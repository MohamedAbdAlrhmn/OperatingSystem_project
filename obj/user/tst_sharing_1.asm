
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
  800031:	e8 03 03 00 00       	call   800339 <libmain>
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
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800075:	a1 20 30 80 00       	mov    0x803020,%eax
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
  80008d:	68 c0 1e 80 00       	push   $0x801ec0
  800092:	6a 12                	push   $0x12
  800094:	68 dc 1e 80 00       	push   $0x801edc
  800099:	e8 d7 03 00 00       	call   800475 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 f4 1e 80 00       	push   $0x801ef4
  8000a6:	e8 7e 06 00 00       	call   800729 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 29 16 00 00       	call   8016dc <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 2b 1f 80 00       	push   $0x801f2b
  8000c5:	e8 5e 14 00 00       	call   801528 <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 30 1f 80 00       	push   $0x801f30
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 dc 1e 80 00       	push   $0x801edc
  8000e8:	e8 88 03 00 00       	call   800475 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 e7 15 00 00       	call   8016dc <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 14                	je     800112 <_main+0xda>
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	68 9c 1f 80 00       	push   $0x801f9c
  800106:	6a 1b                	push   $0x1b
  800108:	68 dc 1e 80 00       	push   $0x801edc
  80010d:	e8 63 03 00 00       	call   800475 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800112:	e8 c5 15 00 00       	call   8016dc <sys_calculate_free_frames>
  800117:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80011a:	83 ec 04             	sub    $0x4,%esp
  80011d:	6a 01                	push   $0x1
  80011f:	68 04 10 00 00       	push   $0x1004
  800124:	68 1a 20 80 00       	push   $0x80201a
  800129:	e8 fa 13 00 00       	call   801528 <smalloc>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800134:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 30 1f 80 00       	push   $0x801f30
  800145:	6a 1f                	push   $0x1f
  800147:	68 dc 1e 80 00       	push   $0x801edc
  80014c:	e8 24 03 00 00       	call   800475 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800151:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800154:	e8 83 15 00 00       	call   8016dc <sys_calculate_free_frames>
  800159:	29 c3                	sub    %eax,%ebx
  80015b:	89 d8                	mov    %ebx,%eax
  80015d:	83 f8 04             	cmp    $0x4,%eax
  800160:	74 14                	je     800176 <_main+0x13e>
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	68 9c 1f 80 00       	push   $0x801f9c
  80016a:	6a 20                	push   $0x20
  80016c:	68 dc 1e 80 00       	push   $0x801edc
  800171:	e8 ff 02 00 00       	call   800475 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800176:	e8 61 15 00 00       	call   8016dc <sys_calculate_free_frames>
  80017b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  80017e:	83 ec 04             	sub    $0x4,%esp
  800181:	6a 01                	push   $0x1
  800183:	6a 04                	push   $0x4
  800185:	68 1c 20 80 00       	push   $0x80201c
  80018a:	e8 99 13 00 00       	call   801528 <smalloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800195:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  80019c:	74 14                	je     8001b2 <_main+0x17a>
  80019e:	83 ec 04             	sub    $0x4,%esp
  8001a1:	68 30 1f 80 00       	push   $0x801f30
  8001a6:	6a 24                	push   $0x24
  8001a8:	68 dc 1e 80 00       	push   $0x801edc
  8001ad:	e8 c3 02 00 00       	call   800475 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001b5:	e8 22 15 00 00       	call   8016dc <sys_calculate_free_frames>
  8001ba:	29 c3                	sub    %eax,%ebx
  8001bc:	89 d8                	mov    %ebx,%eax
  8001be:	83 f8 03             	cmp    $0x3,%eax
  8001c1:	74 14                	je     8001d7 <_main+0x19f>
  8001c3:	83 ec 04             	sub    $0x4,%esp
  8001c6:	68 9c 1f 80 00       	push   $0x801f9c
  8001cb:	6a 25                	push   $0x25
  8001cd:	68 dc 1e 80 00       	push   $0x801edc
  8001d2:	e8 9e 02 00 00       	call   800475 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 20 20 80 00       	push   $0x802020
  8001df:	e8 45 05 00 00       	call   800729 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	68 48 20 80 00       	push   $0x802048
  8001ef:	e8 35 05 00 00       	call   800729 <cprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  8001f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  8001fe:	eb 2d                	jmp    80022d <_main+0x1f5>
		{
			x[i] = -1;
  800200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800203:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020d:	01 d0                	add    %edx,%eax
  80020f:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800215:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800218:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800222:	01 d0                	add    %edx,%eax
  800224:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  80022a:	ff 45 ec             	incl   -0x14(%ebp)
  80022d:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800234:	7e ca                	jle    800200 <_main+0x1c8>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800236:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  80023d:	eb 18                	jmp    800257 <_main+0x21f>
		{
			z[i] = -1;
  80023f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800249:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024c:	01 d0                	add    %edx,%eax
  80024e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800254:	ff 45 ec             	incl   -0x14(%ebp)
  800257:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  80025e:	7e df                	jle    80023f <_main+0x207>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800263:	8b 00                	mov    (%eax),%eax
  800265:	83 f8 ff             	cmp    $0xffffffff,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 70 20 80 00       	push   $0x802070
  800272:	6a 39                	push   $0x39
  800274:	68 dc 1e 80 00       	push   $0x801edc
  800279:	e8 f7 01 00 00       	call   800475 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  80027e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800281:	05 fc 0f 00 00       	add    $0xffc,%eax
  800286:	8b 00                	mov    (%eax),%eax
  800288:	83 f8 ff             	cmp    $0xffffffff,%eax
  80028b:	74 14                	je     8002a1 <_main+0x269>
  80028d:	83 ec 04             	sub    $0x4,%esp
  800290:	68 70 20 80 00       	push   $0x802070
  800295:	6a 3a                	push   $0x3a
  800297:	68 dc 1e 80 00       	push   $0x801edc
  80029c:	e8 d4 01 00 00       	call   800475 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a4:	8b 00                	mov    (%eax),%eax
  8002a6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002a9:	74 14                	je     8002bf <_main+0x287>
  8002ab:	83 ec 04             	sub    $0x4,%esp
  8002ae:	68 70 20 80 00       	push   $0x802070
  8002b3:	6a 3c                	push   $0x3c
  8002b5:	68 dc 1e 80 00       	push   $0x801edc
  8002ba:	e8 b6 01 00 00       	call   800475 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002c2:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002c7:	8b 00                	mov    (%eax),%eax
  8002c9:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cc:	74 14                	je     8002e2 <_main+0x2aa>
  8002ce:	83 ec 04             	sub    $0x4,%esp
  8002d1:	68 70 20 80 00       	push   $0x802070
  8002d6:	6a 3d                	push   $0x3d
  8002d8:	68 dc 1e 80 00       	push   $0x801edc
  8002dd:	e8 93 01 00 00       	call   800475 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	8b 00                	mov    (%eax),%eax
  8002e7:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 70 20 80 00       	push   $0x802070
  8002f4:	6a 3f                	push   $0x3f
  8002f6:	68 dc 1e 80 00       	push   $0x801edc
  8002fb:	e8 75 01 00 00       	call   800475 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800303:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 70 20 80 00       	push   $0x802070
  800317:	6a 40                	push   $0x40
  800319:	68 dc 1e 80 00       	push   $0x801edc
  80031e:	e8 52 01 00 00       	call   800475 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	68 9c 20 80 00       	push   $0x80209c
  80032b:	e8 f9 03 00 00       	call   800729 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp

	return;
  800333:	90                   	nop
}
  800334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80033f:	e8 78 16 00 00       	call   8019bc <sys_getenvindex>
  800344:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800347:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80034a:	89 d0                	mov    %edx,%eax
  80034c:	c1 e0 03             	shl    $0x3,%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	01 c0                	add    %eax,%eax
  800353:	01 d0                	add    %edx,%eax
  800355:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035c:	01 d0                	add    %edx,%eax
  80035e:	c1 e0 04             	shl    $0x4,%eax
  800361:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800366:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80036b:	a1 20 30 80 00       	mov    0x803020,%eax
  800370:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800376:	84 c0                	test   %al,%al
  800378:	74 0f                	je     800389 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80037a:	a1 20 30 80 00       	mov    0x803020,%eax
  80037f:	05 5c 05 00 00       	add    $0x55c,%eax
  800384:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800389:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80038d:	7e 0a                	jle    800399 <libmain+0x60>
		binaryname = argv[0];
  80038f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800392:	8b 00                	mov    (%eax),%eax
  800394:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800399:	83 ec 08             	sub    $0x8,%esp
  80039c:	ff 75 0c             	pushl  0xc(%ebp)
  80039f:	ff 75 08             	pushl  0x8(%ebp)
  8003a2:	e8 91 fc ff ff       	call   800038 <_main>
  8003a7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003aa:	e8 1a 14 00 00       	call   8017c9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003af:	83 ec 0c             	sub    $0xc,%esp
  8003b2:	68 08 21 80 00       	push   $0x802108
  8003b7:	e8 6d 03 00 00       	call   800729 <cprintf>
  8003bc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c4:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cf:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	52                   	push   %edx
  8003d9:	50                   	push   %eax
  8003da:	68 30 21 80 00       	push   $0x802130
  8003df:	e8 45 03 00 00       	call   800729 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ec:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8003f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f7:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8003fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800402:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800408:	51                   	push   %ecx
  800409:	52                   	push   %edx
  80040a:	50                   	push   %eax
  80040b:	68 58 21 80 00       	push   $0x802158
  800410:	e8 14 03 00 00       	call   800729 <cprintf>
  800415:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800418:	a1 20 30 80 00       	mov    0x803020,%eax
  80041d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800423:	83 ec 08             	sub    $0x8,%esp
  800426:	50                   	push   %eax
  800427:	68 b0 21 80 00       	push   $0x8021b0
  80042c:	e8 f8 02 00 00       	call   800729 <cprintf>
  800431:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800434:	83 ec 0c             	sub    $0xc,%esp
  800437:	68 08 21 80 00       	push   $0x802108
  80043c:	e8 e8 02 00 00       	call   800729 <cprintf>
  800441:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800444:	e8 9a 13 00 00       	call   8017e3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800449:	e8 19 00 00 00       	call   800467 <exit>
}
  80044e:	90                   	nop
  80044f:	c9                   	leave  
  800450:	c3                   	ret    

00800451 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800457:	83 ec 0c             	sub    $0xc,%esp
  80045a:	6a 00                	push   $0x0
  80045c:	e8 27 15 00 00       	call   801988 <sys_destroy_env>
  800461:	83 c4 10             	add    $0x10,%esp
}
  800464:	90                   	nop
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <exit>:

void
exit(void)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80046d:	e8 7c 15 00 00       	call   8019ee <sys_exit_env>
}
  800472:	90                   	nop
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80047b:	8d 45 10             	lea    0x10(%ebp),%eax
  80047e:	83 c0 04             	add    $0x4,%eax
  800481:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800484:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800489:	85 c0                	test   %eax,%eax
  80048b:	74 16                	je     8004a3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80048d:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 c4 21 80 00       	push   $0x8021c4
  80049b:	e8 89 02 00 00       	call   800729 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004a3:	a1 00 30 80 00       	mov    0x803000,%eax
  8004a8:	ff 75 0c             	pushl  0xc(%ebp)
  8004ab:	ff 75 08             	pushl  0x8(%ebp)
  8004ae:	50                   	push   %eax
  8004af:	68 c9 21 80 00       	push   $0x8021c9
  8004b4:	e8 70 02 00 00       	call   800729 <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c5:	50                   	push   %eax
  8004c6:	e8 f3 01 00 00       	call   8006be <vcprintf>
  8004cb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	6a 00                	push   $0x0
  8004d3:	68 e5 21 80 00       	push   $0x8021e5
  8004d8:	e8 e1 01 00 00       	call   8006be <vcprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004e0:	e8 82 ff ff ff       	call   800467 <exit>

	// should not return here
	while (1) ;
  8004e5:	eb fe                	jmp    8004e5 <_panic+0x70>

008004e7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f2:	8b 50 74             	mov    0x74(%eax),%edx
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	39 c2                	cmp    %eax,%edx
  8004fa:	74 14                	je     800510 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004fc:	83 ec 04             	sub    $0x4,%esp
  8004ff:	68 e8 21 80 00       	push   $0x8021e8
  800504:	6a 26                	push   $0x26
  800506:	68 34 22 80 00       	push   $0x802234
  80050b:	e8 65 ff ff ff       	call   800475 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800510:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800517:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051e:	e9 c2 00 00 00       	jmp    8005e5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800526:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	85 c0                	test   %eax,%eax
  800536:	75 08                	jne    800540 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800538:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80053b:	e9 a2 00 00 00       	jmp    8005e2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800540:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800547:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80054e:	eb 69                	jmp    8005b9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800550:	a1 20 30 80 00       	mov    0x803020,%eax
  800555:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80055b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80055e:	89 d0                	mov    %edx,%eax
  800560:	01 c0                	add    %eax,%eax
  800562:	01 d0                	add    %edx,%eax
  800564:	c1 e0 03             	shl    $0x3,%eax
  800567:	01 c8                	add    %ecx,%eax
  800569:	8a 40 04             	mov    0x4(%eax),%al
  80056c:	84 c0                	test   %al,%al
  80056e:	75 46                	jne    8005b6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800570:	a1 20 30 80 00       	mov    0x803020,%eax
  800575:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80057b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80057e:	89 d0                	mov    %edx,%eax
  800580:	01 c0                	add    %eax,%eax
  800582:	01 d0                	add    %edx,%eax
  800584:	c1 e0 03             	shl    $0x3,%eax
  800587:	01 c8                	add    %ecx,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80058e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800591:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800596:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	01 c8                	add    %ecx,%eax
  8005a7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a9:	39 c2                	cmp    %eax,%edx
  8005ab:	75 09                	jne    8005b6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005ad:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005b4:	eb 12                	jmp    8005c8 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b6:	ff 45 e8             	incl   -0x18(%ebp)
  8005b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005be:	8b 50 74             	mov    0x74(%eax),%edx
  8005c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c4:	39 c2                	cmp    %eax,%edx
  8005c6:	77 88                	ja     800550 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005cc:	75 14                	jne    8005e2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	68 40 22 80 00       	push   $0x802240
  8005d6:	6a 3a                	push   $0x3a
  8005d8:	68 34 22 80 00       	push   $0x802234
  8005dd:	e8 93 fe ff ff       	call   800475 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005e2:	ff 45 f0             	incl   -0x10(%ebp)
  8005e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005eb:	0f 8c 32 ff ff ff    	jl     800523 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005ff:	eb 26                	jmp    800627 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800601:	a1 20 30 80 00       	mov    0x803020,%eax
  800606:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80060c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	01 c0                	add    %eax,%eax
  800613:	01 d0                	add    %edx,%eax
  800615:	c1 e0 03             	shl    $0x3,%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8a 40 04             	mov    0x4(%eax),%al
  80061d:	3c 01                	cmp    $0x1,%al
  80061f:	75 03                	jne    800624 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800621:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800624:	ff 45 e0             	incl   -0x20(%ebp)
  800627:	a1 20 30 80 00       	mov    0x803020,%eax
  80062c:	8b 50 74             	mov    0x74(%eax),%edx
  80062f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800632:	39 c2                	cmp    %eax,%edx
  800634:	77 cb                	ja     800601 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800639:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80063c:	74 14                	je     800652 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80063e:	83 ec 04             	sub    $0x4,%esp
  800641:	68 94 22 80 00       	push   $0x802294
  800646:	6a 44                	push   $0x44
  800648:	68 34 22 80 00       	push   $0x802234
  80064d:	e8 23 fe ff ff       	call   800475 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800652:	90                   	nop
  800653:	c9                   	leave  
  800654:	c3                   	ret    

00800655 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80065b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	8d 48 01             	lea    0x1(%eax),%ecx
  800663:	8b 55 0c             	mov    0xc(%ebp),%edx
  800666:	89 0a                	mov    %ecx,(%edx)
  800668:	8b 55 08             	mov    0x8(%ebp),%edx
  80066b:	88 d1                	mov    %dl,%cl
  80066d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800670:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800674:	8b 45 0c             	mov    0xc(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	3d ff 00 00 00       	cmp    $0xff,%eax
  80067e:	75 2c                	jne    8006ac <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800680:	a0 24 30 80 00       	mov    0x803024,%al
  800685:	0f b6 c0             	movzbl %al,%eax
  800688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068b:	8b 12                	mov    (%edx),%edx
  80068d:	89 d1                	mov    %edx,%ecx
  80068f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800692:	83 c2 08             	add    $0x8,%edx
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	50                   	push   %eax
  800699:	51                   	push   %ecx
  80069a:	52                   	push   %edx
  80069b:	e8 7b 0f 00 00       	call   80161b <sys_cputs>
  8006a0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006af:	8b 40 04             	mov    0x4(%eax),%eax
  8006b2:	8d 50 01             	lea    0x1(%eax),%edx
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006bb:	90                   	nop
  8006bc:	c9                   	leave  
  8006bd:	c3                   	ret    

008006be <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006ce:	00 00 00 
	b.cnt = 0;
  8006d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006d8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006db:	ff 75 0c             	pushl  0xc(%ebp)
  8006de:	ff 75 08             	pushl  0x8(%ebp)
  8006e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e7:	50                   	push   %eax
  8006e8:	68 55 06 80 00       	push   $0x800655
  8006ed:	e8 11 02 00 00       	call   800903 <vprintfmt>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006f5:	a0 24 30 80 00       	mov    0x803024,%al
  8006fa:	0f b6 c0             	movzbl %al,%eax
  8006fd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800703:	83 ec 04             	sub    $0x4,%esp
  800706:	50                   	push   %eax
  800707:	52                   	push   %edx
  800708:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070e:	83 c0 08             	add    $0x8,%eax
  800711:	50                   	push   %eax
  800712:	e8 04 0f 00 00       	call   80161b <sys_cputs>
  800717:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80071a:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800721:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <cprintf>:

int cprintf(const char *fmt, ...) {
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80072f:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800736:	8d 45 0c             	lea    0xc(%ebp),%eax
  800739:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	ff 75 f4             	pushl  -0xc(%ebp)
  800745:	50                   	push   %eax
  800746:	e8 73 ff ff ff       	call   8006be <vcprintf>
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800751:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800754:	c9                   	leave  
  800755:	c3                   	ret    

00800756 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80075c:	e8 68 10 00 00       	call   8017c9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800761:	8d 45 0c             	lea    0xc(%ebp),%eax
  800764:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 f4             	pushl  -0xc(%ebp)
  800770:	50                   	push   %eax
  800771:	e8 48 ff ff ff       	call   8006be <vcprintf>
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80077c:	e8 62 10 00 00       	call   8017e3 <sys_enable_interrupt>
	return cnt;
  800781:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800784:	c9                   	leave  
  800785:	c3                   	ret    

00800786 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	53                   	push   %ebx
  80078a:	83 ec 14             	sub    $0x14,%esp
  80078d:	8b 45 10             	mov    0x10(%ebp),%eax
  800790:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800799:	8b 45 18             	mov    0x18(%ebp),%eax
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007a4:	77 55                	ja     8007fb <printnum+0x75>
  8007a6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007a9:	72 05                	jb     8007b0 <printnum+0x2a>
  8007ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007ae:	77 4b                	ja     8007fb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007b0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007b3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007be:	52                   	push   %edx
  8007bf:	50                   	push   %eax
  8007c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8007c6:	e8 85 14 00 00       	call   801c50 <__udivdi3>
  8007cb:	83 c4 10             	add    $0x10,%esp
  8007ce:	83 ec 04             	sub    $0x4,%esp
  8007d1:	ff 75 20             	pushl  0x20(%ebp)
  8007d4:	53                   	push   %ebx
  8007d5:	ff 75 18             	pushl  0x18(%ebp)
  8007d8:	52                   	push   %edx
  8007d9:	50                   	push   %eax
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	ff 75 08             	pushl  0x8(%ebp)
  8007e0:	e8 a1 ff ff ff       	call   800786 <printnum>
  8007e5:	83 c4 20             	add    $0x20,%esp
  8007e8:	eb 1a                	jmp    800804 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	ff 75 20             	pushl  0x20(%ebp)
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	ff d0                	call   *%eax
  8007f8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007fb:	ff 4d 1c             	decl   0x1c(%ebp)
  8007fe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800802:	7f e6                	jg     8007ea <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800804:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800807:	bb 00 00 00 00       	mov    $0x0,%ebx
  80080c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800812:	53                   	push   %ebx
  800813:	51                   	push   %ecx
  800814:	52                   	push   %edx
  800815:	50                   	push   %eax
  800816:	e8 45 15 00 00       	call   801d60 <__umoddi3>
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	05 f4 24 80 00       	add    $0x8024f4,%eax
  800823:	8a 00                	mov    (%eax),%al
  800825:	0f be c0             	movsbl %al,%eax
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	50                   	push   %eax
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	ff d0                	call   *%eax
  800834:	83 c4 10             	add    $0x10,%esp
}
  800837:	90                   	nop
  800838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    

0080083d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800840:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800844:	7e 1c                	jle    800862 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	8d 50 08             	lea    0x8(%eax),%edx
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	89 10                	mov    %edx,(%eax)
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	83 e8 08             	sub    $0x8,%eax
  80085b:	8b 50 04             	mov    0x4(%eax),%edx
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	eb 40                	jmp    8008a2 <getuint+0x65>
	else if (lflag)
  800862:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800866:	74 1e                	je     800886 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	ba 00 00 00 00       	mov    $0x0,%edx
  800884:	eb 1c                	jmp    8008a2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	8d 50 04             	lea    0x4(%eax),%edx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	89 10                	mov    %edx,(%eax)
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	83 e8 04             	sub    $0x4,%eax
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008a2:	5d                   	pop    %ebp
  8008a3:	c3                   	ret    

008008a4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ab:	7e 1c                	jle    8008c9 <getint+0x25>
		return va_arg(*ap, long long);
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	8d 50 08             	lea    0x8(%eax),%edx
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	89 10                	mov    %edx,(%eax)
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	83 e8 08             	sub    $0x8,%eax
  8008c2:	8b 50 04             	mov    0x4(%eax),%edx
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	eb 38                	jmp    800901 <getint+0x5d>
	else if (lflag)
  8008c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008cd:	74 1a                	je     8008e9 <getint+0x45>
		return va_arg(*ap, long);
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	8d 50 04             	lea    0x4(%eax),%edx
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	89 10                	mov    %edx,(%eax)
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	83 e8 04             	sub    $0x4,%eax
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	99                   	cltd   
  8008e7:	eb 18                	jmp    800901 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	8d 50 04             	lea    0x4(%eax),%edx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	89 10                	mov    %edx,(%eax)
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	83 e8 04             	sub    $0x4,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	99                   	cltd   
}
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	56                   	push   %esi
  800907:	53                   	push   %ebx
  800908:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80090b:	eb 17                	jmp    800924 <vprintfmt+0x21>
			if (ch == '\0')
  80090d:	85 db                	test   %ebx,%ebx
  80090f:	0f 84 af 03 00 00    	je     800cc4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	53                   	push   %ebx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	ff d0                	call   *%eax
  800921:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800924:	8b 45 10             	mov    0x10(%ebp),%eax
  800927:	8d 50 01             	lea    0x1(%eax),%edx
  80092a:	89 55 10             	mov    %edx,0x10(%ebp)
  80092d:	8a 00                	mov    (%eax),%al
  80092f:	0f b6 d8             	movzbl %al,%ebx
  800932:	83 fb 25             	cmp    $0x25,%ebx
  800935:	75 d6                	jne    80090d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800937:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80093b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800942:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800949:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800950:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800957:	8b 45 10             	mov    0x10(%ebp),%eax
  80095a:	8d 50 01             	lea    0x1(%eax),%edx
  80095d:	89 55 10             	mov    %edx,0x10(%ebp)
  800960:	8a 00                	mov    (%eax),%al
  800962:	0f b6 d8             	movzbl %al,%ebx
  800965:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800968:	83 f8 55             	cmp    $0x55,%eax
  80096b:	0f 87 2b 03 00 00    	ja     800c9c <vprintfmt+0x399>
  800971:	8b 04 85 18 25 80 00 	mov    0x802518(,%eax,4),%eax
  800978:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80097a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80097e:	eb d7                	jmp    800957 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800980:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800984:	eb d1                	jmp    800957 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800986:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80098d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800990:	89 d0                	mov    %edx,%eax
  800992:	c1 e0 02             	shl    $0x2,%eax
  800995:	01 d0                	add    %edx,%eax
  800997:	01 c0                	add    %eax,%eax
  800999:	01 d8                	add    %ebx,%eax
  80099b:	83 e8 30             	sub    $0x30,%eax
  80099e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8a 00                	mov    (%eax),%al
  8009a6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009a9:	83 fb 2f             	cmp    $0x2f,%ebx
  8009ac:	7e 3e                	jle    8009ec <vprintfmt+0xe9>
  8009ae:	83 fb 39             	cmp    $0x39,%ebx
  8009b1:	7f 39                	jg     8009ec <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009b6:	eb d5                	jmp    80098d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	83 c0 04             	add    $0x4,%eax
  8009be:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c4:	83 e8 04             	sub    $0x4,%eax
  8009c7:	8b 00                	mov    (%eax),%eax
  8009c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009cc:	eb 1f                	jmp    8009ed <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d2:	79 83                	jns    800957 <vprintfmt+0x54>
				width = 0;
  8009d4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009db:	e9 77 ff ff ff       	jmp    800957 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009e0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009e7:	e9 6b ff ff ff       	jmp    800957 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009ec:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f1:	0f 89 60 ff ff ff    	jns    800957 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a04:	e9 4e ff ff ff       	jmp    800957 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a09:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a0c:	e9 46 ff ff ff       	jmp    800957 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a11:	8b 45 14             	mov    0x14(%ebp),%eax
  800a14:	83 c0 04             	add    $0x4,%eax
  800a17:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	83 e8 04             	sub    $0x4,%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	50                   	push   %eax
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	ff d0                	call   *%eax
  800a2e:	83 c4 10             	add    $0x10,%esp
			break;
  800a31:	e9 89 02 00 00       	jmp    800cbf <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 c0 04             	add    $0x4,%eax
  800a3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	83 e8 04             	sub    $0x4,%eax
  800a45:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	79 02                	jns    800a4d <vprintfmt+0x14a>
				err = -err;
  800a4b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a4d:	83 fb 64             	cmp    $0x64,%ebx
  800a50:	7f 0b                	jg     800a5d <vprintfmt+0x15a>
  800a52:	8b 34 9d 60 23 80 00 	mov    0x802360(,%ebx,4),%esi
  800a59:	85 f6                	test   %esi,%esi
  800a5b:	75 19                	jne    800a76 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a5d:	53                   	push   %ebx
  800a5e:	68 05 25 80 00       	push   $0x802505
  800a63:	ff 75 0c             	pushl  0xc(%ebp)
  800a66:	ff 75 08             	pushl  0x8(%ebp)
  800a69:	e8 5e 02 00 00       	call   800ccc <printfmt>
  800a6e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a71:	e9 49 02 00 00       	jmp    800cbf <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a76:	56                   	push   %esi
  800a77:	68 0e 25 80 00       	push   $0x80250e
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	ff 75 08             	pushl  0x8(%ebp)
  800a82:	e8 45 02 00 00       	call   800ccc <printfmt>
  800a87:	83 c4 10             	add    $0x10,%esp
			break;
  800a8a:	e9 30 02 00 00       	jmp    800cbf <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	83 c0 04             	add    $0x4,%eax
  800a95:	89 45 14             	mov    %eax,0x14(%ebp)
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	83 e8 04             	sub    $0x4,%eax
  800a9e:	8b 30                	mov    (%eax),%esi
  800aa0:	85 f6                	test   %esi,%esi
  800aa2:	75 05                	jne    800aa9 <vprintfmt+0x1a6>
				p = "(null)";
  800aa4:	be 11 25 80 00       	mov    $0x802511,%esi
			if (width > 0 && padc != '-')
  800aa9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aad:	7e 6d                	jle    800b1c <vprintfmt+0x219>
  800aaf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ab3:	74 67                	je     800b1c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	50                   	push   %eax
  800abc:	56                   	push   %esi
  800abd:	e8 0c 03 00 00       	call   800dce <strnlen>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ac8:	eb 16                	jmp    800ae0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aca:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	50                   	push   %eax
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	ff d0                	call   *%eax
  800ada:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800add:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae4:	7f e4                	jg     800aca <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ae6:	eb 34                	jmp    800b1c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ae8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aec:	74 1c                	je     800b0a <vprintfmt+0x207>
  800aee:	83 fb 1f             	cmp    $0x1f,%ebx
  800af1:	7e 05                	jle    800af8 <vprintfmt+0x1f5>
  800af3:	83 fb 7e             	cmp    $0x7e,%ebx
  800af6:	7e 12                	jle    800b0a <vprintfmt+0x207>
					putch('?', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 3f                	push   $0x3f
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
  800b08:	eb 0f                	jmp    800b19 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	ff 75 0c             	pushl  0xc(%ebp)
  800b10:	53                   	push   %ebx
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b19:	ff 4d e4             	decl   -0x1c(%ebp)
  800b1c:	89 f0                	mov    %esi,%eax
  800b1e:	8d 70 01             	lea    0x1(%eax),%esi
  800b21:	8a 00                	mov    (%eax),%al
  800b23:	0f be d8             	movsbl %al,%ebx
  800b26:	85 db                	test   %ebx,%ebx
  800b28:	74 24                	je     800b4e <vprintfmt+0x24b>
  800b2a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b2e:	78 b8                	js     800ae8 <vprintfmt+0x1e5>
  800b30:	ff 4d e0             	decl   -0x20(%ebp)
  800b33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b37:	79 af                	jns    800ae8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b39:	eb 13                	jmp    800b4e <vprintfmt+0x24b>
				putch(' ', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 20                	push   $0x20
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b52:	7f e7                	jg     800b3b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b54:	e9 66 01 00 00       	jmp    800cbf <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b5f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b62:	50                   	push   %eax
  800b63:	e8 3c fd ff ff       	call   8008a4 <getint>
  800b68:	83 c4 10             	add    $0x10,%esp
  800b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b77:	85 d2                	test   %edx,%edx
  800b79:	79 23                	jns    800b9e <vprintfmt+0x29b>
				putch('-', putdat);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	6a 2d                	push   $0x2d
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	ff d0                	call   *%eax
  800b88:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b91:	f7 d8                	neg    %eax
  800b93:	83 d2 00             	adc    $0x0,%edx
  800b96:	f7 da                	neg    %edx
  800b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b9e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ba5:	e9 bc 00 00 00       	jmp    800c66 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bb3:	50                   	push   %eax
  800bb4:	e8 84 fc ff ff       	call   80083d <getuint>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bc2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc9:	e9 98 00 00 00       	jmp    800c66 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	6a 58                	push   $0x58
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	ff d0                	call   *%eax
  800bdb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	6a 58                	push   $0x58
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	6a 58                	push   $0x58
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	ff d0                	call   *%eax
  800bfb:	83 c4 10             	add    $0x10,%esp
			break;
  800bfe:	e9 bc 00 00 00       	jmp    800cbf <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	6a 30                	push   $0x30
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	ff d0                	call   *%eax
  800c10:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	6a 78                	push   $0x78
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c23:	8b 45 14             	mov    0x14(%ebp),%eax
  800c26:	83 c0 04             	add    $0x4,%eax
  800c29:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2f:	83 e8 04             	sub    $0x4,%eax
  800c32:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c3e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c45:	eb 1f                	jmp    800c66 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c4d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c50:	50                   	push   %eax
  800c51:	e8 e7 fb ff ff       	call   80083d <getuint>
  800c56:	83 c4 10             	add    $0x10,%esp
  800c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c5f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c66:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c6d:	83 ec 04             	sub    $0x4,%esp
  800c70:	52                   	push   %edx
  800c71:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c74:	50                   	push   %eax
  800c75:	ff 75 f4             	pushl  -0xc(%ebp)
  800c78:	ff 75 f0             	pushl  -0x10(%ebp)
  800c7b:	ff 75 0c             	pushl  0xc(%ebp)
  800c7e:	ff 75 08             	pushl  0x8(%ebp)
  800c81:	e8 00 fb ff ff       	call   800786 <printnum>
  800c86:	83 c4 20             	add    $0x20,%esp
			break;
  800c89:	eb 34                	jmp    800cbf <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c8b:	83 ec 08             	sub    $0x8,%esp
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	53                   	push   %ebx
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	ff d0                	call   *%eax
  800c97:	83 c4 10             	add    $0x10,%esp
			break;
  800c9a:	eb 23                	jmp    800cbf <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	6a 25                	push   $0x25
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	ff d0                	call   *%eax
  800ca9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cac:	ff 4d 10             	decl   0x10(%ebp)
  800caf:	eb 03                	jmp    800cb4 <vprintfmt+0x3b1>
  800cb1:	ff 4d 10             	decl   0x10(%ebp)
  800cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb7:	48                   	dec    %eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	3c 25                	cmp    $0x25,%al
  800cbc:	75 f3                	jne    800cb1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cbe:	90                   	nop
		}
	}
  800cbf:	e9 47 fc ff ff       	jmp    80090b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cc4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cd2:	8d 45 10             	lea    0x10(%ebp),%eax
  800cd5:	83 c0 04             	add    $0x4,%eax
  800cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cdb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cde:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce1:	50                   	push   %eax
  800ce2:	ff 75 0c             	pushl  0xc(%ebp)
  800ce5:	ff 75 08             	pushl  0x8(%ebp)
  800ce8:	e8 16 fc ff ff       	call   800903 <vprintfmt>
  800ced:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cf0:	90                   	nop
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	8b 40 08             	mov    0x8(%eax),%eax
  800cfc:	8d 50 01             	lea    0x1(%eax),%edx
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d08:	8b 10                	mov    (%eax),%edx
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 40 04             	mov    0x4(%eax),%eax
  800d10:	39 c2                	cmp    %eax,%edx
  800d12:	73 12                	jae    800d26 <sprintputch+0x33>
		*b->buf++ = ch;
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	8b 00                	mov    (%eax),%eax
  800d19:	8d 48 01             	lea    0x1(%eax),%ecx
  800d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1f:	89 0a                	mov    %ecx,(%edx)
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	88 10                	mov    %dl,(%eax)
}
  800d26:	90                   	nop
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d38:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	01 d0                	add    %edx,%eax
  800d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d4e:	74 06                	je     800d56 <vsnprintf+0x2d>
  800d50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d54:	7f 07                	jg     800d5d <vsnprintf+0x34>
		return -E_INVAL;
  800d56:	b8 03 00 00 00       	mov    $0x3,%eax
  800d5b:	eb 20                	jmp    800d7d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d5d:	ff 75 14             	pushl  0x14(%ebp)
  800d60:	ff 75 10             	pushl  0x10(%ebp)
  800d63:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d66:	50                   	push   %eax
  800d67:	68 f3 0c 80 00       	push   $0x800cf3
  800d6c:	e8 92 fb ff ff       	call   800903 <vprintfmt>
  800d71:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d77:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d85:	8d 45 10             	lea    0x10(%ebp),%eax
  800d88:	83 c0 04             	add    $0x4,%eax
  800d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d91:	ff 75 f4             	pushl  -0xc(%ebp)
  800d94:	50                   	push   %eax
  800d95:	ff 75 0c             	pushl  0xc(%ebp)
  800d98:	ff 75 08             	pushl  0x8(%ebp)
  800d9b:	e8 89 ff ff ff       	call   800d29 <vsnprintf>
  800da0:	83 c4 10             	add    $0x10,%esp
  800da3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800db1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db8:	eb 06                	jmp    800dc0 <strlen+0x15>
		n++;
  800dba:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dbd:	ff 45 08             	incl   0x8(%ebp)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	84 c0                	test   %al,%al
  800dc7:	75 f1                	jne    800dba <strlen+0xf>
		n++;
	return n;
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddb:	eb 09                	jmp    800de6 <strnlen+0x18>
		n++;
  800ddd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de0:	ff 45 08             	incl   0x8(%ebp)
  800de3:	ff 4d 0c             	decl   0xc(%ebp)
  800de6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dea:	74 09                	je     800df5 <strnlen+0x27>
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	84 c0                	test   %al,%al
  800df3:	75 e8                	jne    800ddd <strnlen+0xf>
		n++;
	return n;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e06:	90                   	nop
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8d 50 01             	lea    0x1(%eax),%edx
  800e0d:	89 55 08             	mov    %edx,0x8(%ebp)
  800e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e13:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e16:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e19:	8a 12                	mov    (%edx),%dl
  800e1b:	88 10                	mov    %dl,(%eax)
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 e4                	jne    800e07 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3b:	eb 1f                	jmp    800e5c <strncpy+0x34>
		*dst++ = *src;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8d 50 01             	lea    0x1(%eax),%edx
  800e43:	89 55 08             	mov    %edx,0x8(%ebp)
  800e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e49:	8a 12                	mov    (%edx),%dl
  800e4b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	74 03                	je     800e59 <strncpy+0x31>
			src++;
  800e56:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e59:	ff 45 fc             	incl   -0x4(%ebp)
  800e5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e62:	72 d9                	jb     800e3d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e79:	74 30                	je     800eab <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e7b:	eb 16                	jmp    800e93 <strlcpy+0x2a>
			*dst++ = *src++;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 08             	mov    %edx,0x8(%ebp)
  800e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e93:	ff 4d 10             	decl   0x10(%ebp)
  800e96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9a:	74 09                	je     800ea5 <strlcpy+0x3c>
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	84 c0                	test   %al,%al
  800ea3:	75 d8                	jne    800e7d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb1:	29 c2                	sub    %eax,%edx
  800eb3:	89 d0                	mov    %edx,%eax
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eba:	eb 06                	jmp    800ec2 <strcmp+0xb>
		p++, q++;
  800ebc:	ff 45 08             	incl   0x8(%ebp)
  800ebf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	84 c0                	test   %al,%al
  800ec9:	74 0e                	je     800ed9 <strcmp+0x22>
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 10                	mov    (%eax),%dl
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	38 c2                	cmp    %al,%dl
  800ed7:	74 e3                	je     800ebc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	0f b6 d0             	movzbl %al,%edx
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	0f b6 c0             	movzbl %al,%eax
  800ee9:	29 c2                	sub    %eax,%edx
  800eeb:	89 d0                	mov    %edx,%eax
}
  800eed:	5d                   	pop    %ebp
  800eee:	c3                   	ret    

00800eef <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ef2:	eb 09                	jmp    800efd <strncmp+0xe>
		n--, p++, q++;
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800efd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f01:	74 17                	je     800f1a <strncmp+0x2b>
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	84 c0                	test   %al,%al
  800f0a:	74 0e                	je     800f1a <strncmp+0x2b>
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8a 10                	mov    (%eax),%dl
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	38 c2                	cmp    %al,%dl
  800f18:	74 da                	je     800ef4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	75 07                	jne    800f27 <strncmp+0x38>
		return 0;
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
  800f25:	eb 14                	jmp    800f3b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d0             	movzbl %al,%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	0f b6 c0             	movzbl %al,%eax
  800f37:	29 c2                	sub    %eax,%edx
  800f39:	89 d0                	mov    %edx,%eax
}
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    

00800f3d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	83 ec 04             	sub    $0x4,%esp
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f49:	eb 12                	jmp    800f5d <strchr+0x20>
		if (*s == c)
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f53:	75 05                	jne    800f5a <strchr+0x1d>
			return (char *) s;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	eb 11                	jmp    800f6b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	84 c0                	test   %al,%al
  800f64:	75 e5                	jne    800f4b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    

00800f6d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 04             	sub    $0x4,%esp
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f79:	eb 0d                	jmp    800f88 <strfind+0x1b>
		if (*s == c)
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f83:	74 0e                	je     800f93 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f85:	ff 45 08             	incl   0x8(%ebp)
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	84 c0                	test   %al,%al
  800f8f:	75 ea                	jne    800f7b <strfind+0xe>
  800f91:	eb 01                	jmp    800f94 <strfind+0x27>
		if (*s == c)
			break;
  800f93:	90                   	nop
	return (char *) s;
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f97:	c9                   	leave  
  800f98:	c3                   	ret    

00800f99 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fab:	eb 0e                	jmp    800fbb <memset+0x22>
		*p++ = c;
  800fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb0:	8d 50 01             	lea    0x1(%eax),%edx
  800fb3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fbb:	ff 4d f8             	decl   -0x8(%ebp)
  800fbe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fc2:	79 e9                	jns    800fad <memset+0x14>
		*p++ = c;

	return v;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc7:	c9                   	leave  
  800fc8:	c3                   	ret    

00800fc9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fdb:	eb 16                	jmp    800ff3 <memcpy+0x2a>
		*d++ = *s++;
  800fdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fec:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fef:	8a 12                	mov    (%edx),%dl
  800ff1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	75 dd                	jne    800fdd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801017:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80101d:	73 50                	jae    80106f <memmove+0x6a>
  80101f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	01 d0                	add    %edx,%eax
  801027:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80102a:	76 43                	jbe    80106f <memmove+0x6a>
		s += n;
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801032:	8b 45 10             	mov    0x10(%ebp),%eax
  801035:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801038:	eb 10                	jmp    80104a <memmove+0x45>
			*--d = *--s;
  80103a:	ff 4d f8             	decl   -0x8(%ebp)
  80103d:	ff 4d fc             	decl   -0x4(%ebp)
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801043:	8a 10                	mov    (%eax),%dl
  801045:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801048:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801050:	89 55 10             	mov    %edx,0x10(%ebp)
  801053:	85 c0                	test   %eax,%eax
  801055:	75 e3                	jne    80103a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801057:	eb 23                	jmp    80107c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	8d 50 01             	lea    0x1(%eax),%edx
  80105f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801062:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801065:	8d 4a 01             	lea    0x1(%edx),%ecx
  801068:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106b:	8a 12                	mov    (%edx),%dl
  80106d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80106f:	8b 45 10             	mov    0x10(%ebp),%eax
  801072:	8d 50 ff             	lea    -0x1(%eax),%edx
  801075:	89 55 10             	mov    %edx,0x10(%ebp)
  801078:	85 c0                	test   %eax,%eax
  80107a:	75 dd                	jne    801059 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801093:	eb 2a                	jmp    8010bf <memcmp+0x3e>
		if (*s1 != *s2)
  801095:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801098:	8a 10                	mov    (%eax),%dl
  80109a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	38 c2                	cmp    %al,%dl
  8010a1:	74 16                	je     8010b9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	0f b6 d0             	movzbl %al,%edx
  8010ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	0f b6 c0             	movzbl %al,%eax
  8010b3:	29 c2                	sub    %eax,%edx
  8010b5:	89 d0                	mov    %edx,%eax
  8010b7:	eb 18                	jmp    8010d1 <memcmp+0x50>
		s1++, s2++;
  8010b9:	ff 45 fc             	incl   -0x4(%ebp)
  8010bc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	75 c9                	jne    801095 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	01 d0                	add    %edx,%eax
  8010e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010e4:	eb 15                	jmp    8010fb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	0f b6 d0             	movzbl %al,%edx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	0f b6 c0             	movzbl %al,%eax
  8010f4:	39 c2                	cmp    %eax,%edx
  8010f6:	74 0d                	je     801105 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010f8:	ff 45 08             	incl   0x8(%ebp)
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801101:	72 e3                	jb     8010e6 <memfind+0x13>
  801103:	eb 01                	jmp    801106 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801105:	90                   	nop
	return (void *) s;
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801118:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80111f:	eb 03                	jmp    801124 <strtol+0x19>
		s++;
  801121:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	3c 20                	cmp    $0x20,%al
  80112b:	74 f4                	je     801121 <strtol+0x16>
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	3c 09                	cmp    $0x9,%al
  801134:	74 eb                	je     801121 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	3c 2b                	cmp    $0x2b,%al
  80113d:	75 05                	jne    801144 <strtol+0x39>
		s++;
  80113f:	ff 45 08             	incl   0x8(%ebp)
  801142:	eb 13                	jmp    801157 <strtol+0x4c>
	else if (*s == '-')
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	3c 2d                	cmp    $0x2d,%al
  80114b:	75 0a                	jne    801157 <strtol+0x4c>
		s++, neg = 1;
  80114d:	ff 45 08             	incl   0x8(%ebp)
  801150:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 06                	je     801163 <strtol+0x58>
  80115d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801161:	75 20                	jne    801183 <strtol+0x78>
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	3c 30                	cmp    $0x30,%al
  80116a:	75 17                	jne    801183 <strtol+0x78>
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	40                   	inc    %eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	3c 78                	cmp    $0x78,%al
  801174:	75 0d                	jne    801183 <strtol+0x78>
		s += 2, base = 16;
  801176:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80117a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801181:	eb 28                	jmp    8011ab <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801183:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801187:	75 15                	jne    80119e <strtol+0x93>
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3c 30                	cmp    $0x30,%al
  801190:	75 0c                	jne    80119e <strtol+0x93>
		s++, base = 8;
  801192:	ff 45 08             	incl   0x8(%ebp)
  801195:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80119c:	eb 0d                	jmp    8011ab <strtol+0xa0>
	else if (base == 0)
  80119e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a2:	75 07                	jne    8011ab <strtol+0xa0>
		base = 10;
  8011a4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	3c 2f                	cmp    $0x2f,%al
  8011b2:	7e 19                	jle    8011cd <strtol+0xc2>
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	3c 39                	cmp    $0x39,%al
  8011bb:	7f 10                	jg     8011cd <strtol+0xc2>
			dig = *s - '0';
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f be c0             	movsbl %al,%eax
  8011c5:	83 e8 30             	sub    $0x30,%eax
  8011c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011cb:	eb 42                	jmp    80120f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	3c 60                	cmp    $0x60,%al
  8011d4:	7e 19                	jle    8011ef <strtol+0xe4>
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	3c 7a                	cmp    $0x7a,%al
  8011dd:	7f 10                	jg     8011ef <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	0f be c0             	movsbl %al,%eax
  8011e7:	83 e8 57             	sub    $0x57,%eax
  8011ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ed:	eb 20                	jmp    80120f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	3c 40                	cmp    $0x40,%al
  8011f6:	7e 39                	jle    801231 <strtol+0x126>
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	3c 5a                	cmp    $0x5a,%al
  8011ff:	7f 30                	jg     801231 <strtol+0x126>
			dig = *s - 'A' + 10;
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	8a 00                	mov    (%eax),%al
  801206:	0f be c0             	movsbl %al,%eax
  801209:	83 e8 37             	sub    $0x37,%eax
  80120c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80120f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801212:	3b 45 10             	cmp    0x10(%ebp),%eax
  801215:	7d 19                	jge    801230 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801217:	ff 45 08             	incl   0x8(%ebp)
  80121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801221:	89 c2                	mov    %eax,%edx
  801223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801226:	01 d0                	add    %edx,%eax
  801228:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80122b:	e9 7b ff ff ff       	jmp    8011ab <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801230:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801231:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801235:	74 08                	je     80123f <strtol+0x134>
		*endptr = (char *) s;
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 55 08             	mov    0x8(%ebp),%edx
  80123d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80123f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801243:	74 07                	je     80124c <strtol+0x141>
  801245:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801248:	f7 d8                	neg    %eax
  80124a:	eb 03                	jmp    80124f <strtol+0x144>
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <ltostr>:

void
ltostr(long value, char *str)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801257:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80125e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801265:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801269:	79 13                	jns    80127e <ltostr+0x2d>
	{
		neg = 1;
  80126b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801278:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80127b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801286:	99                   	cltd   
  801287:	f7 f9                	idiv   %ecx
  801289:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80128c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128f:	8d 50 01             	lea    0x1(%eax),%edx
  801292:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801295:	89 c2                	mov    %eax,%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80129f:	83 c2 30             	add    $0x30,%edx
  8012a2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012ac:	f7 e9                	imul   %ecx
  8012ae:	c1 fa 02             	sar    $0x2,%edx
  8012b1:	89 c8                	mov    %ecx,%eax
  8012b3:	c1 f8 1f             	sar    $0x1f,%eax
  8012b6:	29 c2                	sub    %eax,%edx
  8012b8:	89 d0                	mov    %edx,%eax
  8012ba:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c5:	f7 e9                	imul   %ecx
  8012c7:	c1 fa 02             	sar    $0x2,%edx
  8012ca:	89 c8                	mov    %ecx,%eax
  8012cc:	c1 f8 1f             	sar    $0x1f,%eax
  8012cf:	29 c2                	sub    %eax,%edx
  8012d1:	89 d0                	mov    %edx,%eax
  8012d3:	c1 e0 02             	shl    $0x2,%eax
  8012d6:	01 d0                	add    %edx,%eax
  8012d8:	01 c0                	add    %eax,%eax
  8012da:	29 c1                	sub    %eax,%ecx
  8012dc:	89 ca                	mov    %ecx,%edx
  8012de:	85 d2                	test   %edx,%edx
  8012e0:	75 9c                	jne    80127e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	48                   	dec    %eax
  8012ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012f4:	74 3d                	je     801333 <ltostr+0xe2>
		start = 1 ;
  8012f6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012fd:	eb 34                	jmp    801333 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8012ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801302:	8b 45 0c             	mov    0xc(%ebp),%eax
  801305:	01 d0                	add    %edx,%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80130c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801312:	01 c2                	add    %eax,%edx
  801314:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	01 c8                	add    %ecx,%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801320:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 c2                	add    %eax,%edx
  801328:	8a 45 eb             	mov    -0x15(%ebp),%al
  80132b:	88 02                	mov    %al,(%edx)
		start++ ;
  80132d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801330:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801339:	7c c4                	jl     8012ff <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80133b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	01 d0                	add    %edx,%eax
  801343:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801346:	90                   	nop
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80134f:	ff 75 08             	pushl  0x8(%ebp)
  801352:	e8 54 fa ff ff       	call   800dab <strlen>
  801357:	83 c4 04             	add    $0x4,%esp
  80135a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80135d:	ff 75 0c             	pushl  0xc(%ebp)
  801360:	e8 46 fa ff ff       	call   800dab <strlen>
  801365:	83 c4 04             	add    $0x4,%esp
  801368:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801372:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801379:	eb 17                	jmp    801392 <strcconcat+0x49>
		final[s] = str1[s] ;
  80137b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 c2                	add    %eax,%edx
  801383:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	01 c8                	add    %ecx,%eax
  80138b:	8a 00                	mov    (%eax),%al
  80138d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
  801392:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801395:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801398:	7c e1                	jl     80137b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80139a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013a8:	eb 1f                	jmp    8013c9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ad:	8d 50 01             	lea    0x1(%eax),%edx
  8013b0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013b3:	89 c2                	mov    %eax,%edx
  8013b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b8:	01 c2                	add    %eax,%edx
  8013ba:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c0:	01 c8                	add    %ecx,%eax
  8013c2:	8a 00                	mov    (%eax),%al
  8013c4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013c6:	ff 45 f8             	incl   -0x8(%ebp)
  8013c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013cf:	7c d9                	jl     8013aa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d7:	01 d0                	add    %edx,%eax
  8013d9:	c6 00 00             	movb   $0x0,(%eax)
}
  8013dc:	90                   	nop
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ee:	8b 00                	mov    (%eax),%eax
  8013f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fa:	01 d0                	add    %edx,%eax
  8013fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801402:	eb 0c                	jmp    801410 <strsplit+0x31>
			*string++ = 0;
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	8d 50 01             	lea    0x1(%eax),%edx
  80140a:	89 55 08             	mov    %edx,0x8(%ebp)
  80140d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	8a 00                	mov    (%eax),%al
  801415:	84 c0                	test   %al,%al
  801417:	74 18                	je     801431 <strsplit+0x52>
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	0f be c0             	movsbl %al,%eax
  801421:	50                   	push   %eax
  801422:	ff 75 0c             	pushl  0xc(%ebp)
  801425:	e8 13 fb ff ff       	call   800f3d <strchr>
  80142a:	83 c4 08             	add    $0x8,%esp
  80142d:	85 c0                	test   %eax,%eax
  80142f:	75 d3                	jne    801404 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	84 c0                	test   %al,%al
  801438:	74 5a                	je     801494 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80143a:	8b 45 14             	mov    0x14(%ebp),%eax
  80143d:	8b 00                	mov    (%eax),%eax
  80143f:	83 f8 0f             	cmp    $0xf,%eax
  801442:	75 07                	jne    80144b <strsplit+0x6c>
		{
			return 0;
  801444:	b8 00 00 00 00       	mov    $0x0,%eax
  801449:	eb 66                	jmp    8014b1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80144b:	8b 45 14             	mov    0x14(%ebp),%eax
  80144e:	8b 00                	mov    (%eax),%eax
  801450:	8d 48 01             	lea    0x1(%eax),%ecx
  801453:	8b 55 14             	mov    0x14(%ebp),%edx
  801456:	89 0a                	mov    %ecx,(%edx)
  801458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80145f:	8b 45 10             	mov    0x10(%ebp),%eax
  801462:	01 c2                	add    %eax,%edx
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801469:	eb 03                	jmp    80146e <strsplit+0x8f>
			string++;
  80146b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	74 8b                	je     801402 <strsplit+0x23>
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	0f be c0             	movsbl %al,%eax
  80147f:	50                   	push   %eax
  801480:	ff 75 0c             	pushl  0xc(%ebp)
  801483:	e8 b5 fa ff ff       	call   800f3d <strchr>
  801488:	83 c4 08             	add    $0x8,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	74 dc                	je     80146b <strsplit+0x8c>
			string++;
	}
  80148f:	e9 6e ff ff ff       	jmp    801402 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801494:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801495:	8b 45 14             	mov    0x14(%ebp),%eax
  801498:	8b 00                	mov    (%eax),%eax
  80149a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a4:	01 d0                	add    %edx,%eax
  8014a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014ac:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	68 70 26 80 00       	push   $0x802670
  8014c1:	6a 0e                	push   $0xe
  8014c3:	68 aa 26 80 00       	push   $0x8026aa
  8014c8:	e8 a8 ef ff ff       	call   800475 <_panic>

008014cd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8014d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	74 0f                	je     8014eb <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8014dc:	e8 d2 ff ff ff       	call   8014b3 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014e1:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8014e8:	00 00 00 
	}
	if (size == 0) return NULL ;
  8014eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ef:	75 07                	jne    8014f8 <malloc+0x2b>
  8014f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f6:	eb 14                	jmp    80150c <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	68 b8 26 80 00       	push   $0x8026b8
  801500:	6a 2e                	push   $0x2e
  801502:	68 aa 26 80 00       	push   $0x8026aa
  801507:	e8 69 ef ff ff       	call   800475 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	68 e0 26 80 00       	push   $0x8026e0
  80151c:	6a 49                	push   $0x49
  80151e:	68 aa 26 80 00       	push   $0x8026aa
  801523:	e8 4d ef ff ff       	call   800475 <_panic>

00801528 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 18             	sub    $0x18,%esp
  80152e:	8b 45 10             	mov    0x10(%ebp),%eax
  801531:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801534:	83 ec 04             	sub    $0x4,%esp
  801537:	68 04 27 80 00       	push   $0x802704
  80153c:	6a 57                	push   $0x57
  80153e:	68 aa 26 80 00       	push   $0x8026aa
  801543:	e8 2d ef ff ff       	call   800475 <_panic>

00801548 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	68 2c 27 80 00       	push   $0x80272c
  801556:	6a 60                	push   $0x60
  801558:	68 aa 26 80 00       	push   $0x8026aa
  80155d:	e8 13 ef ff ff       	call   800475 <_panic>

00801562 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801568:	83 ec 04             	sub    $0x4,%esp
  80156b:	68 50 27 80 00       	push   $0x802750
  801570:	6a 7c                	push   $0x7c
  801572:	68 aa 26 80 00       	push   $0x8026aa
  801577:	e8 f9 ee ff ff       	call   800475 <_panic>

0080157c <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 78 27 80 00       	push   $0x802778
  80158a:	68 86 00 00 00       	push   $0x86
  80158f:	68 aa 26 80 00       	push   $0x8026aa
  801594:	e8 dc ee ff ff       	call   800475 <_panic>

00801599 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80159f:	83 ec 04             	sub    $0x4,%esp
  8015a2:	68 9c 27 80 00       	push   $0x80279c
  8015a7:	68 91 00 00 00       	push   $0x91
  8015ac:	68 aa 26 80 00       	push   $0x8026aa
  8015b1:	e8 bf ee ff ff       	call   800475 <_panic>

008015b6 <shrink>:

}
void shrink(uint32 newSize)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	68 9c 27 80 00       	push   $0x80279c
  8015c4:	68 96 00 00 00       	push   $0x96
  8015c9:	68 aa 26 80 00       	push   $0x8026aa
  8015ce:	e8 a2 ee ff ff       	call   800475 <_panic>

008015d3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	68 9c 27 80 00       	push   $0x80279c
  8015e1:	68 9b 00 00 00       	push   $0x9b
  8015e6:	68 aa 26 80 00       	push   $0x8026aa
  8015eb:	e8 85 ee ff ff       	call   800475 <_panic>

008015f0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	57                   	push   %edi
  8015f4:	56                   	push   %esi
  8015f5:	53                   	push   %ebx
  8015f6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801602:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801605:	8b 7d 18             	mov    0x18(%ebp),%edi
  801608:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80160b:	cd 30                	int    $0x30
  80160d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801610:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	5b                   	pop    %ebx
  801617:	5e                   	pop    %esi
  801618:	5f                   	pop    %edi
  801619:	5d                   	pop    %ebp
  80161a:	c3                   	ret    

0080161b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801627:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	52                   	push   %edx
  801633:	ff 75 0c             	pushl  0xc(%ebp)
  801636:	50                   	push   %eax
  801637:	6a 00                	push   $0x0
  801639:	e8 b2 ff ff ff       	call   8015f0 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	90                   	nop
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_cgetc>:

int
sys_cgetc(void)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 01                	push   $0x1
  801653:	e8 98 ff ff ff       	call   8015f0 <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	52                   	push   %edx
  80166d:	50                   	push   %eax
  80166e:	6a 05                	push   $0x5
  801670:	e8 7b ff ff ff       	call   8015f0 <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	56                   	push   %esi
  80167e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80167f:	8b 75 18             	mov    0x18(%ebp),%esi
  801682:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801685:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	56                   	push   %esi
  80168f:	53                   	push   %ebx
  801690:	51                   	push   %ecx
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	6a 06                	push   $0x6
  801695:	e8 56 ff ff ff       	call   8015f0 <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a0:	5b                   	pop    %ebx
  8016a1:	5e                   	pop    %esi
  8016a2:	5d                   	pop    %ebp
  8016a3:	c3                   	ret    

008016a4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	52                   	push   %edx
  8016b4:	50                   	push   %eax
  8016b5:	6a 07                	push   $0x7
  8016b7:	e8 34 ff ff ff       	call   8015f0 <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	ff 75 0c             	pushl  0xc(%ebp)
  8016cd:	ff 75 08             	pushl  0x8(%ebp)
  8016d0:	6a 08                	push   $0x8
  8016d2:	e8 19 ff ff ff       	call   8015f0 <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 09                	push   $0x9
  8016eb:	e8 00 ff ff ff       	call   8015f0 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 0a                	push   $0xa
  801704:	e8 e7 fe ff ff       	call   8015f0 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 0b                	push   $0xb
  80171d:	e8 ce fe ff ff       	call   8015f0 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	6a 0f                	push   $0xf
  801738:	e8 b3 fe ff ff       	call   8015f0 <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
	return;
  801740:	90                   	nop
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	ff 75 0c             	pushl  0xc(%ebp)
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	6a 10                	push   $0x10
  801754:	e8 97 fe ff ff       	call   8015f0 <syscall>
  801759:	83 c4 18             	add    $0x18,%esp
	return ;
  80175c:	90                   	nop
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	ff 75 10             	pushl  0x10(%ebp)
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	6a 11                	push   $0x11
  801771:	e8 7a fe ff ff       	call   8015f0 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
	return ;
  801779:	90                   	nop
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 0c                	push   $0xc
  80178b:	e8 60 fe ff ff       	call   8015f0 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	6a 0d                	push   $0xd
  8017a5:	e8 46 fe ff ff       	call   8015f0 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 0e                	push   $0xe
  8017be:	e8 2d fe ff ff       	call   8015f0 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	90                   	nop
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 13                	push   $0x13
  8017d8:	e8 13 fe ff ff       	call   8015f0 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	90                   	nop
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 14                	push   $0x14
  8017f2:	e8 f9 fd ff ff       	call   8015f0 <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	90                   	nop
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_cputc>:


void
sys_cputc(const char c)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801809:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	50                   	push   %eax
  801816:	6a 15                	push   $0x15
  801818:	e8 d3 fd ff ff       	call   8015f0 <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	90                   	nop
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 16                	push   $0x16
  801832:	e8 b9 fd ff ff       	call   8015f0 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	90                   	nop
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	50                   	push   %eax
  80184d:	6a 17                	push   $0x17
  80184f:	e8 9c fd ff ff       	call   8015f0 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80185c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	6a 1a                	push   $0x1a
  80186c:	e8 7f fd ff ff       	call   8015f0 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801879:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	52                   	push   %edx
  801886:	50                   	push   %eax
  801887:	6a 18                	push   $0x18
  801889:	e8 62 fd ff ff       	call   8015f0 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	90                   	nop
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	52                   	push   %edx
  8018a4:	50                   	push   %eax
  8018a5:	6a 19                	push   $0x19
  8018a7:	e8 44 fd ff ff       	call   8015f0 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	90                   	nop
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018be:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018c1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	51                   	push   %ecx
  8018cb:	52                   	push   %edx
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	50                   	push   %eax
  8018d0:	6a 1b                	push   $0x1b
  8018d2:	e8 19 fd ff ff       	call   8015f0 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	52                   	push   %edx
  8018ec:	50                   	push   %eax
  8018ed:	6a 1c                	push   $0x1c
  8018ef:	e8 fc fc ff ff       	call   8015f0 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	51                   	push   %ecx
  80190a:	52                   	push   %edx
  80190b:	50                   	push   %eax
  80190c:	6a 1d                	push   $0x1d
  80190e:	e8 dd fc ff ff       	call   8015f0 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80191b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	52                   	push   %edx
  801928:	50                   	push   %eax
  801929:	6a 1e                	push   $0x1e
  80192b:	e8 c0 fc ff ff       	call   8015f0 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 1f                	push   $0x1f
  801944:	e8 a7 fc ff ff       	call   8015f0 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	6a 00                	push   $0x0
  801956:	ff 75 14             	pushl  0x14(%ebp)
  801959:	ff 75 10             	pushl  0x10(%ebp)
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	50                   	push   %eax
  801960:	6a 20                	push   $0x20
  801962:	e8 89 fc ff ff       	call   8015f0 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	50                   	push   %eax
  80197b:	6a 21                	push   $0x21
  80197d:	e8 6e fc ff ff       	call   8015f0 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	90                   	nop
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	50                   	push   %eax
  801997:	6a 22                	push   $0x22
  801999:	e8 52 fc ff ff       	call   8015f0 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 02                	push   $0x2
  8019b2:	e8 39 fc ff ff       	call   8015f0 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 03                	push   $0x3
  8019cb:	e8 20 fc ff ff       	call   8015f0 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 04                	push   $0x4
  8019e4:	e8 07 fc ff ff       	call   8015f0 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_exit_env>:


void sys_exit_env(void)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 23                	push   $0x23
  8019fd:	e8 ee fb ff ff       	call   8015f0 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	90                   	nop
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a0e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a11:	8d 50 04             	lea    0x4(%eax),%edx
  801a14:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	52                   	push   %edx
  801a1e:	50                   	push   %eax
  801a1f:	6a 24                	push   $0x24
  801a21:	e8 ca fb ff ff       	call   8015f0 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return result;
  801a29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a32:	89 01                	mov    %eax,(%ecx)
  801a34:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	c9                   	leave  
  801a3b:	c2 04 00             	ret    $0x4

00801a3e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	ff 75 10             	pushl  0x10(%ebp)
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	ff 75 08             	pushl  0x8(%ebp)
  801a4e:	6a 12                	push   $0x12
  801a50:	e8 9b fb ff ff       	call   8015f0 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
	return ;
  801a58:	90                   	nop
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_rcr2>:
uint32 sys_rcr2()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 25                	push   $0x25
  801a6a:	e8 81 fb ff ff       	call   8015f0 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 04             	sub    $0x4,%esp
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a80:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	50                   	push   %eax
  801a8d:	6a 26                	push   $0x26
  801a8f:	e8 5c fb ff ff       	call   8015f0 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
	return ;
  801a97:	90                   	nop
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <rsttst>:
void rsttst()
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 28                	push   $0x28
  801aa9:	e8 42 fb ff ff       	call   8015f0 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab1:	90                   	nop
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 04             	sub    $0x4,%esp
  801aba:	8b 45 14             	mov    0x14(%ebp),%eax
  801abd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ac0:	8b 55 18             	mov    0x18(%ebp),%edx
  801ac3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	ff 75 10             	pushl  0x10(%ebp)
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	ff 75 08             	pushl  0x8(%ebp)
  801ad2:	6a 27                	push   $0x27
  801ad4:	e8 17 fb ff ff       	call   8015f0 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
	return ;
  801adc:	90                   	nop
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <chktst>:
void chktst(uint32 n)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	6a 29                	push   $0x29
  801aef:	e8 fc fa ff ff       	call   8015f0 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
	return ;
  801af7:	90                   	nop
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <inctst>:

void inctst()
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 2a                	push   $0x2a
  801b09:	e8 e2 fa ff ff       	call   8015f0 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b11:	90                   	nop
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <gettst>:
uint32 gettst()
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 2b                	push   $0x2b
  801b23:	e8 c8 fa ff ff       	call   8015f0 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 2c                	push   $0x2c
  801b3f:	e8 ac fa ff ff       	call   8015f0 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
  801b47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b4a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b4e:	75 07                	jne    801b57 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b50:	b8 01 00 00 00       	mov    $0x1,%eax
  801b55:	eb 05                	jmp    801b5c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 2c                	push   $0x2c
  801b70:	e8 7b fa ff ff       	call   8015f0 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
  801b78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b7b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b7f:	75 07                	jne    801b88 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b81:	b8 01 00 00 00       	mov    $0x1,%eax
  801b86:	eb 05                	jmp    801b8d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 2c                	push   $0x2c
  801ba1:	e8 4a fa ff ff       	call   8015f0 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
  801ba9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bac:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bb0:	75 07                	jne    801bb9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb7:	eb 05                	jmp    801bbe <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 2c                	push   $0x2c
  801bd2:	e8 19 fa ff ff       	call   8015f0 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
  801bda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bdd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801be1:	75 07                	jne    801bea <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801be3:	b8 01 00 00 00       	mov    $0x1,%eax
  801be8:	eb 05                	jmp    801bef <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 2d                	push   $0x2d
  801c01:	e8 ea f9 ff ff       	call   8015f0 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c10:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c13:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	53                   	push   %ebx
  801c1f:	51                   	push   %ecx
  801c20:	52                   	push   %edx
  801c21:	50                   	push   %eax
  801c22:	6a 2e                	push   $0x2e
  801c24:	e8 c7 f9 ff ff       	call   8015f0 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	52                   	push   %edx
  801c41:	50                   	push   %eax
  801c42:	6a 2f                	push   $0x2f
  801c44:	e8 a7 f9 ff ff       	call   8015f0 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    
  801c4e:	66 90                	xchg   %ax,%ax

00801c50 <__udivdi3>:
  801c50:	55                   	push   %ebp
  801c51:	57                   	push   %edi
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	83 ec 1c             	sub    $0x1c,%esp
  801c57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c67:	89 ca                	mov    %ecx,%edx
  801c69:	89 f8                	mov    %edi,%eax
  801c6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c6f:	85 f6                	test   %esi,%esi
  801c71:	75 2d                	jne    801ca0 <__udivdi3+0x50>
  801c73:	39 cf                	cmp    %ecx,%edi
  801c75:	77 65                	ja     801cdc <__udivdi3+0x8c>
  801c77:	89 fd                	mov    %edi,%ebp
  801c79:	85 ff                	test   %edi,%edi
  801c7b:	75 0b                	jne    801c88 <__udivdi3+0x38>
  801c7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c82:	31 d2                	xor    %edx,%edx
  801c84:	f7 f7                	div    %edi
  801c86:	89 c5                	mov    %eax,%ebp
  801c88:	31 d2                	xor    %edx,%edx
  801c8a:	89 c8                	mov    %ecx,%eax
  801c8c:	f7 f5                	div    %ebp
  801c8e:	89 c1                	mov    %eax,%ecx
  801c90:	89 d8                	mov    %ebx,%eax
  801c92:	f7 f5                	div    %ebp
  801c94:	89 cf                	mov    %ecx,%edi
  801c96:	89 fa                	mov    %edi,%edx
  801c98:	83 c4 1c             	add    $0x1c,%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5f                   	pop    %edi
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    
  801ca0:	39 ce                	cmp    %ecx,%esi
  801ca2:	77 28                	ja     801ccc <__udivdi3+0x7c>
  801ca4:	0f bd fe             	bsr    %esi,%edi
  801ca7:	83 f7 1f             	xor    $0x1f,%edi
  801caa:	75 40                	jne    801cec <__udivdi3+0x9c>
  801cac:	39 ce                	cmp    %ecx,%esi
  801cae:	72 0a                	jb     801cba <__udivdi3+0x6a>
  801cb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cb4:	0f 87 9e 00 00 00    	ja     801d58 <__udivdi3+0x108>
  801cba:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbf:	89 fa                	mov    %edi,%edx
  801cc1:	83 c4 1c             	add    $0x1c,%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5f                   	pop    %edi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    
  801cc9:	8d 76 00             	lea    0x0(%esi),%esi
  801ccc:	31 ff                	xor    %edi,%edi
  801cce:	31 c0                	xor    %eax,%eax
  801cd0:	89 fa                	mov    %edi,%edx
  801cd2:	83 c4 1c             	add    $0x1c,%esp
  801cd5:	5b                   	pop    %ebx
  801cd6:	5e                   	pop    %esi
  801cd7:	5f                   	pop    %edi
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    
  801cda:	66 90                	xchg   %ax,%ax
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	f7 f7                	div    %edi
  801ce0:	31 ff                	xor    %edi,%edi
  801ce2:	89 fa                	mov    %edi,%edx
  801ce4:	83 c4 1c             	add    $0x1c,%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5f                   	pop    %edi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    
  801cec:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cf1:	89 eb                	mov    %ebp,%ebx
  801cf3:	29 fb                	sub    %edi,%ebx
  801cf5:	89 f9                	mov    %edi,%ecx
  801cf7:	d3 e6                	shl    %cl,%esi
  801cf9:	89 c5                	mov    %eax,%ebp
  801cfb:	88 d9                	mov    %bl,%cl
  801cfd:	d3 ed                	shr    %cl,%ebp
  801cff:	89 e9                	mov    %ebp,%ecx
  801d01:	09 f1                	or     %esi,%ecx
  801d03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d07:	89 f9                	mov    %edi,%ecx
  801d09:	d3 e0                	shl    %cl,%eax
  801d0b:	89 c5                	mov    %eax,%ebp
  801d0d:	89 d6                	mov    %edx,%esi
  801d0f:	88 d9                	mov    %bl,%cl
  801d11:	d3 ee                	shr    %cl,%esi
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	d3 e2                	shl    %cl,%edx
  801d17:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1b:	88 d9                	mov    %bl,%cl
  801d1d:	d3 e8                	shr    %cl,%eax
  801d1f:	09 c2                	or     %eax,%edx
  801d21:	89 d0                	mov    %edx,%eax
  801d23:	89 f2                	mov    %esi,%edx
  801d25:	f7 74 24 0c          	divl   0xc(%esp)
  801d29:	89 d6                	mov    %edx,%esi
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	f7 e5                	mul    %ebp
  801d2f:	39 d6                	cmp    %edx,%esi
  801d31:	72 19                	jb     801d4c <__udivdi3+0xfc>
  801d33:	74 0b                	je     801d40 <__udivdi3+0xf0>
  801d35:	89 d8                	mov    %ebx,%eax
  801d37:	31 ff                	xor    %edi,%edi
  801d39:	e9 58 ff ff ff       	jmp    801c96 <__udivdi3+0x46>
  801d3e:	66 90                	xchg   %ax,%ax
  801d40:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d44:	89 f9                	mov    %edi,%ecx
  801d46:	d3 e2                	shl    %cl,%edx
  801d48:	39 c2                	cmp    %eax,%edx
  801d4a:	73 e9                	jae    801d35 <__udivdi3+0xe5>
  801d4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d4f:	31 ff                	xor    %edi,%edi
  801d51:	e9 40 ff ff ff       	jmp    801c96 <__udivdi3+0x46>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	31 c0                	xor    %eax,%eax
  801d5a:	e9 37 ff ff ff       	jmp    801c96 <__udivdi3+0x46>
  801d5f:	90                   	nop

00801d60 <__umoddi3>:
  801d60:	55                   	push   %ebp
  801d61:	57                   	push   %edi
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	83 ec 1c             	sub    $0x1c,%esp
  801d67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d7f:	89 f3                	mov    %esi,%ebx
  801d81:	89 fa                	mov    %edi,%edx
  801d83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d87:	89 34 24             	mov    %esi,(%esp)
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	75 1a                	jne    801da8 <__umoddi3+0x48>
  801d8e:	39 f7                	cmp    %esi,%edi
  801d90:	0f 86 a2 00 00 00    	jbe    801e38 <__umoddi3+0xd8>
  801d96:	89 c8                	mov    %ecx,%eax
  801d98:	89 f2                	mov    %esi,%edx
  801d9a:	f7 f7                	div    %edi
  801d9c:	89 d0                	mov    %edx,%eax
  801d9e:	31 d2                	xor    %edx,%edx
  801da0:	83 c4 1c             	add    $0x1c,%esp
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    
  801da8:	39 f0                	cmp    %esi,%eax
  801daa:	0f 87 ac 00 00 00    	ja     801e5c <__umoddi3+0xfc>
  801db0:	0f bd e8             	bsr    %eax,%ebp
  801db3:	83 f5 1f             	xor    $0x1f,%ebp
  801db6:	0f 84 ac 00 00 00    	je     801e68 <__umoddi3+0x108>
  801dbc:	bf 20 00 00 00       	mov    $0x20,%edi
  801dc1:	29 ef                	sub    %ebp,%edi
  801dc3:	89 fe                	mov    %edi,%esi
  801dc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dc9:	89 e9                	mov    %ebp,%ecx
  801dcb:	d3 e0                	shl    %cl,%eax
  801dcd:	89 d7                	mov    %edx,%edi
  801dcf:	89 f1                	mov    %esi,%ecx
  801dd1:	d3 ef                	shr    %cl,%edi
  801dd3:	09 c7                	or     %eax,%edi
  801dd5:	89 e9                	mov    %ebp,%ecx
  801dd7:	d3 e2                	shl    %cl,%edx
  801dd9:	89 14 24             	mov    %edx,(%esp)
  801ddc:	89 d8                	mov    %ebx,%eax
  801dde:	d3 e0                	shl    %cl,%eax
  801de0:	89 c2                	mov    %eax,%edx
  801de2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de6:	d3 e0                	shl    %cl,%eax
  801de8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dec:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df0:	89 f1                	mov    %esi,%ecx
  801df2:	d3 e8                	shr    %cl,%eax
  801df4:	09 d0                	or     %edx,%eax
  801df6:	d3 eb                	shr    %cl,%ebx
  801df8:	89 da                	mov    %ebx,%edx
  801dfa:	f7 f7                	div    %edi
  801dfc:	89 d3                	mov    %edx,%ebx
  801dfe:	f7 24 24             	mull   (%esp)
  801e01:	89 c6                	mov    %eax,%esi
  801e03:	89 d1                	mov    %edx,%ecx
  801e05:	39 d3                	cmp    %edx,%ebx
  801e07:	0f 82 87 00 00 00    	jb     801e94 <__umoddi3+0x134>
  801e0d:	0f 84 91 00 00 00    	je     801ea4 <__umoddi3+0x144>
  801e13:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e17:	29 f2                	sub    %esi,%edx
  801e19:	19 cb                	sbb    %ecx,%ebx
  801e1b:	89 d8                	mov    %ebx,%eax
  801e1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e21:	d3 e0                	shl    %cl,%eax
  801e23:	89 e9                	mov    %ebp,%ecx
  801e25:	d3 ea                	shr    %cl,%edx
  801e27:	09 d0                	or     %edx,%eax
  801e29:	89 e9                	mov    %ebp,%ecx
  801e2b:	d3 eb                	shr    %cl,%ebx
  801e2d:	89 da                	mov    %ebx,%edx
  801e2f:	83 c4 1c             	add    $0x1c,%esp
  801e32:	5b                   	pop    %ebx
  801e33:	5e                   	pop    %esi
  801e34:	5f                   	pop    %edi
  801e35:	5d                   	pop    %ebp
  801e36:	c3                   	ret    
  801e37:	90                   	nop
  801e38:	89 fd                	mov    %edi,%ebp
  801e3a:	85 ff                	test   %edi,%edi
  801e3c:	75 0b                	jne    801e49 <__umoddi3+0xe9>
  801e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e43:	31 d2                	xor    %edx,%edx
  801e45:	f7 f7                	div    %edi
  801e47:	89 c5                	mov    %eax,%ebp
  801e49:	89 f0                	mov    %esi,%eax
  801e4b:	31 d2                	xor    %edx,%edx
  801e4d:	f7 f5                	div    %ebp
  801e4f:	89 c8                	mov    %ecx,%eax
  801e51:	f7 f5                	div    %ebp
  801e53:	89 d0                	mov    %edx,%eax
  801e55:	e9 44 ff ff ff       	jmp    801d9e <__umoddi3+0x3e>
  801e5a:	66 90                	xchg   %ax,%ax
  801e5c:	89 c8                	mov    %ecx,%eax
  801e5e:	89 f2                	mov    %esi,%edx
  801e60:	83 c4 1c             	add    $0x1c,%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5f                   	pop    %edi
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    
  801e68:	3b 04 24             	cmp    (%esp),%eax
  801e6b:	72 06                	jb     801e73 <__umoddi3+0x113>
  801e6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e71:	77 0f                	ja     801e82 <__umoddi3+0x122>
  801e73:	89 f2                	mov    %esi,%edx
  801e75:	29 f9                	sub    %edi,%ecx
  801e77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e7b:	89 14 24             	mov    %edx,(%esp)
  801e7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e82:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e86:	8b 14 24             	mov    (%esp),%edx
  801e89:	83 c4 1c             	add    $0x1c,%esp
  801e8c:	5b                   	pop    %ebx
  801e8d:	5e                   	pop    %esi
  801e8e:	5f                   	pop    %edi
  801e8f:	5d                   	pop    %ebp
  801e90:	c3                   	ret    
  801e91:	8d 76 00             	lea    0x0(%esi),%esi
  801e94:	2b 04 24             	sub    (%esp),%eax
  801e97:	19 fa                	sbb    %edi,%edx
  801e99:	89 d1                	mov    %edx,%ecx
  801e9b:	89 c6                	mov    %eax,%esi
  801e9d:	e9 71 ff ff ff       	jmp    801e13 <__umoddi3+0xb3>
  801ea2:	66 90                	xchg   %ax,%ax
  801ea4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ea8:	72 ea                	jb     801e94 <__umoddi3+0x134>
  801eaa:	89 d9                	mov    %ebx,%ecx
  801eac:	e9 62 ff ff ff       	jmp    801e13 <__umoddi3+0xb3>
