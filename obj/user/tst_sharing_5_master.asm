
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
  80008d:	68 00 39 80 00       	push   $0x803900
  800092:	6a 12                	push   $0x12
  800094:	68 1c 39 80 00       	push   $0x80391c
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
  8000ae:	68 38 39 80 00       	push   $0x803938
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 6c 39 80 00       	push   $0x80396c
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 c8 39 80 00       	push   $0x8039c8
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 f5 1b 00 00       	call   801cd5 <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 fc 39 80 00       	push   $0x8039fc
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
  80011d:	68 3d 3a 80 00       	push   $0x803a3d
  800122:	e8 59 1b 00 00       	call   801c80 <sys_create_env>
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
  800150:	68 3d 3a 80 00       	push   $0x803a3d
  800155:	e8 26 1b 00 00       	call   801c80 <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 a9 18 00 00       	call   801a0e <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 48 3a 80 00       	push   $0x803a48
  800177:	e8 52 16 00 00       	call   8017ce <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 4c 3a 80 00       	push   $0x803a4c
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 6c 3a 80 00       	push   $0x803a6c
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 1c 39 80 00       	push   $0x80391c
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 57 18 00 00       	call   801a0e <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 d8 3a 80 00       	push   $0x803ad8
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 1c 39 80 00       	push   $0x80391c
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 f3 1b 00 00       	call   801dcc <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 ba 1a 00 00       	call   801c9e <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 ac 1a 00 00       	call   801c9e <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 56 3b 80 00       	push   $0x803b56
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 be 33 00 00       	call   8035d0 <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 2b 1c 00 00       	call   801e46 <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 e9 17 00 00       	call   801a0e <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 7b 16 00 00       	call   8018ae <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 70 3b 80 00       	push   $0x803b70
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 c3 17 00 00       	call   801a0e <sys_calculate_free_frames>
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
  80026f:	68 90 3b 80 00       	push   $0x803b90
  800274:	6a 3b                	push   $0x3b
  800276:	68 1c 39 80 00       	push   $0x80391c
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 d8 3b 80 00       	push   $0x803bd8
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 fc 3b 80 00       	push   $0x803bfc
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
  8002c3:	68 2c 3c 80 00       	push   $0x803c2c
  8002c8:	e8 b3 19 00 00       	call   801c80 <sys_create_env>
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
  8002f6:	68 39 3c 80 00       	push   $0x803c39
  8002fb:	e8 80 19 00 00       	call   801c80 <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 46 3c 80 00       	push   $0x803c46
  800315:	e8 b4 14 00 00       	call   8017ce <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 48 3c 80 00       	push   $0x803c48
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 48 3a 80 00       	push   $0x803a48
  80033f:	e8 8a 14 00 00       	call   8017ce <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 4c 3a 80 00       	push   $0x803a4c
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 6d 1a 00 00       	call   801dcc <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 34 19 00 00       	call   801c9e <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 26 19 00 00       	call   801c9e <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 c5 1a 00 00       	call   801e46 <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 41 1a 00 00       	call   801dcc <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 7e 16 00 00       	call   801a0e <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 10 15 00 00       	call   8018ae <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 68 3c 80 00       	push   $0x803c68
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 f2 14 00 00       	call   8018ae <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 7e 3c 80 00       	push   $0x803c7e
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 3a 16 00 00       	call   801a0e <sys_calculate_free_frames>
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
  8003f2:	68 94 3c 80 00       	push   $0x803c94
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 1c 39 80 00       	push   $0x80391c
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 24 1a 00 00       	call   801e2c <inctst>


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
  800414:	e8 d5 18 00 00       	call   801cee <sys_getenvindex>
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
  80047f:	e8 77 16 00 00       	call   801afb <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 54 3d 80 00       	push   $0x803d54
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
  8004af:	68 7c 3d 80 00       	push   $0x803d7c
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
  8004e0:	68 a4 3d 80 00       	push   $0x803da4
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 fc 3d 80 00       	push   $0x803dfc
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 54 3d 80 00       	push   $0x803d54
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 f7 15 00 00       	call   801b15 <sys_enable_interrupt>

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
  800531:	e8 84 17 00 00       	call   801cba <sys_destroy_env>
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
  800542:	e8 d9 17 00 00       	call   801d20 <sys_exit_env>
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
  80056b:	68 10 3e 80 00       	push   $0x803e10
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 15 3e 80 00       	push   $0x803e15
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
  8005a8:	68 31 3e 80 00       	push   $0x803e31
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
  8005d4:	68 34 3e 80 00       	push   $0x803e34
  8005d9:	6a 26                	push   $0x26
  8005db:	68 80 3e 80 00       	push   $0x803e80
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
  8006a6:	68 8c 3e 80 00       	push   $0x803e8c
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 80 3e 80 00       	push   $0x803e80
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
  800716:	68 e0 3e 80 00       	push   $0x803ee0
  80071b:	6a 44                	push   $0x44
  80071d:	68 80 3e 80 00       	push   $0x803e80
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
  800770:	e8 d8 11 00 00       	call   80194d <sys_cputs>
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
  8007e7:	e8 61 11 00 00       	call   80194d <sys_cputs>
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
  800831:	e8 c5 12 00 00       	call   801afb <sys_disable_interrupt>
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
  800851:	e8 bf 12 00 00       	call   801b15 <sys_enable_interrupt>
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
  80089b:	e8 e4 2d 00 00       	call   803684 <__udivdi3>
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
  8008eb:	e8 a4 2e 00 00       	call   803794 <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 54 41 80 00       	add    $0x804154,%eax
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
  800a46:	8b 04 85 78 41 80 00 	mov    0x804178(,%eax,4),%eax
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
  800b27:	8b 34 9d c0 3f 80 00 	mov    0x803fc0(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 65 41 80 00       	push   $0x804165
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
  800b4c:	68 6e 41 80 00       	push   $0x80416e
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
  800b79:	be 71 41 80 00       	mov    $0x804171,%esi
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
  80159f:	68 d0 42 80 00       	push   $0x8042d0
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
  80166f:	e8 1d 04 00 00       	call   801a91 <sys_allocate_chunk>
  801674:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801677:	a1 20 51 80 00       	mov    0x805120,%eax
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	50                   	push   %eax
  801680:	e8 92 0a 00 00       	call   802117 <initialize_MemBlocksList>
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
  8016ad:	68 f5 42 80 00       	push   $0x8042f5
  8016b2:	6a 33                	push   $0x33
  8016b4:	68 13 43 80 00       	push   $0x804313
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
  80172c:	68 20 43 80 00       	push   $0x804320
  801731:	6a 34                	push   $0x34
  801733:	68 13 43 80 00       	push   $0x804313
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
  8017a1:	68 44 43 80 00       	push   $0x804344
  8017a6:	6a 46                	push   $0x46
  8017a8:	68 13 43 80 00       	push   $0x804313
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
  8017bd:	68 6c 43 80 00       	push   $0x80436c
  8017c2:	6a 61                	push   $0x61
  8017c4:	68 13 43 80 00       	push   $0x804313
  8017c9:	e8 7c ed ff ff       	call   80054a <_panic>

008017ce <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 38             	sub    $0x38,%esp
  8017d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017da:	e8 a9 fd ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e3:	75 07                	jne    8017ec <smalloc+0x1e>
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ea:	eb 7c                	jmp    801868 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017ec:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f9:	01 d0                	add    %edx,%eax
  8017fb:	48                   	dec    %eax
  8017fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801802:	ba 00 00 00 00       	mov    $0x0,%edx
  801807:	f7 75 f0             	divl   -0x10(%ebp)
  80180a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180d:	29 d0                	sub    %edx,%eax
  80180f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801812:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801819:	e8 41 06 00 00       	call   801e5f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80181e:	85 c0                	test   %eax,%eax
  801820:	74 11                	je     801833 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801822:	83 ec 0c             	sub    $0xc,%esp
  801825:	ff 75 e8             	pushl  -0x18(%ebp)
  801828:	e8 ac 0c 00 00       	call   8024d9 <alloc_block_FF>
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801833:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801837:	74 2a                	je     801863 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183c:	8b 40 08             	mov    0x8(%eax),%eax
  80183f:	89 c2                	mov    %eax,%edx
  801841:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801845:	52                   	push   %edx
  801846:	50                   	push   %eax
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	ff 75 08             	pushl  0x8(%ebp)
  80184d:	e8 92 03 00 00       	call   801be4 <sys_createSharedObject>
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801858:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80185c:	74 05                	je     801863 <smalloc+0x95>
			return (void*)virtual_address;
  80185e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801861:	eb 05                	jmp    801868 <smalloc+0x9a>
	}
	return NULL;
  801863:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801870:	e8 13 fd ff ff       	call   801588 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	68 90 43 80 00       	push   $0x804390
  80187d:	68 a2 00 00 00       	push   $0xa2
  801882:	68 13 43 80 00       	push   $0x804313
  801887:	e8 be ec ff ff       	call   80054a <_panic>

0080188c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801892:	e8 f1 fc ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	68 b4 43 80 00       	push   $0x8043b4
  80189f:	68 e6 00 00 00       	push   $0xe6
  8018a4:	68 13 43 80 00       	push   $0x804313
  8018a9:	e8 9c ec ff ff       	call   80054a <_panic>

008018ae <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	68 dc 43 80 00       	push   $0x8043dc
  8018bc:	68 fa 00 00 00       	push   $0xfa
  8018c1:	68 13 43 80 00       	push   $0x804313
  8018c6:	e8 7f ec ff ff       	call   80054a <_panic>

008018cb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	68 00 44 80 00       	push   $0x804400
  8018d9:	68 05 01 00 00       	push   $0x105
  8018de:	68 13 43 80 00       	push   $0x804313
  8018e3:	e8 62 ec ff ff       	call   80054a <_panic>

008018e8 <shrink>:

}
void shrink(uint32 newSize)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	68 00 44 80 00       	push   $0x804400
  8018f6:	68 0a 01 00 00       	push   $0x10a
  8018fb:	68 13 43 80 00       	push   $0x804313
  801900:	e8 45 ec ff ff       	call   80054a <_panic>

00801905 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80190b:	83 ec 04             	sub    $0x4,%esp
  80190e:	68 00 44 80 00       	push   $0x804400
  801913:	68 0f 01 00 00       	push   $0x10f
  801918:	68 13 43 80 00       	push   $0x804313
  80191d:	e8 28 ec ff ff       	call   80054a <_panic>

00801922 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	57                   	push   %edi
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
  801928:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801931:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801934:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801937:	8b 7d 18             	mov    0x18(%ebp),%edi
  80193a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80193d:	cd 30                	int    $0x30
  80193f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801942:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	5b                   	pop    %ebx
  801949:	5e                   	pop    %esi
  80194a:	5f                   	pop    %edi
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	8b 45 10             	mov    0x10(%ebp),%eax
  801956:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801959:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	52                   	push   %edx
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	50                   	push   %eax
  801969:	6a 00                	push   $0x0
  80196b:	e8 b2 ff ff ff       	call   801922 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	90                   	nop
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_cgetc>:

int
sys_cgetc(void)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 01                	push   $0x1
  801985:	e8 98 ff ff ff       	call   801922 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801992:	8b 55 0c             	mov    0xc(%ebp),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	52                   	push   %edx
  80199f:	50                   	push   %eax
  8019a0:	6a 05                	push   $0x5
  8019a2:	e8 7b ff ff ff       	call   801922 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	56                   	push   %esi
  8019b0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8019b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	56                   	push   %esi
  8019c1:	53                   	push   %ebx
  8019c2:	51                   	push   %ecx
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 06                	push   $0x6
  8019c7:	e8 56 ff ff ff       	call   801922 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d2:	5b                   	pop    %ebx
  8019d3:	5e                   	pop    %esi
  8019d4:	5d                   	pop    %ebp
  8019d5:	c3                   	ret    

008019d6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	52                   	push   %edx
  8019e6:	50                   	push   %eax
  8019e7:	6a 07                	push   $0x7
  8019e9:	e8 34 ff ff ff       	call   801922 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	6a 08                	push   $0x8
  801a04:	e8 19 ff ff ff       	call   801922 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 09                	push   $0x9
  801a1d:	e8 00 ff ff ff       	call   801922 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 0a                	push   $0xa
  801a36:	e8 e7 fe ff ff       	call   801922 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 0b                	push   $0xb
  801a4f:	e8 ce fe ff ff       	call   801922 <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	ff 75 08             	pushl  0x8(%ebp)
  801a68:	6a 0f                	push   $0xf
  801a6a:	e8 b3 fe ff ff       	call   801922 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
	return;
  801a72:	90                   	nop
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	ff 75 0c             	pushl  0xc(%ebp)
  801a81:	ff 75 08             	pushl  0x8(%ebp)
  801a84:	6a 10                	push   $0x10
  801a86:	e8 97 fe ff ff       	call   801922 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8e:	90                   	nop
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	ff 75 10             	pushl  0x10(%ebp)
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	6a 11                	push   $0x11
  801aa3:	e8 7a fe ff ff       	call   801922 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
	return ;
  801aab:	90                   	nop
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 0c                	push   $0xc
  801abd:	e8 60 fe ff ff       	call   801922 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	ff 75 08             	pushl  0x8(%ebp)
  801ad5:	6a 0d                	push   $0xd
  801ad7:	e8 46 fe ff ff       	call   801922 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 0e                	push   $0xe
  801af0:	e8 2d fe ff ff       	call   801922 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	90                   	nop
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 13                	push   $0x13
  801b0a:	e8 13 fe ff ff       	call   801922 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	90                   	nop
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 14                	push   $0x14
  801b24:	e8 f9 fd ff ff       	call   801922 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	90                   	nop
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_cputc>:


void
sys_cputc(const char c)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 04             	sub    $0x4,%esp
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b3b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	50                   	push   %eax
  801b48:	6a 15                	push   $0x15
  801b4a:	e8 d3 fd ff ff       	call   801922 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	90                   	nop
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 16                	push   $0x16
  801b64:	e8 b9 fd ff ff       	call   801922 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	50                   	push   %eax
  801b7f:	6a 17                	push   $0x17
  801b81:	e8 9c fd ff ff       	call   801922 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	52                   	push   %edx
  801b9b:	50                   	push   %eax
  801b9c:	6a 1a                	push   $0x1a
  801b9e:	e8 7f fd ff ff       	call   801922 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 18                	push   $0x18
  801bbb:	e8 62 fd ff ff       	call   801922 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	90                   	nop
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	52                   	push   %edx
  801bd6:	50                   	push   %eax
  801bd7:	6a 19                	push   $0x19
  801bd9:	e8 44 fd ff ff       	call   801922 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	90                   	nop
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 04             	sub    $0x4,%esp
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bf0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bf3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	6a 00                	push   $0x0
  801bfc:	51                   	push   %ecx
  801bfd:	52                   	push   %edx
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	50                   	push   %eax
  801c02:	6a 1b                	push   $0x1b
  801c04:	e8 19 fd ff ff       	call   801922 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	52                   	push   %edx
  801c1e:	50                   	push   %eax
  801c1f:	6a 1c                	push   $0x1c
  801c21:	e8 fc fc ff ff       	call   801922 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	51                   	push   %ecx
  801c3c:	52                   	push   %edx
  801c3d:	50                   	push   %eax
  801c3e:	6a 1d                	push   $0x1d
  801c40:	e8 dd fc ff ff       	call   801922 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	52                   	push   %edx
  801c5a:	50                   	push   %eax
  801c5b:	6a 1e                	push   $0x1e
  801c5d:	e8 c0 fc ff ff       	call   801922 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 1f                	push   $0x1f
  801c76:	e8 a7 fc ff ff       	call   801922 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	ff 75 14             	pushl  0x14(%ebp)
  801c8b:	ff 75 10             	pushl  0x10(%ebp)
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	50                   	push   %eax
  801c92:	6a 20                	push   $0x20
  801c94:	e8 89 fc ff ff       	call   801922 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	50                   	push   %eax
  801cad:	6a 21                	push   $0x21
  801caf:	e8 6e fc ff ff       	call   801922 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	90                   	nop
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	50                   	push   %eax
  801cc9:	6a 22                	push   $0x22
  801ccb:	e8 52 fc ff ff       	call   801922 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 02                	push   $0x2
  801ce4:	e8 39 fc ff ff       	call   801922 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 03                	push   $0x3
  801cfd:	e8 20 fc ff ff       	call   801922 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 04                	push   $0x4
  801d16:	e8 07 fc ff ff       	call   801922 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_exit_env>:


void sys_exit_env(void)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 23                	push   $0x23
  801d2f:	e8 ee fb ff ff       	call   801922 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	90                   	nop
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d40:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d43:	8d 50 04             	lea    0x4(%eax),%edx
  801d46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	52                   	push   %edx
  801d50:	50                   	push   %eax
  801d51:	6a 24                	push   $0x24
  801d53:	e8 ca fb ff ff       	call   801922 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
	return result;
  801d5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d64:	89 01                	mov    %eax,(%ecx)
  801d66:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	c9                   	leave  
  801d6d:	c2 04 00             	ret    $0x4

00801d70 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	ff 75 10             	pushl  0x10(%ebp)
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	ff 75 08             	pushl  0x8(%ebp)
  801d80:	6a 12                	push   $0x12
  801d82:	e8 9b fb ff ff       	call   801922 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8a:	90                   	nop
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_rcr2>:
uint32 sys_rcr2()
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 25                	push   $0x25
  801d9c:	e8 81 fb ff ff       	call   801922 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 04             	sub    $0x4,%esp
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801db2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	50                   	push   %eax
  801dbf:	6a 26                	push   $0x26
  801dc1:	e8 5c fb ff ff       	call   801922 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc9:	90                   	nop
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <rsttst>:
void rsttst()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 28                	push   $0x28
  801ddb:	e8 42 fb ff ff       	call   801922 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
	return ;
  801de3:	90                   	nop
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 04             	sub    $0x4,%esp
  801dec:	8b 45 14             	mov    0x14(%ebp),%eax
  801def:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801df2:	8b 55 18             	mov    0x18(%ebp),%edx
  801df5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df9:	52                   	push   %edx
  801dfa:	50                   	push   %eax
  801dfb:	ff 75 10             	pushl  0x10(%ebp)
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	ff 75 08             	pushl  0x8(%ebp)
  801e04:	6a 27                	push   $0x27
  801e06:	e8 17 fb ff ff       	call   801922 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0e:	90                   	nop
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <chktst>:
void chktst(uint32 n)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	ff 75 08             	pushl  0x8(%ebp)
  801e1f:	6a 29                	push   $0x29
  801e21:	e8 fc fa ff ff       	call   801922 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
	return ;
  801e29:	90                   	nop
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <inctst>:

void inctst()
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 2a                	push   $0x2a
  801e3b:	e8 e2 fa ff ff       	call   801922 <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
	return ;
  801e43:	90                   	nop
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <gettst>:
uint32 gettst()
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 2b                	push   $0x2b
  801e55:	e8 c8 fa ff ff       	call   801922 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 2c                	push   $0x2c
  801e71:	e8 ac fa ff ff       	call   801922 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
  801e79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e7c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e80:	75 07                	jne    801e89 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e82:	b8 01 00 00 00       	mov    $0x1,%eax
  801e87:	eb 05                	jmp    801e8e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 2c                	push   $0x2c
  801ea2:	e8 7b fa ff ff       	call   801922 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
  801eaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ead:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eb1:	75 07                	jne    801eba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb8:	eb 05                	jmp    801ebf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 2c                	push   $0x2c
  801ed3:	e8 4a fa ff ff       	call   801922 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
  801edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ede:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ee2:	75 07                	jne    801eeb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ee4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee9:	eb 05                	jmp    801ef0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 2c                	push   $0x2c
  801f04:	e8 19 fa ff ff       	call   801922 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
  801f0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f0f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f13:	75 07                	jne    801f1c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f15:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1a:	eb 05                	jmp    801f21 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 08             	pushl  0x8(%ebp)
  801f31:	6a 2d                	push   $0x2d
  801f33:	e8 ea f9 ff ff       	call   801922 <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3b:	90                   	nop
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	6a 00                	push   $0x0
  801f50:	53                   	push   %ebx
  801f51:	51                   	push   %ecx
  801f52:	52                   	push   %edx
  801f53:	50                   	push   %eax
  801f54:	6a 2e                	push   $0x2e
  801f56:	e8 c7 f9 ff ff       	call   801922 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
}
  801f5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	52                   	push   %edx
  801f73:	50                   	push   %eax
  801f74:	6a 2f                	push   $0x2f
  801f76:	e8 a7 f9 ff ff       	call   801922 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f86:	83 ec 0c             	sub    $0xc,%esp
  801f89:	68 10 44 80 00       	push   $0x804410
  801f8e:	e8 6b e8 ff ff       	call   8007fe <cprintf>
  801f93:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f9d:	83 ec 0c             	sub    $0xc,%esp
  801fa0:	68 3c 44 80 00       	push   $0x80443c
  801fa5:	e8 54 e8 ff ff       	call   8007fe <cprintf>
  801faa:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fad:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fb1:	a1 38 51 80 00       	mov    0x805138,%eax
  801fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb9:	eb 56                	jmp    802011 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fbf:	74 1c                	je     801fdd <print_mem_block_lists+0x5d>
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	8b 50 08             	mov    0x8(%eax),%edx
  801fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fca:	8b 48 08             	mov    0x8(%eax),%ecx
  801fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd3:	01 c8                	add    %ecx,%eax
  801fd5:	39 c2                	cmp    %eax,%edx
  801fd7:	73 04                	jae    801fdd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fd9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe0:	8b 50 08             	mov    0x8(%eax),%edx
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe9:	01 c2                	add    %eax,%edx
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 40 08             	mov    0x8(%eax),%eax
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	52                   	push   %edx
  801ff5:	50                   	push   %eax
  801ff6:	68 51 44 80 00       	push   $0x804451
  801ffb:	e8 fe e7 ff ff       	call   8007fe <cprintf>
  802000:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802009:	a1 40 51 80 00       	mov    0x805140,%eax
  80200e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802011:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802015:	74 07                	je     80201e <print_mem_block_lists+0x9e>
  802017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201a:	8b 00                	mov    (%eax),%eax
  80201c:	eb 05                	jmp    802023 <print_mem_block_lists+0xa3>
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	a3 40 51 80 00       	mov    %eax,0x805140
  802028:	a1 40 51 80 00       	mov    0x805140,%eax
  80202d:	85 c0                	test   %eax,%eax
  80202f:	75 8a                	jne    801fbb <print_mem_block_lists+0x3b>
  802031:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802035:	75 84                	jne    801fbb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802037:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80203b:	75 10                	jne    80204d <print_mem_block_lists+0xcd>
  80203d:	83 ec 0c             	sub    $0xc,%esp
  802040:	68 60 44 80 00       	push   $0x804460
  802045:	e8 b4 e7 ff ff       	call   8007fe <cprintf>
  80204a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80204d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802054:	83 ec 0c             	sub    $0xc,%esp
  802057:	68 84 44 80 00       	push   $0x804484
  80205c:	e8 9d e7 ff ff       	call   8007fe <cprintf>
  802061:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802064:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802068:	a1 40 50 80 00       	mov    0x805040,%eax
  80206d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802070:	eb 56                	jmp    8020c8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802072:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802076:	74 1c                	je     802094 <print_mem_block_lists+0x114>
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 50 08             	mov    0x8(%eax),%edx
  80207e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802081:	8b 48 08             	mov    0x8(%eax),%ecx
  802084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802087:	8b 40 0c             	mov    0xc(%eax),%eax
  80208a:	01 c8                	add    %ecx,%eax
  80208c:	39 c2                	cmp    %eax,%edx
  80208e:	73 04                	jae    802094 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802090:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802097:	8b 50 08             	mov    0x8(%eax),%edx
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a0:	01 c2                	add    %eax,%edx
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	8b 40 08             	mov    0x8(%eax),%eax
  8020a8:	83 ec 04             	sub    $0x4,%esp
  8020ab:	52                   	push   %edx
  8020ac:	50                   	push   %eax
  8020ad:	68 51 44 80 00       	push   $0x804451
  8020b2:	e8 47 e7 ff ff       	call   8007fe <cprintf>
  8020b7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020c0:	a1 48 50 80 00       	mov    0x805048,%eax
  8020c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020cc:	74 07                	je     8020d5 <print_mem_block_lists+0x155>
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	8b 00                	mov    (%eax),%eax
  8020d3:	eb 05                	jmp    8020da <print_mem_block_lists+0x15a>
  8020d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020da:	a3 48 50 80 00       	mov    %eax,0x805048
  8020df:	a1 48 50 80 00       	mov    0x805048,%eax
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	75 8a                	jne    802072 <print_mem_block_lists+0xf2>
  8020e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ec:	75 84                	jne    802072 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020ee:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020f2:	75 10                	jne    802104 <print_mem_block_lists+0x184>
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	68 9c 44 80 00       	push   $0x80449c
  8020fc:	e8 fd e6 ff ff       	call   8007fe <cprintf>
  802101:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	68 10 44 80 00       	push   $0x804410
  80210c:	e8 ed e6 ff ff       	call   8007fe <cprintf>
  802111:	83 c4 10             	add    $0x10,%esp

}
  802114:	90                   	nop
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80211d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802124:	00 00 00 
  802127:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80212e:	00 00 00 
  802131:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802138:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80213b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802142:	e9 9e 00 00 00       	jmp    8021e5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802147:	a1 50 50 80 00       	mov    0x805050,%eax
  80214c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214f:	c1 e2 04             	shl    $0x4,%edx
  802152:	01 d0                	add    %edx,%eax
  802154:	85 c0                	test   %eax,%eax
  802156:	75 14                	jne    80216c <initialize_MemBlocksList+0x55>
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	68 c4 44 80 00       	push   $0x8044c4
  802160:	6a 46                	push   $0x46
  802162:	68 e7 44 80 00       	push   $0x8044e7
  802167:	e8 de e3 ff ff       	call   80054a <_panic>
  80216c:	a1 50 50 80 00       	mov    0x805050,%eax
  802171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802174:	c1 e2 04             	shl    $0x4,%edx
  802177:	01 d0                	add    %edx,%eax
  802179:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80217f:	89 10                	mov    %edx,(%eax)
  802181:	8b 00                	mov    (%eax),%eax
  802183:	85 c0                	test   %eax,%eax
  802185:	74 18                	je     80219f <initialize_MemBlocksList+0x88>
  802187:	a1 48 51 80 00       	mov    0x805148,%eax
  80218c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802192:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802195:	c1 e1 04             	shl    $0x4,%ecx
  802198:	01 ca                	add    %ecx,%edx
  80219a:	89 50 04             	mov    %edx,0x4(%eax)
  80219d:	eb 12                	jmp    8021b1 <initialize_MemBlocksList+0x9a>
  80219f:	a1 50 50 80 00       	mov    0x805050,%eax
  8021a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a7:	c1 e2 04             	shl    $0x4,%edx
  8021aa:	01 d0                	add    %edx,%eax
  8021ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021b1:	a1 50 50 80 00       	mov    0x805050,%eax
  8021b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b9:	c1 e2 04             	shl    $0x4,%edx
  8021bc:	01 d0                	add    %edx,%eax
  8021be:	a3 48 51 80 00       	mov    %eax,0x805148
  8021c3:	a1 50 50 80 00       	mov    0x805050,%eax
  8021c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021cb:	c1 e2 04             	shl    $0x4,%edx
  8021ce:	01 d0                	add    %edx,%eax
  8021d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8021dc:	40                   	inc    %eax
  8021dd:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021e2:	ff 45 f4             	incl   -0xc(%ebp)
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021eb:	0f 82 56 ff ff ff    	jb     802147 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021f1:	90                   	nop
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	8b 00                	mov    (%eax),%eax
  8021ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802202:	eb 19                	jmp    80221d <find_block+0x29>
	{
		if(va==point->sva)
  802204:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802207:	8b 40 08             	mov    0x8(%eax),%eax
  80220a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80220d:	75 05                	jne    802214 <find_block+0x20>
		   return point;
  80220f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802212:	eb 36                	jmp    80224a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	8b 40 08             	mov    0x8(%eax),%eax
  80221a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80221d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802221:	74 07                	je     80222a <find_block+0x36>
  802223:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802226:	8b 00                	mov    (%eax),%eax
  802228:	eb 05                	jmp    80222f <find_block+0x3b>
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
  80222f:	8b 55 08             	mov    0x8(%ebp),%edx
  802232:	89 42 08             	mov    %eax,0x8(%edx)
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	8b 40 08             	mov    0x8(%eax),%eax
  80223b:	85 c0                	test   %eax,%eax
  80223d:	75 c5                	jne    802204 <find_block+0x10>
  80223f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802243:	75 bf                	jne    802204 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802252:	a1 40 50 80 00       	mov    0x805040,%eax
  802257:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80225a:	a1 44 50 80 00       	mov    0x805044,%eax
  80225f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802265:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802268:	74 24                	je     80228e <insert_sorted_allocList+0x42>
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8b 50 08             	mov    0x8(%eax),%edx
  802270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	76 14                	jbe    80228e <insert_sorted_allocList+0x42>
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	8b 50 08             	mov    0x8(%eax),%edx
  802280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802283:	8b 40 08             	mov    0x8(%eax),%eax
  802286:	39 c2                	cmp    %eax,%edx
  802288:	0f 82 60 01 00 00    	jb     8023ee <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80228e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802292:	75 65                	jne    8022f9 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802298:	75 14                	jne    8022ae <insert_sorted_allocList+0x62>
  80229a:	83 ec 04             	sub    $0x4,%esp
  80229d:	68 c4 44 80 00       	push   $0x8044c4
  8022a2:	6a 6b                	push   $0x6b
  8022a4:	68 e7 44 80 00       	push   $0x8044e7
  8022a9:	e8 9c e2 ff ff       	call   80054a <_panic>
  8022ae:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	89 10                	mov    %edx,(%eax)
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	8b 00                	mov    (%eax),%eax
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	74 0d                	je     8022cf <insert_sorted_allocList+0x83>
  8022c2:	a1 40 50 80 00       	mov    0x805040,%eax
  8022c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ca:	89 50 04             	mov    %edx,0x4(%eax)
  8022cd:	eb 08                	jmp    8022d7 <insert_sorted_allocList+0x8b>
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	a3 40 50 80 00       	mov    %eax,0x805040
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ee:	40                   	inc    %eax
  8022ef:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022f4:	e9 dc 01 00 00       	jmp    8024d5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8b 50 08             	mov    0x8(%eax),%edx
  8022ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802302:	8b 40 08             	mov    0x8(%eax),%eax
  802305:	39 c2                	cmp    %eax,%edx
  802307:	77 6c                	ja     802375 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802309:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80230d:	74 06                	je     802315 <insert_sorted_allocList+0xc9>
  80230f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802313:	75 14                	jne    802329 <insert_sorted_allocList+0xdd>
  802315:	83 ec 04             	sub    $0x4,%esp
  802318:	68 00 45 80 00       	push   $0x804500
  80231d:	6a 6f                	push   $0x6f
  80231f:	68 e7 44 80 00       	push   $0x8044e7
  802324:	e8 21 e2 ff ff       	call   80054a <_panic>
  802329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232c:	8b 50 04             	mov    0x4(%eax),%edx
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	89 50 04             	mov    %edx,0x4(%eax)
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233b:	89 10                	mov    %edx,(%eax)
  80233d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802340:	8b 40 04             	mov    0x4(%eax),%eax
  802343:	85 c0                	test   %eax,%eax
  802345:	74 0d                	je     802354 <insert_sorted_allocList+0x108>
  802347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234a:	8b 40 04             	mov    0x4(%eax),%eax
  80234d:	8b 55 08             	mov    0x8(%ebp),%edx
  802350:	89 10                	mov    %edx,(%eax)
  802352:	eb 08                	jmp    80235c <insert_sorted_allocList+0x110>
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	a3 40 50 80 00       	mov    %eax,0x805040
  80235c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235f:	8b 55 08             	mov    0x8(%ebp),%edx
  802362:	89 50 04             	mov    %edx,0x4(%eax)
  802365:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80236a:	40                   	inc    %eax
  80236b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802370:	e9 60 01 00 00       	jmp    8024d5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	8b 50 08             	mov    0x8(%eax),%edx
  80237b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237e:	8b 40 08             	mov    0x8(%eax),%eax
  802381:	39 c2                	cmp    %eax,%edx
  802383:	0f 82 4c 01 00 00    	jb     8024d5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802389:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238d:	75 14                	jne    8023a3 <insert_sorted_allocList+0x157>
  80238f:	83 ec 04             	sub    $0x4,%esp
  802392:	68 38 45 80 00       	push   $0x804538
  802397:	6a 73                	push   $0x73
  802399:	68 e7 44 80 00       	push   $0x8044e7
  80239e:	e8 a7 e1 ff ff       	call   80054a <_panic>
  8023a3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	89 50 04             	mov    %edx,0x4(%eax)
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	8b 40 04             	mov    0x4(%eax),%eax
  8023b5:	85 c0                	test   %eax,%eax
  8023b7:	74 0c                	je     8023c5 <insert_sorted_allocList+0x179>
  8023b9:	a1 44 50 80 00       	mov    0x805044,%eax
  8023be:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c1:	89 10                	mov    %edx,(%eax)
  8023c3:	eb 08                	jmp    8023cd <insert_sorted_allocList+0x181>
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	a3 40 50 80 00       	mov    %eax,0x805040
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	a3 44 50 80 00       	mov    %eax,0x805044
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023de:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023e3:	40                   	inc    %eax
  8023e4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023e9:	e9 e7 00 00 00       	jmp    8024d5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023f4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023fb:	a1 40 50 80 00       	mov    0x805040,%eax
  802400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802403:	e9 9d 00 00 00       	jmp    8024a5 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	8b 50 08             	mov    0x8(%eax),%edx
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 40 08             	mov    0x8(%eax),%eax
  80241c:	39 c2                	cmp    %eax,%edx
  80241e:	76 7d                	jbe    80249d <insert_sorted_allocList+0x251>
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	8b 50 08             	mov    0x8(%eax),%edx
  802426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802429:	8b 40 08             	mov    0x8(%eax),%eax
  80242c:	39 c2                	cmp    %eax,%edx
  80242e:	73 6d                	jae    80249d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802434:	74 06                	je     80243c <insert_sorted_allocList+0x1f0>
  802436:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80243a:	75 14                	jne    802450 <insert_sorted_allocList+0x204>
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	68 5c 45 80 00       	push   $0x80455c
  802444:	6a 7f                	push   $0x7f
  802446:	68 e7 44 80 00       	push   $0x8044e7
  80244b:	e8 fa e0 ff ff       	call   80054a <_panic>
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 10                	mov    (%eax),%edx
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	89 10                	mov    %edx,(%eax)
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	8b 00                	mov    (%eax),%eax
  80245f:	85 c0                	test   %eax,%eax
  802461:	74 0b                	je     80246e <insert_sorted_allocList+0x222>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	8b 55 08             	mov    0x8(%ebp),%edx
  80246b:	89 50 04             	mov    %edx,0x4(%eax)
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 55 08             	mov    0x8(%ebp),%edx
  802474:	89 10                	mov    %edx,(%eax)
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247c:	89 50 04             	mov    %edx,0x4(%eax)
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	8b 00                	mov    (%eax),%eax
  802484:	85 c0                	test   %eax,%eax
  802486:	75 08                	jne    802490 <insert_sorted_allocList+0x244>
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	a3 44 50 80 00       	mov    %eax,0x805044
  802490:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802495:	40                   	inc    %eax
  802496:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80249b:	eb 39                	jmp    8024d6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80249d:	a1 48 50 80 00       	mov    0x805048,%eax
  8024a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a9:	74 07                	je     8024b2 <insert_sorted_allocList+0x266>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	eb 05                	jmp    8024b7 <insert_sorted_allocList+0x26b>
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b7:	a3 48 50 80 00       	mov    %eax,0x805048
  8024bc:	a1 48 50 80 00       	mov    0x805048,%eax
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	0f 85 3f ff ff ff    	jne    802408 <insert_sorted_allocList+0x1bc>
  8024c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cd:	0f 85 35 ff ff ff    	jne    802408 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024d3:	eb 01                	jmp    8024d6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024d5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024d6:	90                   	nop
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024df:	a1 38 51 80 00       	mov    0x805138,%eax
  8024e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e7:	e9 85 01 00 00       	jmp    802671 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f5:	0f 82 6e 01 00 00    	jb     802669 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802501:	3b 45 08             	cmp    0x8(%ebp),%eax
  802504:	0f 85 8a 00 00 00    	jne    802594 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80250a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250e:	75 17                	jne    802527 <alloc_block_FF+0x4e>
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 90 45 80 00       	push   $0x804590
  802518:	68 93 00 00 00       	push   $0x93
  80251d:	68 e7 44 80 00       	push   $0x8044e7
  802522:	e8 23 e0 ff ff       	call   80054a <_panic>
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 10                	je     802540 <alloc_block_FF+0x67>
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 00                	mov    (%eax),%eax
  802535:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802538:	8b 52 04             	mov    0x4(%edx),%edx
  80253b:	89 50 04             	mov    %edx,0x4(%eax)
  80253e:	eb 0b                	jmp    80254b <alloc_block_FF+0x72>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 40 04             	mov    0x4(%eax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	74 0f                	je     802564 <alloc_block_FF+0x8b>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 40 04             	mov    0x4(%eax),%eax
  80255b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255e:	8b 12                	mov    (%edx),%edx
  802560:	89 10                	mov    %edx,(%eax)
  802562:	eb 0a                	jmp    80256e <alloc_block_FF+0x95>
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 00                	mov    (%eax),%eax
  802569:	a3 38 51 80 00       	mov    %eax,0x805138
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802581:	a1 44 51 80 00       	mov    0x805144,%eax
  802586:	48                   	dec    %eax
  802587:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	e9 10 01 00 00       	jmp    8026a4 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 40 0c             	mov    0xc(%eax),%eax
  80259a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259d:	0f 86 c6 00 00 00    	jbe    802669 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8025a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 50 08             	mov    0x8(%eax),%edx
  8025b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b4:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8025bd:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c4:	75 17                	jne    8025dd <alloc_block_FF+0x104>
  8025c6:	83 ec 04             	sub    $0x4,%esp
  8025c9:	68 90 45 80 00       	push   $0x804590
  8025ce:	68 9b 00 00 00       	push   $0x9b
  8025d3:	68 e7 44 80 00       	push   $0x8044e7
  8025d8:	e8 6d df ff ff       	call   80054a <_panic>
  8025dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	74 10                	je     8025f6 <alloc_block_FF+0x11d>
  8025e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ee:	8b 52 04             	mov    0x4(%edx),%edx
  8025f1:	89 50 04             	mov    %edx,0x4(%eax)
  8025f4:	eb 0b                	jmp    802601 <alloc_block_FF+0x128>
  8025f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f9:	8b 40 04             	mov    0x4(%eax),%eax
  8025fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802604:	8b 40 04             	mov    0x4(%eax),%eax
  802607:	85 c0                	test   %eax,%eax
  802609:	74 0f                	je     80261a <alloc_block_FF+0x141>
  80260b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260e:	8b 40 04             	mov    0x4(%eax),%eax
  802611:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802614:	8b 12                	mov    (%edx),%edx
  802616:	89 10                	mov    %edx,(%eax)
  802618:	eb 0a                	jmp    802624 <alloc_block_FF+0x14b>
  80261a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	a3 48 51 80 00       	mov    %eax,0x805148
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802630:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802637:	a1 54 51 80 00       	mov    0x805154,%eax
  80263c:	48                   	dec    %eax
  80263d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 50 08             	mov    0x8(%eax),%edx
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	01 c2                	add    %eax,%edx
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 40 0c             	mov    0xc(%eax),%eax
  802659:	2b 45 08             	sub    0x8(%ebp),%eax
  80265c:	89 c2                	mov    %eax,%edx
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	eb 3b                	jmp    8026a4 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802669:	a1 40 51 80 00       	mov    0x805140,%eax
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802675:	74 07                	je     80267e <alloc_block_FF+0x1a5>
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 00                	mov    (%eax),%eax
  80267c:	eb 05                	jmp    802683 <alloc_block_FF+0x1aa>
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
  802683:	a3 40 51 80 00       	mov    %eax,0x805140
  802688:	a1 40 51 80 00       	mov    0x805140,%eax
  80268d:	85 c0                	test   %eax,%eax
  80268f:	0f 85 57 fe ff ff    	jne    8024ec <alloc_block_FF+0x13>
  802695:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802699:	0f 85 4d fe ff ff    	jne    8024ec <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bb:	e9 df 00 00 00       	jmp    80279f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c9:	0f 82 c8 00 00 00    	jb     802797 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d8:	0f 85 8a 00 00 00    	jne    802768 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e2:	75 17                	jne    8026fb <alloc_block_BF+0x55>
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	68 90 45 80 00       	push   $0x804590
  8026ec:	68 b7 00 00 00       	push   $0xb7
  8026f1:	68 e7 44 80 00       	push   $0x8044e7
  8026f6:	e8 4f de ff ff       	call   80054a <_panic>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	74 10                	je     802714 <alloc_block_BF+0x6e>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270c:	8b 52 04             	mov    0x4(%edx),%edx
  80270f:	89 50 04             	mov    %edx,0x4(%eax)
  802712:	eb 0b                	jmp    80271f <alloc_block_BF+0x79>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 0f                	je     802738 <alloc_block_BF+0x92>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 04             	mov    0x4(%eax),%eax
  80272f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802732:	8b 12                	mov    (%edx),%edx
  802734:	89 10                	mov    %edx,(%eax)
  802736:	eb 0a                	jmp    802742 <alloc_block_BF+0x9c>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	a3 38 51 80 00       	mov    %eax,0x805138
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802755:	a1 44 51 80 00       	mov    0x805144,%eax
  80275a:	48                   	dec    %eax
  80275b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	e9 4d 01 00 00       	jmp    8028b5 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802771:	76 24                	jbe    802797 <alloc_block_BF+0xf1>
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 40 0c             	mov    0xc(%eax),%eax
  802779:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80277c:	73 19                	jae    802797 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80277e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 40 0c             	mov    0xc(%eax),%eax
  80278b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 40 08             	mov    0x8(%eax),%eax
  802794:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802797:	a1 40 51 80 00       	mov    0x805140,%eax
  80279c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a3:	74 07                	je     8027ac <alloc_block_BF+0x106>
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	eb 05                	jmp    8027b1 <alloc_block_BF+0x10b>
  8027ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b1:	a3 40 51 80 00       	mov    %eax,0x805140
  8027b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	0f 85 fd fe ff ff    	jne    8026c0 <alloc_block_BF+0x1a>
  8027c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c7:	0f 85 f3 fe ff ff    	jne    8026c0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027d1:	0f 84 d9 00 00 00    	je     8028b0 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8027dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ee:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027f5:	75 17                	jne    80280e <alloc_block_BF+0x168>
  8027f7:	83 ec 04             	sub    $0x4,%esp
  8027fa:	68 90 45 80 00       	push   $0x804590
  8027ff:	68 c7 00 00 00       	push   $0xc7
  802804:	68 e7 44 80 00       	push   $0x8044e7
  802809:	e8 3c dd ff ff       	call   80054a <_panic>
  80280e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 10                	je     802827 <alloc_block_BF+0x181>
  802817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80281f:	8b 52 04             	mov    0x4(%edx),%edx
  802822:	89 50 04             	mov    %edx,0x4(%eax)
  802825:	eb 0b                	jmp    802832 <alloc_block_BF+0x18c>
  802827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802835:	8b 40 04             	mov    0x4(%eax),%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	74 0f                	je     80284b <alloc_block_BF+0x1a5>
  80283c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802845:	8b 12                	mov    (%edx),%edx
  802847:	89 10                	mov    %edx,(%eax)
  802849:	eb 0a                	jmp    802855 <alloc_block_BF+0x1af>
  80284b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284e:	8b 00                	mov    (%eax),%eax
  802850:	a3 48 51 80 00       	mov    %eax,0x805148
  802855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802858:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802861:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802868:	a1 54 51 80 00       	mov    0x805154,%eax
  80286d:	48                   	dec    %eax
  80286e:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802873:	83 ec 08             	sub    $0x8,%esp
  802876:	ff 75 ec             	pushl  -0x14(%ebp)
  802879:	68 38 51 80 00       	push   $0x805138
  80287e:	e8 71 f9 ff ff       	call   8021f4 <find_block>
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288c:	8b 50 08             	mov    0x8(%eax),%edx
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	01 c2                	add    %eax,%edx
  802894:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802897:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80289a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289d:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a3:	89 c2                	mov    %eax,%edx
  8028a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a8:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ae:	eb 05                	jmp    8028b5 <alloc_block_BF+0x20f>
	}
	return NULL;
  8028b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028bd:	a1 28 50 80 00       	mov    0x805028,%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	0f 85 de 01 00 00    	jne    802aa8 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8028cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d2:	e9 9e 01 00 00       	jmp    802a75 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 40 0c             	mov    0xc(%eax),%eax
  8028dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e0:	0f 82 87 01 00 00    	jb     802a6d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ef:	0f 85 95 00 00 00    	jne    80298a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f9:	75 17                	jne    802912 <alloc_block_NF+0x5b>
  8028fb:	83 ec 04             	sub    $0x4,%esp
  8028fe:	68 90 45 80 00       	push   $0x804590
  802903:	68 e0 00 00 00       	push   $0xe0
  802908:	68 e7 44 80 00       	push   $0x8044e7
  80290d:	e8 38 dc ff ff       	call   80054a <_panic>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 10                	je     80292b <alloc_block_NF+0x74>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802923:	8b 52 04             	mov    0x4(%edx),%edx
  802926:	89 50 04             	mov    %edx,0x4(%eax)
  802929:	eb 0b                	jmp    802936 <alloc_block_NF+0x7f>
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 40 04             	mov    0x4(%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 0f                	je     80294f <alloc_block_NF+0x98>
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 04             	mov    0x4(%eax),%eax
  802946:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802949:	8b 12                	mov    (%edx),%edx
  80294b:	89 10                	mov    %edx,(%eax)
  80294d:	eb 0a                	jmp    802959 <alloc_block_NF+0xa2>
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	a3 38 51 80 00       	mov    %eax,0x805138
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296c:	a1 44 51 80 00       	mov    0x805144,%eax
  802971:	48                   	dec    %eax
  802972:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 08             	mov    0x8(%eax),%eax
  80297d:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	e9 f8 04 00 00       	jmp    802e82 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 0c             	mov    0xc(%eax),%eax
  802990:	3b 45 08             	cmp    0x8(%ebp),%eax
  802993:	0f 86 d4 00 00 00    	jbe    802a6d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802999:	a1 48 51 80 00       	mov    0x805148,%eax
  80299e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 50 08             	mov    0x8(%eax),%edx
  8029a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029aa:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b3:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029ba:	75 17                	jne    8029d3 <alloc_block_NF+0x11c>
  8029bc:	83 ec 04             	sub    $0x4,%esp
  8029bf:	68 90 45 80 00       	push   $0x804590
  8029c4:	68 e9 00 00 00       	push   $0xe9
  8029c9:	68 e7 44 80 00       	push   $0x8044e7
  8029ce:	e8 77 db ff ff       	call   80054a <_panic>
  8029d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d6:	8b 00                	mov    (%eax),%eax
  8029d8:	85 c0                	test   %eax,%eax
  8029da:	74 10                	je     8029ec <alloc_block_NF+0x135>
  8029dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029df:	8b 00                	mov    (%eax),%eax
  8029e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e4:	8b 52 04             	mov    0x4(%edx),%edx
  8029e7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ea:	eb 0b                	jmp    8029f7 <alloc_block_NF+0x140>
  8029ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ef:	8b 40 04             	mov    0x4(%eax),%eax
  8029f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fa:	8b 40 04             	mov    0x4(%eax),%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	74 0f                	je     802a10 <alloc_block_NF+0x159>
  802a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a04:	8b 40 04             	mov    0x4(%eax),%eax
  802a07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a0a:	8b 12                	mov    (%edx),%edx
  802a0c:	89 10                	mov    %edx,(%eax)
  802a0e:	eb 0a                	jmp    802a1a <alloc_block_NF+0x163>
  802a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a13:	8b 00                	mov    (%eax),%eax
  802a15:	a3 48 51 80 00       	mov    %eax,0x805148
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2d:	a1 54 51 80 00       	mov    0x805154,%eax
  802a32:	48                   	dec    %eax
  802a33:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3b:	8b 40 08             	mov    0x8(%eax),%eax
  802a3e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 50 08             	mov    0x8(%eax),%edx
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	01 c2                	add    %eax,%edx
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a5d:	89 c2                	mov    %eax,%edx
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	e9 15 04 00 00       	jmp    802e82 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a6d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a79:	74 07                	je     802a82 <alloc_block_NF+0x1cb>
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	eb 05                	jmp    802a87 <alloc_block_NF+0x1d0>
  802a82:	b8 00 00 00 00       	mov    $0x0,%eax
  802a87:	a3 40 51 80 00       	mov    %eax,0x805140
  802a8c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	0f 85 3e fe ff ff    	jne    8028d7 <alloc_block_NF+0x20>
  802a99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9d:	0f 85 34 fe ff ff    	jne    8028d7 <alloc_block_NF+0x20>
  802aa3:	e9 d5 03 00 00       	jmp    802e7d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa8:	a1 38 51 80 00       	mov    0x805138,%eax
  802aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab0:	e9 b1 01 00 00       	jmp    802c66 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 50 08             	mov    0x8(%eax),%edx
  802abb:	a1 28 50 80 00       	mov    0x805028,%eax
  802ac0:	39 c2                	cmp    %eax,%edx
  802ac2:	0f 82 96 01 00 00    	jb     802c5e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ace:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad1:	0f 82 87 01 00 00    	jb     802c5e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 0c             	mov    0xc(%eax),%eax
  802add:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae0:	0f 85 95 00 00 00    	jne    802b7b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ae6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aea:	75 17                	jne    802b03 <alloc_block_NF+0x24c>
  802aec:	83 ec 04             	sub    $0x4,%esp
  802aef:	68 90 45 80 00       	push   $0x804590
  802af4:	68 fc 00 00 00       	push   $0xfc
  802af9:	68 e7 44 80 00       	push   $0x8044e7
  802afe:	e8 47 da ff ff       	call   80054a <_panic>
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	74 10                	je     802b1c <alloc_block_NF+0x265>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b14:	8b 52 04             	mov    0x4(%edx),%edx
  802b17:	89 50 04             	mov    %edx,0x4(%eax)
  802b1a:	eb 0b                	jmp    802b27 <alloc_block_NF+0x270>
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 40 04             	mov    0x4(%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 0f                	je     802b40 <alloc_block_NF+0x289>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3a:	8b 12                	mov    (%edx),%edx
  802b3c:	89 10                	mov    %edx,(%eax)
  802b3e:	eb 0a                	jmp    802b4a <alloc_block_NF+0x293>
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	a3 38 51 80 00       	mov    %eax,0x805138
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5d:	a1 44 51 80 00       	mov    0x805144,%eax
  802b62:	48                   	dec    %eax
  802b63:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 40 08             	mov    0x8(%eax),%eax
  802b6e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	e9 07 03 00 00       	jmp    802e82 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b84:	0f 86 d4 00 00 00    	jbe    802c5e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b8a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 50 08             	mov    0x8(%eax),%edx
  802b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ba7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bab:	75 17                	jne    802bc4 <alloc_block_NF+0x30d>
  802bad:	83 ec 04             	sub    $0x4,%esp
  802bb0:	68 90 45 80 00       	push   $0x804590
  802bb5:	68 04 01 00 00       	push   $0x104
  802bba:	68 e7 44 80 00       	push   $0x8044e7
  802bbf:	e8 86 d9 ff ff       	call   80054a <_panic>
  802bc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc7:	8b 00                	mov    (%eax),%eax
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	74 10                	je     802bdd <alloc_block_NF+0x326>
  802bcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bd5:	8b 52 04             	mov    0x4(%edx),%edx
  802bd8:	89 50 04             	mov    %edx,0x4(%eax)
  802bdb:	eb 0b                	jmp    802be8 <alloc_block_NF+0x331>
  802bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802beb:	8b 40 04             	mov    0x4(%eax),%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	74 0f                	je     802c01 <alloc_block_NF+0x34a>
  802bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bfb:	8b 12                	mov    (%edx),%edx
  802bfd:	89 10                	mov    %edx,(%eax)
  802bff:	eb 0a                	jmp    802c0b <alloc_block_NF+0x354>
  802c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	a3 48 51 80 00       	mov    %eax,0x805148
  802c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1e:	a1 54 51 80 00       	mov    0x805154,%eax
  802c23:	48                   	dec    %eax
  802c24:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2c:	8b 40 08             	mov    0x8(%eax),%eax
  802c2f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 50 08             	mov    0x8(%eax),%edx
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	01 c2                	add    %eax,%edx
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4b:	2b 45 08             	sub    0x8(%ebp),%eax
  802c4e:	89 c2                	mov    %eax,%edx
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c59:	e9 24 02 00 00       	jmp    802e82 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c5e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6a:	74 07                	je     802c73 <alloc_block_NF+0x3bc>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	eb 05                	jmp    802c78 <alloc_block_NF+0x3c1>
  802c73:	b8 00 00 00 00       	mov    $0x0,%eax
  802c78:	a3 40 51 80 00       	mov    %eax,0x805140
  802c7d:	a1 40 51 80 00       	mov    0x805140,%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	0f 85 2b fe ff ff    	jne    802ab5 <alloc_block_NF+0x1fe>
  802c8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8e:	0f 85 21 fe ff ff    	jne    802ab5 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c94:	a1 38 51 80 00       	mov    0x805138,%eax
  802c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c9c:	e9 ae 01 00 00       	jmp    802e4f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 50 08             	mov    0x8(%eax),%edx
  802ca7:	a1 28 50 80 00       	mov    0x805028,%eax
  802cac:	39 c2                	cmp    %eax,%edx
  802cae:	0f 83 93 01 00 00    	jae    802e47 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cbd:	0f 82 84 01 00 00    	jb     802e47 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ccc:	0f 85 95 00 00 00    	jne    802d67 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd6:	75 17                	jne    802cef <alloc_block_NF+0x438>
  802cd8:	83 ec 04             	sub    $0x4,%esp
  802cdb:	68 90 45 80 00       	push   $0x804590
  802ce0:	68 14 01 00 00       	push   $0x114
  802ce5:	68 e7 44 80 00       	push   $0x8044e7
  802cea:	e8 5b d8 ff ff       	call   80054a <_panic>
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	74 10                	je     802d08 <alloc_block_NF+0x451>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d00:	8b 52 04             	mov    0x4(%edx),%edx
  802d03:	89 50 04             	mov    %edx,0x4(%eax)
  802d06:	eb 0b                	jmp    802d13 <alloc_block_NF+0x45c>
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 40 04             	mov    0x4(%eax),%eax
  802d0e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 40 04             	mov    0x4(%eax),%eax
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	74 0f                	je     802d2c <alloc_block_NF+0x475>
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 40 04             	mov    0x4(%eax),%eax
  802d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d26:	8b 12                	mov    (%edx),%edx
  802d28:	89 10                	mov    %edx,(%eax)
  802d2a:	eb 0a                	jmp    802d36 <alloc_block_NF+0x47f>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	a3 38 51 80 00       	mov    %eax,0x805138
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d49:	a1 44 51 80 00       	mov    0x805144,%eax
  802d4e:	48                   	dec    %eax
  802d4f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 40 08             	mov    0x8(%eax),%eax
  802d5a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	e9 1b 01 00 00       	jmp    802e82 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d70:	0f 86 d1 00 00 00    	jbe    802e47 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d76:	a1 48 51 80 00       	mov    0x805148,%eax
  802d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 50 08             	mov    0x8(%eax),%edx
  802d84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d87:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d90:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d93:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d97:	75 17                	jne    802db0 <alloc_block_NF+0x4f9>
  802d99:	83 ec 04             	sub    $0x4,%esp
  802d9c:	68 90 45 80 00       	push   $0x804590
  802da1:	68 1c 01 00 00       	push   $0x11c
  802da6:	68 e7 44 80 00       	push   $0x8044e7
  802dab:	e8 9a d7 ff ff       	call   80054a <_panic>
  802db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	74 10                	je     802dc9 <alloc_block_NF+0x512>
  802db9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc1:	8b 52 04             	mov    0x4(%edx),%edx
  802dc4:	89 50 04             	mov    %edx,0x4(%eax)
  802dc7:	eb 0b                	jmp    802dd4 <alloc_block_NF+0x51d>
  802dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd7:	8b 40 04             	mov    0x4(%eax),%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	74 0f                	je     802ded <alloc_block_NF+0x536>
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	8b 40 04             	mov    0x4(%eax),%eax
  802de4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de7:	8b 12                	mov    (%edx),%edx
  802de9:	89 10                	mov    %edx,(%eax)
  802deb:	eb 0a                	jmp    802df7 <alloc_block_NF+0x540>
  802ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	a3 48 51 80 00       	mov    %eax,0x805148
  802df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e0f:	48                   	dec    %eax
  802e10:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e18:	8b 40 08             	mov    0x8(%eax),%eax
  802e1b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 50 08             	mov    0x8(%eax),%edx
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	01 c2                	add    %eax,%edx
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	2b 45 08             	sub    0x8(%ebp),%eax
  802e3a:	89 c2                	mov    %eax,%edx
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e45:	eb 3b                	jmp    802e82 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e47:	a1 40 51 80 00       	mov    0x805140,%eax
  802e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e53:	74 07                	je     802e5c <alloc_block_NF+0x5a5>
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	eb 05                	jmp    802e61 <alloc_block_NF+0x5aa>
  802e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e61:	a3 40 51 80 00       	mov    %eax,0x805140
  802e66:	a1 40 51 80 00       	mov    0x805140,%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	0f 85 2e fe ff ff    	jne    802ca1 <alloc_block_NF+0x3ea>
  802e73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e77:	0f 85 24 fe ff ff    	jne    802ca1 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
  802e87:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e8a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e92:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e97:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e9f:	85 c0                	test   %eax,%eax
  802ea1:	74 14                	je     802eb7 <insert_sorted_with_merge_freeList+0x33>
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 50 08             	mov    0x8(%eax),%edx
  802ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eac:	8b 40 08             	mov    0x8(%eax),%eax
  802eaf:	39 c2                	cmp    %eax,%edx
  802eb1:	0f 87 9b 01 00 00    	ja     803052 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebb:	75 17                	jne    802ed4 <insert_sorted_with_merge_freeList+0x50>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 c4 44 80 00       	push   $0x8044c4
  802ec5:	68 38 01 00 00       	push   $0x138
  802eca:	68 e7 44 80 00       	push   $0x8044e7
  802ecf:	e8 76 d6 ff ff       	call   80054a <_panic>
  802ed4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	89 10                	mov    %edx,(%eax)
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	74 0d                	je     802ef5 <insert_sorted_with_merge_freeList+0x71>
  802ee8:	a1 38 51 80 00       	mov    0x805138,%eax
  802eed:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef0:	89 50 04             	mov    %edx,0x4(%eax)
  802ef3:	eb 08                	jmp    802efd <insert_sorted_with_merge_freeList+0x79>
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	a3 38 51 80 00       	mov    %eax,0x805138
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f14:	40                   	inc    %eax
  802f15:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f1e:	0f 84 a8 06 00 00    	je     8035cc <insert_sorted_with_merge_freeList+0x748>
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 50 08             	mov    0x8(%eax),%edx
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f30:	01 c2                	add    %eax,%edx
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	8b 40 08             	mov    0x8(%eax),%eax
  802f38:	39 c2                	cmp    %eax,%edx
  802f3a:	0f 85 8c 06 00 00    	jne    8035cc <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	8b 50 0c             	mov    0xc(%eax),%edx
  802f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f49:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4c:	01 c2                	add    %eax,%edx
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f58:	75 17                	jne    802f71 <insert_sorted_with_merge_freeList+0xed>
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	68 90 45 80 00       	push   $0x804590
  802f62:	68 3c 01 00 00       	push   $0x13c
  802f67:	68 e7 44 80 00       	push   $0x8044e7
  802f6c:	e8 d9 d5 ff ff       	call   80054a <_panic>
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	8b 00                	mov    (%eax),%eax
  802f76:	85 c0                	test   %eax,%eax
  802f78:	74 10                	je     802f8a <insert_sorted_with_merge_freeList+0x106>
  802f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7d:	8b 00                	mov    (%eax),%eax
  802f7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f82:	8b 52 04             	mov    0x4(%edx),%edx
  802f85:	89 50 04             	mov    %edx,0x4(%eax)
  802f88:	eb 0b                	jmp    802f95 <insert_sorted_with_merge_freeList+0x111>
  802f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8d:	8b 40 04             	mov    0x4(%eax),%eax
  802f90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f98:	8b 40 04             	mov    0x4(%eax),%eax
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	74 0f                	je     802fae <insert_sorted_with_merge_freeList+0x12a>
  802f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa2:	8b 40 04             	mov    0x4(%eax),%eax
  802fa5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa8:	8b 12                	mov    (%edx),%edx
  802faa:	89 10                	mov    %edx,(%eax)
  802fac:	eb 0a                	jmp    802fb8 <insert_sorted_with_merge_freeList+0x134>
  802fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb1:	8b 00                	mov    (%eax),%eax
  802fb3:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcb:	a1 44 51 80 00       	mov    0x805144,%eax
  802fd0:	48                   	dec    %eax
  802fd1:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fee:	75 17                	jne    803007 <insert_sorted_with_merge_freeList+0x183>
  802ff0:	83 ec 04             	sub    $0x4,%esp
  802ff3:	68 c4 44 80 00       	push   $0x8044c4
  802ff8:	68 3f 01 00 00       	push   $0x13f
  802ffd:	68 e7 44 80 00       	push   $0x8044e7
  803002:	e8 43 d5 ff ff       	call   80054a <_panic>
  803007:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80300d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803010:	89 10                	mov    %edx,(%eax)
  803012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	74 0d                	je     803028 <insert_sorted_with_merge_freeList+0x1a4>
  80301b:	a1 48 51 80 00       	mov    0x805148,%eax
  803020:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803023:	89 50 04             	mov    %edx,0x4(%eax)
  803026:	eb 08                	jmp    803030 <insert_sorted_with_merge_freeList+0x1ac>
  803028:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803033:	a3 48 51 80 00       	mov    %eax,0x805148
  803038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803042:	a1 54 51 80 00       	mov    0x805154,%eax
  803047:	40                   	inc    %eax
  803048:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80304d:	e9 7a 05 00 00       	jmp    8035cc <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	8b 50 08             	mov    0x8(%eax),%edx
  803058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305b:	8b 40 08             	mov    0x8(%eax),%eax
  80305e:	39 c2                	cmp    %eax,%edx
  803060:	0f 82 14 01 00 00    	jb     80317a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803066:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803069:	8b 50 08             	mov    0x8(%eax),%edx
  80306c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306f:	8b 40 0c             	mov    0xc(%eax),%eax
  803072:	01 c2                	add    %eax,%edx
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	8b 40 08             	mov    0x8(%eax),%eax
  80307a:	39 c2                	cmp    %eax,%edx
  80307c:	0f 85 90 00 00 00    	jne    803112 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803082:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803085:	8b 50 0c             	mov    0xc(%eax),%edx
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	8b 40 0c             	mov    0xc(%eax),%eax
  80308e:	01 c2                	add    %eax,%edx
  803090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803093:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ae:	75 17                	jne    8030c7 <insert_sorted_with_merge_freeList+0x243>
  8030b0:	83 ec 04             	sub    $0x4,%esp
  8030b3:	68 c4 44 80 00       	push   $0x8044c4
  8030b8:	68 49 01 00 00       	push   $0x149
  8030bd:	68 e7 44 80 00       	push   $0x8044e7
  8030c2:	e8 83 d4 ff ff       	call   80054a <_panic>
  8030c7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	89 10                	mov    %edx,(%eax)
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	8b 00                	mov    (%eax),%eax
  8030d7:	85 c0                	test   %eax,%eax
  8030d9:	74 0d                	je     8030e8 <insert_sorted_with_merge_freeList+0x264>
  8030db:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e3:	89 50 04             	mov    %edx,0x4(%eax)
  8030e6:	eb 08                	jmp    8030f0 <insert_sorted_with_merge_freeList+0x26c>
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803102:	a1 54 51 80 00       	mov    0x805154,%eax
  803107:	40                   	inc    %eax
  803108:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80310d:	e9 bb 04 00 00       	jmp    8035cd <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803112:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803116:	75 17                	jne    80312f <insert_sorted_with_merge_freeList+0x2ab>
  803118:	83 ec 04             	sub    $0x4,%esp
  80311b:	68 38 45 80 00       	push   $0x804538
  803120:	68 4c 01 00 00       	push   $0x14c
  803125:	68 e7 44 80 00       	push   $0x8044e7
  80312a:	e8 1b d4 ff ff       	call   80054a <_panic>
  80312f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803135:	8b 45 08             	mov    0x8(%ebp),%eax
  803138:	89 50 04             	mov    %edx,0x4(%eax)
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	8b 40 04             	mov    0x4(%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 0c                	je     803151 <insert_sorted_with_merge_freeList+0x2cd>
  803145:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80314a:	8b 55 08             	mov    0x8(%ebp),%edx
  80314d:	89 10                	mov    %edx,(%eax)
  80314f:	eb 08                	jmp    803159 <insert_sorted_with_merge_freeList+0x2d5>
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	a3 38 51 80 00       	mov    %eax,0x805138
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316a:	a1 44 51 80 00       	mov    0x805144,%eax
  80316f:	40                   	inc    %eax
  803170:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803175:	e9 53 04 00 00       	jmp    8035cd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80317a:	a1 38 51 80 00       	mov    0x805138,%eax
  80317f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803182:	e9 15 04 00 00       	jmp    80359c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	8b 50 08             	mov    0x8(%eax),%edx
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 40 08             	mov    0x8(%eax),%eax
  80319b:	39 c2                	cmp    %eax,%edx
  80319d:	0f 86 f1 03 00 00    	jbe    803594 <insert_sorted_with_merge_freeList+0x710>
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	8b 50 08             	mov    0x8(%eax),%edx
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	8b 40 08             	mov    0x8(%eax),%eax
  8031af:	39 c2                	cmp    %eax,%edx
  8031b1:	0f 83 dd 03 00 00    	jae    803594 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 50 08             	mov    0x8(%eax),%edx
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c3:	01 c2                	add    %eax,%edx
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	8b 40 08             	mov    0x8(%eax),%eax
  8031cb:	39 c2                	cmp    %eax,%edx
  8031cd:	0f 85 b9 01 00 00    	jne    80338c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	8b 50 08             	mov    0x8(%eax),%edx
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031df:	01 c2                	add    %eax,%edx
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	8b 40 08             	mov    0x8(%eax),%eax
  8031e7:	39 c2                	cmp    %eax,%edx
  8031e9:	0f 85 0d 01 00 00    	jne    8032fc <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fb:	01 c2                	add    %eax,%edx
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803207:	75 17                	jne    803220 <insert_sorted_with_merge_freeList+0x39c>
  803209:	83 ec 04             	sub    $0x4,%esp
  80320c:	68 90 45 80 00       	push   $0x804590
  803211:	68 5c 01 00 00       	push   $0x15c
  803216:	68 e7 44 80 00       	push   $0x8044e7
  80321b:	e8 2a d3 ff ff       	call   80054a <_panic>
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	74 10                	je     803239 <insert_sorted_with_merge_freeList+0x3b5>
  803229:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803231:	8b 52 04             	mov    0x4(%edx),%edx
  803234:	89 50 04             	mov    %edx,0x4(%eax)
  803237:	eb 0b                	jmp    803244 <insert_sorted_with_merge_freeList+0x3c0>
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	8b 40 04             	mov    0x4(%eax),%eax
  80323f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803247:	8b 40 04             	mov    0x4(%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 0f                	je     80325d <insert_sorted_with_merge_freeList+0x3d9>
  80324e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803251:	8b 40 04             	mov    0x4(%eax),%eax
  803254:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803257:	8b 12                	mov    (%edx),%edx
  803259:	89 10                	mov    %edx,(%eax)
  80325b:	eb 0a                	jmp    803267 <insert_sorted_with_merge_freeList+0x3e3>
  80325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803260:	8b 00                	mov    (%eax),%eax
  803262:	a3 38 51 80 00       	mov    %eax,0x805138
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327a:	a1 44 51 80 00       	mov    0x805144,%eax
  80327f:	48                   	dec    %eax
  803280:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80328f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803292:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803299:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80329d:	75 17                	jne    8032b6 <insert_sorted_with_merge_freeList+0x432>
  80329f:	83 ec 04             	sub    $0x4,%esp
  8032a2:	68 c4 44 80 00       	push   $0x8044c4
  8032a7:	68 5f 01 00 00       	push   $0x15f
  8032ac:	68 e7 44 80 00       	push   $0x8044e7
  8032b1:	e8 94 d2 ff ff       	call   80054a <_panic>
  8032b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bf:	89 10                	mov    %edx,(%eax)
  8032c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c4:	8b 00                	mov    (%eax),%eax
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	74 0d                	je     8032d7 <insert_sorted_with_merge_freeList+0x453>
  8032ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8032cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d2:	89 50 04             	mov    %edx,0x4(%eax)
  8032d5:	eb 08                	jmp    8032df <insert_sorted_with_merge_freeList+0x45b>
  8032d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8032f6:	40                   	inc    %eax
  8032f7:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 50 0c             	mov    0xc(%eax),%edx
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	8b 40 0c             	mov    0xc(%eax),%eax
  803308:	01 c2                	add    %eax,%edx
  80330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803324:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803328:	75 17                	jne    803341 <insert_sorted_with_merge_freeList+0x4bd>
  80332a:	83 ec 04             	sub    $0x4,%esp
  80332d:	68 c4 44 80 00       	push   $0x8044c4
  803332:	68 64 01 00 00       	push   $0x164
  803337:	68 e7 44 80 00       	push   $0x8044e7
  80333c:	e8 09 d2 ff ff       	call   80054a <_panic>
  803341:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	89 10                	mov    %edx,(%eax)
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	8b 00                	mov    (%eax),%eax
  803351:	85 c0                	test   %eax,%eax
  803353:	74 0d                	je     803362 <insert_sorted_with_merge_freeList+0x4de>
  803355:	a1 48 51 80 00       	mov    0x805148,%eax
  80335a:	8b 55 08             	mov    0x8(%ebp),%edx
  80335d:	89 50 04             	mov    %edx,0x4(%eax)
  803360:	eb 08                	jmp    80336a <insert_sorted_with_merge_freeList+0x4e6>
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	a3 48 51 80 00       	mov    %eax,0x805148
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337c:	a1 54 51 80 00       	mov    0x805154,%eax
  803381:	40                   	inc    %eax
  803382:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803387:	e9 41 02 00 00       	jmp    8035cd <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	8b 50 08             	mov    0x8(%eax),%edx
  803392:	8b 45 08             	mov    0x8(%ebp),%eax
  803395:	8b 40 0c             	mov    0xc(%eax),%eax
  803398:	01 c2                	add    %eax,%edx
  80339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339d:	8b 40 08             	mov    0x8(%eax),%eax
  8033a0:	39 c2                	cmp    %eax,%edx
  8033a2:	0f 85 7c 01 00 00    	jne    803524 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ac:	74 06                	je     8033b4 <insert_sorted_with_merge_freeList+0x530>
  8033ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b2:	75 17                	jne    8033cb <insert_sorted_with_merge_freeList+0x547>
  8033b4:	83 ec 04             	sub    $0x4,%esp
  8033b7:	68 00 45 80 00       	push   $0x804500
  8033bc:	68 69 01 00 00       	push   $0x169
  8033c1:	68 e7 44 80 00       	push   $0x8044e7
  8033c6:	e8 7f d1 ff ff       	call   80054a <_panic>
  8033cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ce:	8b 50 04             	mov    0x4(%eax),%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	89 50 04             	mov    %edx,0x4(%eax)
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033dd:	89 10                	mov    %edx,(%eax)
  8033df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e2:	8b 40 04             	mov    0x4(%eax),%eax
  8033e5:	85 c0                	test   %eax,%eax
  8033e7:	74 0d                	je     8033f6 <insert_sorted_with_merge_freeList+0x572>
  8033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ec:	8b 40 04             	mov    0x4(%eax),%eax
  8033ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f2:	89 10                	mov    %edx,(%eax)
  8033f4:	eb 08                	jmp    8033fe <insert_sorted_with_merge_freeList+0x57a>
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8033fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803401:	8b 55 08             	mov    0x8(%ebp),%edx
  803404:	89 50 04             	mov    %edx,0x4(%eax)
  803407:	a1 44 51 80 00       	mov    0x805144,%eax
  80340c:	40                   	inc    %eax
  80340d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	8b 50 0c             	mov    0xc(%eax),%edx
  803418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341b:	8b 40 0c             	mov    0xc(%eax),%eax
  80341e:	01 c2                	add    %eax,%edx
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803426:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80342a:	75 17                	jne    803443 <insert_sorted_with_merge_freeList+0x5bf>
  80342c:	83 ec 04             	sub    $0x4,%esp
  80342f:	68 90 45 80 00       	push   $0x804590
  803434:	68 6b 01 00 00       	push   $0x16b
  803439:	68 e7 44 80 00       	push   $0x8044e7
  80343e:	e8 07 d1 ff ff       	call   80054a <_panic>
  803443:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803446:	8b 00                	mov    (%eax),%eax
  803448:	85 c0                	test   %eax,%eax
  80344a:	74 10                	je     80345c <insert_sorted_with_merge_freeList+0x5d8>
  80344c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344f:	8b 00                	mov    (%eax),%eax
  803451:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803454:	8b 52 04             	mov    0x4(%edx),%edx
  803457:	89 50 04             	mov    %edx,0x4(%eax)
  80345a:	eb 0b                	jmp    803467 <insert_sorted_with_merge_freeList+0x5e3>
  80345c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345f:	8b 40 04             	mov    0x4(%eax),%eax
  803462:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803467:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346a:	8b 40 04             	mov    0x4(%eax),%eax
  80346d:	85 c0                	test   %eax,%eax
  80346f:	74 0f                	je     803480 <insert_sorted_with_merge_freeList+0x5fc>
  803471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803474:	8b 40 04             	mov    0x4(%eax),%eax
  803477:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80347a:	8b 12                	mov    (%edx),%edx
  80347c:	89 10                	mov    %edx,(%eax)
  80347e:	eb 0a                	jmp    80348a <insert_sorted_with_merge_freeList+0x606>
  803480:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803483:	8b 00                	mov    (%eax),%eax
  803485:	a3 38 51 80 00       	mov    %eax,0x805138
  80348a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803496:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349d:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a2:	48                   	dec    %eax
  8034a3:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034c0:	75 17                	jne    8034d9 <insert_sorted_with_merge_freeList+0x655>
  8034c2:	83 ec 04             	sub    $0x4,%esp
  8034c5:	68 c4 44 80 00       	push   $0x8044c4
  8034ca:	68 6e 01 00 00       	push   $0x16e
  8034cf:	68 e7 44 80 00       	push   $0x8044e7
  8034d4:	e8 71 d0 ff ff       	call   80054a <_panic>
  8034d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e2:	89 10                	mov    %edx,(%eax)
  8034e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e7:	8b 00                	mov    (%eax),%eax
  8034e9:	85 c0                	test   %eax,%eax
  8034eb:	74 0d                	je     8034fa <insert_sorted_with_merge_freeList+0x676>
  8034ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8034f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034f5:	89 50 04             	mov    %edx,0x4(%eax)
  8034f8:	eb 08                	jmp    803502 <insert_sorted_with_merge_freeList+0x67e>
  8034fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803502:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803505:	a3 48 51 80 00       	mov    %eax,0x805148
  80350a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803514:	a1 54 51 80 00       	mov    0x805154,%eax
  803519:	40                   	inc    %eax
  80351a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80351f:	e9 a9 00 00 00       	jmp    8035cd <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803528:	74 06                	je     803530 <insert_sorted_with_merge_freeList+0x6ac>
  80352a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80352e:	75 17                	jne    803547 <insert_sorted_with_merge_freeList+0x6c3>
  803530:	83 ec 04             	sub    $0x4,%esp
  803533:	68 5c 45 80 00       	push   $0x80455c
  803538:	68 73 01 00 00       	push   $0x173
  80353d:	68 e7 44 80 00       	push   $0x8044e7
  803542:	e8 03 d0 ff ff       	call   80054a <_panic>
  803547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354a:	8b 10                	mov    (%eax),%edx
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	89 10                	mov    %edx,(%eax)
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	8b 00                	mov    (%eax),%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	74 0b                	je     803565 <insert_sorted_with_merge_freeList+0x6e1>
  80355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	8b 55 08             	mov    0x8(%ebp),%edx
  803562:	89 50 04             	mov    %edx,0x4(%eax)
  803565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803568:	8b 55 08             	mov    0x8(%ebp),%edx
  80356b:	89 10                	mov    %edx,(%eax)
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803573:	89 50 04             	mov    %edx,0x4(%eax)
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	8b 00                	mov    (%eax),%eax
  80357b:	85 c0                	test   %eax,%eax
  80357d:	75 08                	jne    803587 <insert_sorted_with_merge_freeList+0x703>
  80357f:	8b 45 08             	mov    0x8(%ebp),%eax
  803582:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803587:	a1 44 51 80 00       	mov    0x805144,%eax
  80358c:	40                   	inc    %eax
  80358d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803592:	eb 39                	jmp    8035cd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803594:	a1 40 51 80 00       	mov    0x805140,%eax
  803599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80359c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a0:	74 07                	je     8035a9 <insert_sorted_with_merge_freeList+0x725>
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 00                	mov    (%eax),%eax
  8035a7:	eb 05                	jmp    8035ae <insert_sorted_with_merge_freeList+0x72a>
  8035a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ae:	a3 40 51 80 00       	mov    %eax,0x805140
  8035b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	0f 85 c7 fb ff ff    	jne    803187 <insert_sorted_with_merge_freeList+0x303>
  8035c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c4:	0f 85 bd fb ff ff    	jne    803187 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035ca:	eb 01                	jmp    8035cd <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035cc:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035cd:	90                   	nop
  8035ce:	c9                   	leave  
  8035cf:	c3                   	ret    

008035d0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8035d0:	55                   	push   %ebp
  8035d1:	89 e5                	mov    %esp,%ebp
  8035d3:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8035d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d9:	89 d0                	mov    %edx,%eax
  8035db:	c1 e0 02             	shl    $0x2,%eax
  8035de:	01 d0                	add    %edx,%eax
  8035e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035e7:	01 d0                	add    %edx,%eax
  8035e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035f0:	01 d0                	add    %edx,%eax
  8035f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035f9:	01 d0                	add    %edx,%eax
  8035fb:	c1 e0 04             	shl    $0x4,%eax
  8035fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803601:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803608:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80360b:	83 ec 0c             	sub    $0xc,%esp
  80360e:	50                   	push   %eax
  80360f:	e8 26 e7 ff ff       	call   801d3a <sys_get_virtual_time>
  803614:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803617:	eb 41                	jmp    80365a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803619:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80361c:	83 ec 0c             	sub    $0xc,%esp
  80361f:	50                   	push   %eax
  803620:	e8 15 e7 ff ff       	call   801d3a <sys_get_virtual_time>
  803625:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803628:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80362b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362e:	29 c2                	sub    %eax,%edx
  803630:	89 d0                	mov    %edx,%eax
  803632:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803635:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803638:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363b:	89 d1                	mov    %edx,%ecx
  80363d:	29 c1                	sub    %eax,%ecx
  80363f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803645:	39 c2                	cmp    %eax,%edx
  803647:	0f 97 c0             	seta   %al
  80364a:	0f b6 c0             	movzbl %al,%eax
  80364d:	29 c1                	sub    %eax,%ecx
  80364f:	89 c8                	mov    %ecx,%eax
  803651:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803654:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803657:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80365a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803660:	72 b7                	jb     803619 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803662:	90                   	nop
  803663:	c9                   	leave  
  803664:	c3                   	ret    

00803665 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803665:	55                   	push   %ebp
  803666:	89 e5                	mov    %esp,%ebp
  803668:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80366b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803672:	eb 03                	jmp    803677 <busy_wait+0x12>
  803674:	ff 45 fc             	incl   -0x4(%ebp)
  803677:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80367a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80367d:	72 f5                	jb     803674 <busy_wait+0xf>
	return i;
  80367f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803682:	c9                   	leave  
  803683:	c3                   	ret    

00803684 <__udivdi3>:
  803684:	55                   	push   %ebp
  803685:	57                   	push   %edi
  803686:	56                   	push   %esi
  803687:	53                   	push   %ebx
  803688:	83 ec 1c             	sub    $0x1c,%esp
  80368b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80368f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803693:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803697:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80369b:	89 ca                	mov    %ecx,%edx
  80369d:	89 f8                	mov    %edi,%eax
  80369f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036a3:	85 f6                	test   %esi,%esi
  8036a5:	75 2d                	jne    8036d4 <__udivdi3+0x50>
  8036a7:	39 cf                	cmp    %ecx,%edi
  8036a9:	77 65                	ja     803710 <__udivdi3+0x8c>
  8036ab:	89 fd                	mov    %edi,%ebp
  8036ad:	85 ff                	test   %edi,%edi
  8036af:	75 0b                	jne    8036bc <__udivdi3+0x38>
  8036b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8036b6:	31 d2                	xor    %edx,%edx
  8036b8:	f7 f7                	div    %edi
  8036ba:	89 c5                	mov    %eax,%ebp
  8036bc:	31 d2                	xor    %edx,%edx
  8036be:	89 c8                	mov    %ecx,%eax
  8036c0:	f7 f5                	div    %ebp
  8036c2:	89 c1                	mov    %eax,%ecx
  8036c4:	89 d8                	mov    %ebx,%eax
  8036c6:	f7 f5                	div    %ebp
  8036c8:	89 cf                	mov    %ecx,%edi
  8036ca:	89 fa                	mov    %edi,%edx
  8036cc:	83 c4 1c             	add    $0x1c,%esp
  8036cf:	5b                   	pop    %ebx
  8036d0:	5e                   	pop    %esi
  8036d1:	5f                   	pop    %edi
  8036d2:	5d                   	pop    %ebp
  8036d3:	c3                   	ret    
  8036d4:	39 ce                	cmp    %ecx,%esi
  8036d6:	77 28                	ja     803700 <__udivdi3+0x7c>
  8036d8:	0f bd fe             	bsr    %esi,%edi
  8036db:	83 f7 1f             	xor    $0x1f,%edi
  8036de:	75 40                	jne    803720 <__udivdi3+0x9c>
  8036e0:	39 ce                	cmp    %ecx,%esi
  8036e2:	72 0a                	jb     8036ee <__udivdi3+0x6a>
  8036e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036e8:	0f 87 9e 00 00 00    	ja     80378c <__udivdi3+0x108>
  8036ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f3:	89 fa                	mov    %edi,%edx
  8036f5:	83 c4 1c             	add    $0x1c,%esp
  8036f8:	5b                   	pop    %ebx
  8036f9:	5e                   	pop    %esi
  8036fa:	5f                   	pop    %edi
  8036fb:	5d                   	pop    %ebp
  8036fc:	c3                   	ret    
  8036fd:	8d 76 00             	lea    0x0(%esi),%esi
  803700:	31 ff                	xor    %edi,%edi
  803702:	31 c0                	xor    %eax,%eax
  803704:	89 fa                	mov    %edi,%edx
  803706:	83 c4 1c             	add    $0x1c,%esp
  803709:	5b                   	pop    %ebx
  80370a:	5e                   	pop    %esi
  80370b:	5f                   	pop    %edi
  80370c:	5d                   	pop    %ebp
  80370d:	c3                   	ret    
  80370e:	66 90                	xchg   %ax,%ax
  803710:	89 d8                	mov    %ebx,%eax
  803712:	f7 f7                	div    %edi
  803714:	31 ff                	xor    %edi,%edi
  803716:	89 fa                	mov    %edi,%edx
  803718:	83 c4 1c             	add    $0x1c,%esp
  80371b:	5b                   	pop    %ebx
  80371c:	5e                   	pop    %esi
  80371d:	5f                   	pop    %edi
  80371e:	5d                   	pop    %ebp
  80371f:	c3                   	ret    
  803720:	bd 20 00 00 00       	mov    $0x20,%ebp
  803725:	89 eb                	mov    %ebp,%ebx
  803727:	29 fb                	sub    %edi,%ebx
  803729:	89 f9                	mov    %edi,%ecx
  80372b:	d3 e6                	shl    %cl,%esi
  80372d:	89 c5                	mov    %eax,%ebp
  80372f:	88 d9                	mov    %bl,%cl
  803731:	d3 ed                	shr    %cl,%ebp
  803733:	89 e9                	mov    %ebp,%ecx
  803735:	09 f1                	or     %esi,%ecx
  803737:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80373b:	89 f9                	mov    %edi,%ecx
  80373d:	d3 e0                	shl    %cl,%eax
  80373f:	89 c5                	mov    %eax,%ebp
  803741:	89 d6                	mov    %edx,%esi
  803743:	88 d9                	mov    %bl,%cl
  803745:	d3 ee                	shr    %cl,%esi
  803747:	89 f9                	mov    %edi,%ecx
  803749:	d3 e2                	shl    %cl,%edx
  80374b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80374f:	88 d9                	mov    %bl,%cl
  803751:	d3 e8                	shr    %cl,%eax
  803753:	09 c2                	or     %eax,%edx
  803755:	89 d0                	mov    %edx,%eax
  803757:	89 f2                	mov    %esi,%edx
  803759:	f7 74 24 0c          	divl   0xc(%esp)
  80375d:	89 d6                	mov    %edx,%esi
  80375f:	89 c3                	mov    %eax,%ebx
  803761:	f7 e5                	mul    %ebp
  803763:	39 d6                	cmp    %edx,%esi
  803765:	72 19                	jb     803780 <__udivdi3+0xfc>
  803767:	74 0b                	je     803774 <__udivdi3+0xf0>
  803769:	89 d8                	mov    %ebx,%eax
  80376b:	31 ff                	xor    %edi,%edi
  80376d:	e9 58 ff ff ff       	jmp    8036ca <__udivdi3+0x46>
  803772:	66 90                	xchg   %ax,%ax
  803774:	8b 54 24 08          	mov    0x8(%esp),%edx
  803778:	89 f9                	mov    %edi,%ecx
  80377a:	d3 e2                	shl    %cl,%edx
  80377c:	39 c2                	cmp    %eax,%edx
  80377e:	73 e9                	jae    803769 <__udivdi3+0xe5>
  803780:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803783:	31 ff                	xor    %edi,%edi
  803785:	e9 40 ff ff ff       	jmp    8036ca <__udivdi3+0x46>
  80378a:	66 90                	xchg   %ax,%ax
  80378c:	31 c0                	xor    %eax,%eax
  80378e:	e9 37 ff ff ff       	jmp    8036ca <__udivdi3+0x46>
  803793:	90                   	nop

00803794 <__umoddi3>:
  803794:	55                   	push   %ebp
  803795:	57                   	push   %edi
  803796:	56                   	push   %esi
  803797:	53                   	push   %ebx
  803798:	83 ec 1c             	sub    $0x1c,%esp
  80379b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80379f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037b3:	89 f3                	mov    %esi,%ebx
  8037b5:	89 fa                	mov    %edi,%edx
  8037b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037bb:	89 34 24             	mov    %esi,(%esp)
  8037be:	85 c0                	test   %eax,%eax
  8037c0:	75 1a                	jne    8037dc <__umoddi3+0x48>
  8037c2:	39 f7                	cmp    %esi,%edi
  8037c4:	0f 86 a2 00 00 00    	jbe    80386c <__umoddi3+0xd8>
  8037ca:	89 c8                	mov    %ecx,%eax
  8037cc:	89 f2                	mov    %esi,%edx
  8037ce:	f7 f7                	div    %edi
  8037d0:	89 d0                	mov    %edx,%eax
  8037d2:	31 d2                	xor    %edx,%edx
  8037d4:	83 c4 1c             	add    $0x1c,%esp
  8037d7:	5b                   	pop    %ebx
  8037d8:	5e                   	pop    %esi
  8037d9:	5f                   	pop    %edi
  8037da:	5d                   	pop    %ebp
  8037db:	c3                   	ret    
  8037dc:	39 f0                	cmp    %esi,%eax
  8037de:	0f 87 ac 00 00 00    	ja     803890 <__umoddi3+0xfc>
  8037e4:	0f bd e8             	bsr    %eax,%ebp
  8037e7:	83 f5 1f             	xor    $0x1f,%ebp
  8037ea:	0f 84 ac 00 00 00    	je     80389c <__umoddi3+0x108>
  8037f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8037f5:	29 ef                	sub    %ebp,%edi
  8037f7:	89 fe                	mov    %edi,%esi
  8037f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037fd:	89 e9                	mov    %ebp,%ecx
  8037ff:	d3 e0                	shl    %cl,%eax
  803801:	89 d7                	mov    %edx,%edi
  803803:	89 f1                	mov    %esi,%ecx
  803805:	d3 ef                	shr    %cl,%edi
  803807:	09 c7                	or     %eax,%edi
  803809:	89 e9                	mov    %ebp,%ecx
  80380b:	d3 e2                	shl    %cl,%edx
  80380d:	89 14 24             	mov    %edx,(%esp)
  803810:	89 d8                	mov    %ebx,%eax
  803812:	d3 e0                	shl    %cl,%eax
  803814:	89 c2                	mov    %eax,%edx
  803816:	8b 44 24 08          	mov    0x8(%esp),%eax
  80381a:	d3 e0                	shl    %cl,%eax
  80381c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803820:	8b 44 24 08          	mov    0x8(%esp),%eax
  803824:	89 f1                	mov    %esi,%ecx
  803826:	d3 e8                	shr    %cl,%eax
  803828:	09 d0                	or     %edx,%eax
  80382a:	d3 eb                	shr    %cl,%ebx
  80382c:	89 da                	mov    %ebx,%edx
  80382e:	f7 f7                	div    %edi
  803830:	89 d3                	mov    %edx,%ebx
  803832:	f7 24 24             	mull   (%esp)
  803835:	89 c6                	mov    %eax,%esi
  803837:	89 d1                	mov    %edx,%ecx
  803839:	39 d3                	cmp    %edx,%ebx
  80383b:	0f 82 87 00 00 00    	jb     8038c8 <__umoddi3+0x134>
  803841:	0f 84 91 00 00 00    	je     8038d8 <__umoddi3+0x144>
  803847:	8b 54 24 04          	mov    0x4(%esp),%edx
  80384b:	29 f2                	sub    %esi,%edx
  80384d:	19 cb                	sbb    %ecx,%ebx
  80384f:	89 d8                	mov    %ebx,%eax
  803851:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803855:	d3 e0                	shl    %cl,%eax
  803857:	89 e9                	mov    %ebp,%ecx
  803859:	d3 ea                	shr    %cl,%edx
  80385b:	09 d0                	or     %edx,%eax
  80385d:	89 e9                	mov    %ebp,%ecx
  80385f:	d3 eb                	shr    %cl,%ebx
  803861:	89 da                	mov    %ebx,%edx
  803863:	83 c4 1c             	add    $0x1c,%esp
  803866:	5b                   	pop    %ebx
  803867:	5e                   	pop    %esi
  803868:	5f                   	pop    %edi
  803869:	5d                   	pop    %ebp
  80386a:	c3                   	ret    
  80386b:	90                   	nop
  80386c:	89 fd                	mov    %edi,%ebp
  80386e:	85 ff                	test   %edi,%edi
  803870:	75 0b                	jne    80387d <__umoddi3+0xe9>
  803872:	b8 01 00 00 00       	mov    $0x1,%eax
  803877:	31 d2                	xor    %edx,%edx
  803879:	f7 f7                	div    %edi
  80387b:	89 c5                	mov    %eax,%ebp
  80387d:	89 f0                	mov    %esi,%eax
  80387f:	31 d2                	xor    %edx,%edx
  803881:	f7 f5                	div    %ebp
  803883:	89 c8                	mov    %ecx,%eax
  803885:	f7 f5                	div    %ebp
  803887:	89 d0                	mov    %edx,%eax
  803889:	e9 44 ff ff ff       	jmp    8037d2 <__umoddi3+0x3e>
  80388e:	66 90                	xchg   %ax,%ax
  803890:	89 c8                	mov    %ecx,%eax
  803892:	89 f2                	mov    %esi,%edx
  803894:	83 c4 1c             	add    $0x1c,%esp
  803897:	5b                   	pop    %ebx
  803898:	5e                   	pop    %esi
  803899:	5f                   	pop    %edi
  80389a:	5d                   	pop    %ebp
  80389b:	c3                   	ret    
  80389c:	3b 04 24             	cmp    (%esp),%eax
  80389f:	72 06                	jb     8038a7 <__umoddi3+0x113>
  8038a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038a5:	77 0f                	ja     8038b6 <__umoddi3+0x122>
  8038a7:	89 f2                	mov    %esi,%edx
  8038a9:	29 f9                	sub    %edi,%ecx
  8038ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038af:	89 14 24             	mov    %edx,(%esp)
  8038b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038ba:	8b 14 24             	mov    (%esp),%edx
  8038bd:	83 c4 1c             	add    $0x1c,%esp
  8038c0:	5b                   	pop    %ebx
  8038c1:	5e                   	pop    %esi
  8038c2:	5f                   	pop    %edi
  8038c3:	5d                   	pop    %ebp
  8038c4:	c3                   	ret    
  8038c5:	8d 76 00             	lea    0x0(%esi),%esi
  8038c8:	2b 04 24             	sub    (%esp),%eax
  8038cb:	19 fa                	sbb    %edi,%edx
  8038cd:	89 d1                	mov    %edx,%ecx
  8038cf:	89 c6                	mov    %eax,%esi
  8038d1:	e9 71 ff ff ff       	jmp    803847 <__umoddi3+0xb3>
  8038d6:	66 90                	xchg   %ax,%ax
  8038d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038dc:	72 ea                	jb     8038c8 <__umoddi3+0x134>
  8038de:	89 d9                	mov    %ebx,%ecx
  8038e0:	e9 62 ff ff ff       	jmp    803847 <__umoddi3+0xb3>
