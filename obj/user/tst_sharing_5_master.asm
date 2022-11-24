
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
  800031:	e8 b7 03 00 00       	call   8003ed <libmain>
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
  80008d:	68 20 20 80 00       	push   $0x802020
  800092:	6a 12                	push   $0x12
  800094:	68 3c 20 80 00       	push   $0x80203c
  800099:	e8 8b 04 00 00       	call   800529 <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 58 20 80 00       	push   $0x802058
  8000a6:	e8 32 07 00 00       	call   8007dd <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 8c 20 80 00       	push   $0x80208c
  8000b6:	e8 22 07 00 00       	call   8007dd <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 e8 20 80 00       	push   $0x8020e8
  8000c6:	e8 12 07 00 00       	call   8007dd <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 84 19 00 00       	call   801a57 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 1c 21 80 00       	push   $0x80211c
  8000de:	e8 fa 06 00 00       	call   8007dd <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000eb:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f6:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000fc:	89 c1                	mov    %eax,%ecx
  8000fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800103:	8b 40 74             	mov    0x74(%eax),%eax
  800106:	52                   	push   %edx
  800107:	51                   	push   %ecx
  800108:	50                   	push   %eax
  800109:	68 5d 21 80 00       	push   $0x80215d
  80010e:	e8 ef 18 00 00       	call   801a02 <sys_create_env>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800124:	a1 20 30 80 00       	mov    0x803020,%eax
  800129:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80012f:	89 c1                	mov    %eax,%ecx
  800131:	a1 20 30 80 00       	mov    0x803020,%eax
  800136:	8b 40 74             	mov    0x74(%eax),%eax
  800139:	52                   	push   %edx
  80013a:	51                   	push   %ecx
  80013b:	50                   	push   %eax
  80013c:	68 5d 21 80 00       	push   $0x80215d
  800141:	e8 bc 18 00 00       	call   801a02 <sys_create_env>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  80014c:	e8 3f 16 00 00       	call   801790 <sys_calculate_free_frames>
  800151:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	6a 01                	push   $0x1
  800159:	68 00 10 00 00       	push   $0x1000
  80015e:	68 68 21 80 00       	push   $0x802168
  800163:	e8 74 14 00 00       	call   8015dc <smalloc>
  800168:	83 c4 10             	add    $0x10,%esp
  80016b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 6c 21 80 00       	push   $0x80216c
  800176:	e8 62 06 00 00       	call   8007dd <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80017e:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800185:	74 14                	je     80019b <_main+0x163>
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	68 8c 21 80 00       	push   $0x80218c
  80018f:	6a 24                	push   $0x24
  800191:	68 3c 20 80 00       	push   $0x80203c
  800196:	e8 8e 03 00 00       	call   800529 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80019b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80019e:	e8 ed 15 00 00       	call   801790 <sys_calculate_free_frames>
  8001a3:	29 c3                	sub    %eax,%ebx
  8001a5:	89 d8                	mov    %ebx,%eax
  8001a7:	83 f8 04             	cmp    $0x4,%eax
  8001aa:	74 14                	je     8001c0 <_main+0x188>
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 f8 21 80 00       	push   $0x8021f8
  8001b4:	6a 25                	push   $0x25
  8001b6:	68 3c 20 80 00       	push   $0x80203c
  8001bb:	e8 69 03 00 00       	call   800529 <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001c0:	e8 89 19 00 00       	call   801b4e <rsttst>

		sys_run_env(envIdSlave1);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001cb:	e8 50 18 00 00       	call   801a20 <sys_run_env>
  8001d0:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d9:	e8 42 18 00 00       	call   801a20 <sys_run_env>
  8001de:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 76 22 80 00       	push   $0x802276
  8001e9:	e8 ef 05 00 00       	call   8007dd <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001f1:	83 ec 0c             	sub    $0xc,%esp
  8001f4:	68 b8 0b 00 00       	push   $0xbb8
  8001f9:	e8 04 1b 00 00       	call   801d02 <env_sleep>
  8001fe:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  800201:	e8 c2 19 00 00       	call   801bc8 <gettst>
  800206:	83 f8 02             	cmp    $0x2,%eax
  800209:	74 14                	je     80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 8d 22 80 00       	push   $0x80228d
  800213:	6a 31                	push   $0x31
  800215:	68 3c 20 80 00       	push   $0x80203c
  80021a:	e8 0a 03 00 00       	call   800529 <_panic>

		sfree(x);
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	ff 75 dc             	pushl  -0x24(%ebp)
  800225:	e8 06 14 00 00       	call   801630 <sfree>
  80022a:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	68 9c 22 80 00       	push   $0x80229c
  800235:	e8 a3 05 00 00       	call   8007dd <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  80023d:	e8 4e 15 00 00       	call   801790 <sys_calculate_free_frames>
  800242:	89 c2                	mov    %eax,%edx
  800244:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800247:	29 c2                	sub    %eax,%edx
  800249:	89 d0                	mov    %edx,%eax
  80024b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80024e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800252:	74 14                	je     800268 <_main+0x230>
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	68 bc 22 80 00       	push   $0x8022bc
  80025c:	6a 36                	push   $0x36
  80025e:	68 3c 20 80 00       	push   $0x80203c
  800263:	e8 c1 02 00 00       	call   800529 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 ec 22 80 00       	push   $0x8022ec
  800270:	e8 68 05 00 00       	call   8007dd <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	68 10 23 80 00       	push   $0x802310
  800280:	e8 58 05 00 00       	call   8007dd <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800288:	a1 20 30 80 00       	mov    0x803020,%eax
  80028d:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800293:	a1 20 30 80 00       	mov    0x803020,%eax
  800298:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80029e:	89 c1                	mov    %eax,%ecx
  8002a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a5:	8b 40 74             	mov    0x74(%eax),%eax
  8002a8:	52                   	push   %edx
  8002a9:	51                   	push   %ecx
  8002aa:	50                   	push   %eax
  8002ab:	68 40 23 80 00       	push   $0x802340
  8002b0:	e8 4d 17 00 00       	call   801a02 <sys_create_env>
  8002b5:	83 c4 10             	add    $0x10,%esp
  8002b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c0:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cb:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002d1:	89 c1                	mov    %eax,%ecx
  8002d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d8:	8b 40 74             	mov    0x74(%eax),%eax
  8002db:	52                   	push   %edx
  8002dc:	51                   	push   %ecx
  8002dd:	50                   	push   %eax
  8002de:	68 4d 23 80 00       	push   $0x80234d
  8002e3:	e8 1a 17 00 00       	call   801a02 <sys_create_env>
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	6a 01                	push   $0x1
  8002f3:	68 00 10 00 00       	push   $0x1000
  8002f8:	68 5a 23 80 00       	push   $0x80235a
  8002fd:	e8 da 12 00 00       	call   8015dc <smalloc>
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 5c 23 80 00       	push   $0x80235c
  800310:	e8 c8 04 00 00       	call   8007dd <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	6a 01                	push   $0x1
  80031d:	68 00 10 00 00       	push   $0x1000
  800322:	68 68 21 80 00       	push   $0x802168
  800327:	e8 b0 12 00 00       	call   8015dc <smalloc>
  80032c:	83 c4 10             	add    $0x10,%esp
  80032f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  800332:	83 ec 0c             	sub    $0xc,%esp
  800335:	68 6c 21 80 00       	push   $0x80216c
  80033a:	e8 9e 04 00 00       	call   8007dd <cprintf>
  80033f:	83 c4 10             	add    $0x10,%esp

		rsttst();
  800342:	e8 07 18 00 00       	call   801b4e <rsttst>

		sys_run_env(envIdSlaveB1);
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80034d:	e8 ce 16 00 00       	call   801a20 <sys_run_env>
  800352:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  800355:	83 ec 0c             	sub    $0xc,%esp
  800358:	ff 75 d0             	pushl  -0x30(%ebp)
  80035b:	e8 c0 16 00 00       	call   801a20 <sys_run_env>
  800360:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 a0 0f 00 00       	push   $0xfa0
  80036b:	e8 92 19 00 00       	call   801d02 <env_sleep>
  800370:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  800373:	e8 18 14 00 00       	call   801790 <sys_calculate_free_frames>
  800378:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	ff 75 cc             	pushl  -0x34(%ebp)
  800381:	e8 aa 12 00 00       	call   801630 <sfree>
  800386:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800389:	83 ec 0c             	sub    $0xc,%esp
  80038c:	68 7c 23 80 00       	push   $0x80237c
  800391:	e8 47 04 00 00       	call   8007dd <cprintf>
  800396:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	ff 75 c8             	pushl  -0x38(%ebp)
  80039f:	e8 8c 12 00 00       	call   801630 <sfree>
  8003a4:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 92 23 80 00       	push   $0x802392
  8003af:	e8 29 04 00 00       	call   8007dd <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003b7:	e8 d4 13 00 00       	call   801790 <sys_calculate_free_frames>
  8003bc:	89 c2                	mov    %eax,%edx
  8003be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003c1:	29 c2                	sub    %eax,%edx
  8003c3:	89 d0                	mov    %edx,%eax
  8003c5:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003c8:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003cc:	74 14                	je     8003e2 <_main+0x3aa>
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	68 a8 23 80 00       	push   $0x8023a8
  8003d6:	6a 57                	push   $0x57
  8003d8:	68 3c 20 80 00       	push   $0x80203c
  8003dd:	e8 47 01 00 00       	call   800529 <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003e2:	e8 c7 17 00 00       	call   801bae <inctst>


	}


	return;
  8003e7:	90                   	nop
}
  8003e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003eb:	c9                   	leave  
  8003ec:	c3                   	ret    

008003ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003f3:	e8 78 16 00 00       	call   801a70 <sys_getenvindex>
  8003f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	c1 e0 03             	shl    $0x3,%eax
  800403:	01 d0                	add    %edx,%eax
  800405:	01 c0                	add    %eax,%eax
  800407:	01 d0                	add    %edx,%eax
  800409:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	c1 e0 04             	shl    $0x4,%eax
  800415:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80041a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80041f:	a1 20 30 80 00       	mov    0x803020,%eax
  800424:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80042a:	84 c0                	test   %al,%al
  80042c:	74 0f                	je     80043d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80042e:	a1 20 30 80 00       	mov    0x803020,%eax
  800433:	05 5c 05 00 00       	add    $0x55c,%eax
  800438:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80043d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800441:	7e 0a                	jle    80044d <libmain+0x60>
		binaryname = argv[0];
  800443:	8b 45 0c             	mov    0xc(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	ff 75 0c             	pushl  0xc(%ebp)
  800453:	ff 75 08             	pushl  0x8(%ebp)
  800456:	e8 dd fb ff ff       	call   800038 <_main>
  80045b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80045e:	e8 1a 14 00 00       	call   80187d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	68 68 24 80 00       	push   $0x802468
  80046b:	e8 6d 03 00 00       	call   8007dd <cprintf>
  800470:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800473:	a1 20 30 80 00       	mov    0x803020,%eax
  800478:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80047e:	a1 20 30 80 00       	mov    0x803020,%eax
  800483:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800489:	83 ec 04             	sub    $0x4,%esp
  80048c:	52                   	push   %edx
  80048d:	50                   	push   %eax
  80048e:	68 90 24 80 00       	push   $0x802490
  800493:	e8 45 03 00 00       	call   8007dd <cprintf>
  800498:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80049b:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ab:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004bc:	51                   	push   %ecx
  8004bd:	52                   	push   %edx
  8004be:	50                   	push   %eax
  8004bf:	68 b8 24 80 00       	push   $0x8024b8
  8004c4:	e8 14 03 00 00       	call   8007dd <cprintf>
  8004c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	50                   	push   %eax
  8004db:	68 10 25 80 00       	push   $0x802510
  8004e0:	e8 f8 02 00 00       	call   8007dd <cprintf>
  8004e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004e8:	83 ec 0c             	sub    $0xc,%esp
  8004eb:	68 68 24 80 00       	push   $0x802468
  8004f0:	e8 e8 02 00 00       	call   8007dd <cprintf>
  8004f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004f8:	e8 9a 13 00 00       	call   801897 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004fd:	e8 19 00 00 00       	call   80051b <exit>
}
  800502:	90                   	nop
  800503:	c9                   	leave  
  800504:	c3                   	ret    

00800505 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	6a 00                	push   $0x0
  800510:	e8 27 15 00 00       	call   801a3c <sys_destroy_env>
  800515:	83 c4 10             	add    $0x10,%esp
}
  800518:	90                   	nop
  800519:	c9                   	leave  
  80051a:	c3                   	ret    

0080051b <exit>:

void
exit(void)
{
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800521:	e8 7c 15 00 00       	call   801aa2 <sys_exit_env>
}
  800526:	90                   	nop
  800527:	c9                   	leave  
  800528:	c3                   	ret    

00800529 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800529:	55                   	push   %ebp
  80052a:	89 e5                	mov    %esp,%ebp
  80052c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80052f:	8d 45 10             	lea    0x10(%ebp),%eax
  800532:	83 c0 04             	add    $0x4,%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800538:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	74 16                	je     800557 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800541:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	50                   	push   %eax
  80054a:	68 24 25 80 00       	push   $0x802524
  80054f:	e8 89 02 00 00       	call   8007dd <cprintf>
  800554:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800557:	a1 00 30 80 00       	mov    0x803000,%eax
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	ff 75 08             	pushl  0x8(%ebp)
  800562:	50                   	push   %eax
  800563:	68 29 25 80 00       	push   $0x802529
  800568:	e8 70 02 00 00       	call   8007dd <cprintf>
  80056d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800570:	8b 45 10             	mov    0x10(%ebp),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 f4             	pushl  -0xc(%ebp)
  800579:	50                   	push   %eax
  80057a:	e8 f3 01 00 00       	call   800772 <vcprintf>
  80057f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	6a 00                	push   $0x0
  800587:	68 45 25 80 00       	push   $0x802545
  80058c:	e8 e1 01 00 00       	call   800772 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800594:	e8 82 ff ff ff       	call   80051b <exit>

	// should not return here
	while (1) ;
  800599:	eb fe                	jmp    800599 <_panic+0x70>

0080059b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a6:	8b 50 74             	mov    0x74(%eax),%edx
  8005a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ac:	39 c2                	cmp    %eax,%edx
  8005ae:	74 14                	je     8005c4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005b0:	83 ec 04             	sub    $0x4,%esp
  8005b3:	68 48 25 80 00       	push   $0x802548
  8005b8:	6a 26                	push   $0x26
  8005ba:	68 94 25 80 00       	push   $0x802594
  8005bf:	e8 65 ff ff ff       	call   800529 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005d2:	e9 c2 00 00 00       	jmp    800699 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e4:	01 d0                	add    %edx,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	85 c0                	test   %eax,%eax
  8005ea:	75 08                	jne    8005f4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005ef:	e9 a2 00 00 00       	jmp    800696 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800602:	eb 69                	jmp    80066d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800604:	a1 20 30 80 00       	mov    0x803020,%eax
  800609:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80060f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800612:	89 d0                	mov    %edx,%eax
  800614:	01 c0                	add    %eax,%eax
  800616:	01 d0                	add    %edx,%eax
  800618:	c1 e0 03             	shl    $0x3,%eax
  80061b:	01 c8                	add    %ecx,%eax
  80061d:	8a 40 04             	mov    0x4(%eax),%al
  800620:	84 c0                	test   %al,%al
  800622:	75 46                	jne    80066a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800624:	a1 20 30 80 00       	mov    0x803020,%eax
  800629:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80062f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800632:	89 d0                	mov    %edx,%eax
  800634:	01 c0                	add    %eax,%eax
  800636:	01 d0                	add    %edx,%eax
  800638:	c1 e0 03             	shl    $0x3,%eax
  80063b:	01 c8                	add    %ecx,%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800642:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800645:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80064a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80064c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	01 c8                	add    %ecx,%eax
  80065b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80065d:	39 c2                	cmp    %eax,%edx
  80065f:	75 09                	jne    80066a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800661:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800668:	eb 12                	jmp    80067c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066a:	ff 45 e8             	incl   -0x18(%ebp)
  80066d:	a1 20 30 80 00       	mov    0x803020,%eax
  800672:	8b 50 74             	mov    0x74(%eax),%edx
  800675:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800678:	39 c2                	cmp    %eax,%edx
  80067a:	77 88                	ja     800604 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80067c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800680:	75 14                	jne    800696 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	68 a0 25 80 00       	push   $0x8025a0
  80068a:	6a 3a                	push   $0x3a
  80068c:	68 94 25 80 00       	push   $0x802594
  800691:	e8 93 fe ff ff       	call   800529 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800696:	ff 45 f0             	incl   -0x10(%ebp)
  800699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80069f:	0f 8c 32 ff ff ff    	jl     8005d7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006b3:	eb 26                	jmp    8006db <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ba:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c3:	89 d0                	mov    %edx,%eax
  8006c5:	01 c0                	add    %eax,%eax
  8006c7:	01 d0                	add    %edx,%eax
  8006c9:	c1 e0 03             	shl    $0x3,%eax
  8006cc:	01 c8                	add    %ecx,%eax
  8006ce:	8a 40 04             	mov    0x4(%eax),%al
  8006d1:	3c 01                	cmp    $0x1,%al
  8006d3:	75 03                	jne    8006d8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006d5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006d8:	ff 45 e0             	incl   -0x20(%ebp)
  8006db:	a1 20 30 80 00       	mov    0x803020,%eax
  8006e0:	8b 50 74             	mov    0x74(%eax),%edx
  8006e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e6:	39 c2                	cmp    %eax,%edx
  8006e8:	77 cb                	ja     8006b5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006f0:	74 14                	je     800706 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	68 f4 25 80 00       	push   $0x8025f4
  8006fa:	6a 44                	push   $0x44
  8006fc:	68 94 25 80 00       	push   $0x802594
  800701:	e8 23 fe ff ff       	call   800529 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800706:	90                   	nop
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80070f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	8d 48 01             	lea    0x1(%eax),%ecx
  800717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071a:	89 0a                	mov    %ecx,(%edx)
  80071c:	8b 55 08             	mov    0x8(%ebp),%edx
  80071f:	88 d1                	mov    %dl,%cl
  800721:	8b 55 0c             	mov    0xc(%ebp),%edx
  800724:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800732:	75 2c                	jne    800760 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800734:	a0 24 30 80 00       	mov    0x803024,%al
  800739:	0f b6 c0             	movzbl %al,%eax
  80073c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073f:	8b 12                	mov    (%edx),%edx
  800741:	89 d1                	mov    %edx,%ecx
  800743:	8b 55 0c             	mov    0xc(%ebp),%edx
  800746:	83 c2 08             	add    $0x8,%edx
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	50                   	push   %eax
  80074d:	51                   	push   %ecx
  80074e:	52                   	push   %edx
  80074f:	e8 7b 0f 00 00       	call   8016cf <sys_cputs>
  800754:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800760:	8b 45 0c             	mov    0xc(%ebp),%eax
  800763:	8b 40 04             	mov    0x4(%eax),%eax
  800766:	8d 50 01             	lea    0x1(%eax),%edx
  800769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80076f:	90                   	nop
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80077b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800782:	00 00 00 
	b.cnt = 0;
  800785:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80078c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80078f:	ff 75 0c             	pushl  0xc(%ebp)
  800792:	ff 75 08             	pushl  0x8(%ebp)
  800795:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80079b:	50                   	push   %eax
  80079c:	68 09 07 80 00       	push   $0x800709
  8007a1:	e8 11 02 00 00       	call   8009b7 <vprintfmt>
  8007a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007a9:	a0 24 30 80 00       	mov    0x803024,%al
  8007ae:	0f b6 c0             	movzbl %al,%eax
  8007b1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007b7:	83 ec 04             	sub    $0x4,%esp
  8007ba:	50                   	push   %eax
  8007bb:	52                   	push   %edx
  8007bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007c2:	83 c0 08             	add    $0x8,%eax
  8007c5:	50                   	push   %eax
  8007c6:	e8 04 0f 00 00       	call   8016cf <sys_cputs>
  8007cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ce:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007db:	c9                   	leave  
  8007dc:	c3                   	ret    

008007dd <cprintf>:

int cprintf(const char *fmt, ...) {
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007e3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f9:	50                   	push   %eax
  8007fa:	e8 73 ff ff ff       	call   800772 <vcprintf>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800805:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800808:	c9                   	leave  
  800809:	c3                   	ret    

0080080a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800810:	e8 68 10 00 00       	call   80187d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800815:	8d 45 0c             	lea    0xc(%ebp),%eax
  800818:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	50                   	push   %eax
  800825:	e8 48 ff ff ff       	call   800772 <vcprintf>
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800830:	e8 62 10 00 00       	call   801897 <sys_enable_interrupt>
	return cnt;
  800835:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800838:	c9                   	leave  
  800839:	c3                   	ret    

0080083a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	53                   	push   %ebx
  80083e:	83 ec 14             	sub    $0x14,%esp
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80084d:	8b 45 18             	mov    0x18(%ebp),%eax
  800850:	ba 00 00 00 00       	mov    $0x0,%edx
  800855:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800858:	77 55                	ja     8008af <printnum+0x75>
  80085a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80085d:	72 05                	jb     800864 <printnum+0x2a>
  80085f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800862:	77 4b                	ja     8008af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800864:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800867:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80086a:	8b 45 18             	mov    0x18(%ebp),%eax
  80086d:	ba 00 00 00 00       	mov    $0x0,%edx
  800872:	52                   	push   %edx
  800873:	50                   	push   %eax
  800874:	ff 75 f4             	pushl  -0xc(%ebp)
  800877:	ff 75 f0             	pushl  -0x10(%ebp)
  80087a:	e8 39 15 00 00       	call   801db8 <__udivdi3>
  80087f:	83 c4 10             	add    $0x10,%esp
  800882:	83 ec 04             	sub    $0x4,%esp
  800885:	ff 75 20             	pushl  0x20(%ebp)
  800888:	53                   	push   %ebx
  800889:	ff 75 18             	pushl  0x18(%ebp)
  80088c:	52                   	push   %edx
  80088d:	50                   	push   %eax
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	ff 75 08             	pushl  0x8(%ebp)
  800894:	e8 a1 ff ff ff       	call   80083a <printnum>
  800899:	83 c4 20             	add    $0x20,%esp
  80089c:	eb 1a                	jmp    8008b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	ff 75 20             	pushl  0x20(%ebp)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008af:	ff 4d 1c             	decl   0x1c(%ebp)
  8008b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008b6:	7f e6                	jg     80089e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c6:	53                   	push   %ebx
  8008c7:	51                   	push   %ecx
  8008c8:	52                   	push   %edx
  8008c9:	50                   	push   %eax
  8008ca:	e8 f9 15 00 00       	call   801ec8 <__umoddi3>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	05 54 28 80 00       	add    $0x802854,%eax
  8008d7:	8a 00                	mov    (%eax),%al
  8008d9:	0f be c0             	movsbl %al,%eax
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 0c             	pushl  0xc(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	ff d0                	call   *%eax
  8008e8:	83 c4 10             	add    $0x10,%esp
}
  8008eb:	90                   	nop
  8008ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    

008008f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f8:	7e 1c                	jle    800916 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	8d 50 08             	lea    0x8(%eax),%edx
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	89 10                	mov    %edx,(%eax)
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	83 e8 08             	sub    $0x8,%eax
  80090f:	8b 50 04             	mov    0x4(%eax),%edx
  800912:	8b 00                	mov    (%eax),%eax
  800914:	eb 40                	jmp    800956 <getuint+0x65>
	else if (lflag)
  800916:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091a:	74 1e                	je     80093a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	8b 00                	mov    (%eax),%eax
  800921:	8d 50 04             	lea    0x4(%eax),%edx
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	89 10                	mov    %edx,(%eax)
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	83 e8 04             	sub    $0x4,%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	ba 00 00 00 00       	mov    $0x0,%edx
  800938:	eb 1c                	jmp    800956 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	8d 50 04             	lea    0x4(%eax),%edx
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	89 10                	mov    %edx,(%eax)
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80095b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80095f:	7e 1c                	jle    80097d <getint+0x25>
		return va_arg(*ap, long long);
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	8d 50 08             	lea    0x8(%eax),%edx
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 10                	mov    %edx,(%eax)
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	83 e8 08             	sub    $0x8,%eax
  800976:	8b 50 04             	mov    0x4(%eax),%edx
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	eb 38                	jmp    8009b5 <getint+0x5d>
	else if (lflag)
  80097d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800981:	74 1a                	je     80099d <getint+0x45>
		return va_arg(*ap, long);
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	8d 50 04             	lea    0x4(%eax),%edx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	89 10                	mov    %edx,(%eax)
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	83 e8 04             	sub    $0x4,%eax
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	99                   	cltd   
  80099b:	eb 18                	jmp    8009b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	8d 50 04             	lea    0x4(%eax),%edx
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	89 10                	mov    %edx,(%eax)
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8b 00                	mov    (%eax),%eax
  8009af:	83 e8 04             	sub    $0x4,%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	99                   	cltd   
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	56                   	push   %esi
  8009bb:	53                   	push   %ebx
  8009bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bf:	eb 17                	jmp    8009d8 <vprintfmt+0x21>
			if (ch == '\0')
  8009c1:	85 db                	test   %ebx,%ebx
  8009c3:	0f 84 af 03 00 00    	je     800d78 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	53                   	push   %ebx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	ff d0                	call   *%eax
  8009d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009db:	8d 50 01             	lea    0x1(%eax),%edx
  8009de:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f b6 d8             	movzbl %al,%ebx
  8009e6:	83 fb 25             	cmp    $0x25,%ebx
  8009e9:	75 d6                	jne    8009c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a04:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0e:	8d 50 01             	lea    0x1(%eax),%edx
  800a11:	89 55 10             	mov    %edx,0x10(%ebp)
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	0f b6 d8             	movzbl %al,%ebx
  800a19:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a1c:	83 f8 55             	cmp    $0x55,%eax
  800a1f:	0f 87 2b 03 00 00    	ja     800d50 <vprintfmt+0x399>
  800a25:	8b 04 85 78 28 80 00 	mov    0x802878(,%eax,4),%eax
  800a2c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a2e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a32:	eb d7                	jmp    800a0b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a34:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a38:	eb d1                	jmp    800a0b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a44:	89 d0                	mov    %edx,%eax
  800a46:	c1 e0 02             	shl    $0x2,%eax
  800a49:	01 d0                	add    %edx,%eax
  800a4b:	01 c0                	add    %eax,%eax
  800a4d:	01 d8                	add    %ebx,%eax
  800a4f:	83 e8 30             	sub    $0x30,%eax
  800a52:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a55:	8b 45 10             	mov    0x10(%ebp),%eax
  800a58:	8a 00                	mov    (%eax),%al
  800a5a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a5d:	83 fb 2f             	cmp    $0x2f,%ebx
  800a60:	7e 3e                	jle    800aa0 <vprintfmt+0xe9>
  800a62:	83 fb 39             	cmp    $0x39,%ebx
  800a65:	7f 39                	jg     800aa0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a67:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a6a:	eb d5                	jmp    800a41 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6f:	83 c0 04             	add    $0x4,%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
  800a75:	8b 45 14             	mov    0x14(%ebp),%eax
  800a78:	83 e8 04             	sub    $0x4,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a80:	eb 1f                	jmp    800aa1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a86:	79 83                	jns    800a0b <vprintfmt+0x54>
				width = 0;
  800a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a8f:	e9 77 ff ff ff       	jmp    800a0b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a94:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a9b:	e9 6b ff ff ff       	jmp    800a0b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aa0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aa1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa5:	0f 89 60 ff ff ff    	jns    800a0b <vprintfmt+0x54>
				width = precision, precision = -1;
  800aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ab1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ab8:	e9 4e ff ff ff       	jmp    800a0b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800abd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ac0:	e9 46 ff ff ff       	jmp    800a0b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	83 c0 04             	add    $0x4,%eax
  800acb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	83 e8 04             	sub    $0x4,%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	ff 75 0c             	pushl  0xc(%ebp)
  800adc:	50                   	push   %eax
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
			break;
  800ae5:	e9 89 02 00 00       	jmp    800d73 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	83 c0 04             	add    $0x4,%eax
  800af0:	89 45 14             	mov    %eax,0x14(%ebp)
  800af3:	8b 45 14             	mov    0x14(%ebp),%eax
  800af6:	83 e8 04             	sub    $0x4,%eax
  800af9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800afb:	85 db                	test   %ebx,%ebx
  800afd:	79 02                	jns    800b01 <vprintfmt+0x14a>
				err = -err;
  800aff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b01:	83 fb 64             	cmp    $0x64,%ebx
  800b04:	7f 0b                	jg     800b11 <vprintfmt+0x15a>
  800b06:	8b 34 9d c0 26 80 00 	mov    0x8026c0(,%ebx,4),%esi
  800b0d:	85 f6                	test   %esi,%esi
  800b0f:	75 19                	jne    800b2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b11:	53                   	push   %ebx
  800b12:	68 65 28 80 00       	push   $0x802865
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	ff 75 08             	pushl  0x8(%ebp)
  800b1d:	e8 5e 02 00 00       	call   800d80 <printfmt>
  800b22:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b25:	e9 49 02 00 00       	jmp    800d73 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b2a:	56                   	push   %esi
  800b2b:	68 6e 28 80 00       	push   $0x80286e
  800b30:	ff 75 0c             	pushl  0xc(%ebp)
  800b33:	ff 75 08             	pushl  0x8(%ebp)
  800b36:	e8 45 02 00 00       	call   800d80 <printfmt>
  800b3b:	83 c4 10             	add    $0x10,%esp
			break;
  800b3e:	e9 30 02 00 00       	jmp    800d73 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b43:	8b 45 14             	mov    0x14(%ebp),%eax
  800b46:	83 c0 04             	add    $0x4,%eax
  800b49:	89 45 14             	mov    %eax,0x14(%ebp)
  800b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4f:	83 e8 04             	sub    $0x4,%eax
  800b52:	8b 30                	mov    (%eax),%esi
  800b54:	85 f6                	test   %esi,%esi
  800b56:	75 05                	jne    800b5d <vprintfmt+0x1a6>
				p = "(null)";
  800b58:	be 71 28 80 00       	mov    $0x802871,%esi
			if (width > 0 && padc != '-')
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7e 6d                	jle    800bd0 <vprintfmt+0x219>
  800b63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b67:	74 67                	je     800bd0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	50                   	push   %eax
  800b70:	56                   	push   %esi
  800b71:	e8 0c 03 00 00       	call   800e82 <strnlen>
  800b76:	83 c4 10             	add    $0x10,%esp
  800b79:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b7c:	eb 16                	jmp    800b94 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	50                   	push   %eax
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b91:	ff 4d e4             	decl   -0x1c(%ebp)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	7f e4                	jg     800b7e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9a:	eb 34                	jmp    800bd0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ba0:	74 1c                	je     800bbe <vprintfmt+0x207>
  800ba2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ba5:	7e 05                	jle    800bac <vprintfmt+0x1f5>
  800ba7:	83 fb 7e             	cmp    $0x7e,%ebx
  800baa:	7e 12                	jle    800bbe <vprintfmt+0x207>
					putch('?', putdat);
  800bac:	83 ec 08             	sub    $0x8,%esp
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	6a 3f                	push   $0x3f
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	ff d0                	call   *%eax
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	eb 0f                	jmp    800bcd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bcd:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd0:	89 f0                	mov    %esi,%eax
  800bd2:	8d 70 01             	lea    0x1(%eax),%esi
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	0f be d8             	movsbl %al,%ebx
  800bda:	85 db                	test   %ebx,%ebx
  800bdc:	74 24                	je     800c02 <vprintfmt+0x24b>
  800bde:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800be2:	78 b8                	js     800b9c <vprintfmt+0x1e5>
  800be4:	ff 4d e0             	decl   -0x20(%ebp)
  800be7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800beb:	79 af                	jns    800b9c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bed:	eb 13                	jmp    800c02 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bef:	83 ec 08             	sub    $0x8,%esp
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	6a 20                	push   $0x20
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	ff d0                	call   *%eax
  800bfc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bff:	ff 4d e4             	decl   -0x1c(%ebp)
  800c02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c06:	7f e7                	jg     800bef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c08:	e9 66 01 00 00       	jmp    800d73 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c0d:	83 ec 08             	sub    $0x8,%esp
  800c10:	ff 75 e8             	pushl  -0x18(%ebp)
  800c13:	8d 45 14             	lea    0x14(%ebp),%eax
  800c16:	50                   	push   %eax
  800c17:	e8 3c fd ff ff       	call   800958 <getint>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2b:	85 d2                	test   %edx,%edx
  800c2d:	79 23                	jns    800c52 <vprintfmt+0x29b>
				putch('-', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 2d                	push   $0x2d
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c45:	f7 d8                	neg    %eax
  800c47:	83 d2 00             	adc    $0x0,%edx
  800c4a:	f7 da                	neg    %edx
  800c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c59:	e9 bc 00 00 00       	jmp    800d1a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 e8             	pushl  -0x18(%ebp)
  800c64:	8d 45 14             	lea    0x14(%ebp),%eax
  800c67:	50                   	push   %eax
  800c68:	e8 84 fc ff ff       	call   8008f1 <getuint>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7d:	e9 98 00 00 00       	jmp    800d1a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c82:	83 ec 08             	sub    $0x8,%esp
  800c85:	ff 75 0c             	pushl  0xc(%ebp)
  800c88:	6a 58                	push   $0x58
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c92:	83 ec 08             	sub    $0x8,%esp
  800c95:	ff 75 0c             	pushl  0xc(%ebp)
  800c98:	6a 58                	push   $0x58
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	ff d0                	call   *%eax
  800c9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ca2:	83 ec 08             	sub    $0x8,%esp
  800ca5:	ff 75 0c             	pushl  0xc(%ebp)
  800ca8:	6a 58                	push   $0x58
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	ff d0                	call   *%eax
  800caf:	83 c4 10             	add    $0x10,%esp
			break;
  800cb2:	e9 bc 00 00 00       	jmp    800d73 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cb7:	83 ec 08             	sub    $0x8,%esp
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	6a 30                	push   $0x30
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	ff d0                	call   *%eax
  800cc4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	ff 75 0c             	pushl  0xc(%ebp)
  800ccd:	6a 78                	push   $0x78
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	ff d0                	call   *%eax
  800cd4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cda:	83 c0 04             	add    $0x4,%eax
  800cdd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce3:	83 e8 04             	sub    $0x4,%eax
  800ce6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cf9:	eb 1f                	jmp    800d1a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	ff 75 e8             	pushl  -0x18(%ebp)
  800d01:	8d 45 14             	lea    0x14(%ebp),%eax
  800d04:	50                   	push   %eax
  800d05:	e8 e7 fb ff ff       	call   8008f1 <getuint>
  800d0a:	83 c4 10             	add    $0x10,%esp
  800d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d1a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d21:	83 ec 04             	sub    $0x4,%esp
  800d24:	52                   	push   %edx
  800d25:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d28:	50                   	push   %eax
  800d29:	ff 75 f4             	pushl  -0xc(%ebp)
  800d2c:	ff 75 f0             	pushl  -0x10(%ebp)
  800d2f:	ff 75 0c             	pushl  0xc(%ebp)
  800d32:	ff 75 08             	pushl  0x8(%ebp)
  800d35:	e8 00 fb ff ff       	call   80083a <printnum>
  800d3a:	83 c4 20             	add    $0x20,%esp
			break;
  800d3d:	eb 34                	jmp    800d73 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	53                   	push   %ebx
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	ff d0                	call   *%eax
  800d4b:	83 c4 10             	add    $0x10,%esp
			break;
  800d4e:	eb 23                	jmp    800d73 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d50:	83 ec 08             	sub    $0x8,%esp
  800d53:	ff 75 0c             	pushl  0xc(%ebp)
  800d56:	6a 25                	push   $0x25
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	ff d0                	call   *%eax
  800d5d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d60:	ff 4d 10             	decl   0x10(%ebp)
  800d63:	eb 03                	jmp    800d68 <vprintfmt+0x3b1>
  800d65:	ff 4d 10             	decl   0x10(%ebp)
  800d68:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6b:	48                   	dec    %eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	3c 25                	cmp    $0x25,%al
  800d70:	75 f3                	jne    800d65 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d72:	90                   	nop
		}
	}
  800d73:	e9 47 fc ff ff       	jmp    8009bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d78:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d86:	8d 45 10             	lea    0x10(%ebp),%eax
  800d89:	83 c0 04             	add    $0x4,%eax
  800d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d92:	ff 75 f4             	pushl  -0xc(%ebp)
  800d95:	50                   	push   %eax
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	ff 75 08             	pushl  0x8(%ebp)
  800d9c:	e8 16 fc ff ff       	call   8009b7 <vprintfmt>
  800da1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800da4:	90                   	nop
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	8b 40 08             	mov    0x8(%eax),%eax
  800db0:	8d 50 01             	lea    0x1(%eax),%edx
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	8b 10                	mov    (%eax),%edx
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	8b 40 04             	mov    0x4(%eax),%eax
  800dc4:	39 c2                	cmp    %eax,%edx
  800dc6:	73 12                	jae    800dda <sprintputch+0x33>
		*b->buf++ = ch;
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8b 00                	mov    (%eax),%eax
  800dcd:	8d 48 01             	lea    0x1(%eax),%ecx
  800dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd3:	89 0a                	mov    %ecx,(%edx)
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	88 10                	mov    %dl,(%eax)
}
  800dda:	90                   	nop
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8d 50 ff             	lea    -0x1(%eax),%edx
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	01 d0                	add    %edx,%eax
  800df4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e02:	74 06                	je     800e0a <vsnprintf+0x2d>
  800e04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e08:	7f 07                	jg     800e11 <vsnprintf+0x34>
		return -E_INVAL;
  800e0a:	b8 03 00 00 00       	mov    $0x3,%eax
  800e0f:	eb 20                	jmp    800e31 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e11:	ff 75 14             	pushl  0x14(%ebp)
  800e14:	ff 75 10             	pushl  0x10(%ebp)
  800e17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e1a:	50                   	push   %eax
  800e1b:	68 a7 0d 80 00       	push   $0x800da7
  800e20:	e8 92 fb ff ff       	call   8009b7 <vprintfmt>
  800e25:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e31:	c9                   	leave  
  800e32:	c3                   	ret    

00800e33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e39:	8d 45 10             	lea    0x10(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e42:	8b 45 10             	mov    0x10(%ebp),%eax
  800e45:	ff 75 f4             	pushl  -0xc(%ebp)
  800e48:	50                   	push   %eax
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	ff 75 08             	pushl  0x8(%ebp)
  800e4f:	e8 89 ff ff ff       	call   800ddd <vsnprintf>
  800e54:	83 c4 10             	add    $0x10,%esp
  800e57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6c:	eb 06                	jmp    800e74 <strlen+0x15>
		n++;
  800e6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e71:	ff 45 08             	incl   0x8(%ebp)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	84 c0                	test   %al,%al
  800e7b:	75 f1                	jne    800e6e <strlen+0xf>
		n++;
	return n;
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8f:	eb 09                	jmp    800e9a <strnlen+0x18>
		n++;
  800e91:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e94:	ff 45 08             	incl   0x8(%ebp)
  800e97:	ff 4d 0c             	decl   0xc(%ebp)
  800e9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e9e:	74 09                	je     800ea9 <strnlen+0x27>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	84 c0                	test   %al,%al
  800ea7:	75 e8                	jne    800e91 <strnlen+0xf>
		n++;
	return n;
  800ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eba:	90                   	nop
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8d 50 01             	lea    0x1(%eax),%edx
  800ec1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ecd:	8a 12                	mov    (%edx),%dl
  800ecf:	88 10                	mov    %dl,(%eax)
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 e4                	jne    800ebb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ee8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eef:	eb 1f                	jmp    800f10 <strncpy+0x34>
		*dst++ = *src;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	8d 50 01             	lea    0x1(%eax),%edx
  800ef7:	89 55 08             	mov    %edx,0x8(%ebp)
  800efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efd:	8a 12                	mov    (%edx),%dl
  800eff:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	84 c0                	test   %al,%al
  800f08:	74 03                	je     800f0d <strncpy+0x31>
			src++;
  800f0a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f0d:	ff 45 fc             	incl   -0x4(%ebp)
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f16:	72 d9                	jb     800ef1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f1b:	c9                   	leave  
  800f1c:	c3                   	ret    

00800f1d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2d:	74 30                	je     800f5f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f2f:	eb 16                	jmp    800f47 <strlcpy+0x2a>
			*dst++ = *src++;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8d 50 01             	lea    0x1(%eax),%edx
  800f37:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f43:	8a 12                	mov    (%edx),%dl
  800f45:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f47:	ff 4d 10             	decl   0x10(%ebp)
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 09                	je     800f59 <strlcpy+0x3c>
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	84 c0                	test   %al,%al
  800f57:	75 d8                	jne    800f31 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f65:	29 c2                	sub    %eax,%edx
  800f67:	89 d0                	mov    %edx,%eax
}
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f6e:	eb 06                	jmp    800f76 <strcmp+0xb>
		p++, q++;
  800f70:	ff 45 08             	incl   0x8(%ebp)
  800f73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	84 c0                	test   %al,%al
  800f7d:	74 0e                	je     800f8d <strcmp+0x22>
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 10                	mov    (%eax),%dl
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	38 c2                	cmp    %al,%dl
  800f8b:	74 e3                	je     800f70 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8a 00                	mov    (%eax),%al
  800f92:	0f b6 d0             	movzbl %al,%edx
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	0f b6 c0             	movzbl %al,%eax
  800f9d:	29 c2                	sub    %eax,%edx
  800f9f:	89 d0                	mov    %edx,%eax
}
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fa6:	eb 09                	jmp    800fb1 <strncmp+0xe>
		n--, p++, q++;
  800fa8:	ff 4d 10             	decl   0x10(%ebp)
  800fab:	ff 45 08             	incl   0x8(%ebp)
  800fae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb5:	74 17                	je     800fce <strncmp+0x2b>
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	84 c0                	test   %al,%al
  800fbe:	74 0e                	je     800fce <strncmp+0x2b>
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 10                	mov    (%eax),%dl
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	38 c2                	cmp    %al,%dl
  800fcc:	74 da                	je     800fa8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd2:	75 07                	jne    800fdb <strncmp+0x38>
		return 0;
  800fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd9:	eb 14                	jmp    800fef <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	0f b6 c0             	movzbl %al,%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 04             	sub    $0x4,%esp
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ffd:	eb 12                	jmp    801011 <strchr+0x20>
		if (*s == c)
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801007:	75 05                	jne    80100e <strchr+0x1d>
			return (char *) s;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	eb 11                	jmp    80101f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	84 c0                	test   %al,%al
  801018:	75 e5                	jne    800fff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80101a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 04             	sub    $0x4,%esp
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80102d:	eb 0d                	jmp    80103c <strfind+0x1b>
		if (*s == c)
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801037:	74 0e                	je     801047 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801039:	ff 45 08             	incl   0x8(%ebp)
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	84 c0                	test   %al,%al
  801043:	75 ea                	jne    80102f <strfind+0xe>
  801045:	eb 01                	jmp    801048 <strfind+0x27>
		if (*s == c)
			break;
  801047:	90                   	nop
	return (char *) s;
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801059:	8b 45 10             	mov    0x10(%ebp),%eax
  80105c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80105f:	eb 0e                	jmp    80106f <memset+0x22>
		*p++ = c;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801064:	8d 50 01             	lea    0x1(%eax),%edx
  801067:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80106a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80106f:	ff 4d f8             	decl   -0x8(%ebp)
  801072:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801076:	79 e9                	jns    801061 <memset+0x14>
		*p++ = c;

	return v;
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    

0080107d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801083:	8b 45 0c             	mov    0xc(%ebp),%eax
  801086:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80108f:	eb 16                	jmp    8010a7 <memcpy+0x2a>
		*d++ = *s++;
  801091:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801094:	8d 50 01             	lea    0x1(%eax),%edx
  801097:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109d:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	75 dd                	jne    801091 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010d1:	73 50                	jae    801123 <memmove+0x6a>
  8010d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d9:	01 d0                	add    %edx,%eax
  8010db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010de:	76 43                	jbe    801123 <memmove+0x6a>
		s += n;
  8010e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ec:	eb 10                	jmp    8010fe <memmove+0x45>
			*--d = *--s;
  8010ee:	ff 4d f8             	decl   -0x8(%ebp)
  8010f1:	ff 4d fc             	decl   -0x4(%ebp)
  8010f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f7:	8a 10                	mov    (%eax),%dl
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	8d 50 ff             	lea    -0x1(%eax),%edx
  801104:	89 55 10             	mov    %edx,0x10(%ebp)
  801107:	85 c0                	test   %eax,%eax
  801109:	75 e3                	jne    8010ee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80110b:	eb 23                	jmp    801130 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801110:	8d 50 01             	lea    0x1(%eax),%edx
  801113:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801116:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801119:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80111f:	8a 12                	mov    (%edx),%dl
  801121:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801123:	8b 45 10             	mov    0x10(%ebp),%eax
  801126:	8d 50 ff             	lea    -0x1(%eax),%edx
  801129:	89 55 10             	mov    %edx,0x10(%ebp)
  80112c:	85 c0                	test   %eax,%eax
  80112e:	75 dd                	jne    80110d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801147:	eb 2a                	jmp    801173 <memcmp+0x3e>
		if (*s1 != *s2)
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114c:	8a 10                	mov    (%eax),%dl
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	38 c2                	cmp    %al,%dl
  801155:	74 16                	je     80116d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	0f b6 d0             	movzbl %al,%edx
  80115f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 c0             	movzbl %al,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	eb 18                	jmp    801185 <memcmp+0x50>
		s1++, s2++;
  80116d:	ff 45 fc             	incl   -0x4(%ebp)
  801170:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801173:	8b 45 10             	mov    0x10(%ebp),%eax
  801176:	8d 50 ff             	lea    -0x1(%eax),%edx
  801179:	89 55 10             	mov    %edx,0x10(%ebp)
  80117c:	85 c0                	test   %eax,%eax
  80117e:	75 c9                	jne    801149 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801180:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801185:	c9                   	leave  
  801186:	c3                   	ret    

00801187 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80118d:	8b 55 08             	mov    0x8(%ebp),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801198:	eb 15                	jmp    8011af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 00                	mov    (%eax),%al
  80119f:	0f b6 d0             	movzbl %al,%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	0f b6 c0             	movzbl %al,%eax
  8011a8:	39 c2                	cmp    %eax,%edx
  8011aa:	74 0d                	je     8011b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ac:	ff 45 08             	incl   0x8(%ebp)
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011b5:	72 e3                	jb     80119a <memfind+0x13>
  8011b7:	eb 01                	jmp    8011ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011b9:	90                   	nop
	return (void *) s;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011d3:	eb 03                	jmp    8011d8 <strtol+0x19>
		s++;
  8011d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 20                	cmp    $0x20,%al
  8011df:	74 f4                	je     8011d5 <strtol+0x16>
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 09                	cmp    $0x9,%al
  8011e8:	74 eb                	je     8011d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 2b                	cmp    $0x2b,%al
  8011f1:	75 05                	jne    8011f8 <strtol+0x39>
		s++;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	eb 13                	jmp    80120b <strtol+0x4c>
	else if (*s == '-')
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	3c 2d                	cmp    $0x2d,%al
  8011ff:	75 0a                	jne    80120b <strtol+0x4c>
		s++, neg = 1;
  801201:	ff 45 08             	incl   0x8(%ebp)
  801204:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80120b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120f:	74 06                	je     801217 <strtol+0x58>
  801211:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801215:	75 20                	jne    801237 <strtol+0x78>
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	3c 30                	cmp    $0x30,%al
  80121e:	75 17                	jne    801237 <strtol+0x78>
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	40                   	inc    %eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 78                	cmp    $0x78,%al
  801228:	75 0d                	jne    801237 <strtol+0x78>
		s += 2, base = 16;
  80122a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80122e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801235:	eb 28                	jmp    80125f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801237:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123b:	75 15                	jne    801252 <strtol+0x93>
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	3c 30                	cmp    $0x30,%al
  801244:	75 0c                	jne    801252 <strtol+0x93>
		s++, base = 8;
  801246:	ff 45 08             	incl   0x8(%ebp)
  801249:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801250:	eb 0d                	jmp    80125f <strtol+0xa0>
	else if (base == 0)
  801252:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801256:	75 07                	jne    80125f <strtol+0xa0>
		base = 10;
  801258:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3c 2f                	cmp    $0x2f,%al
  801266:	7e 19                	jle    801281 <strtol+0xc2>
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3c 39                	cmp    $0x39,%al
  80126f:	7f 10                	jg     801281 <strtol+0xc2>
			dig = *s - '0';
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	0f be c0             	movsbl %al,%eax
  801279:	83 e8 30             	sub    $0x30,%eax
  80127c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80127f:	eb 42                	jmp    8012c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	3c 60                	cmp    $0x60,%al
  801288:	7e 19                	jle    8012a3 <strtol+0xe4>
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	3c 7a                	cmp    $0x7a,%al
  801291:	7f 10                	jg     8012a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8a 00                	mov    (%eax),%al
  801298:	0f be c0             	movsbl %al,%eax
  80129b:	83 e8 57             	sub    $0x57,%eax
  80129e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a1:	eb 20                	jmp    8012c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	3c 40                	cmp    $0x40,%al
  8012aa:	7e 39                	jle    8012e5 <strtol+0x126>
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8a 00                	mov    (%eax),%al
  8012b1:	3c 5a                	cmp    $0x5a,%al
  8012b3:	7f 30                	jg     8012e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	0f be c0             	movsbl %al,%eax
  8012bd:	83 e8 37             	sub    $0x37,%eax
  8012c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012c9:	7d 19                	jge    8012e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012cb:	ff 45 08             	incl   0x8(%ebp)
  8012ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012da:	01 d0                	add    %edx,%eax
  8012dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012df:	e9 7b ff ff ff       	jmp    80125f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012e9:	74 08                	je     8012f3 <strtol+0x134>
		*endptr = (char *) s;
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012f7:	74 07                	je     801300 <strtol+0x141>
  8012f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fc:	f7 d8                	neg    %eax
  8012fe:	eb 03                	jmp    801303 <strtol+0x144>
  801300:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801303:	c9                   	leave  
  801304:	c3                   	ret    

00801305 <ltostr>:

void
ltostr(long value, char *str)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80130b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801312:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131d:	79 13                	jns    801332 <ltostr+0x2d>
	{
		neg = 1;
  80131f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80132c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80132f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80133a:	99                   	cltd   
  80133b:	f7 f9                	idiv   %ecx
  80133d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801340:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801343:	8d 50 01             	lea    0x1(%eax),%edx
  801346:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801349:	89 c2                	mov    %eax,%edx
  80134b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134e:	01 d0                	add    %edx,%eax
  801350:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801353:	83 c2 30             	add    $0x30,%edx
  801356:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801358:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801360:	f7 e9                	imul   %ecx
  801362:	c1 fa 02             	sar    $0x2,%edx
  801365:	89 c8                	mov    %ecx,%eax
  801367:	c1 f8 1f             	sar    $0x1f,%eax
  80136a:	29 c2                	sub    %eax,%edx
  80136c:	89 d0                	mov    %edx,%eax
  80136e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801371:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801374:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801379:	f7 e9                	imul   %ecx
  80137b:	c1 fa 02             	sar    $0x2,%edx
  80137e:	89 c8                	mov    %ecx,%eax
  801380:	c1 f8 1f             	sar    $0x1f,%eax
  801383:	29 c2                	sub    %eax,%edx
  801385:	89 d0                	mov    %edx,%eax
  801387:	c1 e0 02             	shl    $0x2,%eax
  80138a:	01 d0                	add    %edx,%eax
  80138c:	01 c0                	add    %eax,%eax
  80138e:	29 c1                	sub    %eax,%ecx
  801390:	89 ca                	mov    %ecx,%edx
  801392:	85 d2                	test   %edx,%edx
  801394:	75 9c                	jne    801332 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801396:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80139d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a0:	48                   	dec    %eax
  8013a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013a8:	74 3d                	je     8013e7 <ltostr+0xe2>
		start = 1 ;
  8013aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b1:	eb 34                	jmp    8013e7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 c2                	add    %eax,%edx
  8013c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	01 c8                	add    %ecx,%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 c2                	add    %eax,%edx
  8013dc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013df:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013e4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ed:	7c c4                	jl     8013b3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	01 d0                	add    %edx,%eax
  8013f7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013fa:	90                   	nop
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801403:	ff 75 08             	pushl  0x8(%ebp)
  801406:	e8 54 fa ff ff       	call   800e5f <strlen>
  80140b:	83 c4 04             	add    $0x4,%esp
  80140e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801411:	ff 75 0c             	pushl  0xc(%ebp)
  801414:	e8 46 fa ff ff       	call   800e5f <strlen>
  801419:	83 c4 04             	add    $0x4,%esp
  80141c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80141f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80142d:	eb 17                	jmp    801446 <strcconcat+0x49>
		final[s] = str1[s] ;
  80142f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801443:	ff 45 fc             	incl   -0x4(%ebp)
  801446:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801449:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80144c:	7c e1                	jl     80142f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80144e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801455:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80145c:	eb 1f                	jmp    80147d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80145e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801461:	8d 50 01             	lea    0x1(%eax),%edx
  801464:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801467:	89 c2                	mov    %eax,%edx
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	01 c2                	add    %eax,%edx
  80146e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 c8                	add    %ecx,%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80147a:	ff 45 f8             	incl   -0x8(%ebp)
  80147d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801480:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801483:	7c d9                	jl     80145e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801485:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	01 d0                	add    %edx,%eax
  80148d:	c6 00 00             	movb   $0x0,(%eax)
}
  801490:	90                   	nop
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801496:	8b 45 14             	mov    0x14(%ebp),%eax
  801499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80149f:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a2:	8b 00                	mov    (%eax),%eax
  8014a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ae:	01 d0                	add    %edx,%eax
  8014b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b6:	eb 0c                	jmp    8014c4 <strsplit+0x31>
			*string++ = 0;
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	8d 50 01             	lea    0x1(%eax),%edx
  8014be:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	84 c0                	test   %al,%al
  8014cb:	74 18                	je     8014e5 <strsplit+0x52>
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	0f be c0             	movsbl %al,%eax
  8014d5:	50                   	push   %eax
  8014d6:	ff 75 0c             	pushl  0xc(%ebp)
  8014d9:	e8 13 fb ff ff       	call   800ff1 <strchr>
  8014de:	83 c4 08             	add    $0x8,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	75 d3                	jne    8014b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	74 5a                	je     801548 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f1:	8b 00                	mov    (%eax),%eax
  8014f3:	83 f8 0f             	cmp    $0xf,%eax
  8014f6:	75 07                	jne    8014ff <strsplit+0x6c>
		{
			return 0;
  8014f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fd:	eb 66                	jmp    801565 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801502:	8b 00                	mov    (%eax),%eax
  801504:	8d 48 01             	lea    0x1(%eax),%ecx
  801507:	8b 55 14             	mov    0x14(%ebp),%edx
  80150a:	89 0a                	mov    %ecx,(%edx)
  80150c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801513:	8b 45 10             	mov    0x10(%ebp),%eax
  801516:	01 c2                	add    %eax,%edx
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80151d:	eb 03                	jmp    801522 <strsplit+0x8f>
			string++;
  80151f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	84 c0                	test   %al,%al
  801529:	74 8b                	je     8014b6 <strsplit+0x23>
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	0f be c0             	movsbl %al,%eax
  801533:	50                   	push   %eax
  801534:	ff 75 0c             	pushl  0xc(%ebp)
  801537:	e8 b5 fa ff ff       	call   800ff1 <strchr>
  80153c:	83 c4 08             	add    $0x8,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	74 dc                	je     80151f <strsplit+0x8c>
			string++;
	}
  801543:	e9 6e ff ff ff       	jmp    8014b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801548:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801549:	8b 45 14             	mov    0x14(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801555:	8b 45 10             	mov    0x10(%ebp),%eax
  801558:	01 d0                	add    %edx,%eax
  80155a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801560:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	68 d0 29 80 00       	push   $0x8029d0
  801575:	6a 0e                	push   $0xe
  801577:	68 0a 2a 80 00       	push   $0x802a0a
  80157c:	e8 a8 ef ff ff       	call   800529 <_panic>

00801581 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801587:	a1 04 30 80 00       	mov    0x803004,%eax
  80158c:	85 c0                	test   %eax,%eax
  80158e:	74 0f                	je     80159f <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801590:	e8 d2 ff ff ff       	call   801567 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801595:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80159c:	00 00 00 
	}
	if (size == 0) return NULL ;
  80159f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015a3:	75 07                	jne    8015ac <malloc+0x2b>
  8015a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015aa:	eb 14                	jmp    8015c0 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	68 18 2a 80 00       	push   $0x802a18
  8015b4:	6a 2e                	push   $0x2e
  8015b6:	68 0a 2a 80 00       	push   $0x802a0a
  8015bb:	e8 69 ef ff ff       	call   800529 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	68 40 2a 80 00       	push   $0x802a40
  8015d0:	6a 49                	push   $0x49
  8015d2:	68 0a 2a 80 00       	push   $0x802a0a
  8015d7:	e8 4d ef ff ff       	call   800529 <_panic>

008015dc <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
  8015e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e5:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8015e8:	83 ec 04             	sub    $0x4,%esp
  8015eb:	68 64 2a 80 00       	push   $0x802a64
  8015f0:	6a 57                	push   $0x57
  8015f2:	68 0a 2a 80 00       	push   $0x802a0a
  8015f7:	e8 2d ef ff ff       	call   800529 <_panic>

008015fc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	68 8c 2a 80 00       	push   $0x802a8c
  80160a:	6a 60                	push   $0x60
  80160c:	68 0a 2a 80 00       	push   $0x802a0a
  801611:	e8 13 ef ff ff       	call   800529 <_panic>

00801616 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80161c:	83 ec 04             	sub    $0x4,%esp
  80161f:	68 b0 2a 80 00       	push   $0x802ab0
  801624:	6a 7c                	push   $0x7c
  801626:	68 0a 2a 80 00       	push   $0x802a0a
  80162b:	e8 f9 ee ff ff       	call   800529 <_panic>

00801630 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	68 d8 2a 80 00       	push   $0x802ad8
  80163e:	68 86 00 00 00       	push   $0x86
  801643:	68 0a 2a 80 00       	push   $0x802a0a
  801648:	e8 dc ee ff ff       	call   800529 <_panic>

0080164d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	68 fc 2a 80 00       	push   $0x802afc
  80165b:	68 91 00 00 00       	push   $0x91
  801660:	68 0a 2a 80 00       	push   $0x802a0a
  801665:	e8 bf ee ff ff       	call   800529 <_panic>

0080166a <shrink>:

}
void shrink(uint32 newSize)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	68 fc 2a 80 00       	push   $0x802afc
  801678:	68 96 00 00 00       	push   $0x96
  80167d:	68 0a 2a 80 00       	push   $0x802a0a
  801682:	e8 a2 ee ff ff       	call   800529 <_panic>

00801687 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	68 fc 2a 80 00       	push   $0x802afc
  801695:	68 9b 00 00 00       	push   $0x9b
  80169a:	68 0a 2a 80 00       	push   $0x802a0a
  80169f:	e8 85 ee ff ff       	call   800529 <_panic>

008016a4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	57                   	push   %edi
  8016a8:	56                   	push   %esi
  8016a9:	53                   	push   %ebx
  8016aa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016b9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016bc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016bf:	cd 30                	int    $0x30
  8016c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	5b                   	pop    %ebx
  8016cb:	5e                   	pop    %esi
  8016cc:	5f                   	pop    %edi
  8016cd:	5d                   	pop    %ebp
  8016ce:	c3                   	ret    

008016cf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	52                   	push   %edx
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	50                   	push   %eax
  8016eb:	6a 00                	push   $0x0
  8016ed:	e8 b2 ff ff ff       	call   8016a4 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	90                   	nop
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 01                	push   $0x1
  801707:	e8 98 ff ff ff       	call   8016a4 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801714:	8b 55 0c             	mov    0xc(%ebp),%edx
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 05                	push   $0x5
  801724:	e8 7b ff ff ff       	call   8016a4 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801733:	8b 75 18             	mov    0x18(%ebp),%esi
  801736:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801739:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	51                   	push   %ecx
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	6a 06                	push   $0x6
  801749:	e8 56 ff ff ff       	call   8016a4 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801754:	5b                   	pop    %ebx
  801755:	5e                   	pop    %esi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    

00801758 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	52                   	push   %edx
  801768:	50                   	push   %eax
  801769:	6a 07                	push   $0x7
  80176b:	e8 34 ff ff ff       	call   8016a4 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 08                	push   $0x8
  801786:	e8 19 ff ff ff       	call   8016a4 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 09                	push   $0x9
  80179f:	e8 00 ff ff ff       	call   8016a4 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 0a                	push   $0xa
  8017b8:	e8 e7 fe ff ff       	call   8016a4 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 0b                	push   $0xb
  8017d1:	e8 ce fe ff ff       	call   8016a4 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	ff 75 08             	pushl  0x8(%ebp)
  8017ea:	6a 0f                	push   $0xf
  8017ec:	e8 b3 fe ff ff       	call   8016a4 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
	return;
  8017f4:	90                   	nop
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	ff 75 0c             	pushl  0xc(%ebp)
  801803:	ff 75 08             	pushl  0x8(%ebp)
  801806:	6a 10                	push   $0x10
  801808:	e8 97 fe ff ff       	call   8016a4 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
	return ;
  801810:	90                   	nop
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	ff 75 10             	pushl  0x10(%ebp)
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	6a 11                	push   $0x11
  801825:	e8 7a fe ff ff       	call   8016a4 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
	return ;
  80182d:	90                   	nop
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 0c                	push   $0xc
  80183f:	e8 60 fe ff ff       	call   8016a4 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	6a 0d                	push   $0xd
  801859:	e8 46 fe ff ff       	call   8016a4 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 0e                	push   $0xe
  801872:	e8 2d fe ff ff       	call   8016a4 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	90                   	nop
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 13                	push   $0x13
  80188c:	e8 13 fe ff ff       	call   8016a4 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	90                   	nop
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 14                	push   $0x14
  8018a6:	e8 f9 fd ff ff       	call   8016a4 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	90                   	nop
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	50                   	push   %eax
  8018ca:	6a 15                	push   $0x15
  8018cc:	e8 d3 fd ff ff       	call   8016a4 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 16                	push   $0x16
  8018e6:	e8 b9 fd ff ff       	call   8016a4 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	90                   	nop
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	50                   	push   %eax
  801901:	6a 17                	push   $0x17
  801903:	e8 9c fd ff ff       	call   8016a4 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	52                   	push   %edx
  80191d:	50                   	push   %eax
  80191e:	6a 1a                	push   $0x1a
  801920:	e8 7f fd ff ff       	call   8016a4 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	6a 18                	push   $0x18
  80193d:	e8 62 fd ff ff       	call   8016a4 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	90                   	nop
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80194b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	52                   	push   %edx
  801958:	50                   	push   %eax
  801959:	6a 19                	push   $0x19
  80195b:	e8 44 fd ff ff       	call   8016a4 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	90                   	nop
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 04             	sub    $0x4,%esp
  80196c:	8b 45 10             	mov    0x10(%ebp),%eax
  80196f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801972:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801975:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	6a 00                	push   $0x0
  80197e:	51                   	push   %ecx
  80197f:	52                   	push   %edx
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	50                   	push   %eax
  801984:	6a 1b                	push   $0x1b
  801986:	e8 19 fd ff ff       	call   8016a4 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801993:	8b 55 0c             	mov    0xc(%ebp),%edx
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	52                   	push   %edx
  8019a0:	50                   	push   %eax
  8019a1:	6a 1c                	push   $0x1c
  8019a3:	e8 fc fc ff ff       	call   8016a4 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	51                   	push   %ecx
  8019be:	52                   	push   %edx
  8019bf:	50                   	push   %eax
  8019c0:	6a 1d                	push   $0x1d
  8019c2:	e8 dd fc ff ff       	call   8016a4 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	52                   	push   %edx
  8019dc:	50                   	push   %eax
  8019dd:	6a 1e                	push   $0x1e
  8019df:	e8 c0 fc ff ff       	call   8016a4 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 1f                	push   $0x1f
  8019f8:	e8 a7 fc ff ff       	call   8016a4 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	ff 75 14             	pushl  0x14(%ebp)
  801a0d:	ff 75 10             	pushl  0x10(%ebp)
  801a10:	ff 75 0c             	pushl  0xc(%ebp)
  801a13:	50                   	push   %eax
  801a14:	6a 20                	push   $0x20
  801a16:	e8 89 fc ff ff       	call   8016a4 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	50                   	push   %eax
  801a2f:	6a 21                	push   $0x21
  801a31:	e8 6e fc ff ff       	call   8016a4 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	90                   	nop
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	50                   	push   %eax
  801a4b:	6a 22                	push   $0x22
  801a4d:	e8 52 fc ff ff       	call   8016a4 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 02                	push   $0x2
  801a66:	e8 39 fc ff ff       	call   8016a4 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 03                	push   $0x3
  801a7f:	e8 20 fc ff ff       	call   8016a4 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 04                	push   $0x4
  801a98:	e8 07 fc ff ff       	call   8016a4 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_exit_env>:


void sys_exit_env(void)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 23                	push   $0x23
  801ab1:	e8 ee fb ff ff       	call   8016a4 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	90                   	nop
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ac2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ac5:	8d 50 04             	lea    0x4(%eax),%edx
  801ac8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	52                   	push   %edx
  801ad2:	50                   	push   %eax
  801ad3:	6a 24                	push   $0x24
  801ad5:	e8 ca fb ff ff       	call   8016a4 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
	return result;
  801add:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ae3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae6:	89 01                	mov    %eax,(%ecx)
  801ae8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	c9                   	leave  
  801aef:	c2 04 00             	ret    $0x4

00801af2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 10             	pushl  0x10(%ebp)
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	ff 75 08             	pushl  0x8(%ebp)
  801b02:	6a 12                	push   $0x12
  801b04:	e8 9b fb ff ff       	call   8016a4 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0c:	90                   	nop
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_rcr2>:
uint32 sys_rcr2()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 25                	push   $0x25
  801b1e:	e8 81 fb ff ff       	call   8016a4 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 04             	sub    $0x4,%esp
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b34:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	50                   	push   %eax
  801b41:	6a 26                	push   $0x26
  801b43:	e8 5c fb ff ff       	call   8016a4 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4b:	90                   	nop
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <rsttst>:
void rsttst()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 28                	push   $0x28
  801b5d:	e8 42 fb ff ff       	call   8016a4 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return ;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 04             	sub    $0x4,%esp
  801b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b74:	8b 55 18             	mov    0x18(%ebp),%edx
  801b77:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7b:	52                   	push   %edx
  801b7c:	50                   	push   %eax
  801b7d:	ff 75 10             	pushl  0x10(%ebp)
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	ff 75 08             	pushl  0x8(%ebp)
  801b86:	6a 27                	push   $0x27
  801b88:	e8 17 fb ff ff       	call   8016a4 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b90:	90                   	nop
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <chktst>:
void chktst(uint32 n)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	ff 75 08             	pushl  0x8(%ebp)
  801ba1:	6a 29                	push   $0x29
  801ba3:	e8 fc fa ff ff       	call   8016a4 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bab:	90                   	nop
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <inctst>:

void inctst()
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 2a                	push   $0x2a
  801bbd:	e8 e2 fa ff ff       	call   8016a4 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc5:	90                   	nop
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <gettst>:
uint32 gettst()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 2b                	push   $0x2b
  801bd7:	e8 c8 fa ff ff       	call   8016a4 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 2c                	push   $0x2c
  801bf3:	e8 ac fa ff ff       	call   8016a4 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
  801bfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bfe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c02:	75 07                	jne    801c0b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c04:	b8 01 00 00 00       	mov    $0x1,%eax
  801c09:	eb 05                	jmp    801c10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 2c                	push   $0x2c
  801c24:	e8 7b fa ff ff       	call   8016a4 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
  801c2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c2f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c33:	75 07                	jne    801c3c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c35:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3a:	eb 05                	jmp    801c41 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 2c                	push   $0x2c
  801c55:	e8 4a fa ff ff       	call   8016a4 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
  801c5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c60:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c64:	75 07                	jne    801c6d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c66:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6b:	eb 05                	jmp    801c72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 2c                	push   $0x2c
  801c86:	e8 19 fa ff ff       	call   8016a4 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
  801c8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c91:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c95:	75 07                	jne    801c9e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c97:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9c:	eb 05                	jmp    801ca3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	ff 75 08             	pushl  0x8(%ebp)
  801cb3:	6a 2d                	push   $0x2d
  801cb5:	e8 ea f9 ff ff       	call   8016a4 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbd:	90                   	nop
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cc4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	53                   	push   %ebx
  801cd3:	51                   	push   %ecx
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 2e                	push   $0x2e
  801cd8:	e8 c7 f9 ff ff       	call   8016a4 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	6a 2f                	push   $0x2f
  801cf8:	e8 a7 f9 ff ff       	call   8016a4 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801d08:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0b:	89 d0                	mov    %edx,%eax
  801d0d:	c1 e0 02             	shl    $0x2,%eax
  801d10:	01 d0                	add    %edx,%eax
  801d12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d22:	01 d0                	add    %edx,%eax
  801d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	c1 e0 04             	shl    $0x4,%eax
  801d30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801d33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801d3a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801d3d:	83 ec 0c             	sub    $0xc,%esp
  801d40:	50                   	push   %eax
  801d41:	e8 76 fd ff ff       	call   801abc <sys_get_virtual_time>
  801d46:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801d49:	eb 41                	jmp    801d8c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801d4b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d4e:	83 ec 0c             	sub    $0xc,%esp
  801d51:	50                   	push   %eax
  801d52:	e8 65 fd ff ff       	call   801abc <sys_get_virtual_time>
  801d57:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801d5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d60:	29 c2                	sub    %eax,%edx
  801d62:	89 d0                	mov    %edx,%eax
  801d64:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801d67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6d:	89 d1                	mov    %edx,%ecx
  801d6f:	29 c1                	sub    %eax,%ecx
  801d71:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d77:	39 c2                	cmp    %eax,%edx
  801d79:	0f 97 c0             	seta   %al
  801d7c:	0f b6 c0             	movzbl %al,%eax
  801d7f:	29 c1                	sub    %eax,%ecx
  801d81:	89 c8                	mov    %ecx,%eax
  801d83:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801d86:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d92:	72 b7                	jb     801d4b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801d9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801da4:	eb 03                	jmp    801da9 <busy_wait+0x12>
  801da6:	ff 45 fc             	incl   -0x4(%ebp)
  801da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dac:	3b 45 08             	cmp    0x8(%ebp),%eax
  801daf:	72 f5                	jb     801da6 <busy_wait+0xf>
	return i;
  801db1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    
  801db6:	66 90                	xchg   %ax,%ax

00801db8 <__udivdi3>:
  801db8:	55                   	push   %ebp
  801db9:	57                   	push   %edi
  801dba:	56                   	push   %esi
  801dbb:	53                   	push   %ebx
  801dbc:	83 ec 1c             	sub    $0x1c,%esp
  801dbf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801dc3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801dc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dcb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dcf:	89 ca                	mov    %ecx,%edx
  801dd1:	89 f8                	mov    %edi,%eax
  801dd3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801dd7:	85 f6                	test   %esi,%esi
  801dd9:	75 2d                	jne    801e08 <__udivdi3+0x50>
  801ddb:	39 cf                	cmp    %ecx,%edi
  801ddd:	77 65                	ja     801e44 <__udivdi3+0x8c>
  801ddf:	89 fd                	mov    %edi,%ebp
  801de1:	85 ff                	test   %edi,%edi
  801de3:	75 0b                	jne    801df0 <__udivdi3+0x38>
  801de5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dea:	31 d2                	xor    %edx,%edx
  801dec:	f7 f7                	div    %edi
  801dee:	89 c5                	mov    %eax,%ebp
  801df0:	31 d2                	xor    %edx,%edx
  801df2:	89 c8                	mov    %ecx,%eax
  801df4:	f7 f5                	div    %ebp
  801df6:	89 c1                	mov    %eax,%ecx
  801df8:	89 d8                	mov    %ebx,%eax
  801dfa:	f7 f5                	div    %ebp
  801dfc:	89 cf                	mov    %ecx,%edi
  801dfe:	89 fa                	mov    %edi,%edx
  801e00:	83 c4 1c             	add    $0x1c,%esp
  801e03:	5b                   	pop    %ebx
  801e04:	5e                   	pop    %esi
  801e05:	5f                   	pop    %edi
  801e06:	5d                   	pop    %ebp
  801e07:	c3                   	ret    
  801e08:	39 ce                	cmp    %ecx,%esi
  801e0a:	77 28                	ja     801e34 <__udivdi3+0x7c>
  801e0c:	0f bd fe             	bsr    %esi,%edi
  801e0f:	83 f7 1f             	xor    $0x1f,%edi
  801e12:	75 40                	jne    801e54 <__udivdi3+0x9c>
  801e14:	39 ce                	cmp    %ecx,%esi
  801e16:	72 0a                	jb     801e22 <__udivdi3+0x6a>
  801e18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e1c:	0f 87 9e 00 00 00    	ja     801ec0 <__udivdi3+0x108>
  801e22:	b8 01 00 00 00       	mov    $0x1,%eax
  801e27:	89 fa                	mov    %edi,%edx
  801e29:	83 c4 1c             	add    $0x1c,%esp
  801e2c:	5b                   	pop    %ebx
  801e2d:	5e                   	pop    %esi
  801e2e:	5f                   	pop    %edi
  801e2f:	5d                   	pop    %ebp
  801e30:	c3                   	ret    
  801e31:	8d 76 00             	lea    0x0(%esi),%esi
  801e34:	31 ff                	xor    %edi,%edi
  801e36:	31 c0                	xor    %eax,%eax
  801e38:	89 fa                	mov    %edi,%edx
  801e3a:	83 c4 1c             	add    $0x1c,%esp
  801e3d:	5b                   	pop    %ebx
  801e3e:	5e                   	pop    %esi
  801e3f:	5f                   	pop    %edi
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    
  801e42:	66 90                	xchg   %ax,%ax
  801e44:	89 d8                	mov    %ebx,%eax
  801e46:	f7 f7                	div    %edi
  801e48:	31 ff                	xor    %edi,%edi
  801e4a:	89 fa                	mov    %edi,%edx
  801e4c:	83 c4 1c             	add    $0x1c,%esp
  801e4f:	5b                   	pop    %ebx
  801e50:	5e                   	pop    %esi
  801e51:	5f                   	pop    %edi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    
  801e54:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e59:	89 eb                	mov    %ebp,%ebx
  801e5b:	29 fb                	sub    %edi,%ebx
  801e5d:	89 f9                	mov    %edi,%ecx
  801e5f:	d3 e6                	shl    %cl,%esi
  801e61:	89 c5                	mov    %eax,%ebp
  801e63:	88 d9                	mov    %bl,%cl
  801e65:	d3 ed                	shr    %cl,%ebp
  801e67:	89 e9                	mov    %ebp,%ecx
  801e69:	09 f1                	or     %esi,%ecx
  801e6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e6f:	89 f9                	mov    %edi,%ecx
  801e71:	d3 e0                	shl    %cl,%eax
  801e73:	89 c5                	mov    %eax,%ebp
  801e75:	89 d6                	mov    %edx,%esi
  801e77:	88 d9                	mov    %bl,%cl
  801e79:	d3 ee                	shr    %cl,%esi
  801e7b:	89 f9                	mov    %edi,%ecx
  801e7d:	d3 e2                	shl    %cl,%edx
  801e7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e83:	88 d9                	mov    %bl,%cl
  801e85:	d3 e8                	shr    %cl,%eax
  801e87:	09 c2                	or     %eax,%edx
  801e89:	89 d0                	mov    %edx,%eax
  801e8b:	89 f2                	mov    %esi,%edx
  801e8d:	f7 74 24 0c          	divl   0xc(%esp)
  801e91:	89 d6                	mov    %edx,%esi
  801e93:	89 c3                	mov    %eax,%ebx
  801e95:	f7 e5                	mul    %ebp
  801e97:	39 d6                	cmp    %edx,%esi
  801e99:	72 19                	jb     801eb4 <__udivdi3+0xfc>
  801e9b:	74 0b                	je     801ea8 <__udivdi3+0xf0>
  801e9d:	89 d8                	mov    %ebx,%eax
  801e9f:	31 ff                	xor    %edi,%edi
  801ea1:	e9 58 ff ff ff       	jmp    801dfe <__udivdi3+0x46>
  801ea6:	66 90                	xchg   %ax,%ax
  801ea8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801eac:	89 f9                	mov    %edi,%ecx
  801eae:	d3 e2                	shl    %cl,%edx
  801eb0:	39 c2                	cmp    %eax,%edx
  801eb2:	73 e9                	jae    801e9d <__udivdi3+0xe5>
  801eb4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eb7:	31 ff                	xor    %edi,%edi
  801eb9:	e9 40 ff ff ff       	jmp    801dfe <__udivdi3+0x46>
  801ebe:	66 90                	xchg   %ax,%ax
  801ec0:	31 c0                	xor    %eax,%eax
  801ec2:	e9 37 ff ff ff       	jmp    801dfe <__udivdi3+0x46>
  801ec7:	90                   	nop

00801ec8 <__umoddi3>:
  801ec8:	55                   	push   %ebp
  801ec9:	57                   	push   %edi
  801eca:	56                   	push   %esi
  801ecb:	53                   	push   %ebx
  801ecc:	83 ec 1c             	sub    $0x1c,%esp
  801ecf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ed3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ed7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801edb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801edf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ee3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ee7:	89 f3                	mov    %esi,%ebx
  801ee9:	89 fa                	mov    %edi,%edx
  801eeb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eef:	89 34 24             	mov    %esi,(%esp)
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	75 1a                	jne    801f10 <__umoddi3+0x48>
  801ef6:	39 f7                	cmp    %esi,%edi
  801ef8:	0f 86 a2 00 00 00    	jbe    801fa0 <__umoddi3+0xd8>
  801efe:	89 c8                	mov    %ecx,%eax
  801f00:	89 f2                	mov    %esi,%edx
  801f02:	f7 f7                	div    %edi
  801f04:	89 d0                	mov    %edx,%eax
  801f06:	31 d2                	xor    %edx,%edx
  801f08:	83 c4 1c             	add    $0x1c,%esp
  801f0b:	5b                   	pop    %ebx
  801f0c:	5e                   	pop    %esi
  801f0d:	5f                   	pop    %edi
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    
  801f10:	39 f0                	cmp    %esi,%eax
  801f12:	0f 87 ac 00 00 00    	ja     801fc4 <__umoddi3+0xfc>
  801f18:	0f bd e8             	bsr    %eax,%ebp
  801f1b:	83 f5 1f             	xor    $0x1f,%ebp
  801f1e:	0f 84 ac 00 00 00    	je     801fd0 <__umoddi3+0x108>
  801f24:	bf 20 00 00 00       	mov    $0x20,%edi
  801f29:	29 ef                	sub    %ebp,%edi
  801f2b:	89 fe                	mov    %edi,%esi
  801f2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f31:	89 e9                	mov    %ebp,%ecx
  801f33:	d3 e0                	shl    %cl,%eax
  801f35:	89 d7                	mov    %edx,%edi
  801f37:	89 f1                	mov    %esi,%ecx
  801f39:	d3 ef                	shr    %cl,%edi
  801f3b:	09 c7                	or     %eax,%edi
  801f3d:	89 e9                	mov    %ebp,%ecx
  801f3f:	d3 e2                	shl    %cl,%edx
  801f41:	89 14 24             	mov    %edx,(%esp)
  801f44:	89 d8                	mov    %ebx,%eax
  801f46:	d3 e0                	shl    %cl,%eax
  801f48:	89 c2                	mov    %eax,%edx
  801f4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f4e:	d3 e0                	shl    %cl,%eax
  801f50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f54:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f58:	89 f1                	mov    %esi,%ecx
  801f5a:	d3 e8                	shr    %cl,%eax
  801f5c:	09 d0                	or     %edx,%eax
  801f5e:	d3 eb                	shr    %cl,%ebx
  801f60:	89 da                	mov    %ebx,%edx
  801f62:	f7 f7                	div    %edi
  801f64:	89 d3                	mov    %edx,%ebx
  801f66:	f7 24 24             	mull   (%esp)
  801f69:	89 c6                	mov    %eax,%esi
  801f6b:	89 d1                	mov    %edx,%ecx
  801f6d:	39 d3                	cmp    %edx,%ebx
  801f6f:	0f 82 87 00 00 00    	jb     801ffc <__umoddi3+0x134>
  801f75:	0f 84 91 00 00 00    	je     80200c <__umoddi3+0x144>
  801f7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f7f:	29 f2                	sub    %esi,%edx
  801f81:	19 cb                	sbb    %ecx,%ebx
  801f83:	89 d8                	mov    %ebx,%eax
  801f85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f89:	d3 e0                	shl    %cl,%eax
  801f8b:	89 e9                	mov    %ebp,%ecx
  801f8d:	d3 ea                	shr    %cl,%edx
  801f8f:	09 d0                	or     %edx,%eax
  801f91:	89 e9                	mov    %ebp,%ecx
  801f93:	d3 eb                	shr    %cl,%ebx
  801f95:	89 da                	mov    %ebx,%edx
  801f97:	83 c4 1c             	add    $0x1c,%esp
  801f9a:	5b                   	pop    %ebx
  801f9b:	5e                   	pop    %esi
  801f9c:	5f                   	pop    %edi
  801f9d:	5d                   	pop    %ebp
  801f9e:	c3                   	ret    
  801f9f:	90                   	nop
  801fa0:	89 fd                	mov    %edi,%ebp
  801fa2:	85 ff                	test   %edi,%edi
  801fa4:	75 0b                	jne    801fb1 <__umoddi3+0xe9>
  801fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fab:	31 d2                	xor    %edx,%edx
  801fad:	f7 f7                	div    %edi
  801faf:	89 c5                	mov    %eax,%ebp
  801fb1:	89 f0                	mov    %esi,%eax
  801fb3:	31 d2                	xor    %edx,%edx
  801fb5:	f7 f5                	div    %ebp
  801fb7:	89 c8                	mov    %ecx,%eax
  801fb9:	f7 f5                	div    %ebp
  801fbb:	89 d0                	mov    %edx,%eax
  801fbd:	e9 44 ff ff ff       	jmp    801f06 <__umoddi3+0x3e>
  801fc2:	66 90                	xchg   %ax,%ax
  801fc4:	89 c8                	mov    %ecx,%eax
  801fc6:	89 f2                	mov    %esi,%edx
  801fc8:	83 c4 1c             	add    $0x1c,%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5f                   	pop    %edi
  801fce:	5d                   	pop    %ebp
  801fcf:	c3                   	ret    
  801fd0:	3b 04 24             	cmp    (%esp),%eax
  801fd3:	72 06                	jb     801fdb <__umoddi3+0x113>
  801fd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fd9:	77 0f                	ja     801fea <__umoddi3+0x122>
  801fdb:	89 f2                	mov    %esi,%edx
  801fdd:	29 f9                	sub    %edi,%ecx
  801fdf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fe3:	89 14 24             	mov    %edx,(%esp)
  801fe6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fea:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fee:	8b 14 24             	mov    (%esp),%edx
  801ff1:	83 c4 1c             	add    $0x1c,%esp
  801ff4:	5b                   	pop    %ebx
  801ff5:	5e                   	pop    %esi
  801ff6:	5f                   	pop    %edi
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    
  801ff9:	8d 76 00             	lea    0x0(%esi),%esi
  801ffc:	2b 04 24             	sub    (%esp),%eax
  801fff:	19 fa                	sbb    %edi,%edx
  802001:	89 d1                	mov    %edx,%ecx
  802003:	89 c6                	mov    %eax,%esi
  802005:	e9 71 ff ff ff       	jmp    801f7b <__umoddi3+0xb3>
  80200a:	66 90                	xchg   %ax,%ax
  80200c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802010:	72 ea                	jb     801ffc <__umoddi3+0x134>
  802012:	89 d9                	mov    %ebx,%ecx
  802014:	e9 62 ff ff ff       	jmp    801f7b <__umoddi3+0xb3>
