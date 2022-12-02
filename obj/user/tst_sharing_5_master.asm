
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d8 03 00 00       	call   80040e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
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
  800099:	e8 ac 04 00 00       	call   80054a <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 de 16 00 00       	call   801786 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 b8 38 80 00       	push   $0x8038b8
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 ec 38 80 00       	push   $0x8038ec
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 48 39 80 00       	push   $0x803948
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 8d 1b 00 00       	call   801c6d <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 7c 39 80 00       	push   $0x80397c
  8000f2:	e8 07 07 00 00       	call   8007fe <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ff:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800110:	89 c1                	mov    %eax,%ecx
  800112:	a1 20 50 80 00       	mov    0x805020,%eax
  800117:	8b 40 74             	mov    0x74(%eax),%eax
  80011a:	52                   	push   %edx
  80011b:	51                   	push   %ecx
  80011c:	50                   	push   %eax
  80011d:	68 bd 39 80 00       	push   $0x8039bd
  800122:	e8 f1 1a 00 00       	call   801c18 <sys_create_env>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80012d:	a1 20 50 80 00       	mov    0x805020,%eax
  800132:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800138:	a1 20 50 80 00       	mov    0x805020,%eax
  80013d:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	a1 20 50 80 00       	mov    0x805020,%eax
  80014a:	8b 40 74             	mov    0x74(%eax),%eax
  80014d:	52                   	push   %edx
  80014e:	51                   	push   %ecx
  80014f:	50                   	push   %eax
  800150:	68 bd 39 80 00       	push   $0x8039bd
  800155:	e8 be 1a 00 00       	call   801c18 <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 41 18 00 00       	call   8019a6 <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 c8 39 80 00       	push   $0x8039c8
  800177:	e8 52 16 00 00       	call   8017ce <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 cc 39 80 00       	push   $0x8039cc
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 ec 39 80 00       	push   $0x8039ec
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 9c 38 80 00       	push   $0x80389c
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 ef 17 00 00       	call   8019a6 <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 58 3a 80 00       	push   $0x803a58
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 9c 38 80 00       	push   $0x80389c
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 8b 1b 00 00       	call   801d64 <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 52 1a 00 00       	call   801c36 <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 44 1a 00 00       	call   801c36 <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 d6 3a 80 00       	push   $0x803ad6
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 56 33 00 00       	call   803568 <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 c3 1b 00 00       	call   801dde <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 81 17 00 00       	call   8019a6 <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 13 16 00 00       	call   801846 <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 f0 3a 80 00       	push   $0x803af0
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 5b 17 00 00       	call   8019a6 <sys_calculate_free_frames>
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800250:	29 c2                	sub    %eax,%edx
  800252:	89 d0                	mov    %edx,%eax
  800254:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expected = (1+1) + (1+1);
  800257:	c7 45 e8 04 00 00 00 	movl   $0x4,-0x18(%ebp)
		if ( diff !=  expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff, expected);
  80025e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800261:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800264:	74 1a                	je     800280 <_main+0x248>
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 e8             	pushl  -0x18(%ebp)
  80026c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80026f:	68 10 3b 80 00       	push   $0x803b10
  800274:	6a 3b                	push   $0x3b
  800276:	68 9c 38 80 00       	push   $0x80389c
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 58 3b 80 00       	push   $0x803b58
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 7c 3b 80 00       	push   $0x803b7c
  800298:	e8 61 05 00 00       	call   8007fe <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002b6:	89 c1                	mov    %eax,%ecx
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 40 74             	mov    0x74(%eax),%eax
  8002c0:	52                   	push   %edx
  8002c1:	51                   	push   %ecx
  8002c2:	50                   	push   %eax
  8002c3:	68 ac 3b 80 00       	push   $0x803bac
  8002c8:	e8 4b 19 00 00       	call   801c18 <sys_create_env>
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d8:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002de:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e3:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002e9:	89 c1                	mov    %eax,%ecx
  8002eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f0:	8b 40 74             	mov    0x74(%eax),%eax
  8002f3:	52                   	push   %edx
  8002f4:	51                   	push   %ecx
  8002f5:	50                   	push   %eax
  8002f6:	68 b9 3b 80 00       	push   $0x803bb9
  8002fb:	e8 18 19 00 00       	call   801c18 <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 c6 3b 80 00       	push   $0x803bc6
  800315:	e8 b4 14 00 00       	call   8017ce <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 c8 3b 80 00       	push   $0x803bc8
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 c8 39 80 00       	push   $0x8039c8
  80033f:	e8 8a 14 00 00       	call   8017ce <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 cc 39 80 00       	push   $0x8039cc
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 05 1a 00 00       	call   801d64 <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 cc 18 00 00       	call   801c36 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 be 18 00 00       	call   801c36 <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 5d 1a 00 00       	call   801dde <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 d9 19 00 00       	call   801d64 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 16 16 00 00       	call   8019a6 <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 a8 14 00 00       	call   801846 <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 e8 3b 80 00       	push   $0x803be8
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 8a 14 00 00       	call   801846 <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 fe 3b 80 00       	push   $0x803bfe
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 d2 15 00 00       	call   8019a6 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003d9:	29 c2                	sub    %eax,%edx
  8003db:	89 d0                	mov    %edx,%eax
  8003dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		expected = 1;
  8003e0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 14 3c 80 00       	push   $0x803c14
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 9c 38 80 00       	push   $0x80389c
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 bc 19 00 00       	call   801dc4 <inctst>


	}


	return;
  800408:	90                   	nop
}
  800409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800414:	e8 6d 18 00 00       	call   801c86 <sys_getenvindex>
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80041c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800431:	01 d0                	add    %edx,%eax
  800433:	c1 e0 04             	shl    $0x4,%eax
  800436:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800440:	a1 20 50 80 00       	mov    0x805020,%eax
  800445:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044b:	84 c0                	test   %al,%al
  80044d:	74 0f                	je     80045e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80044f:	a1 20 50 80 00       	mov    0x805020,%eax
  800454:	05 5c 05 00 00       	add    $0x55c,%eax
  800459:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800462:	7e 0a                	jle    80046e <libmain+0x60>
		binaryname = argv[0];
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 0c             	pushl  0xc(%ebp)
  800474:	ff 75 08             	pushl  0x8(%ebp)
  800477:	e8 bc fb ff ff       	call   800038 <_main>
  80047c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80047f:	e8 0f 16 00 00       	call   801a93 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 d4 3c 80 00       	push   $0x803cd4
  80048c:	e8 6d 03 00 00       	call   8007fe <cprintf>
  800491:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800494:	a1 20 50 80 00       	mov    0x805020,%eax
  800499:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80049f:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	52                   	push   %edx
  8004ae:	50                   	push   %eax
  8004af:	68 fc 3c 80 00       	push   $0x803cfc
  8004b4:	e8 45 03 00 00       	call   8007fe <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004cc:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004dd:	51                   	push   %ecx
  8004de:	52                   	push   %edx
  8004df:	50                   	push   %eax
  8004e0:	68 24 3d 80 00       	push   $0x803d24
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 7c 3d 80 00       	push   $0x803d7c
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 d4 3c 80 00       	push   $0x803cd4
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 8f 15 00 00       	call   801aad <sys_enable_interrupt>

	// exit gracefully
	exit();
  80051e:	e8 19 00 00 00       	call   80053c <exit>
}
  800523:	90                   	nop
  800524:	c9                   	leave  
  800525:	c3                   	ret    

00800526 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80052c:	83 ec 0c             	sub    $0xc,%esp
  80052f:	6a 00                	push   $0x0
  800531:	e8 1c 17 00 00       	call   801c52 <sys_destroy_env>
  800536:	83 c4 10             	add    $0x10,%esp
}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <exit>:

void
exit(void)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800542:	e8 71 17 00 00       	call   801cb8 <sys_exit_env>
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800550:	8d 45 10             	lea    0x10(%ebp),%eax
  800553:	83 c0 04             	add    $0x4,%eax
  800556:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800559:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80055e:	85 c0                	test   %eax,%eax
  800560:	74 16                	je     800578 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800562:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	50                   	push   %eax
  80056b:	68 90 3d 80 00       	push   $0x803d90
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 95 3d 80 00       	push   $0x803d95
  800589:	e8 70 02 00 00       	call   8007fe <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	ff 75 f4             	pushl  -0xc(%ebp)
  80059a:	50                   	push   %eax
  80059b:	e8 f3 01 00 00       	call   800793 <vcprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	6a 00                	push   $0x0
  8005a8:	68 b1 3d 80 00       	push   $0x803db1
  8005ad:	e8 e1 01 00 00       	call   800793 <vcprintf>
  8005b2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005b5:	e8 82 ff ff ff       	call   80053c <exit>

	// should not return here
	while (1) ;
  8005ba:	eb fe                	jmp    8005ba <_panic+0x70>

008005bc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c7:	8b 50 74             	mov    0x74(%eax),%edx
  8005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	74 14                	je     8005e5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	68 b4 3d 80 00       	push   $0x803db4
  8005d9:	6a 26                	push   $0x26
  8005db:	68 00 3e 80 00       	push   $0x803e00
  8005e0:	e8 65 ff ff ff       	call   80054a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f3:	e9 c2 00 00 00       	jmp    8006ba <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	85 c0                	test   %eax,%eax
  80060b:	75 08                	jne    800615 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80060d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800610:	e9 a2 00 00 00       	jmp    8006b7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800615:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800623:	eb 69                	jmp    80068e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	84 c0                	test   %al,%al
  800643:	75 46                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800645:	a1 20 50 80 00       	mov    0x805020,%eax
  80064a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800653:	89 d0                	mov    %edx,%eax
  800655:	01 c0                	add    %eax,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	c1 e0 03             	shl    $0x3,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800663:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800666:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80066b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	01 c8                	add    %ecx,%eax
  80067c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067e:	39 c2                	cmp    %eax,%edx
  800680:	75 09                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800682:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800689:	eb 12                	jmp    80069d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80068b:	ff 45 e8             	incl   -0x18(%ebp)
  80068e:	a1 20 50 80 00       	mov    0x805020,%eax
  800693:	8b 50 74             	mov    0x74(%eax),%edx
  800696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800699:	39 c2                	cmp    %eax,%edx
  80069b:	77 88                	ja     800625 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80069d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a1:	75 14                	jne    8006b7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	68 0c 3e 80 00       	push   $0x803e0c
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 00 3e 80 00       	push   $0x803e00
  8006b2:	e8 93 fe ff ff       	call   80054a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006b7:	ff 45 f0             	incl   -0x10(%ebp)
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c0:	0f 8c 32 ff ff ff    	jl     8005f8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006d4:	eb 26                	jmp    8006fc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	01 c0                	add    %eax,%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	c1 e0 03             	shl    $0x3,%eax
  8006ed:	01 c8                	add    %ecx,%eax
  8006ef:	8a 40 04             	mov    0x4(%eax),%al
  8006f2:	3c 01                	cmp    $0x1,%al
  8006f4:	75 03                	jne    8006f9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006f6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f9:	ff 45 e0             	incl   -0x20(%ebp)
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 50 74             	mov    0x74(%eax),%edx
  800704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800707:	39 c2                	cmp    %eax,%edx
  800709:	77 cb                	ja     8006d6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80070b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800711:	74 14                	je     800727 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800713:	83 ec 04             	sub    $0x4,%esp
  800716:	68 60 3e 80 00       	push   $0x803e60
  80071b:	6a 44                	push   $0x44
  80071d:	68 00 3e 80 00       	push   $0x803e00
  800722:	e8 23 fe ff ff       	call   80054a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800727:	90                   	nop
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	8d 48 01             	lea    0x1(%eax),%ecx
  800738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073b:	89 0a                	mov    %ecx,(%edx)
  80073d:	8b 55 08             	mov    0x8(%ebp),%edx
  800740:	88 d1                	mov    %dl,%cl
  800742:	8b 55 0c             	mov    0xc(%ebp),%edx
  800745:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800753:	75 2c                	jne    800781 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800755:	a0 24 50 80 00       	mov    0x805024,%al
  80075a:	0f b6 c0             	movzbl %al,%eax
  80075d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800760:	8b 12                	mov    (%edx),%edx
  800762:	89 d1                	mov    %edx,%ecx
  800764:	8b 55 0c             	mov    0xc(%ebp),%edx
  800767:	83 c2 08             	add    $0x8,%edx
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	50                   	push   %eax
  80076e:	51                   	push   %ecx
  80076f:	52                   	push   %edx
  800770:	e8 70 11 00 00       	call   8018e5 <sys_cputs>
  800775:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
  800784:	8b 40 04             	mov    0x4(%eax),%eax
  800787:	8d 50 01             	lea    0x1(%eax),%edx
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800790:	90                   	nop
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a3:	00 00 00 
	b.cnt = 0;
  8007a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ad:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	68 2a 07 80 00       	push   $0x80072a
  8007c2:	e8 11 02 00 00       	call   8009d8 <vprintfmt>
  8007c7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007ca:	a0 24 50 80 00       	mov    0x805024,%al
  8007cf:	0f b6 c0             	movzbl %al,%eax
  8007d2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	50                   	push   %eax
  8007dc:	52                   	push   %edx
  8007dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e3:	83 c0 08             	add    $0x8,%eax
  8007e6:	50                   	push   %eax
  8007e7:	e8 f9 10 00 00       	call   8018e5 <sys_cputs>
  8007ec:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ef:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8007f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    

008007fe <cprintf>:

int cprintf(const char *fmt, ...) {
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800804:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80080b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 f4             	pushl  -0xc(%ebp)
  80081a:	50                   	push   %eax
  80081b:	e8 73 ff ff ff       	call   800793 <vcprintf>
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800831:	e8 5d 12 00 00       	call   801a93 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800836:	8d 45 0c             	lea    0xc(%ebp),%eax
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 f4             	pushl  -0xc(%ebp)
  800845:	50                   	push   %eax
  800846:	e8 48 ff ff ff       	call   800793 <vcprintf>
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800851:	e8 57 12 00 00       	call   801aad <sys_enable_interrupt>
	return cnt;
  800856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	83 ec 14             	sub    $0x14,%esp
  800862:	8b 45 10             	mov    0x10(%ebp),%eax
  800865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80086e:	8b 45 18             	mov    0x18(%ebp),%eax
  800871:	ba 00 00 00 00       	mov    $0x0,%edx
  800876:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800879:	77 55                	ja     8008d0 <printnum+0x75>
  80087b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087e:	72 05                	jb     800885 <printnum+0x2a>
  800880:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800883:	77 4b                	ja     8008d0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800885:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800888:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80088b:	8b 45 18             	mov    0x18(%ebp),%eax
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
  800893:	52                   	push   %edx
  800894:	50                   	push   %eax
  800895:	ff 75 f4             	pushl  -0xc(%ebp)
  800898:	ff 75 f0             	pushl  -0x10(%ebp)
  80089b:	e8 7c 2d 00 00       	call   80361c <__udivdi3>
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	83 ec 04             	sub    $0x4,%esp
  8008a6:	ff 75 20             	pushl  0x20(%ebp)
  8008a9:	53                   	push   %ebx
  8008aa:	ff 75 18             	pushl  0x18(%ebp)
  8008ad:	52                   	push   %edx
  8008ae:	50                   	push   %eax
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	ff 75 08             	pushl  0x8(%ebp)
  8008b5:	e8 a1 ff ff ff       	call   80085b <printnum>
  8008ba:	83 c4 20             	add    $0x20,%esp
  8008bd:	eb 1a                	jmp    8008d9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	ff 75 20             	pushl  0x20(%ebp)
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d0:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008d7:	7f e6                	jg     8008bf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e7:	53                   	push   %ebx
  8008e8:	51                   	push   %ecx
  8008e9:	52                   	push   %edx
  8008ea:	50                   	push   %eax
  8008eb:	e8 3c 2e 00 00       	call   80372c <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 d4 40 80 00       	add    $0x8040d4,%eax
  8008f8:	8a 00                	mov    (%eax),%al
  8008fa:	0f be c0             	movsbl %al,%eax
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	50                   	push   %eax
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
}
  80090c:	90                   	nop
  80090d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800915:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800919:	7e 1c                	jle    800937 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 08             	lea    0x8(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 08             	sub    $0x8,%eax
  800930:	8b 50 04             	mov    0x4(%eax),%edx
  800933:	8b 00                	mov    (%eax),%eax
  800935:	eb 40                	jmp    800977 <getuint+0x65>
	else if (lflag)
  800937:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093b:	74 1e                	je     80095b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 04             	lea    0x4(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	ba 00 00 00 00       	mov    $0x0,%edx
  800959:	eb 1c                	jmp    800977 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	8d 50 04             	lea    0x4(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 10                	mov    %edx,(%eax)
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800980:	7e 1c                	jle    80099e <getint+0x25>
		return va_arg(*ap, long long);
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	8d 50 08             	lea    0x8(%eax),%edx
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 10                	mov    %edx,(%eax)
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	83 e8 08             	sub    $0x8,%eax
  800997:	8b 50 04             	mov    0x4(%eax),%edx
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	eb 38                	jmp    8009d6 <getint+0x5d>
	else if (lflag)
  80099e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a2:	74 1a                	je     8009be <getint+0x45>
		return va_arg(*ap, long);
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 10                	mov    %edx,(%eax)
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	99                   	cltd   
  8009bc:	eb 18                	jmp    8009d6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	8d 50 04             	lea    0x4(%eax),%edx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	89 10                	mov    %edx,(%eax)
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	83 e8 04             	sub    $0x4,%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	99                   	cltd   
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e0:	eb 17                	jmp    8009f9 <vprintfmt+0x21>
			if (ch == '\0')
  8009e2:	85 db                	test   %ebx,%ebx
  8009e4:	0f 84 af 03 00 00    	je     800d99 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	53                   	push   %ebx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	8d 50 01             	lea    0x1(%eax),%edx
  8009ff:	89 55 10             	mov    %edx,0x10(%ebp)
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	0f b6 d8             	movzbl %al,%ebx
  800a07:	83 fb 25             	cmp    $0x25,%ebx
  800a0a:	75 d6                	jne    8009e2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a10:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2f:	8d 50 01             	lea    0x1(%eax),%edx
  800a32:	89 55 10             	mov    %edx,0x10(%ebp)
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	0f b6 d8             	movzbl %al,%ebx
  800a3a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a3d:	83 f8 55             	cmp    $0x55,%eax
  800a40:	0f 87 2b 03 00 00    	ja     800d71 <vprintfmt+0x399>
  800a46:	8b 04 85 f8 40 80 00 	mov    0x8040f8(,%eax,4),%eax
  800a4d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a4f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a53:	eb d7                	jmp    800a2c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a55:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a59:	eb d1                	jmp    800a2c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a65:	89 d0                	mov    %edx,%eax
  800a67:	c1 e0 02             	shl    $0x2,%eax
  800a6a:	01 d0                	add    %edx,%eax
  800a6c:	01 c0                	add    %eax,%eax
  800a6e:	01 d8                	add    %ebx,%eax
  800a70:	83 e8 30             	sub    $0x30,%eax
  800a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a76:	8b 45 10             	mov    0x10(%ebp),%eax
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a7e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a81:	7e 3e                	jle    800ac1 <vprintfmt+0xe9>
  800a83:	83 fb 39             	cmp    $0x39,%ebx
  800a86:	7f 39                	jg     800ac1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a88:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a8b:	eb d5                	jmp    800a62 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 c0 04             	add    $0x4,%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa7:	79 83                	jns    800a2c <vprintfmt+0x54>
				width = 0;
  800aa9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab0:	e9 77 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ab5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800abc:	e9 6b ff ff ff       	jmp    800a2c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac6:	0f 89 60 ff ff ff    	jns    800a2c <vprintfmt+0x54>
				width = precision, precision = -1;
  800acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ad9:	e9 4e ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ade:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae1:	e9 46 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae9:	83 c0 04             	add    $0x4,%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	50                   	push   %eax
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			break;
  800b06:	e9 89 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 c0 04             	add    $0x4,%eax
  800b11:	89 45 14             	mov    %eax,0x14(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b1c:	85 db                	test   %ebx,%ebx
  800b1e:	79 02                	jns    800b22 <vprintfmt+0x14a>
				err = -err;
  800b20:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b22:	83 fb 64             	cmp    $0x64,%ebx
  800b25:	7f 0b                	jg     800b32 <vprintfmt+0x15a>
  800b27:	8b 34 9d 40 3f 80 00 	mov    0x803f40(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 e5 40 80 00       	push   $0x8040e5
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	e8 5e 02 00 00       	call   800da1 <printfmt>
  800b43:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b46:	e9 49 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4b:	56                   	push   %esi
  800b4c:	68 ee 40 80 00       	push   $0x8040ee
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 45 02 00 00       	call   800da1 <printfmt>
  800b5c:	83 c4 10             	add    $0x10,%esp
			break;
  800b5f:	e9 30 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	83 c0 04             	add    $0x4,%eax
  800b6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	83 e8 04             	sub    $0x4,%eax
  800b73:	8b 30                	mov    (%eax),%esi
  800b75:	85 f6                	test   %esi,%esi
  800b77:	75 05                	jne    800b7e <vprintfmt+0x1a6>
				p = "(null)";
  800b79:	be f1 40 80 00       	mov    $0x8040f1,%esi
			if (width > 0 && padc != '-')
  800b7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b82:	7e 6d                	jle    800bf1 <vprintfmt+0x219>
  800b84:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b88:	74 67                	je     800bf1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	50                   	push   %eax
  800b91:	56                   	push   %esi
  800b92:	e8 0c 03 00 00       	call   800ea3 <strnlen>
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b9d:	eb 16                	jmp    800bb5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b9f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb9:	7f e4                	jg     800b9f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbb:	eb 34                	jmp    800bf1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc1:	74 1c                	je     800bdf <vprintfmt+0x207>
  800bc3:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc6:	7e 05                	jle    800bcd <vprintfmt+0x1f5>
  800bc8:	83 fb 7e             	cmp    $0x7e,%ebx
  800bcb:	7e 12                	jle    800bdf <vprintfmt+0x207>
					putch('?', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	6a 3f                	push   $0x3f
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	eb 0f                	jmp    800bee <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	53                   	push   %ebx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bee:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf1:	89 f0                	mov    %esi,%eax
  800bf3:	8d 70 01             	lea    0x1(%eax),%esi
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	0f be d8             	movsbl %al,%ebx
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	74 24                	je     800c23 <vprintfmt+0x24b>
  800bff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c03:	78 b8                	js     800bbd <vprintfmt+0x1e5>
  800c05:	ff 4d e0             	decl   -0x20(%ebp)
  800c08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0c:	79 af                	jns    800bbd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0e:	eb 13                	jmp    800c23 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 20                	push   $0x20
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c20:	ff 4d e4             	decl   -0x1c(%ebp)
  800c23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c27:	7f e7                	jg     800c10 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c29:	e9 66 01 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 e8             	pushl  -0x18(%ebp)
  800c34:	8d 45 14             	lea    0x14(%ebp),%eax
  800c37:	50                   	push   %eax
  800c38:	e8 3c fd ff ff       	call   800979 <getint>
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4c:	85 d2                	test   %edx,%edx
  800c4e:	79 23                	jns    800c73 <vprintfmt+0x29b>
				putch('-', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 2d                	push   $0x2d
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c66:	f7 d8                	neg    %eax
  800c68:	83 d2 00             	adc    $0x0,%edx
  800c6b:	f7 da                	neg    %edx
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7a:	e9 bc 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 e8             	pushl  -0x18(%ebp)
  800c85:	8d 45 14             	lea    0x14(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	e8 84 fc ff ff       	call   800912 <getuint>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c9e:	e9 98 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 58                	push   $0x58
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	6a 58                	push   $0x58
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	6a 58                	push   $0x58
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			break;
  800cd3:	e9 bc 00 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	6a 30                	push   $0x30
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	ff d0                	call   *%eax
  800ce5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	6a 78                	push   $0x78
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	ff d0                	call   *%eax
  800cf5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	83 c0 04             	add    $0x4,%eax
  800cfe:	89 45 14             	mov    %eax,0x14(%ebp)
  800d01:	8b 45 14             	mov    0x14(%ebp),%eax
  800d04:	83 e8 04             	sub    $0x4,%eax
  800d07:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d1a:	eb 1f                	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 e8             	pushl  -0x18(%ebp)
  800d22:	8d 45 14             	lea    0x14(%ebp),%eax
  800d25:	50                   	push   %eax
  800d26:	e8 e7 fb ff ff       	call   800912 <getuint>
  800d2b:	83 c4 10             	add    $0x10,%esp
  800d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d34:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	52                   	push   %edx
  800d46:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d49:	50                   	push   %eax
  800d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	ff 75 08             	pushl  0x8(%ebp)
  800d56:	e8 00 fb ff ff       	call   80085b <printnum>
  800d5b:	83 c4 20             	add    $0x20,%esp
			break;
  800d5e:	eb 34                	jmp    800d94 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	53                   	push   %ebx
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	ff d0                	call   *%eax
  800d6c:	83 c4 10             	add    $0x10,%esp
			break;
  800d6f:	eb 23                	jmp    800d94 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d71:	83 ec 08             	sub    $0x8,%esp
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	6a 25                	push   $0x25
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	ff d0                	call   *%eax
  800d7e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d81:	ff 4d 10             	decl   0x10(%ebp)
  800d84:	eb 03                	jmp    800d89 <vprintfmt+0x3b1>
  800d86:	ff 4d 10             	decl   0x10(%ebp)
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	48                   	dec    %eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	3c 25                	cmp    $0x25,%al
  800d91:	75 f3                	jne    800d86 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d93:	90                   	nop
		}
	}
  800d94:	e9 47 fc ff ff       	jmp    8009e0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d99:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800da7:	8d 45 10             	lea    0x10(%ebp),%eax
  800daa:	83 c0 04             	add    $0x4,%eax
  800dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	ff 75 f4             	pushl  -0xc(%ebp)
  800db6:	50                   	push   %eax
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	ff 75 08             	pushl  0x8(%ebp)
  800dbd:	e8 16 fc ff ff       	call   8009d8 <vprintfmt>
  800dc2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dc5:	90                   	nop
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	8b 40 08             	mov    0x8(%eax),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8b 10                	mov    (%eax),%edx
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8b 40 04             	mov    0x4(%eax),%eax
  800de5:	39 c2                	cmp    %eax,%edx
  800de7:	73 12                	jae    800dfb <sprintputch+0x33>
		*b->buf++ = ch;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8b 00                	mov    (%eax),%eax
  800dee:	8d 48 01             	lea    0x1(%eax),%ecx
  800df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df4:	89 0a                	mov    %ecx,(%edx)
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	88 10                	mov    %dl,(%eax)
}
  800dfb:	90                   	nop
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    

00800dfe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e23:	74 06                	je     800e2b <vsnprintf+0x2d>
  800e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e29:	7f 07                	jg     800e32 <vsnprintf+0x34>
		return -E_INVAL;
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	eb 20                	jmp    800e52 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e32:	ff 75 14             	pushl  0x14(%ebp)
  800e35:	ff 75 10             	pushl  0x10(%ebp)
  800e38:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e3b:	50                   	push   %eax
  800e3c:	68 c8 0d 80 00       	push   $0x800dc8
  800e41:	e8 92 fb ff ff       	call   8009d8 <vprintfmt>
  800e46:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e5a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e5d:	83 c0 04             	add    $0x4,%eax
  800e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	ff 75 f4             	pushl  -0xc(%ebp)
  800e69:	50                   	push   %eax
  800e6a:	ff 75 0c             	pushl  0xc(%ebp)
  800e6d:	ff 75 08             	pushl  0x8(%ebp)
  800e70:	e8 89 ff ff ff       	call   800dfe <vsnprintf>
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8d:	eb 06                	jmp    800e95 <strlen+0x15>
		n++;
  800e8f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e92:	ff 45 08             	incl   0x8(%ebp)
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 f1                	jne    800e8f <strlen+0xf>
		n++;
	return n;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb0:	eb 09                	jmp    800ebb <strnlen+0x18>
		n++;
  800eb2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb5:	ff 45 08             	incl   0x8(%ebp)
  800eb8:	ff 4d 0c             	decl   0xc(%ebp)
  800ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebf:	74 09                	je     800eca <strnlen+0x27>
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 e8                	jne    800eb2 <strnlen+0xf>
		n++;
	return n;
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800edb:	90                   	nop
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8d 50 01             	lea    0x1(%eax),%edx
  800ee2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eeb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eee:	8a 12                	mov    (%edx),%dl
  800ef0:	88 10                	mov    %dl,(%eax)
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	75 e4                	jne    800edc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f10:	eb 1f                	jmp    800f31 <strncpy+0x34>
		*dst++ = *src;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8d 50 01             	lea    0x1(%eax),%edx
  800f18:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	84 c0                	test   %al,%al
  800f29:	74 03                	je     800f2e <strncpy+0x31>
			src++;
  800f2b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2e:	ff 45 fc             	incl   -0x4(%ebp)
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f37:	72 d9                	jb     800f12 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 30                	je     800f80 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f50:	eb 16                	jmp    800f68 <strlcpy+0x2a>
			*dst++ = *src++;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f68:	ff 4d 10             	decl   0x10(%ebp)
  800f6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6f:	74 09                	je     800f7a <strlcpy+0x3c>
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 d8                	jne    800f52 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f86:	29 c2                	sub    %eax,%edx
  800f88:	89 d0                	mov    %edx,%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f8f:	eb 06                	jmp    800f97 <strcmp+0xb>
		p++, q++;
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 0e                	je     800fae <strcmp+0x22>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 10                	mov    (%eax),%dl
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	38 c2                	cmp    %al,%dl
  800fac:	74 e3                	je     800f91 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f b6 d0             	movzbl %al,%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 c0             	movzbl %al,%eax
  800fbe:	29 c2                	sub    %eax,%edx
  800fc0:	89 d0                	mov    %edx,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fc7:	eb 09                	jmp    800fd2 <strncmp+0xe>
		n--, p++, q++;
  800fc9:	ff 4d 10             	decl   0x10(%ebp)
  800fcc:	ff 45 08             	incl   0x8(%ebp)
  800fcf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd6:	74 17                	je     800fef <strncmp+0x2b>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	84 c0                	test   %al,%al
  800fdf:	74 0e                	je     800fef <strncmp+0x2b>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 10                	mov    (%eax),%dl
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	38 c2                	cmp    %al,%dl
  800fed:	74 da                	je     800fc9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff3:	75 07                	jne    800ffc <strncmp+0x38>
		return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffa:	eb 14                	jmp    801010 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 c0             	movzbl %al,%eax
  80100c:	29 c2                	sub    %eax,%edx
  80100e:	89 d0                	mov    %edx,%eax
}
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 04             	sub    $0x4,%esp
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101e:	eb 12                	jmp    801032 <strchr+0x20>
		if (*s == c)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801028:	75 05                	jne    80102f <strchr+0x1d>
			return (char *) s;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	eb 11                	jmp    801040 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	84 c0                	test   %al,%al
  801039:	75 e5                	jne    801020 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104e:	eb 0d                	jmp    80105d <strfind+0x1b>
		if (*s == c)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801058:	74 0e                	je     801068 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	84 c0                	test   %al,%al
  801064:	75 ea                	jne    801050 <strfind+0xe>
  801066:	eb 01                	jmp    801069 <strfind+0x27>
		if (*s == c)
			break;
  801068:	90                   	nop
	return (char *) s;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801080:	eb 0e                	jmp    801090 <memset+0x22>
		*p++ = c;
  801082:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801090:	ff 4d f8             	decl   -0x8(%ebp)
  801093:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801097:	79 e9                	jns    801082 <memset+0x14>
		*p++ = c;

	return v;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010b0:	eb 16                	jmp    8010c8 <memcpy+0x2a>
		*d++ = *s++;
  8010b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c4:	8a 12                	mov    (%edx),%dl
  8010c6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 dd                	jne    8010b2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f2:	73 50                	jae    801144 <memmove+0x6a>
  8010f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	01 d0                	add    %edx,%eax
  8010fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ff:	76 43                	jbe    801144 <memmove+0x6a>
		s += n;
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110d:	eb 10                	jmp    80111f <memmove+0x45>
			*--d = *--s;
  80110f:	ff 4d f8             	decl   -0x8(%ebp)
  801112:	ff 4d fc             	decl   -0x4(%ebp)
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801118:	8a 10                	mov    (%eax),%dl
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	8d 50 ff             	lea    -0x1(%eax),%edx
  801125:	89 55 10             	mov    %edx,0x10(%ebp)
  801128:	85 c0                	test   %eax,%eax
  80112a:	75 e3                	jne    80110f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112c:	eb 23                	jmp    801151 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801140:	8a 12                	mov    (%edx),%dl
  801142:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114a:	89 55 10             	mov    %edx,0x10(%ebp)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 dd                	jne    80112e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801168:	eb 2a                	jmp    801194 <memcmp+0x3e>
		if (*s1 != *s2)
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8a 10                	mov    (%eax),%dl
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	38 c2                	cmp    %al,%dl
  801176:	74 16                	je     80118e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	0f b6 d0             	movzbl %al,%edx
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f b6 c0             	movzbl %al,%eax
  801188:	29 c2                	sub    %eax,%edx
  80118a:	89 d0                	mov    %edx,%eax
  80118c:	eb 18                	jmp    8011a6 <memcmp+0x50>
		s1++, s2++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
  801191:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 c9                	jne    80116a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b9:	eb 15                	jmp    8011d0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	0f b6 d0             	movzbl %al,%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	0f b6 c0             	movzbl %al,%eax
  8011c9:	39 c2                	cmp    %eax,%edx
  8011cb:	74 0d                	je     8011da <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011cd:	ff 45 08             	incl   0x8(%ebp)
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d6:	72 e3                	jb     8011bb <memfind+0x13>
  8011d8:	eb 01                	jmp    8011db <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011da:	90                   	nop
	return (void *) s;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f4:	eb 03                	jmp    8011f9 <strtol+0x19>
		s++;
  8011f6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 20                	cmp    $0x20,%al
  801200:	74 f4                	je     8011f6 <strtol+0x16>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 09                	cmp    $0x9,%al
  801209:	74 eb                	je     8011f6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 2b                	cmp    $0x2b,%al
  801212:	75 05                	jne    801219 <strtol+0x39>
		s++;
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	eb 13                	jmp    80122c <strtol+0x4c>
	else if (*s == '-')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 2d                	cmp    $0x2d,%al
  801220:	75 0a                	jne    80122c <strtol+0x4c>
		s++, neg = 1;
  801222:	ff 45 08             	incl   0x8(%ebp)
  801225:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801230:	74 06                	je     801238 <strtol+0x58>
  801232:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801236:	75 20                	jne    801258 <strtol+0x78>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	3c 30                	cmp    $0x30,%al
  80123f:	75 17                	jne    801258 <strtol+0x78>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	40                   	inc    %eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 78                	cmp    $0x78,%al
  801249:	75 0d                	jne    801258 <strtol+0x78>
		s += 2, base = 16;
  80124b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80124f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801256:	eb 28                	jmp    801280 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125c:	75 15                	jne    801273 <strtol+0x93>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 30                	cmp    $0x30,%al
  801265:	75 0c                	jne    801273 <strtol+0x93>
		s++, base = 8;
  801267:	ff 45 08             	incl   0x8(%ebp)
  80126a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801271:	eb 0d                	jmp    801280 <strtol+0xa0>
	else if (base == 0)
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	75 07                	jne    801280 <strtol+0xa0>
		base = 10;
  801279:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 2f                	cmp    $0x2f,%al
  801287:	7e 19                	jle    8012a2 <strtol+0xc2>
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 39                	cmp    $0x39,%al
  801290:	7f 10                	jg     8012a2 <strtol+0xc2>
			dig = *s - '0';
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	83 e8 30             	sub    $0x30,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a0:	eb 42                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 60                	cmp    $0x60,%al
  8012a9:	7e 19                	jle    8012c4 <strtol+0xe4>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 7a                	cmp    $0x7a,%al
  8012b2:	7f 10                	jg     8012c4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	83 e8 57             	sub    $0x57,%eax
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c2:	eb 20                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 40                	cmp    $0x40,%al
  8012cb:	7e 39                	jle    801306 <strtol+0x126>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 5a                	cmp    $0x5a,%al
  8012d4:	7f 30                	jg     801306 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 37             	sub    $0x37,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ea:	7d 19                	jge    801305 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801300:	e9 7b ff ff ff       	jmp    801280 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801305:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130a:	74 08                	je     801314 <strtol+0x134>
		*endptr = (char *) s;
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 07                	je     801321 <strtol+0x141>
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	f7 d8                	neg    %eax
  80131f:	eb 03                	jmp    801324 <strtol+0x144>
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <ltostr>:

void
ltostr(long value, char *str)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801333:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133e:	79 13                	jns    801353 <ltostr+0x2d>
	{
		neg = 1;
  801340:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801350:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135b:	99                   	cltd   
  80135c:	f7 f9                	idiv   %ecx
  80135e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	83 c2 30             	add    $0x30,%edx
  801377:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801381:	f7 e9                	imul   %ecx
  801383:	c1 fa 02             	sar    $0x2,%edx
  801386:	89 c8                	mov    %ecx,%eax
  801388:	c1 f8 1f             	sar    $0x1f,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801395:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80139a:	f7 e9                	imul   %ecx
  80139c:	c1 fa 02             	sar    $0x2,%edx
  80139f:	89 c8                	mov    %ecx,%eax
  8013a1:	c1 f8 1f             	sar    $0x1f,%eax
  8013a4:	29 c2                	sub    %eax,%edx
  8013a6:	89 d0                	mov    %edx,%eax
  8013a8:	c1 e0 02             	shl    $0x2,%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	01 c0                	add    %eax,%eax
  8013af:	29 c1                	sub    %eax,%ecx
  8013b1:	89 ca                	mov    %ecx,%edx
  8013b3:	85 d2                	test   %edx,%edx
  8013b5:	75 9c                	jne    801353 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c1:	48                   	dec    %eax
  8013c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c9:	74 3d                	je     801408 <ltostr+0xe2>
		start = 1 ;
  8013cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013d2:	eb 34                	jmp    801408 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 d0                	add    %edx,%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	01 c2                	add    %eax,%edx
  8013fd:	8a 45 eb             	mov    -0x15(%ebp),%al
  801400:	88 02                	mov    %al,(%edx)
		start++ ;
  801402:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801405:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80140e:	7c c4                	jl     8013d4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801410:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	01 d0                	add    %edx,%eax
  801418:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80141b:	90                   	nop
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 54 fa ff ff       	call   800e80 <strlen>
  80142c:	83 c4 04             	add    $0x4,%esp
  80142f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	e8 46 fa ff ff       	call   800e80 <strlen>
  80143a:	83 c4 04             	add    $0x4,%esp
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144e:	eb 17                	jmp    801467 <strcconcat+0x49>
		final[s] = str1[s] ;
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 10             	mov    0x10(%ebp),%eax
  801456:	01 c2                	add    %eax,%edx
  801458:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 c8                	add    %ecx,%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801464:	ff 45 fc             	incl   -0x4(%ebp)
  801467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80146d:	7c e1                	jl     801450 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80146f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801476:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80147d:	eb 1f                	jmp    80149e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	8d 50 01             	lea    0x1(%eax),%edx
  801485:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801488:	89 c2                	mov    %eax,%edx
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	01 c2                	add    %eax,%edx
  80148f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	01 c8                	add    %ecx,%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80149b:	ff 45 f8             	incl   -0x8(%ebp)
  80149e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a4:	7c d9                	jl     80147f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	c6 00 00             	movb   $0x0,(%eax)
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d7:	eb 0c                	jmp    8014e5 <strsplit+0x31>
			*string++ = 0;
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8d 50 01             	lea    0x1(%eax),%edx
  8014df:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	74 18                	je     801506 <strsplit+0x52>
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	0f be c0             	movsbl %al,%eax
  8014f6:	50                   	push   %eax
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	e8 13 fb ff ff       	call   801012 <strchr>
  8014ff:	83 c4 08             	add    $0x8,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	75 d3                	jne    8014d9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	84 c0                	test   %al,%al
  80150d:	74 5a                	je     801569 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80150f:	8b 45 14             	mov    0x14(%ebp),%eax
  801512:	8b 00                	mov    (%eax),%eax
  801514:	83 f8 0f             	cmp    $0xf,%eax
  801517:	75 07                	jne    801520 <strsplit+0x6c>
		{
			return 0;
  801519:	b8 00 00 00 00       	mov    $0x0,%eax
  80151e:	eb 66                	jmp    801586 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801520:	8b 45 14             	mov    0x14(%ebp),%eax
  801523:	8b 00                	mov    (%eax),%eax
  801525:	8d 48 01             	lea    0x1(%eax),%ecx
  801528:	8b 55 14             	mov    0x14(%ebp),%edx
  80152b:	89 0a                	mov    %ecx,(%edx)
  80152d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	01 c2                	add    %eax,%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80153e:	eb 03                	jmp    801543 <strsplit+0x8f>
			string++;
  801540:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 8b                	je     8014d7 <strsplit+0x23>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f be c0             	movsbl %al,%eax
  801554:	50                   	push   %eax
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 b5 fa ff ff       	call   801012 <strchr>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	74 dc                	je     801540 <strsplit+0x8c>
			string++;
	}
  801564:	e9 6e ff ff ff       	jmp    8014d7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801569:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	01 d0                	add    %edx,%eax
  80157b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801581:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80158e:	a1 04 50 80 00       	mov    0x805004,%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	74 1f                	je     8015b6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801597:	e8 1d 00 00 00       	call   8015b9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	68 50 42 80 00       	push   $0x804250
  8015a4:	e8 55 f2 ff ff       	call   8007fe <cprintf>
  8015a9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8015ac:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8015b3:	00 00 00 
	}
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8015bf:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8015c6:	00 00 00 
  8015c9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8015d0:	00 00 00 
  8015d3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8015da:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8015dd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8015e4:	00 00 00 
  8015e7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8015ee:	00 00 00 
  8015f1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8015f8:	00 00 00 
	uint32 arr_size = 0;
  8015fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801602:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801611:	2d 00 10 00 00       	sub    $0x1000,%eax
  801616:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80161b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801622:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801625:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80162c:	a1 20 51 80 00       	mov    0x805120,%eax
  801631:	c1 e0 04             	shl    $0x4,%eax
  801634:	89 c2                	mov    %eax,%edx
  801636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801639:	01 d0                	add    %edx,%eax
  80163b:	48                   	dec    %eax
  80163c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80163f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801642:	ba 00 00 00 00       	mov    $0x0,%edx
  801647:	f7 75 ec             	divl   -0x14(%ebp)
  80164a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80164d:	29 d0                	sub    %edx,%eax
  80164f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801652:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80165c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801661:	2d 00 10 00 00       	sub    $0x1000,%eax
  801666:	83 ec 04             	sub    $0x4,%esp
  801669:	6a 03                	push   $0x3
  80166b:	ff 75 f4             	pushl  -0xc(%ebp)
  80166e:	50                   	push   %eax
  80166f:	e8 b5 03 00 00       	call   801a29 <sys_allocate_chunk>
  801674:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801677:	a1 20 51 80 00       	mov    0x805120,%eax
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	50                   	push   %eax
  801680:	e8 2a 0a 00 00       	call   8020af <initialize_MemBlocksList>
  801685:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801688:	a1 48 51 80 00       	mov    0x805148,%eax
  80168d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801693:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80169a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8016a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016a8:	75 14                	jne    8016be <initialize_dyn_block_system+0x105>
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	68 75 42 80 00       	push   $0x804275
  8016b2:	6a 33                	push   $0x33
  8016b4:	68 93 42 80 00       	push   $0x804293
  8016b9:	e8 8c ee ff ff       	call   80054a <_panic>
  8016be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	74 10                	je     8016d7 <initialize_dyn_block_system+0x11e>
  8016c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ca:	8b 00                	mov    (%eax),%eax
  8016cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016cf:	8b 52 04             	mov    0x4(%edx),%edx
  8016d2:	89 50 04             	mov    %edx,0x4(%eax)
  8016d5:	eb 0b                	jmp    8016e2 <initialize_dyn_block_system+0x129>
  8016d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016da:	8b 40 04             	mov    0x4(%eax),%eax
  8016dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8016e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e5:	8b 40 04             	mov    0x4(%eax),%eax
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	74 0f                	je     8016fb <initialize_dyn_block_system+0x142>
  8016ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ef:	8b 40 04             	mov    0x4(%eax),%eax
  8016f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016f5:	8b 12                	mov    (%edx),%edx
  8016f7:	89 10                	mov    %edx,(%eax)
  8016f9:	eb 0a                	jmp    801705 <initialize_dyn_block_system+0x14c>
  8016fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016fe:	8b 00                	mov    (%eax),%eax
  801700:	a3 48 51 80 00       	mov    %eax,0x805148
  801705:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80170e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801718:	a1 54 51 80 00       	mov    0x805154,%eax
  80171d:	48                   	dec    %eax
  80171e:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801723:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801727:	75 14                	jne    80173d <initialize_dyn_block_system+0x184>
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	68 a0 42 80 00       	push   $0x8042a0
  801731:	6a 34                	push   $0x34
  801733:	68 93 42 80 00       	push   $0x804293
  801738:	e8 0d ee ff ff       	call   80054a <_panic>
  80173d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801743:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801746:	89 10                	mov    %edx,(%eax)
  801748:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174b:	8b 00                	mov    (%eax),%eax
  80174d:	85 c0                	test   %eax,%eax
  80174f:	74 0d                	je     80175e <initialize_dyn_block_system+0x1a5>
  801751:	a1 38 51 80 00       	mov    0x805138,%eax
  801756:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801759:	89 50 04             	mov    %edx,0x4(%eax)
  80175c:	eb 08                	jmp    801766 <initialize_dyn_block_system+0x1ad>
  80175e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801761:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801766:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801769:	a3 38 51 80 00       	mov    %eax,0x805138
  80176e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801771:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801778:	a1 44 51 80 00       	mov    0x805144,%eax
  80177d:	40                   	inc    %eax
  80177e:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801783:	90                   	nop
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178c:	e8 f7 fd ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  801791:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801795:	75 07                	jne    80179e <malloc+0x18>
  801797:	b8 00 00 00 00       	mov    $0x0,%eax
  80179c:	eb 14                	jmp    8017b2 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	68 c4 42 80 00       	push   $0x8042c4
  8017a6:	6a 46                	push   $0x46
  8017a8:	68 93 42 80 00       	push   $0x804293
  8017ad:	e8 98 ed ff ff       	call   80054a <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	68 ec 42 80 00       	push   $0x8042ec
  8017c2:	6a 61                	push   $0x61
  8017c4:	68 93 42 80 00       	push   $0x804293
  8017c9:	e8 7c ed ff ff       	call   80054a <_panic>

008017ce <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 18             	sub    $0x18,%esp
  8017d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d7:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017da:	e8 a9 fd ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e3:	75 07                	jne    8017ec <smalloc+0x1e>
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ea:	eb 14                	jmp    801800 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8017ec:	83 ec 04             	sub    $0x4,%esp
  8017ef:	68 10 43 80 00       	push   $0x804310
  8017f4:	6a 76                	push   $0x76
  8017f6:	68 93 42 80 00       	push   $0x804293
  8017fb:	e8 4a ed ff ff       	call   80054a <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801808:	e8 7b fd ff ff       	call   801588 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	68 38 43 80 00       	push   $0x804338
  801815:	68 93 00 00 00       	push   $0x93
  80181a:	68 93 42 80 00       	push   $0x804293
  80181f:	e8 26 ed ff ff       	call   80054a <_panic>

00801824 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182a:	e8 59 fd ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	68 5c 43 80 00       	push   $0x80435c
  801837:	68 c5 00 00 00       	push   $0xc5
  80183c:	68 93 42 80 00       	push   $0x804293
  801841:	e8 04 ed ff ff       	call   80054a <_panic>

00801846 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	68 84 43 80 00       	push   $0x804384
  801854:	68 d9 00 00 00       	push   $0xd9
  801859:	68 93 42 80 00       	push   $0x804293
  80185e:	e8 e7 ec ff ff       	call   80054a <_panic>

00801863 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	68 a8 43 80 00       	push   $0x8043a8
  801871:	68 e4 00 00 00       	push   $0xe4
  801876:	68 93 42 80 00       	push   $0x804293
  80187b:	e8 ca ec ff ff       	call   80054a <_panic>

00801880 <shrink>:

}
void shrink(uint32 newSize)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	68 a8 43 80 00       	push   $0x8043a8
  80188e:	68 e9 00 00 00       	push   $0xe9
  801893:	68 93 42 80 00       	push   $0x804293
  801898:	e8 ad ec ff ff       	call   80054a <_panic>

0080189d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a3:	83 ec 04             	sub    $0x4,%esp
  8018a6:	68 a8 43 80 00       	push   $0x8043a8
  8018ab:	68 ee 00 00 00       	push   $0xee
  8018b0:	68 93 42 80 00       	push   $0x804293
  8018b5:	e8 90 ec ff ff       	call   80054a <_panic>

008018ba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	57                   	push   %edi
  8018be:	56                   	push   %esi
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018d2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d5:	cd 30                	int    $0x30
  8018d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	5b                   	pop    %ebx
  8018e1:	5e                   	pop    %esi
  8018e2:	5f                   	pop    %edi
  8018e3:	5d                   	pop    %ebp
  8018e4:	c3                   	ret    

008018e5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018f1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	52                   	push   %edx
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	50                   	push   %eax
  801901:	6a 00                	push   $0x0
  801903:	e8 b2 ff ff ff       	call   8018ba <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	90                   	nop
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_cgetc>:

int
sys_cgetc(void)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 01                	push   $0x1
  80191d:	e8 98 ff ff ff       	call   8018ba <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80192a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	6a 05                	push   $0x5
  80193a:	e8 7b ff ff ff       	call   8018ba <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	56                   	push   %esi
  801948:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801949:	8b 75 18             	mov    0x18(%ebp),%esi
  80194c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801952:	8b 55 0c             	mov    0xc(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	56                   	push   %esi
  801959:	53                   	push   %ebx
  80195a:	51                   	push   %ecx
  80195b:	52                   	push   %edx
  80195c:	50                   	push   %eax
  80195d:	6a 06                	push   $0x6
  80195f:	e8 56 ff ff ff       	call   8018ba <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196a:	5b                   	pop    %ebx
  80196b:	5e                   	pop    %esi
  80196c:	5d                   	pop    %ebp
  80196d:	c3                   	ret    

0080196e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801971:	8b 55 0c             	mov    0xc(%ebp),%edx
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	52                   	push   %edx
  80197e:	50                   	push   %eax
  80197f:	6a 07                	push   $0x7
  801981:	e8 34 ff ff ff       	call   8018ba <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	ff 75 08             	pushl  0x8(%ebp)
  80199a:	6a 08                	push   $0x8
  80199c:	e8 19 ff ff ff       	call   8018ba <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 09                	push   $0x9
  8019b5:	e8 00 ff ff ff       	call   8018ba <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 0a                	push   $0xa
  8019ce:	e8 e7 fe ff ff       	call   8018ba <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 0b                	push   $0xb
  8019e7:	e8 ce fe ff ff       	call   8018ba <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	ff 75 0c             	pushl  0xc(%ebp)
  8019fd:	ff 75 08             	pushl  0x8(%ebp)
  801a00:	6a 0f                	push   $0xf
  801a02:	e8 b3 fe ff ff       	call   8018ba <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
	return;
  801a0a:	90                   	nop
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	ff 75 08             	pushl  0x8(%ebp)
  801a1c:	6a 10                	push   $0x10
  801a1e:	e8 97 fe ff ff       	call   8018ba <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
	return ;
  801a26:	90                   	nop
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	ff 75 10             	pushl  0x10(%ebp)
  801a33:	ff 75 0c             	pushl  0xc(%ebp)
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	6a 11                	push   $0x11
  801a3b:	e8 7a fe ff ff       	call   8018ba <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
	return ;
  801a43:	90                   	nop
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 0c                	push   $0xc
  801a55:	e8 60 fe ff ff       	call   8018ba <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	ff 75 08             	pushl  0x8(%ebp)
  801a6d:	6a 0d                	push   $0xd
  801a6f:	e8 46 fe ff ff       	call   8018ba <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 0e                	push   $0xe
  801a88:	e8 2d fe ff ff       	call   8018ba <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	90                   	nop
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 13                	push   $0x13
  801aa2:	e8 13 fe ff ff       	call   8018ba <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	90                   	nop
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 14                	push   $0x14
  801abc:	e8 f9 fd ff ff       	call   8018ba <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 04             	sub    $0x4,%esp
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	50                   	push   %eax
  801ae0:	6a 15                	push   $0x15
  801ae2:	e8 d3 fd ff ff       	call   8018ba <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	90                   	nop
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 16                	push   $0x16
  801afc:	e8 b9 fd ff ff       	call   8018ba <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	90                   	nop
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	ff 75 0c             	pushl  0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	6a 17                	push   $0x17
  801b19:	e8 9c fd ff ff       	call   8018ba <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	52                   	push   %edx
  801b33:	50                   	push   %eax
  801b34:	6a 1a                	push   $0x1a
  801b36:	e8 7f fd ff ff       	call   8018ba <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 18                	push   $0x18
  801b53:	e8 62 fd ff ff       	call   8018ba <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	90                   	nop
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	52                   	push   %edx
  801b6e:	50                   	push   %eax
  801b6f:	6a 19                	push   $0x19
  801b71:	e8 44 fd ff ff       	call   8018ba <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	90                   	nop
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 04             	sub    $0x4,%esp
  801b82:	8b 45 10             	mov    0x10(%ebp),%eax
  801b85:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b88:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b8b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	51                   	push   %ecx
  801b95:	52                   	push   %edx
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	50                   	push   %eax
  801b9a:	6a 1b                	push   $0x1b
  801b9c:	e8 19 fd ff ff       	call   8018ba <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ba9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	52                   	push   %edx
  801bb6:	50                   	push   %eax
  801bb7:	6a 1c                	push   $0x1c
  801bb9:	e8 fc fc ff ff       	call   8018ba <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	51                   	push   %ecx
  801bd4:	52                   	push   %edx
  801bd5:	50                   	push   %eax
  801bd6:	6a 1d                	push   $0x1d
  801bd8:	e8 dd fc ff ff       	call   8018ba <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 1e                	push   $0x1e
  801bf5:	e8 c0 fc ff ff       	call   8018ba <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 1f                	push   $0x1f
  801c0e:	e8 a7 fc ff ff       	call   8018ba <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	6a 00                	push   $0x0
  801c20:	ff 75 14             	pushl  0x14(%ebp)
  801c23:	ff 75 10             	pushl  0x10(%ebp)
  801c26:	ff 75 0c             	pushl  0xc(%ebp)
  801c29:	50                   	push   %eax
  801c2a:	6a 20                	push   $0x20
  801c2c:	e8 89 fc ff ff       	call   8018ba <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	50                   	push   %eax
  801c45:	6a 21                	push   $0x21
  801c47:	e8 6e fc ff ff       	call   8018ba <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	90                   	nop
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	50                   	push   %eax
  801c61:	6a 22                	push   $0x22
  801c63:	e8 52 fc ff ff       	call   8018ba <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 02                	push   $0x2
  801c7c:	e8 39 fc ff ff       	call   8018ba <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 03                	push   $0x3
  801c95:	e8 20 fc ff ff       	call   8018ba <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 04                	push   $0x4
  801cae:	e8 07 fc ff ff       	call   8018ba <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_exit_env>:


void sys_exit_env(void)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 23                	push   $0x23
  801cc7:	e8 ee fb ff ff       	call   8018ba <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	90                   	nop
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cd8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cdb:	8d 50 04             	lea    0x4(%eax),%edx
  801cde:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	52                   	push   %edx
  801ce8:	50                   	push   %eax
  801ce9:	6a 24                	push   $0x24
  801ceb:	e8 ca fb ff ff       	call   8018ba <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return result;
  801cf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfc:	89 01                	mov    %eax,(%ecx)
  801cfe:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	c9                   	leave  
  801d05:	c2 04 00             	ret    $0x4

00801d08 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	ff 75 10             	pushl  0x10(%ebp)
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	ff 75 08             	pushl  0x8(%ebp)
  801d18:	6a 12                	push   $0x12
  801d1a:	e8 9b fb ff ff       	call   8018ba <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d22:	90                   	nop
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 25                	push   $0x25
  801d34:	e8 81 fb ff ff       	call   8018ba <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 04             	sub    $0x4,%esp
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d4a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	50                   	push   %eax
  801d57:	6a 26                	push   $0x26
  801d59:	e8 5c fb ff ff       	call   8018ba <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d61:	90                   	nop
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <rsttst>:
void rsttst()
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 28                	push   $0x28
  801d73:	e8 42 fb ff ff       	call   8018ba <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7b:	90                   	nop
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 04             	sub    $0x4,%esp
  801d84:	8b 45 14             	mov    0x14(%ebp),%eax
  801d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d8a:	8b 55 18             	mov    0x18(%ebp),%edx
  801d8d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d91:	52                   	push   %edx
  801d92:	50                   	push   %eax
  801d93:	ff 75 10             	pushl  0x10(%ebp)
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	ff 75 08             	pushl  0x8(%ebp)
  801d9c:	6a 27                	push   $0x27
  801d9e:	e8 17 fb ff ff       	call   8018ba <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
	return ;
  801da6:	90                   	nop
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <chktst>:
void chktst(uint32 n)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	ff 75 08             	pushl  0x8(%ebp)
  801db7:	6a 29                	push   $0x29
  801db9:	e8 fc fa ff ff       	call   8018ba <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc1:	90                   	nop
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <inctst>:

void inctst()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 2a                	push   $0x2a
  801dd3:	e8 e2 fa ff ff       	call   8018ba <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddb:	90                   	nop
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <gettst>:
uint32 gettst()
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 2b                	push   $0x2b
  801ded:	e8 c8 fa ff ff       	call   8018ba <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 2c                	push   $0x2c
  801e09:	e8 ac fa ff ff       	call   8018ba <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
  801e11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e14:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e18:	75 07                	jne    801e21 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1f:	eb 05                	jmp    801e26 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 2c                	push   $0x2c
  801e3a:	e8 7b fa ff ff       	call   8018ba <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
  801e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e45:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e49:	75 07                	jne    801e52 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e50:	eb 05                	jmp    801e57 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 2c                	push   $0x2c
  801e6b:	e8 4a fa ff ff       	call   8018ba <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
  801e73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e76:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e7a:	75 07                	jne    801e83 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e81:	eb 05                	jmp    801e88 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 2c                	push   $0x2c
  801e9c:	e8 19 fa ff ff       	call   8018ba <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
  801ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ea7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eab:	75 07                	jne    801eb4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ead:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb2:	eb 05                	jmp    801eb9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	ff 75 08             	pushl  0x8(%ebp)
  801ec9:	6a 2d                	push   $0x2d
  801ecb:	e8 ea f9 ff ff       	call   8018ba <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed3:	90                   	nop
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eda:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801edd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	53                   	push   %ebx
  801ee9:	51                   	push   %ecx
  801eea:	52                   	push   %edx
  801eeb:	50                   	push   %eax
  801eec:	6a 2e                	push   $0x2e
  801eee:	e8 c7 f9 ff ff       	call   8018ba <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801efe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	52                   	push   %edx
  801f0b:	50                   	push   %eax
  801f0c:	6a 2f                	push   $0x2f
  801f0e:	e8 a7 f9 ff ff       	call   8018ba <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f1e:	83 ec 0c             	sub    $0xc,%esp
  801f21:	68 b8 43 80 00       	push   $0x8043b8
  801f26:	e8 d3 e8 ff ff       	call   8007fe <cprintf>
  801f2b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f35:	83 ec 0c             	sub    $0xc,%esp
  801f38:	68 e4 43 80 00       	push   $0x8043e4
  801f3d:	e8 bc e8 ff ff       	call   8007fe <cprintf>
  801f42:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f45:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f49:	a1 38 51 80 00       	mov    0x805138,%eax
  801f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f51:	eb 56                	jmp    801fa9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f57:	74 1c                	je     801f75 <print_mem_block_lists+0x5d>
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	8b 50 08             	mov    0x8(%eax),%edx
  801f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f62:	8b 48 08             	mov    0x8(%eax),%ecx
  801f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f68:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6b:	01 c8                	add    %ecx,%eax
  801f6d:	39 c2                	cmp    %eax,%edx
  801f6f:	73 04                	jae    801f75 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f71:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f78:	8b 50 08             	mov    0x8(%eax),%edx
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f81:	01 c2                	add    %eax,%edx
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	8b 40 08             	mov    0x8(%eax),%eax
  801f89:	83 ec 04             	sub    $0x4,%esp
  801f8c:	52                   	push   %edx
  801f8d:	50                   	push   %eax
  801f8e:	68 f9 43 80 00       	push   $0x8043f9
  801f93:	e8 66 e8 ff ff       	call   8007fe <cprintf>
  801f98:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fa1:	a1 40 51 80 00       	mov    0x805140,%eax
  801fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fad:	74 07                	je     801fb6 <print_mem_block_lists+0x9e>
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 00                	mov    (%eax),%eax
  801fb4:	eb 05                	jmp    801fbb <print_mem_block_lists+0xa3>
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbb:	a3 40 51 80 00       	mov    %eax,0x805140
  801fc0:	a1 40 51 80 00       	mov    0x805140,%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	75 8a                	jne    801f53 <print_mem_block_lists+0x3b>
  801fc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcd:	75 84                	jne    801f53 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fcf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fd3:	75 10                	jne    801fe5 <print_mem_block_lists+0xcd>
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	68 08 44 80 00       	push   $0x804408
  801fdd:	e8 1c e8 ff ff       	call   8007fe <cprintf>
  801fe2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fe5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fec:	83 ec 0c             	sub    $0xc,%esp
  801fef:	68 2c 44 80 00       	push   $0x80442c
  801ff4:	e8 05 e8 ff ff       	call   8007fe <cprintf>
  801ff9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ffc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802000:	a1 40 50 80 00       	mov    0x805040,%eax
  802005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802008:	eb 56                	jmp    802060 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80200a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200e:	74 1c                	je     80202c <print_mem_block_lists+0x114>
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	8b 50 08             	mov    0x8(%eax),%edx
  802016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802019:	8b 48 08             	mov    0x8(%eax),%ecx
  80201c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201f:	8b 40 0c             	mov    0xc(%eax),%eax
  802022:	01 c8                	add    %ecx,%eax
  802024:	39 c2                	cmp    %eax,%edx
  802026:	73 04                	jae    80202c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802028:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	8b 50 08             	mov    0x8(%eax),%edx
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	8b 40 0c             	mov    0xc(%eax),%eax
  802038:	01 c2                	add    %eax,%edx
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	8b 40 08             	mov    0x8(%eax),%eax
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	52                   	push   %edx
  802044:	50                   	push   %eax
  802045:	68 f9 43 80 00       	push   $0x8043f9
  80204a:	e8 af e7 ff ff       	call   8007fe <cprintf>
  80204f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802058:	a1 48 50 80 00       	mov    0x805048,%eax
  80205d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802060:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802064:	74 07                	je     80206d <print_mem_block_lists+0x155>
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 00                	mov    (%eax),%eax
  80206b:	eb 05                	jmp    802072 <print_mem_block_lists+0x15a>
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
  802072:	a3 48 50 80 00       	mov    %eax,0x805048
  802077:	a1 48 50 80 00       	mov    0x805048,%eax
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 8a                	jne    80200a <print_mem_block_lists+0xf2>
  802080:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802084:	75 84                	jne    80200a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802086:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80208a:	75 10                	jne    80209c <print_mem_block_lists+0x184>
  80208c:	83 ec 0c             	sub    $0xc,%esp
  80208f:	68 44 44 80 00       	push   $0x804444
  802094:	e8 65 e7 ff ff       	call   8007fe <cprintf>
  802099:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	68 b8 43 80 00       	push   $0x8043b8
  8020a4:	e8 55 e7 ff ff       	call   8007fe <cprintf>
  8020a9:	83 c4 10             	add    $0x10,%esp

}
  8020ac:	90                   	nop
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020b5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020bc:	00 00 00 
  8020bf:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020c6:	00 00 00 
  8020c9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020d0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020da:	e9 9e 00 00 00       	jmp    80217d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020df:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e7:	c1 e2 04             	shl    $0x4,%edx
  8020ea:	01 d0                	add    %edx,%eax
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	75 14                	jne    802104 <initialize_MemBlocksList+0x55>
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	68 6c 44 80 00       	push   $0x80446c
  8020f8:	6a 46                	push   $0x46
  8020fa:	68 8f 44 80 00       	push   $0x80448f
  8020ff:	e8 46 e4 ff ff       	call   80054a <_panic>
  802104:	a1 50 50 80 00       	mov    0x805050,%eax
  802109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210c:	c1 e2 04             	shl    $0x4,%edx
  80210f:	01 d0                	add    %edx,%eax
  802111:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802117:	89 10                	mov    %edx,(%eax)
  802119:	8b 00                	mov    (%eax),%eax
  80211b:	85 c0                	test   %eax,%eax
  80211d:	74 18                	je     802137 <initialize_MemBlocksList+0x88>
  80211f:	a1 48 51 80 00       	mov    0x805148,%eax
  802124:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80212a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80212d:	c1 e1 04             	shl    $0x4,%ecx
  802130:	01 ca                	add    %ecx,%edx
  802132:	89 50 04             	mov    %edx,0x4(%eax)
  802135:	eb 12                	jmp    802149 <initialize_MemBlocksList+0x9a>
  802137:	a1 50 50 80 00       	mov    0x805050,%eax
  80213c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213f:	c1 e2 04             	shl    $0x4,%edx
  802142:	01 d0                	add    %edx,%eax
  802144:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802149:	a1 50 50 80 00       	mov    0x805050,%eax
  80214e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802151:	c1 e2 04             	shl    $0x4,%edx
  802154:	01 d0                	add    %edx,%eax
  802156:	a3 48 51 80 00       	mov    %eax,0x805148
  80215b:	a1 50 50 80 00       	mov    0x805050,%eax
  802160:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802163:	c1 e2 04             	shl    $0x4,%edx
  802166:	01 d0                	add    %edx,%eax
  802168:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216f:	a1 54 51 80 00       	mov    0x805154,%eax
  802174:	40                   	inc    %eax
  802175:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80217a:	ff 45 f4             	incl   -0xc(%ebp)
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	3b 45 08             	cmp    0x8(%ebp),%eax
  802183:	0f 82 56 ff ff ff    	jb     8020df <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802189:	90                   	nop
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	8b 00                	mov    (%eax),%eax
  802197:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80219a:	eb 19                	jmp    8021b5 <find_block+0x29>
	{
		if(va==point->sva)
  80219c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219f:	8b 40 08             	mov    0x8(%eax),%eax
  8021a2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021a5:	75 05                	jne    8021ac <find_block+0x20>
		   return point;
  8021a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021aa:	eb 36                	jmp    8021e2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8b 40 08             	mov    0x8(%eax),%eax
  8021b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b9:	74 07                	je     8021c2 <find_block+0x36>
  8021bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021be:	8b 00                	mov    (%eax),%eax
  8021c0:	eb 05                	jmp    8021c7 <find_block+0x3b>
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ca:	89 42 08             	mov    %eax,0x8(%edx)
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	8b 40 08             	mov    0x8(%eax),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	75 c5                	jne    80219c <find_block+0x10>
  8021d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021db:	75 bf                	jne    80219c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021ea:	a1 40 50 80 00       	mov    0x805040,%eax
  8021ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021f2:	a1 44 50 80 00       	mov    0x805044,%eax
  8021f7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802200:	74 24                	je     802226 <insert_sorted_allocList+0x42>
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	8b 50 08             	mov    0x8(%eax),%edx
  802208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220b:	8b 40 08             	mov    0x8(%eax),%eax
  80220e:	39 c2                	cmp    %eax,%edx
  802210:	76 14                	jbe    802226 <insert_sorted_allocList+0x42>
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	8b 50 08             	mov    0x8(%eax),%edx
  802218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221b:	8b 40 08             	mov    0x8(%eax),%eax
  80221e:	39 c2                	cmp    %eax,%edx
  802220:	0f 82 60 01 00 00    	jb     802386 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802226:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80222a:	75 65                	jne    802291 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80222c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802230:	75 14                	jne    802246 <insert_sorted_allocList+0x62>
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	68 6c 44 80 00       	push   $0x80446c
  80223a:	6a 6b                	push   $0x6b
  80223c:	68 8f 44 80 00       	push   $0x80448f
  802241:	e8 04 e3 ff ff       	call   80054a <_panic>
  802246:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	89 10                	mov    %edx,(%eax)
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	8b 00                	mov    (%eax),%eax
  802256:	85 c0                	test   %eax,%eax
  802258:	74 0d                	je     802267 <insert_sorted_allocList+0x83>
  80225a:	a1 40 50 80 00       	mov    0x805040,%eax
  80225f:	8b 55 08             	mov    0x8(%ebp),%edx
  802262:	89 50 04             	mov    %edx,0x4(%eax)
  802265:	eb 08                	jmp    80226f <insert_sorted_allocList+0x8b>
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	a3 44 50 80 00       	mov    %eax,0x805044
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	a3 40 50 80 00       	mov    %eax,0x805040
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802281:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802286:	40                   	inc    %eax
  802287:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80228c:	e9 dc 01 00 00       	jmp    80246d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	8b 50 08             	mov    0x8(%eax),%edx
  802297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229a:	8b 40 08             	mov    0x8(%eax),%eax
  80229d:	39 c2                	cmp    %eax,%edx
  80229f:	77 6c                	ja     80230d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022a5:	74 06                	je     8022ad <insert_sorted_allocList+0xc9>
  8022a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ab:	75 14                	jne    8022c1 <insert_sorted_allocList+0xdd>
  8022ad:	83 ec 04             	sub    $0x4,%esp
  8022b0:	68 a8 44 80 00       	push   $0x8044a8
  8022b5:	6a 6f                	push   $0x6f
  8022b7:	68 8f 44 80 00       	push   $0x80448f
  8022bc:	e8 89 e2 ff ff       	call   80054a <_panic>
  8022c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c4:	8b 50 04             	mov    0x4(%eax),%edx
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	89 50 04             	mov    %edx,0x4(%eax)
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d3:	89 10                	mov    %edx,(%eax)
  8022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d8:	8b 40 04             	mov    0x4(%eax),%eax
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	74 0d                	je     8022ec <insert_sorted_allocList+0x108>
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e8:	89 10                	mov    %edx,(%eax)
  8022ea:	eb 08                	jmp    8022f4 <insert_sorted_allocList+0x110>
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	a3 40 50 80 00       	mov    %eax,0x805040
  8022f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fa:	89 50 04             	mov    %edx,0x4(%eax)
  8022fd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802302:	40                   	inc    %eax
  802303:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802308:	e9 60 01 00 00       	jmp    80246d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	8b 50 08             	mov    0x8(%eax),%edx
  802313:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802316:	8b 40 08             	mov    0x8(%eax),%eax
  802319:	39 c2                	cmp    %eax,%edx
  80231b:	0f 82 4c 01 00 00    	jb     80246d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802325:	75 14                	jne    80233b <insert_sorted_allocList+0x157>
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 e0 44 80 00       	push   $0x8044e0
  80232f:	6a 73                	push   $0x73
  802331:	68 8f 44 80 00       	push   $0x80448f
  802336:	e8 0f e2 ff ff       	call   80054a <_panic>
  80233b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	89 50 04             	mov    %edx,0x4(%eax)
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	8b 40 04             	mov    0x4(%eax),%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	74 0c                	je     80235d <insert_sorted_allocList+0x179>
  802351:	a1 44 50 80 00       	mov    0x805044,%eax
  802356:	8b 55 08             	mov    0x8(%ebp),%edx
  802359:	89 10                	mov    %edx,(%eax)
  80235b:	eb 08                	jmp    802365 <insert_sorted_allocList+0x181>
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	a3 40 50 80 00       	mov    %eax,0x805040
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	a3 44 50 80 00       	mov    %eax,0x805044
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802376:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80237b:	40                   	inc    %eax
  80237c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802381:	e9 e7 00 00 00       	jmp    80246d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802389:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80238c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802393:	a1 40 50 80 00       	mov    0x805040,%eax
  802398:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239b:	e9 9d 00 00 00       	jmp    80243d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	8b 50 08             	mov    0x8(%eax),%edx
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 40 08             	mov    0x8(%eax),%eax
  8023b4:	39 c2                	cmp    %eax,%edx
  8023b6:	76 7d                	jbe    802435 <insert_sorted_allocList+0x251>
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8b 50 08             	mov    0x8(%eax),%edx
  8023be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c1:	8b 40 08             	mov    0x8(%eax),%eax
  8023c4:	39 c2                	cmp    %eax,%edx
  8023c6:	73 6d                	jae    802435 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cc:	74 06                	je     8023d4 <insert_sorted_allocList+0x1f0>
  8023ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d2:	75 14                	jne    8023e8 <insert_sorted_allocList+0x204>
  8023d4:	83 ec 04             	sub    $0x4,%esp
  8023d7:	68 04 45 80 00       	push   $0x804504
  8023dc:	6a 7f                	push   $0x7f
  8023de:	68 8f 44 80 00       	push   $0x80448f
  8023e3:	e8 62 e1 ff ff       	call   80054a <_panic>
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 10                	mov    (%eax),%edx
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	89 10                	mov    %edx,(%eax)
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	74 0b                	je     802406 <insert_sorted_allocList+0x222>
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	8b 55 08             	mov    0x8(%ebp),%edx
  802403:	89 50 04             	mov    %edx,0x4(%eax)
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 55 08             	mov    0x8(%ebp),%edx
  80240c:	89 10                	mov    %edx,(%eax)
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802414:	89 50 04             	mov    %edx,0x4(%eax)
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	75 08                	jne    802428 <insert_sorted_allocList+0x244>
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	a3 44 50 80 00       	mov    %eax,0x805044
  802428:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80242d:	40                   	inc    %eax
  80242e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802433:	eb 39                	jmp    80246e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802435:	a1 48 50 80 00       	mov    0x805048,%eax
  80243a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802441:	74 07                	je     80244a <insert_sorted_allocList+0x266>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	eb 05                	jmp    80244f <insert_sorted_allocList+0x26b>
  80244a:	b8 00 00 00 00       	mov    $0x0,%eax
  80244f:	a3 48 50 80 00       	mov    %eax,0x805048
  802454:	a1 48 50 80 00       	mov    0x805048,%eax
  802459:	85 c0                	test   %eax,%eax
  80245b:	0f 85 3f ff ff ff    	jne    8023a0 <insert_sorted_allocList+0x1bc>
  802461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802465:	0f 85 35 ff ff ff    	jne    8023a0 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80246b:	eb 01                	jmp    80246e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80246d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80246e:	90                   	nop
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802477:	a1 38 51 80 00       	mov    0x805138,%eax
  80247c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247f:	e9 85 01 00 00       	jmp    802609 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248d:	0f 82 6e 01 00 00    	jb     802601 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 0c             	mov    0xc(%eax),%eax
  802499:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249c:	0f 85 8a 00 00 00    	jne    80252c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a6:	75 17                	jne    8024bf <alloc_block_FF+0x4e>
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	68 38 45 80 00       	push   $0x804538
  8024b0:	68 93 00 00 00       	push   $0x93
  8024b5:	68 8f 44 80 00       	push   $0x80448f
  8024ba:	e8 8b e0 ff ff       	call   80054a <_panic>
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 10                	je     8024d8 <alloc_block_FF+0x67>
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d0:	8b 52 04             	mov    0x4(%edx),%edx
  8024d3:	89 50 04             	mov    %edx,0x4(%eax)
  8024d6:	eb 0b                	jmp    8024e3 <alloc_block_FF+0x72>
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 40 04             	mov    0x4(%eax),%eax
  8024de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 04             	mov    0x4(%eax),%eax
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	74 0f                	je     8024fc <alloc_block_FF+0x8b>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 40 04             	mov    0x4(%eax),%eax
  8024f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f6:	8b 12                	mov    (%edx),%edx
  8024f8:	89 10                	mov    %edx,(%eax)
  8024fa:	eb 0a                	jmp    802506 <alloc_block_FF+0x95>
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	a3 38 51 80 00       	mov    %eax,0x805138
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802519:	a1 44 51 80 00       	mov    0x805144,%eax
  80251e:	48                   	dec    %eax
  80251f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	e9 10 01 00 00       	jmp    80263c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 40 0c             	mov    0xc(%eax),%eax
  802532:	3b 45 08             	cmp    0x8(%ebp),%eax
  802535:	0f 86 c6 00 00 00    	jbe    802601 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80253b:	a1 48 51 80 00       	mov    0x805148,%eax
  802540:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 50 08             	mov    0x8(%eax),%edx
  802549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80254f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802552:	8b 55 08             	mov    0x8(%ebp),%edx
  802555:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802558:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80255c:	75 17                	jne    802575 <alloc_block_FF+0x104>
  80255e:	83 ec 04             	sub    $0x4,%esp
  802561:	68 38 45 80 00       	push   $0x804538
  802566:	68 9b 00 00 00       	push   $0x9b
  80256b:	68 8f 44 80 00       	push   $0x80448f
  802570:	e8 d5 df ff ff       	call   80054a <_panic>
  802575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	85 c0                	test   %eax,%eax
  80257c:	74 10                	je     80258e <alloc_block_FF+0x11d>
  80257e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802581:	8b 00                	mov    (%eax),%eax
  802583:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802586:	8b 52 04             	mov    0x4(%edx),%edx
  802589:	89 50 04             	mov    %edx,0x4(%eax)
  80258c:	eb 0b                	jmp    802599 <alloc_block_FF+0x128>
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	8b 40 04             	mov    0x4(%eax),%eax
  802594:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259c:	8b 40 04             	mov    0x4(%eax),%eax
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	74 0f                	je     8025b2 <alloc_block_FF+0x141>
  8025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a6:	8b 40 04             	mov    0x4(%eax),%eax
  8025a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ac:	8b 12                	mov    (%edx),%edx
  8025ae:	89 10                	mov    %edx,(%eax)
  8025b0:	eb 0a                	jmp    8025bc <alloc_block_FF+0x14b>
  8025b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b5:	8b 00                	mov    (%eax),%eax
  8025b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8025bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8025d4:	48                   	dec    %eax
  8025d5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 50 08             	mov    0x8(%eax),%edx
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	01 c2                	add    %eax,%edx
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f4:	89 c2                	mov    %eax,%edx
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	eb 3b                	jmp    80263c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802601:	a1 40 51 80 00       	mov    0x805140,%eax
  802606:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260d:	74 07                	je     802616 <alloc_block_FF+0x1a5>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	eb 05                	jmp    80261b <alloc_block_FF+0x1aa>
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
  80261b:	a3 40 51 80 00       	mov    %eax,0x805140
  802620:	a1 40 51 80 00       	mov    0x805140,%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	0f 85 57 fe ff ff    	jne    802484 <alloc_block_FF+0x13>
  80262d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802631:	0f 85 4d fe ff ff    	jne    802484 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
  802641:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802644:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80264b:	a1 38 51 80 00       	mov    0x805138,%eax
  802650:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802653:	e9 df 00 00 00       	jmp    802737 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 40 0c             	mov    0xc(%eax),%eax
  80265e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802661:	0f 82 c8 00 00 00    	jb     80272f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 0c             	mov    0xc(%eax),%eax
  80266d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802670:	0f 85 8a 00 00 00    	jne    802700 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267a:	75 17                	jne    802693 <alloc_block_BF+0x55>
  80267c:	83 ec 04             	sub    $0x4,%esp
  80267f:	68 38 45 80 00       	push   $0x804538
  802684:	68 b7 00 00 00       	push   $0xb7
  802689:	68 8f 44 80 00       	push   $0x80448f
  80268e:	e8 b7 de ff ff       	call   80054a <_panic>
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 00                	mov    (%eax),%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	74 10                	je     8026ac <alloc_block_BF+0x6e>
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a4:	8b 52 04             	mov    0x4(%edx),%edx
  8026a7:	89 50 04             	mov    %edx,0x4(%eax)
  8026aa:	eb 0b                	jmp    8026b7 <alloc_block_BF+0x79>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 40 04             	mov    0x4(%eax),%eax
  8026b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 04             	mov    0x4(%eax),%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	74 0f                	je     8026d0 <alloc_block_BF+0x92>
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 40 04             	mov    0x4(%eax),%eax
  8026c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ca:	8b 12                	mov    (%edx),%edx
  8026cc:	89 10                	mov    %edx,(%eax)
  8026ce:	eb 0a                	jmp    8026da <alloc_block_BF+0x9c>
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 00                	mov    (%eax),%eax
  8026d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8026f2:	48                   	dec    %eax
  8026f3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	e9 4d 01 00 00       	jmp    80284d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 0c             	mov    0xc(%eax),%eax
  802706:	3b 45 08             	cmp    0x8(%ebp),%eax
  802709:	76 24                	jbe    80272f <alloc_block_BF+0xf1>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 0c             	mov    0xc(%eax),%eax
  802711:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802714:	73 19                	jae    80272f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802716:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 40 0c             	mov    0xc(%eax),%eax
  802723:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 08             	mov    0x8(%eax),%eax
  80272c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80272f:	a1 40 51 80 00       	mov    0x805140,%eax
  802734:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273b:	74 07                	je     802744 <alloc_block_BF+0x106>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	eb 05                	jmp    802749 <alloc_block_BF+0x10b>
  802744:	b8 00 00 00 00       	mov    $0x0,%eax
  802749:	a3 40 51 80 00       	mov    %eax,0x805140
  80274e:	a1 40 51 80 00       	mov    0x805140,%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	0f 85 fd fe ff ff    	jne    802658 <alloc_block_BF+0x1a>
  80275b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275f:	0f 85 f3 fe ff ff    	jne    802658 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802765:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802769:	0f 84 d9 00 00 00    	je     802848 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80276f:	a1 48 51 80 00       	mov    0x805148,%eax
  802774:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802783:	8b 55 08             	mov    0x8(%ebp),%edx
  802786:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802789:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80278d:	75 17                	jne    8027a6 <alloc_block_BF+0x168>
  80278f:	83 ec 04             	sub    $0x4,%esp
  802792:	68 38 45 80 00       	push   $0x804538
  802797:	68 c7 00 00 00       	push   $0xc7
  80279c:	68 8f 44 80 00       	push   $0x80448f
  8027a1:	e8 a4 dd ff ff       	call   80054a <_panic>
  8027a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	74 10                	je     8027bf <alloc_block_BF+0x181>
  8027af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b7:	8b 52 04             	mov    0x4(%edx),%edx
  8027ba:	89 50 04             	mov    %edx,0x4(%eax)
  8027bd:	eb 0b                	jmp    8027ca <alloc_block_BF+0x18c>
  8027bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c2:	8b 40 04             	mov    0x4(%eax),%eax
  8027c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027cd:	8b 40 04             	mov    0x4(%eax),%eax
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	74 0f                	je     8027e3 <alloc_block_BF+0x1a5>
  8027d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d7:	8b 40 04             	mov    0x4(%eax),%eax
  8027da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027dd:	8b 12                	mov    (%edx),%edx
  8027df:	89 10                	mov    %edx,(%eax)
  8027e1:	eb 0a                	jmp    8027ed <alloc_block_BF+0x1af>
  8027e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8027ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802800:	a1 54 51 80 00       	mov    0x805154,%eax
  802805:	48                   	dec    %eax
  802806:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80280b:	83 ec 08             	sub    $0x8,%esp
  80280e:	ff 75 ec             	pushl  -0x14(%ebp)
  802811:	68 38 51 80 00       	push   $0x805138
  802816:	e8 71 f9 ff ff       	call   80218c <find_block>
  80281b:	83 c4 10             	add    $0x10,%esp
  80281e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802821:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802824:	8b 50 08             	mov    0x8(%eax),%edx
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	01 c2                	add    %eax,%edx
  80282c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802832:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802835:	8b 40 0c             	mov    0xc(%eax),%eax
  802838:	2b 45 08             	sub    0x8(%ebp),%eax
  80283b:	89 c2                	mov    %eax,%edx
  80283d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802840:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802846:	eb 05                	jmp    80284d <alloc_block_BF+0x20f>
	}
	return NULL;
  802848:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80284d:	c9                   	leave  
  80284e:	c3                   	ret    

0080284f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
  802852:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802855:	a1 28 50 80 00       	mov    0x805028,%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	0f 85 de 01 00 00    	jne    802a40 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802862:	a1 38 51 80 00       	mov    0x805138,%eax
  802867:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286a:	e9 9e 01 00 00       	jmp    802a0d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 40 0c             	mov    0xc(%eax),%eax
  802875:	3b 45 08             	cmp    0x8(%ebp),%eax
  802878:	0f 82 87 01 00 00    	jb     802a05 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 40 0c             	mov    0xc(%eax),%eax
  802884:	3b 45 08             	cmp    0x8(%ebp),%eax
  802887:	0f 85 95 00 00 00    	jne    802922 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80288d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802891:	75 17                	jne    8028aa <alloc_block_NF+0x5b>
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 38 45 80 00       	push   $0x804538
  80289b:	68 e0 00 00 00       	push   $0xe0
  8028a0:	68 8f 44 80 00       	push   $0x80448f
  8028a5:	e8 a0 dc ff ff       	call   80054a <_panic>
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 00                	mov    (%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 10                	je     8028c3 <alloc_block_NF+0x74>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bb:	8b 52 04             	mov    0x4(%edx),%edx
  8028be:	89 50 04             	mov    %edx,0x4(%eax)
  8028c1:	eb 0b                	jmp    8028ce <alloc_block_NF+0x7f>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 04             	mov    0x4(%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 0f                	je     8028e7 <alloc_block_NF+0x98>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e1:	8b 12                	mov    (%edx),%edx
  8028e3:	89 10                	mov    %edx,(%eax)
  8028e5:	eb 0a                	jmp    8028f1 <alloc_block_NF+0xa2>
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	a3 38 51 80 00       	mov    %eax,0x805138
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802904:	a1 44 51 80 00       	mov    0x805144,%eax
  802909:	48                   	dec    %eax
  80290a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 08             	mov    0x8(%eax),%eax
  802915:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	e9 f8 04 00 00       	jmp    802e1a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 40 0c             	mov    0xc(%eax),%eax
  802928:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292b:	0f 86 d4 00 00 00    	jbe    802a05 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802931:	a1 48 51 80 00       	mov    0x805148,%eax
  802936:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 50 08             	mov    0x8(%eax),%edx
  80293f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802942:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802948:	8b 55 08             	mov    0x8(%ebp),%edx
  80294b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80294e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802952:	75 17                	jne    80296b <alloc_block_NF+0x11c>
  802954:	83 ec 04             	sub    $0x4,%esp
  802957:	68 38 45 80 00       	push   $0x804538
  80295c:	68 e9 00 00 00       	push   $0xe9
  802961:	68 8f 44 80 00       	push   $0x80448f
  802966:	e8 df db ff ff       	call   80054a <_panic>
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	85 c0                	test   %eax,%eax
  802972:	74 10                	je     802984 <alloc_block_NF+0x135>
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297c:	8b 52 04             	mov    0x4(%edx),%edx
  80297f:	89 50 04             	mov    %edx,0x4(%eax)
  802982:	eb 0b                	jmp    80298f <alloc_block_NF+0x140>
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	8b 40 04             	mov    0x4(%eax),%eax
  80298a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802992:	8b 40 04             	mov    0x4(%eax),%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	74 0f                	je     8029a8 <alloc_block_NF+0x159>
  802999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299c:	8b 40 04             	mov    0x4(%eax),%eax
  80299f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a2:	8b 12                	mov    (%edx),%edx
  8029a4:	89 10                	mov    %edx,(%eax)
  8029a6:	eb 0a                	jmp    8029b2 <alloc_block_NF+0x163>
  8029a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ab:	8b 00                	mov    (%eax),%eax
  8029ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8029b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8029ca:	48                   	dec    %eax
  8029cb:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	8b 40 08             	mov    0x8(%eax),%eax
  8029d6:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 50 08             	mov    0x8(%eax),%edx
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	01 c2                	add    %eax,%edx
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f2:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f5:	89 c2                	mov    %eax,%edx
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	e9 15 04 00 00       	jmp    802e1a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a05:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a11:	74 07                	je     802a1a <alloc_block_NF+0x1cb>
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 00                	mov    (%eax),%eax
  802a18:	eb 05                	jmp    802a1f <alloc_block_NF+0x1d0>
  802a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1f:	a3 40 51 80 00       	mov    %eax,0x805140
  802a24:	a1 40 51 80 00       	mov    0x805140,%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	0f 85 3e fe ff ff    	jne    80286f <alloc_block_NF+0x20>
  802a31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a35:	0f 85 34 fe ff ff    	jne    80286f <alloc_block_NF+0x20>
  802a3b:	e9 d5 03 00 00       	jmp    802e15 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a40:	a1 38 51 80 00       	mov    0x805138,%eax
  802a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a48:	e9 b1 01 00 00       	jmp    802bfe <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 50 08             	mov    0x8(%eax),%edx
  802a53:	a1 28 50 80 00       	mov    0x805028,%eax
  802a58:	39 c2                	cmp    %eax,%edx
  802a5a:	0f 82 96 01 00 00    	jb     802bf6 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 40 0c             	mov    0xc(%eax),%eax
  802a66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a69:	0f 82 87 01 00 00    	jb     802bf6 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 40 0c             	mov    0xc(%eax),%eax
  802a75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a78:	0f 85 95 00 00 00    	jne    802b13 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a82:	75 17                	jne    802a9b <alloc_block_NF+0x24c>
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	68 38 45 80 00       	push   $0x804538
  802a8c:	68 fc 00 00 00       	push   $0xfc
  802a91:	68 8f 44 80 00       	push   $0x80448f
  802a96:	e8 af da ff ff       	call   80054a <_panic>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	74 10                	je     802ab4 <alloc_block_NF+0x265>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aac:	8b 52 04             	mov    0x4(%edx),%edx
  802aaf:	89 50 04             	mov    %edx,0x4(%eax)
  802ab2:	eb 0b                	jmp    802abf <alloc_block_NF+0x270>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 40 04             	mov    0x4(%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 0f                	je     802ad8 <alloc_block_NF+0x289>
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad2:	8b 12                	mov    (%edx),%edx
  802ad4:	89 10                	mov    %edx,(%eax)
  802ad6:	eb 0a                	jmp    802ae2 <alloc_block_NF+0x293>
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	a3 38 51 80 00       	mov    %eax,0x805138
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af5:	a1 44 51 80 00       	mov    0x805144,%eax
  802afa:	48                   	dec    %eax
  802afb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 40 08             	mov    0x8(%eax),%eax
  802b06:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	e9 07 03 00 00       	jmp    802e1a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	8b 40 0c             	mov    0xc(%eax),%eax
  802b19:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1c:	0f 86 d4 00 00 00    	jbe    802bf6 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b22:	a1 48 51 80 00       	mov    0x805148,%eax
  802b27:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 50 08             	mov    0x8(%eax),%edx
  802b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b33:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b39:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b43:	75 17                	jne    802b5c <alloc_block_NF+0x30d>
  802b45:	83 ec 04             	sub    $0x4,%esp
  802b48:	68 38 45 80 00       	push   $0x804538
  802b4d:	68 04 01 00 00       	push   $0x104
  802b52:	68 8f 44 80 00       	push   $0x80448f
  802b57:	e8 ee d9 ff ff       	call   80054a <_panic>
  802b5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5f:	8b 00                	mov    (%eax),%eax
  802b61:	85 c0                	test   %eax,%eax
  802b63:	74 10                	je     802b75 <alloc_block_NF+0x326>
  802b65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b6d:	8b 52 04             	mov    0x4(%edx),%edx
  802b70:	89 50 04             	mov    %edx,0x4(%eax)
  802b73:	eb 0b                	jmp    802b80 <alloc_block_NF+0x331>
  802b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b78:	8b 40 04             	mov    0x4(%eax),%eax
  802b7b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b83:	8b 40 04             	mov    0x4(%eax),%eax
  802b86:	85 c0                	test   %eax,%eax
  802b88:	74 0f                	je     802b99 <alloc_block_NF+0x34a>
  802b8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8d:	8b 40 04             	mov    0x4(%eax),%eax
  802b90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b93:	8b 12                	mov    (%edx),%edx
  802b95:	89 10                	mov    %edx,(%eax)
  802b97:	eb 0a                	jmp    802ba3 <alloc_block_NF+0x354>
  802b99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802baf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb6:	a1 54 51 80 00       	mov    0x805154,%eax
  802bbb:	48                   	dec    %eax
  802bbc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc4:	8b 40 08             	mov    0x8(%eax),%eax
  802bc7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 50 08             	mov    0x8(%eax),%edx
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	01 c2                	add    %eax,%edx
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 0c             	mov    0xc(%eax),%eax
  802be3:	2b 45 08             	sub    0x8(%ebp),%eax
  802be6:	89 c2                	mov    %eax,%edx
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf1:	e9 24 02 00 00       	jmp    802e1a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bf6:	a1 40 51 80 00       	mov    0x805140,%eax
  802bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c02:	74 07                	je     802c0b <alloc_block_NF+0x3bc>
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	eb 05                	jmp    802c10 <alloc_block_NF+0x3c1>
  802c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c10:	a3 40 51 80 00       	mov    %eax,0x805140
  802c15:	a1 40 51 80 00       	mov    0x805140,%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	0f 85 2b fe ff ff    	jne    802a4d <alloc_block_NF+0x1fe>
  802c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c26:	0f 85 21 fe ff ff    	jne    802a4d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c2c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c34:	e9 ae 01 00 00       	jmp    802de7 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 50 08             	mov    0x8(%eax),%edx
  802c3f:	a1 28 50 80 00       	mov    0x805028,%eax
  802c44:	39 c2                	cmp    %eax,%edx
  802c46:	0f 83 93 01 00 00    	jae    802ddf <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c55:	0f 82 84 01 00 00    	jb     802ddf <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c61:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c64:	0f 85 95 00 00 00    	jne    802cff <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6e:	75 17                	jne    802c87 <alloc_block_NF+0x438>
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	68 38 45 80 00       	push   $0x804538
  802c78:	68 14 01 00 00       	push   $0x114
  802c7d:	68 8f 44 80 00       	push   $0x80448f
  802c82:	e8 c3 d8 ff ff       	call   80054a <_panic>
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 10                	je     802ca0 <alloc_block_NF+0x451>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c98:	8b 52 04             	mov    0x4(%edx),%edx
  802c9b:	89 50 04             	mov    %edx,0x4(%eax)
  802c9e:	eb 0b                	jmp    802cab <alloc_block_NF+0x45c>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	74 0f                	je     802cc4 <alloc_block_NF+0x475>
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbe:	8b 12                	mov    (%edx),%edx
  802cc0:	89 10                	mov    %edx,(%eax)
  802cc2:	eb 0a                	jmp    802cce <alloc_block_NF+0x47f>
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 00                	mov    (%eax),%eax
  802cc9:	a3 38 51 80 00       	mov    %eax,0x805138
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ce6:	48                   	dec    %eax
  802ce7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 40 08             	mov    0x8(%eax),%eax
  802cf2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	e9 1b 01 00 00       	jmp    802e1a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d08:	0f 86 d1 00 00 00    	jbe    802ddf <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d0e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 50 08             	mov    0x8(%eax),%edx
  802d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d25:	8b 55 08             	mov    0x8(%ebp),%edx
  802d28:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d2f:	75 17                	jne    802d48 <alloc_block_NF+0x4f9>
  802d31:	83 ec 04             	sub    $0x4,%esp
  802d34:	68 38 45 80 00       	push   $0x804538
  802d39:	68 1c 01 00 00       	push   $0x11c
  802d3e:	68 8f 44 80 00       	push   $0x80448f
  802d43:	e8 02 d8 ff ff       	call   80054a <_panic>
  802d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	85 c0                	test   %eax,%eax
  802d4f:	74 10                	je     802d61 <alloc_block_NF+0x512>
  802d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d59:	8b 52 04             	mov    0x4(%edx),%edx
  802d5c:	89 50 04             	mov    %edx,0x4(%eax)
  802d5f:	eb 0b                	jmp    802d6c <alloc_block_NF+0x51d>
  802d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d64:	8b 40 04             	mov    0x4(%eax),%eax
  802d67:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6f:	8b 40 04             	mov    0x4(%eax),%eax
  802d72:	85 c0                	test   %eax,%eax
  802d74:	74 0f                	je     802d85 <alloc_block_NF+0x536>
  802d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d79:	8b 40 04             	mov    0x4(%eax),%eax
  802d7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d7f:	8b 12                	mov    (%edx),%edx
  802d81:	89 10                	mov    %edx,(%eax)
  802d83:	eb 0a                	jmp    802d8f <alloc_block_NF+0x540>
  802d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	a3 48 51 80 00       	mov    %eax,0x805148
  802d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da2:	a1 54 51 80 00       	mov    0x805154,%eax
  802da7:	48                   	dec    %eax
  802da8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db0:	8b 40 08             	mov    0x8(%eax),%eax
  802db3:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	8b 50 08             	mov    0x8(%eax),%edx
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	01 c2                	add    %eax,%edx
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcf:	2b 45 08             	sub    0x8(%ebp),%eax
  802dd2:	89 c2                	mov    %eax,%edx
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddd:	eb 3b                	jmp    802e1a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ddf:	a1 40 51 80 00       	mov    0x805140,%eax
  802de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802deb:	74 07                	je     802df4 <alloc_block_NF+0x5a5>
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	eb 05                	jmp    802df9 <alloc_block_NF+0x5aa>
  802df4:	b8 00 00 00 00       	mov    $0x0,%eax
  802df9:	a3 40 51 80 00       	mov    %eax,0x805140
  802dfe:	a1 40 51 80 00       	mov    0x805140,%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	0f 85 2e fe ff ff    	jne    802c39 <alloc_block_NF+0x3ea>
  802e0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0f:	0f 85 24 fe ff ff    	jne    802c39 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e1a:	c9                   	leave  
  802e1b:	c3                   	ret    

00802e1c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e1c:	55                   	push   %ebp
  802e1d:	89 e5                	mov    %esp,%ebp
  802e1f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e22:	a1 38 51 80 00       	mov    0x805138,%eax
  802e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e2a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e2f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e32:	a1 38 51 80 00       	mov    0x805138,%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	74 14                	je     802e4f <insert_sorted_with_merge_freeList+0x33>
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	8b 50 08             	mov    0x8(%eax),%edx
  802e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e44:	8b 40 08             	mov    0x8(%eax),%eax
  802e47:	39 c2                	cmp    %eax,%edx
  802e49:	0f 87 9b 01 00 00    	ja     802fea <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e53:	75 17                	jne    802e6c <insert_sorted_with_merge_freeList+0x50>
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	68 6c 44 80 00       	push   $0x80446c
  802e5d:	68 38 01 00 00       	push   $0x138
  802e62:	68 8f 44 80 00       	push   $0x80448f
  802e67:	e8 de d6 ff ff       	call   80054a <_panic>
  802e6c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	89 10                	mov    %edx,(%eax)
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 0d                	je     802e8d <insert_sorted_with_merge_freeList+0x71>
  802e80:	a1 38 51 80 00       	mov    0x805138,%eax
  802e85:	8b 55 08             	mov    0x8(%ebp),%edx
  802e88:	89 50 04             	mov    %edx,0x4(%eax)
  802e8b:	eb 08                	jmp    802e95 <insert_sorted_with_merge_freeList+0x79>
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	a3 38 51 80 00       	mov    %eax,0x805138
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea7:	a1 44 51 80 00       	mov    0x805144,%eax
  802eac:	40                   	inc    %eax
  802ead:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb6:	0f 84 a8 06 00 00    	je     803564 <insert_sorted_with_merge_freeList+0x748>
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	8b 50 08             	mov    0x8(%eax),%edx
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec8:	01 c2                	add    %eax,%edx
  802eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecd:	8b 40 08             	mov    0x8(%eax),%eax
  802ed0:	39 c2                	cmp    %eax,%edx
  802ed2:	0f 85 8c 06 00 00    	jne    803564 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	8b 50 0c             	mov    0xc(%eax),%edx
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee4:	01 c2                	add    %eax,%edx
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802eec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef0:	75 17                	jne    802f09 <insert_sorted_with_merge_freeList+0xed>
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	68 38 45 80 00       	push   $0x804538
  802efa:	68 3c 01 00 00       	push   $0x13c
  802eff:	68 8f 44 80 00       	push   $0x80448f
  802f04:	e8 41 d6 ff ff       	call   80054a <_panic>
  802f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	74 10                	je     802f22 <insert_sorted_with_merge_freeList+0x106>
  802f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f1a:	8b 52 04             	mov    0x4(%edx),%edx
  802f1d:	89 50 04             	mov    %edx,0x4(%eax)
  802f20:	eb 0b                	jmp    802f2d <insert_sorted_with_merge_freeList+0x111>
  802f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	85 c0                	test   %eax,%eax
  802f35:	74 0f                	je     802f46 <insert_sorted_with_merge_freeList+0x12a>
  802f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3a:	8b 40 04             	mov    0x4(%eax),%eax
  802f3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f40:	8b 12                	mov    (%edx),%edx
  802f42:	89 10                	mov    %edx,(%eax)
  802f44:	eb 0a                	jmp    802f50 <insert_sorted_with_merge_freeList+0x134>
  802f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f63:	a1 44 51 80 00       	mov    0x805144,%eax
  802f68:	48                   	dec    %eax
  802f69:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f86:	75 17                	jne    802f9f <insert_sorted_with_merge_freeList+0x183>
  802f88:	83 ec 04             	sub    $0x4,%esp
  802f8b:	68 6c 44 80 00       	push   $0x80446c
  802f90:	68 3f 01 00 00       	push   $0x13f
  802f95:	68 8f 44 80 00       	push   $0x80448f
  802f9a:	e8 ab d5 ff ff       	call   80054a <_panic>
  802f9f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	74 0d                	je     802fc0 <insert_sorted_with_merge_freeList+0x1a4>
  802fb3:	a1 48 51 80 00       	mov    0x805148,%eax
  802fb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fbb:	89 50 04             	mov    %edx,0x4(%eax)
  802fbe:	eb 08                	jmp    802fc8 <insert_sorted_with_merge_freeList+0x1ac>
  802fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcb:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fda:	a1 54 51 80 00       	mov    0x805154,%eax
  802fdf:	40                   	inc    %eax
  802fe0:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fe5:	e9 7a 05 00 00       	jmp    803564 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	8b 50 08             	mov    0x8(%eax),%edx
  802ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff3:	8b 40 08             	mov    0x8(%eax),%eax
  802ff6:	39 c2                	cmp    %eax,%edx
  802ff8:	0f 82 14 01 00 00    	jb     803112 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803001:	8b 50 08             	mov    0x8(%eax),%edx
  803004:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803007:	8b 40 0c             	mov    0xc(%eax),%eax
  80300a:	01 c2                	add    %eax,%edx
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	8b 40 08             	mov    0x8(%eax),%eax
  803012:	39 c2                	cmp    %eax,%edx
  803014:	0f 85 90 00 00 00    	jne    8030aa <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80301a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301d:	8b 50 0c             	mov    0xc(%eax),%edx
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	8b 40 0c             	mov    0xc(%eax),%eax
  803026:	01 c2                	add    %eax,%edx
  803028:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803042:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803046:	75 17                	jne    80305f <insert_sorted_with_merge_freeList+0x243>
  803048:	83 ec 04             	sub    $0x4,%esp
  80304b:	68 6c 44 80 00       	push   $0x80446c
  803050:	68 49 01 00 00       	push   $0x149
  803055:	68 8f 44 80 00       	push   $0x80448f
  80305a:	e8 eb d4 ff ff       	call   80054a <_panic>
  80305f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	89 10                	mov    %edx,(%eax)
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	74 0d                	je     803080 <insert_sorted_with_merge_freeList+0x264>
  803073:	a1 48 51 80 00       	mov    0x805148,%eax
  803078:	8b 55 08             	mov    0x8(%ebp),%edx
  80307b:	89 50 04             	mov    %edx,0x4(%eax)
  80307e:	eb 08                	jmp    803088 <insert_sorted_with_merge_freeList+0x26c>
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	a3 48 51 80 00       	mov    %eax,0x805148
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309a:	a1 54 51 80 00       	mov    0x805154,%eax
  80309f:	40                   	inc    %eax
  8030a0:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030a5:	e9 bb 04 00 00       	jmp    803565 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ae:	75 17                	jne    8030c7 <insert_sorted_with_merge_freeList+0x2ab>
  8030b0:	83 ec 04             	sub    $0x4,%esp
  8030b3:	68 e0 44 80 00       	push   $0x8044e0
  8030b8:	68 4c 01 00 00       	push   $0x14c
  8030bd:	68 8f 44 80 00       	push   $0x80448f
  8030c2:	e8 83 d4 ff ff       	call   80054a <_panic>
  8030c7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	89 50 04             	mov    %edx,0x4(%eax)
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	8b 40 04             	mov    0x4(%eax),%eax
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	74 0c                	je     8030e9 <insert_sorted_with_merge_freeList+0x2cd>
  8030dd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e5:	89 10                	mov    %edx,(%eax)
  8030e7:	eb 08                	jmp    8030f1 <insert_sorted_with_merge_freeList+0x2d5>
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	a3 38 51 80 00       	mov    %eax,0x805138
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803102:	a1 44 51 80 00       	mov    0x805144,%eax
  803107:	40                   	inc    %eax
  803108:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80310d:	e9 53 04 00 00       	jmp    803565 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803112:	a1 38 51 80 00       	mov    0x805138,%eax
  803117:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80311a:	e9 15 04 00 00       	jmp    803534 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	8b 50 08             	mov    0x8(%eax),%edx
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	8b 40 08             	mov    0x8(%eax),%eax
  803133:	39 c2                	cmp    %eax,%edx
  803135:	0f 86 f1 03 00 00    	jbe    80352c <insert_sorted_with_merge_freeList+0x710>
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	8b 50 08             	mov    0x8(%eax),%edx
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	8b 40 08             	mov    0x8(%eax),%eax
  803147:	39 c2                	cmp    %eax,%edx
  803149:	0f 83 dd 03 00 00    	jae    80352c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 50 08             	mov    0x8(%eax),%edx
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	01 c2                	add    %eax,%edx
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	8b 40 08             	mov    0x8(%eax),%eax
  803163:	39 c2                	cmp    %eax,%edx
  803165:	0f 85 b9 01 00 00    	jne    803324 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	8b 50 08             	mov    0x8(%eax),%edx
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	8b 40 0c             	mov    0xc(%eax),%eax
  803177:	01 c2                	add    %eax,%edx
  803179:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317c:	8b 40 08             	mov    0x8(%eax),%eax
  80317f:	39 c2                	cmp    %eax,%edx
  803181:	0f 85 0d 01 00 00    	jne    803294 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	8b 50 0c             	mov    0xc(%eax),%edx
  80318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803190:	8b 40 0c             	mov    0xc(%eax),%eax
  803193:	01 c2                	add    %eax,%edx
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80319b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319f:	75 17                	jne    8031b8 <insert_sorted_with_merge_freeList+0x39c>
  8031a1:	83 ec 04             	sub    $0x4,%esp
  8031a4:	68 38 45 80 00       	push   $0x804538
  8031a9:	68 5c 01 00 00       	push   $0x15c
  8031ae:	68 8f 44 80 00       	push   $0x80448f
  8031b3:	e8 92 d3 ff ff       	call   80054a <_panic>
  8031b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	74 10                	je     8031d1 <insert_sorted_with_merge_freeList+0x3b5>
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c9:	8b 52 04             	mov    0x4(%edx),%edx
  8031cc:	89 50 04             	mov    %edx,0x4(%eax)
  8031cf:	eb 0b                	jmp    8031dc <insert_sorted_with_merge_freeList+0x3c0>
  8031d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d4:	8b 40 04             	mov    0x4(%eax),%eax
  8031d7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	8b 40 04             	mov    0x4(%eax),%eax
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	74 0f                	je     8031f5 <insert_sorted_with_merge_freeList+0x3d9>
  8031e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e9:	8b 40 04             	mov    0x4(%eax),%eax
  8031ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ef:	8b 12                	mov    (%edx),%edx
  8031f1:	89 10                	mov    %edx,(%eax)
  8031f3:	eb 0a                	jmp    8031ff <insert_sorted_with_merge_freeList+0x3e3>
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803212:	a1 44 51 80 00       	mov    0x805144,%eax
  803217:	48                   	dec    %eax
  803218:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803231:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803235:	75 17                	jne    80324e <insert_sorted_with_merge_freeList+0x432>
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	68 6c 44 80 00       	push   $0x80446c
  80323f:	68 5f 01 00 00       	push   $0x15f
  803244:	68 8f 44 80 00       	push   $0x80448f
  803249:	e8 fc d2 ff ff       	call   80054a <_panic>
  80324e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803254:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803257:	89 10                	mov    %edx,(%eax)
  803259:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325c:	8b 00                	mov    (%eax),%eax
  80325e:	85 c0                	test   %eax,%eax
  803260:	74 0d                	je     80326f <insert_sorted_with_merge_freeList+0x453>
  803262:	a1 48 51 80 00       	mov    0x805148,%eax
  803267:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326a:	89 50 04             	mov    %edx,0x4(%eax)
  80326d:	eb 08                	jmp    803277 <insert_sorted_with_merge_freeList+0x45b>
  80326f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803272:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	a3 48 51 80 00       	mov    %eax,0x805148
  80327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803282:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803289:	a1 54 51 80 00       	mov    0x805154,%eax
  80328e:	40                   	inc    %eax
  80328f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	8b 50 0c             	mov    0xc(%eax),%edx
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a0:	01 c2                	add    %eax,%edx
  8032a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a5:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c0:	75 17                	jne    8032d9 <insert_sorted_with_merge_freeList+0x4bd>
  8032c2:	83 ec 04             	sub    $0x4,%esp
  8032c5:	68 6c 44 80 00       	push   $0x80446c
  8032ca:	68 64 01 00 00       	push   $0x164
  8032cf:	68 8f 44 80 00       	push   $0x80448f
  8032d4:	e8 71 d2 ff ff       	call   80054a <_panic>
  8032d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	89 10                	mov    %edx,(%eax)
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	74 0d                	je     8032fa <insert_sorted_with_merge_freeList+0x4de>
  8032ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8032f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f5:	89 50 04             	mov    %edx,0x4(%eax)
  8032f8:	eb 08                	jmp    803302 <insert_sorted_with_merge_freeList+0x4e6>
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	a3 48 51 80 00       	mov    %eax,0x805148
  80330a:	8b 45 08             	mov    0x8(%ebp),%eax
  80330d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803314:	a1 54 51 80 00       	mov    0x805154,%eax
  803319:	40                   	inc    %eax
  80331a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80331f:	e9 41 02 00 00       	jmp    803565 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	8b 50 08             	mov    0x8(%eax),%edx
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	8b 40 0c             	mov    0xc(%eax),%eax
  803330:	01 c2                	add    %eax,%edx
  803332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803335:	8b 40 08             	mov    0x8(%eax),%eax
  803338:	39 c2                	cmp    %eax,%edx
  80333a:	0f 85 7c 01 00 00    	jne    8034bc <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803340:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803344:	74 06                	je     80334c <insert_sorted_with_merge_freeList+0x530>
  803346:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334a:	75 17                	jne    803363 <insert_sorted_with_merge_freeList+0x547>
  80334c:	83 ec 04             	sub    $0x4,%esp
  80334f:	68 a8 44 80 00       	push   $0x8044a8
  803354:	68 69 01 00 00       	push   $0x169
  803359:	68 8f 44 80 00       	push   $0x80448f
  80335e:	e8 e7 d1 ff ff       	call   80054a <_panic>
  803363:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803366:	8b 50 04             	mov    0x4(%eax),%edx
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	89 50 04             	mov    %edx,0x4(%eax)
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803375:	89 10                	mov    %edx,(%eax)
  803377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337a:	8b 40 04             	mov    0x4(%eax),%eax
  80337d:	85 c0                	test   %eax,%eax
  80337f:	74 0d                	je     80338e <insert_sorted_with_merge_freeList+0x572>
  803381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803384:	8b 40 04             	mov    0x4(%eax),%eax
  803387:	8b 55 08             	mov    0x8(%ebp),%edx
  80338a:	89 10                	mov    %edx,(%eax)
  80338c:	eb 08                	jmp    803396 <insert_sorted_with_merge_freeList+0x57a>
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	a3 38 51 80 00       	mov    %eax,0x805138
  803396:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803399:	8b 55 08             	mov    0x8(%ebp),%edx
  80339c:	89 50 04             	mov    %edx,0x4(%eax)
  80339f:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a4:	40                   	inc    %eax
  8033a5:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b6:	01 c2                	add    %eax,%edx
  8033b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bb:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c2:	75 17                	jne    8033db <insert_sorted_with_merge_freeList+0x5bf>
  8033c4:	83 ec 04             	sub    $0x4,%esp
  8033c7:	68 38 45 80 00       	push   $0x804538
  8033cc:	68 6b 01 00 00       	push   $0x16b
  8033d1:	68 8f 44 80 00       	push   $0x80448f
  8033d6:	e8 6f d1 ff ff       	call   80054a <_panic>
  8033db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	85 c0                	test   %eax,%eax
  8033e2:	74 10                	je     8033f4 <insert_sorted_with_merge_freeList+0x5d8>
  8033e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e7:	8b 00                	mov    (%eax),%eax
  8033e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ec:	8b 52 04             	mov    0x4(%edx),%edx
  8033ef:	89 50 04             	mov    %edx,0x4(%eax)
  8033f2:	eb 0b                	jmp    8033ff <insert_sorted_with_merge_freeList+0x5e3>
  8033f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f7:	8b 40 04             	mov    0x4(%eax),%eax
  8033fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803402:	8b 40 04             	mov    0x4(%eax),%eax
  803405:	85 c0                	test   %eax,%eax
  803407:	74 0f                	je     803418 <insert_sorted_with_merge_freeList+0x5fc>
  803409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340c:	8b 40 04             	mov    0x4(%eax),%eax
  80340f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803412:	8b 12                	mov    (%edx),%edx
  803414:	89 10                	mov    %edx,(%eax)
  803416:	eb 0a                	jmp    803422 <insert_sorted_with_merge_freeList+0x606>
  803418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341b:	8b 00                	mov    (%eax),%eax
  80341d:	a3 38 51 80 00       	mov    %eax,0x805138
  803422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803435:	a1 44 51 80 00       	mov    0x805144,%eax
  80343a:	48                   	dec    %eax
  80343b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803443:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80344a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803454:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803458:	75 17                	jne    803471 <insert_sorted_with_merge_freeList+0x655>
  80345a:	83 ec 04             	sub    $0x4,%esp
  80345d:	68 6c 44 80 00       	push   $0x80446c
  803462:	68 6e 01 00 00       	push   $0x16e
  803467:	68 8f 44 80 00       	push   $0x80448f
  80346c:	e8 d9 d0 ff ff       	call   80054a <_panic>
  803471:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803477:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347a:	89 10                	mov    %edx,(%eax)
  80347c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 0d                	je     803492 <insert_sorted_with_merge_freeList+0x676>
  803485:	a1 48 51 80 00       	mov    0x805148,%eax
  80348a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%eax)
  803490:	eb 08                	jmp    80349a <insert_sorted_with_merge_freeList+0x67e>
  803492:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803495:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80349a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349d:	a3 48 51 80 00       	mov    %eax,0x805148
  8034a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8034b1:	40                   	inc    %eax
  8034b2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034b7:	e9 a9 00 00 00       	jmp    803565 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c0:	74 06                	je     8034c8 <insert_sorted_with_merge_freeList+0x6ac>
  8034c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034c6:	75 17                	jne    8034df <insert_sorted_with_merge_freeList+0x6c3>
  8034c8:	83 ec 04             	sub    $0x4,%esp
  8034cb:	68 04 45 80 00       	push   $0x804504
  8034d0:	68 73 01 00 00       	push   $0x173
  8034d5:	68 8f 44 80 00       	push   $0x80448f
  8034da:	e8 6b d0 ff ff       	call   80054a <_panic>
  8034df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e2:	8b 10                	mov    (%eax),%edx
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	89 10                	mov    %edx,(%eax)
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	74 0b                	je     8034fd <insert_sorted_with_merge_freeList+0x6e1>
  8034f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f5:	8b 00                	mov    (%eax),%eax
  8034f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034fa:	89 50 04             	mov    %edx,0x4(%eax)
  8034fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803500:	8b 55 08             	mov    0x8(%ebp),%edx
  803503:	89 10                	mov    %edx,(%eax)
  803505:	8b 45 08             	mov    0x8(%ebp),%eax
  803508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80350b:	89 50 04             	mov    %edx,0x4(%eax)
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	8b 00                	mov    (%eax),%eax
  803513:	85 c0                	test   %eax,%eax
  803515:	75 08                	jne    80351f <insert_sorted_with_merge_freeList+0x703>
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80351f:	a1 44 51 80 00       	mov    0x805144,%eax
  803524:	40                   	inc    %eax
  803525:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80352a:	eb 39                	jmp    803565 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80352c:	a1 40 51 80 00       	mov    0x805140,%eax
  803531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803534:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803538:	74 07                	je     803541 <insert_sorted_with_merge_freeList+0x725>
  80353a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353d:	8b 00                	mov    (%eax),%eax
  80353f:	eb 05                	jmp    803546 <insert_sorted_with_merge_freeList+0x72a>
  803541:	b8 00 00 00 00       	mov    $0x0,%eax
  803546:	a3 40 51 80 00       	mov    %eax,0x805140
  80354b:	a1 40 51 80 00       	mov    0x805140,%eax
  803550:	85 c0                	test   %eax,%eax
  803552:	0f 85 c7 fb ff ff    	jne    80311f <insert_sorted_with_merge_freeList+0x303>
  803558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355c:	0f 85 bd fb ff ff    	jne    80311f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803562:	eb 01                	jmp    803565 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803564:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803565:	90                   	nop
  803566:	c9                   	leave  
  803567:	c3                   	ret    

00803568 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803568:	55                   	push   %ebp
  803569:	89 e5                	mov    %esp,%ebp
  80356b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80356e:	8b 55 08             	mov    0x8(%ebp),%edx
  803571:	89 d0                	mov    %edx,%eax
  803573:	c1 e0 02             	shl    $0x2,%eax
  803576:	01 d0                	add    %edx,%eax
  803578:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80357f:	01 d0                	add    %edx,%eax
  803581:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803588:	01 d0                	add    %edx,%eax
  80358a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803591:	01 d0                	add    %edx,%eax
  803593:	c1 e0 04             	shl    $0x4,%eax
  803596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8035a0:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8035a3:	83 ec 0c             	sub    $0xc,%esp
  8035a6:	50                   	push   %eax
  8035a7:	e8 26 e7 ff ff       	call   801cd2 <sys_get_virtual_time>
  8035ac:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8035af:	eb 41                	jmp    8035f2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8035b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8035b4:	83 ec 0c             	sub    $0xc,%esp
  8035b7:	50                   	push   %eax
  8035b8:	e8 15 e7 ff ff       	call   801cd2 <sys_get_virtual_time>
  8035bd:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8035c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c6:	29 c2                	sub    %eax,%edx
  8035c8:	89 d0                	mov    %edx,%eax
  8035ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8035cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d3:	89 d1                	mov    %edx,%ecx
  8035d5:	29 c1                	sub    %eax,%ecx
  8035d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035dd:	39 c2                	cmp    %eax,%edx
  8035df:	0f 97 c0             	seta   %al
  8035e2:	0f b6 c0             	movzbl %al,%eax
  8035e5:	29 c1                	sub    %eax,%ecx
  8035e7:	89 c8                	mov    %ecx,%eax
  8035e9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8035ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8035f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8035f8:	72 b7                	jb     8035b1 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8035fa:	90                   	nop
  8035fb:	c9                   	leave  
  8035fc:	c3                   	ret    

008035fd <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8035fd:	55                   	push   %ebp
  8035fe:	89 e5                	mov    %esp,%ebp
  803600:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80360a:	eb 03                	jmp    80360f <busy_wait+0x12>
  80360c:	ff 45 fc             	incl   -0x4(%ebp)
  80360f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803612:	3b 45 08             	cmp    0x8(%ebp),%eax
  803615:	72 f5                	jb     80360c <busy_wait+0xf>
	return i;
  803617:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80361a:	c9                   	leave  
  80361b:	c3                   	ret    

0080361c <__udivdi3>:
  80361c:	55                   	push   %ebp
  80361d:	57                   	push   %edi
  80361e:	56                   	push   %esi
  80361f:	53                   	push   %ebx
  803620:	83 ec 1c             	sub    $0x1c,%esp
  803623:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803627:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80362b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80362f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803633:	89 ca                	mov    %ecx,%edx
  803635:	89 f8                	mov    %edi,%eax
  803637:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80363b:	85 f6                	test   %esi,%esi
  80363d:	75 2d                	jne    80366c <__udivdi3+0x50>
  80363f:	39 cf                	cmp    %ecx,%edi
  803641:	77 65                	ja     8036a8 <__udivdi3+0x8c>
  803643:	89 fd                	mov    %edi,%ebp
  803645:	85 ff                	test   %edi,%edi
  803647:	75 0b                	jne    803654 <__udivdi3+0x38>
  803649:	b8 01 00 00 00       	mov    $0x1,%eax
  80364e:	31 d2                	xor    %edx,%edx
  803650:	f7 f7                	div    %edi
  803652:	89 c5                	mov    %eax,%ebp
  803654:	31 d2                	xor    %edx,%edx
  803656:	89 c8                	mov    %ecx,%eax
  803658:	f7 f5                	div    %ebp
  80365a:	89 c1                	mov    %eax,%ecx
  80365c:	89 d8                	mov    %ebx,%eax
  80365e:	f7 f5                	div    %ebp
  803660:	89 cf                	mov    %ecx,%edi
  803662:	89 fa                	mov    %edi,%edx
  803664:	83 c4 1c             	add    $0x1c,%esp
  803667:	5b                   	pop    %ebx
  803668:	5e                   	pop    %esi
  803669:	5f                   	pop    %edi
  80366a:	5d                   	pop    %ebp
  80366b:	c3                   	ret    
  80366c:	39 ce                	cmp    %ecx,%esi
  80366e:	77 28                	ja     803698 <__udivdi3+0x7c>
  803670:	0f bd fe             	bsr    %esi,%edi
  803673:	83 f7 1f             	xor    $0x1f,%edi
  803676:	75 40                	jne    8036b8 <__udivdi3+0x9c>
  803678:	39 ce                	cmp    %ecx,%esi
  80367a:	72 0a                	jb     803686 <__udivdi3+0x6a>
  80367c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803680:	0f 87 9e 00 00 00    	ja     803724 <__udivdi3+0x108>
  803686:	b8 01 00 00 00       	mov    $0x1,%eax
  80368b:	89 fa                	mov    %edi,%edx
  80368d:	83 c4 1c             	add    $0x1c,%esp
  803690:	5b                   	pop    %ebx
  803691:	5e                   	pop    %esi
  803692:	5f                   	pop    %edi
  803693:	5d                   	pop    %ebp
  803694:	c3                   	ret    
  803695:	8d 76 00             	lea    0x0(%esi),%esi
  803698:	31 ff                	xor    %edi,%edi
  80369a:	31 c0                	xor    %eax,%eax
  80369c:	89 fa                	mov    %edi,%edx
  80369e:	83 c4 1c             	add    $0x1c,%esp
  8036a1:	5b                   	pop    %ebx
  8036a2:	5e                   	pop    %esi
  8036a3:	5f                   	pop    %edi
  8036a4:	5d                   	pop    %ebp
  8036a5:	c3                   	ret    
  8036a6:	66 90                	xchg   %ax,%ax
  8036a8:	89 d8                	mov    %ebx,%eax
  8036aa:	f7 f7                	div    %edi
  8036ac:	31 ff                	xor    %edi,%edi
  8036ae:	89 fa                	mov    %edi,%edx
  8036b0:	83 c4 1c             	add    $0x1c,%esp
  8036b3:	5b                   	pop    %ebx
  8036b4:	5e                   	pop    %esi
  8036b5:	5f                   	pop    %edi
  8036b6:	5d                   	pop    %ebp
  8036b7:	c3                   	ret    
  8036b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036bd:	89 eb                	mov    %ebp,%ebx
  8036bf:	29 fb                	sub    %edi,%ebx
  8036c1:	89 f9                	mov    %edi,%ecx
  8036c3:	d3 e6                	shl    %cl,%esi
  8036c5:	89 c5                	mov    %eax,%ebp
  8036c7:	88 d9                	mov    %bl,%cl
  8036c9:	d3 ed                	shr    %cl,%ebp
  8036cb:	89 e9                	mov    %ebp,%ecx
  8036cd:	09 f1                	or     %esi,%ecx
  8036cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036d3:	89 f9                	mov    %edi,%ecx
  8036d5:	d3 e0                	shl    %cl,%eax
  8036d7:	89 c5                	mov    %eax,%ebp
  8036d9:	89 d6                	mov    %edx,%esi
  8036db:	88 d9                	mov    %bl,%cl
  8036dd:	d3 ee                	shr    %cl,%esi
  8036df:	89 f9                	mov    %edi,%ecx
  8036e1:	d3 e2                	shl    %cl,%edx
  8036e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036e7:	88 d9                	mov    %bl,%cl
  8036e9:	d3 e8                	shr    %cl,%eax
  8036eb:	09 c2                	or     %eax,%edx
  8036ed:	89 d0                	mov    %edx,%eax
  8036ef:	89 f2                	mov    %esi,%edx
  8036f1:	f7 74 24 0c          	divl   0xc(%esp)
  8036f5:	89 d6                	mov    %edx,%esi
  8036f7:	89 c3                	mov    %eax,%ebx
  8036f9:	f7 e5                	mul    %ebp
  8036fb:	39 d6                	cmp    %edx,%esi
  8036fd:	72 19                	jb     803718 <__udivdi3+0xfc>
  8036ff:	74 0b                	je     80370c <__udivdi3+0xf0>
  803701:	89 d8                	mov    %ebx,%eax
  803703:	31 ff                	xor    %edi,%edi
  803705:	e9 58 ff ff ff       	jmp    803662 <__udivdi3+0x46>
  80370a:	66 90                	xchg   %ax,%ax
  80370c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803710:	89 f9                	mov    %edi,%ecx
  803712:	d3 e2                	shl    %cl,%edx
  803714:	39 c2                	cmp    %eax,%edx
  803716:	73 e9                	jae    803701 <__udivdi3+0xe5>
  803718:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80371b:	31 ff                	xor    %edi,%edi
  80371d:	e9 40 ff ff ff       	jmp    803662 <__udivdi3+0x46>
  803722:	66 90                	xchg   %ax,%ax
  803724:	31 c0                	xor    %eax,%eax
  803726:	e9 37 ff ff ff       	jmp    803662 <__udivdi3+0x46>
  80372b:	90                   	nop

0080372c <__umoddi3>:
  80372c:	55                   	push   %ebp
  80372d:	57                   	push   %edi
  80372e:	56                   	push   %esi
  80372f:	53                   	push   %ebx
  803730:	83 ec 1c             	sub    $0x1c,%esp
  803733:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803737:	8b 74 24 34          	mov    0x34(%esp),%esi
  80373b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80373f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803743:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803747:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80374b:	89 f3                	mov    %esi,%ebx
  80374d:	89 fa                	mov    %edi,%edx
  80374f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803753:	89 34 24             	mov    %esi,(%esp)
  803756:	85 c0                	test   %eax,%eax
  803758:	75 1a                	jne    803774 <__umoddi3+0x48>
  80375a:	39 f7                	cmp    %esi,%edi
  80375c:	0f 86 a2 00 00 00    	jbe    803804 <__umoddi3+0xd8>
  803762:	89 c8                	mov    %ecx,%eax
  803764:	89 f2                	mov    %esi,%edx
  803766:	f7 f7                	div    %edi
  803768:	89 d0                	mov    %edx,%eax
  80376a:	31 d2                	xor    %edx,%edx
  80376c:	83 c4 1c             	add    $0x1c,%esp
  80376f:	5b                   	pop    %ebx
  803770:	5e                   	pop    %esi
  803771:	5f                   	pop    %edi
  803772:	5d                   	pop    %ebp
  803773:	c3                   	ret    
  803774:	39 f0                	cmp    %esi,%eax
  803776:	0f 87 ac 00 00 00    	ja     803828 <__umoddi3+0xfc>
  80377c:	0f bd e8             	bsr    %eax,%ebp
  80377f:	83 f5 1f             	xor    $0x1f,%ebp
  803782:	0f 84 ac 00 00 00    	je     803834 <__umoddi3+0x108>
  803788:	bf 20 00 00 00       	mov    $0x20,%edi
  80378d:	29 ef                	sub    %ebp,%edi
  80378f:	89 fe                	mov    %edi,%esi
  803791:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803795:	89 e9                	mov    %ebp,%ecx
  803797:	d3 e0                	shl    %cl,%eax
  803799:	89 d7                	mov    %edx,%edi
  80379b:	89 f1                	mov    %esi,%ecx
  80379d:	d3 ef                	shr    %cl,%edi
  80379f:	09 c7                	or     %eax,%edi
  8037a1:	89 e9                	mov    %ebp,%ecx
  8037a3:	d3 e2                	shl    %cl,%edx
  8037a5:	89 14 24             	mov    %edx,(%esp)
  8037a8:	89 d8                	mov    %ebx,%eax
  8037aa:	d3 e0                	shl    %cl,%eax
  8037ac:	89 c2                	mov    %eax,%edx
  8037ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037b2:	d3 e0                	shl    %cl,%eax
  8037b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037bc:	89 f1                	mov    %esi,%ecx
  8037be:	d3 e8                	shr    %cl,%eax
  8037c0:	09 d0                	or     %edx,%eax
  8037c2:	d3 eb                	shr    %cl,%ebx
  8037c4:	89 da                	mov    %ebx,%edx
  8037c6:	f7 f7                	div    %edi
  8037c8:	89 d3                	mov    %edx,%ebx
  8037ca:	f7 24 24             	mull   (%esp)
  8037cd:	89 c6                	mov    %eax,%esi
  8037cf:	89 d1                	mov    %edx,%ecx
  8037d1:	39 d3                	cmp    %edx,%ebx
  8037d3:	0f 82 87 00 00 00    	jb     803860 <__umoddi3+0x134>
  8037d9:	0f 84 91 00 00 00    	je     803870 <__umoddi3+0x144>
  8037df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037e3:	29 f2                	sub    %esi,%edx
  8037e5:	19 cb                	sbb    %ecx,%ebx
  8037e7:	89 d8                	mov    %ebx,%eax
  8037e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037ed:	d3 e0                	shl    %cl,%eax
  8037ef:	89 e9                	mov    %ebp,%ecx
  8037f1:	d3 ea                	shr    %cl,%edx
  8037f3:	09 d0                	or     %edx,%eax
  8037f5:	89 e9                	mov    %ebp,%ecx
  8037f7:	d3 eb                	shr    %cl,%ebx
  8037f9:	89 da                	mov    %ebx,%edx
  8037fb:	83 c4 1c             	add    $0x1c,%esp
  8037fe:	5b                   	pop    %ebx
  8037ff:	5e                   	pop    %esi
  803800:	5f                   	pop    %edi
  803801:	5d                   	pop    %ebp
  803802:	c3                   	ret    
  803803:	90                   	nop
  803804:	89 fd                	mov    %edi,%ebp
  803806:	85 ff                	test   %edi,%edi
  803808:	75 0b                	jne    803815 <__umoddi3+0xe9>
  80380a:	b8 01 00 00 00       	mov    $0x1,%eax
  80380f:	31 d2                	xor    %edx,%edx
  803811:	f7 f7                	div    %edi
  803813:	89 c5                	mov    %eax,%ebp
  803815:	89 f0                	mov    %esi,%eax
  803817:	31 d2                	xor    %edx,%edx
  803819:	f7 f5                	div    %ebp
  80381b:	89 c8                	mov    %ecx,%eax
  80381d:	f7 f5                	div    %ebp
  80381f:	89 d0                	mov    %edx,%eax
  803821:	e9 44 ff ff ff       	jmp    80376a <__umoddi3+0x3e>
  803826:	66 90                	xchg   %ax,%ax
  803828:	89 c8                	mov    %ecx,%eax
  80382a:	89 f2                	mov    %esi,%edx
  80382c:	83 c4 1c             	add    $0x1c,%esp
  80382f:	5b                   	pop    %ebx
  803830:	5e                   	pop    %esi
  803831:	5f                   	pop    %edi
  803832:	5d                   	pop    %ebp
  803833:	c3                   	ret    
  803834:	3b 04 24             	cmp    (%esp),%eax
  803837:	72 06                	jb     80383f <__umoddi3+0x113>
  803839:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80383d:	77 0f                	ja     80384e <__umoddi3+0x122>
  80383f:	89 f2                	mov    %esi,%edx
  803841:	29 f9                	sub    %edi,%ecx
  803843:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803847:	89 14 24             	mov    %edx,(%esp)
  80384a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80384e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803852:	8b 14 24             	mov    (%esp),%edx
  803855:	83 c4 1c             	add    $0x1c,%esp
  803858:	5b                   	pop    %ebx
  803859:	5e                   	pop    %esi
  80385a:	5f                   	pop    %edi
  80385b:	5d                   	pop    %ebp
  80385c:	c3                   	ret    
  80385d:	8d 76 00             	lea    0x0(%esi),%esi
  803860:	2b 04 24             	sub    (%esp),%eax
  803863:	19 fa                	sbb    %edi,%edx
  803865:	89 d1                	mov    %edx,%ecx
  803867:	89 c6                	mov    %eax,%esi
  803869:	e9 71 ff ff ff       	jmp    8037df <__umoddi3+0xb3>
  80386e:	66 90                	xchg   %ax,%ax
  803870:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803874:	72 ea                	jb     803860 <__umoddi3+0x134>
  803876:	89 d9                	mov    %ebx,%ecx
  803878:	e9 62 ff ff ff       	jmp    8037df <__umoddi3+0xb3>
