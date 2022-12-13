
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
  80008d:	68 40 39 80 00       	push   $0x803940
  800092:	6a 12                	push   $0x12
  800094:	68 5c 39 80 00       	push   $0x80395c
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
  8000ae:	68 78 39 80 00       	push   $0x803978
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 ac 39 80 00       	push   $0x8039ac
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 08 3a 80 00       	push   $0x803a08
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 42 1c 00 00       	call   801d22 <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 3c 3a 80 00       	push   $0x803a3c
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
  80011d:	68 7d 3a 80 00       	push   $0x803a7d
  800122:	e8 a6 1b 00 00       	call   801ccd <sys_create_env>
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
  800150:	68 7d 3a 80 00       	push   $0x803a7d
  800155:	e8 73 1b 00 00       	call   801ccd <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 f6 18 00 00       	call   801a5b <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 88 3a 80 00       	push   $0x803a88
  800177:	e8 9f 16 00 00       	call   80181b <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 8c 3a 80 00       	push   $0x803a8c
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 ac 3a 80 00       	push   $0x803aac
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 5c 39 80 00       	push   $0x80395c
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 a4 18 00 00       	call   801a5b <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 18 3b 80 00       	push   $0x803b18
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 5c 39 80 00       	push   $0x80395c
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 40 1c 00 00       	call   801e19 <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 07 1b 00 00       	call   801ceb <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 f9 1a 00 00       	call   801ceb <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 96 3b 80 00       	push   $0x803b96
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 0b 34 00 00       	call   80361d <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 78 1c 00 00       	call   801e93 <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 36 18 00 00       	call   801a5b <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 c8 16 00 00       	call   8018fb <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 b0 3b 80 00       	push   $0x803bb0
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 10 18 00 00       	call   801a5b <sys_calculate_free_frames>
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
  80026f:	68 d0 3b 80 00       	push   $0x803bd0
  800274:	6a 3b                	push   $0x3b
  800276:	68 5c 39 80 00       	push   $0x80395c
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 18 3c 80 00       	push   $0x803c18
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 3c 3c 80 00       	push   $0x803c3c
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
  8002c3:	68 6c 3c 80 00       	push   $0x803c6c
  8002c8:	e8 00 1a 00 00       	call   801ccd <sys_create_env>
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
  8002f6:	68 79 3c 80 00       	push   $0x803c79
  8002fb:	e8 cd 19 00 00       	call   801ccd <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 86 3c 80 00       	push   $0x803c86
  800315:	e8 01 15 00 00       	call   80181b <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 88 3c 80 00       	push   $0x803c88
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 88 3a 80 00       	push   $0x803a88
  80033f:	e8 d7 14 00 00       	call   80181b <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 8c 3a 80 00       	push   $0x803a8c
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 ba 1a 00 00       	call   801e19 <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 81 19 00 00       	call   801ceb <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 73 19 00 00       	call   801ceb <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 12 1b 00 00       	call   801e93 <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 8e 1a 00 00       	call   801e19 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 cb 16 00 00       	call   801a5b <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 5d 15 00 00       	call   8018fb <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 a8 3c 80 00       	push   $0x803ca8
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 3f 15 00 00       	call   8018fb <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 be 3c 80 00       	push   $0x803cbe
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 87 16 00 00       	call   801a5b <sys_calculate_free_frames>
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
  8003f2:	68 d4 3c 80 00       	push   $0x803cd4
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 5c 39 80 00       	push   $0x80395c
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 71 1a 00 00       	call   801e79 <inctst>


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
  800414:	e8 22 19 00 00       	call   801d3b <sys_getenvindex>
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
  80047f:	e8 c4 16 00 00       	call   801b48 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 94 3d 80 00       	push   $0x803d94
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
  8004af:	68 bc 3d 80 00       	push   $0x803dbc
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
  8004e0:	68 e4 3d 80 00       	push   $0x803de4
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 3c 3e 80 00       	push   $0x803e3c
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 94 3d 80 00       	push   $0x803d94
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 44 16 00 00       	call   801b62 <sys_enable_interrupt>

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
  800531:	e8 d1 17 00 00       	call   801d07 <sys_destroy_env>
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
  800542:	e8 26 18 00 00       	call   801d6d <sys_exit_env>
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
  80056b:	68 50 3e 80 00       	push   $0x803e50
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 55 3e 80 00       	push   $0x803e55
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
  8005a8:	68 71 3e 80 00       	push   $0x803e71
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
  8005d4:	68 74 3e 80 00       	push   $0x803e74
  8005d9:	6a 26                	push   $0x26
  8005db:	68 c0 3e 80 00       	push   $0x803ec0
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
  8006a6:	68 cc 3e 80 00       	push   $0x803ecc
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 c0 3e 80 00       	push   $0x803ec0
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
  800716:	68 20 3f 80 00       	push   $0x803f20
  80071b:	6a 44                	push   $0x44
  80071d:	68 c0 3e 80 00       	push   $0x803ec0
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
  800770:	e8 25 12 00 00       	call   80199a <sys_cputs>
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
  8007e7:	e8 ae 11 00 00       	call   80199a <sys_cputs>
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
  800831:	e8 12 13 00 00       	call   801b48 <sys_disable_interrupt>
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
  800851:	e8 0c 13 00 00       	call   801b62 <sys_enable_interrupt>
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
  80089b:	e8 34 2e 00 00       	call   8036d4 <__udivdi3>
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
  8008eb:	e8 f4 2e 00 00       	call   8037e4 <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 94 41 80 00       	add    $0x804194,%eax
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
  800a46:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
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
  800b27:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 a5 41 80 00       	push   $0x8041a5
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
  800b4c:	68 ae 41 80 00       	push   $0x8041ae
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
  800b79:	be b1 41 80 00       	mov    $0x8041b1,%esi
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
  80159f:	68 10 43 80 00       	push   $0x804310
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801652:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80165c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801661:	2d 00 10 00 00       	sub    $0x1000,%eax
  801666:	83 ec 04             	sub    $0x4,%esp
  801669:	6a 06                	push   $0x6
  80166b:	ff 75 f4             	pushl  -0xc(%ebp)
  80166e:	50                   	push   %eax
  80166f:	e8 6a 04 00 00       	call   801ade <sys_allocate_chunk>
  801674:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801677:	a1 20 51 80 00       	mov    0x805120,%eax
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	50                   	push   %eax
  801680:	e8 df 0a 00 00       	call   802164 <initialize_MemBlocksList>
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
  8016ad:	68 35 43 80 00       	push   $0x804335
  8016b2:	6a 33                	push   $0x33
  8016b4:	68 53 43 80 00       	push   $0x804353
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
  80172c:	68 60 43 80 00       	push   $0x804360
  801731:	6a 34                	push   $0x34
  801733:	68 53 43 80 00       	push   $0x804353
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
  801789:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178c:	e8 f7 fd ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  801791:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801795:	75 07                	jne    80179e <malloc+0x18>
  801797:	b8 00 00 00 00       	mov    $0x0,%eax
  80179c:	eb 61                	jmp    8017ff <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80179e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	48                   	dec    %eax
  8017ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b9:	f7 75 f0             	divl   -0x10(%ebp)
  8017bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bf:	29 d0                	sub    %edx,%eax
  8017c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017c4:	e8 e3 06 00 00       	call   801eac <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	74 11                	je     8017de <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d3:	e8 4e 0d 00 00       	call   802526 <alloc_block_FF>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  8017de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e2:	74 16                	je     8017fa <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  8017e4:	83 ec 0c             	sub    $0xc,%esp
  8017e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ea:	e8 aa 0a 00 00       	call   802299 <insert_sorted_allocList>
  8017ef:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  8017f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f5:	8b 40 08             	mov    0x8(%eax),%eax
  8017f8:	eb 05                	jmp    8017ff <malloc+0x79>
	}

    return NULL;
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801807:	83 ec 04             	sub    $0x4,%esp
  80180a:	68 84 43 80 00       	push   $0x804384
  80180f:	6a 6f                	push   $0x6f
  801811:	68 53 43 80 00       	push   $0x804353
  801816:	e8 2f ed ff ff       	call   80054a <_panic>

0080181b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 38             	sub    $0x38,%esp
  801821:	8b 45 10             	mov    0x10(%ebp),%eax
  801824:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801827:	e8 5c fd ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  80182c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801830:	75 07                	jne    801839 <smalloc+0x1e>
  801832:	b8 00 00 00 00       	mov    $0x0,%eax
  801837:	eb 7c                	jmp    8018b5 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801839:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801846:	01 d0                	add    %edx,%eax
  801848:	48                   	dec    %eax
  801849:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80184c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184f:	ba 00 00 00 00       	mov    $0x0,%edx
  801854:	f7 75 f0             	divl   -0x10(%ebp)
  801857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80185a:	29 d0                	sub    %edx,%eax
  80185c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80185f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801866:	e8 41 06 00 00       	call   801eac <sys_isUHeapPlacementStrategyFIRSTFIT>
  80186b:	85 c0                	test   %eax,%eax
  80186d:	74 11                	je     801880 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80186f:	83 ec 0c             	sub    $0xc,%esp
  801872:	ff 75 e8             	pushl  -0x18(%ebp)
  801875:	e8 ac 0c 00 00       	call   802526 <alloc_block_FF>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801884:	74 2a                	je     8018b0 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801889:	8b 40 08             	mov    0x8(%eax),%eax
  80188c:	89 c2                	mov    %eax,%edx
  80188e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	e8 92 03 00 00       	call   801c31 <sys_createSharedObject>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8018a5:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8018a9:	74 05                	je     8018b0 <smalloc+0x95>
			return (void*)virtual_address;
  8018ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ae:	eb 05                	jmp    8018b5 <smalloc+0x9a>
	}
	return NULL;
  8018b0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018bd:	e8 c6 fc ff ff       	call   801588 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8018c2:	83 ec 04             	sub    $0x4,%esp
  8018c5:	68 a8 43 80 00       	push   $0x8043a8
  8018ca:	68 b0 00 00 00       	push   $0xb0
  8018cf:	68 53 43 80 00       	push   $0x804353
  8018d4:	e8 71 ec ff ff       	call   80054a <_panic>

008018d9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018df:	e8 a4 fc ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018e4:	83 ec 04             	sub    $0x4,%esp
  8018e7:	68 cc 43 80 00       	push   $0x8043cc
  8018ec:	68 f4 00 00 00       	push   $0xf4
  8018f1:	68 53 43 80 00       	push   $0x804353
  8018f6:	e8 4f ec ff ff       	call   80054a <_panic>

008018fb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	68 f4 43 80 00       	push   $0x8043f4
  801909:	68 08 01 00 00       	push   $0x108
  80190e:	68 53 43 80 00       	push   $0x804353
  801913:	e8 32 ec ff ff       	call   80054a <_panic>

00801918 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	68 18 44 80 00       	push   $0x804418
  801926:	68 13 01 00 00       	push   $0x113
  80192b:	68 53 43 80 00       	push   $0x804353
  801930:	e8 15 ec ff ff       	call   80054a <_panic>

00801935 <shrink>:

}
void shrink(uint32 newSize)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	68 18 44 80 00       	push   $0x804418
  801943:	68 18 01 00 00       	push   $0x118
  801948:	68 53 43 80 00       	push   $0x804353
  80194d:	e8 f8 eb ff ff       	call   80054a <_panic>

00801952 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 18 44 80 00       	push   $0x804418
  801960:	68 1d 01 00 00       	push   $0x11d
  801965:	68 53 43 80 00       	push   $0x804353
  80196a:	e8 db eb ff ff       	call   80054a <_panic>

0080196f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	57                   	push   %edi
  801973:	56                   	push   %esi
  801974:	53                   	push   %ebx
  801975:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801981:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801984:	8b 7d 18             	mov    0x18(%ebp),%edi
  801987:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80198a:	cd 30                	int    $0x30
  80198c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	5b                   	pop    %ebx
  801996:	5e                   	pop    %esi
  801997:	5f                   	pop    %edi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019a6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	52                   	push   %edx
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	50                   	push   %eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	e8 b2 ff ff ff       	call   80196f <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 01                	push   $0x1
  8019d2:	e8 98 ff ff ff       	call   80196f <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	52                   	push   %edx
  8019ec:	50                   	push   %eax
  8019ed:	6a 05                	push   $0x5
  8019ef:	e8 7b ff ff ff       	call   80196f <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	56                   	push   %esi
  8019fd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019fe:	8b 75 18             	mov    0x18(%ebp),%esi
  801a01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	56                   	push   %esi
  801a0e:	53                   	push   %ebx
  801a0f:	51                   	push   %ecx
  801a10:	52                   	push   %edx
  801a11:	50                   	push   %eax
  801a12:	6a 06                	push   $0x6
  801a14:	e8 56 ff ff ff       	call   80196f <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1f:	5b                   	pop    %ebx
  801a20:	5e                   	pop    %esi
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    

00801a23 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	52                   	push   %edx
  801a33:	50                   	push   %eax
  801a34:	6a 07                	push   $0x7
  801a36:	e8 34 ff ff ff       	call   80196f <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	ff 75 08             	pushl  0x8(%ebp)
  801a4f:	6a 08                	push   $0x8
  801a51:	e8 19 ff ff ff       	call   80196f <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 09                	push   $0x9
  801a6a:	e8 00 ff ff ff       	call   80196f <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 0a                	push   $0xa
  801a83:	e8 e7 fe ff ff       	call   80196f <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 0b                	push   $0xb
  801a9c:	e8 ce fe ff ff       	call   80196f <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	ff 75 08             	pushl  0x8(%ebp)
  801ab5:	6a 0f                	push   $0xf
  801ab7:	e8 b3 fe ff ff       	call   80196f <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
	return;
  801abf:	90                   	nop
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	ff 75 08             	pushl  0x8(%ebp)
  801ad1:	6a 10                	push   $0x10
  801ad3:	e8 97 fe ff ff       	call   80196f <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	ff 75 08             	pushl  0x8(%ebp)
  801aee:	6a 11                	push   $0x11
  801af0:	e8 7a fe ff ff       	call   80196f <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
	return ;
  801af8:	90                   	nop
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 0c                	push   $0xc
  801b0a:	e8 60 fe ff ff       	call   80196f <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	6a 0d                	push   $0xd
  801b24:	e8 46 fe ff ff       	call   80196f <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 0e                	push   $0xe
  801b3d:	e8 2d fe ff ff       	call   80196f <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 13                	push   $0x13
  801b57:	e8 13 fe ff ff       	call   80196f <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	90                   	nop
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 14                	push   $0x14
  801b71:	e8 f9 fd ff ff       	call   80196f <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	90                   	nop
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_cputc>:


void
sys_cputc(const char c)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 04             	sub    $0x4,%esp
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b88:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	50                   	push   %eax
  801b95:	6a 15                	push   $0x15
  801b97:	e8 d3 fd ff ff       	call   80196f <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	90                   	nop
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 16                	push   $0x16
  801bb1:	e8 b9 fd ff ff       	call   80196f <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	90                   	nop
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	50                   	push   %eax
  801bcc:	6a 17                	push   $0x17
  801bce:	e8 9c fd ff ff       	call   80196f <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	52                   	push   %edx
  801be8:	50                   	push   %eax
  801be9:	6a 1a                	push   $0x1a
  801beb:	e8 7f fd ff ff       	call   80196f <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	52                   	push   %edx
  801c05:	50                   	push   %eax
  801c06:	6a 18                	push   $0x18
  801c08:	e8 62 fd ff ff       	call   80196f <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	90                   	nop
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	52                   	push   %edx
  801c23:	50                   	push   %eax
  801c24:	6a 19                	push   $0x19
  801c26:	e8 44 fd ff ff       	call   80196f <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	90                   	nop
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c3d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c40:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	6a 00                	push   $0x0
  801c49:	51                   	push   %ecx
  801c4a:	52                   	push   %edx
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	50                   	push   %eax
  801c4f:	6a 1b                	push   $0x1b
  801c51:	e8 19 fd ff ff       	call   80196f <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	6a 1c                	push   $0x1c
  801c6e:	e8 fc fc ff ff       	call   80196f <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	51                   	push   %ecx
  801c89:	52                   	push   %edx
  801c8a:	50                   	push   %eax
  801c8b:	6a 1d                	push   $0x1d
  801c8d:	e8 dd fc ff ff       	call   80196f <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	52                   	push   %edx
  801ca7:	50                   	push   %eax
  801ca8:	6a 1e                	push   $0x1e
  801caa:	e8 c0 fc ff ff       	call   80196f <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 1f                	push   $0x1f
  801cc3:	e8 a7 fc ff ff       	call   80196f <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 14             	pushl  0x14(%ebp)
  801cd8:	ff 75 10             	pushl  0x10(%ebp)
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	50                   	push   %eax
  801cdf:	6a 20                	push   $0x20
  801ce1:	e8 89 fc ff ff       	call   80196f <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	50                   	push   %eax
  801cfa:	6a 21                	push   $0x21
  801cfc:	e8 6e fc ff ff       	call   80196f <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	90                   	nop
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	50                   	push   %eax
  801d16:	6a 22                	push   $0x22
  801d18:	e8 52 fc ff ff       	call   80196f <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 02                	push   $0x2
  801d31:	e8 39 fc ff ff       	call   80196f <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 03                	push   $0x3
  801d4a:	e8 20 fc ff ff       	call   80196f <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 04                	push   $0x4
  801d63:	e8 07 fc ff ff       	call   80196f <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_exit_env>:


void sys_exit_env(void)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 23                	push   $0x23
  801d7c:	e8 ee fb ff ff       	call   80196f <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	90                   	nop
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d90:	8d 50 04             	lea    0x4(%eax),%edx
  801d93:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	52                   	push   %edx
  801d9d:	50                   	push   %eax
  801d9e:	6a 24                	push   $0x24
  801da0:	e8 ca fb ff ff       	call   80196f <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
	return result;
  801da8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801db1:	89 01                	mov    %eax,(%ecx)
  801db3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	c9                   	leave  
  801dba:	c2 04 00             	ret    $0x4

00801dbd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	ff 75 10             	pushl  0x10(%ebp)
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	6a 12                	push   $0x12
  801dcf:	e8 9b fb ff ff       	call   80196f <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_rcr2>:
uint32 sys_rcr2()
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 25                	push   $0x25
  801de9:	e8 81 fb ff ff       	call   80196f <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	50                   	push   %eax
  801e0c:	6a 26                	push   $0x26
  801e0e:	e8 5c fb ff ff       	call   80196f <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
	return ;
  801e16:	90                   	nop
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <rsttst>:
void rsttst()
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 28                	push   $0x28
  801e28:	e8 42 fb ff ff       	call   80196f <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e30:	90                   	nop
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e3f:	8b 55 18             	mov    0x18(%ebp),%edx
  801e42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	ff 75 10             	pushl  0x10(%ebp)
  801e4b:	ff 75 0c             	pushl  0xc(%ebp)
  801e4e:	ff 75 08             	pushl  0x8(%ebp)
  801e51:	6a 27                	push   $0x27
  801e53:	e8 17 fb ff ff       	call   80196f <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5b:	90                   	nop
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <chktst>:
void chktst(uint32 n)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	ff 75 08             	pushl  0x8(%ebp)
  801e6c:	6a 29                	push   $0x29
  801e6e:	e8 fc fa ff ff       	call   80196f <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
	return ;
  801e76:	90                   	nop
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <inctst>:

void inctst()
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 2a                	push   $0x2a
  801e88:	e8 e2 fa ff ff       	call   80196f <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e90:	90                   	nop
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <gettst>:
uint32 gettst()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 2b                	push   $0x2b
  801ea2:	e8 c8 fa ff ff       	call   80196f <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 2c                	push   $0x2c
  801ebe:	e8 ac fa ff ff       	call   80196f <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
  801ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ec9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ecd:	75 07                	jne    801ed6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ecf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed4:	eb 05                	jmp    801edb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 2c                	push   $0x2c
  801eef:	e8 7b fa ff ff       	call   80196f <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
  801ef7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801efa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801efe:	75 07                	jne    801f07 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f00:	b8 01 00 00 00       	mov    $0x1,%eax
  801f05:	eb 05                	jmp    801f0c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 2c                	push   $0x2c
  801f20:	e8 4a fa ff ff       	call   80196f <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
  801f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f2b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f2f:	75 07                	jne    801f38 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f31:	b8 01 00 00 00       	mov    $0x1,%eax
  801f36:	eb 05                	jmp    801f3d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 2c                	push   $0x2c
  801f51:	e8 19 fa ff ff       	call   80196f <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
  801f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f5c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f60:	75 07                	jne    801f69 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f62:	b8 01 00 00 00       	mov    $0x1,%eax
  801f67:	eb 05                	jmp    801f6e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	ff 75 08             	pushl  0x8(%ebp)
  801f7e:	6a 2d                	push   $0x2d
  801f80:	e8 ea f9 ff ff       	call   80196f <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
	return ;
  801f88:	90                   	nop
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	53                   	push   %ebx
  801f9e:	51                   	push   %ecx
  801f9f:	52                   	push   %edx
  801fa0:	50                   	push   %eax
  801fa1:	6a 2e                	push   $0x2e
  801fa3:	e8 c7 f9 ff ff       	call   80196f <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	52                   	push   %edx
  801fc0:	50                   	push   %eax
  801fc1:	6a 2f                	push   $0x2f
  801fc3:	e8 a7 f9 ff ff       	call   80196f <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	68 28 44 80 00       	push   $0x804428
  801fdb:	e8 1e e8 ff ff       	call   8007fe <cprintf>
  801fe0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fe3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	68 54 44 80 00       	push   $0x804454
  801ff2:	e8 07 e8 ff ff       	call   8007fe <cprintf>
  801ff7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ffa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ffe:	a1 38 51 80 00       	mov    0x805138,%eax
  802003:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802006:	eb 56                	jmp    80205e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802008:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200c:	74 1c                	je     80202a <print_mem_block_lists+0x5d>
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	8b 50 08             	mov    0x8(%eax),%edx
  802014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802017:	8b 48 08             	mov    0x8(%eax),%ecx
  80201a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201d:	8b 40 0c             	mov    0xc(%eax),%eax
  802020:	01 c8                	add    %ecx,%eax
  802022:	39 c2                	cmp    %eax,%edx
  802024:	73 04                	jae    80202a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802026:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 50 08             	mov    0x8(%eax),%edx
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	8b 40 0c             	mov    0xc(%eax),%eax
  802036:	01 c2                	add    %eax,%edx
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 40 08             	mov    0x8(%eax),%eax
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	52                   	push   %edx
  802042:	50                   	push   %eax
  802043:	68 69 44 80 00       	push   $0x804469
  802048:	e8 b1 e7 ff ff       	call   8007fe <cprintf>
  80204d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802056:	a1 40 51 80 00       	mov    0x805140,%eax
  80205b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802062:	74 07                	je     80206b <print_mem_block_lists+0x9e>
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	8b 00                	mov    (%eax),%eax
  802069:	eb 05                	jmp    802070 <print_mem_block_lists+0xa3>
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	a3 40 51 80 00       	mov    %eax,0x805140
  802075:	a1 40 51 80 00       	mov    0x805140,%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	75 8a                	jne    802008 <print_mem_block_lists+0x3b>
  80207e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802082:	75 84                	jne    802008 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802084:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802088:	75 10                	jne    80209a <print_mem_block_lists+0xcd>
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	68 78 44 80 00       	push   $0x804478
  802092:	e8 67 e7 ff ff       	call   8007fe <cprintf>
  802097:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80209a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	68 9c 44 80 00       	push   $0x80449c
  8020a9:	e8 50 e7 ff ff       	call   8007fe <cprintf>
  8020ae:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020b1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b5:	a1 40 50 80 00       	mov    0x805040,%eax
  8020ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bd:	eb 56                	jmp    802115 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c3:	74 1c                	je     8020e1 <print_mem_block_lists+0x114>
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	8b 50 08             	mov    0x8(%eax),%edx
  8020cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ce:	8b 48 08             	mov    0x8(%eax),%ecx
  8020d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d7:	01 c8                	add    %ecx,%eax
  8020d9:	39 c2                	cmp    %eax,%edx
  8020db:	73 04                	jae    8020e1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020dd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 50 08             	mov    0x8(%eax),%edx
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ed:	01 c2                	add    %eax,%edx
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	8b 40 08             	mov    0x8(%eax),%eax
  8020f5:	83 ec 04             	sub    $0x4,%esp
  8020f8:	52                   	push   %edx
  8020f9:	50                   	push   %eax
  8020fa:	68 69 44 80 00       	push   $0x804469
  8020ff:	e8 fa e6 ff ff       	call   8007fe <cprintf>
  802104:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80210d:	a1 48 50 80 00       	mov    0x805048,%eax
  802112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802119:	74 07                	je     802122 <print_mem_block_lists+0x155>
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 00                	mov    (%eax),%eax
  802120:	eb 05                	jmp    802127 <print_mem_block_lists+0x15a>
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
  802127:	a3 48 50 80 00       	mov    %eax,0x805048
  80212c:	a1 48 50 80 00       	mov    0x805048,%eax
  802131:	85 c0                	test   %eax,%eax
  802133:	75 8a                	jne    8020bf <print_mem_block_lists+0xf2>
  802135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802139:	75 84                	jne    8020bf <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80213b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80213f:	75 10                	jne    802151 <print_mem_block_lists+0x184>
  802141:	83 ec 0c             	sub    $0xc,%esp
  802144:	68 b4 44 80 00       	push   $0x8044b4
  802149:	e8 b0 e6 ff ff       	call   8007fe <cprintf>
  80214e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	68 28 44 80 00       	push   $0x804428
  802159:	e8 a0 e6 ff ff       	call   8007fe <cprintf>
  80215e:	83 c4 10             	add    $0x10,%esp

}
  802161:	90                   	nop
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80216a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802171:	00 00 00 
  802174:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80217b:	00 00 00 
  80217e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802185:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80218f:	e9 9e 00 00 00       	jmp    802232 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802194:	a1 50 50 80 00       	mov    0x805050,%eax
  802199:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219c:	c1 e2 04             	shl    $0x4,%edx
  80219f:	01 d0                	add    %edx,%eax
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	75 14                	jne    8021b9 <initialize_MemBlocksList+0x55>
  8021a5:	83 ec 04             	sub    $0x4,%esp
  8021a8:	68 dc 44 80 00       	push   $0x8044dc
  8021ad:	6a 46                	push   $0x46
  8021af:	68 ff 44 80 00       	push   $0x8044ff
  8021b4:	e8 91 e3 ff ff       	call   80054a <_panic>
  8021b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8021be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c1:	c1 e2 04             	shl    $0x4,%edx
  8021c4:	01 d0                	add    %edx,%eax
  8021c6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021cc:	89 10                	mov    %edx,(%eax)
  8021ce:	8b 00                	mov    (%eax),%eax
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	74 18                	je     8021ec <initialize_MemBlocksList+0x88>
  8021d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8021d9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021df:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021e2:	c1 e1 04             	shl    $0x4,%ecx
  8021e5:	01 ca                	add    %ecx,%edx
  8021e7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ea:	eb 12                	jmp    8021fe <initialize_MemBlocksList+0x9a>
  8021ec:	a1 50 50 80 00       	mov    0x805050,%eax
  8021f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f4:	c1 e2 04             	shl    $0x4,%edx
  8021f7:	01 d0                	add    %edx,%eax
  8021f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021fe:	a1 50 50 80 00       	mov    0x805050,%eax
  802203:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802206:	c1 e2 04             	shl    $0x4,%edx
  802209:	01 d0                	add    %edx,%eax
  80220b:	a3 48 51 80 00       	mov    %eax,0x805148
  802210:	a1 50 50 80 00       	mov    0x805050,%eax
  802215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802218:	c1 e2 04             	shl    $0x4,%edx
  80221b:	01 d0                	add    %edx,%eax
  80221d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802224:	a1 54 51 80 00       	mov    0x805154,%eax
  802229:	40                   	inc    %eax
  80222a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80222f:	ff 45 f4             	incl   -0xc(%ebp)
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	3b 45 08             	cmp    0x8(%ebp),%eax
  802238:	0f 82 56 ff ff ff    	jb     802194 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80223e:	90                   	nop
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8b 00                	mov    (%eax),%eax
  80224c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80224f:	eb 19                	jmp    80226a <find_block+0x29>
	{
		if(va==point->sva)
  802251:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802254:	8b 40 08             	mov    0x8(%eax),%eax
  802257:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80225a:	75 05                	jne    802261 <find_block+0x20>
		   return point;
  80225c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225f:	eb 36                	jmp    802297 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	8b 40 08             	mov    0x8(%eax),%eax
  802267:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80226a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80226e:	74 07                	je     802277 <find_block+0x36>
  802270:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802273:	8b 00                	mov    (%eax),%eax
  802275:	eb 05                	jmp    80227c <find_block+0x3b>
  802277:	b8 00 00 00 00       	mov    $0x0,%eax
  80227c:	8b 55 08             	mov    0x8(%ebp),%edx
  80227f:	89 42 08             	mov    %eax,0x8(%edx)
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	8b 40 08             	mov    0x8(%eax),%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	75 c5                	jne    802251 <find_block+0x10>
  80228c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802290:	75 bf                	jne    802251 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802292:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80229f:	a1 40 50 80 00       	mov    0x805040,%eax
  8022a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8022a7:	a1 44 50 80 00       	mov    0x805044,%eax
  8022ac:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022b5:	74 24                	je     8022db <insert_sorted_allocList+0x42>
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	8b 50 08             	mov    0x8(%eax),%edx
  8022bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c0:	8b 40 08             	mov    0x8(%eax),%eax
  8022c3:	39 c2                	cmp    %eax,%edx
  8022c5:	76 14                	jbe    8022db <insert_sorted_allocList+0x42>
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	8b 50 08             	mov    0x8(%eax),%edx
  8022cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d0:	8b 40 08             	mov    0x8(%eax),%eax
  8022d3:	39 c2                	cmp    %eax,%edx
  8022d5:	0f 82 60 01 00 00    	jb     80243b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022df:	75 65                	jne    802346 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e5:	75 14                	jne    8022fb <insert_sorted_allocList+0x62>
  8022e7:	83 ec 04             	sub    $0x4,%esp
  8022ea:	68 dc 44 80 00       	push   $0x8044dc
  8022ef:	6a 6b                	push   $0x6b
  8022f1:	68 ff 44 80 00       	push   $0x8044ff
  8022f6:	e8 4f e2 ff ff       	call   80054a <_panic>
  8022fb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	89 10                	mov    %edx,(%eax)
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	8b 00                	mov    (%eax),%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	74 0d                	je     80231c <insert_sorted_allocList+0x83>
  80230f:	a1 40 50 80 00       	mov    0x805040,%eax
  802314:	8b 55 08             	mov    0x8(%ebp),%edx
  802317:	89 50 04             	mov    %edx,0x4(%eax)
  80231a:	eb 08                	jmp    802324 <insert_sorted_allocList+0x8b>
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	a3 44 50 80 00       	mov    %eax,0x805044
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	a3 40 50 80 00       	mov    %eax,0x805040
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802336:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80233b:	40                   	inc    %eax
  80233c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802341:	e9 dc 01 00 00       	jmp    802522 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	8b 50 08             	mov    0x8(%eax),%edx
  80234c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234f:	8b 40 08             	mov    0x8(%eax),%eax
  802352:	39 c2                	cmp    %eax,%edx
  802354:	77 6c                	ja     8023c2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80235a:	74 06                	je     802362 <insert_sorted_allocList+0xc9>
  80235c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802360:	75 14                	jne    802376 <insert_sorted_allocList+0xdd>
  802362:	83 ec 04             	sub    $0x4,%esp
  802365:	68 18 45 80 00       	push   $0x804518
  80236a:	6a 6f                	push   $0x6f
  80236c:	68 ff 44 80 00       	push   $0x8044ff
  802371:	e8 d4 e1 ff ff       	call   80054a <_panic>
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	8b 50 04             	mov    0x4(%eax),%edx
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	89 50 04             	mov    %edx,0x4(%eax)
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802388:	89 10                	mov    %edx,(%eax)
  80238a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238d:	8b 40 04             	mov    0x4(%eax),%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	74 0d                	je     8023a1 <insert_sorted_allocList+0x108>
  802394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802397:	8b 40 04             	mov    0x4(%eax),%eax
  80239a:	8b 55 08             	mov    0x8(%ebp),%edx
  80239d:	89 10                	mov    %edx,(%eax)
  80239f:	eb 08                	jmp    8023a9 <insert_sorted_allocList+0x110>
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	a3 40 50 80 00       	mov    %eax,0x805040
  8023a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8023af:	89 50 04             	mov    %edx,0x4(%eax)
  8023b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023b7:	40                   	inc    %eax
  8023b8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023bd:	e9 60 01 00 00       	jmp    802522 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	8b 50 08             	mov    0x8(%eax),%edx
  8023c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cb:	8b 40 08             	mov    0x8(%eax),%eax
  8023ce:	39 c2                	cmp    %eax,%edx
  8023d0:	0f 82 4c 01 00 00    	jb     802522 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023da:	75 14                	jne    8023f0 <insert_sorted_allocList+0x157>
  8023dc:	83 ec 04             	sub    $0x4,%esp
  8023df:	68 50 45 80 00       	push   $0x804550
  8023e4:	6a 73                	push   $0x73
  8023e6:	68 ff 44 80 00       	push   $0x8044ff
  8023eb:	e8 5a e1 ff ff       	call   80054a <_panic>
  8023f0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	89 50 04             	mov    %edx,0x4(%eax)
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	74 0c                	je     802412 <insert_sorted_allocList+0x179>
  802406:	a1 44 50 80 00       	mov    0x805044,%eax
  80240b:	8b 55 08             	mov    0x8(%ebp),%edx
  80240e:	89 10                	mov    %edx,(%eax)
  802410:	eb 08                	jmp    80241a <insert_sorted_allocList+0x181>
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	a3 40 50 80 00       	mov    %eax,0x805040
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	a3 44 50 80 00       	mov    %eax,0x805044
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802430:	40                   	inc    %eax
  802431:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802436:	e9 e7 00 00 00       	jmp    802522 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80243b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802441:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802448:	a1 40 50 80 00       	mov    0x805040,%eax
  80244d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802450:	e9 9d 00 00 00       	jmp    8024f2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	8b 50 08             	mov    0x8(%eax),%edx
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 40 08             	mov    0x8(%eax),%eax
  802469:	39 c2                	cmp    %eax,%edx
  80246b:	76 7d                	jbe    8024ea <insert_sorted_allocList+0x251>
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	8b 50 08             	mov    0x8(%eax),%edx
  802473:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802476:	8b 40 08             	mov    0x8(%eax),%eax
  802479:	39 c2                	cmp    %eax,%edx
  80247b:	73 6d                	jae    8024ea <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80247d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802481:	74 06                	je     802489 <insert_sorted_allocList+0x1f0>
  802483:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802487:	75 14                	jne    80249d <insert_sorted_allocList+0x204>
  802489:	83 ec 04             	sub    $0x4,%esp
  80248c:	68 74 45 80 00       	push   $0x804574
  802491:	6a 7f                	push   $0x7f
  802493:	68 ff 44 80 00       	push   $0x8044ff
  802498:	e8 ad e0 ff ff       	call   80054a <_panic>
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 10                	mov    (%eax),%edx
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	89 10                	mov    %edx,(%eax)
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 0b                	je     8024bb <insert_sorted_allocList+0x222>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b8:	89 50 04             	mov    %edx,0x4(%eax)
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c1:	89 10                	mov    %edx,(%eax)
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c9:	89 50 04             	mov    %edx,0x4(%eax)
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	75 08                	jne    8024dd <insert_sorted_allocList+0x244>
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	a3 44 50 80 00       	mov    %eax,0x805044
  8024dd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024e2:	40                   	inc    %eax
  8024e3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024e8:	eb 39                	jmp    802523 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024ea:	a1 48 50 80 00       	mov    0x805048,%eax
  8024ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f6:	74 07                	je     8024ff <insert_sorted_allocList+0x266>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 00                	mov    (%eax),%eax
  8024fd:	eb 05                	jmp    802504 <insert_sorted_allocList+0x26b>
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	a3 48 50 80 00       	mov    %eax,0x805048
  802509:	a1 48 50 80 00       	mov    0x805048,%eax
  80250e:	85 c0                	test   %eax,%eax
  802510:	0f 85 3f ff ff ff    	jne    802455 <insert_sorted_allocList+0x1bc>
  802516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251a:	0f 85 35 ff ff ff    	jne    802455 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802520:	eb 01                	jmp    802523 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802522:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802523:	90                   	nop
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80252c:	a1 38 51 80 00       	mov    0x805138,%eax
  802531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802534:	e9 85 01 00 00       	jmp    8026be <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 0c             	mov    0xc(%eax),%eax
  80253f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802542:	0f 82 6e 01 00 00    	jb     8026b6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 0c             	mov    0xc(%eax),%eax
  80254e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802551:	0f 85 8a 00 00 00    	jne    8025e1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	75 17                	jne    802574 <alloc_block_FF+0x4e>
  80255d:	83 ec 04             	sub    $0x4,%esp
  802560:	68 a8 45 80 00       	push   $0x8045a8
  802565:	68 93 00 00 00       	push   $0x93
  80256a:	68 ff 44 80 00       	push   $0x8044ff
  80256f:	e8 d6 df ff ff       	call   80054a <_panic>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	74 10                	je     80258d <alloc_block_FF+0x67>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802585:	8b 52 04             	mov    0x4(%edx),%edx
  802588:	89 50 04             	mov    %edx,0x4(%eax)
  80258b:	eb 0b                	jmp    802598 <alloc_block_FF+0x72>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 04             	mov    0x4(%eax),%eax
  802593:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	74 0f                	je     8025b1 <alloc_block_FF+0x8b>
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 40 04             	mov    0x4(%eax),%eax
  8025a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ab:	8b 12                	mov    (%edx),%edx
  8025ad:	89 10                	mov    %edx,(%eax)
  8025af:	eb 0a                	jmp    8025bb <alloc_block_FF+0x95>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8025d3:	48                   	dec    %eax
  8025d4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	e9 10 01 00 00       	jmp    8026f1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ea:	0f 86 c6 00 00 00    	jbe    8026b6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8025f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 50 08             	mov    0x8(%eax),%edx
  8025fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802601:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	8b 55 08             	mov    0x8(%ebp),%edx
  80260a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80260d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802611:	75 17                	jne    80262a <alloc_block_FF+0x104>
  802613:	83 ec 04             	sub    $0x4,%esp
  802616:	68 a8 45 80 00       	push   $0x8045a8
  80261b:	68 9b 00 00 00       	push   $0x9b
  802620:	68 ff 44 80 00       	push   $0x8044ff
  802625:	e8 20 df ff ff       	call   80054a <_panic>
  80262a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	85 c0                	test   %eax,%eax
  802631:	74 10                	je     802643 <alloc_block_FF+0x11d>
  802633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80263b:	8b 52 04             	mov    0x4(%edx),%edx
  80263e:	89 50 04             	mov    %edx,0x4(%eax)
  802641:	eb 0b                	jmp    80264e <alloc_block_FF+0x128>
  802643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802646:	8b 40 04             	mov    0x4(%eax),%eax
  802649:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80264e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802651:	8b 40 04             	mov    0x4(%eax),%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	74 0f                	je     802667 <alloc_block_FF+0x141>
  802658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265b:	8b 40 04             	mov    0x4(%eax),%eax
  80265e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802661:	8b 12                	mov    (%edx),%edx
  802663:	89 10                	mov    %edx,(%eax)
  802665:	eb 0a                	jmp    802671 <alloc_block_FF+0x14b>
  802667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	a3 48 51 80 00       	mov    %eax,0x805148
  802671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802674:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802684:	a1 54 51 80 00       	mov    0x805154,%eax
  802689:	48                   	dec    %eax
  80268a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 50 08             	mov    0x8(%eax),%edx
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	01 c2                	add    %eax,%edx
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a9:	89 c2                	mov    %eax,%edx
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8026b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b4:	eb 3b                	jmp    8026f1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8026bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c2:	74 07                	je     8026cb <alloc_block_FF+0x1a5>
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	eb 05                	jmp    8026d0 <alloc_block_FF+0x1aa>
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d0:	a3 40 51 80 00       	mov    %eax,0x805140
  8026d5:	a1 40 51 80 00       	mov    0x805140,%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	0f 85 57 fe ff ff    	jne    802539 <alloc_block_FF+0x13>
  8026e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e6:	0f 85 4d fe ff ff    	jne    802539 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8026ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
  8026f6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802700:	a1 38 51 80 00       	mov    0x805138,%eax
  802705:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802708:	e9 df 00 00 00       	jmp    8027ec <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 0c             	mov    0xc(%eax),%eax
  802713:	3b 45 08             	cmp    0x8(%ebp),%eax
  802716:	0f 82 c8 00 00 00    	jb     8027e4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 0c             	mov    0xc(%eax),%eax
  802722:	3b 45 08             	cmp    0x8(%ebp),%eax
  802725:	0f 85 8a 00 00 00    	jne    8027b5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80272b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272f:	75 17                	jne    802748 <alloc_block_BF+0x55>
  802731:	83 ec 04             	sub    $0x4,%esp
  802734:	68 a8 45 80 00       	push   $0x8045a8
  802739:	68 b7 00 00 00       	push   $0xb7
  80273e:	68 ff 44 80 00       	push   $0x8044ff
  802743:	e8 02 de ff ff       	call   80054a <_panic>
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 10                	je     802761 <alloc_block_BF+0x6e>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802759:	8b 52 04             	mov    0x4(%edx),%edx
  80275c:	89 50 04             	mov    %edx,0x4(%eax)
  80275f:	eb 0b                	jmp    80276c <alloc_block_BF+0x79>
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 40 04             	mov    0x4(%eax),%eax
  802767:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 40 04             	mov    0x4(%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	74 0f                	je     802785 <alloc_block_BF+0x92>
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277f:	8b 12                	mov    (%edx),%edx
  802781:	89 10                	mov    %edx,(%eax)
  802783:	eb 0a                	jmp    80278f <alloc_block_BF+0x9c>
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	a3 38 51 80 00       	mov    %eax,0x805138
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8027a7:	48                   	dec    %eax
  8027a8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	e9 4d 01 00 00       	jmp    802902 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027be:	76 24                	jbe    8027e4 <alloc_block_BF+0xf1>
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027c9:	73 19                	jae    8027e4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8027cb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 08             	mov    0x8(%eax),%eax
  8027e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8027e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f0:	74 07                	je     8027f9 <alloc_block_BF+0x106>
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	eb 05                	jmp    8027fe <alloc_block_BF+0x10b>
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fe:	a3 40 51 80 00       	mov    %eax,0x805140
  802803:	a1 40 51 80 00       	mov    0x805140,%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	0f 85 fd fe ff ff    	jne    80270d <alloc_block_BF+0x1a>
  802810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802814:	0f 85 f3 fe ff ff    	jne    80270d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80281a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80281e:	0f 84 d9 00 00 00    	je     8028fd <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802824:	a1 48 51 80 00       	mov    0x805148,%eax
  802829:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80282c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802832:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802838:	8b 55 08             	mov    0x8(%ebp),%edx
  80283b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80283e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802842:	75 17                	jne    80285b <alloc_block_BF+0x168>
  802844:	83 ec 04             	sub    $0x4,%esp
  802847:	68 a8 45 80 00       	push   $0x8045a8
  80284c:	68 c7 00 00 00       	push   $0xc7
  802851:	68 ff 44 80 00       	push   $0x8044ff
  802856:	e8 ef dc ff ff       	call   80054a <_panic>
  80285b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	74 10                	je     802874 <alloc_block_BF+0x181>
  802864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80286c:	8b 52 04             	mov    0x4(%edx),%edx
  80286f:	89 50 04             	mov    %edx,0x4(%eax)
  802872:	eb 0b                	jmp    80287f <alloc_block_BF+0x18c>
  802874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802877:	8b 40 04             	mov    0x4(%eax),%eax
  80287a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80287f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	85 c0                	test   %eax,%eax
  802887:	74 0f                	je     802898 <alloc_block_BF+0x1a5>
  802889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288c:	8b 40 04             	mov    0x4(%eax),%eax
  80288f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802892:	8b 12                	mov    (%edx),%edx
  802894:	89 10                	mov    %edx,(%eax)
  802896:	eb 0a                	jmp    8028a2 <alloc_block_BF+0x1af>
  802898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	a3 48 51 80 00       	mov    %eax,0x805148
  8028a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8028ba:	48                   	dec    %eax
  8028bb:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028c0:	83 ec 08             	sub    $0x8,%esp
  8028c3:	ff 75 ec             	pushl  -0x14(%ebp)
  8028c6:	68 38 51 80 00       	push   $0x805138
  8028cb:	e8 71 f9 ff ff       	call   802241 <find_block>
  8028d0:	83 c4 10             	add    $0x10,%esp
  8028d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d9:	8b 50 08             	mov    0x8(%eax),%edx
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	01 c2                	add    %eax,%edx
  8028e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ed:	2b 45 08             	sub    0x8(%ebp),%eax
  8028f0:	89 c2                	mov    %eax,%edx
  8028f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fb:	eb 05                	jmp    802902 <alloc_block_BF+0x20f>
	}
	return NULL;
  8028fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802902:	c9                   	leave  
  802903:	c3                   	ret    

00802904 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
  802907:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80290a:	a1 28 50 80 00       	mov    0x805028,%eax
  80290f:	85 c0                	test   %eax,%eax
  802911:	0f 85 de 01 00 00    	jne    802af5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802917:	a1 38 51 80 00       	mov    0x805138,%eax
  80291c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291f:	e9 9e 01 00 00       	jmp    802ac2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 0c             	mov    0xc(%eax),%eax
  80292a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292d:	0f 82 87 01 00 00    	jb     802aba <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 0c             	mov    0xc(%eax),%eax
  802939:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293c:	0f 85 95 00 00 00    	jne    8029d7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802946:	75 17                	jne    80295f <alloc_block_NF+0x5b>
  802948:	83 ec 04             	sub    $0x4,%esp
  80294b:	68 a8 45 80 00       	push   $0x8045a8
  802950:	68 e0 00 00 00       	push   $0xe0
  802955:	68 ff 44 80 00       	push   $0x8044ff
  80295a:	e8 eb db ff ff       	call   80054a <_panic>
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	85 c0                	test   %eax,%eax
  802966:	74 10                	je     802978 <alloc_block_NF+0x74>
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802970:	8b 52 04             	mov    0x4(%edx),%edx
  802973:	89 50 04             	mov    %edx,0x4(%eax)
  802976:	eb 0b                	jmp    802983 <alloc_block_NF+0x7f>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 40 04             	mov    0x4(%eax),%eax
  80297e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 04             	mov    0x4(%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 0f                	je     80299c <alloc_block_NF+0x98>
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802996:	8b 12                	mov    (%edx),%edx
  802998:	89 10                	mov    %edx,(%eax)
  80299a:	eb 0a                	jmp    8029a6 <alloc_block_NF+0xa2>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8029be:	48                   	dec    %eax
  8029bf:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ca:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	e9 f8 04 00 00       	jmp    802ecf <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e0:	0f 86 d4 00 00 00    	jbe    802aba <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8029eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 50 08             	mov    0x8(%eax),%edx
  8029f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802a00:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a07:	75 17                	jne    802a20 <alloc_block_NF+0x11c>
  802a09:	83 ec 04             	sub    $0x4,%esp
  802a0c:	68 a8 45 80 00       	push   $0x8045a8
  802a11:	68 e9 00 00 00       	push   $0xe9
  802a16:	68 ff 44 80 00       	push   $0x8044ff
  802a1b:	e8 2a db ff ff       	call   80054a <_panic>
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 10                	je     802a39 <alloc_block_NF+0x135>
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a31:	8b 52 04             	mov    0x4(%edx),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	eb 0b                	jmp    802a44 <alloc_block_NF+0x140>
  802a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a47:	8b 40 04             	mov    0x4(%eax),%eax
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	74 0f                	je     802a5d <alloc_block_NF+0x159>
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a57:	8b 12                	mov    (%edx),%edx
  802a59:	89 10                	mov    %edx,(%eax)
  802a5b:	eb 0a                	jmp    802a67 <alloc_block_NF+0x163>
  802a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	a3 48 51 80 00       	mov    %eax,0x805148
  802a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7a:	a1 54 51 80 00       	mov    0x805154,%eax
  802a7f:	48                   	dec    %eax
  802a80:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a88:	8b 40 08             	mov    0x8(%eax),%eax
  802a8b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 50 08             	mov    0x8(%eax),%edx
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	01 c2                	add    %eax,%edx
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa7:	2b 45 08             	sub    0x8(%ebp),%eax
  802aaa:	89 c2                	mov    %eax,%edx
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab5:	e9 15 04 00 00       	jmp    802ecf <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802aba:	a1 40 51 80 00       	mov    0x805140,%eax
  802abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac6:	74 07                	je     802acf <alloc_block_NF+0x1cb>
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 00                	mov    (%eax),%eax
  802acd:	eb 05                	jmp    802ad4 <alloc_block_NF+0x1d0>
  802acf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad4:	a3 40 51 80 00       	mov    %eax,0x805140
  802ad9:	a1 40 51 80 00       	mov    0x805140,%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	0f 85 3e fe ff ff    	jne    802924 <alloc_block_NF+0x20>
  802ae6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aea:	0f 85 34 fe ff ff    	jne    802924 <alloc_block_NF+0x20>
  802af0:	e9 d5 03 00 00       	jmp    802eca <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802af5:	a1 38 51 80 00       	mov    0x805138,%eax
  802afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afd:	e9 b1 01 00 00       	jmp    802cb3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 50 08             	mov    0x8(%eax),%edx
  802b08:	a1 28 50 80 00       	mov    0x805028,%eax
  802b0d:	39 c2                	cmp    %eax,%edx
  802b0f:	0f 82 96 01 00 00    	jb     802cab <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1e:	0f 82 87 01 00 00    	jb     802cab <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2d:	0f 85 95 00 00 00    	jne    802bc8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b37:	75 17                	jne    802b50 <alloc_block_NF+0x24c>
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	68 a8 45 80 00       	push   $0x8045a8
  802b41:	68 fc 00 00 00       	push   $0xfc
  802b46:	68 ff 44 80 00       	push   $0x8044ff
  802b4b:	e8 fa d9 ff ff       	call   80054a <_panic>
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 10                	je     802b69 <alloc_block_NF+0x265>
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b61:	8b 52 04             	mov    0x4(%edx),%edx
  802b64:	89 50 04             	mov    %edx,0x4(%eax)
  802b67:	eb 0b                	jmp    802b74 <alloc_block_NF+0x270>
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 40 04             	mov    0x4(%eax),%eax
  802b6f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0f                	je     802b8d <alloc_block_NF+0x289>
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b87:	8b 12                	mov    (%edx),%edx
  802b89:	89 10                	mov    %edx,(%eax)
  802b8b:	eb 0a                	jmp    802b97 <alloc_block_NF+0x293>
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	a3 38 51 80 00       	mov    %eax,0x805138
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802baa:	a1 44 51 80 00       	mov    0x805144,%eax
  802baf:	48                   	dec    %eax
  802bb0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 40 08             	mov    0x8(%eax),%eax
  802bbb:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	e9 07 03 00 00       	jmp    802ecf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bce:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd1:	0f 86 d4 00 00 00    	jbe    802cab <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bd7:	a1 48 51 80 00       	mov    0x805148,%eax
  802bdc:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 50 08             	mov    0x8(%eax),%edx
  802be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802beb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bee:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bf4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bf8:	75 17                	jne    802c11 <alloc_block_NF+0x30d>
  802bfa:	83 ec 04             	sub    $0x4,%esp
  802bfd:	68 a8 45 80 00       	push   $0x8045a8
  802c02:	68 04 01 00 00       	push   $0x104
  802c07:	68 ff 44 80 00       	push   $0x8044ff
  802c0c:	e8 39 d9 ff ff       	call   80054a <_panic>
  802c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	85 c0                	test   %eax,%eax
  802c18:	74 10                	je     802c2a <alloc_block_NF+0x326>
  802c1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c22:	8b 52 04             	mov    0x4(%edx),%edx
  802c25:	89 50 04             	mov    %edx,0x4(%eax)
  802c28:	eb 0b                	jmp    802c35 <alloc_block_NF+0x331>
  802c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2d:	8b 40 04             	mov    0x4(%eax),%eax
  802c30:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c38:	8b 40 04             	mov    0x4(%eax),%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	74 0f                	je     802c4e <alloc_block_NF+0x34a>
  802c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c42:	8b 40 04             	mov    0x4(%eax),%eax
  802c45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c48:	8b 12                	mov    (%edx),%edx
  802c4a:	89 10                	mov    %edx,(%eax)
  802c4c:	eb 0a                	jmp    802c58 <alloc_block_NF+0x354>
  802c4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c51:	8b 00                	mov    (%eax),%eax
  802c53:	a3 48 51 80 00       	mov    %eax,0x805148
  802c58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6b:	a1 54 51 80 00       	mov    0x805154,%eax
  802c70:	48                   	dec    %eax
  802c71:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c79:	8b 40 08             	mov    0x8(%eax),%eax
  802c7c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 50 08             	mov    0x8(%eax),%edx
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	01 c2                	add    %eax,%edx
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 0c             	mov    0xc(%eax),%eax
  802c98:	2b 45 08             	sub    0x8(%ebp),%eax
  802c9b:	89 c2                	mov    %eax,%edx
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ca3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca6:	e9 24 02 00 00       	jmp    802ecf <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cab:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb7:	74 07                	je     802cc0 <alloc_block_NF+0x3bc>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 00                	mov    (%eax),%eax
  802cbe:	eb 05                	jmp    802cc5 <alloc_block_NF+0x3c1>
  802cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc5:	a3 40 51 80 00       	mov    %eax,0x805140
  802cca:	a1 40 51 80 00       	mov    0x805140,%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	0f 85 2b fe ff ff    	jne    802b02 <alloc_block_NF+0x1fe>
  802cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdb:	0f 85 21 fe ff ff    	jne    802b02 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ce1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce9:	e9 ae 01 00 00       	jmp    802e9c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 50 08             	mov    0x8(%eax),%edx
  802cf4:	a1 28 50 80 00       	mov    0x805028,%eax
  802cf9:	39 c2                	cmp    %eax,%edx
  802cfb:	0f 83 93 01 00 00    	jae    802e94 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 40 0c             	mov    0xc(%eax),%eax
  802d07:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d0a:	0f 82 84 01 00 00    	jb     802e94 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 0c             	mov    0xc(%eax),%eax
  802d16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d19:	0f 85 95 00 00 00    	jne    802db4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d23:	75 17                	jne    802d3c <alloc_block_NF+0x438>
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	68 a8 45 80 00       	push   $0x8045a8
  802d2d:	68 14 01 00 00       	push   $0x114
  802d32:	68 ff 44 80 00       	push   $0x8044ff
  802d37:	e8 0e d8 ff ff       	call   80054a <_panic>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	74 10                	je     802d55 <alloc_block_NF+0x451>
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4d:	8b 52 04             	mov    0x4(%edx),%edx
  802d50:	89 50 04             	mov    %edx,0x4(%eax)
  802d53:	eb 0b                	jmp    802d60 <alloc_block_NF+0x45c>
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 0f                	je     802d79 <alloc_block_NF+0x475>
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d73:	8b 12                	mov    (%edx),%edx
  802d75:	89 10                	mov    %edx,(%eax)
  802d77:	eb 0a                	jmp    802d83 <alloc_block_NF+0x47f>
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d96:	a1 44 51 80 00       	mov    0x805144,%eax
  802d9b:	48                   	dec    %eax
  802d9c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 40 08             	mov    0x8(%eax),%eax
  802da7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	e9 1b 01 00 00       	jmp    802ecf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dbd:	0f 86 d1 00 00 00    	jbe    802e94 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dc3:	a1 48 51 80 00       	mov    0x805148,%eax
  802dc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	8b 50 08             	mov    0x8(%eax),%edx
  802dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dda:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802de0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802de4:	75 17                	jne    802dfd <alloc_block_NF+0x4f9>
  802de6:	83 ec 04             	sub    $0x4,%esp
  802de9:	68 a8 45 80 00       	push   $0x8045a8
  802dee:	68 1c 01 00 00       	push   $0x11c
  802df3:	68 ff 44 80 00       	push   $0x8044ff
  802df8:	e8 4d d7 ff ff       	call   80054a <_panic>
  802dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	85 c0                	test   %eax,%eax
  802e04:	74 10                	je     802e16 <alloc_block_NF+0x512>
  802e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e09:	8b 00                	mov    (%eax),%eax
  802e0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e0e:	8b 52 04             	mov    0x4(%edx),%edx
  802e11:	89 50 04             	mov    %edx,0x4(%eax)
  802e14:	eb 0b                	jmp    802e21 <alloc_block_NF+0x51d>
  802e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e19:	8b 40 04             	mov    0x4(%eax),%eax
  802e1c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e24:	8b 40 04             	mov    0x4(%eax),%eax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	74 0f                	je     802e3a <alloc_block_NF+0x536>
  802e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2e:	8b 40 04             	mov    0x4(%eax),%eax
  802e31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e34:	8b 12                	mov    (%edx),%edx
  802e36:	89 10                	mov    %edx,(%eax)
  802e38:	eb 0a                	jmp    802e44 <alloc_block_NF+0x540>
  802e3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	a3 48 51 80 00       	mov    %eax,0x805148
  802e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e57:	a1 54 51 80 00       	mov    0x805154,%eax
  802e5c:	48                   	dec    %eax
  802e5d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 50 08             	mov    0x8(%eax),%edx
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	01 c2                	add    %eax,%edx
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 40 0c             	mov    0xc(%eax),%eax
  802e84:	2b 45 08             	sub    0x8(%ebp),%eax
  802e87:	89 c2                	mov    %eax,%edx
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e92:	eb 3b                	jmp    802ecf <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e94:	a1 40 51 80 00       	mov    0x805140,%eax
  802e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea0:	74 07                	je     802ea9 <alloc_block_NF+0x5a5>
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	eb 05                	jmp    802eae <alloc_block_NF+0x5aa>
  802ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  802eae:	a3 40 51 80 00       	mov    %eax,0x805140
  802eb3:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	0f 85 2e fe ff ff    	jne    802cee <alloc_block_NF+0x3ea>
  802ec0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec4:	0f 85 24 fe ff ff    	jne    802cee <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802eca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ecf:	c9                   	leave  
  802ed0:	c3                   	ret    

00802ed1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ed1:	55                   	push   %ebp
  802ed2:	89 e5                	mov    %esp,%ebp
  802ed4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ed7:	a1 38 51 80 00       	mov    0x805138,%eax
  802edc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802edf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ee4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ee7:	a1 38 51 80 00       	mov    0x805138,%eax
  802eec:	85 c0                	test   %eax,%eax
  802eee:	74 14                	je     802f04 <insert_sorted_with_merge_freeList+0x33>
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	8b 50 08             	mov    0x8(%eax),%edx
  802ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef9:	8b 40 08             	mov    0x8(%eax),%eax
  802efc:	39 c2                	cmp    %eax,%edx
  802efe:	0f 87 9b 01 00 00    	ja     80309f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f08:	75 17                	jne    802f21 <insert_sorted_with_merge_freeList+0x50>
  802f0a:	83 ec 04             	sub    $0x4,%esp
  802f0d:	68 dc 44 80 00       	push   $0x8044dc
  802f12:	68 38 01 00 00       	push   $0x138
  802f17:	68 ff 44 80 00       	push   $0x8044ff
  802f1c:	e8 29 d6 ff ff       	call   80054a <_panic>
  802f21:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	89 10                	mov    %edx,(%eax)
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	74 0d                	je     802f42 <insert_sorted_with_merge_freeList+0x71>
  802f35:	a1 38 51 80 00       	mov    0x805138,%eax
  802f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3d:	89 50 04             	mov    %edx,0x4(%eax)
  802f40:	eb 08                	jmp    802f4a <insert_sorted_with_merge_freeList+0x79>
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	a3 38 51 80 00       	mov    %eax,0x805138
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f61:	40                   	inc    %eax
  802f62:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f6b:	0f 84 a8 06 00 00    	je     803619 <insert_sorted_with_merge_freeList+0x748>
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 50 08             	mov    0x8(%eax),%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7d:	01 c2                	add    %eax,%edx
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	8b 40 08             	mov    0x8(%eax),%eax
  802f85:	39 c2                	cmp    %eax,%edx
  802f87:	0f 85 8c 06 00 00    	jne    803619 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 50 0c             	mov    0xc(%eax),%edx
  802f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f96:	8b 40 0c             	mov    0xc(%eax),%eax
  802f99:	01 c2                	add    %eax,%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802fa1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fa5:	75 17                	jne    802fbe <insert_sorted_with_merge_freeList+0xed>
  802fa7:	83 ec 04             	sub    $0x4,%esp
  802faa:	68 a8 45 80 00       	push   $0x8045a8
  802faf:	68 3c 01 00 00       	push   $0x13c
  802fb4:	68 ff 44 80 00       	push   $0x8044ff
  802fb9:	e8 8c d5 ff ff       	call   80054a <_panic>
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	74 10                	je     802fd7 <insert_sorted_with_merge_freeList+0x106>
  802fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fca:	8b 00                	mov    (%eax),%eax
  802fcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fcf:	8b 52 04             	mov    0x4(%edx),%edx
  802fd2:	89 50 04             	mov    %edx,0x4(%eax)
  802fd5:	eb 0b                	jmp    802fe2 <insert_sorted_with_merge_freeList+0x111>
  802fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe5:	8b 40 04             	mov    0x4(%eax),%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	74 0f                	je     802ffb <insert_sorted_with_merge_freeList+0x12a>
  802fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fef:	8b 40 04             	mov    0x4(%eax),%eax
  802ff2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ff5:	8b 12                	mov    (%edx),%edx
  802ff7:	89 10                	mov    %edx,(%eax)
  802ff9:	eb 0a                	jmp    803005 <insert_sorted_with_merge_freeList+0x134>
  802ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffe:	8b 00                	mov    (%eax),%eax
  803000:	a3 38 51 80 00       	mov    %eax,0x805138
  803005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803008:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803018:	a1 44 51 80 00       	mov    0x805144,%eax
  80301d:	48                   	dec    %eax
  80301e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803026:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80302d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803030:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803037:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80303b:	75 17                	jne    803054 <insert_sorted_with_merge_freeList+0x183>
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 dc 44 80 00       	push   $0x8044dc
  803045:	68 3f 01 00 00       	push   $0x13f
  80304a:	68 ff 44 80 00       	push   $0x8044ff
  80304f:	e8 f6 d4 ff ff       	call   80054a <_panic>
  803054:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80305a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305d:	89 10                	mov    %edx,(%eax)
  80305f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	74 0d                	je     803075 <insert_sorted_with_merge_freeList+0x1a4>
  803068:	a1 48 51 80 00       	mov    0x805148,%eax
  80306d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803070:	89 50 04             	mov    %edx,0x4(%eax)
  803073:	eb 08                	jmp    80307d <insert_sorted_with_merge_freeList+0x1ac>
  803075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803078:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803080:	a3 48 51 80 00       	mov    %eax,0x805148
  803085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803088:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308f:	a1 54 51 80 00       	mov    0x805154,%eax
  803094:	40                   	inc    %eax
  803095:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80309a:	e9 7a 05 00 00       	jmp    803619 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	8b 50 08             	mov    0x8(%eax),%edx
  8030a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a8:	8b 40 08             	mov    0x8(%eax),%eax
  8030ab:	39 c2                	cmp    %eax,%edx
  8030ad:	0f 82 14 01 00 00    	jb     8031c7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	8b 50 08             	mov    0x8(%eax),%edx
  8030b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bf:	01 c2                	add    %eax,%edx
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	8b 40 08             	mov    0x8(%eax),%eax
  8030c7:	39 c2                	cmp    %eax,%edx
  8030c9:	0f 85 90 00 00 00    	jne    80315f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d2:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030db:	01 c2                	add    %eax,%edx
  8030dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fb:	75 17                	jne    803114 <insert_sorted_with_merge_freeList+0x243>
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	68 dc 44 80 00       	push   $0x8044dc
  803105:	68 49 01 00 00       	push   $0x149
  80310a:	68 ff 44 80 00       	push   $0x8044ff
  80310f:	e8 36 d4 ff ff       	call   80054a <_panic>
  803114:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	89 10                	mov    %edx,(%eax)
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	74 0d                	je     803135 <insert_sorted_with_merge_freeList+0x264>
  803128:	a1 48 51 80 00       	mov    0x805148,%eax
  80312d:	8b 55 08             	mov    0x8(%ebp),%edx
  803130:	89 50 04             	mov    %edx,0x4(%eax)
  803133:	eb 08                	jmp    80313d <insert_sorted_with_merge_freeList+0x26c>
  803135:	8b 45 08             	mov    0x8(%ebp),%eax
  803138:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	a3 48 51 80 00       	mov    %eax,0x805148
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314f:	a1 54 51 80 00       	mov    0x805154,%eax
  803154:	40                   	inc    %eax
  803155:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80315a:	e9 bb 04 00 00       	jmp    80361a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80315f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803163:	75 17                	jne    80317c <insert_sorted_with_merge_freeList+0x2ab>
  803165:	83 ec 04             	sub    $0x4,%esp
  803168:	68 50 45 80 00       	push   $0x804550
  80316d:	68 4c 01 00 00       	push   $0x14c
  803172:	68 ff 44 80 00       	push   $0x8044ff
  803177:	e8 ce d3 ff ff       	call   80054a <_panic>
  80317c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	89 50 04             	mov    %edx,0x4(%eax)
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	8b 40 04             	mov    0x4(%eax),%eax
  80318e:	85 c0                	test   %eax,%eax
  803190:	74 0c                	je     80319e <insert_sorted_with_merge_freeList+0x2cd>
  803192:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803197:	8b 55 08             	mov    0x8(%ebp),%edx
  80319a:	89 10                	mov    %edx,(%eax)
  80319c:	eb 08                	jmp    8031a6 <insert_sorted_with_merge_freeList+0x2d5>
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8031bc:	40                   	inc    %eax
  8031bd:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031c2:	e9 53 04 00 00       	jmp    80361a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8031cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031cf:	e9 15 04 00 00       	jmp    8035e9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	8b 50 08             	mov    0x8(%eax),%edx
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	8b 40 08             	mov    0x8(%eax),%eax
  8031e8:	39 c2                	cmp    %eax,%edx
  8031ea:	0f 86 f1 03 00 00    	jbe    8035e1 <insert_sorted_with_merge_freeList+0x710>
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	8b 50 08             	mov    0x8(%eax),%edx
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	8b 40 08             	mov    0x8(%eax),%eax
  8031fc:	39 c2                	cmp    %eax,%edx
  8031fe:	0f 83 dd 03 00 00    	jae    8035e1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	8b 50 08             	mov    0x8(%eax),%edx
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 40 0c             	mov    0xc(%eax),%eax
  803210:	01 c2                	add    %eax,%edx
  803212:	8b 45 08             	mov    0x8(%ebp),%eax
  803215:	8b 40 08             	mov    0x8(%eax),%eax
  803218:	39 c2                	cmp    %eax,%edx
  80321a:	0f 85 b9 01 00 00    	jne    8033d9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	8b 50 08             	mov    0x8(%eax),%edx
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	8b 40 0c             	mov    0xc(%eax),%eax
  80322c:	01 c2                	add    %eax,%edx
  80322e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803231:	8b 40 08             	mov    0x8(%eax),%eax
  803234:	39 c2                	cmp    %eax,%edx
  803236:	0f 85 0d 01 00 00    	jne    803349 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323f:	8b 50 0c             	mov    0xc(%eax),%edx
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	8b 40 0c             	mov    0xc(%eax),%eax
  803248:	01 c2                	add    %eax,%edx
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803250:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803254:	75 17                	jne    80326d <insert_sorted_with_merge_freeList+0x39c>
  803256:	83 ec 04             	sub    $0x4,%esp
  803259:	68 a8 45 80 00       	push   $0x8045a8
  80325e:	68 5c 01 00 00       	push   $0x15c
  803263:	68 ff 44 80 00       	push   $0x8044ff
  803268:	e8 dd d2 ff ff       	call   80054a <_panic>
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	8b 00                	mov    (%eax),%eax
  803272:	85 c0                	test   %eax,%eax
  803274:	74 10                	je     803286 <insert_sorted_with_merge_freeList+0x3b5>
  803276:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327e:	8b 52 04             	mov    0x4(%edx),%edx
  803281:	89 50 04             	mov    %edx,0x4(%eax)
  803284:	eb 0b                	jmp    803291 <insert_sorted_with_merge_freeList+0x3c0>
  803286:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803289:	8b 40 04             	mov    0x4(%eax),%eax
  80328c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	8b 40 04             	mov    0x4(%eax),%eax
  803297:	85 c0                	test   %eax,%eax
  803299:	74 0f                	je     8032aa <insert_sorted_with_merge_freeList+0x3d9>
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a4:	8b 12                	mov    (%edx),%edx
  8032a6:	89 10                	mov    %edx,(%eax)
  8032a8:	eb 0a                	jmp    8032b4 <insert_sorted_with_merge_freeList+0x3e3>
  8032aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	a3 38 51 80 00       	mov    %eax,0x805138
  8032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032cc:	48                   	dec    %eax
  8032cd:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ea:	75 17                	jne    803303 <insert_sorted_with_merge_freeList+0x432>
  8032ec:	83 ec 04             	sub    $0x4,%esp
  8032ef:	68 dc 44 80 00       	push   $0x8044dc
  8032f4:	68 5f 01 00 00       	push   $0x15f
  8032f9:	68 ff 44 80 00       	push   $0x8044ff
  8032fe:	e8 47 d2 ff ff       	call   80054a <_panic>
  803303:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803309:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330c:	89 10                	mov    %edx,(%eax)
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0d                	je     803324 <insert_sorted_with_merge_freeList+0x453>
  803317:	a1 48 51 80 00       	mov    0x805148,%eax
  80331c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331f:	89 50 04             	mov    %edx,0x4(%eax)
  803322:	eb 08                	jmp    80332c <insert_sorted_with_merge_freeList+0x45b>
  803324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803327:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80332c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332f:	a3 48 51 80 00       	mov    %eax,0x805148
  803334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803337:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333e:	a1 54 51 80 00       	mov    0x805154,%eax
  803343:	40                   	inc    %eax
  803344:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	8b 50 0c             	mov    0xc(%eax),%edx
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	8b 40 0c             	mov    0xc(%eax),%eax
  803355:	01 c2                	add    %eax,%edx
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803371:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803375:	75 17                	jne    80338e <insert_sorted_with_merge_freeList+0x4bd>
  803377:	83 ec 04             	sub    $0x4,%esp
  80337a:	68 dc 44 80 00       	push   $0x8044dc
  80337f:	68 64 01 00 00       	push   $0x164
  803384:	68 ff 44 80 00       	push   $0x8044ff
  803389:	e8 bc d1 ff ff       	call   80054a <_panic>
  80338e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	89 10                	mov    %edx,(%eax)
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	74 0d                	je     8033af <insert_sorted_with_merge_freeList+0x4de>
  8033a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033aa:	89 50 04             	mov    %edx,0x4(%eax)
  8033ad:	eb 08                	jmp    8033b7 <insert_sorted_with_merge_freeList+0x4e6>
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	a3 48 51 80 00       	mov    %eax,0x805148
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ce:	40                   	inc    %eax
  8033cf:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033d4:	e9 41 02 00 00       	jmp    80361a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 50 08             	mov    0x8(%eax),%edx
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e5:	01 c2                	add    %eax,%edx
  8033e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ea:	8b 40 08             	mov    0x8(%eax),%eax
  8033ed:	39 c2                	cmp    %eax,%edx
  8033ef:	0f 85 7c 01 00 00    	jne    803571 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033f9:	74 06                	je     803401 <insert_sorted_with_merge_freeList+0x530>
  8033fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ff:	75 17                	jne    803418 <insert_sorted_with_merge_freeList+0x547>
  803401:	83 ec 04             	sub    $0x4,%esp
  803404:	68 18 45 80 00       	push   $0x804518
  803409:	68 69 01 00 00       	push   $0x169
  80340e:	68 ff 44 80 00       	push   $0x8044ff
  803413:	e8 32 d1 ff ff       	call   80054a <_panic>
  803418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341b:	8b 50 04             	mov    0x4(%eax),%edx
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	89 50 04             	mov    %edx,0x4(%eax)
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342a:	89 10                	mov    %edx,(%eax)
  80342c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342f:	8b 40 04             	mov    0x4(%eax),%eax
  803432:	85 c0                	test   %eax,%eax
  803434:	74 0d                	je     803443 <insert_sorted_with_merge_freeList+0x572>
  803436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803439:	8b 40 04             	mov    0x4(%eax),%eax
  80343c:	8b 55 08             	mov    0x8(%ebp),%edx
  80343f:	89 10                	mov    %edx,(%eax)
  803441:	eb 08                	jmp    80344b <insert_sorted_with_merge_freeList+0x57a>
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	a3 38 51 80 00       	mov    %eax,0x805138
  80344b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344e:	8b 55 08             	mov    0x8(%ebp),%edx
  803451:	89 50 04             	mov    %edx,0x4(%eax)
  803454:	a1 44 51 80 00       	mov    0x805144,%eax
  803459:	40                   	inc    %eax
  80345a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	8b 50 0c             	mov    0xc(%eax),%edx
  803465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803468:	8b 40 0c             	mov    0xc(%eax),%eax
  80346b:	01 c2                	add    %eax,%edx
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803473:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803477:	75 17                	jne    803490 <insert_sorted_with_merge_freeList+0x5bf>
  803479:	83 ec 04             	sub    $0x4,%esp
  80347c:	68 a8 45 80 00       	push   $0x8045a8
  803481:	68 6b 01 00 00       	push   $0x16b
  803486:	68 ff 44 80 00       	push   $0x8044ff
  80348b:	e8 ba d0 ff ff       	call   80054a <_panic>
  803490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	74 10                	je     8034a9 <insert_sorted_with_merge_freeList+0x5d8>
  803499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349c:	8b 00                	mov    (%eax),%eax
  80349e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a1:	8b 52 04             	mov    0x4(%edx),%edx
  8034a4:	89 50 04             	mov    %edx,0x4(%eax)
  8034a7:	eb 0b                	jmp    8034b4 <insert_sorted_with_merge_freeList+0x5e3>
  8034a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ac:	8b 40 04             	mov    0x4(%eax),%eax
  8034af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	74 0f                	je     8034cd <insert_sorted_with_merge_freeList+0x5fc>
  8034be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c1:	8b 40 04             	mov    0x4(%eax),%eax
  8034c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034c7:	8b 12                	mov    (%edx),%edx
  8034c9:	89 10                	mov    %edx,(%eax)
  8034cb:	eb 0a                	jmp    8034d7 <insert_sorted_with_merge_freeList+0x606>
  8034cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d0:	8b 00                	mov    (%eax),%eax
  8034d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ef:	48                   	dec    %eax
  8034f0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803502:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803509:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80350d:	75 17                	jne    803526 <insert_sorted_with_merge_freeList+0x655>
  80350f:	83 ec 04             	sub    $0x4,%esp
  803512:	68 dc 44 80 00       	push   $0x8044dc
  803517:	68 6e 01 00 00       	push   $0x16e
  80351c:	68 ff 44 80 00       	push   $0x8044ff
  803521:	e8 24 d0 ff ff       	call   80054a <_panic>
  803526:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80352c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352f:	89 10                	mov    %edx,(%eax)
  803531:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803534:	8b 00                	mov    (%eax),%eax
  803536:	85 c0                	test   %eax,%eax
  803538:	74 0d                	je     803547 <insert_sorted_with_merge_freeList+0x676>
  80353a:	a1 48 51 80 00       	mov    0x805148,%eax
  80353f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803542:	89 50 04             	mov    %edx,0x4(%eax)
  803545:	eb 08                	jmp    80354f <insert_sorted_with_merge_freeList+0x67e>
  803547:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80354f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803552:	a3 48 51 80 00       	mov    %eax,0x805148
  803557:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803561:	a1 54 51 80 00       	mov    0x805154,%eax
  803566:	40                   	inc    %eax
  803567:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80356c:	e9 a9 00 00 00       	jmp    80361a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803575:	74 06                	je     80357d <insert_sorted_with_merge_freeList+0x6ac>
  803577:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80357b:	75 17                	jne    803594 <insert_sorted_with_merge_freeList+0x6c3>
  80357d:	83 ec 04             	sub    $0x4,%esp
  803580:	68 74 45 80 00       	push   $0x804574
  803585:	68 73 01 00 00       	push   $0x173
  80358a:	68 ff 44 80 00       	push   $0x8044ff
  80358f:	e8 b6 cf ff ff       	call   80054a <_panic>
  803594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803597:	8b 10                	mov    (%eax),%edx
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	89 10                	mov    %edx,(%eax)
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	8b 00                	mov    (%eax),%eax
  8035a3:	85 c0                	test   %eax,%eax
  8035a5:	74 0b                	je     8035b2 <insert_sorted_with_merge_freeList+0x6e1>
  8035a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035aa:	8b 00                	mov    (%eax),%eax
  8035ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8035af:	89 50 04             	mov    %edx,0x4(%eax)
  8035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8035b8:	89 10                	mov    %edx,(%eax)
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035c0:	89 50 04             	mov    %edx,0x4(%eax)
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	8b 00                	mov    (%eax),%eax
  8035c8:	85 c0                	test   %eax,%eax
  8035ca:	75 08                	jne    8035d4 <insert_sorted_with_merge_freeList+0x703>
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8035d9:	40                   	inc    %eax
  8035da:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035df:	eb 39                	jmp    80361a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8035e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ed:	74 07                	je     8035f6 <insert_sorted_with_merge_freeList+0x725>
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	8b 00                	mov    (%eax),%eax
  8035f4:	eb 05                	jmp    8035fb <insert_sorted_with_merge_freeList+0x72a>
  8035f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035fb:	a3 40 51 80 00       	mov    %eax,0x805140
  803600:	a1 40 51 80 00       	mov    0x805140,%eax
  803605:	85 c0                	test   %eax,%eax
  803607:	0f 85 c7 fb ff ff    	jne    8031d4 <insert_sorted_with_merge_freeList+0x303>
  80360d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803611:	0f 85 bd fb ff ff    	jne    8031d4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803617:	eb 01                	jmp    80361a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803619:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80361a:	90                   	nop
  80361b:	c9                   	leave  
  80361c:	c3                   	ret    

0080361d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80361d:	55                   	push   %ebp
  80361e:	89 e5                	mov    %esp,%ebp
  803620:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803623:	8b 55 08             	mov    0x8(%ebp),%edx
  803626:	89 d0                	mov    %edx,%eax
  803628:	c1 e0 02             	shl    $0x2,%eax
  80362b:	01 d0                	add    %edx,%eax
  80362d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803634:	01 d0                	add    %edx,%eax
  803636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80363d:	01 d0                	add    %edx,%eax
  80363f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803646:	01 d0                	add    %edx,%eax
  803648:	c1 e0 04             	shl    $0x4,%eax
  80364b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80364e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803655:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803658:	83 ec 0c             	sub    $0xc,%esp
  80365b:	50                   	push   %eax
  80365c:	e8 26 e7 ff ff       	call   801d87 <sys_get_virtual_time>
  803661:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803664:	eb 41                	jmp    8036a7 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803666:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803669:	83 ec 0c             	sub    $0xc,%esp
  80366c:	50                   	push   %eax
  80366d:	e8 15 e7 ff ff       	call   801d87 <sys_get_virtual_time>
  803672:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803675:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803678:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367b:	29 c2                	sub    %eax,%edx
  80367d:	89 d0                	mov    %edx,%eax
  80367f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803688:	89 d1                	mov    %edx,%ecx
  80368a:	29 c1                	sub    %eax,%ecx
  80368c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80368f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803692:	39 c2                	cmp    %eax,%edx
  803694:	0f 97 c0             	seta   %al
  803697:	0f b6 c0             	movzbl %al,%eax
  80369a:	29 c1                	sub    %eax,%ecx
  80369c:	89 c8                	mov    %ecx,%eax
  80369e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8036a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8036a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8036ad:	72 b7                	jb     803666 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8036af:	90                   	nop
  8036b0:	c9                   	leave  
  8036b1:	c3                   	ret    

008036b2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8036b2:	55                   	push   %ebp
  8036b3:	89 e5                	mov    %esp,%ebp
  8036b5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8036b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8036bf:	eb 03                	jmp    8036c4 <busy_wait+0x12>
  8036c1:	ff 45 fc             	incl   -0x4(%ebp)
  8036c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036ca:	72 f5                	jb     8036c1 <busy_wait+0xf>
	return i;
  8036cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8036cf:	c9                   	leave  
  8036d0:	c3                   	ret    
  8036d1:	66 90                	xchg   %ax,%ax
  8036d3:	90                   	nop

008036d4 <__udivdi3>:
  8036d4:	55                   	push   %ebp
  8036d5:	57                   	push   %edi
  8036d6:	56                   	push   %esi
  8036d7:	53                   	push   %ebx
  8036d8:	83 ec 1c             	sub    $0x1c,%esp
  8036db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036eb:	89 ca                	mov    %ecx,%edx
  8036ed:	89 f8                	mov    %edi,%eax
  8036ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036f3:	85 f6                	test   %esi,%esi
  8036f5:	75 2d                	jne    803724 <__udivdi3+0x50>
  8036f7:	39 cf                	cmp    %ecx,%edi
  8036f9:	77 65                	ja     803760 <__udivdi3+0x8c>
  8036fb:	89 fd                	mov    %edi,%ebp
  8036fd:	85 ff                	test   %edi,%edi
  8036ff:	75 0b                	jne    80370c <__udivdi3+0x38>
  803701:	b8 01 00 00 00       	mov    $0x1,%eax
  803706:	31 d2                	xor    %edx,%edx
  803708:	f7 f7                	div    %edi
  80370a:	89 c5                	mov    %eax,%ebp
  80370c:	31 d2                	xor    %edx,%edx
  80370e:	89 c8                	mov    %ecx,%eax
  803710:	f7 f5                	div    %ebp
  803712:	89 c1                	mov    %eax,%ecx
  803714:	89 d8                	mov    %ebx,%eax
  803716:	f7 f5                	div    %ebp
  803718:	89 cf                	mov    %ecx,%edi
  80371a:	89 fa                	mov    %edi,%edx
  80371c:	83 c4 1c             	add    $0x1c,%esp
  80371f:	5b                   	pop    %ebx
  803720:	5e                   	pop    %esi
  803721:	5f                   	pop    %edi
  803722:	5d                   	pop    %ebp
  803723:	c3                   	ret    
  803724:	39 ce                	cmp    %ecx,%esi
  803726:	77 28                	ja     803750 <__udivdi3+0x7c>
  803728:	0f bd fe             	bsr    %esi,%edi
  80372b:	83 f7 1f             	xor    $0x1f,%edi
  80372e:	75 40                	jne    803770 <__udivdi3+0x9c>
  803730:	39 ce                	cmp    %ecx,%esi
  803732:	72 0a                	jb     80373e <__udivdi3+0x6a>
  803734:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803738:	0f 87 9e 00 00 00    	ja     8037dc <__udivdi3+0x108>
  80373e:	b8 01 00 00 00       	mov    $0x1,%eax
  803743:	89 fa                	mov    %edi,%edx
  803745:	83 c4 1c             	add    $0x1c,%esp
  803748:	5b                   	pop    %ebx
  803749:	5e                   	pop    %esi
  80374a:	5f                   	pop    %edi
  80374b:	5d                   	pop    %ebp
  80374c:	c3                   	ret    
  80374d:	8d 76 00             	lea    0x0(%esi),%esi
  803750:	31 ff                	xor    %edi,%edi
  803752:	31 c0                	xor    %eax,%eax
  803754:	89 fa                	mov    %edi,%edx
  803756:	83 c4 1c             	add    $0x1c,%esp
  803759:	5b                   	pop    %ebx
  80375a:	5e                   	pop    %esi
  80375b:	5f                   	pop    %edi
  80375c:	5d                   	pop    %ebp
  80375d:	c3                   	ret    
  80375e:	66 90                	xchg   %ax,%ax
  803760:	89 d8                	mov    %ebx,%eax
  803762:	f7 f7                	div    %edi
  803764:	31 ff                	xor    %edi,%edi
  803766:	89 fa                	mov    %edi,%edx
  803768:	83 c4 1c             	add    $0x1c,%esp
  80376b:	5b                   	pop    %ebx
  80376c:	5e                   	pop    %esi
  80376d:	5f                   	pop    %edi
  80376e:	5d                   	pop    %ebp
  80376f:	c3                   	ret    
  803770:	bd 20 00 00 00       	mov    $0x20,%ebp
  803775:	89 eb                	mov    %ebp,%ebx
  803777:	29 fb                	sub    %edi,%ebx
  803779:	89 f9                	mov    %edi,%ecx
  80377b:	d3 e6                	shl    %cl,%esi
  80377d:	89 c5                	mov    %eax,%ebp
  80377f:	88 d9                	mov    %bl,%cl
  803781:	d3 ed                	shr    %cl,%ebp
  803783:	89 e9                	mov    %ebp,%ecx
  803785:	09 f1                	or     %esi,%ecx
  803787:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80378b:	89 f9                	mov    %edi,%ecx
  80378d:	d3 e0                	shl    %cl,%eax
  80378f:	89 c5                	mov    %eax,%ebp
  803791:	89 d6                	mov    %edx,%esi
  803793:	88 d9                	mov    %bl,%cl
  803795:	d3 ee                	shr    %cl,%esi
  803797:	89 f9                	mov    %edi,%ecx
  803799:	d3 e2                	shl    %cl,%edx
  80379b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80379f:	88 d9                	mov    %bl,%cl
  8037a1:	d3 e8                	shr    %cl,%eax
  8037a3:	09 c2                	or     %eax,%edx
  8037a5:	89 d0                	mov    %edx,%eax
  8037a7:	89 f2                	mov    %esi,%edx
  8037a9:	f7 74 24 0c          	divl   0xc(%esp)
  8037ad:	89 d6                	mov    %edx,%esi
  8037af:	89 c3                	mov    %eax,%ebx
  8037b1:	f7 e5                	mul    %ebp
  8037b3:	39 d6                	cmp    %edx,%esi
  8037b5:	72 19                	jb     8037d0 <__udivdi3+0xfc>
  8037b7:	74 0b                	je     8037c4 <__udivdi3+0xf0>
  8037b9:	89 d8                	mov    %ebx,%eax
  8037bb:	31 ff                	xor    %edi,%edi
  8037bd:	e9 58 ff ff ff       	jmp    80371a <__udivdi3+0x46>
  8037c2:	66 90                	xchg   %ax,%ax
  8037c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037c8:	89 f9                	mov    %edi,%ecx
  8037ca:	d3 e2                	shl    %cl,%edx
  8037cc:	39 c2                	cmp    %eax,%edx
  8037ce:	73 e9                	jae    8037b9 <__udivdi3+0xe5>
  8037d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037d3:	31 ff                	xor    %edi,%edi
  8037d5:	e9 40 ff ff ff       	jmp    80371a <__udivdi3+0x46>
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	31 c0                	xor    %eax,%eax
  8037de:	e9 37 ff ff ff       	jmp    80371a <__udivdi3+0x46>
  8037e3:	90                   	nop

008037e4 <__umoddi3>:
  8037e4:	55                   	push   %ebp
  8037e5:	57                   	push   %edi
  8037e6:	56                   	push   %esi
  8037e7:	53                   	push   %ebx
  8037e8:	83 ec 1c             	sub    $0x1c,%esp
  8037eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803803:	89 f3                	mov    %esi,%ebx
  803805:	89 fa                	mov    %edi,%edx
  803807:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80380b:	89 34 24             	mov    %esi,(%esp)
  80380e:	85 c0                	test   %eax,%eax
  803810:	75 1a                	jne    80382c <__umoddi3+0x48>
  803812:	39 f7                	cmp    %esi,%edi
  803814:	0f 86 a2 00 00 00    	jbe    8038bc <__umoddi3+0xd8>
  80381a:	89 c8                	mov    %ecx,%eax
  80381c:	89 f2                	mov    %esi,%edx
  80381e:	f7 f7                	div    %edi
  803820:	89 d0                	mov    %edx,%eax
  803822:	31 d2                	xor    %edx,%edx
  803824:	83 c4 1c             	add    $0x1c,%esp
  803827:	5b                   	pop    %ebx
  803828:	5e                   	pop    %esi
  803829:	5f                   	pop    %edi
  80382a:	5d                   	pop    %ebp
  80382b:	c3                   	ret    
  80382c:	39 f0                	cmp    %esi,%eax
  80382e:	0f 87 ac 00 00 00    	ja     8038e0 <__umoddi3+0xfc>
  803834:	0f bd e8             	bsr    %eax,%ebp
  803837:	83 f5 1f             	xor    $0x1f,%ebp
  80383a:	0f 84 ac 00 00 00    	je     8038ec <__umoddi3+0x108>
  803840:	bf 20 00 00 00       	mov    $0x20,%edi
  803845:	29 ef                	sub    %ebp,%edi
  803847:	89 fe                	mov    %edi,%esi
  803849:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80384d:	89 e9                	mov    %ebp,%ecx
  80384f:	d3 e0                	shl    %cl,%eax
  803851:	89 d7                	mov    %edx,%edi
  803853:	89 f1                	mov    %esi,%ecx
  803855:	d3 ef                	shr    %cl,%edi
  803857:	09 c7                	or     %eax,%edi
  803859:	89 e9                	mov    %ebp,%ecx
  80385b:	d3 e2                	shl    %cl,%edx
  80385d:	89 14 24             	mov    %edx,(%esp)
  803860:	89 d8                	mov    %ebx,%eax
  803862:	d3 e0                	shl    %cl,%eax
  803864:	89 c2                	mov    %eax,%edx
  803866:	8b 44 24 08          	mov    0x8(%esp),%eax
  80386a:	d3 e0                	shl    %cl,%eax
  80386c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803870:	8b 44 24 08          	mov    0x8(%esp),%eax
  803874:	89 f1                	mov    %esi,%ecx
  803876:	d3 e8                	shr    %cl,%eax
  803878:	09 d0                	or     %edx,%eax
  80387a:	d3 eb                	shr    %cl,%ebx
  80387c:	89 da                	mov    %ebx,%edx
  80387e:	f7 f7                	div    %edi
  803880:	89 d3                	mov    %edx,%ebx
  803882:	f7 24 24             	mull   (%esp)
  803885:	89 c6                	mov    %eax,%esi
  803887:	89 d1                	mov    %edx,%ecx
  803889:	39 d3                	cmp    %edx,%ebx
  80388b:	0f 82 87 00 00 00    	jb     803918 <__umoddi3+0x134>
  803891:	0f 84 91 00 00 00    	je     803928 <__umoddi3+0x144>
  803897:	8b 54 24 04          	mov    0x4(%esp),%edx
  80389b:	29 f2                	sub    %esi,%edx
  80389d:	19 cb                	sbb    %ecx,%ebx
  80389f:	89 d8                	mov    %ebx,%eax
  8038a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038a5:	d3 e0                	shl    %cl,%eax
  8038a7:	89 e9                	mov    %ebp,%ecx
  8038a9:	d3 ea                	shr    %cl,%edx
  8038ab:	09 d0                	or     %edx,%eax
  8038ad:	89 e9                	mov    %ebp,%ecx
  8038af:	d3 eb                	shr    %cl,%ebx
  8038b1:	89 da                	mov    %ebx,%edx
  8038b3:	83 c4 1c             	add    $0x1c,%esp
  8038b6:	5b                   	pop    %ebx
  8038b7:	5e                   	pop    %esi
  8038b8:	5f                   	pop    %edi
  8038b9:	5d                   	pop    %ebp
  8038ba:	c3                   	ret    
  8038bb:	90                   	nop
  8038bc:	89 fd                	mov    %edi,%ebp
  8038be:	85 ff                	test   %edi,%edi
  8038c0:	75 0b                	jne    8038cd <__umoddi3+0xe9>
  8038c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c7:	31 d2                	xor    %edx,%edx
  8038c9:	f7 f7                	div    %edi
  8038cb:	89 c5                	mov    %eax,%ebp
  8038cd:	89 f0                	mov    %esi,%eax
  8038cf:	31 d2                	xor    %edx,%edx
  8038d1:	f7 f5                	div    %ebp
  8038d3:	89 c8                	mov    %ecx,%eax
  8038d5:	f7 f5                	div    %ebp
  8038d7:	89 d0                	mov    %edx,%eax
  8038d9:	e9 44 ff ff ff       	jmp    803822 <__umoddi3+0x3e>
  8038de:	66 90                	xchg   %ax,%ax
  8038e0:	89 c8                	mov    %ecx,%eax
  8038e2:	89 f2                	mov    %esi,%edx
  8038e4:	83 c4 1c             	add    $0x1c,%esp
  8038e7:	5b                   	pop    %ebx
  8038e8:	5e                   	pop    %esi
  8038e9:	5f                   	pop    %edi
  8038ea:	5d                   	pop    %ebp
  8038eb:	c3                   	ret    
  8038ec:	3b 04 24             	cmp    (%esp),%eax
  8038ef:	72 06                	jb     8038f7 <__umoddi3+0x113>
  8038f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038f5:	77 0f                	ja     803906 <__umoddi3+0x122>
  8038f7:	89 f2                	mov    %esi,%edx
  8038f9:	29 f9                	sub    %edi,%ecx
  8038fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038ff:	89 14 24             	mov    %edx,(%esp)
  803902:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803906:	8b 44 24 04          	mov    0x4(%esp),%eax
  80390a:	8b 14 24             	mov    (%esp),%edx
  80390d:	83 c4 1c             	add    $0x1c,%esp
  803910:	5b                   	pop    %ebx
  803911:	5e                   	pop    %esi
  803912:	5f                   	pop    %edi
  803913:	5d                   	pop    %ebp
  803914:	c3                   	ret    
  803915:	8d 76 00             	lea    0x0(%esi),%esi
  803918:	2b 04 24             	sub    (%esp),%eax
  80391b:	19 fa                	sbb    %edi,%edx
  80391d:	89 d1                	mov    %edx,%ecx
  80391f:	89 c6                	mov    %eax,%esi
  803921:	e9 71 ff ff ff       	jmp    803897 <__umoddi3+0xb3>
  803926:	66 90                	xchg   %ax,%ax
  803928:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80392c:	72 ea                	jb     803918 <__umoddi3+0x134>
  80392e:	89 d9                	mov    %ebx,%ecx
  803930:	e9 62 ff ff ff       	jmp    803897 <__umoddi3+0xb3>
