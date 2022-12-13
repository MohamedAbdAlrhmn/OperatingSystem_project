
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
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
  80008d:	68 a0 39 80 00       	push   $0x8039a0
  800092:	6a 12                	push   $0x12
  800094:	68 bc 39 80 00       	push   $0x8039bc
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 dc 39 80 00       	push   $0x8039dc
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 10 3a 80 00       	push   $0x803a10
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 6c 3a 80 00       	push   $0x803a6c
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 b4 1c 00 00       	call   801d87 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 a0 3a 80 00       	push   $0x803aa0
  8000de:	e8 80 07 00 00       	call   800863 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000eb:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f8:	8b 40 74             	mov    0x74(%eax),%eax
  8000fb:	6a 32                	push   $0x32
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	68 e1 3a 80 00       	push   $0x803ae1
  800104:	e8 29 1c 00 00       	call   801d32 <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010f:	a1 20 50 80 00       	mov    0x805020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	a1 20 50 80 00       	mov    0x805020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 e1 3a 80 00       	push   $0x803ae1
  80012d:	e8 00 1c 00 00       	call   801d32 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 83 19 00 00       	call   801ac0 <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 ef 3a 80 00       	push   $0x803aef
  80014f:	e8 2c 17 00 00       	call   801880 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 f4 3a 80 00       	push   $0x803af4
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 14 3b 80 00       	push   $0x803b14
  80017b:	6a 26                	push   $0x26
  80017d:	68 bc 39 80 00       	push   $0x8039bc
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 31 19 00 00       	call   801ac0 <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 80 3b 80 00       	push   $0x803b80
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 bc 39 80 00       	push   $0x8039bc
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 cd 1c 00 00       	call   801e7e <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 94 1b 00 00       	call   801d50 <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 86 1b 00 00       	call   801d50 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 fe 3b 80 00       	push   $0x803bfe
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 98 34 00 00       	call   803682 <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 06 1d 00 00       	call   801ef8 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 15 3c 80 00       	push   $0x803c15
  8001ff:	6a 33                	push   $0x33
  800201:	68 bc 39 80 00       	push   $0x8039bc
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 4a 17 00 00       	call   801960 <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 24 3c 80 00       	push   $0x803c24
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 92 18 00 00       	call   801ac0 <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 44 3c 80 00       	push   $0x803c44
  800248:	6a 38                	push   $0x38
  80024a:	68 bc 39 80 00       	push   $0x8039bc
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 74 3c 80 00       	push   $0x803c74
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 98 3c 80 00       	push   $0x803c98
  80026c:	e8 f2 05 00 00       	call   800863 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80027f:	89 c2                	mov    %eax,%edx
  800281:	a1 20 50 80 00       	mov    0x805020,%eax
  800286:	8b 40 74             	mov    0x74(%eax),%eax
  800289:	6a 32                	push   $0x32
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 c8 3c 80 00       	push   $0x803cc8
  800292:	e8 9b 1a 00 00       	call   801d32 <sys_create_env>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  80029d:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002af:	8b 40 74             	mov    0x74(%eax),%eax
  8002b2:	6a 32                	push   $0x32
  8002b4:	52                   	push   %edx
  8002b5:	50                   	push   %eax
  8002b6:	68 d8 3c 80 00       	push   $0x803cd8
  8002bb:	e8 72 1a 00 00       	call   801d32 <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 e8 3c 80 00       	push   $0x803ce8
  8002d5:	e8 a6 15 00 00       	call   801880 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 ec 3c 80 00       	push   $0x803cec
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 ef 3a 80 00       	push   $0x803aef
  8002ff:	e8 7c 15 00 00       	call   801880 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 f4 3a 80 00       	push   $0x803af4
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 5f 1b 00 00       	call   801e7e <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 26 1a 00 00       	call   801d50 <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 18 1a 00 00       	call   801d50 <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 3a 33 00 00       	call   803682 <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 70 17 00 00       	call   801ac0 <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 02 16 00 00       	call   801960 <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 0c 3d 80 00       	push   $0x803d0c
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 e4 15 00 00       	call   801960 <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 22 3d 80 00       	push   $0x803d22
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 2c 17 00 00       	call   801ac0 <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 38 3d 80 00       	push   $0x803d38
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 bc 39 80 00       	push   $0x8039bc
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 1f 1b 00 00       	call   801ede <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 dd 3d 80 00       	push   $0x803ddd
  8003cb:	e8 b0 14 00 00       	call   801880 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 d5 19 00 00       	call   801db9 <sys_getparentenvid>
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	0f 8e 81 00 00 00    	jle    80046d <_main+0x435>
			while(*finish_children != 1);
  8003ec:	90                   	nop
  8003ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 f8 01             	cmp    $0x1,%eax
  8003f5:	75 f6                	jne    8003ed <_main+0x3b5>
			cprintf("done\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 ed 3d 80 00       	push   $0x803ded
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 5a 19 00 00       	call   801d6c <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 4c 19 00 00       	call   801d6c <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 3e 19 00 00       	call   801d6c <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 30 19 00 00       	call   801d6c <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 6e 19 00 00       	call   801db9 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 f3 3d 80 00       	push   $0x803df3
  800453:	50                   	push   %eax
  800454:	e8 c3 14 00 00       	call   80191c <sget>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  80045f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 01             	lea    0x1(%eax),%edx
  800467:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  80046c:	90                   	nop
  80046d:	90                   	nop
}
  80046e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 22 19 00 00       	call   801da0 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 c4 16 00 00       	call   801bad <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 1c 3e 80 00       	push   $0x803e1c
  8004f1:	e8 6d 03 00 00       	call   800863 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 44 3e 80 00       	push   $0x803e44
  800519:	e8 45 03 00 00       	call   800863 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 50 80 00       	mov    0x805020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 50 80 00       	mov    0x805020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 50 80 00       	mov    0x805020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 6c 3e 80 00       	push   $0x803e6c
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 c4 3e 80 00       	push   $0x803ec4
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 1c 3e 80 00       	push   $0x803e1c
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 44 16 00 00       	call   801bc7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 d1 17 00 00       	call   801d6c <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 26 18 00 00       	call   801dd2 <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005be:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	74 16                	je     8005dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005c7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	50                   	push   %eax
  8005d0:	68 d8 3e 80 00       	push   $0x803ed8
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 dd 3e 80 00       	push   $0x803edd
  8005ee:	e8 70 02 00 00       	call   800863 <cprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	e8 f3 01 00 00       	call   8007f8 <vcprintf>
  800605:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	6a 00                	push   $0x0
  80060d:	68 f9 3e 80 00       	push   $0x803ef9
  800612:	e8 e1 01 00 00       	call   8007f8 <vcprintf>
  800617:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80061a:	e8 82 ff ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  80061f:	eb fe                	jmp    80061f <_panic+0x70>

00800621 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800627:	a1 20 50 80 00       	mov    0x805020,%eax
  80062c:	8b 50 74             	mov    0x74(%eax),%edx
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	39 c2                	cmp    %eax,%edx
  800634:	74 14                	je     80064a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800636:	83 ec 04             	sub    $0x4,%esp
  800639:	68 fc 3e 80 00       	push   $0x803efc
  80063e:	6a 26                	push   $0x26
  800640:	68 48 3f 80 00       	push   $0x803f48
  800645:	e8 65 ff ff ff       	call   8005af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80064a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800658:	e9 c2 00 00 00       	jmp    80071f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	01 d0                	add    %edx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	85 c0                	test   %eax,%eax
  800670:	75 08                	jne    80067a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800672:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800675:	e9 a2 00 00 00       	jmp    80071c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80067a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800681:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800688:	eb 69                	jmp    8006f3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80068a:	a1 20 50 80 00       	mov    0x805020,%eax
  80068f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800698:	89 d0                	mov    %edx,%eax
  80069a:	01 c0                	add    %eax,%eax
  80069c:	01 d0                	add    %edx,%eax
  80069e:	c1 e0 03             	shl    $0x3,%eax
  8006a1:	01 c8                	add    %ecx,%eax
  8006a3:	8a 40 04             	mov    0x4(%eax),%al
  8006a6:	84 c0                	test   %al,%al
  8006a8:	75 46                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8006af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b8:	89 d0                	mov    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d0                	add    %edx,%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	01 c8                	add    %ecx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	75 09                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8006e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006ee:	eb 12                	jmp    800702 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f0:	ff 45 e8             	incl   -0x18(%ebp)
  8006f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f8:	8b 50 74             	mov    0x74(%eax),%edx
  8006fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006fe:	39 c2                	cmp    %eax,%edx
  800700:	77 88                	ja     80068a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800706:	75 14                	jne    80071c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	68 54 3f 80 00       	push   $0x803f54
  800710:	6a 3a                	push   $0x3a
  800712:	68 48 3f 80 00       	push   $0x803f48
  800717:	e8 93 fe ff ff       	call   8005af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80071c:	ff 45 f0             	incl   -0x10(%ebp)
  80071f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800722:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800725:	0f 8c 32 ff ff ff    	jl     80065d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80072b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800732:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800739:	eb 26                	jmp    800761 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80073b:	a1 20 50 80 00       	mov    0x805020,%eax
  800740:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800746:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800749:	89 d0                	mov    %edx,%eax
  80074b:	01 c0                	add    %eax,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	c1 e0 03             	shl    $0x3,%eax
  800752:	01 c8                	add    %ecx,%eax
  800754:	8a 40 04             	mov    0x4(%eax),%al
  800757:	3c 01                	cmp    $0x1,%al
  800759:	75 03                	jne    80075e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80075b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80075e:	ff 45 e0             	incl   -0x20(%ebp)
  800761:	a1 20 50 80 00       	mov    0x805020,%eax
  800766:	8b 50 74             	mov    0x74(%eax),%edx
  800769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076c:	39 c2                	cmp    %eax,%edx
  80076e:	77 cb                	ja     80073b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800773:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800776:	74 14                	je     80078c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	68 a8 3f 80 00       	push   $0x803fa8
  800780:	6a 44                	push   $0x44
  800782:	68 48 3f 80 00       	push   $0x803f48
  800787:	e8 23 fe ff ff       	call   8005af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80078c:	90                   	nop
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 48 01             	lea    0x1(%eax),%ecx
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a0:	89 0a                	mov    %ecx,(%edx)
  8007a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007a5:	88 d1                	mov    %dl,%cl
  8007a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007aa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007b8:	75 2c                	jne    8007e6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ba:	a0 24 50 80 00       	mov    0x805024,%al
  8007bf:	0f b6 c0             	movzbl %al,%eax
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	8b 12                	mov    (%edx),%edx
  8007c7:	89 d1                	mov    %edx,%ecx
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	83 c2 08             	add    $0x8,%edx
  8007cf:	83 ec 04             	sub    $0x4,%esp
  8007d2:	50                   	push   %eax
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	e8 25 12 00 00       	call   8019ff <sys_cputs>
  8007da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 40 04             	mov    0x4(%eax),%eax
  8007ec:	8d 50 01             	lea    0x1(%eax),%edx
  8007ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007f5:	90                   	nop
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800801:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800808:	00 00 00 
	b.cnt = 0;
  80080b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800812:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800821:	50                   	push   %eax
  800822:	68 8f 07 80 00       	push   $0x80078f
  800827:	e8 11 02 00 00       	call   800a3d <vprintfmt>
  80082c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80082f:	a0 24 50 80 00       	mov    0x805024,%al
  800834:	0f b6 c0             	movzbl %al,%eax
  800837:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80083d:	83 ec 04             	sub    $0x4,%esp
  800840:	50                   	push   %eax
  800841:	52                   	push   %edx
  800842:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800848:	83 c0 08             	add    $0x8,%eax
  80084b:	50                   	push   %eax
  80084c:	e8 ae 11 00 00       	call   8019ff <sys_cputs>
  800851:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800854:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80085b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800861:	c9                   	leave  
  800862:	c3                   	ret    

00800863 <cprintf>:

int cprintf(const char *fmt, ...) {
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800869:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800870:	8d 45 0c             	lea    0xc(%ebp),%eax
  800873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 f4             	pushl  -0xc(%ebp)
  80087f:	50                   	push   %eax
  800880:	e8 73 ff ff ff       	call   8007f8 <vcprintf>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800896:	e8 12 13 00 00       	call   801bad <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80089b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	e8 48 ff ff ff       	call   8007f8 <vcprintf>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008b6:	e8 0c 13 00 00       	call   801bc7 <sys_enable_interrupt>
	return cnt;
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 14             	sub    $0x14,%esp
  8008c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008de:	77 55                	ja     800935 <printnum+0x75>
  8008e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008e3:	72 05                	jb     8008ea <printnum+0x2a>
  8008e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008e8:	77 4b                	ja     800935 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	52                   	push   %edx
  8008f9:	50                   	push   %eax
  8008fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800900:	e8 33 2e 00 00       	call   803738 <__udivdi3>
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	83 ec 04             	sub    $0x4,%esp
  80090b:	ff 75 20             	pushl  0x20(%ebp)
  80090e:	53                   	push   %ebx
  80090f:	ff 75 18             	pushl  0x18(%ebp)
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 a1 ff ff ff       	call   8008c0 <printnum>
  80091f:	83 c4 20             	add    $0x20,%esp
  800922:	eb 1a                	jmp    80093e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	ff 75 20             	pushl  0x20(%ebp)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800935:	ff 4d 1c             	decl   0x1c(%ebp)
  800938:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80093c:	7f e6                	jg     800924 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80093e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800941:	bb 00 00 00 00       	mov    $0x0,%ebx
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094c:	53                   	push   %ebx
  80094d:	51                   	push   %ecx
  80094e:	52                   	push   %edx
  80094f:	50                   	push   %eax
  800950:	e8 f3 2e 00 00       	call   803848 <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 14 42 80 00       	add    $0x804214,%eax
  80095d:	8a 00                	mov    (%eax),%al
  80095f:	0f be c0             	movsbl %al,%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	50                   	push   %eax
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
}
  800971:	90                   	nop
  800972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097e:	7e 1c                	jle    80099c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	8d 50 08             	lea    0x8(%eax),%edx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 10                	mov    %edx,(%eax)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	83 e8 08             	sub    $0x8,%eax
  800995:	8b 50 04             	mov    0x4(%eax),%edx
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	eb 40                	jmp    8009dc <getuint+0x65>
	else if (lflag)
  80099c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a0:	74 1e                	je     8009c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 10                	mov    %edx,(%eax)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 e8 04             	sub    $0x4,%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	eb 1c                	jmp    8009dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e5:	7e 1c                	jle    800a03 <getint+0x25>
		return va_arg(*ap, long long);
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	8d 50 08             	lea    0x8(%eax),%edx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 10                	mov    %edx,(%eax)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	83 e8 08             	sub    $0x8,%eax
  8009fc:	8b 50 04             	mov    0x4(%eax),%edx
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	eb 38                	jmp    800a3b <getint+0x5d>
	else if (lflag)
  800a03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a07:	74 1a                	je     800a23 <getint+0x45>
		return va_arg(*ap, long);
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	8d 50 04             	lea    0x4(%eax),%edx
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 10                	mov    %edx,(%eax)
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	99                   	cltd   
  800a21:	eb 18                	jmp    800a3b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	8d 50 04             	lea    0x4(%eax),%edx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	89 10                	mov    %edx,(%eax)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	99                   	cltd   
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a45:	eb 17                	jmp    800a5e <vprintfmt+0x21>
			if (ch == '\0')
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	0f 84 af 03 00 00    	je     800dfe <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	8d 50 01             	lea    0x1(%eax),%edx
  800a64:	89 55 10             	mov    %edx,0x10(%ebp)
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f b6 d8             	movzbl %al,%ebx
  800a6c:	83 fb 25             	cmp    $0x25,%ebx
  800a6f:	75 d6                	jne    800a47 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a71:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a75:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	8d 50 01             	lea    0x1(%eax),%edx
  800a97:	89 55 10             	mov    %edx,0x10(%ebp)
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	0f b6 d8             	movzbl %al,%ebx
  800a9f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aa2:	83 f8 55             	cmp    $0x55,%eax
  800aa5:	0f 87 2b 03 00 00    	ja     800dd6 <vprintfmt+0x399>
  800aab:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
  800ab2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ab8:	eb d7                	jmp    800a91 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800abe:	eb d1                	jmp    800a91 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ac7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 02             	shl    $0x2,%eax
  800acf:	01 d0                	add    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d8                	add    %ebx,%eax
  800ad5:	83 e8 30             	sub    $0x30,%eax
  800ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	8a 00                	mov    (%eax),%al
  800ae0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae3:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae6:	7e 3e                	jle    800b26 <vprintfmt+0xe9>
  800ae8:	83 fb 39             	cmp    $0x39,%ebx
  800aeb:	7f 39                	jg     800b26 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af0:	eb d5                	jmp    800ac7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b06:	eb 1f                	jmp    800b27 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	79 83                	jns    800a91 <vprintfmt+0x54>
				width = 0;
  800b0e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b15:	e9 77 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b21:	e9 6b ff ff ff       	jmp    800a91 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b26:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2b:	0f 89 60 ff ff ff    	jns    800a91 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b37:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b3e:	e9 4e ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b43:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b46:	e9 46 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	50                   	push   %eax
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			break;
  800b6b:	e9 89 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	83 c0 04             	add    $0x4,%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	79 02                	jns    800b87 <vprintfmt+0x14a>
				err = -err;
  800b85:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b87:	83 fb 64             	cmp    $0x64,%ebx
  800b8a:	7f 0b                	jg     800b97 <vprintfmt+0x15a>
  800b8c:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 25 42 80 00       	push   $0x804225
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 5e 02 00 00       	call   800e06 <printfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bab:	e9 49 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb0:	56                   	push   %esi
  800bb1:	68 2e 42 80 00       	push   $0x80422e
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	e8 45 02 00 00       	call   800e06 <printfmt>
  800bc1:	83 c4 10             	add    $0x10,%esp
			break;
  800bc4:	e9 30 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	83 c0 04             	add    $0x4,%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 e8 04             	sub    $0x4,%eax
  800bd8:	8b 30                	mov    (%eax),%esi
  800bda:	85 f6                	test   %esi,%esi
  800bdc:	75 05                	jne    800be3 <vprintfmt+0x1a6>
				p = "(null)";
  800bde:	be 31 42 80 00       	mov    $0x804231,%esi
			if (width > 0 && padc != '-')
  800be3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be7:	7e 6d                	jle    800c56 <vprintfmt+0x219>
  800be9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bed:	74 67                	je     800c56 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	56                   	push   %esi
  800bf7:	e8 0c 03 00 00       	call   800f08 <strnlen>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c02:	eb 16                	jmp    800c1a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c04:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	50                   	push   %eax
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c17:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1e:	7f e4                	jg     800c04 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c20:	eb 34                	jmp    800c56 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c26:	74 1c                	je     800c44 <vprintfmt+0x207>
  800c28:	83 fb 1f             	cmp    $0x1f,%ebx
  800c2b:	7e 05                	jle    800c32 <vprintfmt+0x1f5>
  800c2d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c30:	7e 12                	jle    800c44 <vprintfmt+0x207>
					putch('?', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 3f                	push   $0x3f
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	eb 0f                	jmp    800c53 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c53:	ff 4d e4             	decl   -0x1c(%ebp)
  800c56:	89 f0                	mov    %esi,%eax
  800c58:	8d 70 01             	lea    0x1(%eax),%esi
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f be d8             	movsbl %al,%ebx
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	74 24                	je     800c88 <vprintfmt+0x24b>
  800c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c68:	78 b8                	js     800c22 <vprintfmt+0x1e5>
  800c6a:	ff 4d e0             	decl   -0x20(%ebp)
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	79 af                	jns    800c22 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c73:	eb 13                	jmp    800c88 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 20                	push   $0x20
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c85:	ff 4d e4             	decl   -0x1c(%ebp)
  800c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8c:	7f e7                	jg     800c75 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c8e:	e9 66 01 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 3c fd ff ff       	call   8009de <getint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	85 d2                	test   %edx,%edx
  800cb3:	79 23                	jns    800cd8 <vprintfmt+0x29b>
				putch('-', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 2d                	push   $0x2d
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccb:	f7 d8                	neg    %eax
  800ccd:	83 d2 00             	adc    $0x0,%edx
  800cd0:	f7 da                	neg    %edx
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cdf:	e9 bc 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cea:	8d 45 14             	lea    0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	e8 84 fc ff ff       	call   800977 <getuint>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cfc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d03:	e9 98 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	6a 58                	push   $0x58
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff d0                	call   *%eax
  800d15:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	6a 58                	push   $0x58
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 58                	push   $0x58
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			break;
  800d38:	e9 bc 00 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	6a 30                	push   $0x30
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d4d:	83 ec 08             	sub    $0x8,%esp
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	6a 78                	push   $0x78
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	83 c0 04             	add    $0x4,%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d78:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d7f:	eb 1f                	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 e8             	pushl  -0x18(%ebp)
  800d87:	8d 45 14             	lea    0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	e8 e7 fb ff ff       	call   800977 <getuint>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da7:	83 ec 04             	sub    $0x4,%esp
  800daa:	52                   	push   %edx
  800dab:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dae:	50                   	push   %eax
  800daf:	ff 75 f4             	pushl  -0xc(%ebp)
  800db2:	ff 75 f0             	pushl  -0x10(%ebp)
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 00 fb ff ff       	call   8008c0 <printnum>
  800dc0:	83 c4 20             	add    $0x20,%esp
			break;
  800dc3:	eb 34                	jmp    800df9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 0c             	pushl  0xc(%ebp)
  800dcb:	53                   	push   %ebx
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	ff d0                	call   *%eax
  800dd1:	83 c4 10             	add    $0x10,%esp
			break;
  800dd4:	eb 23                	jmp    800df9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	6a 25                	push   $0x25
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de6:	ff 4d 10             	decl   0x10(%ebp)
  800de9:	eb 03                	jmp    800dee <vprintfmt+0x3b1>
  800deb:	ff 4d 10             	decl   0x10(%ebp)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	48                   	dec    %eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3c 25                	cmp    $0x25,%al
  800df6:	75 f3                	jne    800deb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800df8:	90                   	nop
		}
	}
  800df9:	e9 47 fc ff ff       	jmp    800a45 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 16 fc ff ff       	call   800a3d <vprintfmt>
  800e27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e2a:	90                   	nop
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 40 08             	mov    0x8(%eax),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 10                	mov    (%eax),%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 40 04             	mov    0x4(%eax),%eax
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	73 12                	jae    800e60 <sprintputch+0x33>
		*b->buf++ = ch;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8b 00                	mov    (%eax),%eax
  800e53:	8d 48 01             	lea    0x1(%eax),%ecx
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	89 0a                	mov    %ecx,(%edx)
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	88 10                	mov    %dl,(%eax)
}
  800e60:	90                   	nop
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	74 06                	je     800e90 <vsnprintf+0x2d>
  800e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8e:	7f 07                	jg     800e97 <vsnprintf+0x34>
		return -E_INVAL;
  800e90:	b8 03 00 00 00       	mov    $0x3,%eax
  800e95:	eb 20                	jmp    800eb7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e97:	ff 75 14             	pushl  0x14(%ebp)
  800e9a:	ff 75 10             	pushl  0x10(%ebp)
  800e9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	68 2d 0e 80 00       	push   $0x800e2d
  800ea6:	e8 92 fb ff ff       	call   800a3d <vprintfmt>
  800eab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	ff 75 08             	pushl  0x8(%ebp)
  800ed5:	e8 89 ff ff ff       	call   800e63 <vsnprintf>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef2:	eb 06                	jmp    800efa <strlen+0x15>
		n++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 f1                	jne    800ef4 <strlen+0xf>
		n++;
	return n;
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 09                	jmp    800f20 <strnlen+0x18>
		n++;
  800f17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 4d 0c             	decl   0xc(%ebp)
  800f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f24:	74 09                	je     800f2f <strnlen+0x27>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 e8                	jne    800f17 <strnlen+0xf>
		n++;
	return n;
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f40:	90                   	nop
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f53:	8a 12                	mov    (%edx),%dl
  800f55:	88 10                	mov    %dl,(%eax)
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 e4                	jne    800f41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f75:	eb 1f                	jmp    800f96 <strncpy+0x34>
		*dst++ = *src;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	84 c0                	test   %al,%al
  800f8e:	74 03                	je     800f93 <strncpy+0x31>
			src++;
  800f90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f93:	ff 45 fc             	incl   -0x4(%ebp)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9c:	72 d9                	jb     800f77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	74 30                	je     800fe5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb5:	eb 16                	jmp    800fcd <strlcpy+0x2a>
			*dst++ = *src++;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc9:	8a 12                	mov    (%edx),%dl
  800fcb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd4:	74 09                	je     800fdf <strlcpy+0x3c>
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 d8                	jne    800fb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff4:	eb 06                	jmp    800ffc <strcmp+0xb>
		p++, q++;
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	74 0e                	je     801013 <strcmp+0x22>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 10                	mov    (%eax),%dl
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 e3                	je     800ff6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	0f b6 d0             	movzbl %al,%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 c0             	movzbl %al,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80102c:	eb 09                	jmp    801037 <strncmp+0xe>
		n--, p++, q++;
  80102e:	ff 4d 10             	decl   0x10(%ebp)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103b:	74 17                	je     801054 <strncmp+0x2b>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	74 0e                	je     801054 <strncmp+0x2b>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	38 c2                	cmp    %al,%dl
  801052:	74 da                	je     80102e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strncmp+0x38>
		return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	eb 14                	jmp    801075 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f b6 d0             	movzbl %al,%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f b6 c0             	movzbl %al,%eax
  801071:	29 c2                	sub    %eax,%edx
  801073:	89 d0                	mov    %edx,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801083:	eb 12                	jmp    801097 <strchr+0x20>
		if (*s == c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108d:	75 05                	jne    801094 <strchr+0x1d>
			return (char *) s;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	eb 11                	jmp    8010a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e5                	jne    801085 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 0d                	jmp    8010c2 <strfind+0x1b>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	74 0e                	je     8010cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	84 c0                	test   %al,%al
  8010c9:	75 ea                	jne    8010b5 <strfind+0xe>
  8010cb:	eb 01                	jmp    8010ce <strfind+0x27>
		if (*s == c)
			break;
  8010cd:	90                   	nop
	return (char *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010e5:	eb 0e                	jmp    8010f5 <memset+0x22>
		*p++ = c;
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010f5:	ff 4d f8             	decl   -0x8(%ebp)
  8010f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010fc:	79 e9                	jns    8010e7 <memset+0x14>
		*p++ = c;

	return v;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801115:	eb 16                	jmp    80112d <memcpy+0x2a>
		*d++ = *s++;
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8d 50 01             	lea    0x1(%eax),%edx
  80111d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801120:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801123:	8d 4a 01             	lea    0x1(%edx),%ecx
  801126:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801129:	8a 12                	mov    (%edx),%dl
  80112b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	8d 50 ff             	lea    -0x1(%eax),%edx
  801133:	89 55 10             	mov    %edx,0x10(%ebp)
  801136:	85 c0                	test   %eax,%eax
  801138:	75 dd                	jne    801117 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801157:	73 50                	jae    8011a9 <memmove+0x6a>
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 d0                	add    %edx,%eax
  801161:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801164:	76 43                	jbe    8011a9 <memmove+0x6a>
		s += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801172:	eb 10                	jmp    801184 <memmove+0x45>
			*--d = *--s;
  801174:	ff 4d f8             	decl   -0x8(%ebp)
  801177:	ff 4d fc             	decl   -0x4(%ebp)
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	8a 10                	mov    (%eax),%dl
  80117f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801182:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118a:	89 55 10             	mov    %edx,0x10(%ebp)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 e3                	jne    801174 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801191:	eb 23                	jmp    8011b6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801193:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801196:	8d 50 01             	lea    0x1(%eax),%edx
  801199:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a5:	8a 12                	mov    (%edx),%dl
  8011a7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011af:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	75 dd                	jne    801193 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011cd:	eb 2a                	jmp    8011f9 <memcmp+0x3e>
		if (*s1 != *s2)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	8a 10                	mov    (%eax),%dl
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	38 c2                	cmp    %al,%dl
  8011db:	74 16                	je     8011f3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d0             	movzbl %al,%edx
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 c0             	movzbl %al,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
  8011f1:	eb 18                	jmp    80120b <memcmp+0x50>
		s1++, s2++;
  8011f3:	ff 45 fc             	incl   -0x4(%ebp)
  8011f6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801202:	85 c0                	test   %eax,%eax
  801204:	75 c9                	jne    8011cf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	8b 45 10             	mov    0x10(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121e:	eb 15                	jmp    801235 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	39 c2                	cmp    %eax,%edx
  801230:	74 0d                	je     80123f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123b:	72 e3                	jb     801220 <memfind+0x13>
  80123d:	eb 01                	jmp    801240 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80123f:	90                   	nop
	return (void *) s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801259:	eb 03                	jmp    80125e <strtol+0x19>
		s++;
  80125b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 20                	cmp    $0x20,%al
  801265:	74 f4                	je     80125b <strtol+0x16>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 09                	cmp    $0x9,%al
  80126e:	74 eb                	je     80125b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 2b                	cmp    $0x2b,%al
  801277:	75 05                	jne    80127e <strtol+0x39>
		s++;
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	eb 13                	jmp    801291 <strtol+0x4c>
	else if (*s == '-')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2d                	cmp    $0x2d,%al
  801285:	75 0a                	jne    801291 <strtol+0x4c>
		s++, neg = 1;
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801291:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801295:	74 06                	je     80129d <strtol+0x58>
  801297:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129b:	75 20                	jne    8012bd <strtol+0x78>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 30                	cmp    $0x30,%al
  8012a4:	75 17                	jne    8012bd <strtol+0x78>
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	40                   	inc    %eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 78                	cmp    $0x78,%al
  8012ae:	75 0d                	jne    8012bd <strtol+0x78>
		s += 2, base = 16;
  8012b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bb:	eb 28                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	75 15                	jne    8012d8 <strtol+0x93>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 30                	cmp    $0x30,%al
  8012ca:	75 0c                	jne    8012d8 <strtol+0x93>
		s++, base = 8;
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d6:	eb 0d                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0)
  8012d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dc:	75 07                	jne    8012e5 <strtol+0xa0>
		base = 10;
  8012de:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 2f                	cmp    $0x2f,%al
  8012ec:	7e 19                	jle    801307 <strtol+0xc2>
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 39                	cmp    $0x39,%al
  8012f5:	7f 10                	jg     801307 <strtol+0xc2>
			dig = *s - '0';
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	0f be c0             	movsbl %al,%eax
  8012ff:	83 e8 30             	sub    $0x30,%eax
  801302:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801305:	eb 42                	jmp    801349 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	3c 60                	cmp    $0x60,%al
  80130e:	7e 19                	jle    801329 <strtol+0xe4>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	3c 7a                	cmp    $0x7a,%al
  801317:	7f 10                	jg     801329 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	0f be c0             	movsbl %al,%eax
  801321:	83 e8 57             	sub    $0x57,%eax
  801324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801327:	eb 20                	jmp    801349 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	3c 40                	cmp    $0x40,%al
  801330:	7e 39                	jle    80136b <strtol+0x126>
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	3c 5a                	cmp    $0x5a,%al
  801339:	7f 30                	jg     80136b <strtol+0x126>
			dig = *s - 'A' + 10;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f be c0             	movsbl %al,%eax
  801343:	83 e8 37             	sub    $0x37,%eax
  801346:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134f:	7d 19                	jge    80136a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801365:	e9 7b ff ff ff       	jmp    8012e5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80136f:	74 08                	je     801379 <strtol+0x134>
		*endptr = (char *) s;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	8b 55 08             	mov    0x8(%ebp),%edx
  801377:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801379:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137d:	74 07                	je     801386 <strtol+0x141>
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	f7 d8                	neg    %eax
  801384:	eb 03                	jmp    801389 <strtol+0x144>
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <ltostr>:

void
ltostr(long value, char *str)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801398:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80139f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a3:	79 13                	jns    8013b8 <ltostr+0x2d>
	{
		neg = 1;
  8013a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c0:	99                   	cltd   
  8013c1:	f7 f9                	idiv   %ecx
  8013c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c9:	8d 50 01             	lea    0x1(%eax),%edx
  8013cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d9:	83 c2 30             	add    $0x30,%edx
  8013dc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e6:	f7 e9                	imul   %ecx
  8013e8:	c1 fa 02             	sar    $0x2,%edx
  8013eb:	89 c8                	mov    %ecx,%eax
  8013ed:	c1 f8 1f             	sar    $0x1f,%eax
  8013f0:	29 c2                	sub    %eax,%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ff:	f7 e9                	imul   %ecx
  801401:	c1 fa 02             	sar    $0x2,%edx
  801404:	89 c8                	mov    %ecx,%eax
  801406:	c1 f8 1f             	sar    $0x1f,%eax
  801409:	29 c2                	sub    %eax,%edx
  80140b:	89 d0                	mov    %edx,%eax
  80140d:	c1 e0 02             	shl    $0x2,%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	01 c0                	add    %eax,%eax
  801414:	29 c1                	sub    %eax,%ecx
  801416:	89 ca                	mov    %ecx,%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	75 9c                	jne    8013b8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80141c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801423:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801426:	48                   	dec    %eax
  801427:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80142a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80142e:	74 3d                	je     80146d <ltostr+0xe2>
		start = 1 ;
  801430:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801437:	eb 34                	jmp    80146d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80145a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 c2                	add    %eax,%edx
  801462:	8a 45 eb             	mov    -0x15(%ebp),%al
  801465:	88 02                	mov    %al,(%edx)
		start++ ;
  801467:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80146a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801473:	7c c4                	jl     801439 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801475:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 54 fa ff ff       	call   800ee5 <strlen>
  801491:	83 c4 04             	add    $0x4,%esp
  801494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	e8 46 fa ff ff       	call   800ee5 <strlen>
  80149f:	83 c4 04             	add    $0x4,%esp
  8014a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b3:	eb 17                	jmp    8014cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8014b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 c2                	add    %eax,%edx
  8014bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	01 c8                	add    %ecx,%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c9:	ff 45 fc             	incl   -0x4(%ebp)
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014d2:	7c e1                	jl     8014b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014e2:	eb 1f                	jmp    801503 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ed:	89 c2                	mov    %eax,%edx
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 c2                	add    %eax,%edx
  8014f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fa:	01 c8                	add    %ecx,%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801500:	ff 45 f8             	incl   -0x8(%ebp)
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801509:	7c d9                	jl     8014e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80150b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	c6 00 00             	movb   $0x0,(%eax)
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80151c:	8b 45 14             	mov    0x14(%ebp),%eax
  80151f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801525:	8b 45 14             	mov    0x14(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	01 d0                	add    %edx,%eax
  801536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153c:	eb 0c                	jmp    80154a <strsplit+0x31>
			*string++ = 0;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8d 50 01             	lea    0x1(%eax),%edx
  801544:	89 55 08             	mov    %edx,0x8(%ebp)
  801547:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	84 c0                	test   %al,%al
  801551:	74 18                	je     80156b <strsplit+0x52>
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	0f be c0             	movsbl %al,%eax
  80155b:	50                   	push   %eax
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	e8 13 fb ff ff       	call   801077 <strchr>
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	75 d3                	jne    80153e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 5a                	je     8015ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	83 f8 0f             	cmp    $0xf,%eax
  80157c:	75 07                	jne    801585 <strsplit+0x6c>
		{
			return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
  801583:	eb 66                	jmp    8015eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	8d 48 01             	lea    0x1(%eax),%ecx
  80158d:	8b 55 14             	mov    0x14(%ebp),%edx
  801590:	89 0a                	mov    %ecx,(%edx)
  801592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	01 c2                	add    %eax,%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a3:	eb 03                	jmp    8015a8 <strsplit+0x8f>
			string++;
  8015a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	84 c0                	test   %al,%al
  8015af:	74 8b                	je     80153c <strsplit+0x23>
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	0f be c0             	movsbl %al,%eax
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	e8 b5 fa ff ff       	call   801077 <strchr>
  8015c2:	83 c4 08             	add    $0x8,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 dc                	je     8015a5 <strsplit+0x8c>
			string++;
	}
  8015c9:	e9 6e ff ff ff       	jmp    80153c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8015f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 1f                	je     80161b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8015fc:	e8 1d 00 00 00       	call   80161e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	68 90 43 80 00       	push   $0x804390
  801609:	e8 55 f2 ff ff       	call   800863 <cprintf>
  80160e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801611:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801618:	00 00 00 
	}
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801624:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80162b:	00 00 00 
  80162e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801635:	00 00 00 
  801638:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80163f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801642:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801649:	00 00 00 
  80164c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801653:	00 00 00 
  801656:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80165d:	00 00 00 
	uint32 arr_size = 0;
  801660:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801667:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80166e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801671:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801676:	2d 00 10 00 00       	sub    $0x1000,%eax
  80167b:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801680:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801687:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80168a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801691:	a1 20 51 80 00       	mov    0x805120,%eax
  801696:	c1 e0 04             	shl    $0x4,%eax
  801699:	89 c2                	mov    %eax,%edx
  80169b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169e:	01 d0                	add    %edx,%eax
  8016a0:	48                   	dec    %eax
  8016a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	f7 75 ec             	divl   -0x14(%ebp)
  8016af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b2:	29 d0                	sub    %edx,%eax
  8016b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8016b7:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8016be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016c6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	6a 06                	push   $0x6
  8016d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d3:	50                   	push   %eax
  8016d4:	e8 6a 04 00 00       	call   801b43 <sys_allocate_chunk>
  8016d9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016dc:	a1 20 51 80 00       	mov    0x805120,%eax
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	50                   	push   %eax
  8016e5:	e8 df 0a 00 00       	call   8021c9 <initialize_MemBlocksList>
  8016ea:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8016ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8016f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8016f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8016ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801702:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801709:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80170d:	75 14                	jne    801723 <initialize_dyn_block_system+0x105>
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	68 b5 43 80 00       	push   $0x8043b5
  801717:	6a 33                	push   $0x33
  801719:	68 d3 43 80 00       	push   $0x8043d3
  80171e:	e8 8c ee ff ff       	call   8005af <_panic>
  801723:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801726:	8b 00                	mov    (%eax),%eax
  801728:	85 c0                	test   %eax,%eax
  80172a:	74 10                	je     80173c <initialize_dyn_block_system+0x11e>
  80172c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172f:	8b 00                	mov    (%eax),%eax
  801731:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801734:	8b 52 04             	mov    0x4(%edx),%edx
  801737:	89 50 04             	mov    %edx,0x4(%eax)
  80173a:	eb 0b                	jmp    801747 <initialize_dyn_block_system+0x129>
  80173c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173f:	8b 40 04             	mov    0x4(%eax),%eax
  801742:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801747:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174a:	8b 40 04             	mov    0x4(%eax),%eax
  80174d:	85 c0                	test   %eax,%eax
  80174f:	74 0f                	je     801760 <initialize_dyn_block_system+0x142>
  801751:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801754:	8b 40 04             	mov    0x4(%eax),%eax
  801757:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80175a:	8b 12                	mov    (%edx),%edx
  80175c:	89 10                	mov    %edx,(%eax)
  80175e:	eb 0a                	jmp    80176a <initialize_dyn_block_system+0x14c>
  801760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	a3 48 51 80 00       	mov    %eax,0x805148
  80176a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80176d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801773:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801776:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80177d:	a1 54 51 80 00       	mov    0x805154,%eax
  801782:	48                   	dec    %eax
  801783:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801788:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80178c:	75 14                	jne    8017a2 <initialize_dyn_block_system+0x184>
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	68 e0 43 80 00       	push   $0x8043e0
  801796:	6a 34                	push   $0x34
  801798:	68 d3 43 80 00       	push   $0x8043d3
  80179d:	e8 0d ee ff ff       	call   8005af <_panic>
  8017a2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8017a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ab:	89 10                	mov    %edx,(%eax)
  8017ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b0:	8b 00                	mov    (%eax),%eax
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	74 0d                	je     8017c3 <initialize_dyn_block_system+0x1a5>
  8017b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8017bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017be:	89 50 04             	mov    %edx,0x4(%eax)
  8017c1:	eb 08                	jmp    8017cb <initialize_dyn_block_system+0x1ad>
  8017c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8017cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8017d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8017e2:	40                   	inc    %eax
  8017e3:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017f1:	e8 f7 fd ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  8017f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017fa:	75 07                	jne    801803 <malloc+0x18>
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801801:	eb 61                	jmp    801864 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801803:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80180a:	8b 55 08             	mov    0x8(%ebp),%edx
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	01 d0                	add    %edx,%eax
  801812:	48                   	dec    %eax
  801813:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801819:	ba 00 00 00 00       	mov    $0x0,%edx
  80181e:	f7 75 f0             	divl   -0x10(%ebp)
  801821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801824:	29 d0                	sub    %edx,%eax
  801826:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801829:	e8 e3 06 00 00       	call   801f11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80182e:	85 c0                	test   %eax,%eax
  801830:	74 11                	je     801843 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	ff 75 e8             	pushl  -0x18(%ebp)
  801838:	e8 4e 0d 00 00       	call   80258b <alloc_block_FF>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801847:	74 16                	je     80185f <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801849:	83 ec 0c             	sub    $0xc,%esp
  80184c:	ff 75 f4             	pushl  -0xc(%ebp)
  80184f:	e8 aa 0a 00 00       	call   8022fe <insert_sorted_allocList>
  801854:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185a:	8b 40 08             	mov    0x8(%eax),%eax
  80185d:	eb 05                	jmp    801864 <malloc+0x79>
	}

    return NULL;
  80185f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80186c:	83 ec 04             	sub    $0x4,%esp
  80186f:	68 04 44 80 00       	push   $0x804404
  801874:	6a 6f                	push   $0x6f
  801876:	68 d3 43 80 00       	push   $0x8043d3
  80187b:	e8 2f ed ff ff       	call   8005af <_panic>

00801880 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 38             	sub    $0x38,%esp
  801886:	8b 45 10             	mov    0x10(%ebp),%eax
  801889:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80188c:	e8 5c fd ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  801891:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801895:	75 07                	jne    80189e <smalloc+0x1e>
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
  80189c:	eb 7c                	jmp    80191a <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80189e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ab:	01 d0                	add    %edx,%eax
  8018ad:	48                   	dec    %eax
  8018ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b9:	f7 75 f0             	divl   -0x10(%ebp)
  8018bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018bf:	29 d0                	sub    %edx,%eax
  8018c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8018c4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8018cb:	e8 41 06 00 00       	call   801f11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	74 11                	je     8018e5 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8018d4:	83 ec 0c             	sub    $0xc,%esp
  8018d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8018da:	e8 ac 0c 00 00       	call   80258b <alloc_block_FF>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8018e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018e9:	74 2a                	je     801915 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8018eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ee:	8b 40 08             	mov    0x8(%eax),%eax
  8018f1:	89 c2                	mov    %eax,%edx
  8018f3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	e8 92 03 00 00       	call   801c96 <sys_createSharedObject>
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80190a:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80190e:	74 05                	je     801915 <smalloc+0x95>
			return (void*)virtual_address;
  801910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801913:	eb 05                	jmp    80191a <smalloc+0x9a>
	}
	return NULL;
  801915:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801922:	e8 c6 fc ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	68 28 44 80 00       	push   $0x804428
  80192f:	68 b0 00 00 00       	push   $0xb0
  801934:	68 d3 43 80 00       	push   $0x8043d3
  801939:	e8 71 ec ff ff       	call   8005af <_panic>

0080193e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801944:	e8 a4 fc ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	68 4c 44 80 00       	push   $0x80444c
  801951:	68 f4 00 00 00       	push   $0xf4
  801956:	68 d3 43 80 00       	push   $0x8043d3
  80195b:	e8 4f ec ff ff       	call   8005af <_panic>

00801960 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	68 74 44 80 00       	push   $0x804474
  80196e:	68 08 01 00 00       	push   $0x108
  801973:	68 d3 43 80 00       	push   $0x8043d3
  801978:	e8 32 ec ff ff       	call   8005af <_panic>

0080197d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	68 98 44 80 00       	push   $0x804498
  80198b:	68 13 01 00 00       	push   $0x113
  801990:	68 d3 43 80 00       	push   $0x8043d3
  801995:	e8 15 ec ff ff       	call   8005af <_panic>

0080199a <shrink>:

}
void shrink(uint32 newSize)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	68 98 44 80 00       	push   $0x804498
  8019a8:	68 18 01 00 00       	push   $0x118
  8019ad:	68 d3 43 80 00       	push   $0x8043d3
  8019b2:	e8 f8 eb ff ff       	call   8005af <_panic>

008019b7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	68 98 44 80 00       	push   $0x804498
  8019c5:	68 1d 01 00 00       	push   $0x11d
  8019ca:	68 d3 43 80 00       	push   $0x8043d3
  8019cf:	e8 db eb ff ff       	call   8005af <_panic>

008019d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	57                   	push   %edi
  8019d8:	56                   	push   %esi
  8019d9:	53                   	push   %ebx
  8019da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019ef:	cd 30                	int    $0x30
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5f                   	pop    %edi
  8019fd:	5d                   	pop    %ebp
  8019fe:	c3                   	ret    

008019ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a0b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	52                   	push   %edx
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	50                   	push   %eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	e8 b2 ff ff ff       	call   8019d4 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 01                	push   $0x1
  801a37:	e8 98 ff ff ff       	call   8019d4 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	52                   	push   %edx
  801a51:	50                   	push   %eax
  801a52:	6a 05                	push   $0x5
  801a54:	e8 7b ff ff ff       	call   8019d4 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	56                   	push   %esi
  801a62:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a63:	8b 75 18             	mov    0x18(%ebp),%esi
  801a66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	51                   	push   %ecx
  801a75:	52                   	push   %edx
  801a76:	50                   	push   %eax
  801a77:	6a 06                	push   $0x6
  801a79:	e8 56 ff ff ff       	call   8019d4 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    

00801a88 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	6a 07                	push   $0x7
  801a9b:	e8 34 ff ff ff       	call   8019d4 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	6a 08                	push   $0x8
  801ab6:	e8 19 ff ff ff       	call   8019d4 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 09                	push   $0x9
  801acf:	e8 00 ff ff ff       	call   8019d4 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 0a                	push   $0xa
  801ae8:	e8 e7 fe ff ff       	call   8019d4 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 0b                	push   $0xb
  801b01:	e8 ce fe ff ff       	call   8019d4 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	ff 75 08             	pushl  0x8(%ebp)
  801b1a:	6a 0f                	push   $0xf
  801b1c:	e8 b3 fe ff ff       	call   8019d4 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
	return;
  801b24:	90                   	nop
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	ff 75 08             	pushl  0x8(%ebp)
  801b36:	6a 10                	push   $0x10
  801b38:	e8 97 fe ff ff       	call   8019d4 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b40:	90                   	nop
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	ff 75 10             	pushl  0x10(%ebp)
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	ff 75 08             	pushl  0x8(%ebp)
  801b53:	6a 11                	push   $0x11
  801b55:	e8 7a fe ff ff       	call   8019d4 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5d:	90                   	nop
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 0c                	push   $0xc
  801b6f:	e8 60 fe ff ff       	call   8019d4 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	6a 0d                	push   $0xd
  801b89:	e8 46 fe ff ff       	call   8019d4 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 0e                	push   $0xe
  801ba2:	e8 2d fe ff ff       	call   8019d4 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	90                   	nop
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 13                	push   $0x13
  801bbc:	e8 13 fe ff ff       	call   8019d4 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	90                   	nop
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 14                	push   $0x14
  801bd6:	e8 f9 fd ff ff       	call   8019d4 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	90                   	nop
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_cputc>:


void
sys_cputc(const char c)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	50                   	push   %eax
  801bfa:	6a 15                	push   $0x15
  801bfc:	e8 d3 fd ff ff       	call   8019d4 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	90                   	nop
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 16                	push   $0x16
  801c16:	e8 b9 fd ff ff       	call   8019d4 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	90                   	nop
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	ff 75 0c             	pushl  0xc(%ebp)
  801c30:	50                   	push   %eax
  801c31:	6a 17                	push   $0x17
  801c33:	e8 9c fd ff ff       	call   8019d4 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	52                   	push   %edx
  801c4d:	50                   	push   %eax
  801c4e:	6a 1a                	push   $0x1a
  801c50:	e8 7f fd ff ff       	call   8019d4 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	52                   	push   %edx
  801c6a:	50                   	push   %eax
  801c6b:	6a 18                	push   $0x18
  801c6d:	e8 62 fd ff ff       	call   8019d4 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	90                   	nop
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	52                   	push   %edx
  801c88:	50                   	push   %eax
  801c89:	6a 19                	push   $0x19
  801c8b:	e8 44 fd ff ff       	call   8019d4 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	90                   	nop
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ca2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ca5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	51                   	push   %ecx
  801caf:	52                   	push   %edx
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	50                   	push   %eax
  801cb4:	6a 1b                	push   $0x1b
  801cb6:	e8 19 fd ff ff       	call   8019d4 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	52                   	push   %edx
  801cd0:	50                   	push   %eax
  801cd1:	6a 1c                	push   $0x1c
  801cd3:	e8 fc fc ff ff       	call   8019d4 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ce0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	51                   	push   %ecx
  801cee:	52                   	push   %edx
  801cef:	50                   	push   %eax
  801cf0:	6a 1d                	push   $0x1d
  801cf2:	e8 dd fc ff ff       	call   8019d4 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	6a 1e                	push   $0x1e
  801d0f:	e8 c0 fc ff ff       	call   8019d4 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 1f                	push   $0x1f
  801d28:	e8 a7 fc ff ff       	call   8019d4 <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	ff 75 14             	pushl  0x14(%ebp)
  801d3d:	ff 75 10             	pushl  0x10(%ebp)
  801d40:	ff 75 0c             	pushl  0xc(%ebp)
  801d43:	50                   	push   %eax
  801d44:	6a 20                	push   $0x20
  801d46:	e8 89 fc ff ff       	call   8019d4 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	50                   	push   %eax
  801d5f:	6a 21                	push   $0x21
  801d61:	e8 6e fc ff ff       	call   8019d4 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	90                   	nop
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	50                   	push   %eax
  801d7b:	6a 22                	push   $0x22
  801d7d:	e8 52 fc ff ff       	call   8019d4 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 02                	push   $0x2
  801d96:	e8 39 fc ff ff       	call   8019d4 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 03                	push   $0x3
  801daf:	e8 20 fc ff ff       	call   8019d4 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 04                	push   $0x4
  801dc8:	e8 07 fc ff ff       	call   8019d4 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_exit_env>:


void sys_exit_env(void)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 23                	push   $0x23
  801de1:	e8 ee fb ff ff       	call   8019d4 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	90                   	nop
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801df2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801df5:	8d 50 04             	lea    0x4(%eax),%edx
  801df8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	52                   	push   %edx
  801e02:	50                   	push   %eax
  801e03:	6a 24                	push   $0x24
  801e05:	e8 ca fb ff ff       	call   8019d4 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
	return result;
  801e0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e16:	89 01                	mov    %eax,(%ecx)
  801e18:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	c9                   	leave  
  801e1f:	c2 04 00             	ret    $0x4

00801e22 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	ff 75 10             	pushl  0x10(%ebp)
  801e2c:	ff 75 0c             	pushl  0xc(%ebp)
  801e2f:	ff 75 08             	pushl  0x8(%ebp)
  801e32:	6a 12                	push   $0x12
  801e34:	e8 9b fb ff ff       	call   8019d4 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3c:	90                   	nop
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_rcr2>:
uint32 sys_rcr2()
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 25                	push   $0x25
  801e4e:	e8 81 fb ff ff       	call   8019d4 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 04             	sub    $0x4,%esp
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e64:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	50                   	push   %eax
  801e71:	6a 26                	push   $0x26
  801e73:	e8 5c fb ff ff       	call   8019d4 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7b:	90                   	nop
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <rsttst>:
void rsttst()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 28                	push   $0x28
  801e8d:	e8 42 fb ff ff       	call   8019d4 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return ;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ea4:	8b 55 18             	mov    0x18(%ebp),%edx
  801ea7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eab:	52                   	push   %edx
  801eac:	50                   	push   %eax
  801ead:	ff 75 10             	pushl  0x10(%ebp)
  801eb0:	ff 75 0c             	pushl  0xc(%ebp)
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	6a 27                	push   $0x27
  801eb8:	e8 17 fb ff ff       	call   8019d4 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec0:	90                   	nop
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <chktst>:
void chktst(uint32 n)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	6a 29                	push   $0x29
  801ed3:	e8 fc fa ff ff       	call   8019d4 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
	return ;
  801edb:	90                   	nop
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <inctst>:

void inctst()
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 2a                	push   $0x2a
  801eed:	e8 e2 fa ff ff       	call   8019d4 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef5:	90                   	nop
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <gettst>:
uint32 gettst()
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 2b                	push   $0x2b
  801f07:	e8 c8 fa ff ff       	call   8019d4 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 2c                	push   $0x2c
  801f23:	e8 ac fa ff ff       	call   8019d4 <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
  801f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f2e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f32:	75 07                	jne    801f3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f34:	b8 01 00 00 00       	mov    $0x1,%eax
  801f39:	eb 05                	jmp    801f40 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 2c                	push   $0x2c
  801f54:	e8 7b fa ff ff       	call   8019d4 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
  801f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f5f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f63:	75 07                	jne    801f6c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f65:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6a:	eb 05                	jmp    801f71 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 2c                	push   $0x2c
  801f85:	e8 4a fa ff ff       	call   8019d4 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
  801f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f90:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f94:	75 07                	jne    801f9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f96:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9b:	eb 05                	jmp    801fa2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 2c                	push   $0x2c
  801fb6:	e8 19 fa ff ff       	call   8019d4 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
  801fbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fc1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fc5:	75 07                	jne    801fce <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcc:	eb 05                	jmp    801fd3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	6a 2d                	push   $0x2d
  801fe5:	e8 ea f9 ff ff       	call   8019d4 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
	return ;
  801fed:	90                   	nop
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ff4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ff7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	6a 00                	push   $0x0
  802002:	53                   	push   %ebx
  802003:	51                   	push   %ecx
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	6a 2e                	push   $0x2e
  802008:	e8 c7 f9 ff ff       	call   8019d4 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	52                   	push   %edx
  802025:	50                   	push   %eax
  802026:	6a 2f                	push   $0x2f
  802028:	e8 a7 f9 ff ff       	call   8019d4 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802038:	83 ec 0c             	sub    $0xc,%esp
  80203b:	68 a8 44 80 00       	push   $0x8044a8
  802040:	e8 1e e8 ff ff       	call   800863 <cprintf>
  802045:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80204f:	83 ec 0c             	sub    $0xc,%esp
  802052:	68 d4 44 80 00       	push   $0x8044d4
  802057:	e8 07 e8 ff ff       	call   800863 <cprintf>
  80205c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80205f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802063:	a1 38 51 80 00       	mov    0x805138,%eax
  802068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80206b:	eb 56                	jmp    8020c3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80206d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802071:	74 1c                	je     80208f <print_mem_block_lists+0x5d>
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 50 08             	mov    0x8(%eax),%edx
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	8b 48 08             	mov    0x8(%eax),%ecx
  80207f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802082:	8b 40 0c             	mov    0xc(%eax),%eax
  802085:	01 c8                	add    %ecx,%eax
  802087:	39 c2                	cmp    %eax,%edx
  802089:	73 04                	jae    80208f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80208b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	8b 50 08             	mov    0x8(%eax),%edx
  802095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802098:	8b 40 0c             	mov    0xc(%eax),%eax
  80209b:	01 c2                	add    %eax,%edx
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 40 08             	mov    0x8(%eax),%eax
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	52                   	push   %edx
  8020a7:	50                   	push   %eax
  8020a8:	68 e9 44 80 00       	push   $0x8044e9
  8020ad:	e8 b1 e7 ff ff       	call   800863 <cprintf>
  8020b2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8020c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c7:	74 07                	je     8020d0 <print_mem_block_lists+0x9e>
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	8b 00                	mov    (%eax),%eax
  8020ce:	eb 05                	jmp    8020d5 <print_mem_block_lists+0xa3>
  8020d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d5:	a3 40 51 80 00       	mov    %eax,0x805140
  8020da:	a1 40 51 80 00       	mov    0x805140,%eax
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	75 8a                	jne    80206d <print_mem_block_lists+0x3b>
  8020e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e7:	75 84                	jne    80206d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020e9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ed:	75 10                	jne    8020ff <print_mem_block_lists+0xcd>
  8020ef:	83 ec 0c             	sub    $0xc,%esp
  8020f2:	68 f8 44 80 00       	push   $0x8044f8
  8020f7:	e8 67 e7 ff ff       	call   800863 <cprintf>
  8020fc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	68 1c 45 80 00       	push   $0x80451c
  80210e:	e8 50 e7 ff ff       	call   800863 <cprintf>
  802113:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802116:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80211a:	a1 40 50 80 00       	mov    0x805040,%eax
  80211f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802122:	eb 56                	jmp    80217a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802124:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802128:	74 1c                	je     802146 <print_mem_block_lists+0x114>
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	8b 50 08             	mov    0x8(%eax),%edx
  802130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802133:	8b 48 08             	mov    0x8(%eax),%ecx
  802136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802139:	8b 40 0c             	mov    0xc(%eax),%eax
  80213c:	01 c8                	add    %ecx,%eax
  80213e:	39 c2                	cmp    %eax,%edx
  802140:	73 04                	jae    802146 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802142:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	8b 50 08             	mov    0x8(%eax),%edx
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 40 0c             	mov    0xc(%eax),%eax
  802152:	01 c2                	add    %eax,%edx
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 40 08             	mov    0x8(%eax),%eax
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	52                   	push   %edx
  80215e:	50                   	push   %eax
  80215f:	68 e9 44 80 00       	push   $0x8044e9
  802164:	e8 fa e6 ff ff       	call   800863 <cprintf>
  802169:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802172:	a1 48 50 80 00       	mov    0x805048,%eax
  802177:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217e:	74 07                	je     802187 <print_mem_block_lists+0x155>
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	eb 05                	jmp    80218c <print_mem_block_lists+0x15a>
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	a3 48 50 80 00       	mov    %eax,0x805048
  802191:	a1 48 50 80 00       	mov    0x805048,%eax
  802196:	85 c0                	test   %eax,%eax
  802198:	75 8a                	jne    802124 <print_mem_block_lists+0xf2>
  80219a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219e:	75 84                	jne    802124 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021a0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021a4:	75 10                	jne    8021b6 <print_mem_block_lists+0x184>
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	68 34 45 80 00       	push   $0x804534
  8021ae:	e8 b0 e6 ff ff       	call   800863 <cprintf>
  8021b3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021b6:	83 ec 0c             	sub    $0xc,%esp
  8021b9:	68 a8 44 80 00       	push   $0x8044a8
  8021be:	e8 a0 e6 ff ff       	call   800863 <cprintf>
  8021c3:	83 c4 10             	add    $0x10,%esp

}
  8021c6:	90                   	nop
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8021cf:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8021d6:	00 00 00 
  8021d9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8021e0:	00 00 00 
  8021e3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8021ea:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8021ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021f4:	e9 9e 00 00 00       	jmp    802297 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8021f9:	a1 50 50 80 00       	mov    0x805050,%eax
  8021fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802201:	c1 e2 04             	shl    $0x4,%edx
  802204:	01 d0                	add    %edx,%eax
  802206:	85 c0                	test   %eax,%eax
  802208:	75 14                	jne    80221e <initialize_MemBlocksList+0x55>
  80220a:	83 ec 04             	sub    $0x4,%esp
  80220d:	68 5c 45 80 00       	push   $0x80455c
  802212:	6a 46                	push   $0x46
  802214:	68 7f 45 80 00       	push   $0x80457f
  802219:	e8 91 e3 ff ff       	call   8005af <_panic>
  80221e:	a1 50 50 80 00       	mov    0x805050,%eax
  802223:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802226:	c1 e2 04             	shl    $0x4,%edx
  802229:	01 d0                	add    %edx,%eax
  80222b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802231:	89 10                	mov    %edx,(%eax)
  802233:	8b 00                	mov    (%eax),%eax
  802235:	85 c0                	test   %eax,%eax
  802237:	74 18                	je     802251 <initialize_MemBlocksList+0x88>
  802239:	a1 48 51 80 00       	mov    0x805148,%eax
  80223e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802244:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802247:	c1 e1 04             	shl    $0x4,%ecx
  80224a:	01 ca                	add    %ecx,%edx
  80224c:	89 50 04             	mov    %edx,0x4(%eax)
  80224f:	eb 12                	jmp    802263 <initialize_MemBlocksList+0x9a>
  802251:	a1 50 50 80 00       	mov    0x805050,%eax
  802256:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802259:	c1 e2 04             	shl    $0x4,%edx
  80225c:	01 d0                	add    %edx,%eax
  80225e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802263:	a1 50 50 80 00       	mov    0x805050,%eax
  802268:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226b:	c1 e2 04             	shl    $0x4,%edx
  80226e:	01 d0                	add    %edx,%eax
  802270:	a3 48 51 80 00       	mov    %eax,0x805148
  802275:	a1 50 50 80 00       	mov    0x805050,%eax
  80227a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227d:	c1 e2 04             	shl    $0x4,%edx
  802280:	01 d0                	add    %edx,%eax
  802282:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802289:	a1 54 51 80 00       	mov    0x805154,%eax
  80228e:	40                   	inc    %eax
  80228f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802294:	ff 45 f4             	incl   -0xc(%ebp)
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80229d:	0f 82 56 ff ff ff    	jb     8021f9 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8022a3:	90                   	nop
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8b 00                	mov    (%eax),%eax
  8022b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022b4:	eb 19                	jmp    8022cf <find_block+0x29>
	{
		if(va==point->sva)
  8022b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022b9:	8b 40 08             	mov    0x8(%eax),%eax
  8022bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022bf:	75 05                	jne    8022c6 <find_block+0x20>
		   return point;
  8022c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022c4:	eb 36                	jmp    8022fc <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 40 08             	mov    0x8(%eax),%eax
  8022cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022d3:	74 07                	je     8022dc <find_block+0x36>
  8022d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	eb 05                	jmp    8022e1 <find_block+0x3b>
  8022dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e4:	89 42 08             	mov    %eax,0x8(%edx)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8b 40 08             	mov    0x8(%eax),%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	75 c5                	jne    8022b6 <find_block+0x10>
  8022f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022f5:	75 bf                	jne    8022b6 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802304:	a1 40 50 80 00       	mov    0x805040,%eax
  802309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80230c:	a1 44 50 80 00       	mov    0x805044,%eax
  802311:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80231a:	74 24                	je     802340 <insert_sorted_allocList+0x42>
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	8b 50 08             	mov    0x8(%eax),%edx
  802322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802325:	8b 40 08             	mov    0x8(%eax),%eax
  802328:	39 c2                	cmp    %eax,%edx
  80232a:	76 14                	jbe    802340 <insert_sorted_allocList+0x42>
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	8b 50 08             	mov    0x8(%eax),%edx
  802332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802335:	8b 40 08             	mov    0x8(%eax),%eax
  802338:	39 c2                	cmp    %eax,%edx
  80233a:	0f 82 60 01 00 00    	jb     8024a0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802340:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802344:	75 65                	jne    8023ab <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802346:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80234a:	75 14                	jne    802360 <insert_sorted_allocList+0x62>
  80234c:	83 ec 04             	sub    $0x4,%esp
  80234f:	68 5c 45 80 00       	push   $0x80455c
  802354:	6a 6b                	push   $0x6b
  802356:	68 7f 45 80 00       	push   $0x80457f
  80235b:	e8 4f e2 ff ff       	call   8005af <_panic>
  802360:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	89 10                	mov    %edx,(%eax)
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	85 c0                	test   %eax,%eax
  802372:	74 0d                	je     802381 <insert_sorted_allocList+0x83>
  802374:	a1 40 50 80 00       	mov    0x805040,%eax
  802379:	8b 55 08             	mov    0x8(%ebp),%edx
  80237c:	89 50 04             	mov    %edx,0x4(%eax)
  80237f:	eb 08                	jmp    802389 <insert_sorted_allocList+0x8b>
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	a3 44 50 80 00       	mov    %eax,0x805044
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	a3 40 50 80 00       	mov    %eax,0x805040
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80239b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023a0:	40                   	inc    %eax
  8023a1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023a6:	e9 dc 01 00 00       	jmp    802587 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	8b 50 08             	mov    0x8(%eax),%edx
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	8b 40 08             	mov    0x8(%eax),%eax
  8023b7:	39 c2                	cmp    %eax,%edx
  8023b9:	77 6c                	ja     802427 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8023bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023bf:	74 06                	je     8023c7 <insert_sorted_allocList+0xc9>
  8023c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c5:	75 14                	jne    8023db <insert_sorted_allocList+0xdd>
  8023c7:	83 ec 04             	sub    $0x4,%esp
  8023ca:	68 98 45 80 00       	push   $0x804598
  8023cf:	6a 6f                	push   $0x6f
  8023d1:	68 7f 45 80 00       	push   $0x80457f
  8023d6:	e8 d4 e1 ff ff       	call   8005af <_panic>
  8023db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023de:	8b 50 04             	mov    0x4(%eax),%edx
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	89 50 04             	mov    %edx,0x4(%eax)
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ed:	89 10                	mov    %edx,(%eax)
  8023ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f2:	8b 40 04             	mov    0x4(%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 0d                	je     802406 <insert_sorted_allocList+0x108>
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	8b 40 04             	mov    0x4(%eax),%eax
  8023ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802402:	89 10                	mov    %edx,(%eax)
  802404:	eb 08                	jmp    80240e <insert_sorted_allocList+0x110>
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	a3 40 50 80 00       	mov    %eax,0x805040
  80240e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802411:	8b 55 08             	mov    0x8(%ebp),%edx
  802414:	89 50 04             	mov    %edx,0x4(%eax)
  802417:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80241c:	40                   	inc    %eax
  80241d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802422:	e9 60 01 00 00       	jmp    802587 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	8b 50 08             	mov    0x8(%eax),%edx
  80242d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802430:	8b 40 08             	mov    0x8(%eax),%eax
  802433:	39 c2                	cmp    %eax,%edx
  802435:	0f 82 4c 01 00 00    	jb     802587 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80243b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80243f:	75 14                	jne    802455 <insert_sorted_allocList+0x157>
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	68 d0 45 80 00       	push   $0x8045d0
  802449:	6a 73                	push   $0x73
  80244b:	68 7f 45 80 00       	push   $0x80457f
  802450:	e8 5a e1 ff ff       	call   8005af <_panic>
  802455:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80245b:	8b 45 08             	mov    0x8(%ebp),%eax
  80245e:	89 50 04             	mov    %edx,0x4(%eax)
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	8b 40 04             	mov    0x4(%eax),%eax
  802467:	85 c0                	test   %eax,%eax
  802469:	74 0c                	je     802477 <insert_sorted_allocList+0x179>
  80246b:	a1 44 50 80 00       	mov    0x805044,%eax
  802470:	8b 55 08             	mov    0x8(%ebp),%edx
  802473:	89 10                	mov    %edx,(%eax)
  802475:	eb 08                	jmp    80247f <insert_sorted_allocList+0x181>
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	a3 40 50 80 00       	mov    %eax,0x805040
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	a3 44 50 80 00       	mov    %eax,0x805044
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802490:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802495:	40                   	inc    %eax
  802496:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80249b:	e9 e7 00 00 00       	jmp    802587 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8024a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8024a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024ad:	a1 40 50 80 00       	mov    0x805040,%eax
  8024b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b5:	e9 9d 00 00 00       	jmp    802557 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	8b 50 08             	mov    0x8(%eax),%edx
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 40 08             	mov    0x8(%eax),%eax
  8024ce:	39 c2                	cmp    %eax,%edx
  8024d0:	76 7d                	jbe    80254f <insert_sorted_allocList+0x251>
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	8b 50 08             	mov    0x8(%eax),%edx
  8024d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024db:	8b 40 08             	mov    0x8(%eax),%eax
  8024de:	39 c2                	cmp    %eax,%edx
  8024e0:	73 6d                	jae    80254f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8024e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e6:	74 06                	je     8024ee <insert_sorted_allocList+0x1f0>
  8024e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ec:	75 14                	jne    802502 <insert_sorted_allocList+0x204>
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	68 f4 45 80 00       	push   $0x8045f4
  8024f6:	6a 7f                	push   $0x7f
  8024f8:	68 7f 45 80 00       	push   $0x80457f
  8024fd:	e8 ad e0 ff ff       	call   8005af <_panic>
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 10                	mov    (%eax),%edx
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	89 10                	mov    %edx,(%eax)
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	8b 00                	mov    (%eax),%eax
  802511:	85 c0                	test   %eax,%eax
  802513:	74 0b                	je     802520 <insert_sorted_allocList+0x222>
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	8b 55 08             	mov    0x8(%ebp),%edx
  80251d:	89 50 04             	mov    %edx,0x4(%eax)
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 55 08             	mov    0x8(%ebp),%edx
  802526:	89 10                	mov    %edx,(%eax)
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252e:	89 50 04             	mov    %edx,0x4(%eax)
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	8b 00                	mov    (%eax),%eax
  802536:	85 c0                	test   %eax,%eax
  802538:	75 08                	jne    802542 <insert_sorted_allocList+0x244>
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	a3 44 50 80 00       	mov    %eax,0x805044
  802542:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802547:	40                   	inc    %eax
  802548:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80254d:	eb 39                	jmp    802588 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80254f:	a1 48 50 80 00       	mov    0x805048,%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	74 07                	je     802564 <insert_sorted_allocList+0x266>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	eb 05                	jmp    802569 <insert_sorted_allocList+0x26b>
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
  802569:	a3 48 50 80 00       	mov    %eax,0x805048
  80256e:	a1 48 50 80 00       	mov    0x805048,%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	0f 85 3f ff ff ff    	jne    8024ba <insert_sorted_allocList+0x1bc>
  80257b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257f:	0f 85 35 ff ff ff    	jne    8024ba <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802585:	eb 01                	jmp    802588 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802587:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802588:	90                   	nop
  802589:	c9                   	leave  
  80258a:	c3                   	ret    

0080258b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802591:	a1 38 51 80 00       	mov    0x805138,%eax
  802596:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802599:	e9 85 01 00 00       	jmp    802723 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a7:	0f 82 6e 01 00 00    	jb     80271b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b6:	0f 85 8a 00 00 00    	jne    802646 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8025bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c0:	75 17                	jne    8025d9 <alloc_block_FF+0x4e>
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	68 28 46 80 00       	push   $0x804628
  8025ca:	68 93 00 00 00       	push   $0x93
  8025cf:	68 7f 45 80 00       	push   $0x80457f
  8025d4:	e8 d6 df ff ff       	call   8005af <_panic>
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 00                	mov    (%eax),%eax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	74 10                	je     8025f2 <alloc_block_FF+0x67>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ea:	8b 52 04             	mov    0x4(%edx),%edx
  8025ed:	89 50 04             	mov    %edx,0x4(%eax)
  8025f0:	eb 0b                	jmp    8025fd <alloc_block_FF+0x72>
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 04             	mov    0x4(%eax),%eax
  8025f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 04             	mov    0x4(%eax),%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	74 0f                	je     802616 <alloc_block_FF+0x8b>
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 40 04             	mov    0x4(%eax),%eax
  80260d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802610:	8b 12                	mov    (%edx),%edx
  802612:	89 10                	mov    %edx,(%eax)
  802614:	eb 0a                	jmp    802620 <alloc_block_FF+0x95>
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	a3 38 51 80 00       	mov    %eax,0x805138
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802633:	a1 44 51 80 00       	mov    0x805144,%eax
  802638:	48                   	dec    %eax
  802639:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	e9 10 01 00 00       	jmp    802756 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 40 0c             	mov    0xc(%eax),%eax
  80264c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264f:	0f 86 c6 00 00 00    	jbe    80271b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802655:	a1 48 51 80 00       	mov    0x805148,%eax
  80265a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 50 08             	mov    0x8(%eax),%edx
  802663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802666:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266c:	8b 55 08             	mov    0x8(%ebp),%edx
  80266f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802672:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802676:	75 17                	jne    80268f <alloc_block_FF+0x104>
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	68 28 46 80 00       	push   $0x804628
  802680:	68 9b 00 00 00       	push   $0x9b
  802685:	68 7f 45 80 00       	push   $0x80457f
  80268a:	e8 20 df ff ff       	call   8005af <_panic>
  80268f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	85 c0                	test   %eax,%eax
  802696:	74 10                	je     8026a8 <alloc_block_FF+0x11d>
  802698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a0:	8b 52 04             	mov    0x4(%edx),%edx
  8026a3:	89 50 04             	mov    %edx,0x4(%eax)
  8026a6:	eb 0b                	jmp    8026b3 <alloc_block_FF+0x128>
  8026a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b6:	8b 40 04             	mov    0x4(%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 0f                	je     8026cc <alloc_block_FF+0x141>
  8026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c6:	8b 12                	mov    (%edx),%edx
  8026c8:	89 10                	mov    %edx,(%eax)
  8026ca:	eb 0a                	jmp    8026d6 <alloc_block_FF+0x14b>
  8026cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8026d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8026ee:	48                   	dec    %eax
  8026ef:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 50 08             	mov    0x8(%eax),%edx
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	01 c2                	add    %eax,%edx
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 0c             	mov    0xc(%eax),%eax
  80270b:	2b 45 08             	sub    0x8(%ebp),%eax
  80270e:	89 c2                	mov    %eax,%edx
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	eb 3b                	jmp    802756 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80271b:	a1 40 51 80 00       	mov    0x805140,%eax
  802720:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802727:	74 07                	je     802730 <alloc_block_FF+0x1a5>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	eb 05                	jmp    802735 <alloc_block_FF+0x1aa>
  802730:	b8 00 00 00 00       	mov    $0x0,%eax
  802735:	a3 40 51 80 00       	mov    %eax,0x805140
  80273a:	a1 40 51 80 00       	mov    0x805140,%eax
  80273f:	85 c0                	test   %eax,%eax
  802741:	0f 85 57 fe ff ff    	jne    80259e <alloc_block_FF+0x13>
  802747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274b:	0f 85 4d fe ff ff    	jne    80259e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802751:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802756:	c9                   	leave  
  802757:	c3                   	ret    

00802758 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
  80275b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80275e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802765:	a1 38 51 80 00       	mov    0x805138,%eax
  80276a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276d:	e9 df 00 00 00       	jmp    802851 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 0c             	mov    0xc(%eax),%eax
  802778:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277b:	0f 82 c8 00 00 00    	jb     802849 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 40 0c             	mov    0xc(%eax),%eax
  802787:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278a:	0f 85 8a 00 00 00    	jne    80281a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802794:	75 17                	jne    8027ad <alloc_block_BF+0x55>
  802796:	83 ec 04             	sub    $0x4,%esp
  802799:	68 28 46 80 00       	push   $0x804628
  80279e:	68 b7 00 00 00       	push   $0xb7
  8027a3:	68 7f 45 80 00       	push   $0x80457f
  8027a8:	e8 02 de ff ff       	call   8005af <_panic>
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	74 10                	je     8027c6 <alloc_block_BF+0x6e>
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027be:	8b 52 04             	mov    0x4(%edx),%edx
  8027c1:	89 50 04             	mov    %edx,0x4(%eax)
  8027c4:	eb 0b                	jmp    8027d1 <alloc_block_BF+0x79>
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 40 04             	mov    0x4(%eax),%eax
  8027cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 0f                	je     8027ea <alloc_block_BF+0x92>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 04             	mov    0x4(%eax),%eax
  8027e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e4:	8b 12                	mov    (%edx),%edx
  8027e6:	89 10                	mov    %edx,(%eax)
  8027e8:	eb 0a                	jmp    8027f4 <alloc_block_BF+0x9c>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	a3 38 51 80 00       	mov    %eax,0x805138
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802807:	a1 44 51 80 00       	mov    0x805144,%eax
  80280c:	48                   	dec    %eax
  80280d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	e9 4d 01 00 00       	jmp    802967 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 0c             	mov    0xc(%eax),%eax
  802820:	3b 45 08             	cmp    0x8(%ebp),%eax
  802823:	76 24                	jbe    802849 <alloc_block_BF+0xf1>
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 0c             	mov    0xc(%eax),%eax
  80282b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80282e:	73 19                	jae    802849 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802830:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 40 0c             	mov    0xc(%eax),%eax
  80283d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 08             	mov    0x8(%eax),%eax
  802846:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802849:	a1 40 51 80 00       	mov    0x805140,%eax
  80284e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	74 07                	je     80285e <alloc_block_BF+0x106>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	eb 05                	jmp    802863 <alloc_block_BF+0x10b>
  80285e:	b8 00 00 00 00       	mov    $0x0,%eax
  802863:	a3 40 51 80 00       	mov    %eax,0x805140
  802868:	a1 40 51 80 00       	mov    0x805140,%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	0f 85 fd fe ff ff    	jne    802772 <alloc_block_BF+0x1a>
  802875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802879:	0f 85 f3 fe ff ff    	jne    802772 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80287f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802883:	0f 84 d9 00 00 00    	je     802962 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802889:	a1 48 51 80 00       	mov    0x805148,%eax
  80288e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802894:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802897:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80289a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289d:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8028a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028a7:	75 17                	jne    8028c0 <alloc_block_BF+0x168>
  8028a9:	83 ec 04             	sub    $0x4,%esp
  8028ac:	68 28 46 80 00       	push   $0x804628
  8028b1:	68 c7 00 00 00       	push   $0xc7
  8028b6:	68 7f 45 80 00       	push   $0x80457f
  8028bb:	e8 ef dc ff ff       	call   8005af <_panic>
  8028c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 10                	je     8028d9 <alloc_block_BF+0x181>
  8028c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028d1:	8b 52 04             	mov    0x4(%edx),%edx
  8028d4:	89 50 04             	mov    %edx,0x4(%eax)
  8028d7:	eb 0b                	jmp    8028e4 <alloc_block_BF+0x18c>
  8028d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028dc:	8b 40 04             	mov    0x4(%eax),%eax
  8028df:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	74 0f                	je     8028fd <alloc_block_BF+0x1a5>
  8028ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f1:	8b 40 04             	mov    0x4(%eax),%eax
  8028f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028f7:	8b 12                	mov    (%edx),%edx
  8028f9:	89 10                	mov    %edx,(%eax)
  8028fb:	eb 0a                	jmp    802907 <alloc_block_BF+0x1af>
  8028fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	a3 48 51 80 00       	mov    %eax,0x805148
  802907:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80290a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802913:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291a:	a1 54 51 80 00       	mov    0x805154,%eax
  80291f:	48                   	dec    %eax
  802920:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802925:	83 ec 08             	sub    $0x8,%esp
  802928:	ff 75 ec             	pushl  -0x14(%ebp)
  80292b:	68 38 51 80 00       	push   $0x805138
  802930:	e8 71 f9 ff ff       	call   8022a6 <find_block>
  802935:	83 c4 10             	add    $0x10,%esp
  802938:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80293b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293e:	8b 50 08             	mov    0x8(%eax),%edx
  802941:	8b 45 08             	mov    0x8(%ebp),%eax
  802944:	01 c2                	add    %eax,%edx
  802946:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802949:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80294c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80294f:	8b 40 0c             	mov    0xc(%eax),%eax
  802952:	2b 45 08             	sub    0x8(%ebp),%eax
  802955:	89 c2                	mov    %eax,%edx
  802957:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80295d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802960:	eb 05                	jmp    802967 <alloc_block_BF+0x20f>
	}
	return NULL;
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802967:	c9                   	leave  
  802968:	c3                   	ret    

00802969 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802969:	55                   	push   %ebp
  80296a:	89 e5                	mov    %esp,%ebp
  80296c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80296f:	a1 28 50 80 00       	mov    0x805028,%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	0f 85 de 01 00 00    	jne    802b5a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80297c:	a1 38 51 80 00       	mov    0x805138,%eax
  802981:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802984:	e9 9e 01 00 00       	jmp    802b27 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 40 0c             	mov    0xc(%eax),%eax
  80298f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802992:	0f 82 87 01 00 00    	jb     802b1f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 0c             	mov    0xc(%eax),%eax
  80299e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a1:	0f 85 95 00 00 00    	jne    802a3c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8029a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ab:	75 17                	jne    8029c4 <alloc_block_NF+0x5b>
  8029ad:	83 ec 04             	sub    $0x4,%esp
  8029b0:	68 28 46 80 00       	push   $0x804628
  8029b5:	68 e0 00 00 00       	push   $0xe0
  8029ba:	68 7f 45 80 00       	push   $0x80457f
  8029bf:	e8 eb db ff ff       	call   8005af <_panic>
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	85 c0                	test   %eax,%eax
  8029cb:	74 10                	je     8029dd <alloc_block_NF+0x74>
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d5:	8b 52 04             	mov    0x4(%edx),%edx
  8029d8:	89 50 04             	mov    %edx,0x4(%eax)
  8029db:	eb 0b                	jmp    8029e8 <alloc_block_NF+0x7f>
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 40 04             	mov    0x4(%eax),%eax
  8029e3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	74 0f                	je     802a01 <alloc_block_NF+0x98>
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 40 04             	mov    0x4(%eax),%eax
  8029f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fb:	8b 12                	mov    (%edx),%edx
  8029fd:	89 10                	mov    %edx,(%eax)
  8029ff:	eb 0a                	jmp    802a0b <alloc_block_NF+0xa2>
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	a3 38 51 80 00       	mov    %eax,0x805138
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1e:	a1 44 51 80 00       	mov    0x805144,%eax
  802a23:	48                   	dec    %eax
  802a24:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 08             	mov    0x8(%eax),%eax
  802a2f:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	e9 f8 04 00 00       	jmp    802f34 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a42:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a45:	0f 86 d4 00 00 00    	jbe    802b1f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a4b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 50 08             	mov    0x8(%eax),%edx
  802a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a62:	8b 55 08             	mov    0x8(%ebp),%edx
  802a65:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a6c:	75 17                	jne    802a85 <alloc_block_NF+0x11c>
  802a6e:	83 ec 04             	sub    $0x4,%esp
  802a71:	68 28 46 80 00       	push   $0x804628
  802a76:	68 e9 00 00 00       	push   $0xe9
  802a7b:	68 7f 45 80 00       	push   $0x80457f
  802a80:	e8 2a db ff ff       	call   8005af <_panic>
  802a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	74 10                	je     802a9e <alloc_block_NF+0x135>
  802a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a96:	8b 52 04             	mov    0x4(%edx),%edx
  802a99:	89 50 04             	mov    %edx,0x4(%eax)
  802a9c:	eb 0b                	jmp    802aa9 <alloc_block_NF+0x140>
  802a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa1:	8b 40 04             	mov    0x4(%eax),%eax
  802aa4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0f                	je     802ac2 <alloc_block_NF+0x159>
  802ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abc:	8b 12                	mov    (%edx),%edx
  802abe:	89 10                	mov    %edx,(%eax)
  802ac0:	eb 0a                	jmp    802acc <alloc_block_NF+0x163>
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	a3 48 51 80 00       	mov    %eax,0x805148
  802acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adf:	a1 54 51 80 00       	mov    0x805154,%eax
  802ae4:	48                   	dec    %eax
  802ae5:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aed:	8b 40 08             	mov    0x8(%eax),%eax
  802af0:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 50 08             	mov    0x8(%eax),%edx
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	01 c2                	add    %eax,%edx
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b0f:	89 c2                	mov    %eax,%edx
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1a:	e9 15 04 00 00       	jmp    802f34 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b1f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2b:	74 07                	je     802b34 <alloc_block_NF+0x1cb>
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	eb 05                	jmp    802b39 <alloc_block_NF+0x1d0>
  802b34:	b8 00 00 00 00       	mov    $0x0,%eax
  802b39:	a3 40 51 80 00       	mov    %eax,0x805140
  802b3e:	a1 40 51 80 00       	mov    0x805140,%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	0f 85 3e fe ff ff    	jne    802989 <alloc_block_NF+0x20>
  802b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4f:	0f 85 34 fe ff ff    	jne    802989 <alloc_block_NF+0x20>
  802b55:	e9 d5 03 00 00       	jmp    802f2f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b5a:	a1 38 51 80 00       	mov    0x805138,%eax
  802b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b62:	e9 b1 01 00 00       	jmp    802d18 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 50 08             	mov    0x8(%eax),%edx
  802b6d:	a1 28 50 80 00       	mov    0x805028,%eax
  802b72:	39 c2                	cmp    %eax,%edx
  802b74:	0f 82 96 01 00 00    	jb     802d10 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b80:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b83:	0f 82 87 01 00 00    	jb     802d10 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b92:	0f 85 95 00 00 00    	jne    802c2d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9c:	75 17                	jne    802bb5 <alloc_block_NF+0x24c>
  802b9e:	83 ec 04             	sub    $0x4,%esp
  802ba1:	68 28 46 80 00       	push   $0x804628
  802ba6:	68 fc 00 00 00       	push   $0xfc
  802bab:	68 7f 45 80 00       	push   $0x80457f
  802bb0:	e8 fa d9 ff ff       	call   8005af <_panic>
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 00                	mov    (%eax),%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	74 10                	je     802bce <alloc_block_NF+0x265>
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc6:	8b 52 04             	mov    0x4(%edx),%edx
  802bc9:	89 50 04             	mov    %edx,0x4(%eax)
  802bcc:	eb 0b                	jmp    802bd9 <alloc_block_NF+0x270>
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 40 04             	mov    0x4(%eax),%eax
  802bd4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 40 04             	mov    0x4(%eax),%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	74 0f                	je     802bf2 <alloc_block_NF+0x289>
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 40 04             	mov    0x4(%eax),%eax
  802be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bec:	8b 12                	mov    (%edx),%edx
  802bee:	89 10                	mov    %edx,(%eax)
  802bf0:	eb 0a                	jmp    802bfc <alloc_block_NF+0x293>
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	a3 38 51 80 00       	mov    %eax,0x805138
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0f:	a1 44 51 80 00       	mov    0x805144,%eax
  802c14:	48                   	dec    %eax
  802c15:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 08             	mov    0x8(%eax),%eax
  802c20:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	e9 07 03 00 00       	jmp    802f34 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 40 0c             	mov    0xc(%eax),%eax
  802c33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c36:	0f 86 d4 00 00 00    	jbe    802d10 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c3c:	a1 48 51 80 00       	mov    0x805148,%eax
  802c41:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 50 08             	mov    0x8(%eax),%edx
  802c4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c53:	8b 55 08             	mov    0x8(%ebp),%edx
  802c56:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c59:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c5d:	75 17                	jne    802c76 <alloc_block_NF+0x30d>
  802c5f:	83 ec 04             	sub    $0x4,%esp
  802c62:	68 28 46 80 00       	push   $0x804628
  802c67:	68 04 01 00 00       	push   $0x104
  802c6c:	68 7f 45 80 00       	push   $0x80457f
  802c71:	e8 39 d9 ff ff       	call   8005af <_panic>
  802c76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c79:	8b 00                	mov    (%eax),%eax
  802c7b:	85 c0                	test   %eax,%eax
  802c7d:	74 10                	je     802c8f <alloc_block_NF+0x326>
  802c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c87:	8b 52 04             	mov    0x4(%edx),%edx
  802c8a:	89 50 04             	mov    %edx,0x4(%eax)
  802c8d:	eb 0b                	jmp    802c9a <alloc_block_NF+0x331>
  802c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c92:	8b 40 04             	mov    0x4(%eax),%eax
  802c95:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	74 0f                	je     802cb3 <alloc_block_NF+0x34a>
  802ca4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cad:	8b 12                	mov    (%edx),%edx
  802caf:	89 10                	mov    %edx,(%eax)
  802cb1:	eb 0a                	jmp    802cbd <alloc_block_NF+0x354>
  802cb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	a3 48 51 80 00       	mov    %eax,0x805148
  802cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd0:	a1 54 51 80 00       	mov    0x805154,%eax
  802cd5:	48                   	dec    %eax
  802cd6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cde:	8b 40 08             	mov    0x8(%eax),%eax
  802ce1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 50 08             	mov    0x8(%eax),%edx
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	01 c2                	add    %eax,%edx
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfd:	2b 45 08             	sub    0x8(%ebp),%eax
  802d00:	89 c2                	mov    %eax,%edx
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0b:	e9 24 02 00 00       	jmp    802f34 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d10:	a1 40 51 80 00       	mov    0x805140,%eax
  802d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1c:	74 07                	je     802d25 <alloc_block_NF+0x3bc>
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	eb 05                	jmp    802d2a <alloc_block_NF+0x3c1>
  802d25:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2a:	a3 40 51 80 00       	mov    %eax,0x805140
  802d2f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	0f 85 2b fe ff ff    	jne    802b67 <alloc_block_NF+0x1fe>
  802d3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d40:	0f 85 21 fe ff ff    	jne    802b67 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d46:	a1 38 51 80 00       	mov    0x805138,%eax
  802d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4e:	e9 ae 01 00 00       	jmp    802f01 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	8b 50 08             	mov    0x8(%eax),%edx
  802d59:	a1 28 50 80 00       	mov    0x805028,%eax
  802d5e:	39 c2                	cmp    %eax,%edx
  802d60:	0f 83 93 01 00 00    	jae    802ef9 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d6f:	0f 82 84 01 00 00    	jb     802ef9 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7e:	0f 85 95 00 00 00    	jne    802e19 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d88:	75 17                	jne    802da1 <alloc_block_NF+0x438>
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	68 28 46 80 00       	push   $0x804628
  802d92:	68 14 01 00 00       	push   $0x114
  802d97:	68 7f 45 80 00       	push   $0x80457f
  802d9c:	e8 0e d8 ff ff       	call   8005af <_panic>
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 10                	je     802dba <alloc_block_NF+0x451>
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db2:	8b 52 04             	mov    0x4(%edx),%edx
  802db5:	89 50 04             	mov    %edx,0x4(%eax)
  802db8:	eb 0b                	jmp    802dc5 <alloc_block_NF+0x45c>
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0f                	je     802dde <alloc_block_NF+0x475>
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd8:	8b 12                	mov    (%edx),%edx
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	eb 0a                	jmp    802de8 <alloc_block_NF+0x47f>
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	a3 38 51 80 00       	mov    %eax,0x805138
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfb:	a1 44 51 80 00       	mov    0x805144,%eax
  802e00:	48                   	dec    %eax
  802e01:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	e9 1b 01 00 00       	jmp    802f34 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e22:	0f 86 d1 00 00 00    	jbe    802ef9 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e28:	a1 48 51 80 00       	mov    0x805148,%eax
  802e2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 50 08             	mov    0x8(%eax),%edx
  802e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e39:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e42:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e49:	75 17                	jne    802e62 <alloc_block_NF+0x4f9>
  802e4b:	83 ec 04             	sub    $0x4,%esp
  802e4e:	68 28 46 80 00       	push   $0x804628
  802e53:	68 1c 01 00 00       	push   $0x11c
  802e58:	68 7f 45 80 00       	push   $0x80457f
  802e5d:	e8 4d d7 ff ff       	call   8005af <_panic>
  802e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 10                	je     802e7b <alloc_block_NF+0x512>
  802e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e73:	8b 52 04             	mov    0x4(%edx),%edx
  802e76:	89 50 04             	mov    %edx,0x4(%eax)
  802e79:	eb 0b                	jmp    802e86 <alloc_block_NF+0x51d>
  802e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7e:	8b 40 04             	mov    0x4(%eax),%eax
  802e81:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	85 c0                	test   %eax,%eax
  802e8e:	74 0f                	je     802e9f <alloc_block_NF+0x536>
  802e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e99:	8b 12                	mov    (%edx),%edx
  802e9b:	89 10                	mov    %edx,(%eax)
  802e9d:	eb 0a                	jmp    802ea9 <alloc_block_NF+0x540>
  802e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebc:	a1 54 51 80 00       	mov    0x805154,%eax
  802ec1:	48                   	dec    %eax
  802ec2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eca:	8b 40 08             	mov    0x8(%eax),%eax
  802ecd:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 50 08             	mov    0x8(%eax),%edx
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	01 c2                	add    %eax,%edx
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee9:	2b 45 08             	sub    0x8(%ebp),%eax
  802eec:	89 c2                	mov    %eax,%edx
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef7:	eb 3b                	jmp    802f34 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ef9:	a1 40 51 80 00       	mov    0x805140,%eax
  802efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f05:	74 07                	je     802f0e <alloc_block_NF+0x5a5>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	eb 05                	jmp    802f13 <alloc_block_NF+0x5aa>
  802f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f13:	a3 40 51 80 00       	mov    %eax,0x805140
  802f18:	a1 40 51 80 00       	mov    0x805140,%eax
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	0f 85 2e fe ff ff    	jne    802d53 <alloc_block_NF+0x3ea>
  802f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f29:	0f 85 24 fe ff ff    	jne    802d53 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f34:	c9                   	leave  
  802f35:	c3                   	ret    

00802f36 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f36:	55                   	push   %ebp
  802f37:	89 e5                	mov    %esp,%ebp
  802f39:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802f3c:	a1 38 51 80 00       	mov    0x805138,%eax
  802f41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802f44:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f49:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802f4c:	a1 38 51 80 00       	mov    0x805138,%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 14                	je     802f69 <insert_sorted_with_merge_freeList+0x33>
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	8b 50 08             	mov    0x8(%eax),%edx
  802f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5e:	8b 40 08             	mov    0x8(%eax),%eax
  802f61:	39 c2                	cmp    %eax,%edx
  802f63:	0f 87 9b 01 00 00    	ja     803104 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6d:	75 17                	jne    802f86 <insert_sorted_with_merge_freeList+0x50>
  802f6f:	83 ec 04             	sub    $0x4,%esp
  802f72:	68 5c 45 80 00       	push   $0x80455c
  802f77:	68 38 01 00 00       	push   $0x138
  802f7c:	68 7f 45 80 00       	push   $0x80457f
  802f81:	e8 29 d6 ff ff       	call   8005af <_panic>
  802f86:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	89 10                	mov    %edx,(%eax)
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	85 c0                	test   %eax,%eax
  802f98:	74 0d                	je     802fa7 <insert_sorted_with_merge_freeList+0x71>
  802f9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa2:	89 50 04             	mov    %edx,0x4(%eax)
  802fa5:	eb 08                	jmp    802faf <insert_sorted_with_merge_freeList+0x79>
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc1:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc6:	40                   	inc    %eax
  802fc7:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fd0:	0f 84 a8 06 00 00    	je     80367e <insert_sorted_with_merge_freeList+0x748>
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	8b 50 08             	mov    0x8(%eax),%edx
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe2:	01 c2                	add    %eax,%edx
  802fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe7:	8b 40 08             	mov    0x8(%eax),%eax
  802fea:	39 c2                	cmp    %eax,%edx
  802fec:	0f 85 8c 06 00 00    	jne    80367e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffe:	01 c2                	add    %eax,%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803006:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80300a:	75 17                	jne    803023 <insert_sorted_with_merge_freeList+0xed>
  80300c:	83 ec 04             	sub    $0x4,%esp
  80300f:	68 28 46 80 00       	push   $0x804628
  803014:	68 3c 01 00 00       	push   $0x13c
  803019:	68 7f 45 80 00       	push   $0x80457f
  80301e:	e8 8c d5 ff ff       	call   8005af <_panic>
  803023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803026:	8b 00                	mov    (%eax),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	74 10                	je     80303c <insert_sorted_with_merge_freeList+0x106>
  80302c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803034:	8b 52 04             	mov    0x4(%edx),%edx
  803037:	89 50 04             	mov    %edx,0x4(%eax)
  80303a:	eb 0b                	jmp    803047 <insert_sorted_with_merge_freeList+0x111>
  80303c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303f:	8b 40 04             	mov    0x4(%eax),%eax
  803042:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304a:	8b 40 04             	mov    0x4(%eax),%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	74 0f                	je     803060 <insert_sorted_with_merge_freeList+0x12a>
  803051:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803054:	8b 40 04             	mov    0x4(%eax),%eax
  803057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80305a:	8b 12                	mov    (%edx),%edx
  80305c:	89 10                	mov    %edx,(%eax)
  80305e:	eb 0a                	jmp    80306a <insert_sorted_with_merge_freeList+0x134>
  803060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	a3 38 51 80 00       	mov    %eax,0x805138
  80306a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803076:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307d:	a1 44 51 80 00       	mov    0x805144,%eax
  803082:	48                   	dec    %eax
  803083:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803095:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80309c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030a0:	75 17                	jne    8030b9 <insert_sorted_with_merge_freeList+0x183>
  8030a2:	83 ec 04             	sub    $0x4,%esp
  8030a5:	68 5c 45 80 00       	push   $0x80455c
  8030aa:	68 3f 01 00 00       	push   $0x13f
  8030af:	68 7f 45 80 00       	push   $0x80457f
  8030b4:	e8 f6 d4 ff ff       	call   8005af <_panic>
  8030b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c2:	89 10                	mov    %edx,(%eax)
  8030c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	74 0d                	je     8030da <insert_sorted_with_merge_freeList+0x1a4>
  8030cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8030d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d5:	89 50 04             	mov    %edx,0x4(%eax)
  8030d8:	eb 08                	jmp    8030e2 <insert_sorted_with_merge_freeList+0x1ac>
  8030da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8030f9:	40                   	inc    %eax
  8030fa:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030ff:	e9 7a 05 00 00       	jmp    80367e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	8b 50 08             	mov    0x8(%eax),%edx
  80310a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310d:	8b 40 08             	mov    0x8(%eax),%eax
  803110:	39 c2                	cmp    %eax,%edx
  803112:	0f 82 14 01 00 00    	jb     80322c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311b:	8b 50 08             	mov    0x8(%eax),%edx
  80311e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803121:	8b 40 0c             	mov    0xc(%eax),%eax
  803124:	01 c2                	add    %eax,%edx
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	8b 40 08             	mov    0x8(%eax),%eax
  80312c:	39 c2                	cmp    %eax,%edx
  80312e:	0f 85 90 00 00 00    	jne    8031c4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803137:	8b 50 0c             	mov    0xc(%eax),%edx
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	8b 40 0c             	mov    0xc(%eax),%eax
  803140:	01 c2                	add    %eax,%edx
  803142:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803145:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80315c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803160:	75 17                	jne    803179 <insert_sorted_with_merge_freeList+0x243>
  803162:	83 ec 04             	sub    $0x4,%esp
  803165:	68 5c 45 80 00       	push   $0x80455c
  80316a:	68 49 01 00 00       	push   $0x149
  80316f:	68 7f 45 80 00       	push   $0x80457f
  803174:	e8 36 d4 ff ff       	call   8005af <_panic>
  803179:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	89 10                	mov    %edx,(%eax)
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	74 0d                	je     80319a <insert_sorted_with_merge_freeList+0x264>
  80318d:	a1 48 51 80 00       	mov    0x805148,%eax
  803192:	8b 55 08             	mov    0x8(%ebp),%edx
  803195:	89 50 04             	mov    %edx,0x4(%eax)
  803198:	eb 08                	jmp    8031a2 <insert_sorted_with_merge_freeList+0x26c>
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b9:	40                   	inc    %eax
  8031ba:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031bf:	e9 bb 04 00 00       	jmp    80367f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8031c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c8:	75 17                	jne    8031e1 <insert_sorted_with_merge_freeList+0x2ab>
  8031ca:	83 ec 04             	sub    $0x4,%esp
  8031cd:	68 d0 45 80 00       	push   $0x8045d0
  8031d2:	68 4c 01 00 00       	push   $0x14c
  8031d7:	68 7f 45 80 00       	push   $0x80457f
  8031dc:	e8 ce d3 ff ff       	call   8005af <_panic>
  8031e1:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	89 50 04             	mov    %edx,0x4(%eax)
  8031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f0:	8b 40 04             	mov    0x4(%eax),%eax
  8031f3:	85 c0                	test   %eax,%eax
  8031f5:	74 0c                	je     803203 <insert_sorted_with_merge_freeList+0x2cd>
  8031f7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	eb 08                	jmp    80320b <insert_sorted_with_merge_freeList+0x2d5>
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	a3 38 51 80 00       	mov    %eax,0x805138
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321c:	a1 44 51 80 00       	mov    0x805144,%eax
  803221:	40                   	inc    %eax
  803222:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803227:	e9 53 04 00 00       	jmp    80367f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80322c:	a1 38 51 80 00       	mov    0x805138,%eax
  803231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803234:	e9 15 04 00 00       	jmp    80364e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	8b 50 08             	mov    0x8(%eax),%edx
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 40 08             	mov    0x8(%eax),%eax
  80324d:	39 c2                	cmp    %eax,%edx
  80324f:	0f 86 f1 03 00 00    	jbe    803646 <insert_sorted_with_merge_freeList+0x710>
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	8b 50 08             	mov    0x8(%eax),%edx
  80325b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325e:	8b 40 08             	mov    0x8(%eax),%eax
  803261:	39 c2                	cmp    %eax,%edx
  803263:	0f 83 dd 03 00 00    	jae    803646 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326c:	8b 50 08             	mov    0x8(%eax),%edx
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	8b 40 0c             	mov    0xc(%eax),%eax
  803275:	01 c2                	add    %eax,%edx
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	8b 40 08             	mov    0x8(%eax),%eax
  80327d:	39 c2                	cmp    %eax,%edx
  80327f:	0f 85 b9 01 00 00    	jne    80343e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	8b 50 08             	mov    0x8(%eax),%edx
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	8b 40 0c             	mov    0xc(%eax),%eax
  803291:	01 c2                	add    %eax,%edx
  803293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803296:	8b 40 08             	mov    0x8(%eax),%eax
  803299:	39 c2                	cmp    %eax,%edx
  80329b:	0f 85 0d 01 00 00    	jne    8033ae <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ad:	01 c2                	add    %eax,%edx
  8032af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b2:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032b9:	75 17                	jne    8032d2 <insert_sorted_with_merge_freeList+0x39c>
  8032bb:	83 ec 04             	sub    $0x4,%esp
  8032be:	68 28 46 80 00       	push   $0x804628
  8032c3:	68 5c 01 00 00       	push   $0x15c
  8032c8:	68 7f 45 80 00       	push   $0x80457f
  8032cd:	e8 dd d2 ff ff       	call   8005af <_panic>
  8032d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d5:	8b 00                	mov    (%eax),%eax
  8032d7:	85 c0                	test   %eax,%eax
  8032d9:	74 10                	je     8032eb <insert_sorted_with_merge_freeList+0x3b5>
  8032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032de:	8b 00                	mov    (%eax),%eax
  8032e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e3:	8b 52 04             	mov    0x4(%edx),%edx
  8032e6:	89 50 04             	mov    %edx,0x4(%eax)
  8032e9:	eb 0b                	jmp    8032f6 <insert_sorted_with_merge_freeList+0x3c0>
  8032eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ee:	8b 40 04             	mov    0x4(%eax),%eax
  8032f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	8b 40 04             	mov    0x4(%eax),%eax
  8032fc:	85 c0                	test   %eax,%eax
  8032fe:	74 0f                	je     80330f <insert_sorted_with_merge_freeList+0x3d9>
  803300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803303:	8b 40 04             	mov    0x4(%eax),%eax
  803306:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803309:	8b 12                	mov    (%edx),%edx
  80330b:	89 10                	mov    %edx,(%eax)
  80330d:	eb 0a                	jmp    803319 <insert_sorted_with_merge_freeList+0x3e3>
  80330f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803312:	8b 00                	mov    (%eax),%eax
  803314:	a3 38 51 80 00       	mov    %eax,0x805138
  803319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803325:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332c:	a1 44 51 80 00       	mov    0x805144,%eax
  803331:	48                   	dec    %eax
  803332:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803341:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803344:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80334b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80334f:	75 17                	jne    803368 <insert_sorted_with_merge_freeList+0x432>
  803351:	83 ec 04             	sub    $0x4,%esp
  803354:	68 5c 45 80 00       	push   $0x80455c
  803359:	68 5f 01 00 00       	push   $0x15f
  80335e:	68 7f 45 80 00       	push   $0x80457f
  803363:	e8 47 d2 ff ff       	call   8005af <_panic>
  803368:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80336e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803371:	89 10                	mov    %edx,(%eax)
  803373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	74 0d                	je     803389 <insert_sorted_with_merge_freeList+0x453>
  80337c:	a1 48 51 80 00       	mov    0x805148,%eax
  803381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803384:	89 50 04             	mov    %edx,0x4(%eax)
  803387:	eb 08                	jmp    803391 <insert_sorted_with_merge_freeList+0x45b>
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803394:	a3 48 51 80 00       	mov    %eax,0x805148
  803399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a8:	40                   	inc    %eax
  8033a9:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ba:	01 c2                	add    %eax,%edx
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033da:	75 17                	jne    8033f3 <insert_sorted_with_merge_freeList+0x4bd>
  8033dc:	83 ec 04             	sub    $0x4,%esp
  8033df:	68 5c 45 80 00       	push   $0x80455c
  8033e4:	68 64 01 00 00       	push   $0x164
  8033e9:	68 7f 45 80 00       	push   $0x80457f
  8033ee:	e8 bc d1 ff ff       	call   8005af <_panic>
  8033f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	89 10                	mov    %edx,(%eax)
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	8b 00                	mov    (%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 0d                	je     803414 <insert_sorted_with_merge_freeList+0x4de>
  803407:	a1 48 51 80 00       	mov    0x805148,%eax
  80340c:	8b 55 08             	mov    0x8(%ebp),%edx
  80340f:	89 50 04             	mov    %edx,0x4(%eax)
  803412:	eb 08                	jmp    80341c <insert_sorted_with_merge_freeList+0x4e6>
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341c:	8b 45 08             	mov    0x8(%ebp),%eax
  80341f:	a3 48 51 80 00       	mov    %eax,0x805148
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342e:	a1 54 51 80 00       	mov    0x805154,%eax
  803433:	40                   	inc    %eax
  803434:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803439:	e9 41 02 00 00       	jmp    80367f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	8b 50 08             	mov    0x8(%eax),%edx
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	8b 40 0c             	mov    0xc(%eax),%eax
  80344a:	01 c2                	add    %eax,%edx
  80344c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344f:	8b 40 08             	mov    0x8(%eax),%eax
  803452:	39 c2                	cmp    %eax,%edx
  803454:	0f 85 7c 01 00 00    	jne    8035d6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80345a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80345e:	74 06                	je     803466 <insert_sorted_with_merge_freeList+0x530>
  803460:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803464:	75 17                	jne    80347d <insert_sorted_with_merge_freeList+0x547>
  803466:	83 ec 04             	sub    $0x4,%esp
  803469:	68 98 45 80 00       	push   $0x804598
  80346e:	68 69 01 00 00       	push   $0x169
  803473:	68 7f 45 80 00       	push   $0x80457f
  803478:	e8 32 d1 ff ff       	call   8005af <_panic>
  80347d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803480:	8b 50 04             	mov    0x4(%eax),%edx
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	89 50 04             	mov    %edx,0x4(%eax)
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348f:	89 10                	mov    %edx,(%eax)
  803491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803494:	8b 40 04             	mov    0x4(%eax),%eax
  803497:	85 c0                	test   %eax,%eax
  803499:	74 0d                	je     8034a8 <insert_sorted_with_merge_freeList+0x572>
  80349b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349e:	8b 40 04             	mov    0x4(%eax),%eax
  8034a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a4:	89 10                	mov    %edx,(%eax)
  8034a6:	eb 08                	jmp    8034b0 <insert_sorted_with_merge_freeList+0x57a>
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b6:	89 50 04             	mov    %edx,0x4(%eax)
  8034b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034be:	40                   	inc    %eax
  8034bf:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8034ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d0:	01 c2                	add    %eax,%edx
  8034d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8034d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034dc:	75 17                	jne    8034f5 <insert_sorted_with_merge_freeList+0x5bf>
  8034de:	83 ec 04             	sub    $0x4,%esp
  8034e1:	68 28 46 80 00       	push   $0x804628
  8034e6:	68 6b 01 00 00       	push   $0x16b
  8034eb:	68 7f 45 80 00       	push   $0x80457f
  8034f0:	e8 ba d0 ff ff       	call   8005af <_panic>
  8034f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f8:	8b 00                	mov    (%eax),%eax
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	74 10                	je     80350e <insert_sorted_with_merge_freeList+0x5d8>
  8034fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803501:	8b 00                	mov    (%eax),%eax
  803503:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803506:	8b 52 04             	mov    0x4(%edx),%edx
  803509:	89 50 04             	mov    %edx,0x4(%eax)
  80350c:	eb 0b                	jmp    803519 <insert_sorted_with_merge_freeList+0x5e3>
  80350e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803511:	8b 40 04             	mov    0x4(%eax),%eax
  803514:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803519:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351c:	8b 40 04             	mov    0x4(%eax),%eax
  80351f:	85 c0                	test   %eax,%eax
  803521:	74 0f                	je     803532 <insert_sorted_with_merge_freeList+0x5fc>
  803523:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803526:	8b 40 04             	mov    0x4(%eax),%eax
  803529:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80352c:	8b 12                	mov    (%edx),%edx
  80352e:	89 10                	mov    %edx,(%eax)
  803530:	eb 0a                	jmp    80353c <insert_sorted_with_merge_freeList+0x606>
  803532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803535:	8b 00                	mov    (%eax),%eax
  803537:	a3 38 51 80 00       	mov    %eax,0x805138
  80353c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803548:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354f:	a1 44 51 80 00       	mov    0x805144,%eax
  803554:	48                   	dec    %eax
  803555:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80355a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803564:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803567:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80356e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803572:	75 17                	jne    80358b <insert_sorted_with_merge_freeList+0x655>
  803574:	83 ec 04             	sub    $0x4,%esp
  803577:	68 5c 45 80 00       	push   $0x80455c
  80357c:	68 6e 01 00 00       	push   $0x16e
  803581:	68 7f 45 80 00       	push   $0x80457f
  803586:	e8 24 d0 ff ff       	call   8005af <_panic>
  80358b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803591:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803594:	89 10                	mov    %edx,(%eax)
  803596:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803599:	8b 00                	mov    (%eax),%eax
  80359b:	85 c0                	test   %eax,%eax
  80359d:	74 0d                	je     8035ac <insert_sorted_with_merge_freeList+0x676>
  80359f:	a1 48 51 80 00       	mov    0x805148,%eax
  8035a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035a7:	89 50 04             	mov    %edx,0x4(%eax)
  8035aa:	eb 08                	jmp    8035b4 <insert_sorted_with_merge_freeList+0x67e>
  8035ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8035bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8035cb:	40                   	inc    %eax
  8035cc:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035d1:	e9 a9 00 00 00       	jmp    80367f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8035d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035da:	74 06                	je     8035e2 <insert_sorted_with_merge_freeList+0x6ac>
  8035dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e0:	75 17                	jne    8035f9 <insert_sorted_with_merge_freeList+0x6c3>
  8035e2:	83 ec 04             	sub    $0x4,%esp
  8035e5:	68 f4 45 80 00       	push   $0x8045f4
  8035ea:	68 73 01 00 00       	push   $0x173
  8035ef:	68 7f 45 80 00       	push   $0x80457f
  8035f4:	e8 b6 cf ff ff       	call   8005af <_panic>
  8035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fc:	8b 10                	mov    (%eax),%edx
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	89 10                	mov    %edx,(%eax)
  803603:	8b 45 08             	mov    0x8(%ebp),%eax
  803606:	8b 00                	mov    (%eax),%eax
  803608:	85 c0                	test   %eax,%eax
  80360a:	74 0b                	je     803617 <insert_sorted_with_merge_freeList+0x6e1>
  80360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360f:	8b 00                	mov    (%eax),%eax
  803611:	8b 55 08             	mov    0x8(%ebp),%edx
  803614:	89 50 04             	mov    %edx,0x4(%eax)
  803617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361a:	8b 55 08             	mov    0x8(%ebp),%edx
  80361d:	89 10                	mov    %edx,(%eax)
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803625:	89 50 04             	mov    %edx,0x4(%eax)
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	85 c0                	test   %eax,%eax
  80362f:	75 08                	jne    803639 <insert_sorted_with_merge_freeList+0x703>
  803631:	8b 45 08             	mov    0x8(%ebp),%eax
  803634:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803639:	a1 44 51 80 00       	mov    0x805144,%eax
  80363e:	40                   	inc    %eax
  80363f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803644:	eb 39                	jmp    80367f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803646:	a1 40 51 80 00       	mov    0x805140,%eax
  80364b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80364e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803652:	74 07                	je     80365b <insert_sorted_with_merge_freeList+0x725>
  803654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	eb 05                	jmp    803660 <insert_sorted_with_merge_freeList+0x72a>
  80365b:	b8 00 00 00 00       	mov    $0x0,%eax
  803660:	a3 40 51 80 00       	mov    %eax,0x805140
  803665:	a1 40 51 80 00       	mov    0x805140,%eax
  80366a:	85 c0                	test   %eax,%eax
  80366c:	0f 85 c7 fb ff ff    	jne    803239 <insert_sorted_with_merge_freeList+0x303>
  803672:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803676:	0f 85 bd fb ff ff    	jne    803239 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80367c:	eb 01                	jmp    80367f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80367e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80367f:	90                   	nop
  803680:	c9                   	leave  
  803681:	c3                   	ret    

00803682 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803682:	55                   	push   %ebp
  803683:	89 e5                	mov    %esp,%ebp
  803685:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803688:	8b 55 08             	mov    0x8(%ebp),%edx
  80368b:	89 d0                	mov    %edx,%eax
  80368d:	c1 e0 02             	shl    $0x2,%eax
  803690:	01 d0                	add    %edx,%eax
  803692:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803699:	01 d0                	add    %edx,%eax
  80369b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036a2:	01 d0                	add    %edx,%eax
  8036a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036ab:	01 d0                	add    %edx,%eax
  8036ad:	c1 e0 04             	shl    $0x4,%eax
  8036b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8036b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8036ba:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8036bd:	83 ec 0c             	sub    $0xc,%esp
  8036c0:	50                   	push   %eax
  8036c1:	e8 26 e7 ff ff       	call   801dec <sys_get_virtual_time>
  8036c6:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8036c9:	eb 41                	jmp    80370c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8036cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8036ce:	83 ec 0c             	sub    $0xc,%esp
  8036d1:	50                   	push   %eax
  8036d2:	e8 15 e7 ff ff       	call   801dec <sys_get_virtual_time>
  8036d7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8036da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e0:	29 c2                	sub    %eax,%edx
  8036e2:	89 d0                	mov    %edx,%eax
  8036e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8036e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ed:	89 d1                	mov    %edx,%ecx
  8036ef:	29 c1                	sub    %eax,%ecx
  8036f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8036f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f7:	39 c2                	cmp    %eax,%edx
  8036f9:	0f 97 c0             	seta   %al
  8036fc:	0f b6 c0             	movzbl %al,%eax
  8036ff:	29 c1                	sub    %eax,%ecx
  803701:	89 c8                	mov    %ecx,%eax
  803703:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803706:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803709:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80370c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803712:	72 b7                	jb     8036cb <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803714:	90                   	nop
  803715:	c9                   	leave  
  803716:	c3                   	ret    

00803717 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803717:	55                   	push   %ebp
  803718:	89 e5                	mov    %esp,%ebp
  80371a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80371d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803724:	eb 03                	jmp    803729 <busy_wait+0x12>
  803726:	ff 45 fc             	incl   -0x4(%ebp)
  803729:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80372c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80372f:	72 f5                	jb     803726 <busy_wait+0xf>
	return i;
  803731:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803734:	c9                   	leave  
  803735:	c3                   	ret    
  803736:	66 90                	xchg   %ax,%ax

00803738 <__udivdi3>:
  803738:	55                   	push   %ebp
  803739:	57                   	push   %edi
  80373a:	56                   	push   %esi
  80373b:	53                   	push   %ebx
  80373c:	83 ec 1c             	sub    $0x1c,%esp
  80373f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803743:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803747:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80374b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80374f:	89 ca                	mov    %ecx,%edx
  803751:	89 f8                	mov    %edi,%eax
  803753:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803757:	85 f6                	test   %esi,%esi
  803759:	75 2d                	jne    803788 <__udivdi3+0x50>
  80375b:	39 cf                	cmp    %ecx,%edi
  80375d:	77 65                	ja     8037c4 <__udivdi3+0x8c>
  80375f:	89 fd                	mov    %edi,%ebp
  803761:	85 ff                	test   %edi,%edi
  803763:	75 0b                	jne    803770 <__udivdi3+0x38>
  803765:	b8 01 00 00 00       	mov    $0x1,%eax
  80376a:	31 d2                	xor    %edx,%edx
  80376c:	f7 f7                	div    %edi
  80376e:	89 c5                	mov    %eax,%ebp
  803770:	31 d2                	xor    %edx,%edx
  803772:	89 c8                	mov    %ecx,%eax
  803774:	f7 f5                	div    %ebp
  803776:	89 c1                	mov    %eax,%ecx
  803778:	89 d8                	mov    %ebx,%eax
  80377a:	f7 f5                	div    %ebp
  80377c:	89 cf                	mov    %ecx,%edi
  80377e:	89 fa                	mov    %edi,%edx
  803780:	83 c4 1c             	add    $0x1c,%esp
  803783:	5b                   	pop    %ebx
  803784:	5e                   	pop    %esi
  803785:	5f                   	pop    %edi
  803786:	5d                   	pop    %ebp
  803787:	c3                   	ret    
  803788:	39 ce                	cmp    %ecx,%esi
  80378a:	77 28                	ja     8037b4 <__udivdi3+0x7c>
  80378c:	0f bd fe             	bsr    %esi,%edi
  80378f:	83 f7 1f             	xor    $0x1f,%edi
  803792:	75 40                	jne    8037d4 <__udivdi3+0x9c>
  803794:	39 ce                	cmp    %ecx,%esi
  803796:	72 0a                	jb     8037a2 <__udivdi3+0x6a>
  803798:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80379c:	0f 87 9e 00 00 00    	ja     803840 <__udivdi3+0x108>
  8037a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8037a7:	89 fa                	mov    %edi,%edx
  8037a9:	83 c4 1c             	add    $0x1c,%esp
  8037ac:	5b                   	pop    %ebx
  8037ad:	5e                   	pop    %esi
  8037ae:	5f                   	pop    %edi
  8037af:	5d                   	pop    %ebp
  8037b0:	c3                   	ret    
  8037b1:	8d 76 00             	lea    0x0(%esi),%esi
  8037b4:	31 ff                	xor    %edi,%edi
  8037b6:	31 c0                	xor    %eax,%eax
  8037b8:	89 fa                	mov    %edi,%edx
  8037ba:	83 c4 1c             	add    $0x1c,%esp
  8037bd:	5b                   	pop    %ebx
  8037be:	5e                   	pop    %esi
  8037bf:	5f                   	pop    %edi
  8037c0:	5d                   	pop    %ebp
  8037c1:	c3                   	ret    
  8037c2:	66 90                	xchg   %ax,%ax
  8037c4:	89 d8                	mov    %ebx,%eax
  8037c6:	f7 f7                	div    %edi
  8037c8:	31 ff                	xor    %edi,%edi
  8037ca:	89 fa                	mov    %edi,%edx
  8037cc:	83 c4 1c             	add    $0x1c,%esp
  8037cf:	5b                   	pop    %ebx
  8037d0:	5e                   	pop    %esi
  8037d1:	5f                   	pop    %edi
  8037d2:	5d                   	pop    %ebp
  8037d3:	c3                   	ret    
  8037d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037d9:	89 eb                	mov    %ebp,%ebx
  8037db:	29 fb                	sub    %edi,%ebx
  8037dd:	89 f9                	mov    %edi,%ecx
  8037df:	d3 e6                	shl    %cl,%esi
  8037e1:	89 c5                	mov    %eax,%ebp
  8037e3:	88 d9                	mov    %bl,%cl
  8037e5:	d3 ed                	shr    %cl,%ebp
  8037e7:	89 e9                	mov    %ebp,%ecx
  8037e9:	09 f1                	or     %esi,%ecx
  8037eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037ef:	89 f9                	mov    %edi,%ecx
  8037f1:	d3 e0                	shl    %cl,%eax
  8037f3:	89 c5                	mov    %eax,%ebp
  8037f5:	89 d6                	mov    %edx,%esi
  8037f7:	88 d9                	mov    %bl,%cl
  8037f9:	d3 ee                	shr    %cl,%esi
  8037fb:	89 f9                	mov    %edi,%ecx
  8037fd:	d3 e2                	shl    %cl,%edx
  8037ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803803:	88 d9                	mov    %bl,%cl
  803805:	d3 e8                	shr    %cl,%eax
  803807:	09 c2                	or     %eax,%edx
  803809:	89 d0                	mov    %edx,%eax
  80380b:	89 f2                	mov    %esi,%edx
  80380d:	f7 74 24 0c          	divl   0xc(%esp)
  803811:	89 d6                	mov    %edx,%esi
  803813:	89 c3                	mov    %eax,%ebx
  803815:	f7 e5                	mul    %ebp
  803817:	39 d6                	cmp    %edx,%esi
  803819:	72 19                	jb     803834 <__udivdi3+0xfc>
  80381b:	74 0b                	je     803828 <__udivdi3+0xf0>
  80381d:	89 d8                	mov    %ebx,%eax
  80381f:	31 ff                	xor    %edi,%edi
  803821:	e9 58 ff ff ff       	jmp    80377e <__udivdi3+0x46>
  803826:	66 90                	xchg   %ax,%ax
  803828:	8b 54 24 08          	mov    0x8(%esp),%edx
  80382c:	89 f9                	mov    %edi,%ecx
  80382e:	d3 e2                	shl    %cl,%edx
  803830:	39 c2                	cmp    %eax,%edx
  803832:	73 e9                	jae    80381d <__udivdi3+0xe5>
  803834:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803837:	31 ff                	xor    %edi,%edi
  803839:	e9 40 ff ff ff       	jmp    80377e <__udivdi3+0x46>
  80383e:	66 90                	xchg   %ax,%ax
  803840:	31 c0                	xor    %eax,%eax
  803842:	e9 37 ff ff ff       	jmp    80377e <__udivdi3+0x46>
  803847:	90                   	nop

00803848 <__umoddi3>:
  803848:	55                   	push   %ebp
  803849:	57                   	push   %edi
  80384a:	56                   	push   %esi
  80384b:	53                   	push   %ebx
  80384c:	83 ec 1c             	sub    $0x1c,%esp
  80384f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803853:	8b 74 24 34          	mov    0x34(%esp),%esi
  803857:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80385b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80385f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803863:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803867:	89 f3                	mov    %esi,%ebx
  803869:	89 fa                	mov    %edi,%edx
  80386b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80386f:	89 34 24             	mov    %esi,(%esp)
  803872:	85 c0                	test   %eax,%eax
  803874:	75 1a                	jne    803890 <__umoddi3+0x48>
  803876:	39 f7                	cmp    %esi,%edi
  803878:	0f 86 a2 00 00 00    	jbe    803920 <__umoddi3+0xd8>
  80387e:	89 c8                	mov    %ecx,%eax
  803880:	89 f2                	mov    %esi,%edx
  803882:	f7 f7                	div    %edi
  803884:	89 d0                	mov    %edx,%eax
  803886:	31 d2                	xor    %edx,%edx
  803888:	83 c4 1c             	add    $0x1c,%esp
  80388b:	5b                   	pop    %ebx
  80388c:	5e                   	pop    %esi
  80388d:	5f                   	pop    %edi
  80388e:	5d                   	pop    %ebp
  80388f:	c3                   	ret    
  803890:	39 f0                	cmp    %esi,%eax
  803892:	0f 87 ac 00 00 00    	ja     803944 <__umoddi3+0xfc>
  803898:	0f bd e8             	bsr    %eax,%ebp
  80389b:	83 f5 1f             	xor    $0x1f,%ebp
  80389e:	0f 84 ac 00 00 00    	je     803950 <__umoddi3+0x108>
  8038a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8038a9:	29 ef                	sub    %ebp,%edi
  8038ab:	89 fe                	mov    %edi,%esi
  8038ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038b1:	89 e9                	mov    %ebp,%ecx
  8038b3:	d3 e0                	shl    %cl,%eax
  8038b5:	89 d7                	mov    %edx,%edi
  8038b7:	89 f1                	mov    %esi,%ecx
  8038b9:	d3 ef                	shr    %cl,%edi
  8038bb:	09 c7                	or     %eax,%edi
  8038bd:	89 e9                	mov    %ebp,%ecx
  8038bf:	d3 e2                	shl    %cl,%edx
  8038c1:	89 14 24             	mov    %edx,(%esp)
  8038c4:	89 d8                	mov    %ebx,%eax
  8038c6:	d3 e0                	shl    %cl,%eax
  8038c8:	89 c2                	mov    %eax,%edx
  8038ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ce:	d3 e0                	shl    %cl,%eax
  8038d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038d8:	89 f1                	mov    %esi,%ecx
  8038da:	d3 e8                	shr    %cl,%eax
  8038dc:	09 d0                	or     %edx,%eax
  8038de:	d3 eb                	shr    %cl,%ebx
  8038e0:	89 da                	mov    %ebx,%edx
  8038e2:	f7 f7                	div    %edi
  8038e4:	89 d3                	mov    %edx,%ebx
  8038e6:	f7 24 24             	mull   (%esp)
  8038e9:	89 c6                	mov    %eax,%esi
  8038eb:	89 d1                	mov    %edx,%ecx
  8038ed:	39 d3                	cmp    %edx,%ebx
  8038ef:	0f 82 87 00 00 00    	jb     80397c <__umoddi3+0x134>
  8038f5:	0f 84 91 00 00 00    	je     80398c <__umoddi3+0x144>
  8038fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038ff:	29 f2                	sub    %esi,%edx
  803901:	19 cb                	sbb    %ecx,%ebx
  803903:	89 d8                	mov    %ebx,%eax
  803905:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803909:	d3 e0                	shl    %cl,%eax
  80390b:	89 e9                	mov    %ebp,%ecx
  80390d:	d3 ea                	shr    %cl,%edx
  80390f:	09 d0                	or     %edx,%eax
  803911:	89 e9                	mov    %ebp,%ecx
  803913:	d3 eb                	shr    %cl,%ebx
  803915:	89 da                	mov    %ebx,%edx
  803917:	83 c4 1c             	add    $0x1c,%esp
  80391a:	5b                   	pop    %ebx
  80391b:	5e                   	pop    %esi
  80391c:	5f                   	pop    %edi
  80391d:	5d                   	pop    %ebp
  80391e:	c3                   	ret    
  80391f:	90                   	nop
  803920:	89 fd                	mov    %edi,%ebp
  803922:	85 ff                	test   %edi,%edi
  803924:	75 0b                	jne    803931 <__umoddi3+0xe9>
  803926:	b8 01 00 00 00       	mov    $0x1,%eax
  80392b:	31 d2                	xor    %edx,%edx
  80392d:	f7 f7                	div    %edi
  80392f:	89 c5                	mov    %eax,%ebp
  803931:	89 f0                	mov    %esi,%eax
  803933:	31 d2                	xor    %edx,%edx
  803935:	f7 f5                	div    %ebp
  803937:	89 c8                	mov    %ecx,%eax
  803939:	f7 f5                	div    %ebp
  80393b:	89 d0                	mov    %edx,%eax
  80393d:	e9 44 ff ff ff       	jmp    803886 <__umoddi3+0x3e>
  803942:	66 90                	xchg   %ax,%ax
  803944:	89 c8                	mov    %ecx,%eax
  803946:	89 f2                	mov    %esi,%edx
  803948:	83 c4 1c             	add    $0x1c,%esp
  80394b:	5b                   	pop    %ebx
  80394c:	5e                   	pop    %esi
  80394d:	5f                   	pop    %edi
  80394e:	5d                   	pop    %ebp
  80394f:	c3                   	ret    
  803950:	3b 04 24             	cmp    (%esp),%eax
  803953:	72 06                	jb     80395b <__umoddi3+0x113>
  803955:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803959:	77 0f                	ja     80396a <__umoddi3+0x122>
  80395b:	89 f2                	mov    %esi,%edx
  80395d:	29 f9                	sub    %edi,%ecx
  80395f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803963:	89 14 24             	mov    %edx,(%esp)
  803966:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80396a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80396e:	8b 14 24             	mov    (%esp),%edx
  803971:	83 c4 1c             	add    $0x1c,%esp
  803974:	5b                   	pop    %ebx
  803975:	5e                   	pop    %esi
  803976:	5f                   	pop    %edi
  803977:	5d                   	pop    %ebp
  803978:	c3                   	ret    
  803979:	8d 76 00             	lea    0x0(%esi),%esi
  80397c:	2b 04 24             	sub    (%esp),%eax
  80397f:	19 fa                	sbb    %edi,%edx
  803981:	89 d1                	mov    %edx,%ecx
  803983:	89 c6                	mov    %eax,%esi
  803985:	e9 71 ff ff ff       	jmp    8038fb <__umoddi3+0xb3>
  80398a:	66 90                	xchg   %ax,%ax
  80398c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803990:	72 ea                	jb     80397c <__umoddi3+0x134>
  803992:	89 d9                	mov    %ebx,%ecx
  803994:	e9 62 ff ff ff       	jmp    8038fb <__umoddi3+0xb3>
