
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
  80008d:	68 e0 39 80 00       	push   $0x8039e0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 39 80 00       	push   $0x8039fc
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
  8000ae:	68 18 3a 80 00       	push   $0x803a18
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 4c 3a 80 00       	push   $0x803a4c
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 a8 3a 80 00       	push   $0x803aa8
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 d4 1c 00 00       	call   801db4 <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 dc 3a 80 00       	push   $0x803adc
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
  80011d:	68 1d 3b 80 00       	push   $0x803b1d
  800122:	e8 38 1c 00 00       	call   801d5f <sys_create_env>
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
  800150:	68 1d 3b 80 00       	push   $0x803b1d
  800155:	e8 05 1c 00 00       	call   801d5f <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 88 19 00 00       	call   801aed <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 28 3b 80 00       	push   $0x803b28
  800177:	e8 9f 16 00 00       	call   80181b <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 2c 3b 80 00       	push   $0x803b2c
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 4c 3b 80 00       	push   $0x803b4c
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 fc 39 80 00       	push   $0x8039fc
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 36 19 00 00       	call   801aed <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 b8 3b 80 00       	push   $0x803bb8
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 fc 39 80 00       	push   $0x8039fc
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 d2 1c 00 00       	call   801eab <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 99 1b 00 00       	call   801d7d <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 8b 1b 00 00       	call   801d7d <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 36 3c 80 00       	push   $0x803c36
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 9d 34 00 00       	call   8036af <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 0a 1d 00 00       	call   801f25 <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 c8 18 00 00       	call   801aed <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 5a 17 00 00       	call   80198d <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 50 3c 80 00       	push   $0x803c50
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 a2 18 00 00       	call   801aed <sys_calculate_free_frames>
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
  80026f:	68 70 3c 80 00       	push   $0x803c70
  800274:	6a 3b                	push   $0x3b
  800276:	68 fc 39 80 00       	push   $0x8039fc
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 b8 3c 80 00       	push   $0x803cb8
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 dc 3c 80 00       	push   $0x803cdc
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
  8002c3:	68 0c 3d 80 00       	push   $0x803d0c
  8002c8:	e8 92 1a 00 00       	call   801d5f <sys_create_env>
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
  8002f6:	68 19 3d 80 00       	push   $0x803d19
  8002fb:	e8 5f 1a 00 00       	call   801d5f <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 26 3d 80 00       	push   $0x803d26
  800315:	e8 01 15 00 00       	call   80181b <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 28 3d 80 00       	push   $0x803d28
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 28 3b 80 00       	push   $0x803b28
  80033f:	e8 d7 14 00 00       	call   80181b <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 2c 3b 80 00       	push   $0x803b2c
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 4c 1b 00 00       	call   801eab <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 13 1a 00 00       	call   801d7d <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 05 1a 00 00       	call   801d7d <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 a4 1b 00 00       	call   801f25 <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 20 1b 00 00       	call   801eab <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 5d 17 00 00       	call   801aed <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 ef 15 00 00       	call   80198d <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 48 3d 80 00       	push   $0x803d48
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 d1 15 00 00       	call   80198d <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 5e 3d 80 00       	push   $0x803d5e
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 19 17 00 00       	call   801aed <sys_calculate_free_frames>
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
  8003f2:	68 74 3d 80 00       	push   $0x803d74
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 fc 39 80 00       	push   $0x8039fc
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 03 1b 00 00       	call   801f0b <inctst>


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
  800414:	e8 b4 19 00 00       	call   801dcd <sys_getenvindex>
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
  80047f:	e8 56 17 00 00       	call   801bda <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 34 3e 80 00       	push   $0x803e34
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
  8004af:	68 5c 3e 80 00       	push   $0x803e5c
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
  8004e0:	68 84 3e 80 00       	push   $0x803e84
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 dc 3e 80 00       	push   $0x803edc
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 34 3e 80 00       	push   $0x803e34
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 d6 16 00 00       	call   801bf4 <sys_enable_interrupt>

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
  800531:	e8 63 18 00 00       	call   801d99 <sys_destroy_env>
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
  800542:	e8 b8 18 00 00       	call   801dff <sys_exit_env>
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
  80056b:	68 f0 3e 80 00       	push   $0x803ef0
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 f5 3e 80 00       	push   $0x803ef5
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
  8005a8:	68 11 3f 80 00       	push   $0x803f11
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
  8005d4:	68 14 3f 80 00       	push   $0x803f14
  8005d9:	6a 26                	push   $0x26
  8005db:	68 60 3f 80 00       	push   $0x803f60
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
  8006a6:	68 6c 3f 80 00       	push   $0x803f6c
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 60 3f 80 00       	push   $0x803f60
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
  800716:	68 c0 3f 80 00       	push   $0x803fc0
  80071b:	6a 44                	push   $0x44
  80071d:	68 60 3f 80 00       	push   $0x803f60
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
  800770:	e8 b7 12 00 00       	call   801a2c <sys_cputs>
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
  8007e7:	e8 40 12 00 00       	call   801a2c <sys_cputs>
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
  800831:	e8 a4 13 00 00       	call   801bda <sys_disable_interrupt>
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
  800851:	e8 9e 13 00 00       	call   801bf4 <sys_enable_interrupt>
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
  80089b:	e8 c4 2e 00 00       	call   803764 <__udivdi3>
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
  8008eb:	e8 84 2f 00 00       	call   803874 <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 34 42 80 00       	add    $0x804234,%eax
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
  800a46:	8b 04 85 58 42 80 00 	mov    0x804258(,%eax,4),%eax
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
  800b27:	8b 34 9d a0 40 80 00 	mov    0x8040a0(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 45 42 80 00       	push   $0x804245
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
  800b4c:	68 4e 42 80 00       	push   $0x80424e
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
  800b79:	be 51 42 80 00       	mov    $0x804251,%esi
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
  80159f:	68 b0 43 80 00       	push   $0x8043b0
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
  80166f:	e8 fc 04 00 00       	call   801b70 <sys_allocate_chunk>
  801674:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801677:	a1 20 51 80 00       	mov    0x805120,%eax
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	50                   	push   %eax
  801680:	e8 71 0b 00 00       	call   8021f6 <initialize_MemBlocksList>
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
  8016ad:	68 d5 43 80 00       	push   $0x8043d5
  8016b2:	6a 33                	push   $0x33
  8016b4:	68 f3 43 80 00       	push   $0x8043f3
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
  80172c:	68 00 44 80 00       	push   $0x804400
  801731:	6a 34                	push   $0x34
  801733:	68 f3 43 80 00       	push   $0x8043f3
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
  8017c4:	e8 75 07 00 00       	call   801f3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	74 11                	je     8017de <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d3:	e8 e0 0d 00 00       	call   8025b8 <alloc_block_FF>
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
  8017ea:	e8 3c 0b 00 00       	call   80232b <insert_sorted_allocList>
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
  80180a:	68 24 44 80 00       	push   $0x804424
  80180f:	6a 6f                	push   $0x6f
  801811:	68 f3 43 80 00       	push   $0x8043f3
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
  801830:	75 0a                	jne    80183c <smalloc+0x21>
  801832:	b8 00 00 00 00       	mov    $0x0,%eax
  801837:	e9 8b 00 00 00       	jmp    8018c7 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80183c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801849:	01 d0                	add    %edx,%eax
  80184b:	48                   	dec    %eax
  80184c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80184f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801852:	ba 00 00 00 00       	mov    $0x0,%edx
  801857:	f7 75 f0             	divl   -0x10(%ebp)
  80185a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80185d:	29 d0                	sub    %edx,%eax
  80185f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801862:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801869:	e8 d0 06 00 00       	call   801f3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80186e:	85 c0                	test   %eax,%eax
  801870:	74 11                	je     801883 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801872:	83 ec 0c             	sub    $0xc,%esp
  801875:	ff 75 e8             	pushl  -0x18(%ebp)
  801878:	e8 3b 0d 00 00       	call   8025b8 <alloc_block_FF>
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801887:	74 39                	je     8018c2 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	8b 40 08             	mov    0x8(%eax),%eax
  80188f:	89 c2                	mov    %eax,%edx
  801891:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801895:	52                   	push   %edx
  801896:	50                   	push   %eax
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	ff 75 08             	pushl  0x8(%ebp)
  80189d:	e8 21 04 00 00       	call   801cc3 <sys_createSharedObject>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8018a8:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8018ac:	74 14                	je     8018c2 <smalloc+0xa7>
  8018ae:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8018b2:	74 0e                	je     8018c2 <smalloc+0xa7>
  8018b4:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8018b8:	74 08                	je     8018c2 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8018ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bd:	8b 40 08             	mov    0x8(%eax),%eax
  8018c0:	eb 05                	jmp    8018c7 <smalloc+0xac>
	}
	return NULL;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018cf:	e8 b4 fc ff ff       	call   801588 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018d4:	83 ec 08             	sub    $0x8,%esp
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	ff 75 08             	pushl  0x8(%ebp)
  8018dd:	e8 0b 04 00 00       	call   801ced <sys_getSizeOfSharedObject>
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8018e8:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8018ec:	74 76                	je     801964 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8018ee:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	48                   	dec    %eax
  8018fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801904:	ba 00 00 00 00       	mov    $0x0,%edx
  801909:	f7 75 ec             	divl   -0x14(%ebp)
  80190c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80190f:	29 d0                	sub    %edx,%eax
  801911:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801914:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80191b:	e8 1e 06 00 00       	call   801f3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801920:	85 c0                	test   %eax,%eax
  801922:	74 11                	je     801935 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801924:	83 ec 0c             	sub    $0xc,%esp
  801927:	ff 75 e4             	pushl  -0x1c(%ebp)
  80192a:	e8 89 0c 00 00       	call   8025b8 <alloc_block_FF>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801939:	74 29                	je     801964 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193e:	8b 40 08             	mov    0x8(%eax),%eax
  801941:	83 ec 04             	sub    $0x4,%esp
  801944:	50                   	push   %eax
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	e8 ba 03 00 00       	call   801d0a <sys_getSharedObject>
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801956:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80195a:	74 08                	je     801964 <sget+0x9b>
				return (void *)mem_block->sva;
  80195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195f:	8b 40 08             	mov    0x8(%eax),%eax
  801962:	eb 05                	jmp    801969 <sget+0xa0>
		}
	}
	return NULL;
  801964:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801971:	e8 12 fc ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	68 48 44 80 00       	push   $0x804448
  80197e:	68 f1 00 00 00       	push   $0xf1
  801983:	68 f3 43 80 00       	push   $0x8043f3
  801988:	e8 bd eb ff ff       	call   80054a <_panic>

0080198d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801993:	83 ec 04             	sub    $0x4,%esp
  801996:	68 70 44 80 00       	push   $0x804470
  80199b:	68 05 01 00 00       	push   $0x105
  8019a0:	68 f3 43 80 00       	push   $0x8043f3
  8019a5:	e8 a0 eb ff ff       	call   80054a <_panic>

008019aa <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019b0:	83 ec 04             	sub    $0x4,%esp
  8019b3:	68 94 44 80 00       	push   $0x804494
  8019b8:	68 10 01 00 00       	push   $0x110
  8019bd:	68 f3 43 80 00       	push   $0x8043f3
  8019c2:	e8 83 eb ff ff       	call   80054a <_panic>

008019c7 <shrink>:

}
void shrink(uint32 newSize)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	68 94 44 80 00       	push   $0x804494
  8019d5:	68 15 01 00 00       	push   $0x115
  8019da:	68 f3 43 80 00       	push   $0x8043f3
  8019df:	e8 66 eb ff ff       	call   80054a <_panic>

008019e4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	68 94 44 80 00       	push   $0x804494
  8019f2:	68 1a 01 00 00       	push   $0x11a
  8019f7:	68 f3 43 80 00       	push   $0x8043f3
  8019fc:	e8 49 eb ff ff       	call   80054a <_panic>

00801a01 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	57                   	push   %edi
  801a05:	56                   	push   %esi
  801a06:	53                   	push   %ebx
  801a07:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a13:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a16:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a19:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a1c:	cd 30                	int    $0x30
  801a1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5f                   	pop    %edi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 04             	sub    $0x4,%esp
  801a32:	8b 45 10             	mov    0x10(%ebp),%eax
  801a35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a38:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	52                   	push   %edx
  801a44:	ff 75 0c             	pushl  0xc(%ebp)
  801a47:	50                   	push   %eax
  801a48:	6a 00                	push   $0x0
  801a4a:	e8 b2 ff ff ff       	call   801a01 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 01                	push   $0x1
  801a64:	e8 98 ff ff ff       	call   801a01 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	52                   	push   %edx
  801a7e:	50                   	push   %eax
  801a7f:	6a 05                	push   $0x5
  801a81:	e8 7b ff ff ff       	call   801a01 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a90:	8b 75 18             	mov    0x18(%ebp),%esi
  801a93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	56                   	push   %esi
  801aa0:	53                   	push   %ebx
  801aa1:	51                   	push   %ecx
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	6a 06                	push   $0x6
  801aa6:	e8 56 ff ff ff       	call   801a01 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5d                   	pop    %ebp
  801ab4:	c3                   	ret    

00801ab5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	52                   	push   %edx
  801ac5:	50                   	push   %eax
  801ac6:	6a 07                	push   $0x7
  801ac8:	e8 34 ff ff ff       	call   801a01 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	6a 08                	push   $0x8
  801ae3:	e8 19 ff ff ff       	call   801a01 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 09                	push   $0x9
  801afc:	e8 00 ff ff ff       	call   801a01 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 0a                	push   $0xa
  801b15:	e8 e7 fe ff ff       	call   801a01 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 0b                	push   $0xb
  801b2e:	e8 ce fe ff ff       	call   801a01 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	ff 75 08             	pushl  0x8(%ebp)
  801b47:	6a 0f                	push   $0xf
  801b49:	e8 b3 fe ff ff       	call   801a01 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
	return;
  801b51:	90                   	nop
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	ff 75 08             	pushl  0x8(%ebp)
  801b63:	6a 10                	push   $0x10
  801b65:	e8 97 fe ff ff       	call   801a01 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6d:	90                   	nop
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	ff 75 10             	pushl  0x10(%ebp)
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	ff 75 08             	pushl  0x8(%ebp)
  801b80:	6a 11                	push   $0x11
  801b82:	e8 7a fe ff ff       	call   801a01 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8a:	90                   	nop
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 0c                	push   $0xc
  801b9c:	e8 60 fe ff ff       	call   801a01 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	6a 0d                	push   $0xd
  801bb6:	e8 46 fe ff ff       	call   801a01 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 0e                	push   $0xe
  801bcf:	e8 2d fe ff ff       	call   801a01 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	90                   	nop
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 13                	push   $0x13
  801be9:	e8 13 fe ff ff       	call   801a01 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	90                   	nop
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 14                	push   $0x14
  801c03:	e8 f9 fd ff ff       	call   801a01 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	90                   	nop
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_cputc>:


void
sys_cputc(const char c)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 04             	sub    $0x4,%esp
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	50                   	push   %eax
  801c27:	6a 15                	push   $0x15
  801c29:	e8 d3 fd ff ff       	call   801a01 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	90                   	nop
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 16                	push   $0x16
  801c43:	e8 b9 fd ff ff       	call   801a01 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	90                   	nop
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	50                   	push   %eax
  801c5e:	6a 17                	push   $0x17
  801c60:	e8 9c fd ff ff       	call   801a01 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	52                   	push   %edx
  801c7a:	50                   	push   %eax
  801c7b:	6a 1a                	push   $0x1a
  801c7d:	e8 7f fd ff ff       	call   801a01 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	52                   	push   %edx
  801c97:	50                   	push   %eax
  801c98:	6a 18                	push   $0x18
  801c9a:	e8 62 fd ff ff       	call   801a01 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	90                   	nop
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 19                	push   $0x19
  801cb8:	e8 44 fd ff ff       	call   801a01 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	90                   	nop
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ccf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	6a 00                	push   $0x0
  801cdb:	51                   	push   %ecx
  801cdc:	52                   	push   %edx
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	50                   	push   %eax
  801ce1:	6a 1b                	push   $0x1b
  801ce3:	e8 19 fd ff ff       	call   801a01 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	52                   	push   %edx
  801cfd:	50                   	push   %eax
  801cfe:	6a 1c                	push   $0x1c
  801d00:	e8 fc fc ff ff       	call   801a01 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	51                   	push   %ecx
  801d1b:	52                   	push   %edx
  801d1c:	50                   	push   %eax
  801d1d:	6a 1d                	push   $0x1d
  801d1f:	e8 dd fc ff ff       	call   801a01 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	52                   	push   %edx
  801d39:	50                   	push   %eax
  801d3a:	6a 1e                	push   $0x1e
  801d3c:	e8 c0 fc ff ff       	call   801a01 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 1f                	push   $0x1f
  801d55:	e8 a7 fc ff ff       	call   801a01 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	6a 00                	push   $0x0
  801d67:	ff 75 14             	pushl  0x14(%ebp)
  801d6a:	ff 75 10             	pushl  0x10(%ebp)
  801d6d:	ff 75 0c             	pushl  0xc(%ebp)
  801d70:	50                   	push   %eax
  801d71:	6a 20                	push   $0x20
  801d73:	e8 89 fc ff ff       	call   801a01 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	50                   	push   %eax
  801d8c:	6a 21                	push   $0x21
  801d8e:	e8 6e fc ff ff       	call   801a01 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	90                   	nop
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	50                   	push   %eax
  801da8:	6a 22                	push   $0x22
  801daa:	e8 52 fc ff ff       	call   801a01 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 02                	push   $0x2
  801dc3:	e8 39 fc ff ff       	call   801a01 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 03                	push   $0x3
  801ddc:	e8 20 fc ff ff       	call   801a01 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 04                	push   $0x4
  801df5:	e8 07 fc ff ff       	call   801a01 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_exit_env>:


void sys_exit_env(void)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 23                	push   $0x23
  801e0e:	e8 ee fb ff ff       	call   801a01 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	90                   	nop
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e1f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e22:	8d 50 04             	lea    0x4(%eax),%edx
  801e25:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	52                   	push   %edx
  801e2f:	50                   	push   %eax
  801e30:	6a 24                	push   $0x24
  801e32:	e8 ca fb ff ff       	call   801a01 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return result;
  801e3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e43:	89 01                	mov    %eax,(%ecx)
  801e45:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	c9                   	leave  
  801e4c:	c2 04 00             	ret    $0x4

00801e4f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	ff 75 10             	pushl  0x10(%ebp)
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	6a 12                	push   $0x12
  801e61:	e8 9b fb ff ff       	call   801a01 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return ;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_rcr2>:
uint32 sys_rcr2()
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 25                	push   $0x25
  801e7b:	e8 81 fb ff ff       	call   801a01 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e91:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	50                   	push   %eax
  801e9e:	6a 26                	push   $0x26
  801ea0:	e8 5c fb ff ff       	call   801a01 <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea8:	90                   	nop
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <rsttst>:
void rsttst()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 28                	push   $0x28
  801eba:	e8 42 fb ff ff       	call   801a01 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec2:	90                   	nop
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ece:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ed1:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed8:	52                   	push   %edx
  801ed9:	50                   	push   %eax
  801eda:	ff 75 10             	pushl  0x10(%ebp)
  801edd:	ff 75 0c             	pushl  0xc(%ebp)
  801ee0:	ff 75 08             	pushl  0x8(%ebp)
  801ee3:	6a 27                	push   $0x27
  801ee5:	e8 17 fb ff ff       	call   801a01 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
	return ;
  801eed:	90                   	nop
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <chktst>:
void chktst(uint32 n)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	ff 75 08             	pushl  0x8(%ebp)
  801efe:	6a 29                	push   $0x29
  801f00:	e8 fc fa ff ff       	call   801a01 <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
	return ;
  801f08:	90                   	nop
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <inctst>:

void inctst()
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 2a                	push   $0x2a
  801f1a:	e8 e2 fa ff ff       	call   801a01 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f22:	90                   	nop
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <gettst>:
uint32 gettst()
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 2b                	push   $0x2b
  801f34:	e8 c8 fa ff ff       	call   801a01 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 2c                	push   $0x2c
  801f50:	e8 ac fa ff ff       	call   801a01 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
  801f58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f5b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f5f:	75 07                	jne    801f68 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f61:	b8 01 00 00 00       	mov    $0x1,%eax
  801f66:	eb 05                	jmp    801f6d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 2c                	push   $0x2c
  801f81:	e8 7b fa ff ff       	call   801a01 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
  801f89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f8c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f90:	75 07                	jne    801f99 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f92:	b8 01 00 00 00       	mov    $0x1,%eax
  801f97:	eb 05                	jmp    801f9e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 2c                	push   $0x2c
  801fb2:	e8 4a fa ff ff       	call   801a01 <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
  801fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fbd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fc1:	75 07                	jne    801fca <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc8:	eb 05                	jmp    801fcf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 2c                	push   $0x2c
  801fe3:	e8 19 fa ff ff       	call   801a01 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
  801feb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fee:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ff2:	75 07                	jne    801ffb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff9:	eb 05                	jmp    802000 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	6a 2d                	push   $0x2d
  802012:	e8 ea f9 ff ff       	call   801a01 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
	return ;
  80201a:	90                   	nop
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802021:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802024:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	6a 00                	push   $0x0
  80202f:	53                   	push   %ebx
  802030:	51                   	push   %ecx
  802031:	52                   	push   %edx
  802032:	50                   	push   %eax
  802033:	6a 2e                	push   $0x2e
  802035:	e8 c7 f9 ff ff       	call   801a01 <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp
}
  80203d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	52                   	push   %edx
  802052:	50                   	push   %eax
  802053:	6a 2f                	push   $0x2f
  802055:	e8 a7 f9 ff ff       	call   801a01 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	68 a4 44 80 00       	push   $0x8044a4
  80206d:	e8 8c e7 ff ff       	call   8007fe <cprintf>
  802072:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802075:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80207c:	83 ec 0c             	sub    $0xc,%esp
  80207f:	68 d0 44 80 00       	push   $0x8044d0
  802084:	e8 75 e7 ff ff       	call   8007fe <cprintf>
  802089:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80208c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802090:	a1 38 51 80 00       	mov    0x805138,%eax
  802095:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802098:	eb 56                	jmp    8020f0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80209a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80209e:	74 1c                	je     8020bc <print_mem_block_lists+0x5d>
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 50 08             	mov    0x8(%eax),%edx
  8020a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a9:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020af:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b2:	01 c8                	add    %ecx,%eax
  8020b4:	39 c2                	cmp    %eax,%edx
  8020b6:	73 04                	jae    8020bc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020b8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	8b 50 08             	mov    0x8(%eax),%edx
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c8:	01 c2                	add    %eax,%edx
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 40 08             	mov    0x8(%eax),%eax
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	52                   	push   %edx
  8020d4:	50                   	push   %eax
  8020d5:	68 e5 44 80 00       	push   $0x8044e5
  8020da:	e8 1f e7 ff ff       	call   8007fe <cprintf>
  8020df:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8020ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f4:	74 07                	je     8020fd <print_mem_block_lists+0x9e>
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	8b 00                	mov    (%eax),%eax
  8020fb:	eb 05                	jmp    802102 <print_mem_block_lists+0xa3>
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	a3 40 51 80 00       	mov    %eax,0x805140
  802107:	a1 40 51 80 00       	mov    0x805140,%eax
  80210c:	85 c0                	test   %eax,%eax
  80210e:	75 8a                	jne    80209a <print_mem_block_lists+0x3b>
  802110:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802114:	75 84                	jne    80209a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802116:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80211a:	75 10                	jne    80212c <print_mem_block_lists+0xcd>
  80211c:	83 ec 0c             	sub    $0xc,%esp
  80211f:	68 f4 44 80 00       	push   $0x8044f4
  802124:	e8 d5 e6 ff ff       	call   8007fe <cprintf>
  802129:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80212c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802133:	83 ec 0c             	sub    $0xc,%esp
  802136:	68 18 45 80 00       	push   $0x804518
  80213b:	e8 be e6 ff ff       	call   8007fe <cprintf>
  802140:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802143:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802147:	a1 40 50 80 00       	mov    0x805040,%eax
  80214c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214f:	eb 56                	jmp    8021a7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802151:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802155:	74 1c                	je     802173 <print_mem_block_lists+0x114>
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 50 08             	mov    0x8(%eax),%edx
  80215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802160:	8b 48 08             	mov    0x8(%eax),%ecx
  802163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802166:	8b 40 0c             	mov    0xc(%eax),%eax
  802169:	01 c8                	add    %ecx,%eax
  80216b:	39 c2                	cmp    %eax,%edx
  80216d:	73 04                	jae    802173 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80216f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	8b 50 08             	mov    0x8(%eax),%edx
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 40 0c             	mov    0xc(%eax),%eax
  80217f:	01 c2                	add    %eax,%edx
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	83 ec 04             	sub    $0x4,%esp
  80218a:	52                   	push   %edx
  80218b:	50                   	push   %eax
  80218c:	68 e5 44 80 00       	push   $0x8044e5
  802191:	e8 68 e6 ff ff       	call   8007fe <cprintf>
  802196:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80219f:	a1 48 50 80 00       	mov    0x805048,%eax
  8021a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ab:	74 07                	je     8021b4 <print_mem_block_lists+0x155>
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	8b 00                	mov    (%eax),%eax
  8021b2:	eb 05                	jmp    8021b9 <print_mem_block_lists+0x15a>
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b9:	a3 48 50 80 00       	mov    %eax,0x805048
  8021be:	a1 48 50 80 00       	mov    0x805048,%eax
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	75 8a                	jne    802151 <print_mem_block_lists+0xf2>
  8021c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cb:	75 84                	jne    802151 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021cd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021d1:	75 10                	jne    8021e3 <print_mem_block_lists+0x184>
  8021d3:	83 ec 0c             	sub    $0xc,%esp
  8021d6:	68 30 45 80 00       	push   $0x804530
  8021db:	e8 1e e6 ff ff       	call   8007fe <cprintf>
  8021e0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021e3:	83 ec 0c             	sub    $0xc,%esp
  8021e6:	68 a4 44 80 00       	push   $0x8044a4
  8021eb:	e8 0e e6 ff ff       	call   8007fe <cprintf>
  8021f0:	83 c4 10             	add    $0x10,%esp

}
  8021f3:	90                   	nop
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8021fc:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802203:	00 00 00 
  802206:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80220d:	00 00 00 
  802210:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802217:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80221a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802221:	e9 9e 00 00 00       	jmp    8022c4 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802226:	a1 50 50 80 00       	mov    0x805050,%eax
  80222b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222e:	c1 e2 04             	shl    $0x4,%edx
  802231:	01 d0                	add    %edx,%eax
  802233:	85 c0                	test   %eax,%eax
  802235:	75 14                	jne    80224b <initialize_MemBlocksList+0x55>
  802237:	83 ec 04             	sub    $0x4,%esp
  80223a:	68 58 45 80 00       	push   $0x804558
  80223f:	6a 46                	push   $0x46
  802241:	68 7b 45 80 00       	push   $0x80457b
  802246:	e8 ff e2 ff ff       	call   80054a <_panic>
  80224b:	a1 50 50 80 00       	mov    0x805050,%eax
  802250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802253:	c1 e2 04             	shl    $0x4,%edx
  802256:	01 d0                	add    %edx,%eax
  802258:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80225e:	89 10                	mov    %edx,(%eax)
  802260:	8b 00                	mov    (%eax),%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	74 18                	je     80227e <initialize_MemBlocksList+0x88>
  802266:	a1 48 51 80 00       	mov    0x805148,%eax
  80226b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802271:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802274:	c1 e1 04             	shl    $0x4,%ecx
  802277:	01 ca                	add    %ecx,%edx
  802279:	89 50 04             	mov    %edx,0x4(%eax)
  80227c:	eb 12                	jmp    802290 <initialize_MemBlocksList+0x9a>
  80227e:	a1 50 50 80 00       	mov    0x805050,%eax
  802283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802286:	c1 e2 04             	shl    $0x4,%edx
  802289:	01 d0                	add    %edx,%eax
  80228b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802290:	a1 50 50 80 00       	mov    0x805050,%eax
  802295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802298:	c1 e2 04             	shl    $0x4,%edx
  80229b:	01 d0                	add    %edx,%eax
  80229d:	a3 48 51 80 00       	mov    %eax,0x805148
  8022a2:	a1 50 50 80 00       	mov    0x805050,%eax
  8022a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022aa:	c1 e2 04             	shl    $0x4,%edx
  8022ad:	01 d0                	add    %edx,%eax
  8022af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b6:	a1 54 51 80 00       	mov    0x805154,%eax
  8022bb:	40                   	inc    %eax
  8022bc:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8022c1:	ff 45 f4             	incl   -0xc(%ebp)
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ca:	0f 82 56 ff ff ff    	jb     802226 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8022d0:	90                   	nop
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022e1:	eb 19                	jmp    8022fc <find_block+0x29>
	{
		if(va==point->sva)
  8022e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e6:	8b 40 08             	mov    0x8(%eax),%eax
  8022e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022ec:	75 05                	jne    8022f3 <find_block+0x20>
		   return point;
  8022ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f1:	eb 36                	jmp    802329 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	8b 40 08             	mov    0x8(%eax),%eax
  8022f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802300:	74 07                	je     802309 <find_block+0x36>
  802302:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	eb 05                	jmp    80230e <find_block+0x3b>
  802309:	b8 00 00 00 00       	mov    $0x0,%eax
  80230e:	8b 55 08             	mov    0x8(%ebp),%edx
  802311:	89 42 08             	mov    %eax,0x8(%edx)
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	8b 40 08             	mov    0x8(%eax),%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	75 c5                	jne    8022e3 <find_block+0x10>
  80231e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802322:	75 bf                	jne    8022e3 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802324:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802331:	a1 40 50 80 00       	mov    0x805040,%eax
  802336:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802339:	a1 44 50 80 00       	mov    0x805044,%eax
  80233e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802344:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802347:	74 24                	je     80236d <insert_sorted_allocList+0x42>
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	8b 50 08             	mov    0x8(%eax),%edx
  80234f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802352:	8b 40 08             	mov    0x8(%eax),%eax
  802355:	39 c2                	cmp    %eax,%edx
  802357:	76 14                	jbe    80236d <insert_sorted_allocList+0x42>
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	8b 50 08             	mov    0x8(%eax),%edx
  80235f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802362:	8b 40 08             	mov    0x8(%eax),%eax
  802365:	39 c2                	cmp    %eax,%edx
  802367:	0f 82 60 01 00 00    	jb     8024cd <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80236d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802371:	75 65                	jne    8023d8 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802373:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802377:	75 14                	jne    80238d <insert_sorted_allocList+0x62>
  802379:	83 ec 04             	sub    $0x4,%esp
  80237c:	68 58 45 80 00       	push   $0x804558
  802381:	6a 6b                	push   $0x6b
  802383:	68 7b 45 80 00       	push   $0x80457b
  802388:	e8 bd e1 ff ff       	call   80054a <_panic>
  80238d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	89 10                	mov    %edx,(%eax)
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	74 0d                	je     8023ae <insert_sorted_allocList+0x83>
  8023a1:	a1 40 50 80 00       	mov    0x805040,%eax
  8023a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a9:	89 50 04             	mov    %edx,0x4(%eax)
  8023ac:	eb 08                	jmp    8023b6 <insert_sorted_allocList+0x8b>
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	a3 44 50 80 00       	mov    %eax,0x805044
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	a3 40 50 80 00       	mov    %eax,0x805040
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023cd:	40                   	inc    %eax
  8023ce:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023d3:	e9 dc 01 00 00       	jmp    8025b4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	8b 50 08             	mov    0x8(%eax),%edx
  8023de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e1:	8b 40 08             	mov    0x8(%eax),%eax
  8023e4:	39 c2                	cmp    %eax,%edx
  8023e6:	77 6c                	ja     802454 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8023e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ec:	74 06                	je     8023f4 <insert_sorted_allocList+0xc9>
  8023ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f2:	75 14                	jne    802408 <insert_sorted_allocList+0xdd>
  8023f4:	83 ec 04             	sub    $0x4,%esp
  8023f7:	68 94 45 80 00       	push   $0x804594
  8023fc:	6a 6f                	push   $0x6f
  8023fe:	68 7b 45 80 00       	push   $0x80457b
  802403:	e8 42 e1 ff ff       	call   80054a <_panic>
  802408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240b:	8b 50 04             	mov    0x4(%eax),%edx
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	89 50 04             	mov    %edx,0x4(%eax)
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80241a:	89 10                	mov    %edx,(%eax)
  80241c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241f:	8b 40 04             	mov    0x4(%eax),%eax
  802422:	85 c0                	test   %eax,%eax
  802424:	74 0d                	je     802433 <insert_sorted_allocList+0x108>
  802426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802429:	8b 40 04             	mov    0x4(%eax),%eax
  80242c:	8b 55 08             	mov    0x8(%ebp),%edx
  80242f:	89 10                	mov    %edx,(%eax)
  802431:	eb 08                	jmp    80243b <insert_sorted_allocList+0x110>
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	a3 40 50 80 00       	mov    %eax,0x805040
  80243b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243e:	8b 55 08             	mov    0x8(%ebp),%edx
  802441:	89 50 04             	mov    %edx,0x4(%eax)
  802444:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802449:	40                   	inc    %eax
  80244a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80244f:	e9 60 01 00 00       	jmp    8025b4 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	8b 50 08             	mov    0x8(%eax),%edx
  80245a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245d:	8b 40 08             	mov    0x8(%eax),%eax
  802460:	39 c2                	cmp    %eax,%edx
  802462:	0f 82 4c 01 00 00    	jb     8025b4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802468:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80246c:	75 14                	jne    802482 <insert_sorted_allocList+0x157>
  80246e:	83 ec 04             	sub    $0x4,%esp
  802471:	68 cc 45 80 00       	push   $0x8045cc
  802476:	6a 73                	push   $0x73
  802478:	68 7b 45 80 00       	push   $0x80457b
  80247d:	e8 c8 e0 ff ff       	call   80054a <_panic>
  802482:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	89 50 04             	mov    %edx,0x4(%eax)
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	8b 40 04             	mov    0x4(%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 0c                	je     8024a4 <insert_sorted_allocList+0x179>
  802498:	a1 44 50 80 00       	mov    0x805044,%eax
  80249d:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a0:	89 10                	mov    %edx,(%eax)
  8024a2:	eb 08                	jmp    8024ac <insert_sorted_allocList+0x181>
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	a3 40 50 80 00       	mov    %eax,0x805040
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	a3 44 50 80 00       	mov    %eax,0x805044
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024c2:	40                   	inc    %eax
  8024c3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024c8:	e9 e7 00 00 00       	jmp    8025b4 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8024d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024da:	a1 40 50 80 00       	mov    0x805040,%eax
  8024df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e2:	e9 9d 00 00 00       	jmp    802584 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	8b 50 08             	mov    0x8(%eax),%edx
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 08             	mov    0x8(%eax),%eax
  8024fb:	39 c2                	cmp    %eax,%edx
  8024fd:	76 7d                	jbe    80257c <insert_sorted_allocList+0x251>
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	8b 50 08             	mov    0x8(%eax),%edx
  802505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802508:	8b 40 08             	mov    0x8(%eax),%eax
  80250b:	39 c2                	cmp    %eax,%edx
  80250d:	73 6d                	jae    80257c <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80250f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802513:	74 06                	je     80251b <insert_sorted_allocList+0x1f0>
  802515:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802519:	75 14                	jne    80252f <insert_sorted_allocList+0x204>
  80251b:	83 ec 04             	sub    $0x4,%esp
  80251e:	68 f0 45 80 00       	push   $0x8045f0
  802523:	6a 7f                	push   $0x7f
  802525:	68 7b 45 80 00       	push   $0x80457b
  80252a:	e8 1b e0 ff ff       	call   80054a <_panic>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 10                	mov    (%eax),%edx
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	89 10                	mov    %edx,(%eax)
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	85 c0                	test   %eax,%eax
  802540:	74 0b                	je     80254d <insert_sorted_allocList+0x222>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 00                	mov    (%eax),%eax
  802547:	8b 55 08             	mov    0x8(%ebp),%edx
  80254a:	89 50 04             	mov    %edx,0x4(%eax)
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 55 08             	mov    0x8(%ebp),%edx
  802553:	89 10                	mov    %edx,(%eax)
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255b:	89 50 04             	mov    %edx,0x4(%eax)
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	85 c0                	test   %eax,%eax
  802565:	75 08                	jne    80256f <insert_sorted_allocList+0x244>
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	a3 44 50 80 00       	mov    %eax,0x805044
  80256f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802574:	40                   	inc    %eax
  802575:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80257a:	eb 39                	jmp    8025b5 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80257c:	a1 48 50 80 00       	mov    0x805048,%eax
  802581:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802588:	74 07                	je     802591 <insert_sorted_allocList+0x266>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 00                	mov    (%eax),%eax
  80258f:	eb 05                	jmp    802596 <insert_sorted_allocList+0x26b>
  802591:	b8 00 00 00 00       	mov    $0x0,%eax
  802596:	a3 48 50 80 00       	mov    %eax,0x805048
  80259b:	a1 48 50 80 00       	mov    0x805048,%eax
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	0f 85 3f ff ff ff    	jne    8024e7 <insert_sorted_allocList+0x1bc>
  8025a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ac:	0f 85 35 ff ff ff    	jne    8024e7 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025b2:	eb 01                	jmp    8025b5 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025b4:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025b5:	90                   	nop
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025be:	a1 38 51 80 00       	mov    0x805138,%eax
  8025c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c6:	e9 85 01 00 00       	jmp    802750 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d4:	0f 82 6e 01 00 00    	jb     802748 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e3:	0f 85 8a 00 00 00    	jne    802673 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8025e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ed:	75 17                	jne    802606 <alloc_block_FF+0x4e>
  8025ef:	83 ec 04             	sub    $0x4,%esp
  8025f2:	68 24 46 80 00       	push   $0x804624
  8025f7:	68 93 00 00 00       	push   $0x93
  8025fc:	68 7b 45 80 00       	push   $0x80457b
  802601:	e8 44 df ff ff       	call   80054a <_panic>
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 10                	je     80261f <alloc_block_FF+0x67>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802617:	8b 52 04             	mov    0x4(%edx),%edx
  80261a:	89 50 04             	mov    %edx,0x4(%eax)
  80261d:	eb 0b                	jmp    80262a <alloc_block_FF+0x72>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 40 04             	mov    0x4(%eax),%eax
  802625:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 04             	mov    0x4(%eax),%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	74 0f                	je     802643 <alloc_block_FF+0x8b>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 40 04             	mov    0x4(%eax),%eax
  80263a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263d:	8b 12                	mov    (%edx),%edx
  80263f:	89 10                	mov    %edx,(%eax)
  802641:	eb 0a                	jmp    80264d <alloc_block_FF+0x95>
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	a3 38 51 80 00       	mov    %eax,0x805138
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802660:	a1 44 51 80 00       	mov    0x805144,%eax
  802665:	48                   	dec    %eax
  802666:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	e9 10 01 00 00       	jmp    802783 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 0c             	mov    0xc(%eax),%eax
  802679:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267c:	0f 86 c6 00 00 00    	jbe    802748 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802682:	a1 48 51 80 00       	mov    0x805148,%eax
  802687:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 50 08             	mov    0x8(%eax),%edx
  802690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802693:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802696:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802699:	8b 55 08             	mov    0x8(%ebp),%edx
  80269c:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80269f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026a3:	75 17                	jne    8026bc <alloc_block_FF+0x104>
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	68 24 46 80 00       	push   $0x804624
  8026ad:	68 9b 00 00 00       	push   $0x9b
  8026b2:	68 7b 45 80 00       	push   $0x80457b
  8026b7:	e8 8e de ff ff       	call   80054a <_panic>
  8026bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 10                	je     8026d5 <alloc_block_FF+0x11d>
  8026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026cd:	8b 52 04             	mov    0x4(%edx),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	eb 0b                	jmp    8026e0 <alloc_block_FF+0x128>
  8026d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	74 0f                	je     8026f9 <alloc_block_FF+0x141>
  8026ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ed:	8b 40 04             	mov    0x4(%eax),%eax
  8026f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f3:	8b 12                	mov    (%edx),%edx
  8026f5:	89 10                	mov    %edx,(%eax)
  8026f7:	eb 0a                	jmp    802703 <alloc_block_FF+0x14b>
  8026f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	a3 48 51 80 00       	mov    %eax,0x805148
  802703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802716:	a1 54 51 80 00       	mov    0x805154,%eax
  80271b:	48                   	dec    %eax
  80271c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 50 08             	mov    0x8(%eax),%edx
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	01 c2                	add    %eax,%edx
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 0c             	mov    0xc(%eax),%eax
  802738:	2b 45 08             	sub    0x8(%ebp),%eax
  80273b:	89 c2                	mov    %eax,%edx
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	eb 3b                	jmp    802783 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802748:	a1 40 51 80 00       	mov    0x805140,%eax
  80274d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802750:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802754:	74 07                	je     80275d <alloc_block_FF+0x1a5>
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	eb 05                	jmp    802762 <alloc_block_FF+0x1aa>
  80275d:	b8 00 00 00 00       	mov    $0x0,%eax
  802762:	a3 40 51 80 00       	mov    %eax,0x805140
  802767:	a1 40 51 80 00       	mov    0x805140,%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	0f 85 57 fe ff ff    	jne    8025cb <alloc_block_FF+0x13>
  802774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802778:	0f 85 4d fe ff ff    	jne    8025cb <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80277e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80278b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802792:	a1 38 51 80 00       	mov    0x805138,%eax
  802797:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279a:	e9 df 00 00 00       	jmp    80287e <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a8:	0f 82 c8 00 00 00    	jb     802876 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b7:	0f 85 8a 00 00 00    	jne    802847 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8027bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c1:	75 17                	jne    8027da <alloc_block_BF+0x55>
  8027c3:	83 ec 04             	sub    $0x4,%esp
  8027c6:	68 24 46 80 00       	push   $0x804624
  8027cb:	68 b7 00 00 00       	push   $0xb7
  8027d0:	68 7b 45 80 00       	push   $0x80457b
  8027d5:	e8 70 dd ff ff       	call   80054a <_panic>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	85 c0                	test   %eax,%eax
  8027e1:	74 10                	je     8027f3 <alloc_block_BF+0x6e>
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027eb:	8b 52 04             	mov    0x4(%edx),%edx
  8027ee:	89 50 04             	mov    %edx,0x4(%eax)
  8027f1:	eb 0b                	jmp    8027fe <alloc_block_BF+0x79>
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 04             	mov    0x4(%eax),%eax
  8027f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 40 04             	mov    0x4(%eax),%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	74 0f                	je     802817 <alloc_block_BF+0x92>
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 40 04             	mov    0x4(%eax),%eax
  80280e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802811:	8b 12                	mov    (%edx),%edx
  802813:	89 10                	mov    %edx,(%eax)
  802815:	eb 0a                	jmp    802821 <alloc_block_BF+0x9c>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	a3 38 51 80 00       	mov    %eax,0x805138
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802834:	a1 44 51 80 00       	mov    0x805144,%eax
  802839:	48                   	dec    %eax
  80283a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	e9 4d 01 00 00       	jmp    802994 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 40 0c             	mov    0xc(%eax),%eax
  80284d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802850:	76 24                	jbe    802876 <alloc_block_BF+0xf1>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 40 0c             	mov    0xc(%eax),%eax
  802858:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80285b:	73 19                	jae    802876 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80285d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 40 0c             	mov    0xc(%eax),%eax
  80286a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 40 08             	mov    0x8(%eax),%eax
  802873:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802876:	a1 40 51 80 00       	mov    0x805140,%eax
  80287b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802882:	74 07                	je     80288b <alloc_block_BF+0x106>
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 00                	mov    (%eax),%eax
  802889:	eb 05                	jmp    802890 <alloc_block_BF+0x10b>
  80288b:	b8 00 00 00 00       	mov    $0x0,%eax
  802890:	a3 40 51 80 00       	mov    %eax,0x805140
  802895:	a1 40 51 80 00       	mov    0x805140,%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	0f 85 fd fe ff ff    	jne    80279f <alloc_block_BF+0x1a>
  8028a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a6:	0f 85 f3 fe ff ff    	jne    80279f <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8028ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028b0:	0f 84 d9 00 00 00    	je     80298f <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8028bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8028be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c4:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8028c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cd:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8028d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028d4:	75 17                	jne    8028ed <alloc_block_BF+0x168>
  8028d6:	83 ec 04             	sub    $0x4,%esp
  8028d9:	68 24 46 80 00       	push   $0x804624
  8028de:	68 c7 00 00 00       	push   $0xc7
  8028e3:	68 7b 45 80 00       	push   $0x80457b
  8028e8:	e8 5d dc ff ff       	call   80054a <_panic>
  8028ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 10                	je     802906 <alloc_block_BF+0x181>
  8028f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028fe:	8b 52 04             	mov    0x4(%edx),%edx
  802901:	89 50 04             	mov    %edx,0x4(%eax)
  802904:	eb 0b                	jmp    802911 <alloc_block_BF+0x18c>
  802906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802909:	8b 40 04             	mov    0x4(%eax),%eax
  80290c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802911:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 0f                	je     80292a <alloc_block_BF+0x1a5>
  80291b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802924:	8b 12                	mov    (%edx),%edx
  802926:	89 10                	mov    %edx,(%eax)
  802928:	eb 0a                	jmp    802934 <alloc_block_BF+0x1af>
  80292a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	a3 48 51 80 00       	mov    %eax,0x805148
  802934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802937:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802940:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802947:	a1 54 51 80 00       	mov    0x805154,%eax
  80294c:	48                   	dec    %eax
  80294d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802952:	83 ec 08             	sub    $0x8,%esp
  802955:	ff 75 ec             	pushl  -0x14(%ebp)
  802958:	68 38 51 80 00       	push   $0x805138
  80295d:	e8 71 f9 ff ff       	call   8022d3 <find_block>
  802962:	83 c4 10             	add    $0x10,%esp
  802965:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802968:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80296b:	8b 50 08             	mov    0x8(%eax),%edx
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	01 c2                	add    %eax,%edx
  802973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802976:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802979:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297c:	8b 40 0c             	mov    0xc(%eax),%eax
  80297f:	2b 45 08             	sub    0x8(%ebp),%eax
  802982:	89 c2                	mov    %eax,%edx
  802984:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802987:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80298a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298d:	eb 05                	jmp    802994 <alloc_block_BF+0x20f>
	}
	return NULL;
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802994:	c9                   	leave  
  802995:	c3                   	ret    

00802996 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
  802999:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80299c:	a1 28 50 80 00       	mov    0x805028,%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	0f 85 de 01 00 00    	jne    802b87 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b1:	e9 9e 01 00 00       	jmp    802b54 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029bf:	0f 82 87 01 00 00    	jb     802b4c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ce:	0f 85 95 00 00 00    	jne    802a69 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8029d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d8:	75 17                	jne    8029f1 <alloc_block_NF+0x5b>
  8029da:	83 ec 04             	sub    $0x4,%esp
  8029dd:	68 24 46 80 00       	push   $0x804624
  8029e2:	68 e0 00 00 00       	push   $0xe0
  8029e7:	68 7b 45 80 00       	push   $0x80457b
  8029ec:	e8 59 db ff ff       	call   80054a <_panic>
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	74 10                	je     802a0a <alloc_block_NF+0x74>
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 00                	mov    (%eax),%eax
  8029ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a02:	8b 52 04             	mov    0x4(%edx),%edx
  802a05:	89 50 04             	mov    %edx,0x4(%eax)
  802a08:	eb 0b                	jmp    802a15 <alloc_block_NF+0x7f>
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 40 04             	mov    0x4(%eax),%eax
  802a10:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 0f                	je     802a2e <alloc_block_NF+0x98>
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 40 04             	mov    0x4(%eax),%eax
  802a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a28:	8b 12                	mov    (%edx),%edx
  802a2a:	89 10                	mov    %edx,(%eax)
  802a2c:	eb 0a                	jmp    802a38 <alloc_block_NF+0xa2>
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 00                	mov    (%eax),%eax
  802a33:	a3 38 51 80 00       	mov    %eax,0x805138
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4b:	a1 44 51 80 00       	mov    0x805144,%eax
  802a50:	48                   	dec    %eax
  802a51:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 08             	mov    0x8(%eax),%eax
  802a5c:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	e9 f8 04 00 00       	jmp    802f61 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a72:	0f 86 d4 00 00 00    	jbe    802b4c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a78:	a1 48 51 80 00       	mov    0x805148,%eax
  802a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 50 08             	mov    0x8(%eax),%edx
  802a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a89:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a92:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a99:	75 17                	jne    802ab2 <alloc_block_NF+0x11c>
  802a9b:	83 ec 04             	sub    $0x4,%esp
  802a9e:	68 24 46 80 00       	push   $0x804624
  802aa3:	68 e9 00 00 00       	push   $0xe9
  802aa8:	68 7b 45 80 00       	push   $0x80457b
  802aad:	e8 98 da ff ff       	call   80054a <_panic>
  802ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	74 10                	je     802acb <alloc_block_NF+0x135>
  802abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac3:	8b 52 04             	mov    0x4(%edx),%edx
  802ac6:	89 50 04             	mov    %edx,0x4(%eax)
  802ac9:	eb 0b                	jmp    802ad6 <alloc_block_NF+0x140>
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	8b 40 04             	mov    0x4(%eax),%eax
  802ad1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad9:	8b 40 04             	mov    0x4(%eax),%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	74 0f                	je     802aef <alloc_block_NF+0x159>
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	8b 40 04             	mov    0x4(%eax),%eax
  802ae6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae9:	8b 12                	mov    (%edx),%edx
  802aeb:	89 10                	mov    %edx,(%eax)
  802aed:	eb 0a                	jmp    802af9 <alloc_block_NF+0x163>
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	a3 48 51 80 00       	mov    %eax,0x805148
  802af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802b11:	48                   	dec    %eax
  802b12:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1a:	8b 40 08             	mov    0x8(%eax),%eax
  802b1d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 50 08             	mov    0x8(%eax),%edx
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	01 c2                	add    %eax,%edx
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	2b 45 08             	sub    0x8(%ebp),%eax
  802b3c:	89 c2                	mov    %eax,%edx
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	e9 15 04 00 00       	jmp    802f61 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b4c:	a1 40 51 80 00       	mov    0x805140,%eax
  802b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b58:	74 07                	je     802b61 <alloc_block_NF+0x1cb>
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	eb 05                	jmp    802b66 <alloc_block_NF+0x1d0>
  802b61:	b8 00 00 00 00       	mov    $0x0,%eax
  802b66:	a3 40 51 80 00       	mov    %eax,0x805140
  802b6b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	0f 85 3e fe ff ff    	jne    8029b6 <alloc_block_NF+0x20>
  802b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7c:	0f 85 34 fe ff ff    	jne    8029b6 <alloc_block_NF+0x20>
  802b82:	e9 d5 03 00 00       	jmp    802f5c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b87:	a1 38 51 80 00       	mov    0x805138,%eax
  802b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8f:	e9 b1 01 00 00       	jmp    802d45 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 50 08             	mov    0x8(%eax),%edx
  802b9a:	a1 28 50 80 00       	mov    0x805028,%eax
  802b9f:	39 c2                	cmp    %eax,%edx
  802ba1:	0f 82 96 01 00 00    	jb     802d3d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bad:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb0:	0f 82 87 01 00 00    	jb     802d3d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bbf:	0f 85 95 00 00 00    	jne    802c5a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc9:	75 17                	jne    802be2 <alloc_block_NF+0x24c>
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	68 24 46 80 00       	push   $0x804624
  802bd3:	68 fc 00 00 00       	push   $0xfc
  802bd8:	68 7b 45 80 00       	push   $0x80457b
  802bdd:	e8 68 d9 ff ff       	call   80054a <_panic>
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 10                	je     802bfb <alloc_block_NF+0x265>
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf3:	8b 52 04             	mov    0x4(%edx),%edx
  802bf6:	89 50 04             	mov    %edx,0x4(%eax)
  802bf9:	eb 0b                	jmp    802c06 <alloc_block_NF+0x270>
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0f                	je     802c1f <alloc_block_NF+0x289>
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c19:	8b 12                	mov    (%edx),%edx
  802c1b:	89 10                	mov    %edx,(%eax)
  802c1d:	eb 0a                	jmp    802c29 <alloc_block_NF+0x293>
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	a3 38 51 80 00       	mov    %eax,0x805138
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3c:	a1 44 51 80 00       	mov    0x805144,%eax
  802c41:	48                   	dec    %eax
  802c42:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	e9 07 03 00 00       	jmp    802f61 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c60:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c63:	0f 86 d4 00 00 00    	jbe    802d3d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c69:	a1 48 51 80 00       	mov    0x805148,%eax
  802c6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 50 08             	mov    0x8(%eax),%edx
  802c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c80:	8b 55 08             	mov    0x8(%ebp),%edx
  802c83:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c8a:	75 17                	jne    802ca3 <alloc_block_NF+0x30d>
  802c8c:	83 ec 04             	sub    $0x4,%esp
  802c8f:	68 24 46 80 00       	push   $0x804624
  802c94:	68 04 01 00 00       	push   $0x104
  802c99:	68 7b 45 80 00       	push   $0x80457b
  802c9e:	e8 a7 d8 ff ff       	call   80054a <_panic>
  802ca3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca6:	8b 00                	mov    (%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 10                	je     802cbc <alloc_block_NF+0x326>
  802cac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cb4:	8b 52 04             	mov    0x4(%edx),%edx
  802cb7:	89 50 04             	mov    %edx,0x4(%eax)
  802cba:	eb 0b                	jmp    802cc7 <alloc_block_NF+0x331>
  802cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cca:	8b 40 04             	mov    0x4(%eax),%eax
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	74 0f                	je     802ce0 <alloc_block_NF+0x34a>
  802cd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd4:	8b 40 04             	mov    0x4(%eax),%eax
  802cd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cda:	8b 12                	mov    (%edx),%edx
  802cdc:	89 10                	mov    %edx,(%eax)
  802cde:	eb 0a                	jmp    802cea <alloc_block_NF+0x354>
  802ce0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	a3 48 51 80 00       	mov    %eax,0x805148
  802cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ced:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfd:	a1 54 51 80 00       	mov    0x805154,%eax
  802d02:	48                   	dec    %eax
  802d03:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0b:	8b 40 08             	mov    0x8(%eax),%eax
  802d0e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 50 08             	mov    0x8(%eax),%edx
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	01 c2                	add    %eax,%edx
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d2d:	89 c2                	mov    %eax,%edx
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d38:	e9 24 02 00 00       	jmp    802f61 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d49:	74 07                	je     802d52 <alloc_block_NF+0x3bc>
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	eb 05                	jmp    802d57 <alloc_block_NF+0x3c1>
  802d52:	b8 00 00 00 00       	mov    $0x0,%eax
  802d57:	a3 40 51 80 00       	mov    %eax,0x805140
  802d5c:	a1 40 51 80 00       	mov    0x805140,%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	0f 85 2b fe ff ff    	jne    802b94 <alloc_block_NF+0x1fe>
  802d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6d:	0f 85 21 fe ff ff    	jne    802b94 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d73:	a1 38 51 80 00       	mov    0x805138,%eax
  802d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d7b:	e9 ae 01 00 00       	jmp    802f2e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 50 08             	mov    0x8(%eax),%edx
  802d86:	a1 28 50 80 00       	mov    0x805028,%eax
  802d8b:	39 c2                	cmp    %eax,%edx
  802d8d:	0f 83 93 01 00 00    	jae    802f26 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	8b 40 0c             	mov    0xc(%eax),%eax
  802d99:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d9c:	0f 82 84 01 00 00    	jb     802f26 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 40 0c             	mov    0xc(%eax),%eax
  802da8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dab:	0f 85 95 00 00 00    	jne    802e46 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db5:	75 17                	jne    802dce <alloc_block_NF+0x438>
  802db7:	83 ec 04             	sub    $0x4,%esp
  802dba:	68 24 46 80 00       	push   $0x804624
  802dbf:	68 14 01 00 00       	push   $0x114
  802dc4:	68 7b 45 80 00       	push   $0x80457b
  802dc9:	e8 7c d7 ff ff       	call   80054a <_panic>
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 10                	je     802de7 <alloc_block_NF+0x451>
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddf:	8b 52 04             	mov    0x4(%edx),%edx
  802de2:	89 50 04             	mov    %edx,0x4(%eax)
  802de5:	eb 0b                	jmp    802df2 <alloc_block_NF+0x45c>
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 0f                	je     802e0b <alloc_block_NF+0x475>
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	8b 40 04             	mov    0x4(%eax),%eax
  802e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e05:	8b 12                	mov    (%edx),%edx
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	eb 0a                	jmp    802e15 <alloc_block_NF+0x47f>
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 00                	mov    (%eax),%eax
  802e10:	a3 38 51 80 00       	mov    %eax,0x805138
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e28:	a1 44 51 80 00       	mov    0x805144,%eax
  802e2d:	48                   	dec    %eax
  802e2e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 40 08             	mov    0x8(%eax),%eax
  802e39:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	e9 1b 01 00 00       	jmp    802f61 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e4f:	0f 86 d1 00 00 00    	jbe    802f26 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e55:	a1 48 51 80 00       	mov    0x805148,%eax
  802e5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 50 08             	mov    0x8(%eax),%edx
  802e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e66:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e76:	75 17                	jne    802e8f <alloc_block_NF+0x4f9>
  802e78:	83 ec 04             	sub    $0x4,%esp
  802e7b:	68 24 46 80 00       	push   $0x804624
  802e80:	68 1c 01 00 00       	push   $0x11c
  802e85:	68 7b 45 80 00       	push   $0x80457b
  802e8a:	e8 bb d6 ff ff       	call   80054a <_panic>
  802e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	85 c0                	test   %eax,%eax
  802e96:	74 10                	je     802ea8 <alloc_block_NF+0x512>
  802e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ea0:	8b 52 04             	mov    0x4(%edx),%edx
  802ea3:	89 50 04             	mov    %edx,0x4(%eax)
  802ea6:	eb 0b                	jmp    802eb3 <alloc_block_NF+0x51d>
  802ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb6:	8b 40 04             	mov    0x4(%eax),%eax
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	74 0f                	je     802ecc <alloc_block_NF+0x536>
  802ebd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec0:	8b 40 04             	mov    0x4(%eax),%eax
  802ec3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ec6:	8b 12                	mov    (%edx),%edx
  802ec8:	89 10                	mov    %edx,(%eax)
  802eca:	eb 0a                	jmp    802ed6 <alloc_block_NF+0x540>
  802ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee9:	a1 54 51 80 00       	mov    0x805154,%eax
  802eee:	48                   	dec    %eax
  802eef:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef7:	8b 40 08             	mov    0x8(%eax),%eax
  802efa:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	8b 50 08             	mov    0x8(%eax),%edx
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	01 c2                	add    %eax,%edx
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 40 0c             	mov    0xc(%eax),%eax
  802f16:	2b 45 08             	sub    0x8(%ebp),%eax
  802f19:	89 c2                	mov    %eax,%edx
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f24:	eb 3b                	jmp    802f61 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f26:	a1 40 51 80 00       	mov    0x805140,%eax
  802f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f32:	74 07                	je     802f3b <alloc_block_NF+0x5a5>
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 00                	mov    (%eax),%eax
  802f39:	eb 05                	jmp    802f40 <alloc_block_NF+0x5aa>
  802f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f40:	a3 40 51 80 00       	mov    %eax,0x805140
  802f45:	a1 40 51 80 00       	mov    0x805140,%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	0f 85 2e fe ff ff    	jne    802d80 <alloc_block_NF+0x3ea>
  802f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f56:	0f 85 24 fe ff ff    	jne    802d80 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f61:	c9                   	leave  
  802f62:	c3                   	ret    

00802f63 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f63:	55                   	push   %ebp
  802f64:	89 e5                	mov    %esp,%ebp
  802f66:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802f69:	a1 38 51 80 00       	mov    0x805138,%eax
  802f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802f71:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f76:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802f79:	a1 38 51 80 00       	mov    0x805138,%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 14                	je     802f96 <insert_sorted_with_merge_freeList+0x33>
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	8b 50 08             	mov    0x8(%eax),%edx
  802f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8b:	8b 40 08             	mov    0x8(%eax),%eax
  802f8e:	39 c2                	cmp    %eax,%edx
  802f90:	0f 87 9b 01 00 00    	ja     803131 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9a:	75 17                	jne    802fb3 <insert_sorted_with_merge_freeList+0x50>
  802f9c:	83 ec 04             	sub    $0x4,%esp
  802f9f:	68 58 45 80 00       	push   $0x804558
  802fa4:	68 38 01 00 00       	push   $0x138
  802fa9:	68 7b 45 80 00       	push   $0x80457b
  802fae:	e8 97 d5 ff ff       	call   80054a <_panic>
  802fb3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	89 10                	mov    %edx,(%eax)
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	85 c0                	test   %eax,%eax
  802fc5:	74 0d                	je     802fd4 <insert_sorted_with_merge_freeList+0x71>
  802fc7:	a1 38 51 80 00       	mov    0x805138,%eax
  802fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802fcf:	89 50 04             	mov    %edx,0x4(%eax)
  802fd2:	eb 08                	jmp    802fdc <insert_sorted_with_merge_freeList+0x79>
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fee:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff3:	40                   	inc    %eax
  802ff4:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ff9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ffd:	0f 84 a8 06 00 00    	je     8036ab <insert_sorted_with_merge_freeList+0x748>
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	8b 50 08             	mov    0x8(%eax),%edx
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	8b 40 0c             	mov    0xc(%eax),%eax
  80300f:	01 c2                	add    %eax,%edx
  803011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803014:	8b 40 08             	mov    0x8(%eax),%eax
  803017:	39 c2                	cmp    %eax,%edx
  803019:	0f 85 8c 06 00 00    	jne    8036ab <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	8b 50 0c             	mov    0xc(%eax),%edx
  803025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803028:	8b 40 0c             	mov    0xc(%eax),%eax
  80302b:	01 c2                	add    %eax,%edx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803033:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803037:	75 17                	jne    803050 <insert_sorted_with_merge_freeList+0xed>
  803039:	83 ec 04             	sub    $0x4,%esp
  80303c:	68 24 46 80 00       	push   $0x804624
  803041:	68 3c 01 00 00       	push   $0x13c
  803046:	68 7b 45 80 00       	push   $0x80457b
  80304b:	e8 fa d4 ff ff       	call   80054a <_panic>
  803050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	85 c0                	test   %eax,%eax
  803057:	74 10                	je     803069 <insert_sorted_with_merge_freeList+0x106>
  803059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803061:	8b 52 04             	mov    0x4(%edx),%edx
  803064:	89 50 04             	mov    %edx,0x4(%eax)
  803067:	eb 0b                	jmp    803074 <insert_sorted_with_merge_freeList+0x111>
  803069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306c:	8b 40 04             	mov    0x4(%eax),%eax
  80306f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803077:	8b 40 04             	mov    0x4(%eax),%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	74 0f                	je     80308d <insert_sorted_with_merge_freeList+0x12a>
  80307e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803081:	8b 40 04             	mov    0x4(%eax),%eax
  803084:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803087:	8b 12                	mov    (%edx),%edx
  803089:	89 10                	mov    %edx,(%eax)
  80308b:	eb 0a                	jmp    803097 <insert_sorted_with_merge_freeList+0x134>
  80308d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	a3 38 51 80 00       	mov    %eax,0x805138
  803097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8030af:	48                   	dec    %eax
  8030b0:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8030b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8030bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8030c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030cd:	75 17                	jne    8030e6 <insert_sorted_with_merge_freeList+0x183>
  8030cf:	83 ec 04             	sub    $0x4,%esp
  8030d2:	68 58 45 80 00       	push   $0x804558
  8030d7:	68 3f 01 00 00       	push   $0x13f
  8030dc:	68 7b 45 80 00       	push   $0x80457b
  8030e1:	e8 64 d4 ff ff       	call   80054a <_panic>
  8030e6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ef:	89 10                	mov    %edx,(%eax)
  8030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 0d                	je     803107 <insert_sorted_with_merge_freeList+0x1a4>
  8030fa:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803102:	89 50 04             	mov    %edx,0x4(%eax)
  803105:	eb 08                	jmp    80310f <insert_sorted_with_merge_freeList+0x1ac>
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	a3 48 51 80 00       	mov    %eax,0x805148
  803117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803121:	a1 54 51 80 00       	mov    0x805154,%eax
  803126:	40                   	inc    %eax
  803127:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80312c:	e9 7a 05 00 00       	jmp    8036ab <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	8b 50 08             	mov    0x8(%eax),%edx
  803137:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313a:	8b 40 08             	mov    0x8(%eax),%eax
  80313d:	39 c2                	cmp    %eax,%edx
  80313f:	0f 82 14 01 00 00    	jb     803259 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803145:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803148:	8b 50 08             	mov    0x8(%eax),%edx
  80314b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314e:	8b 40 0c             	mov    0xc(%eax),%eax
  803151:	01 c2                	add    %eax,%edx
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	8b 40 08             	mov    0x8(%eax),%eax
  803159:	39 c2                	cmp    %eax,%edx
  80315b:	0f 85 90 00 00 00    	jne    8031f1 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803164:	8b 50 0c             	mov    0xc(%eax),%edx
  803167:	8b 45 08             	mov    0x8(%ebp),%eax
  80316a:	8b 40 0c             	mov    0xc(%eax),%eax
  80316d:	01 c2                	add    %eax,%edx
  80316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803172:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803189:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318d:	75 17                	jne    8031a6 <insert_sorted_with_merge_freeList+0x243>
  80318f:	83 ec 04             	sub    $0x4,%esp
  803192:	68 58 45 80 00       	push   $0x804558
  803197:	68 49 01 00 00       	push   $0x149
  80319c:	68 7b 45 80 00       	push   $0x80457b
  8031a1:	e8 a4 d3 ff ff       	call   80054a <_panic>
  8031a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	89 10                	mov    %edx,(%eax)
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	8b 00                	mov    (%eax),%eax
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	74 0d                	je     8031c7 <insert_sorted_with_merge_freeList+0x264>
  8031ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8031bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c2:	89 50 04             	mov    %edx,0x4(%eax)
  8031c5:	eb 08                	jmp    8031cf <insert_sorted_with_merge_freeList+0x26c>
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8031e6:	40                   	inc    %eax
  8031e7:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031ec:	e9 bb 04 00 00       	jmp    8036ac <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8031f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f5:	75 17                	jne    80320e <insert_sorted_with_merge_freeList+0x2ab>
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	68 cc 45 80 00       	push   $0x8045cc
  8031ff:	68 4c 01 00 00       	push   $0x14c
  803204:	68 7b 45 80 00       	push   $0x80457b
  803209:	e8 3c d3 ff ff       	call   80054a <_panic>
  80320e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803214:	8b 45 08             	mov    0x8(%ebp),%eax
  803217:	89 50 04             	mov    %edx,0x4(%eax)
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	8b 40 04             	mov    0x4(%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	74 0c                	je     803230 <insert_sorted_with_merge_freeList+0x2cd>
  803224:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803229:	8b 55 08             	mov    0x8(%ebp),%edx
  80322c:	89 10                	mov    %edx,(%eax)
  80322e:	eb 08                	jmp    803238 <insert_sorted_with_merge_freeList+0x2d5>
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	a3 38 51 80 00       	mov    %eax,0x805138
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803249:	a1 44 51 80 00       	mov    0x805144,%eax
  80324e:	40                   	inc    %eax
  80324f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803254:	e9 53 04 00 00       	jmp    8036ac <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803259:	a1 38 51 80 00       	mov    0x805138,%eax
  80325e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803261:	e9 15 04 00 00       	jmp    80367b <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	8b 00                	mov    (%eax),%eax
  80326b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	8b 50 08             	mov    0x8(%eax),%edx
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	8b 40 08             	mov    0x8(%eax),%eax
  80327a:	39 c2                	cmp    %eax,%edx
  80327c:	0f 86 f1 03 00 00    	jbe    803673 <insert_sorted_with_merge_freeList+0x710>
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	8b 50 08             	mov    0x8(%eax),%edx
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	8b 40 08             	mov    0x8(%eax),%eax
  80328e:	39 c2                	cmp    %eax,%edx
  803290:	0f 83 dd 03 00 00    	jae    803673 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803299:	8b 50 08             	mov    0x8(%eax),%edx
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a2:	01 c2                	add    %eax,%edx
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 40 08             	mov    0x8(%eax),%eax
  8032aa:	39 c2                	cmp    %eax,%edx
  8032ac:	0f 85 b9 01 00 00    	jne    80346b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	8b 50 08             	mov    0x8(%eax),%edx
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032be:	01 c2                	add    %eax,%edx
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	8b 40 08             	mov    0x8(%eax),%eax
  8032c6:	39 c2                	cmp    %eax,%edx
  8032c8:	0f 85 0d 01 00 00    	jne    8033db <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8032ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032da:	01 c2                	add    %eax,%edx
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e6:	75 17                	jne    8032ff <insert_sorted_with_merge_freeList+0x39c>
  8032e8:	83 ec 04             	sub    $0x4,%esp
  8032eb:	68 24 46 80 00       	push   $0x804624
  8032f0:	68 5c 01 00 00       	push   $0x15c
  8032f5:	68 7b 45 80 00       	push   $0x80457b
  8032fa:	e8 4b d2 ff ff       	call   80054a <_panic>
  8032ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803302:	8b 00                	mov    (%eax),%eax
  803304:	85 c0                	test   %eax,%eax
  803306:	74 10                	je     803318 <insert_sorted_with_merge_freeList+0x3b5>
  803308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803310:	8b 52 04             	mov    0x4(%edx),%edx
  803313:	89 50 04             	mov    %edx,0x4(%eax)
  803316:	eb 0b                	jmp    803323 <insert_sorted_with_merge_freeList+0x3c0>
  803318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331b:	8b 40 04             	mov    0x4(%eax),%eax
  80331e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	8b 40 04             	mov    0x4(%eax),%eax
  803329:	85 c0                	test   %eax,%eax
  80332b:	74 0f                	je     80333c <insert_sorted_with_merge_freeList+0x3d9>
  80332d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803330:	8b 40 04             	mov    0x4(%eax),%eax
  803333:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803336:	8b 12                	mov    (%edx),%edx
  803338:	89 10                	mov    %edx,(%eax)
  80333a:	eb 0a                	jmp    803346 <insert_sorted_with_merge_freeList+0x3e3>
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	8b 00                	mov    (%eax),%eax
  803341:	a3 38 51 80 00       	mov    %eax,0x805138
  803346:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803359:	a1 44 51 80 00       	mov    0x805144,%eax
  80335e:	48                   	dec    %eax
  80335f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803367:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80336e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803371:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803378:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80337c:	75 17                	jne    803395 <insert_sorted_with_merge_freeList+0x432>
  80337e:	83 ec 04             	sub    $0x4,%esp
  803381:	68 58 45 80 00       	push   $0x804558
  803386:	68 5f 01 00 00       	push   $0x15f
  80338b:	68 7b 45 80 00       	push   $0x80457b
  803390:	e8 b5 d1 ff ff       	call   80054a <_panic>
  803395:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339e:	89 10                	mov    %edx,(%eax)
  8033a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	74 0d                	je     8033b6 <insert_sorted_with_merge_freeList+0x453>
  8033a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b1:	89 50 04             	mov    %edx,0x4(%eax)
  8033b4:	eb 08                	jmp    8033be <insert_sorted_with_merge_freeList+0x45b>
  8033b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8033c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8033d5:	40                   	inc    %eax
  8033d6:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033de:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e7:	01 c2                	add    %eax,%edx
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803407:	75 17                	jne    803420 <insert_sorted_with_merge_freeList+0x4bd>
  803409:	83 ec 04             	sub    $0x4,%esp
  80340c:	68 58 45 80 00       	push   $0x804558
  803411:	68 64 01 00 00       	push   $0x164
  803416:	68 7b 45 80 00       	push   $0x80457b
  80341b:	e8 2a d1 ff ff       	call   80054a <_panic>
  803420:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	89 10                	mov    %edx,(%eax)
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	8b 00                	mov    (%eax),%eax
  803430:	85 c0                	test   %eax,%eax
  803432:	74 0d                	je     803441 <insert_sorted_with_merge_freeList+0x4de>
  803434:	a1 48 51 80 00       	mov    0x805148,%eax
  803439:	8b 55 08             	mov    0x8(%ebp),%edx
  80343c:	89 50 04             	mov    %edx,0x4(%eax)
  80343f:	eb 08                	jmp    803449 <insert_sorted_with_merge_freeList+0x4e6>
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	a3 48 51 80 00       	mov    %eax,0x805148
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345b:	a1 54 51 80 00       	mov    0x805154,%eax
  803460:	40                   	inc    %eax
  803461:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803466:	e9 41 02 00 00       	jmp    8036ac <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	8b 50 08             	mov    0x8(%eax),%edx
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	8b 40 0c             	mov    0xc(%eax),%eax
  803477:	01 c2                	add    %eax,%edx
  803479:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347c:	8b 40 08             	mov    0x8(%eax),%eax
  80347f:	39 c2                	cmp    %eax,%edx
  803481:	0f 85 7c 01 00 00    	jne    803603 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803487:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80348b:	74 06                	je     803493 <insert_sorted_with_merge_freeList+0x530>
  80348d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803491:	75 17                	jne    8034aa <insert_sorted_with_merge_freeList+0x547>
  803493:	83 ec 04             	sub    $0x4,%esp
  803496:	68 94 45 80 00       	push   $0x804594
  80349b:	68 69 01 00 00       	push   $0x169
  8034a0:	68 7b 45 80 00       	push   $0x80457b
  8034a5:	e8 a0 d0 ff ff       	call   80054a <_panic>
  8034aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ad:	8b 50 04             	mov    0x4(%eax),%edx
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	89 50 04             	mov    %edx,0x4(%eax)
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034bc:	89 10                	mov    %edx,(%eax)
  8034be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c1:	8b 40 04             	mov    0x4(%eax),%eax
  8034c4:	85 c0                	test   %eax,%eax
  8034c6:	74 0d                	je     8034d5 <insert_sorted_with_merge_freeList+0x572>
  8034c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d1:	89 10                	mov    %edx,(%eax)
  8034d3:	eb 08                	jmp    8034dd <insert_sorted_with_merge_freeList+0x57a>
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8034dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e3:	89 50 04             	mov    %edx,0x4(%eax)
  8034e6:	a1 44 51 80 00       	mov    0x805144,%eax
  8034eb:	40                   	inc    %eax
  8034ec:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8034f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8034f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fd:	01 c2                	add    %eax,%edx
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803505:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803509:	75 17                	jne    803522 <insert_sorted_with_merge_freeList+0x5bf>
  80350b:	83 ec 04             	sub    $0x4,%esp
  80350e:	68 24 46 80 00       	push   $0x804624
  803513:	68 6b 01 00 00       	push   $0x16b
  803518:	68 7b 45 80 00       	push   $0x80457b
  80351d:	e8 28 d0 ff ff       	call   80054a <_panic>
  803522:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803525:	8b 00                	mov    (%eax),%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	74 10                	je     80353b <insert_sorted_with_merge_freeList+0x5d8>
  80352b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352e:	8b 00                	mov    (%eax),%eax
  803530:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803533:	8b 52 04             	mov    0x4(%edx),%edx
  803536:	89 50 04             	mov    %edx,0x4(%eax)
  803539:	eb 0b                	jmp    803546 <insert_sorted_with_merge_freeList+0x5e3>
  80353b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353e:	8b 40 04             	mov    0x4(%eax),%eax
  803541:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803546:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803549:	8b 40 04             	mov    0x4(%eax),%eax
  80354c:	85 c0                	test   %eax,%eax
  80354e:	74 0f                	je     80355f <insert_sorted_with_merge_freeList+0x5fc>
  803550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803553:	8b 40 04             	mov    0x4(%eax),%eax
  803556:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803559:	8b 12                	mov    (%edx),%edx
  80355b:	89 10                	mov    %edx,(%eax)
  80355d:	eb 0a                	jmp    803569 <insert_sorted_with_merge_freeList+0x606>
  80355f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803562:	8b 00                	mov    (%eax),%eax
  803564:	a3 38 51 80 00       	mov    %eax,0x805138
  803569:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803575:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357c:	a1 44 51 80 00       	mov    0x805144,%eax
  803581:	48                   	dec    %eax
  803582:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803591:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803594:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80359b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80359f:	75 17                	jne    8035b8 <insert_sorted_with_merge_freeList+0x655>
  8035a1:	83 ec 04             	sub    $0x4,%esp
  8035a4:	68 58 45 80 00       	push   $0x804558
  8035a9:	68 6e 01 00 00       	push   $0x16e
  8035ae:	68 7b 45 80 00       	push   $0x80457b
  8035b3:	e8 92 cf ff ff       	call   80054a <_panic>
  8035b8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c1:	89 10                	mov    %edx,(%eax)
  8035c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c6:	8b 00                	mov    (%eax),%eax
  8035c8:	85 c0                	test   %eax,%eax
  8035ca:	74 0d                	je     8035d9 <insert_sorted_with_merge_freeList+0x676>
  8035cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8035d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d4:	89 50 04             	mov    %edx,0x4(%eax)
  8035d7:	eb 08                	jmp    8035e1 <insert_sorted_with_merge_freeList+0x67e>
  8035d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e4:	a3 48 51 80 00       	mov    %eax,0x805148
  8035e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8035f8:	40                   	inc    %eax
  8035f9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035fe:	e9 a9 00 00 00       	jmp    8036ac <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803607:	74 06                	je     80360f <insert_sorted_with_merge_freeList+0x6ac>
  803609:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80360d:	75 17                	jne    803626 <insert_sorted_with_merge_freeList+0x6c3>
  80360f:	83 ec 04             	sub    $0x4,%esp
  803612:	68 f0 45 80 00       	push   $0x8045f0
  803617:	68 73 01 00 00       	push   $0x173
  80361c:	68 7b 45 80 00       	push   $0x80457b
  803621:	e8 24 cf ff ff       	call   80054a <_panic>
  803626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803629:	8b 10                	mov    (%eax),%edx
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	89 10                	mov    %edx,(%eax)
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	85 c0                	test   %eax,%eax
  803637:	74 0b                	je     803644 <insert_sorted_with_merge_freeList+0x6e1>
  803639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363c:	8b 00                	mov    (%eax),%eax
  80363e:	8b 55 08             	mov    0x8(%ebp),%edx
  803641:	89 50 04             	mov    %edx,0x4(%eax)
  803644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803647:	8b 55 08             	mov    0x8(%ebp),%edx
  80364a:	89 10                	mov    %edx,(%eax)
  80364c:	8b 45 08             	mov    0x8(%ebp),%eax
  80364f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803652:	89 50 04             	mov    %edx,0x4(%eax)
  803655:	8b 45 08             	mov    0x8(%ebp),%eax
  803658:	8b 00                	mov    (%eax),%eax
  80365a:	85 c0                	test   %eax,%eax
  80365c:	75 08                	jne    803666 <insert_sorted_with_merge_freeList+0x703>
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803666:	a1 44 51 80 00       	mov    0x805144,%eax
  80366b:	40                   	inc    %eax
  80366c:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803671:	eb 39                	jmp    8036ac <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803673:	a1 40 51 80 00       	mov    0x805140,%eax
  803678:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80367b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367f:	74 07                	je     803688 <insert_sorted_with_merge_freeList+0x725>
  803681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803684:	8b 00                	mov    (%eax),%eax
  803686:	eb 05                	jmp    80368d <insert_sorted_with_merge_freeList+0x72a>
  803688:	b8 00 00 00 00       	mov    $0x0,%eax
  80368d:	a3 40 51 80 00       	mov    %eax,0x805140
  803692:	a1 40 51 80 00       	mov    0x805140,%eax
  803697:	85 c0                	test   %eax,%eax
  803699:	0f 85 c7 fb ff ff    	jne    803266 <insert_sorted_with_merge_freeList+0x303>
  80369f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a3:	0f 85 bd fb ff ff    	jne    803266 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036a9:	eb 01                	jmp    8036ac <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036ab:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ac:	90                   	nop
  8036ad:	c9                   	leave  
  8036ae:	c3                   	ret    

008036af <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8036af:	55                   	push   %ebp
  8036b0:	89 e5                	mov    %esp,%ebp
  8036b2:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8036b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b8:	89 d0                	mov    %edx,%eax
  8036ba:	c1 e0 02             	shl    $0x2,%eax
  8036bd:	01 d0                	add    %edx,%eax
  8036bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036c6:	01 d0                	add    %edx,%eax
  8036c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036cf:	01 d0                	add    %edx,%eax
  8036d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036d8:	01 d0                	add    %edx,%eax
  8036da:	c1 e0 04             	shl    $0x4,%eax
  8036dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8036e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8036e7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8036ea:	83 ec 0c             	sub    $0xc,%esp
  8036ed:	50                   	push   %eax
  8036ee:	e8 26 e7 ff ff       	call   801e19 <sys_get_virtual_time>
  8036f3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8036f6:	eb 41                	jmp    803739 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8036f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8036fb:	83 ec 0c             	sub    $0xc,%esp
  8036fe:	50                   	push   %eax
  8036ff:	e8 15 e7 ff ff       	call   801e19 <sys_get_virtual_time>
  803704:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803707:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80370a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370d:	29 c2                	sub    %eax,%edx
  80370f:	89 d0                	mov    %edx,%eax
  803711:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803714:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371a:	89 d1                	mov    %edx,%ecx
  80371c:	29 c1                	sub    %eax,%ecx
  80371e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803721:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803724:	39 c2                	cmp    %eax,%edx
  803726:	0f 97 c0             	seta   %al
  803729:	0f b6 c0             	movzbl %al,%eax
  80372c:	29 c1                	sub    %eax,%ecx
  80372e:	89 c8                	mov    %ecx,%eax
  803730:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803733:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803736:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80373f:	72 b7                	jb     8036f8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803741:	90                   	nop
  803742:	c9                   	leave  
  803743:	c3                   	ret    

00803744 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803744:	55                   	push   %ebp
  803745:	89 e5                	mov    %esp,%ebp
  803747:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80374a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803751:	eb 03                	jmp    803756 <busy_wait+0x12>
  803753:	ff 45 fc             	incl   -0x4(%ebp)
  803756:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803759:	3b 45 08             	cmp    0x8(%ebp),%eax
  80375c:	72 f5                	jb     803753 <busy_wait+0xf>
	return i;
  80375e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803761:	c9                   	leave  
  803762:	c3                   	ret    
  803763:	90                   	nop

00803764 <__udivdi3>:
  803764:	55                   	push   %ebp
  803765:	57                   	push   %edi
  803766:	56                   	push   %esi
  803767:	53                   	push   %ebx
  803768:	83 ec 1c             	sub    $0x1c,%esp
  80376b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80376f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803773:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803777:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80377b:	89 ca                	mov    %ecx,%edx
  80377d:	89 f8                	mov    %edi,%eax
  80377f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803783:	85 f6                	test   %esi,%esi
  803785:	75 2d                	jne    8037b4 <__udivdi3+0x50>
  803787:	39 cf                	cmp    %ecx,%edi
  803789:	77 65                	ja     8037f0 <__udivdi3+0x8c>
  80378b:	89 fd                	mov    %edi,%ebp
  80378d:	85 ff                	test   %edi,%edi
  80378f:	75 0b                	jne    80379c <__udivdi3+0x38>
  803791:	b8 01 00 00 00       	mov    $0x1,%eax
  803796:	31 d2                	xor    %edx,%edx
  803798:	f7 f7                	div    %edi
  80379a:	89 c5                	mov    %eax,%ebp
  80379c:	31 d2                	xor    %edx,%edx
  80379e:	89 c8                	mov    %ecx,%eax
  8037a0:	f7 f5                	div    %ebp
  8037a2:	89 c1                	mov    %eax,%ecx
  8037a4:	89 d8                	mov    %ebx,%eax
  8037a6:	f7 f5                	div    %ebp
  8037a8:	89 cf                	mov    %ecx,%edi
  8037aa:	89 fa                	mov    %edi,%edx
  8037ac:	83 c4 1c             	add    $0x1c,%esp
  8037af:	5b                   	pop    %ebx
  8037b0:	5e                   	pop    %esi
  8037b1:	5f                   	pop    %edi
  8037b2:	5d                   	pop    %ebp
  8037b3:	c3                   	ret    
  8037b4:	39 ce                	cmp    %ecx,%esi
  8037b6:	77 28                	ja     8037e0 <__udivdi3+0x7c>
  8037b8:	0f bd fe             	bsr    %esi,%edi
  8037bb:	83 f7 1f             	xor    $0x1f,%edi
  8037be:	75 40                	jne    803800 <__udivdi3+0x9c>
  8037c0:	39 ce                	cmp    %ecx,%esi
  8037c2:	72 0a                	jb     8037ce <__udivdi3+0x6a>
  8037c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037c8:	0f 87 9e 00 00 00    	ja     80386c <__udivdi3+0x108>
  8037ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8037d3:	89 fa                	mov    %edi,%edx
  8037d5:	83 c4 1c             	add    $0x1c,%esp
  8037d8:	5b                   	pop    %ebx
  8037d9:	5e                   	pop    %esi
  8037da:	5f                   	pop    %edi
  8037db:	5d                   	pop    %ebp
  8037dc:	c3                   	ret    
  8037dd:	8d 76 00             	lea    0x0(%esi),%esi
  8037e0:	31 ff                	xor    %edi,%edi
  8037e2:	31 c0                	xor    %eax,%eax
  8037e4:	89 fa                	mov    %edi,%edx
  8037e6:	83 c4 1c             	add    $0x1c,%esp
  8037e9:	5b                   	pop    %ebx
  8037ea:	5e                   	pop    %esi
  8037eb:	5f                   	pop    %edi
  8037ec:	5d                   	pop    %ebp
  8037ed:	c3                   	ret    
  8037ee:	66 90                	xchg   %ax,%ax
  8037f0:	89 d8                	mov    %ebx,%eax
  8037f2:	f7 f7                	div    %edi
  8037f4:	31 ff                	xor    %edi,%edi
  8037f6:	89 fa                	mov    %edi,%edx
  8037f8:	83 c4 1c             	add    $0x1c,%esp
  8037fb:	5b                   	pop    %ebx
  8037fc:	5e                   	pop    %esi
  8037fd:	5f                   	pop    %edi
  8037fe:	5d                   	pop    %ebp
  8037ff:	c3                   	ret    
  803800:	bd 20 00 00 00       	mov    $0x20,%ebp
  803805:	89 eb                	mov    %ebp,%ebx
  803807:	29 fb                	sub    %edi,%ebx
  803809:	89 f9                	mov    %edi,%ecx
  80380b:	d3 e6                	shl    %cl,%esi
  80380d:	89 c5                	mov    %eax,%ebp
  80380f:	88 d9                	mov    %bl,%cl
  803811:	d3 ed                	shr    %cl,%ebp
  803813:	89 e9                	mov    %ebp,%ecx
  803815:	09 f1                	or     %esi,%ecx
  803817:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80381b:	89 f9                	mov    %edi,%ecx
  80381d:	d3 e0                	shl    %cl,%eax
  80381f:	89 c5                	mov    %eax,%ebp
  803821:	89 d6                	mov    %edx,%esi
  803823:	88 d9                	mov    %bl,%cl
  803825:	d3 ee                	shr    %cl,%esi
  803827:	89 f9                	mov    %edi,%ecx
  803829:	d3 e2                	shl    %cl,%edx
  80382b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80382f:	88 d9                	mov    %bl,%cl
  803831:	d3 e8                	shr    %cl,%eax
  803833:	09 c2                	or     %eax,%edx
  803835:	89 d0                	mov    %edx,%eax
  803837:	89 f2                	mov    %esi,%edx
  803839:	f7 74 24 0c          	divl   0xc(%esp)
  80383d:	89 d6                	mov    %edx,%esi
  80383f:	89 c3                	mov    %eax,%ebx
  803841:	f7 e5                	mul    %ebp
  803843:	39 d6                	cmp    %edx,%esi
  803845:	72 19                	jb     803860 <__udivdi3+0xfc>
  803847:	74 0b                	je     803854 <__udivdi3+0xf0>
  803849:	89 d8                	mov    %ebx,%eax
  80384b:	31 ff                	xor    %edi,%edi
  80384d:	e9 58 ff ff ff       	jmp    8037aa <__udivdi3+0x46>
  803852:	66 90                	xchg   %ax,%ax
  803854:	8b 54 24 08          	mov    0x8(%esp),%edx
  803858:	89 f9                	mov    %edi,%ecx
  80385a:	d3 e2                	shl    %cl,%edx
  80385c:	39 c2                	cmp    %eax,%edx
  80385e:	73 e9                	jae    803849 <__udivdi3+0xe5>
  803860:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803863:	31 ff                	xor    %edi,%edi
  803865:	e9 40 ff ff ff       	jmp    8037aa <__udivdi3+0x46>
  80386a:	66 90                	xchg   %ax,%ax
  80386c:	31 c0                	xor    %eax,%eax
  80386e:	e9 37 ff ff ff       	jmp    8037aa <__udivdi3+0x46>
  803873:	90                   	nop

00803874 <__umoddi3>:
  803874:	55                   	push   %ebp
  803875:	57                   	push   %edi
  803876:	56                   	push   %esi
  803877:	53                   	push   %ebx
  803878:	83 ec 1c             	sub    $0x1c,%esp
  80387b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80387f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803883:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803887:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80388b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80388f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803893:	89 f3                	mov    %esi,%ebx
  803895:	89 fa                	mov    %edi,%edx
  803897:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80389b:	89 34 24             	mov    %esi,(%esp)
  80389e:	85 c0                	test   %eax,%eax
  8038a0:	75 1a                	jne    8038bc <__umoddi3+0x48>
  8038a2:	39 f7                	cmp    %esi,%edi
  8038a4:	0f 86 a2 00 00 00    	jbe    80394c <__umoddi3+0xd8>
  8038aa:	89 c8                	mov    %ecx,%eax
  8038ac:	89 f2                	mov    %esi,%edx
  8038ae:	f7 f7                	div    %edi
  8038b0:	89 d0                	mov    %edx,%eax
  8038b2:	31 d2                	xor    %edx,%edx
  8038b4:	83 c4 1c             	add    $0x1c,%esp
  8038b7:	5b                   	pop    %ebx
  8038b8:	5e                   	pop    %esi
  8038b9:	5f                   	pop    %edi
  8038ba:	5d                   	pop    %ebp
  8038bb:	c3                   	ret    
  8038bc:	39 f0                	cmp    %esi,%eax
  8038be:	0f 87 ac 00 00 00    	ja     803970 <__umoddi3+0xfc>
  8038c4:	0f bd e8             	bsr    %eax,%ebp
  8038c7:	83 f5 1f             	xor    $0x1f,%ebp
  8038ca:	0f 84 ac 00 00 00    	je     80397c <__umoddi3+0x108>
  8038d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8038d5:	29 ef                	sub    %ebp,%edi
  8038d7:	89 fe                	mov    %edi,%esi
  8038d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038dd:	89 e9                	mov    %ebp,%ecx
  8038df:	d3 e0                	shl    %cl,%eax
  8038e1:	89 d7                	mov    %edx,%edi
  8038e3:	89 f1                	mov    %esi,%ecx
  8038e5:	d3 ef                	shr    %cl,%edi
  8038e7:	09 c7                	or     %eax,%edi
  8038e9:	89 e9                	mov    %ebp,%ecx
  8038eb:	d3 e2                	shl    %cl,%edx
  8038ed:	89 14 24             	mov    %edx,(%esp)
  8038f0:	89 d8                	mov    %ebx,%eax
  8038f2:	d3 e0                	shl    %cl,%eax
  8038f4:	89 c2                	mov    %eax,%edx
  8038f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038fa:	d3 e0                	shl    %cl,%eax
  8038fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803900:	8b 44 24 08          	mov    0x8(%esp),%eax
  803904:	89 f1                	mov    %esi,%ecx
  803906:	d3 e8                	shr    %cl,%eax
  803908:	09 d0                	or     %edx,%eax
  80390a:	d3 eb                	shr    %cl,%ebx
  80390c:	89 da                	mov    %ebx,%edx
  80390e:	f7 f7                	div    %edi
  803910:	89 d3                	mov    %edx,%ebx
  803912:	f7 24 24             	mull   (%esp)
  803915:	89 c6                	mov    %eax,%esi
  803917:	89 d1                	mov    %edx,%ecx
  803919:	39 d3                	cmp    %edx,%ebx
  80391b:	0f 82 87 00 00 00    	jb     8039a8 <__umoddi3+0x134>
  803921:	0f 84 91 00 00 00    	je     8039b8 <__umoddi3+0x144>
  803927:	8b 54 24 04          	mov    0x4(%esp),%edx
  80392b:	29 f2                	sub    %esi,%edx
  80392d:	19 cb                	sbb    %ecx,%ebx
  80392f:	89 d8                	mov    %ebx,%eax
  803931:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803935:	d3 e0                	shl    %cl,%eax
  803937:	89 e9                	mov    %ebp,%ecx
  803939:	d3 ea                	shr    %cl,%edx
  80393b:	09 d0                	or     %edx,%eax
  80393d:	89 e9                	mov    %ebp,%ecx
  80393f:	d3 eb                	shr    %cl,%ebx
  803941:	89 da                	mov    %ebx,%edx
  803943:	83 c4 1c             	add    $0x1c,%esp
  803946:	5b                   	pop    %ebx
  803947:	5e                   	pop    %esi
  803948:	5f                   	pop    %edi
  803949:	5d                   	pop    %ebp
  80394a:	c3                   	ret    
  80394b:	90                   	nop
  80394c:	89 fd                	mov    %edi,%ebp
  80394e:	85 ff                	test   %edi,%edi
  803950:	75 0b                	jne    80395d <__umoddi3+0xe9>
  803952:	b8 01 00 00 00       	mov    $0x1,%eax
  803957:	31 d2                	xor    %edx,%edx
  803959:	f7 f7                	div    %edi
  80395b:	89 c5                	mov    %eax,%ebp
  80395d:	89 f0                	mov    %esi,%eax
  80395f:	31 d2                	xor    %edx,%edx
  803961:	f7 f5                	div    %ebp
  803963:	89 c8                	mov    %ecx,%eax
  803965:	f7 f5                	div    %ebp
  803967:	89 d0                	mov    %edx,%eax
  803969:	e9 44 ff ff ff       	jmp    8038b2 <__umoddi3+0x3e>
  80396e:	66 90                	xchg   %ax,%ax
  803970:	89 c8                	mov    %ecx,%eax
  803972:	89 f2                	mov    %esi,%edx
  803974:	83 c4 1c             	add    $0x1c,%esp
  803977:	5b                   	pop    %ebx
  803978:	5e                   	pop    %esi
  803979:	5f                   	pop    %edi
  80397a:	5d                   	pop    %ebp
  80397b:	c3                   	ret    
  80397c:	3b 04 24             	cmp    (%esp),%eax
  80397f:	72 06                	jb     803987 <__umoddi3+0x113>
  803981:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803985:	77 0f                	ja     803996 <__umoddi3+0x122>
  803987:	89 f2                	mov    %esi,%edx
  803989:	29 f9                	sub    %edi,%ecx
  80398b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80398f:	89 14 24             	mov    %edx,(%esp)
  803992:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803996:	8b 44 24 04          	mov    0x4(%esp),%eax
  80399a:	8b 14 24             	mov    (%esp),%edx
  80399d:	83 c4 1c             	add    $0x1c,%esp
  8039a0:	5b                   	pop    %ebx
  8039a1:	5e                   	pop    %esi
  8039a2:	5f                   	pop    %edi
  8039a3:	5d                   	pop    %ebp
  8039a4:	c3                   	ret    
  8039a5:	8d 76 00             	lea    0x0(%esi),%esi
  8039a8:	2b 04 24             	sub    (%esp),%eax
  8039ab:	19 fa                	sbb    %edi,%edx
  8039ad:	89 d1                	mov    %edx,%ecx
  8039af:	89 c6                	mov    %eax,%esi
  8039b1:	e9 71 ff ff ff       	jmp    803927 <__umoddi3+0xb3>
  8039b6:	66 90                	xchg   %ax,%ax
  8039b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039bc:	72 ea                	jb     8039a8 <__umoddi3+0x134>
  8039be:	89 d9                	mov    %ebx,%ecx
  8039c0:	e9 62 ff ff ff       	jmp    803927 <__umoddi3+0xb3>
