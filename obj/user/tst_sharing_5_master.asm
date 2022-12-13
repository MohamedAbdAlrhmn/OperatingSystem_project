
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
  80008d:	68 20 39 80 00       	push   $0x803920
  800092:	6a 12                	push   $0x12
  800094:	68 3c 39 80 00       	push   $0x80393c
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
  8000ae:	68 58 39 80 00       	push   $0x803958
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 8c 39 80 00       	push   $0x80398c
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 e8 39 80 00       	push   $0x8039e8
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 1a 1c 00 00       	call   801cfa <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 1c 3a 80 00       	push   $0x803a1c
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
  80011d:	68 5d 3a 80 00       	push   $0x803a5d
  800122:	e8 7e 1b 00 00       	call   801ca5 <sys_create_env>
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
  800150:	68 5d 3a 80 00       	push   $0x803a5d
  800155:	e8 4b 1b 00 00       	call   801ca5 <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 ce 18 00 00       	call   801a33 <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 68 3a 80 00       	push   $0x803a68
  800177:	e8 52 16 00 00       	call   8017ce <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 6c 3a 80 00       	push   $0x803a6c
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 8c 3a 80 00       	push   $0x803a8c
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 3c 39 80 00       	push   $0x80393c
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 7c 18 00 00       	call   801a33 <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 f8 3a 80 00       	push   $0x803af8
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 3c 39 80 00       	push   $0x80393c
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 18 1c 00 00       	call   801df1 <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 df 1a 00 00       	call   801cc3 <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 d1 1a 00 00       	call   801cc3 <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 76 3b 80 00       	push   $0x803b76
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 e3 33 00 00       	call   8035f5 <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 50 1c 00 00       	call   801e6b <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 0e 18 00 00       	call   801a33 <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 a0 16 00 00       	call   8018d3 <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 90 3b 80 00       	push   $0x803b90
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 e8 17 00 00       	call   801a33 <sys_calculate_free_frames>
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
  80026f:	68 b0 3b 80 00       	push   $0x803bb0
  800274:	6a 3b                	push   $0x3b
  800276:	68 3c 39 80 00       	push   $0x80393c
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 f8 3b 80 00       	push   $0x803bf8
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 1c 3c 80 00       	push   $0x803c1c
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
  8002c3:	68 4c 3c 80 00       	push   $0x803c4c
  8002c8:	e8 d8 19 00 00       	call   801ca5 <sys_create_env>
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
  8002f6:	68 59 3c 80 00       	push   $0x803c59
  8002fb:	e8 a5 19 00 00       	call   801ca5 <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 66 3c 80 00       	push   $0x803c66
  800315:	e8 b4 14 00 00       	call   8017ce <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 68 3c 80 00       	push   $0x803c68
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 68 3a 80 00       	push   $0x803a68
  80033f:	e8 8a 14 00 00       	call   8017ce <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 6c 3a 80 00       	push   $0x803a6c
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 92 1a 00 00       	call   801df1 <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 59 19 00 00       	call   801cc3 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 4b 19 00 00       	call   801cc3 <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 ea 1a 00 00       	call   801e6b <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 66 1a 00 00       	call   801df1 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 a3 16 00 00       	call   801a33 <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 35 15 00 00       	call   8018d3 <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 88 3c 80 00       	push   $0x803c88
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 17 15 00 00       	call   8018d3 <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 9e 3c 80 00       	push   $0x803c9e
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 5f 16 00 00       	call   801a33 <sys_calculate_free_frames>
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
  8003f2:	68 b4 3c 80 00       	push   $0x803cb4
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 3c 39 80 00       	push   $0x80393c
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 49 1a 00 00       	call   801e51 <inctst>


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
  800414:	e8 fa 18 00 00       	call   801d13 <sys_getenvindex>
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
  80047f:	e8 9c 16 00 00       	call   801b20 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 74 3d 80 00       	push   $0x803d74
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
  8004af:	68 9c 3d 80 00       	push   $0x803d9c
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
  8004e0:	68 c4 3d 80 00       	push   $0x803dc4
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 1c 3e 80 00       	push   $0x803e1c
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 74 3d 80 00       	push   $0x803d74
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 1c 16 00 00       	call   801b3a <sys_enable_interrupt>

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
  800531:	e8 a9 17 00 00       	call   801cdf <sys_destroy_env>
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
  800542:	e8 fe 17 00 00       	call   801d45 <sys_exit_env>
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
  80056b:	68 30 3e 80 00       	push   $0x803e30
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 35 3e 80 00       	push   $0x803e35
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
  8005a8:	68 51 3e 80 00       	push   $0x803e51
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
  8005d4:	68 54 3e 80 00       	push   $0x803e54
  8005d9:	6a 26                	push   $0x26
  8005db:	68 a0 3e 80 00       	push   $0x803ea0
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
  8006a6:	68 ac 3e 80 00       	push   $0x803eac
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 a0 3e 80 00       	push   $0x803ea0
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
  800716:	68 00 3f 80 00       	push   $0x803f00
  80071b:	6a 44                	push   $0x44
  80071d:	68 a0 3e 80 00       	push   $0x803ea0
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
  800770:	e8 fd 11 00 00       	call   801972 <sys_cputs>
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
  8007e7:	e8 86 11 00 00       	call   801972 <sys_cputs>
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
  800831:	e8 ea 12 00 00       	call   801b20 <sys_disable_interrupt>
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
  800851:	e8 e4 12 00 00       	call   801b3a <sys_enable_interrupt>
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
  80089b:	e8 0c 2e 00 00       	call   8036ac <__udivdi3>
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
  8008eb:	e8 cc 2e 00 00       	call   8037bc <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 74 41 80 00       	add    $0x804174,%eax
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
  800a46:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
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
  800b27:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 85 41 80 00       	push   $0x804185
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
  800b4c:	68 8e 41 80 00       	push   $0x80418e
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
  800b79:	be 91 41 80 00       	mov    $0x804191,%esi
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
  80159f:	68 f0 42 80 00       	push   $0x8042f0
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
  80166f:	e8 42 04 00 00       	call   801ab6 <sys_allocate_chunk>
  801674:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801677:	a1 20 51 80 00       	mov    0x805120,%eax
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	50                   	push   %eax
  801680:	e8 b7 0a 00 00       	call   80213c <initialize_MemBlocksList>
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
  8016ad:	68 15 43 80 00       	push   $0x804315
  8016b2:	6a 33                	push   $0x33
  8016b4:	68 33 43 80 00       	push   $0x804333
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
  80172c:	68 40 43 80 00       	push   $0x804340
  801731:	6a 34                	push   $0x34
  801733:	68 33 43 80 00       	push   $0x804333
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
  8017a1:	68 64 43 80 00       	push   $0x804364
  8017a6:	6a 46                	push   $0x46
  8017a8:	68 33 43 80 00       	push   $0x804333
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
  8017bd:	68 8c 43 80 00       	push   $0x80438c
  8017c2:	6a 61                	push   $0x61
  8017c4:	68 33 43 80 00       	push   $0x804333
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
  8017e3:	75 0a                	jne    8017ef <smalloc+0x21>
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ea:	e9 9e 00 00 00       	jmp    80188d <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017ef:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fc:	01 d0                	add    %edx,%eax
  8017fe:	48                   	dec    %eax
  8017ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801805:	ba 00 00 00 00       	mov    $0x0,%edx
  80180a:	f7 75 f0             	divl   -0x10(%ebp)
  80180d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801810:	29 d0                	sub    %edx,%eax
  801812:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801815:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80181c:	e8 63 06 00 00       	call   801e84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801821:	85 c0                	test   %eax,%eax
  801823:	74 11                	je     801836 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801825:	83 ec 0c             	sub    $0xc,%esp
  801828:	ff 75 e8             	pushl  -0x18(%ebp)
  80182b:	e8 ce 0c 00 00       	call   8024fe <alloc_block_FF>
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80183a:	74 4c                	je     801888 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183f:	8b 40 08             	mov    0x8(%eax),%eax
  801842:	89 c2                	mov    %eax,%edx
  801844:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801848:	52                   	push   %edx
  801849:	50                   	push   %eax
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	e8 b4 03 00 00       	call   801c09 <sys_createSharedObject>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  80185b:	83 ec 08             	sub    $0x8,%esp
  80185e:	ff 75 e0             	pushl  -0x20(%ebp)
  801861:	68 af 43 80 00       	push   $0x8043af
  801866:	e8 93 ef ff ff       	call   8007fe <cprintf>
  80186b:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80186e:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801872:	74 14                	je     801888 <smalloc+0xba>
  801874:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801878:	74 0e                	je     801888 <smalloc+0xba>
  80187a:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80187e:	74 08                	je     801888 <smalloc+0xba>
			return (void*) mem_block->sva;
  801880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801883:	8b 40 08             	mov    0x8(%eax),%eax
  801886:	eb 05                	jmp    80188d <smalloc+0xbf>
	}
	return NULL;
  801888:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801895:	e8 ee fc ff ff       	call   801588 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80189a:	83 ec 04             	sub    $0x4,%esp
  80189d:	68 c4 43 80 00       	push   $0x8043c4
  8018a2:	68 ab 00 00 00       	push   $0xab
  8018a7:	68 33 43 80 00       	push   $0x804333
  8018ac:	e8 99 ec ff ff       	call   80054a <_panic>

008018b1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018b7:	e8 cc fc ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	68 e8 43 80 00       	push   $0x8043e8
  8018c4:	68 ef 00 00 00       	push   $0xef
  8018c9:	68 33 43 80 00       	push   $0x804333
  8018ce:	e8 77 ec ff ff       	call   80054a <_panic>

008018d3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018d9:	83 ec 04             	sub    $0x4,%esp
  8018dc:	68 10 44 80 00       	push   $0x804410
  8018e1:	68 03 01 00 00       	push   $0x103
  8018e6:	68 33 43 80 00       	push   $0x804333
  8018eb:	e8 5a ec ff ff       	call   80054a <_panic>

008018f0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f6:	83 ec 04             	sub    $0x4,%esp
  8018f9:	68 34 44 80 00       	push   $0x804434
  8018fe:	68 0e 01 00 00       	push   $0x10e
  801903:	68 33 43 80 00       	push   $0x804333
  801908:	e8 3d ec ff ff       	call   80054a <_panic>

0080190d <shrink>:

}
void shrink(uint32 newSize)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801913:	83 ec 04             	sub    $0x4,%esp
  801916:	68 34 44 80 00       	push   $0x804434
  80191b:	68 13 01 00 00       	push   $0x113
  801920:	68 33 43 80 00       	push   $0x804333
  801925:	e8 20 ec ff ff       	call   80054a <_panic>

0080192a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801930:	83 ec 04             	sub    $0x4,%esp
  801933:	68 34 44 80 00       	push   $0x804434
  801938:	68 18 01 00 00       	push   $0x118
  80193d:	68 33 43 80 00       	push   $0x804333
  801942:	e8 03 ec ff ff       	call   80054a <_panic>

00801947 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	57                   	push   %edi
  80194b:	56                   	push   %esi
  80194c:	53                   	push   %ebx
  80194d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801959:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80195c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80195f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801962:	cd 30                	int    $0x30
  801964:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801967:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80196a:	83 c4 10             	add    $0x10,%esp
  80196d:	5b                   	pop    %ebx
  80196e:	5e                   	pop    %esi
  80196f:	5f                   	pop    %edi
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    

00801972 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 04             	sub    $0x4,%esp
  801978:	8b 45 10             	mov    0x10(%ebp),%eax
  80197b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80197e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	52                   	push   %edx
  80198a:	ff 75 0c             	pushl  0xc(%ebp)
  80198d:	50                   	push   %eax
  80198e:	6a 00                	push   $0x0
  801990:	e8 b2 ff ff ff       	call   801947 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_cgetc>:

int
sys_cgetc(void)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 01                	push   $0x1
  8019aa:	e8 98 ff ff ff       	call   801947 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 05                	push   $0x5
  8019c7:	e8 7b ff ff ff       	call   801947 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	56                   	push   %esi
  8019d5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8019d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
  8019e7:	51                   	push   %ecx
  8019e8:	52                   	push   %edx
  8019e9:	50                   	push   %eax
  8019ea:	6a 06                	push   $0x6
  8019ec:	e8 56 ff ff ff       	call   801947 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    

008019fb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	52                   	push   %edx
  801a0b:	50                   	push   %eax
  801a0c:	6a 07                	push   $0x7
  801a0e:	e8 34 ff ff ff       	call   801947 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	ff 75 08             	pushl  0x8(%ebp)
  801a27:	6a 08                	push   $0x8
  801a29:	e8 19 ff ff ff       	call   801947 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 09                	push   $0x9
  801a42:	e8 00 ff ff ff       	call   801947 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 0a                	push   $0xa
  801a5b:	e8 e7 fe ff ff       	call   801947 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 0b                	push   $0xb
  801a74:	e8 ce fe ff ff       	call   801947 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	ff 75 08             	pushl  0x8(%ebp)
  801a8d:	6a 0f                	push   $0xf
  801a8f:	e8 b3 fe ff ff       	call   801947 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
	return;
  801a97:	90                   	nop
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	6a 10                	push   $0x10
  801aab:	e8 97 fe ff ff       	call   801947 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab3:	90                   	nop
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	ff 75 10             	pushl  0x10(%ebp)
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	ff 75 08             	pushl  0x8(%ebp)
  801ac6:	6a 11                	push   $0x11
  801ac8:	e8 7a fe ff ff       	call   801947 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad0:	90                   	nop
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 0c                	push   $0xc
  801ae2:	e8 60 fe ff ff       	call   801947 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	ff 75 08             	pushl  0x8(%ebp)
  801afa:	6a 0d                	push   $0xd
  801afc:	e8 46 fe ff ff       	call   801947 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 0e                	push   $0xe
  801b15:	e8 2d fe ff ff       	call   801947 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 13                	push   $0x13
  801b2f:	e8 13 fe ff ff       	call   801947 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	90                   	nop
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 14                	push   $0x14
  801b49:	e8 f9 fd ff ff       	call   801947 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	90                   	nop
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 04             	sub    $0x4,%esp
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	50                   	push   %eax
  801b6d:	6a 15                	push   $0x15
  801b6f:	e8 d3 fd ff ff       	call   801947 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	90                   	nop
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 16                	push   $0x16
  801b89:	e8 b9 fd ff ff       	call   801947 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	90                   	nop
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	ff 75 0c             	pushl  0xc(%ebp)
  801ba3:	50                   	push   %eax
  801ba4:	6a 17                	push   $0x17
  801ba6:	e8 9c fd ff ff       	call   801947 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	52                   	push   %edx
  801bc0:	50                   	push   %eax
  801bc1:	6a 1a                	push   $0x1a
  801bc3:	e8 7f fd ff ff       	call   801947 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	52                   	push   %edx
  801bdd:	50                   	push   %eax
  801bde:	6a 18                	push   $0x18
  801be0:	e8 62 fd ff ff       	call   801947 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	90                   	nop
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	6a 19                	push   $0x19
  801bfe:	e8 44 fd ff ff       	call   801947 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	90                   	nop
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c12:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c15:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c18:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	51                   	push   %ecx
  801c22:	52                   	push   %edx
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	50                   	push   %eax
  801c27:	6a 1b                	push   $0x1b
  801c29:	e8 19 fd ff ff       	call   801947 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	52                   	push   %edx
  801c43:	50                   	push   %eax
  801c44:	6a 1c                	push   $0x1c
  801c46:	e8 fc fc ff ff       	call   801947 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	51                   	push   %ecx
  801c61:	52                   	push   %edx
  801c62:	50                   	push   %eax
  801c63:	6a 1d                	push   $0x1d
  801c65:	e8 dd fc ff ff       	call   801947 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	6a 1e                	push   $0x1e
  801c82:	e8 c0 fc ff ff       	call   801947 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 1f                	push   $0x1f
  801c9b:	e8 a7 fc ff ff       	call   801947 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	ff 75 14             	pushl  0x14(%ebp)
  801cb0:	ff 75 10             	pushl  0x10(%ebp)
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	50                   	push   %eax
  801cb7:	6a 20                	push   $0x20
  801cb9:	e8 89 fc ff ff       	call   801947 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	50                   	push   %eax
  801cd2:	6a 21                	push   $0x21
  801cd4:	e8 6e fc ff ff       	call   801947 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	90                   	nop
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	50                   	push   %eax
  801cee:	6a 22                	push   $0x22
  801cf0:	e8 52 fc ff ff       	call   801947 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 02                	push   $0x2
  801d09:	e8 39 fc ff ff       	call   801947 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 03                	push   $0x3
  801d22:	e8 20 fc ff ff       	call   801947 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 04                	push   $0x4
  801d3b:	e8 07 fc ff ff       	call   801947 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_exit_env>:


void sys_exit_env(void)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 23                	push   $0x23
  801d54:	e8 ee fb ff ff       	call   801947 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	90                   	nop
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d68:	8d 50 04             	lea    0x4(%eax),%edx
  801d6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	52                   	push   %edx
  801d75:	50                   	push   %eax
  801d76:	6a 24                	push   $0x24
  801d78:	e8 ca fb ff ff       	call   801947 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
	return result;
  801d80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d89:	89 01                	mov    %eax,(%ecx)
  801d8b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	c9                   	leave  
  801d92:	c2 04 00             	ret    $0x4

00801d95 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	ff 75 10             	pushl  0x10(%ebp)
  801d9f:	ff 75 0c             	pushl  0xc(%ebp)
  801da2:	ff 75 08             	pushl  0x8(%ebp)
  801da5:	6a 12                	push   $0x12
  801da7:	e8 9b fb ff ff       	call   801947 <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
	return ;
  801daf:	90                   	nop
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 25                	push   $0x25
  801dc1:	e8 81 fb ff ff       	call   801947 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 04             	sub    $0x4,%esp
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dd7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	50                   	push   %eax
  801de4:	6a 26                	push   $0x26
  801de6:	e8 5c fb ff ff       	call   801947 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dee:	90                   	nop
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <rsttst>:
void rsttst()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 28                	push   $0x28
  801e00:	e8 42 fb ff ff       	call   801947 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
	return ;
  801e08:	90                   	nop
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	83 ec 04             	sub    $0x4,%esp
  801e11:	8b 45 14             	mov    0x14(%ebp),%eax
  801e14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e17:	8b 55 18             	mov    0x18(%ebp),%edx
  801e1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e1e:	52                   	push   %edx
  801e1f:	50                   	push   %eax
  801e20:	ff 75 10             	pushl  0x10(%ebp)
  801e23:	ff 75 0c             	pushl  0xc(%ebp)
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	6a 27                	push   $0x27
  801e2b:	e8 17 fb ff ff       	call   801947 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
	return ;
  801e33:	90                   	nop
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <chktst>:
void chktst(uint32 n)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 08             	pushl  0x8(%ebp)
  801e44:	6a 29                	push   $0x29
  801e46:	e8 fc fa ff ff       	call   801947 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4e:	90                   	nop
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <inctst>:

void inctst()
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 2a                	push   $0x2a
  801e60:	e8 e2 fa ff ff       	call   801947 <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
	return ;
  801e68:	90                   	nop
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <gettst>:
uint32 gettst()
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 2b                	push   $0x2b
  801e7a:	e8 c8 fa ff ff       	call   801947 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 2c                	push   $0x2c
  801e96:	e8 ac fa ff ff       	call   801947 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
  801e9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ea1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ea5:	75 07                	jne    801eae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ea7:	b8 01 00 00 00       	mov    $0x1,%eax
  801eac:	eb 05                	jmp    801eb3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 2c                	push   $0x2c
  801ec7:	e8 7b fa ff ff       	call   801947 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
  801ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ed2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ed6:	75 07                	jne    801edf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ed8:	b8 01 00 00 00       	mov    $0x1,%eax
  801edd:	eb 05                	jmp    801ee4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 2c                	push   $0x2c
  801ef8:	e8 4a fa ff ff       	call   801947 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
  801f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f03:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f07:	75 07                	jne    801f10 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f09:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0e:	eb 05                	jmp    801f15 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 2c                	push   $0x2c
  801f29:	e8 19 fa ff ff       	call   801947 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
  801f31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f34:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f38:	75 07                	jne    801f41 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3f:	eb 05                	jmp    801f46 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	ff 75 08             	pushl  0x8(%ebp)
  801f56:	6a 2d                	push   $0x2d
  801f58:	e8 ea f9 ff ff       	call   801947 <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f60:	90                   	nop
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	53                   	push   %ebx
  801f76:	51                   	push   %ecx
  801f77:	52                   	push   %edx
  801f78:	50                   	push   %eax
  801f79:	6a 2e                	push   $0x2e
  801f7b:	e8 c7 f9 ff ff       	call   801947 <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	52                   	push   %edx
  801f98:	50                   	push   %eax
  801f99:	6a 2f                	push   $0x2f
  801f9b:	e8 a7 f9 ff ff       	call   801947 <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	68 44 44 80 00       	push   $0x804444
  801fb3:	e8 46 e8 ff ff       	call   8007fe <cprintf>
  801fb8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	68 70 44 80 00       	push   $0x804470
  801fca:	e8 2f e8 ff ff       	call   8007fe <cprintf>
  801fcf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fd2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fd6:	a1 38 51 80 00       	mov    0x805138,%eax
  801fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fde:	eb 56                	jmp    802036 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe4:	74 1c                	je     802002 <print_mem_block_lists+0x5d>
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	8b 50 08             	mov    0x8(%eax),%edx
  801fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fef:	8b 48 08             	mov    0x8(%eax),%ecx
  801ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff8:	01 c8                	add    %ecx,%eax
  801ffa:	39 c2                	cmp    %eax,%edx
  801ffc:	73 04                	jae    802002 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ffe:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 50 08             	mov    0x8(%eax),%edx
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	8b 40 0c             	mov    0xc(%eax),%eax
  80200e:	01 c2                	add    %eax,%edx
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	8b 40 08             	mov    0x8(%eax),%eax
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	52                   	push   %edx
  80201a:	50                   	push   %eax
  80201b:	68 85 44 80 00       	push   $0x804485
  802020:	e8 d9 e7 ff ff       	call   8007fe <cprintf>
  802025:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80202e:	a1 40 51 80 00       	mov    0x805140,%eax
  802033:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802036:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203a:	74 07                	je     802043 <print_mem_block_lists+0x9e>
  80203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203f:	8b 00                	mov    (%eax),%eax
  802041:	eb 05                	jmp    802048 <print_mem_block_lists+0xa3>
  802043:	b8 00 00 00 00       	mov    $0x0,%eax
  802048:	a3 40 51 80 00       	mov    %eax,0x805140
  80204d:	a1 40 51 80 00       	mov    0x805140,%eax
  802052:	85 c0                	test   %eax,%eax
  802054:	75 8a                	jne    801fe0 <print_mem_block_lists+0x3b>
  802056:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205a:	75 84                	jne    801fe0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80205c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802060:	75 10                	jne    802072 <print_mem_block_lists+0xcd>
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	68 94 44 80 00       	push   $0x804494
  80206a:	e8 8f e7 ff ff       	call   8007fe <cprintf>
  80206f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802072:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802079:	83 ec 0c             	sub    $0xc,%esp
  80207c:	68 b8 44 80 00       	push   $0x8044b8
  802081:	e8 78 e7 ff ff       	call   8007fe <cprintf>
  802086:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802089:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80208d:	a1 40 50 80 00       	mov    0x805040,%eax
  802092:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802095:	eb 56                	jmp    8020ed <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802097:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80209b:	74 1c                	je     8020b9 <print_mem_block_lists+0x114>
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 50 08             	mov    0x8(%eax),%edx
  8020a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a6:	8b 48 08             	mov    0x8(%eax),%ecx
  8020a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8020af:	01 c8                	add    %ecx,%eax
  8020b1:	39 c2                	cmp    %eax,%edx
  8020b3:	73 04                	jae    8020b9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020b5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bc:	8b 50 08             	mov    0x8(%eax),%edx
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c5:	01 c2                	add    %eax,%edx
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	8b 40 08             	mov    0x8(%eax),%eax
  8020cd:	83 ec 04             	sub    $0x4,%esp
  8020d0:	52                   	push   %edx
  8020d1:	50                   	push   %eax
  8020d2:	68 85 44 80 00       	push   $0x804485
  8020d7:	e8 22 e7 ff ff       	call   8007fe <cprintf>
  8020dc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020e5:	a1 48 50 80 00       	mov    0x805048,%eax
  8020ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f1:	74 07                	je     8020fa <print_mem_block_lists+0x155>
  8020f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f6:	8b 00                	mov    (%eax),%eax
  8020f8:	eb 05                	jmp    8020ff <print_mem_block_lists+0x15a>
  8020fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ff:	a3 48 50 80 00       	mov    %eax,0x805048
  802104:	a1 48 50 80 00       	mov    0x805048,%eax
  802109:	85 c0                	test   %eax,%eax
  80210b:	75 8a                	jne    802097 <print_mem_block_lists+0xf2>
  80210d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802111:	75 84                	jne    802097 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802113:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802117:	75 10                	jne    802129 <print_mem_block_lists+0x184>
  802119:	83 ec 0c             	sub    $0xc,%esp
  80211c:	68 d0 44 80 00       	push   $0x8044d0
  802121:	e8 d8 e6 ff ff       	call   8007fe <cprintf>
  802126:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802129:	83 ec 0c             	sub    $0xc,%esp
  80212c:	68 44 44 80 00       	push   $0x804444
  802131:	e8 c8 e6 ff ff       	call   8007fe <cprintf>
  802136:	83 c4 10             	add    $0x10,%esp

}
  802139:	90                   	nop
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802142:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802149:	00 00 00 
  80214c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802153:	00 00 00 
  802156:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80215d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802160:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802167:	e9 9e 00 00 00       	jmp    80220a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80216c:	a1 50 50 80 00       	mov    0x805050,%eax
  802171:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802174:	c1 e2 04             	shl    $0x4,%edx
  802177:	01 d0                	add    %edx,%eax
  802179:	85 c0                	test   %eax,%eax
  80217b:	75 14                	jne    802191 <initialize_MemBlocksList+0x55>
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	68 f8 44 80 00       	push   $0x8044f8
  802185:	6a 46                	push   $0x46
  802187:	68 1b 45 80 00       	push   $0x80451b
  80218c:	e8 b9 e3 ff ff       	call   80054a <_panic>
  802191:	a1 50 50 80 00       	mov    0x805050,%eax
  802196:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802199:	c1 e2 04             	shl    $0x4,%edx
  80219c:	01 d0                	add    %edx,%eax
  80219e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021a4:	89 10                	mov    %edx,(%eax)
  8021a6:	8b 00                	mov    (%eax),%eax
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	74 18                	je     8021c4 <initialize_MemBlocksList+0x88>
  8021ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8021b1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021b7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021ba:	c1 e1 04             	shl    $0x4,%ecx
  8021bd:	01 ca                	add    %ecx,%edx
  8021bf:	89 50 04             	mov    %edx,0x4(%eax)
  8021c2:	eb 12                	jmp    8021d6 <initialize_MemBlocksList+0x9a>
  8021c4:	a1 50 50 80 00       	mov    0x805050,%eax
  8021c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021cc:	c1 e2 04             	shl    $0x4,%edx
  8021cf:	01 d0                	add    %edx,%eax
  8021d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021d6:	a1 50 50 80 00       	mov    0x805050,%eax
  8021db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021de:	c1 e2 04             	shl    $0x4,%edx
  8021e1:	01 d0                	add    %edx,%eax
  8021e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8021e8:	a1 50 50 80 00       	mov    0x805050,%eax
  8021ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f0:	c1 e2 04             	shl    $0x4,%edx
  8021f3:	01 d0                	add    %edx,%eax
  8021f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021fc:	a1 54 51 80 00       	mov    0x805154,%eax
  802201:	40                   	inc    %eax
  802202:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802207:	ff 45 f4             	incl   -0xc(%ebp)
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802210:	0f 82 56 ff ff ff    	jb     80216c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802216:	90                   	nop
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	8b 00                	mov    (%eax),%eax
  802224:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802227:	eb 19                	jmp    802242 <find_block+0x29>
	{
		if(va==point->sva)
  802229:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222c:	8b 40 08             	mov    0x8(%eax),%eax
  80222f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802232:	75 05                	jne    802239 <find_block+0x20>
		   return point;
  802234:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802237:	eb 36                	jmp    80226f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8b 40 08             	mov    0x8(%eax),%eax
  80223f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802242:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802246:	74 07                	je     80224f <find_block+0x36>
  802248:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224b:	8b 00                	mov    (%eax),%eax
  80224d:	eb 05                	jmp    802254 <find_block+0x3b>
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
  802254:	8b 55 08             	mov    0x8(%ebp),%edx
  802257:	89 42 08             	mov    %eax,0x8(%edx)
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	8b 40 08             	mov    0x8(%eax),%eax
  802260:	85 c0                	test   %eax,%eax
  802262:	75 c5                	jne    802229 <find_block+0x10>
  802264:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802268:	75 bf                	jne    802229 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802277:	a1 40 50 80 00       	mov    0x805040,%eax
  80227c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80227f:	a1 44 50 80 00       	mov    0x805044,%eax
  802284:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80228d:	74 24                	je     8022b3 <insert_sorted_allocList+0x42>
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	8b 50 08             	mov    0x8(%eax),%edx
  802295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802298:	8b 40 08             	mov    0x8(%eax),%eax
  80229b:	39 c2                	cmp    %eax,%edx
  80229d:	76 14                	jbe    8022b3 <insert_sorted_allocList+0x42>
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	8b 50 08             	mov    0x8(%eax),%edx
  8022a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a8:	8b 40 08             	mov    0x8(%eax),%eax
  8022ab:	39 c2                	cmp    %eax,%edx
  8022ad:	0f 82 60 01 00 00    	jb     802413 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b7:	75 65                	jne    80231e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022bd:	75 14                	jne    8022d3 <insert_sorted_allocList+0x62>
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	68 f8 44 80 00       	push   $0x8044f8
  8022c7:	6a 6b                	push   $0x6b
  8022c9:	68 1b 45 80 00       	push   $0x80451b
  8022ce:	e8 77 e2 ff ff       	call   80054a <_panic>
  8022d3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	89 10                	mov    %edx,(%eax)
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	8b 00                	mov    (%eax),%eax
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	74 0d                	je     8022f4 <insert_sorted_allocList+0x83>
  8022e7:	a1 40 50 80 00       	mov    0x805040,%eax
  8022ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ef:	89 50 04             	mov    %edx,0x4(%eax)
  8022f2:	eb 08                	jmp    8022fc <insert_sorted_allocList+0x8b>
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 44 50 80 00       	mov    %eax,0x805044
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	a3 40 50 80 00       	mov    %eax,0x805040
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802313:	40                   	inc    %eax
  802314:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802319:	e9 dc 01 00 00       	jmp    8024fa <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8b 50 08             	mov    0x8(%eax),%edx
  802324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802327:	8b 40 08             	mov    0x8(%eax),%eax
  80232a:	39 c2                	cmp    %eax,%edx
  80232c:	77 6c                	ja     80239a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80232e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802332:	74 06                	je     80233a <insert_sorted_allocList+0xc9>
  802334:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802338:	75 14                	jne    80234e <insert_sorted_allocList+0xdd>
  80233a:	83 ec 04             	sub    $0x4,%esp
  80233d:	68 34 45 80 00       	push   $0x804534
  802342:	6a 6f                	push   $0x6f
  802344:	68 1b 45 80 00       	push   $0x80451b
  802349:	e8 fc e1 ff ff       	call   80054a <_panic>
  80234e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802351:	8b 50 04             	mov    0x4(%eax),%edx
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	89 50 04             	mov    %edx,0x4(%eax)
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802360:	89 10                	mov    %edx,(%eax)
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	74 0d                	je     802379 <insert_sorted_allocList+0x108>
  80236c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	8b 55 08             	mov    0x8(%ebp),%edx
  802375:	89 10                	mov    %edx,(%eax)
  802377:	eb 08                	jmp    802381 <insert_sorted_allocList+0x110>
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	a3 40 50 80 00       	mov    %eax,0x805040
  802381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802384:	8b 55 08             	mov    0x8(%ebp),%edx
  802387:	89 50 04             	mov    %edx,0x4(%eax)
  80238a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80238f:	40                   	inc    %eax
  802390:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802395:	e9 60 01 00 00       	jmp    8024fa <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	8b 50 08             	mov    0x8(%eax),%edx
  8023a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a3:	8b 40 08             	mov    0x8(%eax),%eax
  8023a6:	39 c2                	cmp    %eax,%edx
  8023a8:	0f 82 4c 01 00 00    	jb     8024fa <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b2:	75 14                	jne    8023c8 <insert_sorted_allocList+0x157>
  8023b4:	83 ec 04             	sub    $0x4,%esp
  8023b7:	68 6c 45 80 00       	push   $0x80456c
  8023bc:	6a 73                	push   $0x73
  8023be:	68 1b 45 80 00       	push   $0x80451b
  8023c3:	e8 82 e1 ff ff       	call   80054a <_panic>
  8023c8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	89 50 04             	mov    %edx,0x4(%eax)
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	8b 40 04             	mov    0x4(%eax),%eax
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	74 0c                	je     8023ea <insert_sorted_allocList+0x179>
  8023de:	a1 44 50 80 00       	mov    0x805044,%eax
  8023e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e6:	89 10                	mov    %edx,(%eax)
  8023e8:	eb 08                	jmp    8023f2 <insert_sorted_allocList+0x181>
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	a3 40 50 80 00       	mov    %eax,0x805040
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	a3 44 50 80 00       	mov    %eax,0x805044
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802403:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802408:	40                   	inc    %eax
  802409:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80240e:	e9 e7 00 00 00       	jmp    8024fa <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802416:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802419:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802420:	a1 40 50 80 00       	mov    0x805040,%eax
  802425:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802428:	e9 9d 00 00 00       	jmp    8024ca <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	8b 50 08             	mov    0x8(%eax),%edx
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 08             	mov    0x8(%eax),%eax
  802441:	39 c2                	cmp    %eax,%edx
  802443:	76 7d                	jbe    8024c2 <insert_sorted_allocList+0x251>
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	8b 50 08             	mov    0x8(%eax),%edx
  80244b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244e:	8b 40 08             	mov    0x8(%eax),%eax
  802451:	39 c2                	cmp    %eax,%edx
  802453:	73 6d                	jae    8024c2 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802459:	74 06                	je     802461 <insert_sorted_allocList+0x1f0>
  80245b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80245f:	75 14                	jne    802475 <insert_sorted_allocList+0x204>
  802461:	83 ec 04             	sub    $0x4,%esp
  802464:	68 90 45 80 00       	push   $0x804590
  802469:	6a 7f                	push   $0x7f
  80246b:	68 1b 45 80 00       	push   $0x80451b
  802470:	e8 d5 e0 ff ff       	call   80054a <_panic>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 10                	mov    (%eax),%edx
  80247a:	8b 45 08             	mov    0x8(%ebp),%eax
  80247d:	89 10                	mov    %edx,(%eax)
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	8b 00                	mov    (%eax),%eax
  802484:	85 c0                	test   %eax,%eax
  802486:	74 0b                	je     802493 <insert_sorted_allocList+0x222>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	8b 55 08             	mov    0x8(%ebp),%edx
  802490:	89 50 04             	mov    %edx,0x4(%eax)
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 55 08             	mov    0x8(%ebp),%edx
  802499:	89 10                	mov    %edx,(%eax)
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a1:	89 50 04             	mov    %edx,0x4(%eax)
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	75 08                	jne    8024b5 <insert_sorted_allocList+0x244>
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	a3 44 50 80 00       	mov    %eax,0x805044
  8024b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024ba:	40                   	inc    %eax
  8024bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024c0:	eb 39                	jmp    8024fb <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024c2:	a1 48 50 80 00       	mov    0x805048,%eax
  8024c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ce:	74 07                	je     8024d7 <insert_sorted_allocList+0x266>
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	eb 05                	jmp    8024dc <insert_sorted_allocList+0x26b>
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dc:	a3 48 50 80 00       	mov    %eax,0x805048
  8024e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	0f 85 3f ff ff ff    	jne    80242d <insert_sorted_allocList+0x1bc>
  8024ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f2:	0f 85 35 ff ff ff    	jne    80242d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024f8:	eb 01                	jmp    8024fb <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024fa:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024fb:	90                   	nop
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802504:	a1 38 51 80 00       	mov    0x805138,%eax
  802509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250c:	e9 85 01 00 00       	jmp    802696 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 40 0c             	mov    0xc(%eax),%eax
  802517:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251a:	0f 82 6e 01 00 00    	jb     80268e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 0c             	mov    0xc(%eax),%eax
  802526:	3b 45 08             	cmp    0x8(%ebp),%eax
  802529:	0f 85 8a 00 00 00    	jne    8025b9 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80252f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802533:	75 17                	jne    80254c <alloc_block_FF+0x4e>
  802535:	83 ec 04             	sub    $0x4,%esp
  802538:	68 c4 45 80 00       	push   $0x8045c4
  80253d:	68 93 00 00 00       	push   $0x93
  802542:	68 1b 45 80 00       	push   $0x80451b
  802547:	e8 fe df ff ff       	call   80054a <_panic>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	74 10                	je     802565 <alloc_block_FF+0x67>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255d:	8b 52 04             	mov    0x4(%edx),%edx
  802560:	89 50 04             	mov    %edx,0x4(%eax)
  802563:	eb 0b                	jmp    802570 <alloc_block_FF+0x72>
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 40 04             	mov    0x4(%eax),%eax
  80256b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 40 04             	mov    0x4(%eax),%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	74 0f                	je     802589 <alloc_block_FF+0x8b>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 40 04             	mov    0x4(%eax),%eax
  802580:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802583:	8b 12                	mov    (%edx),%edx
  802585:	89 10                	mov    %edx,(%eax)
  802587:	eb 0a                	jmp    802593 <alloc_block_FF+0x95>
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 00                	mov    (%eax),%eax
  80258e:	a3 38 51 80 00       	mov    %eax,0x805138
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8025ab:	48                   	dec    %eax
  8025ac:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	e9 10 01 00 00       	jmp    8026c9 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c2:	0f 86 c6 00 00 00    	jbe    80268e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8025cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 50 08             	mov    0x8(%eax),%edx
  8025d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025df:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e9:	75 17                	jne    802602 <alloc_block_FF+0x104>
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	68 c4 45 80 00       	push   $0x8045c4
  8025f3:	68 9b 00 00 00       	push   $0x9b
  8025f8:	68 1b 45 80 00       	push   $0x80451b
  8025fd:	e8 48 df ff ff       	call   80054a <_panic>
  802602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	85 c0                	test   %eax,%eax
  802609:	74 10                	je     80261b <alloc_block_FF+0x11d>
  80260b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260e:	8b 00                	mov    (%eax),%eax
  802610:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802613:	8b 52 04             	mov    0x4(%edx),%edx
  802616:	89 50 04             	mov    %edx,0x4(%eax)
  802619:	eb 0b                	jmp    802626 <alloc_block_FF+0x128>
  80261b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802629:	8b 40 04             	mov    0x4(%eax),%eax
  80262c:	85 c0                	test   %eax,%eax
  80262e:	74 0f                	je     80263f <alloc_block_FF+0x141>
  802630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802633:	8b 40 04             	mov    0x4(%eax),%eax
  802636:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802639:	8b 12                	mov    (%edx),%edx
  80263b:	89 10                	mov    %edx,(%eax)
  80263d:	eb 0a                	jmp    802649 <alloc_block_FF+0x14b>
  80263f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802642:	8b 00                	mov    (%eax),%eax
  802644:	a3 48 51 80 00       	mov    %eax,0x805148
  802649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802655:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265c:	a1 54 51 80 00       	mov    0x805154,%eax
  802661:	48                   	dec    %eax
  802662:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 50 08             	mov    0x8(%eax),%edx
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	01 c2                	add    %eax,%edx
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 40 0c             	mov    0xc(%eax),%eax
  80267e:	2b 45 08             	sub    0x8(%ebp),%eax
  802681:	89 c2                	mov    %eax,%edx
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268c:	eb 3b                	jmp    8026c9 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80268e:	a1 40 51 80 00       	mov    0x805140,%eax
  802693:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802696:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269a:	74 07                	je     8026a3 <alloc_block_FF+0x1a5>
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	eb 05                	jmp    8026a8 <alloc_block_FF+0x1aa>
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	a3 40 51 80 00       	mov    %eax,0x805140
  8026ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	0f 85 57 fe ff ff    	jne    802511 <alloc_block_FF+0x13>
  8026ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026be:	0f 85 4d fe ff ff    	jne    802511 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c9:	c9                   	leave  
  8026ca:	c3                   	ret    

008026cb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
  8026ce:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8026dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e0:	e9 df 00 00 00       	jmp    8027c4 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ee:	0f 82 c8 00 00 00    	jb     8027bc <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fd:	0f 85 8a 00 00 00    	jne    80278d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802707:	75 17                	jne    802720 <alloc_block_BF+0x55>
  802709:	83 ec 04             	sub    $0x4,%esp
  80270c:	68 c4 45 80 00       	push   $0x8045c4
  802711:	68 b7 00 00 00       	push   $0xb7
  802716:	68 1b 45 80 00       	push   $0x80451b
  80271b:	e8 2a de ff ff       	call   80054a <_panic>
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 10                	je     802739 <alloc_block_BF+0x6e>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802731:	8b 52 04             	mov    0x4(%edx),%edx
  802734:	89 50 04             	mov    %edx,0x4(%eax)
  802737:	eb 0b                	jmp    802744 <alloc_block_BF+0x79>
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	8b 40 04             	mov    0x4(%eax),%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	74 0f                	je     80275d <alloc_block_BF+0x92>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802757:	8b 12                	mov    (%edx),%edx
  802759:	89 10                	mov    %edx,(%eax)
  80275b:	eb 0a                	jmp    802767 <alloc_block_BF+0x9c>
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	a3 38 51 80 00       	mov    %eax,0x805138
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277a:	a1 44 51 80 00       	mov    0x805144,%eax
  80277f:	48                   	dec    %eax
  802780:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	e9 4d 01 00 00       	jmp    8028da <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 40 0c             	mov    0xc(%eax),%eax
  802793:	3b 45 08             	cmp    0x8(%ebp),%eax
  802796:	76 24                	jbe    8027bc <alloc_block_BF+0xf1>
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 40 0c             	mov    0xc(%eax),%eax
  80279e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027a1:	73 19                	jae    8027bc <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8027a3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 08             	mov    0x8(%eax),%eax
  8027b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8027c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	74 07                	je     8027d1 <alloc_block_BF+0x106>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	eb 05                	jmp    8027d6 <alloc_block_BF+0x10b>
  8027d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8027db:	a1 40 51 80 00       	mov    0x805140,%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	0f 85 fd fe ff ff    	jne    8026e5 <alloc_block_BF+0x1a>
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	0f 85 f3 fe ff ff    	jne    8026e5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027f6:	0f 84 d9 00 00 00    	je     8028d5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027fc:	a1 48 51 80 00       	mov    0x805148,%eax
  802801:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802807:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80280a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80280d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802810:	8b 55 08             	mov    0x8(%ebp),%edx
  802813:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80281a:	75 17                	jne    802833 <alloc_block_BF+0x168>
  80281c:	83 ec 04             	sub    $0x4,%esp
  80281f:	68 c4 45 80 00       	push   $0x8045c4
  802824:	68 c7 00 00 00       	push   $0xc7
  802829:	68 1b 45 80 00       	push   $0x80451b
  80282e:	e8 17 dd ff ff       	call   80054a <_panic>
  802833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	74 10                	je     80284c <alloc_block_BF+0x181>
  80283c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283f:	8b 00                	mov    (%eax),%eax
  802841:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802844:	8b 52 04             	mov    0x4(%edx),%edx
  802847:	89 50 04             	mov    %edx,0x4(%eax)
  80284a:	eb 0b                	jmp    802857 <alloc_block_BF+0x18c>
  80284c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284f:	8b 40 04             	mov    0x4(%eax),%eax
  802852:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285a:	8b 40 04             	mov    0x4(%eax),%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 0f                	je     802870 <alloc_block_BF+0x1a5>
  802861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802864:	8b 40 04             	mov    0x4(%eax),%eax
  802867:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80286a:	8b 12                	mov    (%edx),%edx
  80286c:	89 10                	mov    %edx,(%eax)
  80286e:	eb 0a                	jmp    80287a <alloc_block_BF+0x1af>
  802870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802873:	8b 00                	mov    (%eax),%eax
  802875:	a3 48 51 80 00       	mov    %eax,0x805148
  80287a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802886:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288d:	a1 54 51 80 00       	mov    0x805154,%eax
  802892:	48                   	dec    %eax
  802893:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802898:	83 ec 08             	sub    $0x8,%esp
  80289b:	ff 75 ec             	pushl  -0x14(%ebp)
  80289e:	68 38 51 80 00       	push   $0x805138
  8028a3:	e8 71 f9 ff ff       	call   802219 <find_block>
  8028a8:	83 c4 10             	add    $0x10,%esp
  8028ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b1:	8b 50 08             	mov    0x8(%eax),%edx
  8028b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b7:	01 c2                	add    %eax,%edx
  8028b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028bc:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8028c8:	89 c2                	mov    %eax,%edx
  8028ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cd:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d3:	eb 05                	jmp    8028da <alloc_block_BF+0x20f>
	}
	return NULL;
  8028d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028da:	c9                   	leave  
  8028db:	c3                   	ret    

008028dc <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
  8028df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028e2:	a1 28 50 80 00       	mov    0x805028,%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	0f 85 de 01 00 00    	jne    802acd <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f7:	e9 9e 01 00 00       	jmp    802a9a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802902:	3b 45 08             	cmp    0x8(%ebp),%eax
  802905:	0f 82 87 01 00 00    	jb     802a92 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 40 0c             	mov    0xc(%eax),%eax
  802911:	3b 45 08             	cmp    0x8(%ebp),%eax
  802914:	0f 85 95 00 00 00    	jne    8029af <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80291a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291e:	75 17                	jne    802937 <alloc_block_NF+0x5b>
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 c4 45 80 00       	push   $0x8045c4
  802928:	68 e0 00 00 00       	push   $0xe0
  80292d:	68 1b 45 80 00       	push   $0x80451b
  802932:	e8 13 dc ff ff       	call   80054a <_panic>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 10                	je     802950 <alloc_block_NF+0x74>
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802948:	8b 52 04             	mov    0x4(%edx),%edx
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	eb 0b                	jmp    80295b <alloc_block_NF+0x7f>
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 04             	mov    0x4(%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 0f                	je     802974 <alloc_block_NF+0x98>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296e:	8b 12                	mov    (%edx),%edx
  802970:	89 10                	mov    %edx,(%eax)
  802972:	eb 0a                	jmp    80297e <alloc_block_NF+0xa2>
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	a3 38 51 80 00       	mov    %eax,0x805138
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 44 51 80 00       	mov    0x805144,%eax
  802996:	48                   	dec    %eax
  802997:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 40 08             	mov    0x8(%eax),%eax
  8029a2:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	e9 f8 04 00 00       	jmp    802ea7 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b8:	0f 86 d4 00 00 00    	jbe    802a92 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029be:	a1 48 51 80 00       	mov    0x805148,%eax
  8029c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 50 08             	mov    0x8(%eax),%edx
  8029cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cf:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029df:	75 17                	jne    8029f8 <alloc_block_NF+0x11c>
  8029e1:	83 ec 04             	sub    $0x4,%esp
  8029e4:	68 c4 45 80 00       	push   $0x8045c4
  8029e9:	68 e9 00 00 00       	push   $0xe9
  8029ee:	68 1b 45 80 00       	push   $0x80451b
  8029f3:	e8 52 db ff ff       	call   80054a <_panic>
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	74 10                	je     802a11 <alloc_block_NF+0x135>
  802a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a09:	8b 52 04             	mov    0x4(%edx),%edx
  802a0c:	89 50 04             	mov    %edx,0x4(%eax)
  802a0f:	eb 0b                	jmp    802a1c <alloc_block_NF+0x140>
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1f:	8b 40 04             	mov    0x4(%eax),%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 0f                	je     802a35 <alloc_block_NF+0x159>
  802a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a2f:	8b 12                	mov    (%edx),%edx
  802a31:	89 10                	mov    %edx,(%eax)
  802a33:	eb 0a                	jmp    802a3f <alloc_block_NF+0x163>
  802a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	a3 48 51 80 00       	mov    %eax,0x805148
  802a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a52:	a1 54 51 80 00       	mov    0x805154,%eax
  802a57:	48                   	dec    %eax
  802a58:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a60:	8b 40 08             	mov    0x8(%eax),%eax
  802a63:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 50 08             	mov    0x8(%eax),%edx
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	01 c2                	add    %eax,%edx
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a82:	89 c2                	mov    %eax,%edx
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8d:	e9 15 04 00 00       	jmp    802ea7 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a92:	a1 40 51 80 00       	mov    0x805140,%eax
  802a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9e:	74 07                	je     802aa7 <alloc_block_NF+0x1cb>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	eb 05                	jmp    802aac <alloc_block_NF+0x1d0>
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aac:	a3 40 51 80 00       	mov    %eax,0x805140
  802ab1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	0f 85 3e fe ff ff    	jne    8028fc <alloc_block_NF+0x20>
  802abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac2:	0f 85 34 fe ff ff    	jne    8028fc <alloc_block_NF+0x20>
  802ac8:	e9 d5 03 00 00       	jmp    802ea2 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802acd:	a1 38 51 80 00       	mov    0x805138,%eax
  802ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad5:	e9 b1 01 00 00       	jmp    802c8b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 50 08             	mov    0x8(%eax),%edx
  802ae0:	a1 28 50 80 00       	mov    0x805028,%eax
  802ae5:	39 c2                	cmp    %eax,%edx
  802ae7:	0f 82 96 01 00 00    	jb     802c83 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 40 0c             	mov    0xc(%eax),%eax
  802af3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af6:	0f 82 87 01 00 00    	jb     802c83 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 40 0c             	mov    0xc(%eax),%eax
  802b02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b05:	0f 85 95 00 00 00    	jne    802ba0 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0f:	75 17                	jne    802b28 <alloc_block_NF+0x24c>
  802b11:	83 ec 04             	sub    $0x4,%esp
  802b14:	68 c4 45 80 00       	push   $0x8045c4
  802b19:	68 fc 00 00 00       	push   $0xfc
  802b1e:	68 1b 45 80 00       	push   $0x80451b
  802b23:	e8 22 da ff ff       	call   80054a <_panic>
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 10                	je     802b41 <alloc_block_NF+0x265>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b39:	8b 52 04             	mov    0x4(%edx),%edx
  802b3c:	89 50 04             	mov    %edx,0x4(%eax)
  802b3f:	eb 0b                	jmp    802b4c <alloc_block_NF+0x270>
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 40 04             	mov    0x4(%eax),%eax
  802b47:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	8b 40 04             	mov    0x4(%eax),%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	74 0f                	je     802b65 <alloc_block_NF+0x289>
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 40 04             	mov    0x4(%eax),%eax
  802b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5f:	8b 12                	mov    (%edx),%edx
  802b61:	89 10                	mov    %edx,(%eax)
  802b63:	eb 0a                	jmp    802b6f <alloc_block_NF+0x293>
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	a3 38 51 80 00       	mov    %eax,0x805138
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b82:	a1 44 51 80 00       	mov    0x805144,%eax
  802b87:	48                   	dec    %eax
  802b88:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 40 08             	mov    0x8(%eax),%eax
  802b93:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	e9 07 03 00 00       	jmp    802ea7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba9:	0f 86 d4 00 00 00    	jbe    802c83 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802baf:	a1 48 51 80 00       	mov    0x805148,%eax
  802bb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 50 08             	mov    0x8(%eax),%edx
  802bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bcc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bd0:	75 17                	jne    802be9 <alloc_block_NF+0x30d>
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	68 c4 45 80 00       	push   $0x8045c4
  802bda:	68 04 01 00 00       	push   $0x104
  802bdf:	68 1b 45 80 00       	push   $0x80451b
  802be4:	e8 61 d9 ff ff       	call   80054a <_panic>
  802be9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	74 10                	je     802c02 <alloc_block_NF+0x326>
  802bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bfa:	8b 52 04             	mov    0x4(%edx),%edx
  802bfd:	89 50 04             	mov    %edx,0x4(%eax)
  802c00:	eb 0b                	jmp    802c0d <alloc_block_NF+0x331>
  802c02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c10:	8b 40 04             	mov    0x4(%eax),%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	74 0f                	je     802c26 <alloc_block_NF+0x34a>
  802c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1a:	8b 40 04             	mov    0x4(%eax),%eax
  802c1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c20:	8b 12                	mov    (%edx),%edx
  802c22:	89 10                	mov    %edx,(%eax)
  802c24:	eb 0a                	jmp    802c30 <alloc_block_NF+0x354>
  802c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	a3 48 51 80 00       	mov    %eax,0x805148
  802c30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c43:	a1 54 51 80 00       	mov    0x805154,%eax
  802c48:	48                   	dec    %eax
  802c49:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c51:	8b 40 08             	mov    0x8(%eax),%eax
  802c54:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 50 08             	mov    0x8(%eax),%edx
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	01 c2                	add    %eax,%edx
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c70:	2b 45 08             	sub    0x8(%ebp),%eax
  802c73:	89 c2                	mov    %eax,%edx
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7e:	e9 24 02 00 00       	jmp    802ea7 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c83:	a1 40 51 80 00       	mov    0x805140,%eax
  802c88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8f:	74 07                	je     802c98 <alloc_block_NF+0x3bc>
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	eb 05                	jmp    802c9d <alloc_block_NF+0x3c1>
  802c98:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9d:	a3 40 51 80 00       	mov    %eax,0x805140
  802ca2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	0f 85 2b fe ff ff    	jne    802ada <alloc_block_NF+0x1fe>
  802caf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb3:	0f 85 21 fe ff ff    	jne    802ada <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cb9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc1:	e9 ae 01 00 00       	jmp    802e74 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 50 08             	mov    0x8(%eax),%edx
  802ccc:	a1 28 50 80 00       	mov    0x805028,%eax
  802cd1:	39 c2                	cmp    %eax,%edx
  802cd3:	0f 83 93 01 00 00    	jae    802e6c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce2:	0f 82 84 01 00 00    	jb     802e6c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf1:	0f 85 95 00 00 00    	jne    802d8c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfb:	75 17                	jne    802d14 <alloc_block_NF+0x438>
  802cfd:	83 ec 04             	sub    $0x4,%esp
  802d00:	68 c4 45 80 00       	push   $0x8045c4
  802d05:	68 14 01 00 00       	push   $0x114
  802d0a:	68 1b 45 80 00       	push   $0x80451b
  802d0f:	e8 36 d8 ff ff       	call   80054a <_panic>
  802d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	74 10                	je     802d2d <alloc_block_NF+0x451>
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 00                	mov    (%eax),%eax
  802d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d25:	8b 52 04             	mov    0x4(%edx),%edx
  802d28:	89 50 04             	mov    %edx,0x4(%eax)
  802d2b:	eb 0b                	jmp    802d38 <alloc_block_NF+0x45c>
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 40 04             	mov    0x4(%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0f                	je     802d51 <alloc_block_NF+0x475>
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 04             	mov    0x4(%eax),%eax
  802d48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4b:	8b 12                	mov    (%edx),%edx
  802d4d:	89 10                	mov    %edx,(%eax)
  802d4f:	eb 0a                	jmp    802d5b <alloc_block_NF+0x47f>
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	a3 38 51 80 00       	mov    %eax,0x805138
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d73:	48                   	dec    %eax
  802d74:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 40 08             	mov    0x8(%eax),%eax
  802d7f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	e9 1b 01 00 00       	jmp    802ea7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d95:	0f 86 d1 00 00 00    	jbe    802e6c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d9b:	a1 48 51 80 00       	mov    0x805148,%eax
  802da0:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 50 08             	mov    0x8(%eax),%edx
  802da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dac:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db2:	8b 55 08             	mov    0x8(%ebp),%edx
  802db5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802db8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dbc:	75 17                	jne    802dd5 <alloc_block_NF+0x4f9>
  802dbe:	83 ec 04             	sub    $0x4,%esp
  802dc1:	68 c4 45 80 00       	push   $0x8045c4
  802dc6:	68 1c 01 00 00       	push   $0x11c
  802dcb:	68 1b 45 80 00       	push   $0x80451b
  802dd0:	e8 75 d7 ff ff       	call   80054a <_panic>
  802dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	74 10                	je     802dee <alloc_block_NF+0x512>
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de6:	8b 52 04             	mov    0x4(%edx),%edx
  802de9:	89 50 04             	mov    %edx,0x4(%eax)
  802dec:	eb 0b                	jmp    802df9 <alloc_block_NF+0x51d>
  802dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfc:	8b 40 04             	mov    0x4(%eax),%eax
  802dff:	85 c0                	test   %eax,%eax
  802e01:	74 0f                	je     802e12 <alloc_block_NF+0x536>
  802e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e06:	8b 40 04             	mov    0x4(%eax),%eax
  802e09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e0c:	8b 12                	mov    (%edx),%edx
  802e0e:	89 10                	mov    %edx,(%eax)
  802e10:	eb 0a                	jmp    802e1c <alloc_block_NF+0x540>
  802e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e15:	8b 00                	mov    (%eax),%eax
  802e17:	a3 48 51 80 00       	mov    %eax,0x805148
  802e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2f:	a1 54 51 80 00       	mov    0x805154,%eax
  802e34:	48                   	dec    %eax
  802e35:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3d:	8b 40 08             	mov    0x8(%eax),%eax
  802e40:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	01 c2                	add    %eax,%edx
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e5f:	89 c2                	mov    %eax,%edx
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6a:	eb 3b                	jmp    802ea7 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e6c:	a1 40 51 80 00       	mov    0x805140,%eax
  802e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e78:	74 07                	je     802e81 <alloc_block_NF+0x5a5>
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	eb 05                	jmp    802e86 <alloc_block_NF+0x5aa>
  802e81:	b8 00 00 00 00       	mov    $0x0,%eax
  802e86:	a3 40 51 80 00       	mov    %eax,0x805140
  802e8b:	a1 40 51 80 00       	mov    0x805140,%eax
  802e90:	85 c0                	test   %eax,%eax
  802e92:	0f 85 2e fe ff ff    	jne    802cc6 <alloc_block_NF+0x3ea>
  802e98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9c:	0f 85 24 fe ff ff    	jne    802cc6 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ea2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ea7:	c9                   	leave  
  802ea8:	c3                   	ret    

00802ea9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ea9:	55                   	push   %ebp
  802eaa:	89 e5                	mov    %esp,%ebp
  802eac:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802eaf:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802eb7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ebc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ebf:	a1 38 51 80 00       	mov    0x805138,%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 14                	je     802edc <insert_sorted_with_merge_freeList+0x33>
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	8b 50 08             	mov    0x8(%eax),%edx
  802ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed1:	8b 40 08             	mov    0x8(%eax),%eax
  802ed4:	39 c2                	cmp    %eax,%edx
  802ed6:	0f 87 9b 01 00 00    	ja     803077 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802edc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee0:	75 17                	jne    802ef9 <insert_sorted_with_merge_freeList+0x50>
  802ee2:	83 ec 04             	sub    $0x4,%esp
  802ee5:	68 f8 44 80 00       	push   $0x8044f8
  802eea:	68 38 01 00 00       	push   $0x138
  802eef:	68 1b 45 80 00       	push   $0x80451b
  802ef4:	e8 51 d6 ff ff       	call   80054a <_panic>
  802ef9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	89 10                	mov    %edx,(%eax)
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	85 c0                	test   %eax,%eax
  802f0b:	74 0d                	je     802f1a <insert_sorted_with_merge_freeList+0x71>
  802f0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f12:	8b 55 08             	mov    0x8(%ebp),%edx
  802f15:	89 50 04             	mov    %edx,0x4(%eax)
  802f18:	eb 08                	jmp    802f22 <insert_sorted_with_merge_freeList+0x79>
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f34:	a1 44 51 80 00       	mov    0x805144,%eax
  802f39:	40                   	inc    %eax
  802f3a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f43:	0f 84 a8 06 00 00    	je     8035f1 <insert_sorted_with_merge_freeList+0x748>
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	8b 50 08             	mov    0x8(%eax),%edx
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 40 0c             	mov    0xc(%eax),%eax
  802f55:	01 c2                	add    %eax,%edx
  802f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5a:	8b 40 08             	mov    0x8(%eax),%eax
  802f5d:	39 c2                	cmp    %eax,%edx
  802f5f:	0f 85 8c 06 00 00    	jne    8035f1 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	8b 50 0c             	mov    0xc(%eax),%edx
  802f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f71:	01 c2                	add    %eax,%edx
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7d:	75 17                	jne    802f96 <insert_sorted_with_merge_freeList+0xed>
  802f7f:	83 ec 04             	sub    $0x4,%esp
  802f82:	68 c4 45 80 00       	push   $0x8045c4
  802f87:	68 3c 01 00 00       	push   $0x13c
  802f8c:	68 1b 45 80 00       	push   $0x80451b
  802f91:	e8 b4 d5 ff ff       	call   80054a <_panic>
  802f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	74 10                	je     802faf <insert_sorted_with_merge_freeList+0x106>
  802f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa2:	8b 00                	mov    (%eax),%eax
  802fa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa7:	8b 52 04             	mov    0x4(%edx),%edx
  802faa:	89 50 04             	mov    %edx,0x4(%eax)
  802fad:	eb 0b                	jmp    802fba <insert_sorted_with_merge_freeList+0x111>
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbd:	8b 40 04             	mov    0x4(%eax),%eax
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	74 0f                	je     802fd3 <insert_sorted_with_merge_freeList+0x12a>
  802fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc7:	8b 40 04             	mov    0x4(%eax),%eax
  802fca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fcd:	8b 12                	mov    (%edx),%edx
  802fcf:	89 10                	mov    %edx,(%eax)
  802fd1:	eb 0a                	jmp    802fdd <insert_sorted_with_merge_freeList+0x134>
  802fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	a3 38 51 80 00       	mov    %eax,0x805138
  802fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff5:	48                   	dec    %eax
  802ff6:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803008:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80300f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803013:	75 17                	jne    80302c <insert_sorted_with_merge_freeList+0x183>
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	68 f8 44 80 00       	push   $0x8044f8
  80301d:	68 3f 01 00 00       	push   $0x13f
  803022:	68 1b 45 80 00       	push   $0x80451b
  803027:	e8 1e d5 ff ff       	call   80054a <_panic>
  80302c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803035:	89 10                	mov    %edx,(%eax)
  803037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	74 0d                	je     80304d <insert_sorted_with_merge_freeList+0x1a4>
  803040:	a1 48 51 80 00       	mov    0x805148,%eax
  803045:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803048:	89 50 04             	mov    %edx,0x4(%eax)
  80304b:	eb 08                	jmp    803055 <insert_sorted_with_merge_freeList+0x1ac>
  80304d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803050:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803058:	a3 48 51 80 00       	mov    %eax,0x805148
  80305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803060:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803067:	a1 54 51 80 00       	mov    0x805154,%eax
  80306c:	40                   	inc    %eax
  80306d:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803072:	e9 7a 05 00 00       	jmp    8035f1 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	8b 50 08             	mov    0x8(%eax),%edx
  80307d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803080:	8b 40 08             	mov    0x8(%eax),%eax
  803083:	39 c2                	cmp    %eax,%edx
  803085:	0f 82 14 01 00 00    	jb     80319f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80308b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308e:	8b 50 08             	mov    0x8(%eax),%edx
  803091:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803094:	8b 40 0c             	mov    0xc(%eax),%eax
  803097:	01 c2                	add    %eax,%edx
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	8b 40 08             	mov    0x8(%eax),%eax
  80309f:	39 c2                	cmp    %eax,%edx
  8030a1:	0f 85 90 00 00 00    	jne    803137 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b3:	01 c2                	add    %eax,%edx
  8030b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b8:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d3:	75 17                	jne    8030ec <insert_sorted_with_merge_freeList+0x243>
  8030d5:	83 ec 04             	sub    $0x4,%esp
  8030d8:	68 f8 44 80 00       	push   $0x8044f8
  8030dd:	68 49 01 00 00       	push   $0x149
  8030e2:	68 1b 45 80 00       	push   $0x80451b
  8030e7:	e8 5e d4 ff ff       	call   80054a <_panic>
  8030ec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	89 10                	mov    %edx,(%eax)
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	74 0d                	je     80310d <insert_sorted_with_merge_freeList+0x264>
  803100:	a1 48 51 80 00       	mov    0x805148,%eax
  803105:	8b 55 08             	mov    0x8(%ebp),%edx
  803108:	89 50 04             	mov    %edx,0x4(%eax)
  80310b:	eb 08                	jmp    803115 <insert_sorted_with_merge_freeList+0x26c>
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	a3 48 51 80 00       	mov    %eax,0x805148
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803127:	a1 54 51 80 00       	mov    0x805154,%eax
  80312c:	40                   	inc    %eax
  80312d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803132:	e9 bb 04 00 00       	jmp    8035f2 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803137:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313b:	75 17                	jne    803154 <insert_sorted_with_merge_freeList+0x2ab>
  80313d:	83 ec 04             	sub    $0x4,%esp
  803140:	68 6c 45 80 00       	push   $0x80456c
  803145:	68 4c 01 00 00       	push   $0x14c
  80314a:	68 1b 45 80 00       	push   $0x80451b
  80314f:	e8 f6 d3 ff ff       	call   80054a <_panic>
  803154:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	89 50 04             	mov    %edx,0x4(%eax)
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 40 04             	mov    0x4(%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 0c                	je     803176 <insert_sorted_with_merge_freeList+0x2cd>
  80316a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80316f:	8b 55 08             	mov    0x8(%ebp),%edx
  803172:	89 10                	mov    %edx,(%eax)
  803174:	eb 08                	jmp    80317e <insert_sorted_with_merge_freeList+0x2d5>
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	a3 38 51 80 00       	mov    %eax,0x805138
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318f:	a1 44 51 80 00       	mov    0x805144,%eax
  803194:	40                   	inc    %eax
  803195:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80319a:	e9 53 04 00 00       	jmp    8035f2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80319f:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a7:	e9 15 04 00 00       	jmp    8035c1 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	8b 40 08             	mov    0x8(%eax),%eax
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	0f 86 f1 03 00 00    	jbe    8035b9 <insert_sorted_with_merge_freeList+0x710>
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 40 08             	mov    0x8(%eax),%eax
  8031d4:	39 c2                	cmp    %eax,%edx
  8031d6:	0f 83 dd 03 00 00    	jae    8035b9 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 50 08             	mov    0x8(%eax),%edx
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e8:	01 c2                	add    %eax,%edx
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	8b 40 08             	mov    0x8(%eax),%eax
  8031f0:	39 c2                	cmp    %eax,%edx
  8031f2:	0f 85 b9 01 00 00    	jne    8033b1 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fb:	8b 50 08             	mov    0x8(%eax),%edx
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	8b 40 0c             	mov    0xc(%eax),%eax
  803204:	01 c2                	add    %eax,%edx
  803206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803209:	8b 40 08             	mov    0x8(%eax),%eax
  80320c:	39 c2                	cmp    %eax,%edx
  80320e:	0f 85 0d 01 00 00    	jne    803321 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 50 0c             	mov    0xc(%eax),%edx
  80321a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321d:	8b 40 0c             	mov    0xc(%eax),%eax
  803220:	01 c2                	add    %eax,%edx
  803222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803225:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803228:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80322c:	75 17                	jne    803245 <insert_sorted_with_merge_freeList+0x39c>
  80322e:	83 ec 04             	sub    $0x4,%esp
  803231:	68 c4 45 80 00       	push   $0x8045c4
  803236:	68 5c 01 00 00       	push   $0x15c
  80323b:	68 1b 45 80 00       	push   $0x80451b
  803240:	e8 05 d3 ff ff       	call   80054a <_panic>
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	8b 00                	mov    (%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 10                	je     80325e <insert_sorted_with_merge_freeList+0x3b5>
  80324e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803256:	8b 52 04             	mov    0x4(%edx),%edx
  803259:	89 50 04             	mov    %edx,0x4(%eax)
  80325c:	eb 0b                	jmp    803269 <insert_sorted_with_merge_freeList+0x3c0>
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	8b 40 04             	mov    0x4(%eax),%eax
  803264:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326c:	8b 40 04             	mov    0x4(%eax),%eax
  80326f:	85 c0                	test   %eax,%eax
  803271:	74 0f                	je     803282 <insert_sorted_with_merge_freeList+0x3d9>
  803273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803276:	8b 40 04             	mov    0x4(%eax),%eax
  803279:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327c:	8b 12                	mov    (%edx),%edx
  80327e:	89 10                	mov    %edx,(%eax)
  803280:	eb 0a                	jmp    80328c <insert_sorted_with_merge_freeList+0x3e3>
  803282:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803285:	8b 00                	mov    (%eax),%eax
  803287:	a3 38 51 80 00       	mov    %eax,0x805138
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329f:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a4:	48                   	dec    %eax
  8032a5:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032c2:	75 17                	jne    8032db <insert_sorted_with_merge_freeList+0x432>
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	68 f8 44 80 00       	push   $0x8044f8
  8032cc:	68 5f 01 00 00       	push   $0x15f
  8032d1:	68 1b 45 80 00       	push   $0x80451b
  8032d6:	e8 6f d2 ff ff       	call   80054a <_panic>
  8032db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e4:	89 10                	mov    %edx,(%eax)
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	8b 00                	mov    (%eax),%eax
  8032eb:	85 c0                	test   %eax,%eax
  8032ed:	74 0d                	je     8032fc <insert_sorted_with_merge_freeList+0x453>
  8032ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8032f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f7:	89 50 04             	mov    %edx,0x4(%eax)
  8032fa:	eb 08                	jmp    803304 <insert_sorted_with_merge_freeList+0x45b>
  8032fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803307:	a3 48 51 80 00       	mov    %eax,0x805148
  80330c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803316:	a1 54 51 80 00       	mov    0x805154,%eax
  80331b:	40                   	inc    %eax
  80331c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	8b 50 0c             	mov    0xc(%eax),%edx
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	8b 40 0c             	mov    0xc(%eax),%eax
  80332d:	01 c2                	add    %eax,%edx
  80332f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803332:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803349:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334d:	75 17                	jne    803366 <insert_sorted_with_merge_freeList+0x4bd>
  80334f:	83 ec 04             	sub    $0x4,%esp
  803352:	68 f8 44 80 00       	push   $0x8044f8
  803357:	68 64 01 00 00       	push   $0x164
  80335c:	68 1b 45 80 00       	push   $0x80451b
  803361:	e8 e4 d1 ff ff       	call   80054a <_panic>
  803366:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	89 10                	mov    %edx,(%eax)
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	85 c0                	test   %eax,%eax
  803378:	74 0d                	je     803387 <insert_sorted_with_merge_freeList+0x4de>
  80337a:	a1 48 51 80 00       	mov    0x805148,%eax
  80337f:	8b 55 08             	mov    0x8(%ebp),%edx
  803382:	89 50 04             	mov    %edx,0x4(%eax)
  803385:	eb 08                	jmp    80338f <insert_sorted_with_merge_freeList+0x4e6>
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	a3 48 51 80 00       	mov    %eax,0x805148
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a6:	40                   	inc    %eax
  8033a7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033ac:	e9 41 02 00 00       	jmp    8035f2 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	8b 50 08             	mov    0x8(%eax),%edx
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8033bd:	01 c2                	add    %eax,%edx
  8033bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c2:	8b 40 08             	mov    0x8(%eax),%eax
  8033c5:	39 c2                	cmp    %eax,%edx
  8033c7:	0f 85 7c 01 00 00    	jne    803549 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033d1:	74 06                	je     8033d9 <insert_sorted_with_merge_freeList+0x530>
  8033d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d7:	75 17                	jne    8033f0 <insert_sorted_with_merge_freeList+0x547>
  8033d9:	83 ec 04             	sub    $0x4,%esp
  8033dc:	68 34 45 80 00       	push   $0x804534
  8033e1:	68 69 01 00 00       	push   $0x169
  8033e6:	68 1b 45 80 00       	push   $0x80451b
  8033eb:	e8 5a d1 ff ff       	call   80054a <_panic>
  8033f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f3:	8b 50 04             	mov    0x4(%eax),%edx
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	89 50 04             	mov    %edx,0x4(%eax)
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803402:	89 10                	mov    %edx,(%eax)
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	8b 40 04             	mov    0x4(%eax),%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	74 0d                	je     80341b <insert_sorted_with_merge_freeList+0x572>
  80340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803411:	8b 40 04             	mov    0x4(%eax),%eax
  803414:	8b 55 08             	mov    0x8(%ebp),%edx
  803417:	89 10                	mov    %edx,(%eax)
  803419:	eb 08                	jmp    803423 <insert_sorted_with_merge_freeList+0x57a>
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	a3 38 51 80 00       	mov    %eax,0x805138
  803423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803426:	8b 55 08             	mov    0x8(%ebp),%edx
  803429:	89 50 04             	mov    %edx,0x4(%eax)
  80342c:	a1 44 51 80 00       	mov    0x805144,%eax
  803431:	40                   	inc    %eax
  803432:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803437:	8b 45 08             	mov    0x8(%ebp),%eax
  80343a:	8b 50 0c             	mov    0xc(%eax),%edx
  80343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803440:	8b 40 0c             	mov    0xc(%eax),%eax
  803443:	01 c2                	add    %eax,%edx
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80344b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80344f:	75 17                	jne    803468 <insert_sorted_with_merge_freeList+0x5bf>
  803451:	83 ec 04             	sub    $0x4,%esp
  803454:	68 c4 45 80 00       	push   $0x8045c4
  803459:	68 6b 01 00 00       	push   $0x16b
  80345e:	68 1b 45 80 00       	push   $0x80451b
  803463:	e8 e2 d0 ff ff       	call   80054a <_panic>
  803468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	85 c0                	test   %eax,%eax
  80346f:	74 10                	je     803481 <insert_sorted_with_merge_freeList+0x5d8>
  803471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803479:	8b 52 04             	mov    0x4(%edx),%edx
  80347c:	89 50 04             	mov    %edx,0x4(%eax)
  80347f:	eb 0b                	jmp    80348c <insert_sorted_with_merge_freeList+0x5e3>
  803481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803484:	8b 40 04             	mov    0x4(%eax),%eax
  803487:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80348c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348f:	8b 40 04             	mov    0x4(%eax),%eax
  803492:	85 c0                	test   %eax,%eax
  803494:	74 0f                	je     8034a5 <insert_sorted_with_merge_freeList+0x5fc>
  803496:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803499:	8b 40 04             	mov    0x4(%eax),%eax
  80349c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80349f:	8b 12                	mov    (%edx),%edx
  8034a1:	89 10                	mov    %edx,(%eax)
  8034a3:	eb 0a                	jmp    8034af <insert_sorted_with_merge_freeList+0x606>
  8034a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c7:	48                   	dec    %eax
  8034c8:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034e5:	75 17                	jne    8034fe <insert_sorted_with_merge_freeList+0x655>
  8034e7:	83 ec 04             	sub    $0x4,%esp
  8034ea:	68 f8 44 80 00       	push   $0x8044f8
  8034ef:	68 6e 01 00 00       	push   $0x16e
  8034f4:	68 1b 45 80 00       	push   $0x80451b
  8034f9:	e8 4c d0 ff ff       	call   80054a <_panic>
  8034fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803507:	89 10                	mov    %edx,(%eax)
  803509:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350c:	8b 00                	mov    (%eax),%eax
  80350e:	85 c0                	test   %eax,%eax
  803510:	74 0d                	je     80351f <insert_sorted_with_merge_freeList+0x676>
  803512:	a1 48 51 80 00       	mov    0x805148,%eax
  803517:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80351a:	89 50 04             	mov    %edx,0x4(%eax)
  80351d:	eb 08                	jmp    803527 <insert_sorted_with_merge_freeList+0x67e>
  80351f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803522:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352a:	a3 48 51 80 00       	mov    %eax,0x805148
  80352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803532:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803539:	a1 54 51 80 00       	mov    0x805154,%eax
  80353e:	40                   	inc    %eax
  80353f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803544:	e9 a9 00 00 00       	jmp    8035f2 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354d:	74 06                	je     803555 <insert_sorted_with_merge_freeList+0x6ac>
  80354f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803553:	75 17                	jne    80356c <insert_sorted_with_merge_freeList+0x6c3>
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	68 90 45 80 00       	push   $0x804590
  80355d:	68 73 01 00 00       	push   $0x173
  803562:	68 1b 45 80 00       	push   $0x80451b
  803567:	e8 de cf ff ff       	call   80054a <_panic>
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 10                	mov    (%eax),%edx
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	89 10                	mov    %edx,(%eax)
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	8b 00                	mov    (%eax),%eax
  80357b:	85 c0                	test   %eax,%eax
  80357d:	74 0b                	je     80358a <insert_sorted_with_merge_freeList+0x6e1>
  80357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803582:	8b 00                	mov    (%eax),%eax
  803584:	8b 55 08             	mov    0x8(%ebp),%edx
  803587:	89 50 04             	mov    %edx,0x4(%eax)
  80358a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358d:	8b 55 08             	mov    0x8(%ebp),%edx
  803590:	89 10                	mov    %edx,(%eax)
  803592:	8b 45 08             	mov    0x8(%ebp),%eax
  803595:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803598:	89 50 04             	mov    %edx,0x4(%eax)
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	75 08                	jne    8035ac <insert_sorted_with_merge_freeList+0x703>
  8035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b1:	40                   	inc    %eax
  8035b2:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035b7:	eb 39                	jmp    8035f2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8035be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c5:	74 07                	je     8035ce <insert_sorted_with_merge_freeList+0x725>
  8035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	eb 05                	jmp    8035d3 <insert_sorted_with_merge_freeList+0x72a>
  8035ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d3:	a3 40 51 80 00       	mov    %eax,0x805140
  8035d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	0f 85 c7 fb ff ff    	jne    8031ac <insert_sorted_with_merge_freeList+0x303>
  8035e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e9:	0f 85 bd fb ff ff    	jne    8031ac <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035ef:	eb 01                	jmp    8035f2 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035f1:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035f2:	90                   	nop
  8035f3:	c9                   	leave  
  8035f4:	c3                   	ret    

008035f5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8035f5:	55                   	push   %ebp
  8035f6:	89 e5                	mov    %esp,%ebp
  8035f8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8035fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8035fe:	89 d0                	mov    %edx,%eax
  803600:	c1 e0 02             	shl    $0x2,%eax
  803603:	01 d0                	add    %edx,%eax
  803605:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80360c:	01 d0                	add    %edx,%eax
  80360e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803615:	01 d0                	add    %edx,%eax
  803617:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80361e:	01 d0                	add    %edx,%eax
  803620:	c1 e0 04             	shl    $0x4,%eax
  803623:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803626:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80362d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803630:	83 ec 0c             	sub    $0xc,%esp
  803633:	50                   	push   %eax
  803634:	e8 26 e7 ff ff       	call   801d5f <sys_get_virtual_time>
  803639:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80363c:	eb 41                	jmp    80367f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80363e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803641:	83 ec 0c             	sub    $0xc,%esp
  803644:	50                   	push   %eax
  803645:	e8 15 e7 ff ff       	call   801d5f <sys_get_virtual_time>
  80364a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80364d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803650:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803653:	29 c2                	sub    %eax,%edx
  803655:	89 d0                	mov    %edx,%eax
  803657:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80365a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80365d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803660:	89 d1                	mov    %edx,%ecx
  803662:	29 c1                	sub    %eax,%ecx
  803664:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80366a:	39 c2                	cmp    %eax,%edx
  80366c:	0f 97 c0             	seta   %al
  80366f:	0f b6 c0             	movzbl %al,%eax
  803672:	29 c1                	sub    %eax,%ecx
  803674:	89 c8                	mov    %ecx,%eax
  803676:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803679:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80367c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80367f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803682:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803685:	72 b7                	jb     80363e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803687:	90                   	nop
  803688:	c9                   	leave  
  803689:	c3                   	ret    

0080368a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80368a:	55                   	push   %ebp
  80368b:	89 e5                	mov    %esp,%ebp
  80368d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803690:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803697:	eb 03                	jmp    80369c <busy_wait+0x12>
  803699:	ff 45 fc             	incl   -0x4(%ebp)
  80369c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80369f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036a2:	72 f5                	jb     803699 <busy_wait+0xf>
	return i;
  8036a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8036a7:	c9                   	leave  
  8036a8:	c3                   	ret    
  8036a9:	66 90                	xchg   %ax,%ax
  8036ab:	90                   	nop

008036ac <__udivdi3>:
  8036ac:	55                   	push   %ebp
  8036ad:	57                   	push   %edi
  8036ae:	56                   	push   %esi
  8036af:	53                   	push   %ebx
  8036b0:	83 ec 1c             	sub    $0x1c,%esp
  8036b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036c3:	89 ca                	mov    %ecx,%edx
  8036c5:	89 f8                	mov    %edi,%eax
  8036c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036cb:	85 f6                	test   %esi,%esi
  8036cd:	75 2d                	jne    8036fc <__udivdi3+0x50>
  8036cf:	39 cf                	cmp    %ecx,%edi
  8036d1:	77 65                	ja     803738 <__udivdi3+0x8c>
  8036d3:	89 fd                	mov    %edi,%ebp
  8036d5:	85 ff                	test   %edi,%edi
  8036d7:	75 0b                	jne    8036e4 <__udivdi3+0x38>
  8036d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8036de:	31 d2                	xor    %edx,%edx
  8036e0:	f7 f7                	div    %edi
  8036e2:	89 c5                	mov    %eax,%ebp
  8036e4:	31 d2                	xor    %edx,%edx
  8036e6:	89 c8                	mov    %ecx,%eax
  8036e8:	f7 f5                	div    %ebp
  8036ea:	89 c1                	mov    %eax,%ecx
  8036ec:	89 d8                	mov    %ebx,%eax
  8036ee:	f7 f5                	div    %ebp
  8036f0:	89 cf                	mov    %ecx,%edi
  8036f2:	89 fa                	mov    %edi,%edx
  8036f4:	83 c4 1c             	add    $0x1c,%esp
  8036f7:	5b                   	pop    %ebx
  8036f8:	5e                   	pop    %esi
  8036f9:	5f                   	pop    %edi
  8036fa:	5d                   	pop    %ebp
  8036fb:	c3                   	ret    
  8036fc:	39 ce                	cmp    %ecx,%esi
  8036fe:	77 28                	ja     803728 <__udivdi3+0x7c>
  803700:	0f bd fe             	bsr    %esi,%edi
  803703:	83 f7 1f             	xor    $0x1f,%edi
  803706:	75 40                	jne    803748 <__udivdi3+0x9c>
  803708:	39 ce                	cmp    %ecx,%esi
  80370a:	72 0a                	jb     803716 <__udivdi3+0x6a>
  80370c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803710:	0f 87 9e 00 00 00    	ja     8037b4 <__udivdi3+0x108>
  803716:	b8 01 00 00 00       	mov    $0x1,%eax
  80371b:	89 fa                	mov    %edi,%edx
  80371d:	83 c4 1c             	add    $0x1c,%esp
  803720:	5b                   	pop    %ebx
  803721:	5e                   	pop    %esi
  803722:	5f                   	pop    %edi
  803723:	5d                   	pop    %ebp
  803724:	c3                   	ret    
  803725:	8d 76 00             	lea    0x0(%esi),%esi
  803728:	31 ff                	xor    %edi,%edi
  80372a:	31 c0                	xor    %eax,%eax
  80372c:	89 fa                	mov    %edi,%edx
  80372e:	83 c4 1c             	add    $0x1c,%esp
  803731:	5b                   	pop    %ebx
  803732:	5e                   	pop    %esi
  803733:	5f                   	pop    %edi
  803734:	5d                   	pop    %ebp
  803735:	c3                   	ret    
  803736:	66 90                	xchg   %ax,%ax
  803738:	89 d8                	mov    %ebx,%eax
  80373a:	f7 f7                	div    %edi
  80373c:	31 ff                	xor    %edi,%edi
  80373e:	89 fa                	mov    %edi,%edx
  803740:	83 c4 1c             	add    $0x1c,%esp
  803743:	5b                   	pop    %ebx
  803744:	5e                   	pop    %esi
  803745:	5f                   	pop    %edi
  803746:	5d                   	pop    %ebp
  803747:	c3                   	ret    
  803748:	bd 20 00 00 00       	mov    $0x20,%ebp
  80374d:	89 eb                	mov    %ebp,%ebx
  80374f:	29 fb                	sub    %edi,%ebx
  803751:	89 f9                	mov    %edi,%ecx
  803753:	d3 e6                	shl    %cl,%esi
  803755:	89 c5                	mov    %eax,%ebp
  803757:	88 d9                	mov    %bl,%cl
  803759:	d3 ed                	shr    %cl,%ebp
  80375b:	89 e9                	mov    %ebp,%ecx
  80375d:	09 f1                	or     %esi,%ecx
  80375f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803763:	89 f9                	mov    %edi,%ecx
  803765:	d3 e0                	shl    %cl,%eax
  803767:	89 c5                	mov    %eax,%ebp
  803769:	89 d6                	mov    %edx,%esi
  80376b:	88 d9                	mov    %bl,%cl
  80376d:	d3 ee                	shr    %cl,%esi
  80376f:	89 f9                	mov    %edi,%ecx
  803771:	d3 e2                	shl    %cl,%edx
  803773:	8b 44 24 08          	mov    0x8(%esp),%eax
  803777:	88 d9                	mov    %bl,%cl
  803779:	d3 e8                	shr    %cl,%eax
  80377b:	09 c2                	or     %eax,%edx
  80377d:	89 d0                	mov    %edx,%eax
  80377f:	89 f2                	mov    %esi,%edx
  803781:	f7 74 24 0c          	divl   0xc(%esp)
  803785:	89 d6                	mov    %edx,%esi
  803787:	89 c3                	mov    %eax,%ebx
  803789:	f7 e5                	mul    %ebp
  80378b:	39 d6                	cmp    %edx,%esi
  80378d:	72 19                	jb     8037a8 <__udivdi3+0xfc>
  80378f:	74 0b                	je     80379c <__udivdi3+0xf0>
  803791:	89 d8                	mov    %ebx,%eax
  803793:	31 ff                	xor    %edi,%edi
  803795:	e9 58 ff ff ff       	jmp    8036f2 <__udivdi3+0x46>
  80379a:	66 90                	xchg   %ax,%ax
  80379c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037a0:	89 f9                	mov    %edi,%ecx
  8037a2:	d3 e2                	shl    %cl,%edx
  8037a4:	39 c2                	cmp    %eax,%edx
  8037a6:	73 e9                	jae    803791 <__udivdi3+0xe5>
  8037a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037ab:	31 ff                	xor    %edi,%edi
  8037ad:	e9 40 ff ff ff       	jmp    8036f2 <__udivdi3+0x46>
  8037b2:	66 90                	xchg   %ax,%ax
  8037b4:	31 c0                	xor    %eax,%eax
  8037b6:	e9 37 ff ff ff       	jmp    8036f2 <__udivdi3+0x46>
  8037bb:	90                   	nop

008037bc <__umoddi3>:
  8037bc:	55                   	push   %ebp
  8037bd:	57                   	push   %edi
  8037be:	56                   	push   %esi
  8037bf:	53                   	push   %ebx
  8037c0:	83 ec 1c             	sub    $0x1c,%esp
  8037c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037db:	89 f3                	mov    %esi,%ebx
  8037dd:	89 fa                	mov    %edi,%edx
  8037df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037e3:	89 34 24             	mov    %esi,(%esp)
  8037e6:	85 c0                	test   %eax,%eax
  8037e8:	75 1a                	jne    803804 <__umoddi3+0x48>
  8037ea:	39 f7                	cmp    %esi,%edi
  8037ec:	0f 86 a2 00 00 00    	jbe    803894 <__umoddi3+0xd8>
  8037f2:	89 c8                	mov    %ecx,%eax
  8037f4:	89 f2                	mov    %esi,%edx
  8037f6:	f7 f7                	div    %edi
  8037f8:	89 d0                	mov    %edx,%eax
  8037fa:	31 d2                	xor    %edx,%edx
  8037fc:	83 c4 1c             	add    $0x1c,%esp
  8037ff:	5b                   	pop    %ebx
  803800:	5e                   	pop    %esi
  803801:	5f                   	pop    %edi
  803802:	5d                   	pop    %ebp
  803803:	c3                   	ret    
  803804:	39 f0                	cmp    %esi,%eax
  803806:	0f 87 ac 00 00 00    	ja     8038b8 <__umoddi3+0xfc>
  80380c:	0f bd e8             	bsr    %eax,%ebp
  80380f:	83 f5 1f             	xor    $0x1f,%ebp
  803812:	0f 84 ac 00 00 00    	je     8038c4 <__umoddi3+0x108>
  803818:	bf 20 00 00 00       	mov    $0x20,%edi
  80381d:	29 ef                	sub    %ebp,%edi
  80381f:	89 fe                	mov    %edi,%esi
  803821:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803825:	89 e9                	mov    %ebp,%ecx
  803827:	d3 e0                	shl    %cl,%eax
  803829:	89 d7                	mov    %edx,%edi
  80382b:	89 f1                	mov    %esi,%ecx
  80382d:	d3 ef                	shr    %cl,%edi
  80382f:	09 c7                	or     %eax,%edi
  803831:	89 e9                	mov    %ebp,%ecx
  803833:	d3 e2                	shl    %cl,%edx
  803835:	89 14 24             	mov    %edx,(%esp)
  803838:	89 d8                	mov    %ebx,%eax
  80383a:	d3 e0                	shl    %cl,%eax
  80383c:	89 c2                	mov    %eax,%edx
  80383e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803842:	d3 e0                	shl    %cl,%eax
  803844:	89 44 24 04          	mov    %eax,0x4(%esp)
  803848:	8b 44 24 08          	mov    0x8(%esp),%eax
  80384c:	89 f1                	mov    %esi,%ecx
  80384e:	d3 e8                	shr    %cl,%eax
  803850:	09 d0                	or     %edx,%eax
  803852:	d3 eb                	shr    %cl,%ebx
  803854:	89 da                	mov    %ebx,%edx
  803856:	f7 f7                	div    %edi
  803858:	89 d3                	mov    %edx,%ebx
  80385a:	f7 24 24             	mull   (%esp)
  80385d:	89 c6                	mov    %eax,%esi
  80385f:	89 d1                	mov    %edx,%ecx
  803861:	39 d3                	cmp    %edx,%ebx
  803863:	0f 82 87 00 00 00    	jb     8038f0 <__umoddi3+0x134>
  803869:	0f 84 91 00 00 00    	je     803900 <__umoddi3+0x144>
  80386f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803873:	29 f2                	sub    %esi,%edx
  803875:	19 cb                	sbb    %ecx,%ebx
  803877:	89 d8                	mov    %ebx,%eax
  803879:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80387d:	d3 e0                	shl    %cl,%eax
  80387f:	89 e9                	mov    %ebp,%ecx
  803881:	d3 ea                	shr    %cl,%edx
  803883:	09 d0                	or     %edx,%eax
  803885:	89 e9                	mov    %ebp,%ecx
  803887:	d3 eb                	shr    %cl,%ebx
  803889:	89 da                	mov    %ebx,%edx
  80388b:	83 c4 1c             	add    $0x1c,%esp
  80388e:	5b                   	pop    %ebx
  80388f:	5e                   	pop    %esi
  803890:	5f                   	pop    %edi
  803891:	5d                   	pop    %ebp
  803892:	c3                   	ret    
  803893:	90                   	nop
  803894:	89 fd                	mov    %edi,%ebp
  803896:	85 ff                	test   %edi,%edi
  803898:	75 0b                	jne    8038a5 <__umoddi3+0xe9>
  80389a:	b8 01 00 00 00       	mov    $0x1,%eax
  80389f:	31 d2                	xor    %edx,%edx
  8038a1:	f7 f7                	div    %edi
  8038a3:	89 c5                	mov    %eax,%ebp
  8038a5:	89 f0                	mov    %esi,%eax
  8038a7:	31 d2                	xor    %edx,%edx
  8038a9:	f7 f5                	div    %ebp
  8038ab:	89 c8                	mov    %ecx,%eax
  8038ad:	f7 f5                	div    %ebp
  8038af:	89 d0                	mov    %edx,%eax
  8038b1:	e9 44 ff ff ff       	jmp    8037fa <__umoddi3+0x3e>
  8038b6:	66 90                	xchg   %ax,%ax
  8038b8:	89 c8                	mov    %ecx,%eax
  8038ba:	89 f2                	mov    %esi,%edx
  8038bc:	83 c4 1c             	add    $0x1c,%esp
  8038bf:	5b                   	pop    %ebx
  8038c0:	5e                   	pop    %esi
  8038c1:	5f                   	pop    %edi
  8038c2:	5d                   	pop    %ebp
  8038c3:	c3                   	ret    
  8038c4:	3b 04 24             	cmp    (%esp),%eax
  8038c7:	72 06                	jb     8038cf <__umoddi3+0x113>
  8038c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038cd:	77 0f                	ja     8038de <__umoddi3+0x122>
  8038cf:	89 f2                	mov    %esi,%edx
  8038d1:	29 f9                	sub    %edi,%ecx
  8038d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038d7:	89 14 24             	mov    %edx,(%esp)
  8038da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038e2:	8b 14 24             	mov    (%esp),%edx
  8038e5:	83 c4 1c             	add    $0x1c,%esp
  8038e8:	5b                   	pop    %ebx
  8038e9:	5e                   	pop    %esi
  8038ea:	5f                   	pop    %edi
  8038eb:	5d                   	pop    %ebp
  8038ec:	c3                   	ret    
  8038ed:	8d 76 00             	lea    0x0(%esi),%esi
  8038f0:	2b 04 24             	sub    (%esp),%eax
  8038f3:	19 fa                	sbb    %edi,%edx
  8038f5:	89 d1                	mov    %edx,%ecx
  8038f7:	89 c6                	mov    %eax,%esi
  8038f9:	e9 71 ff ff ff       	jmp    80386f <__umoddi3+0xb3>
  8038fe:	66 90                	xchg   %ax,%ax
  803900:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803904:	72 ea                	jb     8038f0 <__umoddi3+0x134>
  803906:	89 d9                	mov    %ebx,%ecx
  803908:	e9 62 ff ff ff       	jmp    80386f <__umoddi3+0xb3>
