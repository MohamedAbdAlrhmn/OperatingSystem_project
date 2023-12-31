
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
  80008d:	68 80 3a 80 00       	push   $0x803a80
  800092:	6a 12                	push   $0x12
  800094:	68 9c 3a 80 00       	push   $0x803a9c
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
  8000ae:	68 b8 3a 80 00       	push   $0x803ab8
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 ec 3a 80 00       	push   $0x803aec
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 48 3b 80 00       	push   $0x803b48
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 8a 1d 00 00       	call   801e6a <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 7c 3b 80 00       	push   $0x803b7c
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
  80011d:	68 bd 3b 80 00       	push   $0x803bbd
  800122:	e8 ee 1c 00 00       	call   801e15 <sys_create_env>
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
  800150:	68 bd 3b 80 00       	push   $0x803bbd
  800155:	e8 bb 1c 00 00       	call   801e15 <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 3e 1a 00 00       	call   801ba3 <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 c8 3b 80 00       	push   $0x803bc8
  800177:	e8 55 17 00 00       	call   8018d1 <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 cc 3b 80 00       	push   $0x803bcc
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 ec 3b 80 00       	push   $0x803bec
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 9c 3a 80 00       	push   $0x803a9c
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 ec 19 00 00       	call   801ba3 <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 58 3c 80 00       	push   $0x803c58
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 9c 3a 80 00       	push   $0x803a9c
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 88 1d 00 00       	call   801f61 <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 4f 1c 00 00       	call   801e33 <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 41 1c 00 00       	call   801e33 <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 d6 3c 80 00       	push   $0x803cd6
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 53 35 00 00       	call   803765 <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 c0 1d 00 00       	call   801fdb <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 7e 19 00 00       	call   801ba3 <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 10 18 00 00       	call   801a43 <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 f0 3c 80 00       	push   $0x803cf0
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 58 19 00 00       	call   801ba3 <sys_calculate_free_frames>
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
  80026f:	68 10 3d 80 00       	push   $0x803d10
  800274:	6a 3b                	push   $0x3b
  800276:	68 9c 3a 80 00       	push   $0x803a9c
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 58 3d 80 00       	push   $0x803d58
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 7c 3d 80 00       	push   $0x803d7c
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
  8002c3:	68 ac 3d 80 00       	push   $0x803dac
  8002c8:	e8 48 1b 00 00       	call   801e15 <sys_create_env>
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
  8002f6:	68 b9 3d 80 00       	push   $0x803db9
  8002fb:	e8 15 1b 00 00       	call   801e15 <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 c6 3d 80 00       	push   $0x803dc6
  800315:	e8 b7 15 00 00       	call   8018d1 <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 c8 3d 80 00       	push   $0x803dc8
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 c8 3b 80 00       	push   $0x803bc8
  80033f:	e8 8d 15 00 00       	call   8018d1 <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 cc 3b 80 00       	push   $0x803bcc
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 02 1c 00 00       	call   801f61 <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 c9 1a 00 00       	call   801e33 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 bb 1a 00 00       	call   801e33 <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 5a 1c 00 00       	call   801fdb <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 d6 1b 00 00       	call   801f61 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 13 18 00 00       	call   801ba3 <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 a5 16 00 00       	call   801a43 <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 e8 3d 80 00       	push   $0x803de8
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 87 16 00 00       	call   801a43 <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 fe 3d 80 00       	push   $0x803dfe
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 cf 17 00 00       	call   801ba3 <sys_calculate_free_frames>
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
  8003f2:	68 14 3e 80 00       	push   $0x803e14
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 9c 3a 80 00       	push   $0x803a9c
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 b9 1b 00 00       	call   801fc1 <inctst>


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
  800414:	e8 6a 1a 00 00       	call   801e83 <sys_getenvindex>
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
  80047f:	e8 0c 18 00 00       	call   801c90 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 d4 3e 80 00       	push   $0x803ed4
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
  8004af:	68 fc 3e 80 00       	push   $0x803efc
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
  8004e0:	68 24 3f 80 00       	push   $0x803f24
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 7c 3f 80 00       	push   $0x803f7c
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 d4 3e 80 00       	push   $0x803ed4
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 8c 17 00 00       	call   801caa <sys_enable_interrupt>

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
  800531:	e8 19 19 00 00       	call   801e4f <sys_destroy_env>
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
  800542:	e8 6e 19 00 00       	call   801eb5 <sys_exit_env>
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
  80056b:	68 90 3f 80 00       	push   $0x803f90
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 95 3f 80 00       	push   $0x803f95
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
  8005a8:	68 b1 3f 80 00       	push   $0x803fb1
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
  8005d4:	68 b4 3f 80 00       	push   $0x803fb4
  8005d9:	6a 26                	push   $0x26
  8005db:	68 00 40 80 00       	push   $0x804000
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
  8006a6:	68 0c 40 80 00       	push   $0x80400c
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 00 40 80 00       	push   $0x804000
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
  800716:	68 60 40 80 00       	push   $0x804060
  80071b:	6a 44                	push   $0x44
  80071d:	68 00 40 80 00       	push   $0x804000
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
  800770:	e8 6d 13 00 00       	call   801ae2 <sys_cputs>
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
  8007e7:	e8 f6 12 00 00       	call   801ae2 <sys_cputs>
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
  800831:	e8 5a 14 00 00       	call   801c90 <sys_disable_interrupt>
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
  800851:	e8 54 14 00 00       	call   801caa <sys_enable_interrupt>
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
  80089b:	e8 7c 2f 00 00       	call   80381c <__udivdi3>
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
  8008eb:	e8 3c 30 00 00       	call   80392c <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 d4 42 80 00       	add    $0x8042d4,%eax
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
  800a46:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
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
  800b27:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 e5 42 80 00       	push   $0x8042e5
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
  800b4c:	68 ee 42 80 00       	push   $0x8042ee
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
  800b79:	be f1 42 80 00       	mov    $0x8042f1,%esi
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
  80159f:	68 50 44 80 00       	push   $0x804450
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
  80166f:	e8 b2 05 00 00       	call   801c26 <sys_allocate_chunk>
  801674:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801677:	a1 20 51 80 00       	mov    0x805120,%eax
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	50                   	push   %eax
  801680:	e8 27 0c 00 00       	call   8022ac <initialize_MemBlocksList>
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
  8016ad:	68 75 44 80 00       	push   $0x804475
  8016b2:	6a 33                	push   $0x33
  8016b4:	68 93 44 80 00       	push   $0x804493
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
  80172c:	68 a0 44 80 00       	push   $0x8044a0
  801731:	6a 34                	push   $0x34
  801733:	68 93 44 80 00       	push   $0x804493
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
  8017c4:	e8 2b 08 00 00       	call   801ff4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	74 11                	je     8017de <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d3:	e8 96 0e 00 00       	call   80266e <alloc_block_FF>
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
  8017ea:	e8 f2 0b 00 00       	call   8023e1 <insert_sorted_allocList>
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
  801804:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	83 ec 08             	sub    $0x8,%esp
  80180d:	50                   	push   %eax
  80180e:	68 40 50 80 00       	push   $0x805040
  801813:	e8 71 0b 00 00       	call   802389 <find_block>
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80181e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801822:	0f 84 a6 00 00 00    	je     8018ce <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182b:	8b 50 0c             	mov    0xc(%eax),%edx
  80182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801831:	8b 40 08             	mov    0x8(%eax),%eax
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	52                   	push   %edx
  801838:	50                   	push   %eax
  801839:	e8 b0 03 00 00       	call   801bee <sys_free_user_mem>
  80183e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801845:	75 14                	jne    80185b <free+0x5a>
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	68 75 44 80 00       	push   $0x804475
  80184f:	6a 74                	push   $0x74
  801851:	68 93 44 80 00       	push   $0x804493
  801856:	e8 ef ec ff ff       	call   80054a <_panic>
  80185b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185e:	8b 00                	mov    (%eax),%eax
  801860:	85 c0                	test   %eax,%eax
  801862:	74 10                	je     801874 <free+0x73>
  801864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801867:	8b 00                	mov    (%eax),%eax
  801869:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186c:	8b 52 04             	mov    0x4(%edx),%edx
  80186f:	89 50 04             	mov    %edx,0x4(%eax)
  801872:	eb 0b                	jmp    80187f <free+0x7e>
  801874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801877:	8b 40 04             	mov    0x4(%eax),%eax
  80187a:	a3 44 50 80 00       	mov    %eax,0x805044
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	8b 40 04             	mov    0x4(%eax),%eax
  801885:	85 c0                	test   %eax,%eax
  801887:	74 0f                	je     801898 <free+0x97>
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	8b 40 04             	mov    0x4(%eax),%eax
  80188f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801892:	8b 12                	mov    (%edx),%edx
  801894:	89 10                	mov    %edx,(%eax)
  801896:	eb 0a                	jmp    8018a2 <free+0xa1>
  801898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189b:	8b 00                	mov    (%eax),%eax
  80189d:	a3 40 50 80 00       	mov    %eax,0x805040
  8018a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8018ba:	48                   	dec    %eax
  8018bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  8018c0:	83 ec 0c             	sub    $0xc,%esp
  8018c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c6:	e8 4e 17 00 00       	call   803019 <insert_sorted_with_merge_freeList>
  8018cb:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	83 ec 08             	sub    $0x8,%esp
  80180d:	50                   	push   %eax
  80180e:	68 40 50 80 00       	push   $0x805040
  801813:	e8 71 0b 00 00       	call   802389 <find_block>
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  80181e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801822:	0f 84 a6 00 00 00    	je     8018ce <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182b:	8b 50 0c             	mov    0xc(%eax),%edx
  80182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801831:	8b 40 08             	mov    0x8(%eax),%eax
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	52                   	push   %edx
  801838:	50                   	push   %eax
  801839:	e8 b0 03 00 00       	call   801bee <sys_free_user_mem>
  80183e:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  801841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801845:	75 14                	jne    80185b <free+0x5a>
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	68 75 44 80 00       	push   $0x804475
  80184f:	6a 7a                	push   $0x7a
  801851:	68 93 44 80 00       	push   $0x804493
  801856:	e8 ef ec ff ff       	call   80054a <_panic>
  80185b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185e:	8b 00                	mov    (%eax),%eax
  801860:	85 c0                	test   %eax,%eax
  801862:	74 10                	je     801874 <free+0x73>
  801864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801867:	8b 00                	mov    (%eax),%eax
  801869:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186c:	8b 52 04             	mov    0x4(%edx),%edx
  80186f:	89 50 04             	mov    %edx,0x4(%eax)
  801872:	eb 0b                	jmp    80187f <free+0x7e>
  801874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801877:	8b 40 04             	mov    0x4(%eax),%eax
  80187a:	a3 44 50 80 00       	mov    %eax,0x805044
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	8b 40 04             	mov    0x4(%eax),%eax
  801885:	85 c0                	test   %eax,%eax
  801887:	74 0f                	je     801898 <free+0x97>
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	8b 40 04             	mov    0x4(%eax),%eax
  80188f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801892:	8b 12                	mov    (%edx),%edx
  801894:	89 10                	mov    %edx,(%eax)
  801896:	eb 0a                	jmp    8018a2 <free+0xa1>
  801898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189b:	8b 00                	mov    (%eax),%eax
  80189d:	a3 40 50 80 00       	mov    %eax,0x805040
  8018a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8018ba:	48                   	dec    %eax
  8018bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  8018c0:	83 ec 0c             	sub    $0xc,%esp
  8018c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c6:	e8 4e 17 00 00       	call   803019 <insert_sorted_with_merge_freeList>
  8018cb:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  8018ce:	90                   	nop
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 38             	sub    $0x38,%esp
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018dd:	e8 a6 fc ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018e6:	75 0a                	jne    8018f2 <smalloc+0x21>
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ed:	e9 8b 00 00 00       	jmp    80197d <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8018f2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ff:	01 d0                	add    %edx,%eax
  801901:	48                   	dec    %eax
  801902:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801905:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801908:	ba 00 00 00 00       	mov    $0x0,%edx
  80190d:	f7 75 f0             	divl   -0x10(%ebp)
  801910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801913:	29 d0                	sub    %edx,%eax
  801915:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801918:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80191f:	e8 d0 06 00 00       	call   801ff4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801924:	85 c0                	test   %eax,%eax
  801926:	74 11                	je     801939 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	ff 75 e8             	pushl  -0x18(%ebp)
  80192e:	e8 3b 0d 00 00       	call   80266e <alloc_block_FF>
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80193d:	74 39                	je     801978 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801942:	8b 40 08             	mov    0x8(%eax),%eax
  801945:	89 c2                	mov    %eax,%edx
  801947:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80194b:	52                   	push   %edx
  80194c:	50                   	push   %eax
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	e8 21 04 00 00       	call   801d79 <sys_createSharedObject>
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80195e:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801962:	74 14                	je     801978 <smalloc+0xa7>
  801964:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801968:	74 0e                	je     801978 <smalloc+0xa7>
  80196a:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80196e:	74 08                	je     801978 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801973:	8b 40 08             	mov    0x8(%eax),%eax
  801976:	eb 05                	jmp    80197d <smalloc+0xac>
	}
	return NULL;
  801978:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801985:	e8 fe fb ff ff       	call   801588 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80198a:	83 ec 08             	sub    $0x8,%esp
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	e8 0b 04 00 00       	call   801da3 <sys_getSizeOfSharedObject>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80199e:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8019a2:	74 76                	je     801a1a <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019a4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b1:	01 d0                	add    %edx,%eax
  8019b3:	48                   	dec    %eax
  8019b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bf:	f7 75 ec             	divl   -0x14(%ebp)
  8019c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019c5:	29 d0                	sub    %edx,%eax
  8019c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8019ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019d1:	e8 1e 06 00 00       	call   801ff4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	74 11                	je     8019eb <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8019da:	83 ec 0c             	sub    $0xc,%esp
  8019dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019e0:	e8 89 0c 00 00       	call   80266e <alloc_block_FF>
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8019eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019ef:	74 29                	je     801a1a <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8019f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f4:	8b 40 08             	mov    0x8(%eax),%eax
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	50                   	push   %eax
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	e8 ba 03 00 00       	call   801dc0 <sys_getSharedObject>
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801a0c:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801a10:	74 08                	je     801a1a <sget+0x9b>
				return (void *)mem_block->sva;
  801a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a15:	8b 40 08             	mov    0x8(%eax),%eax
  801a18:	eb 05                	jmp    801a1f <sget+0xa0>
		}
	}
	return NULL;
  801a1a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a27:	e8 5c fb ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	68 c4 44 80 00       	push   $0x8044c4
<<<<<<< HEAD
  801a34:	68 fc 00 00 00       	push   $0xfc
=======
  801a34:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801a39:	68 93 44 80 00       	push   $0x804493
  801a3e:	e8 07 eb ff ff       	call   80054a <_panic>

00801a43 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 ec 44 80 00       	push   $0x8044ec
<<<<<<< HEAD
  801a51:	68 10 01 00 00       	push   $0x110
=======
  801a51:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801a56:	68 93 44 80 00       	push   $0x804493
  801a5b:	e8 ea ea ff ff       	call   80054a <_panic>

00801a60 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	68 10 45 80 00       	push   $0x804510
<<<<<<< HEAD
  801a6e:	68 1b 01 00 00       	push   $0x11b
=======
  801a6e:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801a73:	68 93 44 80 00       	push   $0x804493
  801a78:	e8 cd ea ff ff       	call   80054a <_panic>

00801a7d <shrink>:

}
void shrink(uint32 newSize)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 10 45 80 00       	push   $0x804510
<<<<<<< HEAD
  801a8b:	68 20 01 00 00       	push   $0x120
=======
  801a8b:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801a90:	68 93 44 80 00       	push   $0x804493
  801a95:	e8 b0 ea ff ff       	call   80054a <_panic>

00801a9a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	68 10 45 80 00       	push   $0x804510
<<<<<<< HEAD
  801aa8:	68 25 01 00 00       	push   $0x125
=======
  801aa8:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801aad:	68 93 44 80 00       	push   $0x804493
  801ab2:	e8 93 ea ff ff       	call   80054a <_panic>

00801ab7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	57                   	push   %edi
  801abb:	56                   	push   %esi
  801abc:	53                   	push   %ebx
  801abd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801acc:	8b 7d 18             	mov    0x18(%ebp),%edi
  801acf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ad2:	cd 30                	int    $0x30
  801ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	5b                   	pop    %ebx
  801ade:	5e                   	pop    %esi
  801adf:	5f                   	pop    %edi
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    

00801ae2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 04             	sub    $0x4,%esp
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801aee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	52                   	push   %edx
  801afa:	ff 75 0c             	pushl  0xc(%ebp)
  801afd:	50                   	push   %eax
  801afe:	6a 00                	push   $0x0
  801b00:	e8 b2 ff ff ff       	call   801ab7 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	90                   	nop
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_cgetc>:

int
sys_cgetc(void)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 01                	push   $0x1
  801b1a:	e8 98 ff ff ff       	call   801ab7 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	52                   	push   %edx
  801b34:	50                   	push   %eax
  801b35:	6a 05                	push   $0x5
  801b37:	e8 7b ff ff ff       	call   801ab7 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	56                   	push   %esi
  801b45:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b46:	8b 75 18             	mov    0x18(%ebp),%esi
  801b49:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	56                   	push   %esi
  801b56:	53                   	push   %ebx
  801b57:	51                   	push   %ecx
  801b58:	52                   	push   %edx
  801b59:	50                   	push   %eax
  801b5a:	6a 06                	push   $0x6
  801b5c:	e8 56 ff ff ff       	call   801ab7 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b67:	5b                   	pop    %ebx
  801b68:	5e                   	pop    %esi
  801b69:	5d                   	pop    %ebp
  801b6a:	c3                   	ret    

00801b6b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	52                   	push   %edx
  801b7b:	50                   	push   %eax
  801b7c:	6a 07                	push   $0x7
  801b7e:	e8 34 ff ff ff       	call   801ab7 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	ff 75 08             	pushl  0x8(%ebp)
  801b97:	6a 08                	push   $0x8
  801b99:	e8 19 ff ff ff       	call   801ab7 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 09                	push   $0x9
  801bb2:	e8 00 ff ff ff       	call   801ab7 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 0a                	push   $0xa
  801bcb:	e8 e7 fe ff ff       	call   801ab7 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 0b                	push   $0xb
  801be4:	e8 ce fe ff ff       	call   801ab7 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	ff 75 0c             	pushl  0xc(%ebp)
  801bfa:	ff 75 08             	pushl  0x8(%ebp)
  801bfd:	6a 0f                	push   $0xf
  801bff:	e8 b3 fe ff ff       	call   801ab7 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
	return;
  801c07:	90                   	nop
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	ff 75 08             	pushl  0x8(%ebp)
  801c19:	6a 10                	push   $0x10
  801c1b:	e8 97 fe ff ff       	call   801ab7 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
	return ;
  801c23:	90                   	nop
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	ff 75 10             	pushl  0x10(%ebp)
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	ff 75 08             	pushl  0x8(%ebp)
  801c36:	6a 11                	push   $0x11
  801c38:	e8 7a fe ff ff       	call   801ab7 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c40:	90                   	nop
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 0c                	push   $0xc
  801c52:	e8 60 fe ff ff       	call   801ab7 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	ff 75 08             	pushl  0x8(%ebp)
  801c6a:	6a 0d                	push   $0xd
  801c6c:	e8 46 fe ff ff       	call   801ab7 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 0e                	push   $0xe
  801c85:	e8 2d fe ff ff       	call   801ab7 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	90                   	nop
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 13                	push   $0x13
  801c9f:	e8 13 fe ff ff       	call   801ab7 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	90                   	nop
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 14                	push   $0x14
  801cb9:	e8 f9 fd ff ff       	call   801ab7 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
}
  801cc1:	90                   	nop
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cd0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	50                   	push   %eax
  801cdd:	6a 15                	push   $0x15
  801cdf:	e8 d3 fd ff ff       	call   801ab7 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	90                   	nop
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 16                	push   $0x16
  801cf9:	e8 b9 fd ff ff       	call   801ab7 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	90                   	nop
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	50                   	push   %eax
  801d14:	6a 17                	push   $0x17
  801d16:	e8 9c fd ff ff       	call   801ab7 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	52                   	push   %edx
  801d30:	50                   	push   %eax
  801d31:	6a 1a                	push   $0x1a
  801d33:	e8 7f fd ff ff       	call   801ab7 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	52                   	push   %edx
  801d4d:	50                   	push   %eax
  801d4e:	6a 18                	push   $0x18
  801d50:	e8 62 fd ff ff       	call   801ab7 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	90                   	nop
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	52                   	push   %edx
  801d6b:	50                   	push   %eax
  801d6c:	6a 19                	push   $0x19
  801d6e:	e8 44 fd ff ff       	call   801ab7 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	90                   	nop
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d82:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d85:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d88:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	6a 00                	push   $0x0
  801d91:	51                   	push   %ecx
  801d92:	52                   	push   %edx
  801d93:	ff 75 0c             	pushl  0xc(%ebp)
  801d96:	50                   	push   %eax
  801d97:	6a 1b                	push   $0x1b
  801d99:	e8 19 fd ff ff       	call   801ab7 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801da6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	52                   	push   %edx
  801db3:	50                   	push   %eax
  801db4:	6a 1c                	push   $0x1c
  801db6:	e8 fc fc ff ff       	call   801ab7 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	51                   	push   %ecx
  801dd1:	52                   	push   %edx
  801dd2:	50                   	push   %eax
  801dd3:	6a 1d                	push   $0x1d
  801dd5:	e8 dd fc ff ff       	call   801ab7 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	52                   	push   %edx
  801def:	50                   	push   %eax
  801df0:	6a 1e                	push   $0x1e
  801df2:	e8 c0 fc ff ff       	call   801ab7 <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 1f                	push   $0x1f
  801e0b:	e8 a7 fc ff ff       	call   801ab7 <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	ff 75 14             	pushl  0x14(%ebp)
  801e20:	ff 75 10             	pushl  0x10(%ebp)
  801e23:	ff 75 0c             	pushl  0xc(%ebp)
  801e26:	50                   	push   %eax
  801e27:	6a 20                	push   $0x20
  801e29:	e8 89 fc ff ff       	call   801ab7 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	50                   	push   %eax
  801e42:	6a 21                	push   $0x21
  801e44:	e8 6e fc ff ff       	call   801ab7 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	90                   	nop
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	50                   	push   %eax
  801e5e:	6a 22                	push   $0x22
  801e60:	e8 52 fc ff ff       	call   801ab7 <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 02                	push   $0x2
  801e79:	e8 39 fc ff ff       	call   801ab7 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 03                	push   $0x3
  801e92:	e8 20 fc ff ff       	call   801ab7 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 04                	push   $0x4
  801eab:	e8 07 fc ff ff       	call   801ab7 <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_exit_env>:


void sys_exit_env(void)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 23                	push   $0x23
  801ec4:	e8 ee fb ff ff       	call   801ab7 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	90                   	nop
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ed5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ed8:	8d 50 04             	lea    0x4(%eax),%edx
  801edb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	52                   	push   %edx
  801ee5:	50                   	push   %eax
  801ee6:	6a 24                	push   $0x24
  801ee8:	e8 ca fb ff ff       	call   801ab7 <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
	return result;
  801ef0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ef6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ef9:	89 01                	mov    %eax,(%ecx)
  801efb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	c9                   	leave  
  801f02:	c2 04 00             	ret    $0x4

00801f05 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	ff 75 10             	pushl  0x10(%ebp)
  801f0f:	ff 75 0c             	pushl  0xc(%ebp)
  801f12:	ff 75 08             	pushl  0x8(%ebp)
  801f15:	6a 12                	push   $0x12
  801f17:	e8 9b fb ff ff       	call   801ab7 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1f:	90                   	nop
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 25                	push   $0x25
  801f31:	e8 81 fb ff ff       	call   801ab7 <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	83 ec 04             	sub    $0x4,%esp
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f47:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	50                   	push   %eax
  801f54:	6a 26                	push   $0x26
  801f56:	e8 5c fb ff ff       	call   801ab7 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5e:	90                   	nop
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <rsttst>:
void rsttst()
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 28                	push   $0x28
  801f70:	e8 42 fb ff ff       	call   801ab7 <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
	return ;
  801f78:	90                   	nop
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	8b 45 14             	mov    0x14(%ebp),%eax
  801f84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f87:	8b 55 18             	mov    0x18(%ebp),%edx
  801f8a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f8e:	52                   	push   %edx
  801f8f:	50                   	push   %eax
  801f90:	ff 75 10             	pushl  0x10(%ebp)
  801f93:	ff 75 0c             	pushl  0xc(%ebp)
  801f96:	ff 75 08             	pushl  0x8(%ebp)
  801f99:	6a 27                	push   $0x27
  801f9b:	e8 17 fb ff ff       	call   801ab7 <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa3:	90                   	nop
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <chktst>:
void chktst(uint32 n)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	ff 75 08             	pushl  0x8(%ebp)
  801fb4:	6a 29                	push   $0x29
  801fb6:	e8 fc fa ff ff       	call   801ab7 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbe:	90                   	nop
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <inctst>:

void inctst()
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 2a                	push   $0x2a
  801fd0:	e8 e2 fa ff ff       	call   801ab7 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd8:	90                   	nop
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <gettst>:
uint32 gettst()
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 2b                	push   $0x2b
  801fea:	e8 c8 fa ff ff       	call   801ab7 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 2c                	push   $0x2c
  802006:	e8 ac fa ff ff       	call   801ab7 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
  80200e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802011:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802015:	75 07                	jne    80201e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802017:	b8 01 00 00 00       	mov    $0x1,%eax
  80201c:	eb 05                	jmp    802023 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 2c                	push   $0x2c
  802037:	e8 7b fa ff ff       	call   801ab7 <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
  80203f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802042:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802046:	75 07                	jne    80204f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802048:	b8 01 00 00 00       	mov    $0x1,%eax
  80204d:	eb 05                	jmp    802054 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 2c                	push   $0x2c
  802068:	e8 4a fa ff ff       	call   801ab7 <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
  802070:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802073:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802077:	75 07                	jne    802080 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802079:	b8 01 00 00 00       	mov    $0x1,%eax
  80207e:	eb 05                	jmp    802085 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 2c                	push   $0x2c
  802099:	e8 19 fa ff ff       	call   801ab7 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
  8020a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020a4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020a8:	75 07                	jne    8020b1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8020af:	eb 05                	jmp    8020b6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	ff 75 08             	pushl  0x8(%ebp)
  8020c6:	6a 2d                	push   $0x2d
  8020c8:	e8 ea f9 ff ff       	call   801ab7 <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d0:	90                   	nop
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	53                   	push   %ebx
  8020e6:	51                   	push   %ecx
  8020e7:	52                   	push   %edx
  8020e8:	50                   	push   %eax
  8020e9:	6a 2e                	push   $0x2e
  8020eb:	e8 c7 f9 ff ff       	call   801ab7 <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	52                   	push   %edx
  802108:	50                   	push   %eax
  802109:	6a 2f                	push   $0x2f
  80210b:	e8 a7 f9 ff ff       	call   801ab7 <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80211b:	83 ec 0c             	sub    $0xc,%esp
  80211e:	68 20 45 80 00       	push   $0x804520
  802123:	e8 d6 e6 ff ff       	call   8007fe <cprintf>
  802128:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80212b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802132:	83 ec 0c             	sub    $0xc,%esp
  802135:	68 4c 45 80 00       	push   $0x80454c
  80213a:	e8 bf e6 ff ff       	call   8007fe <cprintf>
  80213f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802142:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802146:	a1 38 51 80 00       	mov    0x805138,%eax
  80214b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214e:	eb 56                	jmp    8021a6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802150:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802154:	74 1c                	je     802172 <print_mem_block_lists+0x5d>
  802156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802159:	8b 50 08             	mov    0x8(%eax),%edx
  80215c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215f:	8b 48 08             	mov    0x8(%eax),%ecx
  802162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802165:	8b 40 0c             	mov    0xc(%eax),%eax
  802168:	01 c8                	add    %ecx,%eax
  80216a:	39 c2                	cmp    %eax,%edx
  80216c:	73 04                	jae    802172 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80216e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802175:	8b 50 08             	mov    0x8(%eax),%edx
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	8b 40 0c             	mov    0xc(%eax),%eax
  80217e:	01 c2                	add    %eax,%edx
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 40 08             	mov    0x8(%eax),%eax
  802186:	83 ec 04             	sub    $0x4,%esp
  802189:	52                   	push   %edx
  80218a:	50                   	push   %eax
  80218b:	68 61 45 80 00       	push   $0x804561
  802190:	e8 69 e6 ff ff       	call   8007fe <cprintf>
  802195:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80219e:	a1 40 51 80 00       	mov    0x805140,%eax
  8021a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021aa:	74 07                	je     8021b3 <print_mem_block_lists+0x9e>
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	8b 00                	mov    (%eax),%eax
  8021b1:	eb 05                	jmp    8021b8 <print_mem_block_lists+0xa3>
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b8:	a3 40 51 80 00       	mov    %eax,0x805140
  8021bd:	a1 40 51 80 00       	mov    0x805140,%eax
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	75 8a                	jne    802150 <print_mem_block_lists+0x3b>
  8021c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ca:	75 84                	jne    802150 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021cc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021d0:	75 10                	jne    8021e2 <print_mem_block_lists+0xcd>
  8021d2:	83 ec 0c             	sub    $0xc,%esp
  8021d5:	68 70 45 80 00       	push   $0x804570
  8021da:	e8 1f e6 ff ff       	call   8007fe <cprintf>
  8021df:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	68 94 45 80 00       	push   $0x804594
  8021f1:	e8 08 e6 ff ff       	call   8007fe <cprintf>
  8021f6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021f9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021fd:	a1 40 50 80 00       	mov    0x805040,%eax
  802202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802205:	eb 56                	jmp    80225d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802207:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220b:	74 1c                	je     802229 <print_mem_block_lists+0x114>
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	8b 50 08             	mov    0x8(%eax),%edx
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	8b 48 08             	mov    0x8(%eax),%ecx
  802219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221c:	8b 40 0c             	mov    0xc(%eax),%eax
  80221f:	01 c8                	add    %ecx,%eax
  802221:	39 c2                	cmp    %eax,%edx
  802223:	73 04                	jae    802229 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802225:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	8b 50 08             	mov    0x8(%eax),%edx
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	8b 40 0c             	mov    0xc(%eax),%eax
  802235:	01 c2                	add    %eax,%edx
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 40 08             	mov    0x8(%eax),%eax
  80223d:	83 ec 04             	sub    $0x4,%esp
  802240:	52                   	push   %edx
  802241:	50                   	push   %eax
  802242:	68 61 45 80 00       	push   $0x804561
  802247:	e8 b2 e5 ff ff       	call   8007fe <cprintf>
  80224c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80224f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802252:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802255:	a1 48 50 80 00       	mov    0x805048,%eax
  80225a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802261:	74 07                	je     80226a <print_mem_block_lists+0x155>
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	8b 00                	mov    (%eax),%eax
  802268:	eb 05                	jmp    80226f <print_mem_block_lists+0x15a>
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	a3 48 50 80 00       	mov    %eax,0x805048
  802274:	a1 48 50 80 00       	mov    0x805048,%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	75 8a                	jne    802207 <print_mem_block_lists+0xf2>
  80227d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802281:	75 84                	jne    802207 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802283:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802287:	75 10                	jne    802299 <print_mem_block_lists+0x184>
  802289:	83 ec 0c             	sub    $0xc,%esp
  80228c:	68 ac 45 80 00       	push   $0x8045ac
  802291:	e8 68 e5 ff ff       	call   8007fe <cprintf>
  802296:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802299:	83 ec 0c             	sub    $0xc,%esp
  80229c:	68 20 45 80 00       	push   $0x804520
  8022a1:	e8 58 e5 ff ff       	call   8007fe <cprintf>
  8022a6:	83 c4 10             	add    $0x10,%esp

}
  8022a9:	90                   	nop
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8022b2:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022b9:	00 00 00 
  8022bc:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022c3:	00 00 00 
  8022c6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022cd:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8022d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022d7:	e9 9e 00 00 00       	jmp    80237a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8022dc:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e4:	c1 e2 04             	shl    $0x4,%edx
  8022e7:	01 d0                	add    %edx,%eax
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	75 14                	jne    802301 <initialize_MemBlocksList+0x55>
  8022ed:	83 ec 04             	sub    $0x4,%esp
  8022f0:	68 d4 45 80 00       	push   $0x8045d4
  8022f5:	6a 46                	push   $0x46
  8022f7:	68 f7 45 80 00       	push   $0x8045f7
  8022fc:	e8 49 e2 ff ff       	call   80054a <_panic>
  802301:	a1 50 50 80 00       	mov    0x805050,%eax
  802306:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802309:	c1 e2 04             	shl    $0x4,%edx
  80230c:	01 d0                	add    %edx,%eax
  80230e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802314:	89 10                	mov    %edx,(%eax)
  802316:	8b 00                	mov    (%eax),%eax
  802318:	85 c0                	test   %eax,%eax
  80231a:	74 18                	je     802334 <initialize_MemBlocksList+0x88>
  80231c:	a1 48 51 80 00       	mov    0x805148,%eax
  802321:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802327:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80232a:	c1 e1 04             	shl    $0x4,%ecx
  80232d:	01 ca                	add    %ecx,%edx
  80232f:	89 50 04             	mov    %edx,0x4(%eax)
  802332:	eb 12                	jmp    802346 <initialize_MemBlocksList+0x9a>
  802334:	a1 50 50 80 00       	mov    0x805050,%eax
  802339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233c:	c1 e2 04             	shl    $0x4,%edx
  80233f:	01 d0                	add    %edx,%eax
  802341:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802346:	a1 50 50 80 00       	mov    0x805050,%eax
  80234b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234e:	c1 e2 04             	shl    $0x4,%edx
  802351:	01 d0                	add    %edx,%eax
  802353:	a3 48 51 80 00       	mov    %eax,0x805148
  802358:	a1 50 50 80 00       	mov    0x805050,%eax
  80235d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802360:	c1 e2 04             	shl    $0x4,%edx
  802363:	01 d0                	add    %edx,%eax
  802365:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236c:	a1 54 51 80 00       	mov    0x805154,%eax
  802371:	40                   	inc    %eax
  802372:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802377:	ff 45 f4             	incl   -0xc(%ebp)
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802380:	0f 82 56 ff ff ff    	jb     8022dc <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802386:	90                   	nop
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	8b 00                	mov    (%eax),%eax
  802394:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802397:	eb 19                	jmp    8023b2 <find_block+0x29>
	{
		if(va==point->sva)
  802399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80239c:	8b 40 08             	mov    0x8(%eax),%eax
  80239f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023a2:	75 05                	jne    8023a9 <find_block+0x20>
		   return point;
  8023a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a7:	eb 36                	jmp    8023df <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	8b 40 08             	mov    0x8(%eax),%eax
  8023af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023b6:	74 07                	je     8023bf <find_block+0x36>
  8023b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	eb 05                	jmp    8023c4 <find_block+0x3b>
  8023bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c7:	89 42 08             	mov    %eax,0x8(%edx)
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	8b 40 08             	mov    0x8(%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	75 c5                	jne    802399 <find_block+0x10>
  8023d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023d8:	75 bf                	jne    802399 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8023e7:	a1 40 50 80 00       	mov    0x805040,%eax
  8023ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8023ef:	a1 44 50 80 00       	mov    0x805044,%eax
  8023f4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8023f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023fd:	74 24                	je     802423 <insert_sorted_allocList+0x42>
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8b 50 08             	mov    0x8(%eax),%edx
  802405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802408:	8b 40 08             	mov    0x8(%eax),%eax
  80240b:	39 c2                	cmp    %eax,%edx
  80240d:	76 14                	jbe    802423 <insert_sorted_allocList+0x42>
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	8b 50 08             	mov    0x8(%eax),%edx
  802415:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802418:	8b 40 08             	mov    0x8(%eax),%eax
  80241b:	39 c2                	cmp    %eax,%edx
  80241d:	0f 82 60 01 00 00    	jb     802583 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802423:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802427:	75 65                	jne    80248e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802429:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80242d:	75 14                	jne    802443 <insert_sorted_allocList+0x62>
  80242f:	83 ec 04             	sub    $0x4,%esp
  802432:	68 d4 45 80 00       	push   $0x8045d4
  802437:	6a 6b                	push   $0x6b
  802439:	68 f7 45 80 00       	push   $0x8045f7
  80243e:	e8 07 e1 ff ff       	call   80054a <_panic>
  802443:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	89 10                	mov    %edx,(%eax)
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	8b 00                	mov    (%eax),%eax
  802453:	85 c0                	test   %eax,%eax
  802455:	74 0d                	je     802464 <insert_sorted_allocList+0x83>
  802457:	a1 40 50 80 00       	mov    0x805040,%eax
  80245c:	8b 55 08             	mov    0x8(%ebp),%edx
  80245f:	89 50 04             	mov    %edx,0x4(%eax)
  802462:	eb 08                	jmp    80246c <insert_sorted_allocList+0x8b>
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	a3 44 50 80 00       	mov    %eax,0x805044
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	a3 40 50 80 00       	mov    %eax,0x805040
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802483:	40                   	inc    %eax
  802484:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802489:	e9 dc 01 00 00       	jmp    80266a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	8b 50 08             	mov    0x8(%eax),%edx
  802494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802497:	8b 40 08             	mov    0x8(%eax),%eax
  80249a:	39 c2                	cmp    %eax,%edx
  80249c:	77 6c                	ja     80250a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80249e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024a2:	74 06                	je     8024aa <insert_sorted_allocList+0xc9>
  8024a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024a8:	75 14                	jne    8024be <insert_sorted_allocList+0xdd>
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	68 10 46 80 00       	push   $0x804610
  8024b2:	6a 6f                	push   $0x6f
  8024b4:	68 f7 45 80 00       	push   $0x8045f7
  8024b9:	e8 8c e0 ff ff       	call   80054a <_panic>
  8024be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c1:	8b 50 04             	mov    0x4(%eax),%edx
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d0:	89 10                	mov    %edx,(%eax)
  8024d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d5:	8b 40 04             	mov    0x4(%eax),%eax
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	74 0d                	je     8024e9 <insert_sorted_allocList+0x108>
  8024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024df:	8b 40 04             	mov    0x4(%eax),%eax
  8024e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e5:	89 10                	mov    %edx,(%eax)
  8024e7:	eb 08                	jmp    8024f1 <insert_sorted_allocList+0x110>
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	a3 40 50 80 00       	mov    %eax,0x805040
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f7:	89 50 04             	mov    %edx,0x4(%eax)
  8024fa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024ff:	40                   	inc    %eax
  802500:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802505:	e9 60 01 00 00       	jmp    80266a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	8b 50 08             	mov    0x8(%eax),%edx
  802510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802513:	8b 40 08             	mov    0x8(%eax),%eax
  802516:	39 c2                	cmp    %eax,%edx
  802518:	0f 82 4c 01 00 00    	jb     80266a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80251e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802522:	75 14                	jne    802538 <insert_sorted_allocList+0x157>
  802524:	83 ec 04             	sub    $0x4,%esp
  802527:	68 48 46 80 00       	push   $0x804648
  80252c:	6a 73                	push   $0x73
  80252e:	68 f7 45 80 00       	push   $0x8045f7
  802533:	e8 12 e0 ff ff       	call   80054a <_panic>
  802538:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	89 50 04             	mov    %edx,0x4(%eax)
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	8b 40 04             	mov    0x4(%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 0c                	je     80255a <insert_sorted_allocList+0x179>
  80254e:	a1 44 50 80 00       	mov    0x805044,%eax
  802553:	8b 55 08             	mov    0x8(%ebp),%edx
  802556:	89 10                	mov    %edx,(%eax)
  802558:	eb 08                	jmp    802562 <insert_sorted_allocList+0x181>
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	a3 40 50 80 00       	mov    %eax,0x805040
  802562:	8b 45 08             	mov    0x8(%ebp),%eax
  802565:	a3 44 50 80 00       	mov    %eax,0x805044
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802573:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802578:	40                   	inc    %eax
  802579:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80257e:	e9 e7 00 00 00       	jmp    80266a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802589:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802590:	a1 40 50 80 00       	mov    0x805040,%eax
  802595:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802598:	e9 9d 00 00 00       	jmp    80263a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	8b 50 08             	mov    0x8(%eax),%edx
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 40 08             	mov    0x8(%eax),%eax
  8025b1:	39 c2                	cmp    %eax,%edx
  8025b3:	76 7d                	jbe    802632 <insert_sorted_allocList+0x251>
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	8b 50 08             	mov    0x8(%eax),%edx
  8025bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025be:	8b 40 08             	mov    0x8(%eax),%eax
  8025c1:	39 c2                	cmp    %eax,%edx
  8025c3:	73 6d                	jae    802632 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8025c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c9:	74 06                	je     8025d1 <insert_sorted_allocList+0x1f0>
  8025cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025cf:	75 14                	jne    8025e5 <insert_sorted_allocList+0x204>
  8025d1:	83 ec 04             	sub    $0x4,%esp
  8025d4:	68 6c 46 80 00       	push   $0x80466c
  8025d9:	6a 7f                	push   $0x7f
  8025db:	68 f7 45 80 00       	push   $0x8045f7
  8025e0:	e8 65 df ff ff       	call   80054a <_panic>
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 10                	mov    (%eax),%edx
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	89 10                	mov    %edx,(%eax)
  8025ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f2:	8b 00                	mov    (%eax),%eax
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	74 0b                	je     802603 <insert_sorted_allocList+0x222>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802600:	89 50 04             	mov    %edx,0x4(%eax)
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 55 08             	mov    0x8(%ebp),%edx
  802609:	89 10                	mov    %edx,(%eax)
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802611:	89 50 04             	mov    %edx,0x4(%eax)
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	8b 00                	mov    (%eax),%eax
  802619:	85 c0                	test   %eax,%eax
  80261b:	75 08                	jne    802625 <insert_sorted_allocList+0x244>
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	a3 44 50 80 00       	mov    %eax,0x805044
  802625:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80262a:	40                   	inc    %eax
  80262b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802630:	eb 39                	jmp    80266b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802632:	a1 48 50 80 00       	mov    0x805048,%eax
  802637:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263e:	74 07                	je     802647 <insert_sorted_allocList+0x266>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	eb 05                	jmp    80264c <insert_sorted_allocList+0x26b>
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
  80264c:	a3 48 50 80 00       	mov    %eax,0x805048
  802651:	a1 48 50 80 00       	mov    0x805048,%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	0f 85 3f ff ff ff    	jne    80259d <insert_sorted_allocList+0x1bc>
  80265e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802662:	0f 85 35 ff ff ff    	jne    80259d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802668:	eb 01                	jmp    80266b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80266a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80266b:	90                   	nop
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802674:	a1 38 51 80 00       	mov    0x805138,%eax
  802679:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267c:	e9 85 01 00 00       	jmp    802806 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 40 0c             	mov    0xc(%eax),%eax
  802687:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268a:	0f 82 6e 01 00 00    	jb     8027fe <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 40 0c             	mov    0xc(%eax),%eax
  802696:	3b 45 08             	cmp    0x8(%ebp),%eax
  802699:	0f 85 8a 00 00 00    	jne    802729 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80269f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a3:	75 17                	jne    8026bc <alloc_block_FF+0x4e>
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	68 a0 46 80 00       	push   $0x8046a0
  8026ad:	68 93 00 00 00       	push   $0x93
  8026b2:	68 f7 45 80 00       	push   $0x8045f7
  8026b7:	e8 8e de ff ff       	call   80054a <_panic>
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 10                	je     8026d5 <alloc_block_FF+0x67>
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	8b 52 04             	mov    0x4(%edx),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	eb 0b                	jmp    8026e0 <alloc_block_FF+0x72>
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	74 0f                	je     8026f9 <alloc_block_FF+0x8b>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 04             	mov    0x4(%eax),%eax
  8026f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f3:	8b 12                	mov    (%edx),%edx
  8026f5:	89 10                	mov    %edx,(%eax)
  8026f7:	eb 0a                	jmp    802703 <alloc_block_FF+0x95>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	a3 38 51 80 00       	mov    %eax,0x805138
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802716:	a1 44 51 80 00       	mov    0x805144,%eax
  80271b:	48                   	dec    %eax
  80271c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	e9 10 01 00 00       	jmp    802839 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 0c             	mov    0xc(%eax),%eax
  80272f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802732:	0f 86 c6 00 00 00    	jbe    8027fe <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802738:	a1 48 51 80 00       	mov    0x805148,%eax
  80273d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 50 08             	mov    0x8(%eax),%edx
  802746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802749:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80274c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274f:	8b 55 08             	mov    0x8(%ebp),%edx
  802752:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802755:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802759:	75 17                	jne    802772 <alloc_block_FF+0x104>
  80275b:	83 ec 04             	sub    $0x4,%esp
  80275e:	68 a0 46 80 00       	push   $0x8046a0
  802763:	68 9b 00 00 00       	push   $0x9b
  802768:	68 f7 45 80 00       	push   $0x8045f7
  80276d:	e8 d8 dd ff ff       	call   80054a <_panic>
  802772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 10                	je     80278b <alloc_block_FF+0x11d>
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802783:	8b 52 04             	mov    0x4(%edx),%edx
  802786:	89 50 04             	mov    %edx,0x4(%eax)
  802789:	eb 0b                	jmp    802796 <alloc_block_FF+0x128>
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 0f                	je     8027af <alloc_block_FF+0x141>
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	8b 40 04             	mov    0x4(%eax),%eax
  8027a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a9:	8b 12                	mov    (%edx),%edx
  8027ab:	89 10                	mov    %edx,(%eax)
  8027ad:	eb 0a                	jmp    8027b9 <alloc_block_FF+0x14b>
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8027d1:	48                   	dec    %eax
  8027d2:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 50 08             	mov    0x8(%eax),%edx
  8027dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e0:	01 c2                	add    %eax,%edx
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ee:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f1:	89 c2                	mov    %eax,%edx
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8027f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fc:	eb 3b                	jmp    802839 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027fe:	a1 40 51 80 00       	mov    0x805140,%eax
  802803:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280a:	74 07                	je     802813 <alloc_block_FF+0x1a5>
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	eb 05                	jmp    802818 <alloc_block_FF+0x1aa>
  802813:	b8 00 00 00 00       	mov    $0x0,%eax
  802818:	a3 40 51 80 00       	mov    %eax,0x805140
  80281d:	a1 40 51 80 00       	mov    0x805140,%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	0f 85 57 fe ff ff    	jne    802681 <alloc_block_FF+0x13>
  80282a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282e:	0f 85 4d fe ff ff    	jne    802681 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802839:	c9                   	leave  
  80283a:	c3                   	ret    

0080283b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
  80283e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802841:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802848:	a1 38 51 80 00       	mov    0x805138,%eax
  80284d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802850:	e9 df 00 00 00       	jmp    802934 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 40 0c             	mov    0xc(%eax),%eax
  80285b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285e:	0f 82 c8 00 00 00    	jb     80292c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 40 0c             	mov    0xc(%eax),%eax
  80286a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286d:	0f 85 8a 00 00 00    	jne    8028fd <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802877:	75 17                	jne    802890 <alloc_block_BF+0x55>
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	68 a0 46 80 00       	push   $0x8046a0
  802881:	68 b7 00 00 00       	push   $0xb7
  802886:	68 f7 45 80 00       	push   $0x8045f7
  80288b:	e8 ba dc ff ff       	call   80054a <_panic>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	74 10                	je     8028a9 <alloc_block_BF+0x6e>
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a1:	8b 52 04             	mov    0x4(%edx),%edx
  8028a4:	89 50 04             	mov    %edx,0x4(%eax)
  8028a7:	eb 0b                	jmp    8028b4 <alloc_block_BF+0x79>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	74 0f                	je     8028cd <alloc_block_BF+0x92>
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c7:	8b 12                	mov    (%edx),%edx
  8028c9:	89 10                	mov    %edx,(%eax)
  8028cb:	eb 0a                	jmp    8028d7 <alloc_block_BF+0x9c>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8028ef:	48                   	dec    %eax
  8028f0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	e9 4d 01 00 00       	jmp    802a4a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 40 0c             	mov    0xc(%eax),%eax
  802903:	3b 45 08             	cmp    0x8(%ebp),%eax
  802906:	76 24                	jbe    80292c <alloc_block_BF+0xf1>
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 0c             	mov    0xc(%eax),%eax
  80290e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802911:	73 19                	jae    80292c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802913:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 0c             	mov    0xc(%eax),%eax
  802920:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 08             	mov    0x8(%eax),%eax
  802929:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80292c:	a1 40 51 80 00       	mov    0x805140,%eax
  802931:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802938:	74 07                	je     802941 <alloc_block_BF+0x106>
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	eb 05                	jmp    802946 <alloc_block_BF+0x10b>
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
  802946:	a3 40 51 80 00       	mov    %eax,0x805140
  80294b:	a1 40 51 80 00       	mov    0x805140,%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	0f 85 fd fe ff ff    	jne    802855 <alloc_block_BF+0x1a>
  802958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295c:	0f 85 f3 fe ff ff    	jne    802855 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802962:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802966:	0f 84 d9 00 00 00    	je     802a45 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80296c:	a1 48 51 80 00       	mov    0x805148,%eax
  802971:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802974:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802977:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80297a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80297d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802980:	8b 55 08             	mov    0x8(%ebp),%edx
  802983:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802986:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80298a:	75 17                	jne    8029a3 <alloc_block_BF+0x168>
  80298c:	83 ec 04             	sub    $0x4,%esp
  80298f:	68 a0 46 80 00       	push   $0x8046a0
  802994:	68 c7 00 00 00       	push   $0xc7
  802999:	68 f7 45 80 00       	push   $0x8045f7
  80299e:	e8 a7 db ff ff       	call   80054a <_panic>
  8029a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 10                	je     8029bc <alloc_block_BF+0x181>
  8029ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029b4:	8b 52 04             	mov    0x4(%edx),%edx
  8029b7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ba:	eb 0b                	jmp    8029c7 <alloc_block_BF+0x18c>
  8029bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 0f                	je     8029e0 <alloc_block_BF+0x1a5>
  8029d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d4:	8b 40 04             	mov    0x4(%eax),%eax
  8029d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029da:	8b 12                	mov    (%edx),%edx
  8029dc:	89 10                	mov    %edx,(%eax)
  8029de:	eb 0a                	jmp    8029ea <alloc_block_BF+0x1af>
  8029e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8029ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fd:	a1 54 51 80 00       	mov    0x805154,%eax
  802a02:	48                   	dec    %eax
  802a03:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a08:	83 ec 08             	sub    $0x8,%esp
  802a0b:	ff 75 ec             	pushl  -0x14(%ebp)
  802a0e:	68 38 51 80 00       	push   $0x805138
  802a13:	e8 71 f9 ff ff       	call   802389 <find_block>
  802a18:	83 c4 10             	add    $0x10,%esp
  802a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a21:	8b 50 08             	mov    0x8(%eax),%edx
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	01 c2                	add    %eax,%edx
  802a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a32:	8b 40 0c             	mov    0xc(%eax),%eax
  802a35:	2b 45 08             	sub    0x8(%ebp),%eax
  802a38:	89 c2                	mov    %eax,%edx
  802a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a43:	eb 05                	jmp    802a4a <alloc_block_BF+0x20f>
	}
	return NULL;
  802a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a4a:	c9                   	leave  
  802a4b:	c3                   	ret    

00802a4c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a4c:	55                   	push   %ebp
  802a4d:	89 e5                	mov    %esp,%ebp
  802a4f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a52:	a1 28 50 80 00       	mov    0x805028,%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	0f 85 de 01 00 00    	jne    802c3d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a5f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a67:	e9 9e 01 00 00       	jmp    802c0a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a72:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a75:	0f 82 87 01 00 00    	jb     802c02 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a84:	0f 85 95 00 00 00    	jne    802b1f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8e:	75 17                	jne    802aa7 <alloc_block_NF+0x5b>
  802a90:	83 ec 04             	sub    $0x4,%esp
  802a93:	68 a0 46 80 00       	push   $0x8046a0
  802a98:	68 e0 00 00 00       	push   $0xe0
  802a9d:	68 f7 45 80 00       	push   $0x8045f7
  802aa2:	e8 a3 da ff ff       	call   80054a <_panic>
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 10                	je     802ac0 <alloc_block_NF+0x74>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab8:	8b 52 04             	mov    0x4(%edx),%edx
  802abb:	89 50 04             	mov    %edx,0x4(%eax)
  802abe:	eb 0b                	jmp    802acb <alloc_block_NF+0x7f>
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 04             	mov    0x4(%eax),%eax
  802ac6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 40 04             	mov    0x4(%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 0f                	je     802ae4 <alloc_block_NF+0x98>
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 40 04             	mov    0x4(%eax),%eax
  802adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ade:	8b 12                	mov    (%edx),%edx
  802ae0:	89 10                	mov    %edx,(%eax)
  802ae2:	eb 0a                	jmp    802aee <alloc_block_NF+0xa2>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	a3 38 51 80 00       	mov    %eax,0x805138
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b01:	a1 44 51 80 00       	mov    0x805144,%eax
  802b06:	48                   	dec    %eax
  802b07:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 40 08             	mov    0x8(%eax),%eax
  802b12:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	e9 f8 04 00 00       	jmp    803017 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 0c             	mov    0xc(%eax),%eax
  802b25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b28:	0f 86 d4 00 00 00    	jbe    802c02 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b2e:	a1 48 51 80 00       	mov    0x805148,%eax
  802b33:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 50 08             	mov    0x8(%eax),%edx
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b45:	8b 55 08             	mov    0x8(%ebp),%edx
  802b48:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4f:	75 17                	jne    802b68 <alloc_block_NF+0x11c>
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	68 a0 46 80 00       	push   $0x8046a0
  802b59:	68 e9 00 00 00       	push   $0xe9
  802b5e:	68 f7 45 80 00       	push   $0x8045f7
  802b63:	e8 e2 d9 ff ff       	call   80054a <_panic>
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	85 c0                	test   %eax,%eax
  802b6f:	74 10                	je     802b81 <alloc_block_NF+0x135>
  802b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b79:	8b 52 04             	mov    0x4(%edx),%edx
  802b7c:	89 50 04             	mov    %edx,0x4(%eax)
  802b7f:	eb 0b                	jmp    802b8c <alloc_block_NF+0x140>
  802b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b84:	8b 40 04             	mov    0x4(%eax),%eax
  802b87:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8f:	8b 40 04             	mov    0x4(%eax),%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	74 0f                	je     802ba5 <alloc_block_NF+0x159>
  802b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b99:	8b 40 04             	mov    0x4(%eax),%eax
  802b9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9f:	8b 12                	mov    (%edx),%edx
  802ba1:	89 10                	mov    %edx,(%eax)
  802ba3:	eb 0a                	jmp    802baf <alloc_block_NF+0x163>
  802ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	a3 48 51 80 00       	mov    %eax,0x805148
  802baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc2:	a1 54 51 80 00       	mov    0x805154,%eax
  802bc7:	48                   	dec    %eax
  802bc8:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd0:	8b 40 08             	mov    0x8(%eax),%eax
  802bd3:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 50 08             	mov    0x8(%eax),%edx
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	01 c2                	add    %eax,%edx
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 40 0c             	mov    0xc(%eax),%eax
  802bef:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf2:	89 c2                	mov    %eax,%edx
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfd:	e9 15 04 00 00       	jmp    803017 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c02:	a1 40 51 80 00       	mov    0x805140,%eax
  802c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0e:	74 07                	je     802c17 <alloc_block_NF+0x1cb>
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	eb 05                	jmp    802c1c <alloc_block_NF+0x1d0>
  802c17:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1c:	a3 40 51 80 00       	mov    %eax,0x805140
  802c21:	a1 40 51 80 00       	mov    0x805140,%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	0f 85 3e fe ff ff    	jne    802a6c <alloc_block_NF+0x20>
  802c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c32:	0f 85 34 fe ff ff    	jne    802a6c <alloc_block_NF+0x20>
  802c38:	e9 d5 03 00 00       	jmp    803012 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c3d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c45:	e9 b1 01 00 00       	jmp    802dfb <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4d:	8b 50 08             	mov    0x8(%eax),%edx
  802c50:	a1 28 50 80 00       	mov    0x805028,%eax
  802c55:	39 c2                	cmp    %eax,%edx
  802c57:	0f 82 96 01 00 00    	jb     802df3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 0c             	mov    0xc(%eax),%eax
  802c63:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c66:	0f 82 87 01 00 00    	jb     802df3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c72:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c75:	0f 85 95 00 00 00    	jne    802d10 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7f:	75 17                	jne    802c98 <alloc_block_NF+0x24c>
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	68 a0 46 80 00       	push   $0x8046a0
  802c89:	68 fc 00 00 00       	push   $0xfc
  802c8e:	68 f7 45 80 00       	push   $0x8045f7
  802c93:	e8 b2 d8 ff ff       	call   80054a <_panic>
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 10                	je     802cb1 <alloc_block_NF+0x265>
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca9:	8b 52 04             	mov    0x4(%edx),%edx
  802cac:	89 50 04             	mov    %edx,0x4(%eax)
  802caf:	eb 0b                	jmp    802cbc <alloc_block_NF+0x270>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 0f                	je     802cd5 <alloc_block_NF+0x289>
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccf:	8b 12                	mov    (%edx),%edx
  802cd1:	89 10                	mov    %edx,(%eax)
  802cd3:	eb 0a                	jmp    802cdf <alloc_block_NF+0x293>
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	a3 38 51 80 00       	mov    %eax,0x805138
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf2:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf7:	48                   	dec    %eax
  802cf8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 40 08             	mov    0x8(%eax),%eax
  802d03:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	e9 07 03 00 00       	jmp    803017 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 0c             	mov    0xc(%eax),%eax
  802d16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d19:	0f 86 d4 00 00 00    	jbe    802df3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d1f:	a1 48 51 80 00       	mov    0x805148,%eax
  802d24:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	8b 50 08             	mov    0x8(%eax),%edx
  802d2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d30:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d36:	8b 55 08             	mov    0x8(%ebp),%edx
  802d39:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d3c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d40:	75 17                	jne    802d59 <alloc_block_NF+0x30d>
  802d42:	83 ec 04             	sub    $0x4,%esp
  802d45:	68 a0 46 80 00       	push   $0x8046a0
  802d4a:	68 04 01 00 00       	push   $0x104
  802d4f:	68 f7 45 80 00       	push   $0x8045f7
  802d54:	e8 f1 d7 ff ff       	call   80054a <_panic>
  802d59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5c:	8b 00                	mov    (%eax),%eax
  802d5e:	85 c0                	test   %eax,%eax
  802d60:	74 10                	je     802d72 <alloc_block_NF+0x326>
  802d62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d65:	8b 00                	mov    (%eax),%eax
  802d67:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d6a:	8b 52 04             	mov    0x4(%edx),%edx
  802d6d:	89 50 04             	mov    %edx,0x4(%eax)
  802d70:	eb 0b                	jmp    802d7d <alloc_block_NF+0x331>
  802d72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d75:	8b 40 04             	mov    0x4(%eax),%eax
  802d78:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d80:	8b 40 04             	mov    0x4(%eax),%eax
  802d83:	85 c0                	test   %eax,%eax
  802d85:	74 0f                	je     802d96 <alloc_block_NF+0x34a>
  802d87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8a:	8b 40 04             	mov    0x4(%eax),%eax
  802d8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d90:	8b 12                	mov    (%edx),%edx
  802d92:	89 10                	mov    %edx,(%eax)
  802d94:	eb 0a                	jmp    802da0 <alloc_block_NF+0x354>
  802d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d99:	8b 00                	mov    (%eax),%eax
  802d9b:	a3 48 51 80 00       	mov    %eax,0x805148
  802da0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db3:	a1 54 51 80 00       	mov    0x805154,%eax
  802db8:	48                   	dec    %eax
  802db9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc1:	8b 40 08             	mov    0x8(%eax),%eax
  802dc4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 50 08             	mov    0x8(%eax),%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	01 c2                	add    %eax,%edx
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 40 0c             	mov    0xc(%eax),%eax
  802de0:	2b 45 08             	sub    0x8(%ebp),%eax
  802de3:	89 c2                	mov    %eax,%edx
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dee:	e9 24 02 00 00       	jmp    803017 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802df3:	a1 40 51 80 00       	mov    0x805140,%eax
  802df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dff:	74 07                	je     802e08 <alloc_block_NF+0x3bc>
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	eb 05                	jmp    802e0d <alloc_block_NF+0x3c1>
  802e08:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0d:	a3 40 51 80 00       	mov    %eax,0x805140
  802e12:	a1 40 51 80 00       	mov    0x805140,%eax
  802e17:	85 c0                	test   %eax,%eax
  802e19:	0f 85 2b fe ff ff    	jne    802c4a <alloc_block_NF+0x1fe>
  802e1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e23:	0f 85 21 fe ff ff    	jne    802c4a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e29:	a1 38 51 80 00       	mov    0x805138,%eax
  802e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e31:	e9 ae 01 00 00       	jmp    802fe4 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 50 08             	mov    0x8(%eax),%edx
  802e3c:	a1 28 50 80 00       	mov    0x805028,%eax
  802e41:	39 c2                	cmp    %eax,%edx
  802e43:	0f 83 93 01 00 00    	jae    802fdc <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e52:	0f 82 84 01 00 00    	jb     802fdc <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e61:	0f 85 95 00 00 00    	jne    802efc <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6b:	75 17                	jne    802e84 <alloc_block_NF+0x438>
  802e6d:	83 ec 04             	sub    $0x4,%esp
  802e70:	68 a0 46 80 00       	push   $0x8046a0
  802e75:	68 14 01 00 00       	push   $0x114
  802e7a:	68 f7 45 80 00       	push   $0x8045f7
  802e7f:	e8 c6 d6 ff ff       	call   80054a <_panic>
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	8b 00                	mov    (%eax),%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	74 10                	je     802e9d <alloc_block_NF+0x451>
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e95:	8b 52 04             	mov    0x4(%edx),%edx
  802e98:	89 50 04             	mov    %edx,0x4(%eax)
  802e9b:	eb 0b                	jmp    802ea8 <alloc_block_NF+0x45c>
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 40 04             	mov    0x4(%eax),%eax
  802ea3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	74 0f                	je     802ec1 <alloc_block_NF+0x475>
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	8b 40 04             	mov    0x4(%eax),%eax
  802eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebb:	8b 12                	mov    (%edx),%edx
  802ebd:	89 10                	mov    %edx,(%eax)
  802ebf:	eb 0a                	jmp    802ecb <alloc_block_NF+0x47f>
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	a3 38 51 80 00       	mov    %eax,0x805138
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ede:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee3:	48                   	dec    %eax
  802ee4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 40 08             	mov    0x8(%eax),%eax
  802eef:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	e9 1b 01 00 00       	jmp    803017 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 40 0c             	mov    0xc(%eax),%eax
  802f02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f05:	0f 86 d1 00 00 00    	jbe    802fdc <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f0b:	a1 48 51 80 00       	mov    0x805148,%eax
  802f10:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	8b 50 08             	mov    0x8(%eax),%edx
  802f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f22:	8b 55 08             	mov    0x8(%ebp),%edx
  802f25:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f2c:	75 17                	jne    802f45 <alloc_block_NF+0x4f9>
  802f2e:	83 ec 04             	sub    $0x4,%esp
  802f31:	68 a0 46 80 00       	push   $0x8046a0
  802f36:	68 1c 01 00 00       	push   $0x11c
  802f3b:	68 f7 45 80 00       	push   $0x8045f7
  802f40:	e8 05 d6 ff ff       	call   80054a <_panic>
  802f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 10                	je     802f5e <alloc_block_NF+0x512>
  802f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f51:	8b 00                	mov    (%eax),%eax
  802f53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f56:	8b 52 04             	mov    0x4(%edx),%edx
  802f59:	89 50 04             	mov    %edx,0x4(%eax)
  802f5c:	eb 0b                	jmp    802f69 <alloc_block_NF+0x51d>
  802f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6c:	8b 40 04             	mov    0x4(%eax),%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	74 0f                	je     802f82 <alloc_block_NF+0x536>
  802f73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f76:	8b 40 04             	mov    0x4(%eax),%eax
  802f79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f7c:	8b 12                	mov    (%edx),%edx
  802f7e:	89 10                	mov    %edx,(%eax)
  802f80:	eb 0a                	jmp    802f8c <alloc_block_NF+0x540>
  802f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f85:	8b 00                	mov    (%eax),%eax
  802f87:	a3 48 51 80 00       	mov    %eax,0x805148
  802f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9f:	a1 54 51 80 00       	mov    0x805154,%eax
  802fa4:	48                   	dec    %eax
  802fa5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802faa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fad:	8b 40 08             	mov    0x8(%eax),%eax
  802fb0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	8b 50 08             	mov    0x8(%eax),%edx
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	01 c2                	add    %eax,%edx
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcc:	2b 45 08             	sub    0x8(%ebp),%eax
  802fcf:	89 c2                	mov    %eax,%edx
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fda:	eb 3b                	jmp    803017 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fdc:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe8:	74 07                	je     802ff1 <alloc_block_NF+0x5a5>
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	eb 05                	jmp    802ff6 <alloc_block_NF+0x5aa>
  802ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff6:	a3 40 51 80 00       	mov    %eax,0x805140
  802ffb:	a1 40 51 80 00       	mov    0x805140,%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	0f 85 2e fe ff ff    	jne    802e36 <alloc_block_NF+0x3ea>
  803008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300c:	0f 85 24 fe ff ff    	jne    802e36 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803012:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803017:	c9                   	leave  
  803018:	c3                   	ret    

00803019 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803019:	55                   	push   %ebp
  80301a:	89 e5                	mov    %esp,%ebp
  80301c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80301f:	a1 38 51 80 00       	mov    0x805138,%eax
  803024:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803027:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80302c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80302f:	a1 38 51 80 00       	mov    0x805138,%eax
  803034:	85 c0                	test   %eax,%eax
  803036:	74 14                	je     80304c <insert_sorted_with_merge_freeList+0x33>
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	8b 50 08             	mov    0x8(%eax),%edx
  80303e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803041:	8b 40 08             	mov    0x8(%eax),%eax
  803044:	39 c2                	cmp    %eax,%edx
  803046:	0f 87 9b 01 00 00    	ja     8031e7 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80304c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803050:	75 17                	jne    803069 <insert_sorted_with_merge_freeList+0x50>
  803052:	83 ec 04             	sub    $0x4,%esp
  803055:	68 d4 45 80 00       	push   $0x8045d4
  80305a:	68 38 01 00 00       	push   $0x138
  80305f:	68 f7 45 80 00       	push   $0x8045f7
  803064:	e8 e1 d4 ff ff       	call   80054a <_panic>
  803069:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	89 10                	mov    %edx,(%eax)
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	74 0d                	je     80308a <insert_sorted_with_merge_freeList+0x71>
  80307d:	a1 38 51 80 00       	mov    0x805138,%eax
  803082:	8b 55 08             	mov    0x8(%ebp),%edx
  803085:	89 50 04             	mov    %edx,0x4(%eax)
  803088:	eb 08                	jmp    803092 <insert_sorted_with_merge_freeList+0x79>
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	a3 38 51 80 00       	mov    %eax,0x805138
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a9:	40                   	inc    %eax
  8030aa:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030b3:	0f 84 a8 06 00 00    	je     803761 <insert_sorted_with_merge_freeList+0x748>
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	8b 50 08             	mov    0x8(%eax),%edx
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c5:	01 c2                	add    %eax,%edx
  8030c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ca:	8b 40 08             	mov    0x8(%eax),%eax
  8030cd:	39 c2                	cmp    %eax,%edx
  8030cf:	0f 85 8c 06 00 00    	jne    803761 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	8b 50 0c             	mov    0xc(%eax),%edx
  8030db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030de:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e1:	01 c2                	add    %eax,%edx
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8030e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ed:	75 17                	jne    803106 <insert_sorted_with_merge_freeList+0xed>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 a0 46 80 00       	push   $0x8046a0
  8030f7:	68 3c 01 00 00       	push   $0x13c
  8030fc:	68 f7 45 80 00       	push   $0x8045f7
  803101:	e8 44 d4 ff ff       	call   80054a <_panic>
  803106:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	74 10                	je     80311f <insert_sorted_with_merge_freeList+0x106>
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803117:	8b 52 04             	mov    0x4(%edx),%edx
  80311a:	89 50 04             	mov    %edx,0x4(%eax)
  80311d:	eb 0b                	jmp    80312a <insert_sorted_with_merge_freeList+0x111>
  80311f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	8b 40 04             	mov    0x4(%eax),%eax
  803130:	85 c0                	test   %eax,%eax
  803132:	74 0f                	je     803143 <insert_sorted_with_merge_freeList+0x12a>
  803134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80313d:	8b 12                	mov    (%edx),%edx
  80313f:	89 10                	mov    %edx,(%eax)
  803141:	eb 0a                	jmp    80314d <insert_sorted_with_merge_freeList+0x134>
  803143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	a3 38 51 80 00       	mov    %eax,0x805138
  80314d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803159:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803160:	a1 44 51 80 00       	mov    0x805144,%eax
  803165:	48                   	dec    %eax
  803166:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80316b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803178:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80317f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803183:	75 17                	jne    80319c <insert_sorted_with_merge_freeList+0x183>
  803185:	83 ec 04             	sub    $0x4,%esp
  803188:	68 d4 45 80 00       	push   $0x8045d4
  80318d:	68 3f 01 00 00       	push   $0x13f
  803192:	68 f7 45 80 00       	push   $0x8045f7
  803197:	e8 ae d3 ff ff       	call   80054a <_panic>
  80319c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a5:	89 10                	mov    %edx,(%eax)
  8031a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	85 c0                	test   %eax,%eax
  8031ae:	74 0d                	je     8031bd <insert_sorted_with_merge_freeList+0x1a4>
  8031b0:	a1 48 51 80 00       	mov    0x805148,%eax
  8031b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b8:	89 50 04             	mov    %edx,0x4(%eax)
  8031bb:	eb 08                	jmp    8031c5 <insert_sorted_with_merge_freeList+0x1ac>
  8031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8031cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8031dc:	40                   	inc    %eax
  8031dd:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031e2:	e9 7a 05 00 00       	jmp    803761 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	8b 50 08             	mov    0x8(%eax),%edx
  8031ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f0:	8b 40 08             	mov    0x8(%eax),%eax
  8031f3:	39 c2                	cmp    %eax,%edx
  8031f5:	0f 82 14 01 00 00    	jb     80330f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8031fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fe:	8b 50 08             	mov    0x8(%eax),%edx
  803201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803204:	8b 40 0c             	mov    0xc(%eax),%eax
  803207:	01 c2                	add    %eax,%edx
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	8b 40 08             	mov    0x8(%eax),%eax
  80320f:	39 c2                	cmp    %eax,%edx
  803211:	0f 85 90 00 00 00    	jne    8032a7 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321a:	8b 50 0c             	mov    0xc(%eax),%edx
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	8b 40 0c             	mov    0xc(%eax),%eax
  803223:	01 c2                	add    %eax,%edx
  803225:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803228:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80323f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803243:	75 17                	jne    80325c <insert_sorted_with_merge_freeList+0x243>
  803245:	83 ec 04             	sub    $0x4,%esp
  803248:	68 d4 45 80 00       	push   $0x8045d4
  80324d:	68 49 01 00 00       	push   $0x149
  803252:	68 f7 45 80 00       	push   $0x8045f7
  803257:	e8 ee d2 ff ff       	call   80054a <_panic>
  80325c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	89 10                	mov    %edx,(%eax)
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	8b 00                	mov    (%eax),%eax
  80326c:	85 c0                	test   %eax,%eax
  80326e:	74 0d                	je     80327d <insert_sorted_with_merge_freeList+0x264>
  803270:	a1 48 51 80 00       	mov    0x805148,%eax
  803275:	8b 55 08             	mov    0x8(%ebp),%edx
  803278:	89 50 04             	mov    %edx,0x4(%eax)
  80327b:	eb 08                	jmp    803285 <insert_sorted_with_merge_freeList+0x26c>
  80327d:	8b 45 08             	mov    0x8(%ebp),%eax
  803280:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	a3 48 51 80 00       	mov    %eax,0x805148
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803297:	a1 54 51 80 00       	mov    0x805154,%eax
  80329c:	40                   	inc    %eax
  80329d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032a2:	e9 bb 04 00 00       	jmp    803762 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ab:	75 17                	jne    8032c4 <insert_sorted_with_merge_freeList+0x2ab>
  8032ad:	83 ec 04             	sub    $0x4,%esp
  8032b0:	68 48 46 80 00       	push   $0x804648
  8032b5:	68 4c 01 00 00       	push   $0x14c
  8032ba:	68 f7 45 80 00       	push   $0x8045f7
  8032bf:	e8 86 d2 ff ff       	call   80054a <_panic>
  8032c4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	89 50 04             	mov    %edx,0x4(%eax)
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 40 04             	mov    0x4(%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	74 0c                	je     8032e6 <insert_sorted_with_merge_freeList+0x2cd>
  8032da:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032df:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e2:	89 10                	mov    %edx,(%eax)
  8032e4:	eb 08                	jmp    8032ee <insert_sorted_with_merge_freeList+0x2d5>
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ff:	a1 44 51 80 00       	mov    0x805144,%eax
  803304:	40                   	inc    %eax
  803305:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80330a:	e9 53 04 00 00       	jmp    803762 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80330f:	a1 38 51 80 00       	mov    0x805138,%eax
  803314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803317:	e9 15 04 00 00       	jmp    803731 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	8b 00                	mov    (%eax),%eax
  803321:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	8b 50 08             	mov    0x8(%eax),%edx
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	8b 40 08             	mov    0x8(%eax),%eax
  803330:	39 c2                	cmp    %eax,%edx
  803332:	0f 86 f1 03 00 00    	jbe    803729 <insert_sorted_with_merge_freeList+0x710>
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	8b 50 08             	mov    0x8(%eax),%edx
  80333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803341:	8b 40 08             	mov    0x8(%eax),%eax
  803344:	39 c2                	cmp    %eax,%edx
  803346:	0f 83 dd 03 00 00    	jae    803729 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334f:	8b 50 08             	mov    0x8(%eax),%edx
  803352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803355:	8b 40 0c             	mov    0xc(%eax),%eax
  803358:	01 c2                	add    %eax,%edx
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	8b 40 08             	mov    0x8(%eax),%eax
  803360:	39 c2                	cmp    %eax,%edx
  803362:	0f 85 b9 01 00 00    	jne    803521 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	8b 50 08             	mov    0x8(%eax),%edx
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	8b 40 0c             	mov    0xc(%eax),%eax
  803374:	01 c2                	add    %eax,%edx
  803376:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803379:	8b 40 08             	mov    0x8(%eax),%eax
  80337c:	39 c2                	cmp    %eax,%edx
  80337e:	0f 85 0d 01 00 00    	jne    803491 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	8b 50 0c             	mov    0xc(%eax),%edx
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	8b 40 0c             	mov    0xc(%eax),%eax
  803390:	01 c2                	add    %eax,%edx
  803392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803395:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803398:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80339c:	75 17                	jne    8033b5 <insert_sorted_with_merge_freeList+0x39c>
  80339e:	83 ec 04             	sub    $0x4,%esp
  8033a1:	68 a0 46 80 00       	push   $0x8046a0
  8033a6:	68 5c 01 00 00       	push   $0x15c
  8033ab:	68 f7 45 80 00       	push   $0x8045f7
  8033b0:	e8 95 d1 ff ff       	call   80054a <_panic>
  8033b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b8:	8b 00                	mov    (%eax),%eax
  8033ba:	85 c0                	test   %eax,%eax
  8033bc:	74 10                	je     8033ce <insert_sorted_with_merge_freeList+0x3b5>
  8033be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c6:	8b 52 04             	mov    0x4(%edx),%edx
  8033c9:	89 50 04             	mov    %edx,0x4(%eax)
  8033cc:	eb 0b                	jmp    8033d9 <insert_sorted_with_merge_freeList+0x3c0>
  8033ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d1:	8b 40 04             	mov    0x4(%eax),%eax
  8033d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	8b 40 04             	mov    0x4(%eax),%eax
  8033df:	85 c0                	test   %eax,%eax
  8033e1:	74 0f                	je     8033f2 <insert_sorted_with_merge_freeList+0x3d9>
  8033e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e6:	8b 40 04             	mov    0x4(%eax),%eax
  8033e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ec:	8b 12                	mov    (%edx),%edx
  8033ee:	89 10                	mov    %edx,(%eax)
  8033f0:	eb 0a                	jmp    8033fc <insert_sorted_with_merge_freeList+0x3e3>
  8033f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	a3 38 51 80 00       	mov    %eax,0x805138
  8033fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803408:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340f:	a1 44 51 80 00       	mov    0x805144,%eax
  803414:	48                   	dec    %eax
  803415:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80341a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803427:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80342e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803432:	75 17                	jne    80344b <insert_sorted_with_merge_freeList+0x432>
  803434:	83 ec 04             	sub    $0x4,%esp
  803437:	68 d4 45 80 00       	push   $0x8045d4
  80343c:	68 5f 01 00 00       	push   $0x15f
  803441:	68 f7 45 80 00       	push   $0x8045f7
  803446:	e8 ff d0 ff ff       	call   80054a <_panic>
  80344b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803454:	89 10                	mov    %edx,(%eax)
  803456:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803459:	8b 00                	mov    (%eax),%eax
  80345b:	85 c0                	test   %eax,%eax
  80345d:	74 0d                	je     80346c <insert_sorted_with_merge_freeList+0x453>
  80345f:	a1 48 51 80 00       	mov    0x805148,%eax
  803464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803467:	89 50 04             	mov    %edx,0x4(%eax)
  80346a:	eb 08                	jmp    803474 <insert_sorted_with_merge_freeList+0x45b>
  80346c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803474:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803477:	a3 48 51 80 00       	mov    %eax,0x805148
  80347c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803486:	a1 54 51 80 00       	mov    0x805154,%eax
  80348b:	40                   	inc    %eax
  80348c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	8b 50 0c             	mov    0xc(%eax),%edx
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	8b 40 0c             	mov    0xc(%eax),%eax
  80349d:	01 c2                	add    %eax,%edx
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8034af:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034bd:	75 17                	jne    8034d6 <insert_sorted_with_merge_freeList+0x4bd>
  8034bf:	83 ec 04             	sub    $0x4,%esp
  8034c2:	68 d4 45 80 00       	push   $0x8045d4
  8034c7:	68 64 01 00 00       	push   $0x164
  8034cc:	68 f7 45 80 00       	push   $0x8045f7
  8034d1:	e8 74 d0 ff ff       	call   80054a <_panic>
  8034d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034df:	89 10                	mov    %edx,(%eax)
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	85 c0                	test   %eax,%eax
  8034e8:	74 0d                	je     8034f7 <insert_sorted_with_merge_freeList+0x4de>
  8034ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f2:	89 50 04             	mov    %edx,0x4(%eax)
  8034f5:	eb 08                	jmp    8034ff <insert_sorted_with_merge_freeList+0x4e6>
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	a3 48 51 80 00       	mov    %eax,0x805148
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803511:	a1 54 51 80 00       	mov    0x805154,%eax
  803516:	40                   	inc    %eax
  803517:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80351c:	e9 41 02 00 00       	jmp    803762 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	8b 50 08             	mov    0x8(%eax),%edx
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	8b 40 0c             	mov    0xc(%eax),%eax
  80352d:	01 c2                	add    %eax,%edx
  80352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803532:	8b 40 08             	mov    0x8(%eax),%eax
  803535:	39 c2                	cmp    %eax,%edx
  803537:	0f 85 7c 01 00 00    	jne    8036b9 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80353d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803541:	74 06                	je     803549 <insert_sorted_with_merge_freeList+0x530>
  803543:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803547:	75 17                	jne    803560 <insert_sorted_with_merge_freeList+0x547>
  803549:	83 ec 04             	sub    $0x4,%esp
  80354c:	68 10 46 80 00       	push   $0x804610
  803551:	68 69 01 00 00       	push   $0x169
  803556:	68 f7 45 80 00       	push   $0x8045f7
  80355b:	e8 ea cf ff ff       	call   80054a <_panic>
  803560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803563:	8b 50 04             	mov    0x4(%eax),%edx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	89 50 04             	mov    %edx,0x4(%eax)
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803572:	89 10                	mov    %edx,(%eax)
  803574:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803577:	8b 40 04             	mov    0x4(%eax),%eax
  80357a:	85 c0                	test   %eax,%eax
  80357c:	74 0d                	je     80358b <insert_sorted_with_merge_freeList+0x572>
  80357e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803581:	8b 40 04             	mov    0x4(%eax),%eax
  803584:	8b 55 08             	mov    0x8(%ebp),%edx
  803587:	89 10                	mov    %edx,(%eax)
  803589:	eb 08                	jmp    803593 <insert_sorted_with_merge_freeList+0x57a>
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	a3 38 51 80 00       	mov    %eax,0x805138
  803593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803596:	8b 55 08             	mov    0x8(%ebp),%edx
  803599:	89 50 04             	mov    %edx,0x4(%eax)
  80359c:	a1 44 51 80 00       	mov    0x805144,%eax
  8035a1:	40                   	inc    %eax
  8035a2:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b3:	01 c2                	add    %eax,%edx
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035bf:	75 17                	jne    8035d8 <insert_sorted_with_merge_freeList+0x5bf>
  8035c1:	83 ec 04             	sub    $0x4,%esp
  8035c4:	68 a0 46 80 00       	push   $0x8046a0
  8035c9:	68 6b 01 00 00       	push   $0x16b
  8035ce:	68 f7 45 80 00       	push   $0x8045f7
  8035d3:	e8 72 cf ff ff       	call   80054a <_panic>
  8035d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035db:	8b 00                	mov    (%eax),%eax
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	74 10                	je     8035f1 <insert_sorted_with_merge_freeList+0x5d8>
  8035e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e4:	8b 00                	mov    (%eax),%eax
  8035e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035e9:	8b 52 04             	mov    0x4(%edx),%edx
  8035ec:	89 50 04             	mov    %edx,0x4(%eax)
  8035ef:	eb 0b                	jmp    8035fc <insert_sorted_with_merge_freeList+0x5e3>
  8035f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f4:	8b 40 04             	mov    0x4(%eax),%eax
  8035f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ff:	8b 40 04             	mov    0x4(%eax),%eax
  803602:	85 c0                	test   %eax,%eax
  803604:	74 0f                	je     803615 <insert_sorted_with_merge_freeList+0x5fc>
  803606:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803609:	8b 40 04             	mov    0x4(%eax),%eax
  80360c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80360f:	8b 12                	mov    (%edx),%edx
  803611:	89 10                	mov    %edx,(%eax)
  803613:	eb 0a                	jmp    80361f <insert_sorted_with_merge_freeList+0x606>
  803615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803618:	8b 00                	mov    (%eax),%eax
  80361a:	a3 38 51 80 00       	mov    %eax,0x805138
  80361f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803632:	a1 44 51 80 00       	mov    0x805144,%eax
  803637:	48                   	dec    %eax
  803638:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80363d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803640:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803651:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803655:	75 17                	jne    80366e <insert_sorted_with_merge_freeList+0x655>
  803657:	83 ec 04             	sub    $0x4,%esp
  80365a:	68 d4 45 80 00       	push   $0x8045d4
  80365f:	68 6e 01 00 00       	push   $0x16e
  803664:	68 f7 45 80 00       	push   $0x8045f7
  803669:	e8 dc ce ff ff       	call   80054a <_panic>
  80366e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803677:	89 10                	mov    %edx,(%eax)
  803679:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367c:	8b 00                	mov    (%eax),%eax
  80367e:	85 c0                	test   %eax,%eax
  803680:	74 0d                	je     80368f <insert_sorted_with_merge_freeList+0x676>
  803682:	a1 48 51 80 00       	mov    0x805148,%eax
  803687:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80368a:	89 50 04             	mov    %edx,0x4(%eax)
  80368d:	eb 08                	jmp    803697 <insert_sorted_with_merge_freeList+0x67e>
  80368f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803692:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803697:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369a:	a3 48 51 80 00       	mov    %eax,0x805148
  80369f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ae:	40                   	inc    %eax
  8036af:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036b4:	e9 a9 00 00 00       	jmp    803762 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8036b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036bd:	74 06                	je     8036c5 <insert_sorted_with_merge_freeList+0x6ac>
  8036bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c3:	75 17                	jne    8036dc <insert_sorted_with_merge_freeList+0x6c3>
  8036c5:	83 ec 04             	sub    $0x4,%esp
  8036c8:	68 6c 46 80 00       	push   $0x80466c
  8036cd:	68 73 01 00 00       	push   $0x173
  8036d2:	68 f7 45 80 00       	push   $0x8045f7
  8036d7:	e8 6e ce ff ff       	call   80054a <_panic>
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	8b 10                	mov    (%eax),%edx
  8036e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e4:	89 10                	mov    %edx,(%eax)
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	8b 00                	mov    (%eax),%eax
  8036eb:	85 c0                	test   %eax,%eax
  8036ed:	74 0b                	je     8036fa <insert_sorted_with_merge_freeList+0x6e1>
  8036ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f2:	8b 00                	mov    (%eax),%eax
  8036f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f7:	89 50 04             	mov    %edx,0x4(%eax)
  8036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fd:	8b 55 08             	mov    0x8(%ebp),%edx
  803700:	89 10                	mov    %edx,(%eax)
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803708:	89 50 04             	mov    %edx,0x4(%eax)
  80370b:	8b 45 08             	mov    0x8(%ebp),%eax
  80370e:	8b 00                	mov    (%eax),%eax
  803710:	85 c0                	test   %eax,%eax
  803712:	75 08                	jne    80371c <insert_sorted_with_merge_freeList+0x703>
  803714:	8b 45 08             	mov    0x8(%ebp),%eax
  803717:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80371c:	a1 44 51 80 00       	mov    0x805144,%eax
  803721:	40                   	inc    %eax
  803722:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803727:	eb 39                	jmp    803762 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803729:	a1 40 51 80 00       	mov    0x805140,%eax
  80372e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803735:	74 07                	je     80373e <insert_sorted_with_merge_freeList+0x725>
  803737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373a:	8b 00                	mov    (%eax),%eax
  80373c:	eb 05                	jmp    803743 <insert_sorted_with_merge_freeList+0x72a>
  80373e:	b8 00 00 00 00       	mov    $0x0,%eax
  803743:	a3 40 51 80 00       	mov    %eax,0x805140
  803748:	a1 40 51 80 00       	mov    0x805140,%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	0f 85 c7 fb ff ff    	jne    80331c <insert_sorted_with_merge_freeList+0x303>
  803755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803759:	0f 85 bd fb ff ff    	jne    80331c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80375f:	eb 01                	jmp    803762 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803761:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803762:	90                   	nop
  803763:	c9                   	leave  
  803764:	c3                   	ret    

00803765 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803765:	55                   	push   %ebp
  803766:	89 e5                	mov    %esp,%ebp
  803768:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80376b:	8b 55 08             	mov    0x8(%ebp),%edx
  80376e:	89 d0                	mov    %edx,%eax
  803770:	c1 e0 02             	shl    $0x2,%eax
  803773:	01 d0                	add    %edx,%eax
  803775:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80377c:	01 d0                	add    %edx,%eax
  80377e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803785:	01 d0                	add    %edx,%eax
  803787:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80378e:	01 d0                	add    %edx,%eax
  803790:	c1 e0 04             	shl    $0x4,%eax
  803793:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803796:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80379d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8037a0:	83 ec 0c             	sub    $0xc,%esp
  8037a3:	50                   	push   %eax
  8037a4:	e8 26 e7 ff ff       	call   801ecf <sys_get_virtual_time>
  8037a9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8037ac:	eb 41                	jmp    8037ef <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8037ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037b1:	83 ec 0c             	sub    $0xc,%esp
  8037b4:	50                   	push   %eax
  8037b5:	e8 15 e7 ff ff       	call   801ecf <sys_get_virtual_time>
  8037ba:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8037bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c3:	29 c2                	sub    %eax,%edx
  8037c5:	89 d0                	mov    %edx,%eax
  8037c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8037ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d0:	89 d1                	mov    %edx,%ecx
  8037d2:	29 c1                	sub    %eax,%ecx
  8037d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8037d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037da:	39 c2                	cmp    %eax,%edx
  8037dc:	0f 97 c0             	seta   %al
  8037df:	0f b6 c0             	movzbl %al,%eax
  8037e2:	29 c1                	sub    %eax,%ecx
  8037e4:	89 c8                	mov    %ecx,%eax
  8037e6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8037e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8037ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037f5:	72 b7                	jb     8037ae <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8037f7:	90                   	nop
  8037f8:	c9                   	leave  
  8037f9:	c3                   	ret    

008037fa <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8037fa:	55                   	push   %ebp
  8037fb:	89 e5                	mov    %esp,%ebp
  8037fd:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803800:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803807:	eb 03                	jmp    80380c <busy_wait+0x12>
  803809:	ff 45 fc             	incl   -0x4(%ebp)
  80380c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80380f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803812:	72 f5                	jb     803809 <busy_wait+0xf>
	return i;
  803814:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803817:	c9                   	leave  
  803818:	c3                   	ret    
  803819:	66 90                	xchg   %ax,%ax
  80381b:	90                   	nop

0080381c <__udivdi3>:
  80381c:	55                   	push   %ebp
  80381d:	57                   	push   %edi
  80381e:	56                   	push   %esi
  80381f:	53                   	push   %ebx
  803820:	83 ec 1c             	sub    $0x1c,%esp
  803823:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803827:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80382b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80382f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803833:	89 ca                	mov    %ecx,%edx
  803835:	89 f8                	mov    %edi,%eax
  803837:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80383b:	85 f6                	test   %esi,%esi
  80383d:	75 2d                	jne    80386c <__udivdi3+0x50>
  80383f:	39 cf                	cmp    %ecx,%edi
  803841:	77 65                	ja     8038a8 <__udivdi3+0x8c>
  803843:	89 fd                	mov    %edi,%ebp
  803845:	85 ff                	test   %edi,%edi
  803847:	75 0b                	jne    803854 <__udivdi3+0x38>
  803849:	b8 01 00 00 00       	mov    $0x1,%eax
  80384e:	31 d2                	xor    %edx,%edx
  803850:	f7 f7                	div    %edi
  803852:	89 c5                	mov    %eax,%ebp
  803854:	31 d2                	xor    %edx,%edx
  803856:	89 c8                	mov    %ecx,%eax
  803858:	f7 f5                	div    %ebp
  80385a:	89 c1                	mov    %eax,%ecx
  80385c:	89 d8                	mov    %ebx,%eax
  80385e:	f7 f5                	div    %ebp
  803860:	89 cf                	mov    %ecx,%edi
  803862:	89 fa                	mov    %edi,%edx
  803864:	83 c4 1c             	add    $0x1c,%esp
  803867:	5b                   	pop    %ebx
  803868:	5e                   	pop    %esi
  803869:	5f                   	pop    %edi
  80386a:	5d                   	pop    %ebp
  80386b:	c3                   	ret    
  80386c:	39 ce                	cmp    %ecx,%esi
  80386e:	77 28                	ja     803898 <__udivdi3+0x7c>
  803870:	0f bd fe             	bsr    %esi,%edi
  803873:	83 f7 1f             	xor    $0x1f,%edi
  803876:	75 40                	jne    8038b8 <__udivdi3+0x9c>
  803878:	39 ce                	cmp    %ecx,%esi
  80387a:	72 0a                	jb     803886 <__udivdi3+0x6a>
  80387c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803880:	0f 87 9e 00 00 00    	ja     803924 <__udivdi3+0x108>
  803886:	b8 01 00 00 00       	mov    $0x1,%eax
  80388b:	89 fa                	mov    %edi,%edx
  80388d:	83 c4 1c             	add    $0x1c,%esp
  803890:	5b                   	pop    %ebx
  803891:	5e                   	pop    %esi
  803892:	5f                   	pop    %edi
  803893:	5d                   	pop    %ebp
  803894:	c3                   	ret    
  803895:	8d 76 00             	lea    0x0(%esi),%esi
  803898:	31 ff                	xor    %edi,%edi
  80389a:	31 c0                	xor    %eax,%eax
  80389c:	89 fa                	mov    %edi,%edx
  80389e:	83 c4 1c             	add    $0x1c,%esp
  8038a1:	5b                   	pop    %ebx
  8038a2:	5e                   	pop    %esi
  8038a3:	5f                   	pop    %edi
  8038a4:	5d                   	pop    %ebp
  8038a5:	c3                   	ret    
  8038a6:	66 90                	xchg   %ax,%ax
  8038a8:	89 d8                	mov    %ebx,%eax
  8038aa:	f7 f7                	div    %edi
  8038ac:	31 ff                	xor    %edi,%edi
  8038ae:	89 fa                	mov    %edi,%edx
  8038b0:	83 c4 1c             	add    $0x1c,%esp
  8038b3:	5b                   	pop    %ebx
  8038b4:	5e                   	pop    %esi
  8038b5:	5f                   	pop    %edi
  8038b6:	5d                   	pop    %ebp
  8038b7:	c3                   	ret    
  8038b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038bd:	89 eb                	mov    %ebp,%ebx
  8038bf:	29 fb                	sub    %edi,%ebx
  8038c1:	89 f9                	mov    %edi,%ecx
  8038c3:	d3 e6                	shl    %cl,%esi
  8038c5:	89 c5                	mov    %eax,%ebp
  8038c7:	88 d9                	mov    %bl,%cl
  8038c9:	d3 ed                	shr    %cl,%ebp
  8038cb:	89 e9                	mov    %ebp,%ecx
  8038cd:	09 f1                	or     %esi,%ecx
  8038cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038d3:	89 f9                	mov    %edi,%ecx
  8038d5:	d3 e0                	shl    %cl,%eax
  8038d7:	89 c5                	mov    %eax,%ebp
  8038d9:	89 d6                	mov    %edx,%esi
  8038db:	88 d9                	mov    %bl,%cl
  8038dd:	d3 ee                	shr    %cl,%esi
  8038df:	89 f9                	mov    %edi,%ecx
  8038e1:	d3 e2                	shl    %cl,%edx
  8038e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038e7:	88 d9                	mov    %bl,%cl
  8038e9:	d3 e8                	shr    %cl,%eax
  8038eb:	09 c2                	or     %eax,%edx
  8038ed:	89 d0                	mov    %edx,%eax
  8038ef:	89 f2                	mov    %esi,%edx
  8038f1:	f7 74 24 0c          	divl   0xc(%esp)
  8038f5:	89 d6                	mov    %edx,%esi
  8038f7:	89 c3                	mov    %eax,%ebx
  8038f9:	f7 e5                	mul    %ebp
  8038fb:	39 d6                	cmp    %edx,%esi
  8038fd:	72 19                	jb     803918 <__udivdi3+0xfc>
  8038ff:	74 0b                	je     80390c <__udivdi3+0xf0>
  803901:	89 d8                	mov    %ebx,%eax
  803903:	31 ff                	xor    %edi,%edi
  803905:	e9 58 ff ff ff       	jmp    803862 <__udivdi3+0x46>
  80390a:	66 90                	xchg   %ax,%ax
  80390c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803910:	89 f9                	mov    %edi,%ecx
  803912:	d3 e2                	shl    %cl,%edx
  803914:	39 c2                	cmp    %eax,%edx
  803916:	73 e9                	jae    803901 <__udivdi3+0xe5>
  803918:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80391b:	31 ff                	xor    %edi,%edi
  80391d:	e9 40 ff ff ff       	jmp    803862 <__udivdi3+0x46>
  803922:	66 90                	xchg   %ax,%ax
  803924:	31 c0                	xor    %eax,%eax
  803926:	e9 37 ff ff ff       	jmp    803862 <__udivdi3+0x46>
  80392b:	90                   	nop

0080392c <__umoddi3>:
  80392c:	55                   	push   %ebp
  80392d:	57                   	push   %edi
  80392e:	56                   	push   %esi
  80392f:	53                   	push   %ebx
  803930:	83 ec 1c             	sub    $0x1c,%esp
  803933:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803937:	8b 74 24 34          	mov    0x34(%esp),%esi
  80393b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80393f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803943:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803947:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80394b:	89 f3                	mov    %esi,%ebx
  80394d:	89 fa                	mov    %edi,%edx
  80394f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803953:	89 34 24             	mov    %esi,(%esp)
  803956:	85 c0                	test   %eax,%eax
  803958:	75 1a                	jne    803974 <__umoddi3+0x48>
  80395a:	39 f7                	cmp    %esi,%edi
  80395c:	0f 86 a2 00 00 00    	jbe    803a04 <__umoddi3+0xd8>
  803962:	89 c8                	mov    %ecx,%eax
  803964:	89 f2                	mov    %esi,%edx
  803966:	f7 f7                	div    %edi
  803968:	89 d0                	mov    %edx,%eax
  80396a:	31 d2                	xor    %edx,%edx
  80396c:	83 c4 1c             	add    $0x1c,%esp
  80396f:	5b                   	pop    %ebx
  803970:	5e                   	pop    %esi
  803971:	5f                   	pop    %edi
  803972:	5d                   	pop    %ebp
  803973:	c3                   	ret    
  803974:	39 f0                	cmp    %esi,%eax
  803976:	0f 87 ac 00 00 00    	ja     803a28 <__umoddi3+0xfc>
  80397c:	0f bd e8             	bsr    %eax,%ebp
  80397f:	83 f5 1f             	xor    $0x1f,%ebp
  803982:	0f 84 ac 00 00 00    	je     803a34 <__umoddi3+0x108>
  803988:	bf 20 00 00 00       	mov    $0x20,%edi
  80398d:	29 ef                	sub    %ebp,%edi
  80398f:	89 fe                	mov    %edi,%esi
  803991:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803995:	89 e9                	mov    %ebp,%ecx
  803997:	d3 e0                	shl    %cl,%eax
  803999:	89 d7                	mov    %edx,%edi
  80399b:	89 f1                	mov    %esi,%ecx
  80399d:	d3 ef                	shr    %cl,%edi
  80399f:	09 c7                	or     %eax,%edi
  8039a1:	89 e9                	mov    %ebp,%ecx
  8039a3:	d3 e2                	shl    %cl,%edx
  8039a5:	89 14 24             	mov    %edx,(%esp)
  8039a8:	89 d8                	mov    %ebx,%eax
  8039aa:	d3 e0                	shl    %cl,%eax
  8039ac:	89 c2                	mov    %eax,%edx
  8039ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039b2:	d3 e0                	shl    %cl,%eax
  8039b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039bc:	89 f1                	mov    %esi,%ecx
  8039be:	d3 e8                	shr    %cl,%eax
  8039c0:	09 d0                	or     %edx,%eax
  8039c2:	d3 eb                	shr    %cl,%ebx
  8039c4:	89 da                	mov    %ebx,%edx
  8039c6:	f7 f7                	div    %edi
  8039c8:	89 d3                	mov    %edx,%ebx
  8039ca:	f7 24 24             	mull   (%esp)
  8039cd:	89 c6                	mov    %eax,%esi
  8039cf:	89 d1                	mov    %edx,%ecx
  8039d1:	39 d3                	cmp    %edx,%ebx
  8039d3:	0f 82 87 00 00 00    	jb     803a60 <__umoddi3+0x134>
  8039d9:	0f 84 91 00 00 00    	je     803a70 <__umoddi3+0x144>
  8039df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039e3:	29 f2                	sub    %esi,%edx
  8039e5:	19 cb                	sbb    %ecx,%ebx
  8039e7:	89 d8                	mov    %ebx,%eax
  8039e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039ed:	d3 e0                	shl    %cl,%eax
  8039ef:	89 e9                	mov    %ebp,%ecx
  8039f1:	d3 ea                	shr    %cl,%edx
  8039f3:	09 d0                	or     %edx,%eax
  8039f5:	89 e9                	mov    %ebp,%ecx
  8039f7:	d3 eb                	shr    %cl,%ebx
  8039f9:	89 da                	mov    %ebx,%edx
  8039fb:	83 c4 1c             	add    $0x1c,%esp
  8039fe:	5b                   	pop    %ebx
  8039ff:	5e                   	pop    %esi
  803a00:	5f                   	pop    %edi
  803a01:	5d                   	pop    %ebp
  803a02:	c3                   	ret    
  803a03:	90                   	nop
  803a04:	89 fd                	mov    %edi,%ebp
  803a06:	85 ff                	test   %edi,%edi
  803a08:	75 0b                	jne    803a15 <__umoddi3+0xe9>
  803a0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0f:	31 d2                	xor    %edx,%edx
  803a11:	f7 f7                	div    %edi
  803a13:	89 c5                	mov    %eax,%ebp
  803a15:	89 f0                	mov    %esi,%eax
  803a17:	31 d2                	xor    %edx,%edx
  803a19:	f7 f5                	div    %ebp
  803a1b:	89 c8                	mov    %ecx,%eax
  803a1d:	f7 f5                	div    %ebp
  803a1f:	89 d0                	mov    %edx,%eax
  803a21:	e9 44 ff ff ff       	jmp    80396a <__umoddi3+0x3e>
  803a26:	66 90                	xchg   %ax,%ax
  803a28:	89 c8                	mov    %ecx,%eax
  803a2a:	89 f2                	mov    %esi,%edx
  803a2c:	83 c4 1c             	add    $0x1c,%esp
  803a2f:	5b                   	pop    %ebx
  803a30:	5e                   	pop    %esi
  803a31:	5f                   	pop    %edi
  803a32:	5d                   	pop    %ebp
  803a33:	c3                   	ret    
  803a34:	3b 04 24             	cmp    (%esp),%eax
  803a37:	72 06                	jb     803a3f <__umoddi3+0x113>
  803a39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a3d:	77 0f                	ja     803a4e <__umoddi3+0x122>
  803a3f:	89 f2                	mov    %esi,%edx
  803a41:	29 f9                	sub    %edi,%ecx
  803a43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a47:	89 14 24             	mov    %edx,(%esp)
  803a4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a52:	8b 14 24             	mov    (%esp),%edx
  803a55:	83 c4 1c             	add    $0x1c,%esp
  803a58:	5b                   	pop    %ebx
  803a59:	5e                   	pop    %esi
  803a5a:	5f                   	pop    %edi
  803a5b:	5d                   	pop    %ebp
  803a5c:	c3                   	ret    
  803a5d:	8d 76 00             	lea    0x0(%esi),%esi
  803a60:	2b 04 24             	sub    (%esp),%eax
  803a63:	19 fa                	sbb    %edi,%edx
  803a65:	89 d1                	mov    %edx,%ecx
  803a67:	89 c6                	mov    %eax,%esi
  803a69:	e9 71 ff ff ff       	jmp    8039df <__umoddi3+0xb3>
  803a6e:	66 90                	xchg   %ax,%ax
  803a70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a74:	72 ea                	jb     803a60 <__umoddi3+0x134>
  803a76:	89 d9                	mov    %ebx,%ecx
  803a78:	e9 62 ff ff ff       	jmp    8039df <__umoddi3+0xb3>
