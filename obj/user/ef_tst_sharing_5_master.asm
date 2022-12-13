
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
  80008d:	68 40 3a 80 00       	push   $0x803a40
  800092:	6a 12                	push   $0x12
  800094:	68 5c 3a 80 00       	push   $0x803a5c
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 7c 3a 80 00       	push   $0x803a7c
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 b0 3a 80 00       	push   $0x803ab0
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 0c 3b 80 00       	push   $0x803b0c
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 46 1d 00 00       	call   801e19 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 40 3b 80 00       	push   $0x803b40
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
  8000ff:	68 81 3b 80 00       	push   $0x803b81
  800104:	e8 bb 1c 00 00       	call   801dc4 <sys_create_env>
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
  800128:	68 81 3b 80 00       	push   $0x803b81
  80012d:	e8 92 1c 00 00       	call   801dc4 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 15 1a 00 00       	call   801b52 <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 8f 3b 80 00       	push   $0x803b8f
  80014f:	e8 2c 17 00 00       	call   801880 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 94 3b 80 00       	push   $0x803b94
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 b4 3b 80 00       	push   $0x803bb4
  80017b:	6a 26                	push   $0x26
  80017d:	68 5c 3a 80 00       	push   $0x803a5c
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 c3 19 00 00       	call   801b52 <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 20 3c 80 00       	push   $0x803c20
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 5c 3a 80 00       	push   $0x803a5c
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 5f 1d 00 00       	call   801f10 <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 26 1c 00 00       	call   801de2 <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 18 1c 00 00       	call   801de2 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 9e 3c 80 00       	push   $0x803c9e
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 2a 35 00 00       	call   803714 <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 98 1d 00 00       	call   801f8a <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 b5 3c 80 00       	push   $0x803cb5
  8001ff:	6a 33                	push   $0x33
  800201:	68 5c 3a 80 00       	push   $0x803a5c
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 dc 17 00 00       	call   8019f2 <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 c4 3c 80 00       	push   $0x803cc4
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 24 19 00 00       	call   801b52 <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 e4 3c 80 00       	push   $0x803ce4
  800248:	6a 38                	push   $0x38
  80024a:	68 5c 3a 80 00       	push   $0x803a5c
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 14 3d 80 00       	push   $0x803d14
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 38 3d 80 00       	push   $0x803d38
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
  80028d:	68 68 3d 80 00       	push   $0x803d68
  800292:	e8 2d 1b 00 00       	call   801dc4 <sys_create_env>
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
  8002b6:	68 78 3d 80 00       	push   $0x803d78
  8002bb:	e8 04 1b 00 00       	call   801dc4 <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 88 3d 80 00       	push   $0x803d88
  8002d5:	e8 a6 15 00 00       	call   801880 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 8c 3d 80 00       	push   $0x803d8c
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 8f 3b 80 00       	push   $0x803b8f
  8002ff:	e8 7c 15 00 00       	call   801880 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 94 3b 80 00       	push   $0x803b94
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 f1 1b 00 00       	call   801f10 <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 b8 1a 00 00       	call   801de2 <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 aa 1a 00 00       	call   801de2 <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 cc 33 00 00       	call   803714 <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 02 18 00 00       	call   801b52 <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 94 16 00 00       	call   8019f2 <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 ac 3d 80 00       	push   $0x803dac
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 76 16 00 00       	call   8019f2 <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 c2 3d 80 00       	push   $0x803dc2
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 be 17 00 00       	call   801b52 <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 d8 3d 80 00       	push   $0x803dd8
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 5c 3a 80 00       	push   $0x803a5c
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 b1 1b 00 00       	call   801f70 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 7d 3e 80 00       	push   $0x803e7d
  8003cb:	e8 b0 14 00 00       	call   801880 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 67 1a 00 00       	call   801e4b <sys_getparentenvid>
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
  8003fa:	68 8d 3e 80 00       	push   $0x803e8d
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 ec 19 00 00       	call   801dfe <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 de 19 00 00       	call   801dfe <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 d0 19 00 00       	call   801dfe <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 c2 19 00 00       	call   801dfe <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 00 1a 00 00       	call   801e4b <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 93 3e 80 00       	push   $0x803e93
  800453:	50                   	push   %eax
  800454:	e8 d5 14 00 00       	call   80192e <sget>
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
  800479:	e8 b4 19 00 00       	call   801e32 <sys_getenvindex>
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
  8004e4:	e8 56 17 00 00       	call   801c3f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 bc 3e 80 00       	push   $0x803ebc
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
  800514:	68 e4 3e 80 00       	push   $0x803ee4
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
  800545:	68 0c 3f 80 00       	push   $0x803f0c
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 64 3f 80 00       	push   $0x803f64
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 bc 3e 80 00       	push   $0x803ebc
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 d6 16 00 00       	call   801c59 <sys_enable_interrupt>

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
  800596:	e8 63 18 00 00       	call   801dfe <sys_destroy_env>
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
  8005a7:	e8 b8 18 00 00       	call   801e64 <sys_exit_env>
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
  8005d0:	68 78 3f 80 00       	push   $0x803f78
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 7d 3f 80 00       	push   $0x803f7d
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
  80060d:	68 99 3f 80 00       	push   $0x803f99
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
  800639:	68 9c 3f 80 00       	push   $0x803f9c
  80063e:	6a 26                	push   $0x26
  800640:	68 e8 3f 80 00       	push   $0x803fe8
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
  80070b:	68 f4 3f 80 00       	push   $0x803ff4
  800710:	6a 3a                	push   $0x3a
  800712:	68 e8 3f 80 00       	push   $0x803fe8
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
  80077b:	68 48 40 80 00       	push   $0x804048
  800780:	6a 44                	push   $0x44
  800782:	68 e8 3f 80 00       	push   $0x803fe8
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
  8007d5:	e8 b7 12 00 00       	call   801a91 <sys_cputs>
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
  80084c:	e8 40 12 00 00       	call   801a91 <sys_cputs>
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
  800896:	e8 a4 13 00 00       	call   801c3f <sys_disable_interrupt>
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
  8008b6:	e8 9e 13 00 00       	call   801c59 <sys_enable_interrupt>
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
  800900:	e8 c3 2e 00 00       	call   8037c8 <__udivdi3>
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
  800950:	e8 83 2f 00 00       	call   8038d8 <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 b4 42 80 00       	add    $0x8042b4,%eax
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
  800aab:	8b 04 85 d8 42 80 00 	mov    0x8042d8(,%eax,4),%eax
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
  800b8c:	8b 34 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 c5 42 80 00       	push   $0x8042c5
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
  800bb1:	68 ce 42 80 00       	push   $0x8042ce
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
  800bde:	be d1 42 80 00       	mov    $0x8042d1,%esi
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
  801604:	68 30 44 80 00       	push   $0x804430
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
  8016d4:	e8 fc 04 00 00       	call   801bd5 <sys_allocate_chunk>
  8016d9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016dc:	a1 20 51 80 00       	mov    0x805120,%eax
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	50                   	push   %eax
  8016e5:	e8 71 0b 00 00       	call   80225b <initialize_MemBlocksList>
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
  801712:	68 55 44 80 00       	push   $0x804455
  801717:	6a 33                	push   $0x33
  801719:	68 73 44 80 00       	push   $0x804473
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
  801791:	68 80 44 80 00       	push   $0x804480
  801796:	6a 34                	push   $0x34
  801798:	68 73 44 80 00       	push   $0x804473
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
  801829:	e8 75 07 00 00       	call   801fa3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80182e:	85 c0                	test   %eax,%eax
  801830:	74 11                	je     801843 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	ff 75 e8             	pushl  -0x18(%ebp)
  801838:	e8 e0 0d 00 00       	call   80261d <alloc_block_FF>
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
  80184f:	e8 3c 0b 00 00       	call   802390 <insert_sorted_allocList>
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
  80186f:	68 a4 44 80 00       	push   $0x8044a4
  801874:	6a 6f                	push   $0x6f
  801876:	68 73 44 80 00       	push   $0x804473
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
  801895:	75 0a                	jne    8018a1 <smalloc+0x21>
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
  80189c:	e9 8b 00 00 00       	jmp    80192c <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8018a1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	48                   	dec    %eax
  8018b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bc:	f7 75 f0             	divl   -0x10(%ebp)
  8018bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c2:	29 d0                	sub    %edx,%eax
  8018c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8018c7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8018ce:	e8 d0 06 00 00       	call   801fa3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	74 11                	je     8018e8 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	ff 75 e8             	pushl  -0x18(%ebp)
  8018dd:	e8 3b 0d 00 00       	call   80261d <alloc_block_FF>
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8018e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018ec:	74 39                	je     801927 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8018ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f1:	8b 40 08             	mov    0x8(%eax),%eax
  8018f4:	89 c2                	mov    %eax,%edx
  8018f6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018fa:	52                   	push   %edx
  8018fb:	50                   	push   %eax
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	e8 21 04 00 00       	call   801d28 <sys_createSharedObject>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80190d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801911:	74 14                	je     801927 <smalloc+0xa7>
  801913:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801917:	74 0e                	je     801927 <smalloc+0xa7>
  801919:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80191d:	74 08                	je     801927 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	8b 40 08             	mov    0x8(%eax),%eax
  801925:	eb 05                	jmp    80192c <smalloc+0xac>
	}
	return NULL;
  801927:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801934:	e8 b4 fc ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801939:	83 ec 08             	sub    $0x8,%esp
  80193c:	ff 75 0c             	pushl  0xc(%ebp)
  80193f:	ff 75 08             	pushl  0x8(%ebp)
  801942:	e8 0b 04 00 00       	call   801d52 <sys_getSizeOfSharedObject>
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80194d:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801951:	74 76                	je     8019c9 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801953:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80195a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80195d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801960:	01 d0                	add    %edx,%eax
  801962:	48                   	dec    %eax
  801963:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801969:	ba 00 00 00 00       	mov    $0x0,%edx
  80196e:	f7 75 ec             	divl   -0x14(%ebp)
  801971:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801974:	29 d0                	sub    %edx,%eax
  801976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801979:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801980:	e8 1e 06 00 00       	call   801fa3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801985:	85 c0                	test   %eax,%eax
  801987:	74 11                	je     80199a <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801989:	83 ec 0c             	sub    $0xc,%esp
  80198c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80198f:	e8 89 0c 00 00       	call   80261d <alloc_block_FF>
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80199a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80199e:	74 29                	je     8019c9 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a3:	8b 40 08             	mov    0x8(%eax),%eax
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	50                   	push   %eax
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	ff 75 08             	pushl  0x8(%ebp)
  8019b0:	e8 ba 03 00 00       	call   801d6f <sys_getSharedObject>
  8019b5:	83 c4 10             	add    $0x10,%esp
  8019b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8019bb:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8019bf:	74 08                	je     8019c9 <sget+0x9b>
				return (void *)mem_block->sva;
  8019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c4:	8b 40 08             	mov    0x8(%eax),%eax
  8019c7:	eb 05                	jmp    8019ce <sget+0xa0>
		}
	}
	return (void *)NULL;
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019d6:	e8 12 fc ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	68 c8 44 80 00       	push   $0x8044c8
  8019e3:	68 f1 00 00 00       	push   $0xf1
  8019e8:	68 73 44 80 00       	push   $0x804473
  8019ed:	e8 bd eb ff ff       	call   8005af <_panic>

008019f2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	68 f0 44 80 00       	push   $0x8044f0
  801a00:	68 05 01 00 00       	push   $0x105
  801a05:	68 73 44 80 00       	push   $0x804473
  801a0a:	e8 a0 eb ff ff       	call   8005af <_panic>

00801a0f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a15:	83 ec 04             	sub    $0x4,%esp
  801a18:	68 14 45 80 00       	push   $0x804514
  801a1d:	68 10 01 00 00       	push   $0x110
  801a22:	68 73 44 80 00       	push   $0x804473
  801a27:	e8 83 eb ff ff       	call   8005af <_panic>

00801a2c <shrink>:

}
void shrink(uint32 newSize)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a32:	83 ec 04             	sub    $0x4,%esp
  801a35:	68 14 45 80 00       	push   $0x804514
  801a3a:	68 15 01 00 00       	push   $0x115
  801a3f:	68 73 44 80 00       	push   $0x804473
  801a44:	e8 66 eb ff ff       	call   8005af <_panic>

00801a49 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	68 14 45 80 00       	push   $0x804514
  801a57:	68 1a 01 00 00       	push   $0x11a
  801a5c:	68 73 44 80 00       	push   $0x804473
  801a61:	e8 49 eb ff ff       	call   8005af <_panic>

00801a66 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a7b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a7e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a81:	cd 30                	int    $0x30
  801a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	5b                   	pop    %ebx
  801a8d:	5e                   	pop    %esi
  801a8e:	5f                   	pop    %edi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    

00801a91 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a9d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	52                   	push   %edx
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	50                   	push   %eax
  801aad:	6a 00                	push   $0x0
  801aaf:	e8 b2 ff ff ff       	call   801a66 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	90                   	nop
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_cgetc>:

int
sys_cgetc(void)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 01                	push   $0x1
  801ac9:	e8 98 ff ff ff       	call   801a66 <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	6a 05                	push   $0x5
  801ae6:	e8 7b ff ff ff       	call   801a66 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	56                   	push   %esi
  801af4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801af5:	8b 75 18             	mov    0x18(%ebp),%esi
  801af8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801afb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	56                   	push   %esi
  801b05:	53                   	push   %ebx
  801b06:	51                   	push   %ecx
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 06                	push   $0x6
  801b0b:	e8 56 ff ff ff       	call   801a66 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b16:	5b                   	pop    %ebx
  801b17:	5e                   	pop    %esi
  801b18:	5d                   	pop    %ebp
  801b19:	c3                   	ret    

00801b1a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	52                   	push   %edx
  801b2a:	50                   	push   %eax
  801b2b:	6a 07                	push   $0x7
  801b2d:	e8 34 ff ff ff       	call   801a66 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	6a 08                	push   $0x8
  801b48:	e8 19 ff ff ff       	call   801a66 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 09                	push   $0x9
  801b61:	e8 00 ff ff ff       	call   801a66 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 0a                	push   $0xa
  801b7a:	e8 e7 fe ff ff       	call   801a66 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 0b                	push   $0xb
  801b93:	e8 ce fe ff ff       	call   801a66 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	ff 75 08             	pushl  0x8(%ebp)
  801bac:	6a 0f                	push   $0xf
  801bae:	e8 b3 fe ff ff       	call   801a66 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
	return;
  801bb6:	90                   	nop
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	ff 75 08             	pushl  0x8(%ebp)
  801bc8:	6a 10                	push   $0x10
  801bca:	e8 97 fe ff ff       	call   801a66 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd2:	90                   	nop
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	ff 75 10             	pushl  0x10(%ebp)
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	ff 75 08             	pushl  0x8(%ebp)
  801be5:	6a 11                	push   $0x11
  801be7:	e8 7a fe ff ff       	call   801a66 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
	return ;
  801bef:	90                   	nop
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 0c                	push   $0xc
  801c01:	e8 60 fe ff ff       	call   801a66 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	ff 75 08             	pushl  0x8(%ebp)
  801c19:	6a 0d                	push   $0xd
  801c1b:	e8 46 fe ff ff       	call   801a66 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 0e                	push   $0xe
  801c34:	e8 2d fe ff ff       	call   801a66 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	90                   	nop
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 13                	push   $0x13
  801c4e:	e8 13 fe ff ff       	call   801a66 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	90                   	nop
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 14                	push   $0x14
  801c68:	e8 f9 fd ff ff       	call   801a66 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	90                   	nop
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 04             	sub    $0x4,%esp
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c7f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	50                   	push   %eax
  801c8c:	6a 15                	push   $0x15
  801c8e:	e8 d3 fd ff ff       	call   801a66 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	90                   	nop
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 16                	push   $0x16
  801ca8:	e8 b9 fd ff ff       	call   801a66 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	ff 75 0c             	pushl  0xc(%ebp)
  801cc2:	50                   	push   %eax
  801cc3:	6a 17                	push   $0x17
  801cc5:	e8 9c fd ff ff       	call   801a66 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	52                   	push   %edx
  801cdf:	50                   	push   %eax
  801ce0:	6a 1a                	push   $0x1a
  801ce2:	e8 7f fd ff ff       	call   801a66 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	52                   	push   %edx
  801cfc:	50                   	push   %eax
  801cfd:	6a 18                	push   $0x18
  801cff:	e8 62 fd ff ff       	call   801a66 <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	90                   	nop
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	52                   	push   %edx
  801d1a:	50                   	push   %eax
  801d1b:	6a 19                	push   $0x19
  801d1d:	e8 44 fd ff ff       	call   801a66 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	90                   	nop
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 04             	sub    $0x4,%esp
  801d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d31:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d34:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d37:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	6a 00                	push   $0x0
  801d40:	51                   	push   %ecx
  801d41:	52                   	push   %edx
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	50                   	push   %eax
  801d46:	6a 1b                	push   $0x1b
  801d48:	e8 19 fd ff ff       	call   801a66 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	52                   	push   %edx
  801d62:	50                   	push   %eax
  801d63:	6a 1c                	push   $0x1c
  801d65:	e8 fc fc ff ff       	call   801a66 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	51                   	push   %ecx
  801d80:	52                   	push   %edx
  801d81:	50                   	push   %eax
  801d82:	6a 1d                	push   $0x1d
  801d84:	e8 dd fc ff ff       	call   801a66 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	52                   	push   %edx
  801d9e:	50                   	push   %eax
  801d9f:	6a 1e                	push   $0x1e
  801da1:	e8 c0 fc ff ff       	call   801a66 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 1f                	push   $0x1f
  801dba:	e8 a7 fc ff ff       	call   801a66 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	6a 00                	push   $0x0
  801dcc:	ff 75 14             	pushl  0x14(%ebp)
  801dcf:	ff 75 10             	pushl  0x10(%ebp)
  801dd2:	ff 75 0c             	pushl  0xc(%ebp)
  801dd5:	50                   	push   %eax
  801dd6:	6a 20                	push   $0x20
  801dd8:	e8 89 fc ff ff       	call   801a66 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	50                   	push   %eax
  801df1:	6a 21                	push   $0x21
  801df3:	e8 6e fc ff ff       	call   801a66 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	90                   	nop
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	50                   	push   %eax
  801e0d:	6a 22                	push   $0x22
  801e0f:	e8 52 fc ff ff       	call   801a66 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 02                	push   $0x2
  801e28:	e8 39 fc ff ff       	call   801a66 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 03                	push   $0x3
  801e41:	e8 20 fc ff ff       	call   801a66 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 04                	push   $0x4
  801e5a:	e8 07 fc ff ff       	call   801a66 <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_exit_env>:


void sys_exit_env(void)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 23                	push   $0x23
  801e73:	e8 ee fb ff ff       	call   801a66 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	90                   	nop
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e84:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e87:	8d 50 04             	lea    0x4(%eax),%edx
  801e8a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	52                   	push   %edx
  801e94:	50                   	push   %eax
  801e95:	6a 24                	push   $0x24
  801e97:	e8 ca fb ff ff       	call   801a66 <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
	return result;
  801e9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ea5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ea8:	89 01                	mov    %eax,(%ecx)
  801eaa:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	c9                   	leave  
  801eb1:	c2 04 00             	ret    $0x4

00801eb4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	ff 75 10             	pushl  0x10(%ebp)
  801ebe:	ff 75 0c             	pushl  0xc(%ebp)
  801ec1:	ff 75 08             	pushl  0x8(%ebp)
  801ec4:	6a 12                	push   $0x12
  801ec6:	e8 9b fb ff ff       	call   801a66 <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ece:	90                   	nop
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 25                	push   $0x25
  801ee0:	e8 81 fb ff ff       	call   801a66 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 04             	sub    $0x4,%esp
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ef6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	50                   	push   %eax
  801f03:	6a 26                	push   $0x26
  801f05:	e8 5c fb ff ff       	call   801a66 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0d:	90                   	nop
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <rsttst>:
void rsttst()
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 28                	push   $0x28
  801f1f:	e8 42 fb ff ff       	call   801a66 <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
	return ;
  801f27:	90                   	nop
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 04             	sub    $0x4,%esp
  801f30:	8b 45 14             	mov    0x14(%ebp),%eax
  801f33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f36:	8b 55 18             	mov    0x18(%ebp),%edx
  801f39:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f3d:	52                   	push   %edx
  801f3e:	50                   	push   %eax
  801f3f:	ff 75 10             	pushl  0x10(%ebp)
  801f42:	ff 75 0c             	pushl  0xc(%ebp)
  801f45:	ff 75 08             	pushl  0x8(%ebp)
  801f48:	6a 27                	push   $0x27
  801f4a:	e8 17 fb ff ff       	call   801a66 <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f52:	90                   	nop
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <chktst>:
void chktst(uint32 n)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	ff 75 08             	pushl  0x8(%ebp)
  801f63:	6a 29                	push   $0x29
  801f65:	e8 fc fa ff ff       	call   801a66 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6d:	90                   	nop
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <inctst>:

void inctst()
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 2a                	push   $0x2a
  801f7f:	e8 e2 fa ff ff       	call   801a66 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
	return ;
  801f87:	90                   	nop
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <gettst>:
uint32 gettst()
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 2b                	push   $0x2b
  801f99:	e8 c8 fa ff ff       	call   801a66 <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 2c                	push   $0x2c
  801fb5:	e8 ac fa ff ff       	call   801a66 <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
  801fbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fc0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fc4:	75 07                	jne    801fcd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcb:	eb 05                	jmp    801fd2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 2c                	push   $0x2c
  801fe6:	e8 7b fa ff ff       	call   801a66 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
  801fee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ff1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ff5:	75 07                	jne    801ffe <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ff7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffc:	eb 05                	jmp    802003 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 2c                	push   $0x2c
  802017:	e8 4a fa ff ff       	call   801a66 <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
  80201f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802022:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802026:	75 07                	jne    80202f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802028:	b8 01 00 00 00       	mov    $0x1,%eax
  80202d:	eb 05                	jmp    802034 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80202f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 2c                	push   $0x2c
  802048:	e8 19 fa ff ff       	call   801a66 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
  802050:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802053:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802057:	75 07                	jne    802060 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802059:	b8 01 00 00 00       	mov    $0x1,%eax
  80205e:	eb 05                	jmp    802065 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802060:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	ff 75 08             	pushl  0x8(%ebp)
  802075:	6a 2d                	push   $0x2d
  802077:	e8 ea f9 ff ff       	call   801a66 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
	return ;
  80207f:	90                   	nop
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802086:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802089:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80208c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	6a 00                	push   $0x0
  802094:	53                   	push   %ebx
  802095:	51                   	push   %ecx
  802096:	52                   	push   %edx
  802097:	50                   	push   %eax
  802098:	6a 2e                	push   $0x2e
  80209a:	e8 c7 f9 ff ff       	call   801a66 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	52                   	push   %edx
  8020b7:	50                   	push   %eax
  8020b8:	6a 2f                	push   $0x2f
  8020ba:	e8 a7 f9 ff ff       	call   801a66 <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020ca:	83 ec 0c             	sub    $0xc,%esp
  8020cd:	68 24 45 80 00       	push   $0x804524
  8020d2:	e8 8c e7 ff ff       	call   800863 <cprintf>
  8020d7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020e1:	83 ec 0c             	sub    $0xc,%esp
  8020e4:	68 50 45 80 00       	push   $0x804550
  8020e9:	e8 75 e7 ff ff       	call   800863 <cprintf>
  8020ee:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020f1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020f5:	a1 38 51 80 00       	mov    0x805138,%eax
  8020fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fd:	eb 56                	jmp    802155 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802103:	74 1c                	je     802121 <print_mem_block_lists+0x5d>
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 50 08             	mov    0x8(%eax),%edx
  80210b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210e:	8b 48 08             	mov    0x8(%eax),%ecx
  802111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802114:	8b 40 0c             	mov    0xc(%eax),%eax
  802117:	01 c8                	add    %ecx,%eax
  802119:	39 c2                	cmp    %eax,%edx
  80211b:	73 04                	jae    802121 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80211d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	8b 50 08             	mov    0x8(%eax),%edx
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	8b 40 0c             	mov    0xc(%eax),%eax
  80212d:	01 c2                	add    %eax,%edx
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 40 08             	mov    0x8(%eax),%eax
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	52                   	push   %edx
  802139:	50                   	push   %eax
  80213a:	68 65 45 80 00       	push   $0x804565
  80213f:	e8 1f e7 ff ff       	call   800863 <cprintf>
  802144:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80214d:	a1 40 51 80 00       	mov    0x805140,%eax
  802152:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802155:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802159:	74 07                	je     802162 <print_mem_block_lists+0x9e>
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	8b 00                	mov    (%eax),%eax
  802160:	eb 05                	jmp    802167 <print_mem_block_lists+0xa3>
  802162:	b8 00 00 00 00       	mov    $0x0,%eax
  802167:	a3 40 51 80 00       	mov    %eax,0x805140
  80216c:	a1 40 51 80 00       	mov    0x805140,%eax
  802171:	85 c0                	test   %eax,%eax
  802173:	75 8a                	jne    8020ff <print_mem_block_lists+0x3b>
  802175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802179:	75 84                	jne    8020ff <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80217b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80217f:	75 10                	jne    802191 <print_mem_block_lists+0xcd>
  802181:	83 ec 0c             	sub    $0xc,%esp
  802184:	68 74 45 80 00       	push   $0x804574
  802189:	e8 d5 e6 ff ff       	call   800863 <cprintf>
  80218e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802191:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802198:	83 ec 0c             	sub    $0xc,%esp
  80219b:	68 98 45 80 00       	push   $0x804598
  8021a0:	e8 be e6 ff ff       	call   800863 <cprintf>
  8021a5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021a8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021ac:	a1 40 50 80 00       	mov    0x805040,%eax
  8021b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b4:	eb 56                	jmp    80220c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ba:	74 1c                	je     8021d8 <print_mem_block_lists+0x114>
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	8b 50 08             	mov    0x8(%eax),%edx
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	8b 48 08             	mov    0x8(%eax),%ecx
  8021c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ce:	01 c8                	add    %ecx,%eax
  8021d0:	39 c2                	cmp    %eax,%edx
  8021d2:	73 04                	jae    8021d8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021d4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	8b 50 08             	mov    0x8(%eax),%edx
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e4:	01 c2                	add    %eax,%edx
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ec:	83 ec 04             	sub    $0x4,%esp
  8021ef:	52                   	push   %edx
  8021f0:	50                   	push   %eax
  8021f1:	68 65 45 80 00       	push   $0x804565
  8021f6:	e8 68 e6 ff ff       	call   800863 <cprintf>
  8021fb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802204:	a1 48 50 80 00       	mov    0x805048,%eax
  802209:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802210:	74 07                	je     802219 <print_mem_block_lists+0x155>
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	8b 00                	mov    (%eax),%eax
  802217:	eb 05                	jmp    80221e <print_mem_block_lists+0x15a>
  802219:	b8 00 00 00 00       	mov    $0x0,%eax
  80221e:	a3 48 50 80 00       	mov    %eax,0x805048
  802223:	a1 48 50 80 00       	mov    0x805048,%eax
  802228:	85 c0                	test   %eax,%eax
  80222a:	75 8a                	jne    8021b6 <print_mem_block_lists+0xf2>
  80222c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802230:	75 84                	jne    8021b6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802232:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802236:	75 10                	jne    802248 <print_mem_block_lists+0x184>
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	68 b0 45 80 00       	push   $0x8045b0
  802240:	e8 1e e6 ff ff       	call   800863 <cprintf>
  802245:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802248:	83 ec 0c             	sub    $0xc,%esp
  80224b:	68 24 45 80 00       	push   $0x804524
  802250:	e8 0e e6 ff ff       	call   800863 <cprintf>
  802255:	83 c4 10             	add    $0x10,%esp

}
  802258:	90                   	nop
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802261:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802268:	00 00 00 
  80226b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802272:	00 00 00 
  802275:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80227c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80227f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802286:	e9 9e 00 00 00       	jmp    802329 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80228b:	a1 50 50 80 00       	mov    0x805050,%eax
  802290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802293:	c1 e2 04             	shl    $0x4,%edx
  802296:	01 d0                	add    %edx,%eax
  802298:	85 c0                	test   %eax,%eax
  80229a:	75 14                	jne    8022b0 <initialize_MemBlocksList+0x55>
  80229c:	83 ec 04             	sub    $0x4,%esp
  80229f:	68 d8 45 80 00       	push   $0x8045d8
  8022a4:	6a 46                	push   $0x46
  8022a6:	68 fb 45 80 00       	push   $0x8045fb
  8022ab:	e8 ff e2 ff ff       	call   8005af <_panic>
  8022b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8022b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b8:	c1 e2 04             	shl    $0x4,%edx
  8022bb:	01 d0                	add    %edx,%eax
  8022bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8022c3:	89 10                	mov    %edx,(%eax)
  8022c5:	8b 00                	mov    (%eax),%eax
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	74 18                	je     8022e3 <initialize_MemBlocksList+0x88>
  8022cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8022d0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022d6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022d9:	c1 e1 04             	shl    $0x4,%ecx
  8022dc:	01 ca                	add    %ecx,%edx
  8022de:	89 50 04             	mov    %edx,0x4(%eax)
  8022e1:	eb 12                	jmp    8022f5 <initialize_MemBlocksList+0x9a>
  8022e3:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022eb:	c1 e2 04             	shl    $0x4,%edx
  8022ee:	01 d0                	add    %edx,%eax
  8022f0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022f5:	a1 50 50 80 00       	mov    0x805050,%eax
  8022fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fd:	c1 e2 04             	shl    $0x4,%edx
  802300:	01 d0                	add    %edx,%eax
  802302:	a3 48 51 80 00       	mov    %eax,0x805148
  802307:	a1 50 50 80 00       	mov    0x805050,%eax
  80230c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230f:	c1 e2 04             	shl    $0x4,%edx
  802312:	01 d0                	add    %edx,%eax
  802314:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80231b:	a1 54 51 80 00       	mov    0x805154,%eax
  802320:	40                   	inc    %eax
  802321:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802326:	ff 45 f4             	incl   -0xc(%ebp)
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80232f:	0f 82 56 ff ff ff    	jb     80228b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802335:	90                   	nop
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802346:	eb 19                	jmp    802361 <find_block+0x29>
	{
		if(va==point->sva)
  802348:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80234b:	8b 40 08             	mov    0x8(%eax),%eax
  80234e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802351:	75 05                	jne    802358 <find_block+0x20>
		   return point;
  802353:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802356:	eb 36                	jmp    80238e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	8b 40 08             	mov    0x8(%eax),%eax
  80235e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802361:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802365:	74 07                	je     80236e <find_block+0x36>
  802367:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80236a:	8b 00                	mov    (%eax),%eax
  80236c:	eb 05                	jmp    802373 <find_block+0x3b>
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
  802373:	8b 55 08             	mov    0x8(%ebp),%edx
  802376:	89 42 08             	mov    %eax,0x8(%edx)
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	8b 40 08             	mov    0x8(%eax),%eax
  80237f:	85 c0                	test   %eax,%eax
  802381:	75 c5                	jne    802348 <find_block+0x10>
  802383:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802387:	75 bf                	jne    802348 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802396:	a1 40 50 80 00       	mov    0x805040,%eax
  80239b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80239e:	a1 44 50 80 00       	mov    0x805044,%eax
  8023a3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8023a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023ac:	74 24                	je     8023d2 <insert_sorted_allocList+0x42>
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	8b 50 08             	mov    0x8(%eax),%edx
  8023b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b7:	8b 40 08             	mov    0x8(%eax),%eax
  8023ba:	39 c2                	cmp    %eax,%edx
  8023bc:	76 14                	jbe    8023d2 <insert_sorted_allocList+0x42>
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	8b 50 08             	mov    0x8(%eax),%edx
  8023c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c7:	8b 40 08             	mov    0x8(%eax),%eax
  8023ca:	39 c2                	cmp    %eax,%edx
  8023cc:	0f 82 60 01 00 00    	jb     802532 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8023d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d6:	75 65                	jne    80243d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8023d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023dc:	75 14                	jne    8023f2 <insert_sorted_allocList+0x62>
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	68 d8 45 80 00       	push   $0x8045d8
  8023e6:	6a 6b                	push   $0x6b
  8023e8:	68 fb 45 80 00       	push   $0x8045fb
  8023ed:	e8 bd e1 ff ff       	call   8005af <_panic>
  8023f2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	89 10                	mov    %edx,(%eax)
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	74 0d                	je     802413 <insert_sorted_allocList+0x83>
  802406:	a1 40 50 80 00       	mov    0x805040,%eax
  80240b:	8b 55 08             	mov    0x8(%ebp),%edx
  80240e:	89 50 04             	mov    %edx,0x4(%eax)
  802411:	eb 08                	jmp    80241b <insert_sorted_allocList+0x8b>
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	a3 44 50 80 00       	mov    %eax,0x805044
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	a3 40 50 80 00       	mov    %eax,0x805040
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80242d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802432:	40                   	inc    %eax
  802433:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802438:	e9 dc 01 00 00       	jmp    802619 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8b 50 08             	mov    0x8(%eax),%edx
  802443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802446:	8b 40 08             	mov    0x8(%eax),%eax
  802449:	39 c2                	cmp    %eax,%edx
  80244b:	77 6c                	ja     8024b9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80244d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802451:	74 06                	je     802459 <insert_sorted_allocList+0xc9>
  802453:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802457:	75 14                	jne    80246d <insert_sorted_allocList+0xdd>
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	68 14 46 80 00       	push   $0x804614
  802461:	6a 6f                	push   $0x6f
  802463:	68 fb 45 80 00       	push   $0x8045fb
  802468:	e8 42 e1 ff ff       	call   8005af <_panic>
  80246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802470:	8b 50 04             	mov    0x4(%eax),%edx
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	89 50 04             	mov    %edx,0x4(%eax)
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80247f:	89 10                	mov    %edx,(%eax)
  802481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802484:	8b 40 04             	mov    0x4(%eax),%eax
  802487:	85 c0                	test   %eax,%eax
  802489:	74 0d                	je     802498 <insert_sorted_allocList+0x108>
  80248b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	8b 55 08             	mov    0x8(%ebp),%edx
  802494:	89 10                	mov    %edx,(%eax)
  802496:	eb 08                	jmp    8024a0 <insert_sorted_allocList+0x110>
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	a3 40 50 80 00       	mov    %eax,0x805040
  8024a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a6:	89 50 04             	mov    %edx,0x4(%eax)
  8024a9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024ae:	40                   	inc    %eax
  8024af:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024b4:	e9 60 01 00 00       	jmp    802619 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	8b 50 08             	mov    0x8(%eax),%edx
  8024bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c2:	8b 40 08             	mov    0x8(%eax),%eax
  8024c5:	39 c2                	cmp    %eax,%edx
  8024c7:	0f 82 4c 01 00 00    	jb     802619 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8024cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024d1:	75 14                	jne    8024e7 <insert_sorted_allocList+0x157>
  8024d3:	83 ec 04             	sub    $0x4,%esp
  8024d6:	68 4c 46 80 00       	push   $0x80464c
  8024db:	6a 73                	push   $0x73
  8024dd:	68 fb 45 80 00       	push   $0x8045fb
  8024e2:	e8 c8 e0 ff ff       	call   8005af <_panic>
  8024e7:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	89 50 04             	mov    %edx,0x4(%eax)
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	8b 40 04             	mov    0x4(%eax),%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	74 0c                	je     802509 <insert_sorted_allocList+0x179>
  8024fd:	a1 44 50 80 00       	mov    0x805044,%eax
  802502:	8b 55 08             	mov    0x8(%ebp),%edx
  802505:	89 10                	mov    %edx,(%eax)
  802507:	eb 08                	jmp    802511 <insert_sorted_allocList+0x181>
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	a3 40 50 80 00       	mov    %eax,0x805040
  802511:	8b 45 08             	mov    0x8(%ebp),%eax
  802514:	a3 44 50 80 00       	mov    %eax,0x805044
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802522:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802527:	40                   	inc    %eax
  802528:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80252d:	e9 e7 00 00 00       	jmp    802619 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802535:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802538:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80253f:	a1 40 50 80 00       	mov    0x805040,%eax
  802544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802547:	e9 9d 00 00 00       	jmp    8025e9 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	8b 50 08             	mov    0x8(%eax),%edx
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 08             	mov    0x8(%eax),%eax
  802560:	39 c2                	cmp    %eax,%edx
  802562:	76 7d                	jbe    8025e1 <insert_sorted_allocList+0x251>
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	8b 50 08             	mov    0x8(%eax),%edx
  80256a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80256d:	8b 40 08             	mov    0x8(%eax),%eax
  802570:	39 c2                	cmp    %eax,%edx
  802572:	73 6d                	jae    8025e1 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802578:	74 06                	je     802580 <insert_sorted_allocList+0x1f0>
  80257a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80257e:	75 14                	jne    802594 <insert_sorted_allocList+0x204>
  802580:	83 ec 04             	sub    $0x4,%esp
  802583:	68 70 46 80 00       	push   $0x804670
  802588:	6a 7f                	push   $0x7f
  80258a:	68 fb 45 80 00       	push   $0x8045fb
  80258f:	e8 1b e0 ff ff       	call   8005af <_panic>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 10                	mov    (%eax),%edx
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	89 10                	mov    %edx,(%eax)
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	74 0b                	je     8025b2 <insert_sorted_allocList+0x222>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8025af:	89 50 04             	mov    %edx,0x4(%eax)
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b8:	89 10                	mov    %edx,(%eax)
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c0:	89 50 04             	mov    %edx,0x4(%eax)
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	75 08                	jne    8025d4 <insert_sorted_allocList+0x244>
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	a3 44 50 80 00       	mov    %eax,0x805044
  8025d4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025d9:	40                   	inc    %eax
  8025da:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8025df:	eb 39                	jmp    80261a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8025e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ed:	74 07                	je     8025f6 <insert_sorted_allocList+0x266>
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 00                	mov    (%eax),%eax
  8025f4:	eb 05                	jmp    8025fb <insert_sorted_allocList+0x26b>
  8025f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fb:	a3 48 50 80 00       	mov    %eax,0x805048
  802600:	a1 48 50 80 00       	mov    0x805048,%eax
  802605:	85 c0                	test   %eax,%eax
  802607:	0f 85 3f ff ff ff    	jne    80254c <insert_sorted_allocList+0x1bc>
  80260d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802611:	0f 85 35 ff ff ff    	jne    80254c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802617:	eb 01                	jmp    80261a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802619:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80261a:	90                   	nop
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80261d:	55                   	push   %ebp
  80261e:	89 e5                	mov    %esp,%ebp
  802620:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802623:	a1 38 51 80 00       	mov    0x805138,%eax
  802628:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262b:	e9 85 01 00 00       	jmp    8027b5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 40 0c             	mov    0xc(%eax),%eax
  802636:	3b 45 08             	cmp    0x8(%ebp),%eax
  802639:	0f 82 6e 01 00 00    	jb     8027ad <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 40 0c             	mov    0xc(%eax),%eax
  802645:	3b 45 08             	cmp    0x8(%ebp),%eax
  802648:	0f 85 8a 00 00 00    	jne    8026d8 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	75 17                	jne    80266b <alloc_block_FF+0x4e>
  802654:	83 ec 04             	sub    $0x4,%esp
  802657:	68 a4 46 80 00       	push   $0x8046a4
  80265c:	68 93 00 00 00       	push   $0x93
  802661:	68 fb 45 80 00       	push   $0x8045fb
  802666:	e8 44 df ff ff       	call   8005af <_panic>
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	74 10                	je     802684 <alloc_block_FF+0x67>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267c:	8b 52 04             	mov    0x4(%edx),%edx
  80267f:	89 50 04             	mov    %edx,0x4(%eax)
  802682:	eb 0b                	jmp    80268f <alloc_block_FF+0x72>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 04             	mov    0x4(%eax),%eax
  80268a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	74 0f                	je     8026a8 <alloc_block_FF+0x8b>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 04             	mov    0x4(%eax),%eax
  80269f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a2:	8b 12                	mov    (%edx),%edx
  8026a4:	89 10                	mov    %edx,(%eax)
  8026a6:	eb 0a                	jmp    8026b2 <alloc_block_FF+0x95>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 00                	mov    (%eax),%eax
  8026ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8026ca:	48                   	dec    %eax
  8026cb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	e9 10 01 00 00       	jmp    8027e8 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 40 0c             	mov    0xc(%eax),%eax
  8026de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e1:	0f 86 c6 00 00 00    	jbe    8027ad <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8026ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 50 08             	mov    0x8(%eax),%edx
  8026f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f8:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8026fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802701:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802704:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802708:	75 17                	jne    802721 <alloc_block_FF+0x104>
  80270a:	83 ec 04             	sub    $0x4,%esp
  80270d:	68 a4 46 80 00       	push   $0x8046a4
  802712:	68 9b 00 00 00       	push   $0x9b
  802717:	68 fb 45 80 00       	push   $0x8045fb
  80271c:	e8 8e de ff ff       	call   8005af <_panic>
  802721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	85 c0                	test   %eax,%eax
  802728:	74 10                	je     80273a <alloc_block_FF+0x11d>
  80272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802732:	8b 52 04             	mov    0x4(%edx),%edx
  802735:	89 50 04             	mov    %edx,0x4(%eax)
  802738:	eb 0b                	jmp    802745 <alloc_block_FF+0x128>
  80273a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273d:	8b 40 04             	mov    0x4(%eax),%eax
  802740:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	8b 40 04             	mov    0x4(%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 0f                	je     80275e <alloc_block_FF+0x141>
  80274f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802752:	8b 40 04             	mov    0x4(%eax),%eax
  802755:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802758:	8b 12                	mov    (%edx),%edx
  80275a:	89 10                	mov    %edx,(%eax)
  80275c:	eb 0a                	jmp    802768 <alloc_block_FF+0x14b>
  80275e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	a3 48 51 80 00       	mov    %eax,0x805148
  802768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802774:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277b:	a1 54 51 80 00       	mov    0x805154,%eax
  802780:	48                   	dec    %eax
  802781:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 50 08             	mov    0x8(%eax),%edx
  80278c:	8b 45 08             	mov    0x8(%ebp),%eax
  80278f:	01 c2                	add    %eax,%edx
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 40 0c             	mov    0xc(%eax),%eax
  80279d:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a0:	89 c2                	mov    %eax,%edx
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	eb 3b                	jmp    8027e8 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	74 07                	je     8027c2 <alloc_block_FF+0x1a5>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	eb 05                	jmp    8027c7 <alloc_block_FF+0x1aa>
  8027c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c7:	a3 40 51 80 00       	mov    %eax,0x805140
  8027cc:	a1 40 51 80 00       	mov    0x805140,%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	0f 85 57 fe ff ff    	jne    802630 <alloc_block_FF+0x13>
  8027d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dd:	0f 85 4d fe ff ff    	jne    802630 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8027f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8027fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ff:	e9 df 00 00 00       	jmp    8028e3 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 40 0c             	mov    0xc(%eax),%eax
  80280a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280d:	0f 82 c8 00 00 00    	jb     8028db <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 40 0c             	mov    0xc(%eax),%eax
  802819:	3b 45 08             	cmp    0x8(%ebp),%eax
  80281c:	0f 85 8a 00 00 00    	jne    8028ac <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802826:	75 17                	jne    80283f <alloc_block_BF+0x55>
  802828:	83 ec 04             	sub    $0x4,%esp
  80282b:	68 a4 46 80 00       	push   $0x8046a4
  802830:	68 b7 00 00 00       	push   $0xb7
  802835:	68 fb 45 80 00       	push   $0x8045fb
  80283a:	e8 70 dd ff ff       	call   8005af <_panic>
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	74 10                	je     802858 <alloc_block_BF+0x6e>
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802850:	8b 52 04             	mov    0x4(%edx),%edx
  802853:	89 50 04             	mov    %edx,0x4(%eax)
  802856:	eb 0b                	jmp    802863 <alloc_block_BF+0x79>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 40 04             	mov    0x4(%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 0f                	je     80287c <alloc_block_BF+0x92>
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802876:	8b 12                	mov    (%edx),%edx
  802878:	89 10                	mov    %edx,(%eax)
  80287a:	eb 0a                	jmp    802886 <alloc_block_BF+0x9c>
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	a3 38 51 80 00       	mov    %eax,0x805138
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802899:	a1 44 51 80 00       	mov    0x805144,%eax
  80289e:	48                   	dec    %eax
  80289f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	e9 4d 01 00 00       	jmp    8029f9 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b5:	76 24                	jbe    8028db <alloc_block_BF+0xf1>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028c0:	73 19                	jae    8028db <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8028c2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 08             	mov    0x8(%eax),%eax
  8028d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028db:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e7:	74 07                	je     8028f0 <alloc_block_BF+0x106>
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	eb 05                	jmp    8028f5 <alloc_block_BF+0x10b>
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f5:	a3 40 51 80 00       	mov    %eax,0x805140
  8028fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	0f 85 fd fe ff ff    	jne    802804 <alloc_block_BF+0x1a>
  802907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290b:	0f 85 f3 fe ff ff    	jne    802804 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802911:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802915:	0f 84 d9 00 00 00    	je     8029f4 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80291b:	a1 48 51 80 00       	mov    0x805148,%eax
  802920:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802926:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802929:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80292c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292f:	8b 55 08             	mov    0x8(%ebp),%edx
  802932:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802935:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802939:	75 17                	jne    802952 <alloc_block_BF+0x168>
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	68 a4 46 80 00       	push   $0x8046a4
  802943:	68 c7 00 00 00       	push   $0xc7
  802948:	68 fb 45 80 00       	push   $0x8045fb
  80294d:	e8 5d dc ff ff       	call   8005af <_panic>
  802952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	74 10                	je     80296b <alloc_block_BF+0x181>
  80295b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802963:	8b 52 04             	mov    0x4(%edx),%edx
  802966:	89 50 04             	mov    %edx,0x4(%eax)
  802969:	eb 0b                	jmp    802976 <alloc_block_BF+0x18c>
  80296b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296e:	8b 40 04             	mov    0x4(%eax),%eax
  802971:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802979:	8b 40 04             	mov    0x4(%eax),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 0f                	je     80298f <alloc_block_BF+0x1a5>
  802980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802989:	8b 12                	mov    (%edx),%edx
  80298b:	89 10                	mov    %edx,(%eax)
  80298d:	eb 0a                	jmp    802999 <alloc_block_BF+0x1af>
  80298f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	a3 48 51 80 00       	mov    %eax,0x805148
  802999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8029b1:	48                   	dec    %eax
  8029b2:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8029b7:	83 ec 08             	sub    $0x8,%esp
  8029ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8029bd:	68 38 51 80 00       	push   $0x805138
  8029c2:	e8 71 f9 ff ff       	call   802338 <find_block>
  8029c7:	83 c4 10             	add    $0x10,%esp
  8029ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8029cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d0:	8b 50 08             	mov    0x8(%eax),%edx
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	01 c2                	add    %eax,%edx
  8029d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029db:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8029de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e4:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e7:	89 c2                	mov    %eax,%edx
  8029e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ec:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8029ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f2:	eb 05                	jmp    8029f9 <alloc_block_BF+0x20f>
	}
	return NULL;
  8029f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f9:	c9                   	leave  
  8029fa:	c3                   	ret    

008029fb <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029fb:	55                   	push   %ebp
  8029fc:	89 e5                	mov    %esp,%ebp
  8029fe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a01:	a1 28 50 80 00       	mov    0x805028,%eax
  802a06:	85 c0                	test   %eax,%eax
  802a08:	0f 85 de 01 00 00    	jne    802bec <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a0e:	a1 38 51 80 00       	mov    0x805138,%eax
  802a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a16:	e9 9e 01 00 00       	jmp    802bb9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a21:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a24:	0f 82 87 01 00 00    	jb     802bb1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a30:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a33:	0f 85 95 00 00 00    	jne    802ace <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3d:	75 17                	jne    802a56 <alloc_block_NF+0x5b>
  802a3f:	83 ec 04             	sub    $0x4,%esp
  802a42:	68 a4 46 80 00       	push   $0x8046a4
  802a47:	68 e0 00 00 00       	push   $0xe0
  802a4c:	68 fb 45 80 00       	push   $0x8045fb
  802a51:	e8 59 db ff ff       	call   8005af <_panic>
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	74 10                	je     802a6f <alloc_block_NF+0x74>
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a67:	8b 52 04             	mov    0x4(%edx),%edx
  802a6a:	89 50 04             	mov    %edx,0x4(%eax)
  802a6d:	eb 0b                	jmp    802a7a <alloc_block_NF+0x7f>
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 40 04             	mov    0x4(%eax),%eax
  802a75:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 0f                	je     802a93 <alloc_block_NF+0x98>
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	8b 40 04             	mov    0x4(%eax),%eax
  802a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8d:	8b 12                	mov    (%edx),%edx
  802a8f:	89 10                	mov    %edx,(%eax)
  802a91:	eb 0a                	jmp    802a9d <alloc_block_NF+0xa2>
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 00                	mov    (%eax),%eax
  802a98:	a3 38 51 80 00       	mov    %eax,0x805138
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab5:	48                   	dec    %eax
  802ab6:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 40 08             	mov    0x8(%eax),%eax
  802ac1:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	e9 f8 04 00 00       	jmp    802fc6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad7:	0f 86 d4 00 00 00    	jbe    802bb1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802add:	a1 48 51 80 00       	mov    0x805148,%eax
  802ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 50 08             	mov    0x8(%eax),%edx
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aee:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af4:	8b 55 08             	mov    0x8(%ebp),%edx
  802af7:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802afa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802afe:	75 17                	jne    802b17 <alloc_block_NF+0x11c>
  802b00:	83 ec 04             	sub    $0x4,%esp
  802b03:	68 a4 46 80 00       	push   $0x8046a4
  802b08:	68 e9 00 00 00       	push   $0xe9
  802b0d:	68 fb 45 80 00       	push   $0x8045fb
  802b12:	e8 98 da ff ff       	call   8005af <_panic>
  802b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	74 10                	je     802b30 <alloc_block_NF+0x135>
  802b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b28:	8b 52 04             	mov    0x4(%edx),%edx
  802b2b:	89 50 04             	mov    %edx,0x4(%eax)
  802b2e:	eb 0b                	jmp    802b3b <alloc_block_NF+0x140>
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 0f                	je     802b54 <alloc_block_NF+0x159>
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4e:	8b 12                	mov    (%edx),%edx
  802b50:	89 10                	mov    %edx,(%eax)
  802b52:	eb 0a                	jmp    802b5e <alloc_block_NF+0x163>
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	a3 48 51 80 00       	mov    %eax,0x805148
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b71:	a1 54 51 80 00       	mov    0x805154,%eax
  802b76:	48                   	dec    %eax
  802b77:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	8b 40 08             	mov    0x8(%eax),%eax
  802b82:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 50 08             	mov    0x8(%eax),%edx
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	01 c2                	add    %eax,%edx
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9e:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba1:	89 c2                	mov    %eax,%edx
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	e9 15 04 00 00       	jmp    802fc6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802bb1:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbd:	74 07                	je     802bc6 <alloc_block_NF+0x1cb>
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	eb 05                	jmp    802bcb <alloc_block_NF+0x1d0>
  802bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcb:	a3 40 51 80 00       	mov    %eax,0x805140
  802bd0:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	0f 85 3e fe ff ff    	jne    802a1b <alloc_block_NF+0x20>
  802bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be1:	0f 85 34 fe ff ff    	jne    802a1b <alloc_block_NF+0x20>
  802be7:	e9 d5 03 00 00       	jmp    802fc1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bec:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf4:	e9 b1 01 00 00       	jmp    802daa <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 50 08             	mov    0x8(%eax),%edx
  802bff:	a1 28 50 80 00       	mov    0x805028,%eax
  802c04:	39 c2                	cmp    %eax,%edx
  802c06:	0f 82 96 01 00 00    	jb     802da2 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c12:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c15:	0f 82 87 01 00 00    	jb     802da2 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c21:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c24:	0f 85 95 00 00 00    	jne    802cbf <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2e:	75 17                	jne    802c47 <alloc_block_NF+0x24c>
  802c30:	83 ec 04             	sub    $0x4,%esp
  802c33:	68 a4 46 80 00       	push   $0x8046a4
  802c38:	68 fc 00 00 00       	push   $0xfc
  802c3d:	68 fb 45 80 00       	push   $0x8045fb
  802c42:	e8 68 d9 ff ff       	call   8005af <_panic>
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	74 10                	je     802c60 <alloc_block_NF+0x265>
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c58:	8b 52 04             	mov    0x4(%edx),%edx
  802c5b:	89 50 04             	mov    %edx,0x4(%eax)
  802c5e:	eb 0b                	jmp    802c6b <alloc_block_NF+0x270>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 40 04             	mov    0x4(%eax),%eax
  802c66:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	74 0f                	je     802c84 <alloc_block_NF+0x289>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 40 04             	mov    0x4(%eax),%eax
  802c7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7e:	8b 12                	mov    (%edx),%edx
  802c80:	89 10                	mov    %edx,(%eax)
  802c82:	eb 0a                	jmp    802c8e <alloc_block_NF+0x293>
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	a3 38 51 80 00       	mov    %eax,0x805138
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca6:	48                   	dec    %eax
  802ca7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 40 08             	mov    0x8(%eax),%eax
  802cb2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	e9 07 03 00 00       	jmp    802fc6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc8:	0f 86 d4 00 00 00    	jbe    802da2 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cce:	a1 48 51 80 00       	mov    0x805148,%eax
  802cd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 50 08             	mov    0x8(%eax),%edx
  802cdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ceb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cef:	75 17                	jne    802d08 <alloc_block_NF+0x30d>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 a4 46 80 00       	push   $0x8046a4
  802cf9:	68 04 01 00 00       	push   $0x104
  802cfe:	68 fb 45 80 00       	push   $0x8045fb
  802d03:	e8 a7 d8 ff ff       	call   8005af <_panic>
  802d08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	85 c0                	test   %eax,%eax
  802d0f:	74 10                	je     802d21 <alloc_block_NF+0x326>
  802d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d19:	8b 52 04             	mov    0x4(%edx),%edx
  802d1c:	89 50 04             	mov    %edx,0x4(%eax)
  802d1f:	eb 0b                	jmp    802d2c <alloc_block_NF+0x331>
  802d21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d24:	8b 40 04             	mov    0x4(%eax),%eax
  802d27:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	74 0f                	je     802d45 <alloc_block_NF+0x34a>
  802d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d39:	8b 40 04             	mov    0x4(%eax),%eax
  802d3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d3f:	8b 12                	mov    (%edx),%edx
  802d41:	89 10                	mov    %edx,(%eax)
  802d43:	eb 0a                	jmp    802d4f <alloc_block_NF+0x354>
  802d45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	a3 48 51 80 00       	mov    %eax,0x805148
  802d4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d62:	a1 54 51 80 00       	mov    0x805154,%eax
  802d67:	48                   	dec    %eax
  802d68:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d70:	8b 40 08             	mov    0x8(%eax),%eax
  802d73:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 50 08             	mov    0x8(%eax),%edx
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	01 c2                	add    %eax,%edx
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8f:	2b 45 08             	sub    0x8(%ebp),%eax
  802d92:	89 c2                	mov    %eax,%edx
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9d:	e9 24 02 00 00       	jmp    802fc6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802da2:	a1 40 51 80 00       	mov    0x805140,%eax
  802da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802daa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dae:	74 07                	je     802db7 <alloc_block_NF+0x3bc>
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	eb 05                	jmp    802dbc <alloc_block_NF+0x3c1>
  802db7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dbc:	a3 40 51 80 00       	mov    %eax,0x805140
  802dc1:	a1 40 51 80 00       	mov    0x805140,%eax
  802dc6:	85 c0                	test   %eax,%eax
  802dc8:	0f 85 2b fe ff ff    	jne    802bf9 <alloc_block_NF+0x1fe>
  802dce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd2:	0f 85 21 fe ff ff    	jne    802bf9 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dd8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de0:	e9 ae 01 00 00       	jmp    802f93 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 50 08             	mov    0x8(%eax),%edx
  802deb:	a1 28 50 80 00       	mov    0x805028,%eax
  802df0:	39 c2                	cmp    %eax,%edx
  802df2:	0f 83 93 01 00 00    	jae    802f8b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e01:	0f 82 84 01 00 00    	jb     802f8b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e10:	0f 85 95 00 00 00    	jne    802eab <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1a:	75 17                	jne    802e33 <alloc_block_NF+0x438>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 a4 46 80 00       	push   $0x8046a4
  802e24:	68 14 01 00 00       	push   $0x114
  802e29:	68 fb 45 80 00       	push   $0x8045fb
  802e2e:	e8 7c d7 ff ff       	call   8005af <_panic>
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	74 10                	je     802e4c <alloc_block_NF+0x451>
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e44:	8b 52 04             	mov    0x4(%edx),%edx
  802e47:	89 50 04             	mov    %edx,0x4(%eax)
  802e4a:	eb 0b                	jmp    802e57 <alloc_block_NF+0x45c>
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0f                	je     802e70 <alloc_block_NF+0x475>
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6a:	8b 12                	mov    (%edx),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	eb 0a                	jmp    802e7a <alloc_block_NF+0x47f>
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	a3 38 51 80 00       	mov    %eax,0x805138
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e92:	48                   	dec    %eax
  802e93:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 08             	mov    0x8(%eax),%eax
  802e9e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	e9 1b 01 00 00       	jmp    802fc6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb4:	0f 86 d1 00 00 00    	jbe    802f8b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802eba:	a1 48 51 80 00       	mov    0x805148,%eax
  802ebf:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 50 08             	mov    0x8(%eax),%edx
  802ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ed7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802edb:	75 17                	jne    802ef4 <alloc_block_NF+0x4f9>
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	68 a4 46 80 00       	push   $0x8046a4
  802ee5:	68 1c 01 00 00       	push   $0x11c
  802eea:	68 fb 45 80 00       	push   $0x8045fb
  802eef:	e8 bb d6 ff ff       	call   8005af <_panic>
  802ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 10                	je     802f0d <alloc_block_NF+0x512>
  802efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f05:	8b 52 04             	mov    0x4(%edx),%edx
  802f08:	89 50 04             	mov    %edx,0x4(%eax)
  802f0b:	eb 0b                	jmp    802f18 <alloc_block_NF+0x51d>
  802f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 0f                	je     802f31 <alloc_block_NF+0x536>
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f2b:	8b 12                	mov    (%edx),%edx
  802f2d:	89 10                	mov    %edx,(%eax)
  802f2f:	eb 0a                	jmp    802f3b <alloc_block_NF+0x540>
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	a3 48 51 80 00       	mov    %eax,0x805148
  802f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4e:	a1 54 51 80 00       	mov    0x805154,%eax
  802f53:	48                   	dec    %eax
  802f54:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5c:	8b 40 08             	mov    0x8(%eax),%eax
  802f5f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 50 08             	mov    0x8(%eax),%edx
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	01 c2                	add    %eax,%edx
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7b:	2b 45 08             	sub    0x8(%ebp),%eax
  802f7e:	89 c2                	mov    %eax,%edx
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f89:	eb 3b                	jmp    802fc6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f8b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f97:	74 07                	je     802fa0 <alloc_block_NF+0x5a5>
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 00                	mov    (%eax),%eax
  802f9e:	eb 05                	jmp    802fa5 <alloc_block_NF+0x5aa>
  802fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa5:	a3 40 51 80 00       	mov    %eax,0x805140
  802faa:	a1 40 51 80 00       	mov    0x805140,%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	0f 85 2e fe ff ff    	jne    802de5 <alloc_block_NF+0x3ea>
  802fb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fbb:	0f 85 24 fe ff ff    	jne    802de5 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fc6:	c9                   	leave  
  802fc7:	c3                   	ret    

00802fc8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802fc8:	55                   	push   %ebp
  802fc9:	89 e5                	mov    %esp,%ebp
  802fcb:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802fce:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802fd6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802fde:	a1 38 51 80 00       	mov    0x805138,%eax
  802fe3:	85 c0                	test   %eax,%eax
  802fe5:	74 14                	je     802ffb <insert_sorted_with_merge_freeList+0x33>
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	8b 50 08             	mov    0x8(%eax),%edx
  802fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff0:	8b 40 08             	mov    0x8(%eax),%eax
  802ff3:	39 c2                	cmp    %eax,%edx
  802ff5:	0f 87 9b 01 00 00    	ja     803196 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ffb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fff:	75 17                	jne    803018 <insert_sorted_with_merge_freeList+0x50>
  803001:	83 ec 04             	sub    $0x4,%esp
  803004:	68 d8 45 80 00       	push   $0x8045d8
  803009:	68 38 01 00 00       	push   $0x138
  80300e:	68 fb 45 80 00       	push   $0x8045fb
  803013:	e8 97 d5 ff ff       	call   8005af <_panic>
  803018:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	89 10                	mov    %edx,(%eax)
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	8b 00                	mov    (%eax),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	74 0d                	je     803039 <insert_sorted_with_merge_freeList+0x71>
  80302c:	a1 38 51 80 00       	mov    0x805138,%eax
  803031:	8b 55 08             	mov    0x8(%ebp),%edx
  803034:	89 50 04             	mov    %edx,0x4(%eax)
  803037:	eb 08                	jmp    803041 <insert_sorted_with_merge_freeList+0x79>
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	a3 38 51 80 00       	mov    %eax,0x805138
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803053:	a1 44 51 80 00       	mov    0x805144,%eax
  803058:	40                   	inc    %eax
  803059:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80305e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803062:	0f 84 a8 06 00 00    	je     803710 <insert_sorted_with_merge_freeList+0x748>
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	8b 50 08             	mov    0x8(%eax),%edx
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	8b 40 0c             	mov    0xc(%eax),%eax
  803074:	01 c2                	add    %eax,%edx
  803076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803079:	8b 40 08             	mov    0x8(%eax),%eax
  80307c:	39 c2                	cmp    %eax,%edx
  80307e:	0f 85 8c 06 00 00    	jne    803710 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	8b 50 0c             	mov    0xc(%eax),%edx
  80308a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308d:	8b 40 0c             	mov    0xc(%eax),%eax
  803090:	01 c2                	add    %eax,%edx
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803098:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80309c:	75 17                	jne    8030b5 <insert_sorted_with_merge_freeList+0xed>
  80309e:	83 ec 04             	sub    $0x4,%esp
  8030a1:	68 a4 46 80 00       	push   $0x8046a4
  8030a6:	68 3c 01 00 00       	push   $0x13c
  8030ab:	68 fb 45 80 00       	push   $0x8045fb
  8030b0:	e8 fa d4 ff ff       	call   8005af <_panic>
  8030b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b8:	8b 00                	mov    (%eax),%eax
  8030ba:	85 c0                	test   %eax,%eax
  8030bc:	74 10                	je     8030ce <insert_sorted_with_merge_freeList+0x106>
  8030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c6:	8b 52 04             	mov    0x4(%edx),%edx
  8030c9:	89 50 04             	mov    %edx,0x4(%eax)
  8030cc:	eb 0b                	jmp    8030d9 <insert_sorted_with_merge_freeList+0x111>
  8030ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d1:	8b 40 04             	mov    0x4(%eax),%eax
  8030d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	8b 40 04             	mov    0x4(%eax),%eax
  8030df:	85 c0                	test   %eax,%eax
  8030e1:	74 0f                	je     8030f2 <insert_sorted_with_merge_freeList+0x12a>
  8030e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e6:	8b 40 04             	mov    0x4(%eax),%eax
  8030e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ec:	8b 12                	mov    (%edx),%edx
  8030ee:	89 10                	mov    %edx,(%eax)
  8030f0:	eb 0a                	jmp    8030fc <insert_sorted_with_merge_freeList+0x134>
  8030f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	a3 38 51 80 00       	mov    %eax,0x805138
  8030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310f:	a1 44 51 80 00       	mov    0x805144,%eax
  803114:	48                   	dec    %eax
  803115:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80311a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803127:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80312e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803132:	75 17                	jne    80314b <insert_sorted_with_merge_freeList+0x183>
  803134:	83 ec 04             	sub    $0x4,%esp
  803137:	68 d8 45 80 00       	push   $0x8045d8
  80313c:	68 3f 01 00 00       	push   $0x13f
  803141:	68 fb 45 80 00       	push   $0x8045fb
  803146:	e8 64 d4 ff ff       	call   8005af <_panic>
  80314b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803154:	89 10                	mov    %edx,(%eax)
  803156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803159:	8b 00                	mov    (%eax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	74 0d                	je     80316c <insert_sorted_with_merge_freeList+0x1a4>
  80315f:	a1 48 51 80 00       	mov    0x805148,%eax
  803164:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803167:	89 50 04             	mov    %edx,0x4(%eax)
  80316a:	eb 08                	jmp    803174 <insert_sorted_with_merge_freeList+0x1ac>
  80316c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803177:	a3 48 51 80 00       	mov    %eax,0x805148
  80317c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803186:	a1 54 51 80 00       	mov    0x805154,%eax
  80318b:	40                   	inc    %eax
  80318c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803191:	e9 7a 05 00 00       	jmp    803710 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	8b 50 08             	mov    0x8(%eax),%edx
  80319c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319f:	8b 40 08             	mov    0x8(%eax),%eax
  8031a2:	39 c2                	cmp    %eax,%edx
  8031a4:	0f 82 14 01 00 00    	jb     8032be <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8031aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ad:	8b 50 08             	mov    0x8(%eax),%edx
  8031b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b6:	01 c2                	add    %eax,%edx
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	8b 40 08             	mov    0x8(%eax),%eax
  8031be:	39 c2                	cmp    %eax,%edx
  8031c0:	0f 85 90 00 00 00    	jne    803256 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8031c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c9:	8b 50 0c             	mov    0xc(%eax),%edx
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d2:	01 c2                	add    %eax,%edx
  8031d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d7:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f2:	75 17                	jne    80320b <insert_sorted_with_merge_freeList+0x243>
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	68 d8 45 80 00       	push   $0x8045d8
  8031fc:	68 49 01 00 00       	push   $0x149
  803201:	68 fb 45 80 00       	push   $0x8045fb
  803206:	e8 a4 d3 ff ff       	call   8005af <_panic>
  80320b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	89 10                	mov    %edx,(%eax)
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 0d                	je     80322c <insert_sorted_with_merge_freeList+0x264>
  80321f:	a1 48 51 80 00       	mov    0x805148,%eax
  803224:	8b 55 08             	mov    0x8(%ebp),%edx
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	eb 08                	jmp    803234 <insert_sorted_with_merge_freeList+0x26c>
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	a3 48 51 80 00       	mov    %eax,0x805148
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	a1 54 51 80 00       	mov    0x805154,%eax
  80324b:	40                   	inc    %eax
  80324c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803251:	e9 bb 04 00 00       	jmp    803711 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325a:	75 17                	jne    803273 <insert_sorted_with_merge_freeList+0x2ab>
  80325c:	83 ec 04             	sub    $0x4,%esp
  80325f:	68 4c 46 80 00       	push   $0x80464c
  803264:	68 4c 01 00 00       	push   $0x14c
  803269:	68 fb 45 80 00       	push   $0x8045fb
  80326e:	e8 3c d3 ff ff       	call   8005af <_panic>
  803273:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	89 50 04             	mov    %edx,0x4(%eax)
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 0c                	je     803295 <insert_sorted_with_merge_freeList+0x2cd>
  803289:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80328e:	8b 55 08             	mov    0x8(%ebp),%edx
  803291:	89 10                	mov    %edx,(%eax)
  803293:	eb 08                	jmp    80329d <insert_sorted_with_merge_freeList+0x2d5>
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	a3 38 51 80 00       	mov    %eax,0x805138
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8032b3:	40                   	inc    %eax
  8032b4:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032b9:	e9 53 04 00 00       	jmp    803711 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032be:	a1 38 51 80 00       	mov    0x805138,%eax
  8032c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c6:	e9 15 04 00 00       	jmp    8036e0 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	8b 50 08             	mov    0x8(%eax),%edx
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 40 08             	mov    0x8(%eax),%eax
  8032df:	39 c2                	cmp    %eax,%edx
  8032e1:	0f 86 f1 03 00 00    	jbe    8036d8 <insert_sorted_with_merge_freeList+0x710>
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	8b 50 08             	mov    0x8(%eax),%edx
  8032ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f0:	8b 40 08             	mov    0x8(%eax),%eax
  8032f3:	39 c2                	cmp    %eax,%edx
  8032f5:	0f 83 dd 03 00 00    	jae    8036d8 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fe:	8b 50 08             	mov    0x8(%eax),%edx
  803301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803304:	8b 40 0c             	mov    0xc(%eax),%eax
  803307:	01 c2                	add    %eax,%edx
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	8b 40 08             	mov    0x8(%eax),%eax
  80330f:	39 c2                	cmp    %eax,%edx
  803311:	0f 85 b9 01 00 00    	jne    8034d0 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	8b 50 08             	mov    0x8(%eax),%edx
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	8b 40 0c             	mov    0xc(%eax),%eax
  803323:	01 c2                	add    %eax,%edx
  803325:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803328:	8b 40 08             	mov    0x8(%eax),%eax
  80332b:	39 c2                	cmp    %eax,%edx
  80332d:	0f 85 0d 01 00 00    	jne    803440 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803336:	8b 50 0c             	mov    0xc(%eax),%edx
  803339:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333c:	8b 40 0c             	mov    0xc(%eax),%eax
  80333f:	01 c2                	add    %eax,%edx
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803347:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80334b:	75 17                	jne    803364 <insert_sorted_with_merge_freeList+0x39c>
  80334d:	83 ec 04             	sub    $0x4,%esp
  803350:	68 a4 46 80 00       	push   $0x8046a4
  803355:	68 5c 01 00 00       	push   $0x15c
  80335a:	68 fb 45 80 00       	push   $0x8045fb
  80335f:	e8 4b d2 ff ff       	call   8005af <_panic>
  803364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	85 c0                	test   %eax,%eax
  80336b:	74 10                	je     80337d <insert_sorted_with_merge_freeList+0x3b5>
  80336d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803370:	8b 00                	mov    (%eax),%eax
  803372:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803375:	8b 52 04             	mov    0x4(%edx),%edx
  803378:	89 50 04             	mov    %edx,0x4(%eax)
  80337b:	eb 0b                	jmp    803388 <insert_sorted_with_merge_freeList+0x3c0>
  80337d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803380:	8b 40 04             	mov    0x4(%eax),%eax
  803383:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803388:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338b:	8b 40 04             	mov    0x4(%eax),%eax
  80338e:	85 c0                	test   %eax,%eax
  803390:	74 0f                	je     8033a1 <insert_sorted_with_merge_freeList+0x3d9>
  803392:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803395:	8b 40 04             	mov    0x4(%eax),%eax
  803398:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339b:	8b 12                	mov    (%edx),%edx
  80339d:	89 10                	mov    %edx,(%eax)
  80339f:	eb 0a                	jmp    8033ab <insert_sorted_with_merge_freeList+0x3e3>
  8033a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a4:	8b 00                	mov    (%eax),%eax
  8033a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8033ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033be:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c3:	48                   	dec    %eax
  8033c4:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8033c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8033d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033e1:	75 17                	jne    8033fa <insert_sorted_with_merge_freeList+0x432>
  8033e3:	83 ec 04             	sub    $0x4,%esp
  8033e6:	68 d8 45 80 00       	push   $0x8045d8
  8033eb:	68 5f 01 00 00       	push   $0x15f
  8033f0:	68 fb 45 80 00       	push   $0x8045fb
  8033f5:	e8 b5 d1 ff ff       	call   8005af <_panic>
  8033fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803400:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803403:	89 10                	mov    %edx,(%eax)
  803405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803408:	8b 00                	mov    (%eax),%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	74 0d                	je     80341b <insert_sorted_with_merge_freeList+0x453>
  80340e:	a1 48 51 80 00       	mov    0x805148,%eax
  803413:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803416:	89 50 04             	mov    %edx,0x4(%eax)
  803419:	eb 08                	jmp    803423 <insert_sorted_with_merge_freeList+0x45b>
  80341b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803426:	a3 48 51 80 00       	mov    %eax,0x805148
  80342b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803435:	a1 54 51 80 00       	mov    0x805154,%eax
  80343a:	40                   	inc    %eax
  80343b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803443:	8b 50 0c             	mov    0xc(%eax),%edx
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	8b 40 0c             	mov    0xc(%eax),%eax
  80344c:	01 c2                	add    %eax,%edx
  80344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803451:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803468:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80346c:	75 17                	jne    803485 <insert_sorted_with_merge_freeList+0x4bd>
  80346e:	83 ec 04             	sub    $0x4,%esp
  803471:	68 d8 45 80 00       	push   $0x8045d8
  803476:	68 64 01 00 00       	push   $0x164
  80347b:	68 fb 45 80 00       	push   $0x8045fb
  803480:	e8 2a d1 ff ff       	call   8005af <_panic>
  803485:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	89 10                	mov    %edx,(%eax)
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	74 0d                	je     8034a6 <insert_sorted_with_merge_freeList+0x4de>
  803499:	a1 48 51 80 00       	mov    0x805148,%eax
  80349e:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a1:	89 50 04             	mov    %edx,0x4(%eax)
  8034a4:	eb 08                	jmp    8034ae <insert_sorted_with_merge_freeList+0x4e6>
  8034a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8034c5:	40                   	inc    %eax
  8034c6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034cb:	e9 41 02 00 00       	jmp    803711 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	8b 50 08             	mov    0x8(%eax),%edx
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034dc:	01 c2                	add    %eax,%edx
  8034de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e1:	8b 40 08             	mov    0x8(%eax),%eax
  8034e4:	39 c2                	cmp    %eax,%edx
  8034e6:	0f 85 7c 01 00 00    	jne    803668 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8034ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034f0:	74 06                	je     8034f8 <insert_sorted_with_merge_freeList+0x530>
  8034f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034f6:	75 17                	jne    80350f <insert_sorted_with_merge_freeList+0x547>
  8034f8:	83 ec 04             	sub    $0x4,%esp
  8034fb:	68 14 46 80 00       	push   $0x804614
  803500:	68 69 01 00 00       	push   $0x169
  803505:	68 fb 45 80 00       	push   $0x8045fb
  80350a:	e8 a0 d0 ff ff       	call   8005af <_panic>
  80350f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803512:	8b 50 04             	mov    0x4(%eax),%edx
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	89 50 04             	mov    %edx,0x4(%eax)
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803521:	89 10                	mov    %edx,(%eax)
  803523:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803526:	8b 40 04             	mov    0x4(%eax),%eax
  803529:	85 c0                	test   %eax,%eax
  80352b:	74 0d                	je     80353a <insert_sorted_with_merge_freeList+0x572>
  80352d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803530:	8b 40 04             	mov    0x4(%eax),%eax
  803533:	8b 55 08             	mov    0x8(%ebp),%edx
  803536:	89 10                	mov    %edx,(%eax)
  803538:	eb 08                	jmp    803542 <insert_sorted_with_merge_freeList+0x57a>
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	a3 38 51 80 00       	mov    %eax,0x805138
  803542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803545:	8b 55 08             	mov    0x8(%ebp),%edx
  803548:	89 50 04             	mov    %edx,0x4(%eax)
  80354b:	a1 44 51 80 00       	mov    0x805144,%eax
  803550:	40                   	inc    %eax
  803551:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	8b 50 0c             	mov    0xc(%eax),%edx
  80355c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355f:	8b 40 0c             	mov    0xc(%eax),%eax
  803562:	01 c2                	add    %eax,%edx
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80356a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80356e:	75 17                	jne    803587 <insert_sorted_with_merge_freeList+0x5bf>
  803570:	83 ec 04             	sub    $0x4,%esp
  803573:	68 a4 46 80 00       	push   $0x8046a4
  803578:	68 6b 01 00 00       	push   $0x16b
  80357d:	68 fb 45 80 00       	push   $0x8045fb
  803582:	e8 28 d0 ff ff       	call   8005af <_panic>
  803587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358a:	8b 00                	mov    (%eax),%eax
  80358c:	85 c0                	test   %eax,%eax
  80358e:	74 10                	je     8035a0 <insert_sorted_with_merge_freeList+0x5d8>
  803590:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803598:	8b 52 04             	mov    0x4(%edx),%edx
  80359b:	89 50 04             	mov    %edx,0x4(%eax)
  80359e:	eb 0b                	jmp    8035ab <insert_sorted_with_merge_freeList+0x5e3>
  8035a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a3:	8b 40 04             	mov    0x4(%eax),%eax
  8035a6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ae:	8b 40 04             	mov    0x4(%eax),%eax
  8035b1:	85 c0                	test   %eax,%eax
  8035b3:	74 0f                	je     8035c4 <insert_sorted_with_merge_freeList+0x5fc>
  8035b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b8:	8b 40 04             	mov    0x4(%eax),%eax
  8035bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035be:	8b 12                	mov    (%edx),%edx
  8035c0:	89 10                	mov    %edx,(%eax)
  8035c2:	eb 0a                	jmp    8035ce <insert_sorted_with_merge_freeList+0x606>
  8035c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c7:	8b 00                	mov    (%eax),%eax
  8035c9:	a3 38 51 80 00       	mov    %eax,0x805138
  8035ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8035e6:	48                   	dec    %eax
  8035e7:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8035ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8035f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803600:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803604:	75 17                	jne    80361d <insert_sorted_with_merge_freeList+0x655>
  803606:	83 ec 04             	sub    $0x4,%esp
  803609:	68 d8 45 80 00       	push   $0x8045d8
  80360e:	68 6e 01 00 00       	push   $0x16e
  803613:	68 fb 45 80 00       	push   $0x8045fb
  803618:	e8 92 cf ff ff       	call   8005af <_panic>
  80361d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803623:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803626:	89 10                	mov    %edx,(%eax)
  803628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	85 c0                	test   %eax,%eax
  80362f:	74 0d                	je     80363e <insert_sorted_with_merge_freeList+0x676>
  803631:	a1 48 51 80 00       	mov    0x805148,%eax
  803636:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803639:	89 50 04             	mov    %edx,0x4(%eax)
  80363c:	eb 08                	jmp    803646 <insert_sorted_with_merge_freeList+0x67e>
  80363e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803641:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803649:	a3 48 51 80 00       	mov    %eax,0x805148
  80364e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803651:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803658:	a1 54 51 80 00       	mov    0x805154,%eax
  80365d:	40                   	inc    %eax
  80365e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803663:	e9 a9 00 00 00       	jmp    803711 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366c:	74 06                	je     803674 <insert_sorted_with_merge_freeList+0x6ac>
  80366e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803672:	75 17                	jne    80368b <insert_sorted_with_merge_freeList+0x6c3>
  803674:	83 ec 04             	sub    $0x4,%esp
  803677:	68 70 46 80 00       	push   $0x804670
  80367c:	68 73 01 00 00       	push   $0x173
  803681:	68 fb 45 80 00       	push   $0x8045fb
  803686:	e8 24 cf ff ff       	call   8005af <_panic>
  80368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368e:	8b 10                	mov    (%eax),%edx
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
  803693:	89 10                	mov    %edx,(%eax)
  803695:	8b 45 08             	mov    0x8(%ebp),%eax
  803698:	8b 00                	mov    (%eax),%eax
  80369a:	85 c0                	test   %eax,%eax
  80369c:	74 0b                	je     8036a9 <insert_sorted_with_merge_freeList+0x6e1>
  80369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a1:	8b 00                	mov    (%eax),%eax
  8036a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a6:	89 50 04             	mov    %edx,0x4(%eax)
  8036a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8036af:	89 10                	mov    %edx,(%eax)
  8036b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	75 08                	jne    8036cb <insert_sorted_with_merge_freeList+0x703>
  8036c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8036d0:	40                   	inc    %eax
  8036d1:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8036d6:	eb 39                	jmp    803711 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8036dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e4:	74 07                	je     8036ed <insert_sorted_with_merge_freeList+0x725>
  8036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e9:	8b 00                	mov    (%eax),%eax
  8036eb:	eb 05                	jmp    8036f2 <insert_sorted_with_merge_freeList+0x72a>
  8036ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f2:	a3 40 51 80 00       	mov    %eax,0x805140
  8036f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8036fc:	85 c0                	test   %eax,%eax
  8036fe:	0f 85 c7 fb ff ff    	jne    8032cb <insert_sorted_with_merge_freeList+0x303>
  803704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803708:	0f 85 bd fb ff ff    	jne    8032cb <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80370e:	eb 01                	jmp    803711 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803710:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803711:	90                   	nop
  803712:	c9                   	leave  
  803713:	c3                   	ret    

00803714 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803714:	55                   	push   %ebp
  803715:	89 e5                	mov    %esp,%ebp
  803717:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80371a:	8b 55 08             	mov    0x8(%ebp),%edx
  80371d:	89 d0                	mov    %edx,%eax
  80371f:	c1 e0 02             	shl    $0x2,%eax
  803722:	01 d0                	add    %edx,%eax
  803724:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80372b:	01 d0                	add    %edx,%eax
  80372d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803734:	01 d0                	add    %edx,%eax
  803736:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80373d:	01 d0                	add    %edx,%eax
  80373f:	c1 e0 04             	shl    $0x4,%eax
  803742:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803745:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80374c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80374f:	83 ec 0c             	sub    $0xc,%esp
  803752:	50                   	push   %eax
  803753:	e8 26 e7 ff ff       	call   801e7e <sys_get_virtual_time>
  803758:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80375b:	eb 41                	jmp    80379e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80375d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803760:	83 ec 0c             	sub    $0xc,%esp
  803763:	50                   	push   %eax
  803764:	e8 15 e7 ff ff       	call   801e7e <sys_get_virtual_time>
  803769:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80376c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80376f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803772:	29 c2                	sub    %eax,%edx
  803774:	89 d0                	mov    %edx,%eax
  803776:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803779:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80377c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377f:	89 d1                	mov    %edx,%ecx
  803781:	29 c1                	sub    %eax,%ecx
  803783:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803789:	39 c2                	cmp    %eax,%edx
  80378b:	0f 97 c0             	seta   %al
  80378e:	0f b6 c0             	movzbl %al,%eax
  803791:	29 c1                	sub    %eax,%ecx
  803793:	89 c8                	mov    %ecx,%eax
  803795:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803798:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80379b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037a4:	72 b7                	jb     80375d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8037a6:	90                   	nop
  8037a7:	c9                   	leave  
  8037a8:	c3                   	ret    

008037a9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8037a9:	55                   	push   %ebp
  8037aa:	89 e5                	mov    %esp,%ebp
  8037ac:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8037af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8037b6:	eb 03                	jmp    8037bb <busy_wait+0x12>
  8037b8:	ff 45 fc             	incl   -0x4(%ebp)
  8037bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037c1:	72 f5                	jb     8037b8 <busy_wait+0xf>
	return i;
  8037c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8037c6:	c9                   	leave  
  8037c7:	c3                   	ret    

008037c8 <__udivdi3>:
  8037c8:	55                   	push   %ebp
  8037c9:	57                   	push   %edi
  8037ca:	56                   	push   %esi
  8037cb:	53                   	push   %ebx
  8037cc:	83 ec 1c             	sub    $0x1c,%esp
  8037cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037df:	89 ca                	mov    %ecx,%edx
  8037e1:	89 f8                	mov    %edi,%eax
  8037e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037e7:	85 f6                	test   %esi,%esi
  8037e9:	75 2d                	jne    803818 <__udivdi3+0x50>
  8037eb:	39 cf                	cmp    %ecx,%edi
  8037ed:	77 65                	ja     803854 <__udivdi3+0x8c>
  8037ef:	89 fd                	mov    %edi,%ebp
  8037f1:	85 ff                	test   %edi,%edi
  8037f3:	75 0b                	jne    803800 <__udivdi3+0x38>
  8037f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8037fa:	31 d2                	xor    %edx,%edx
  8037fc:	f7 f7                	div    %edi
  8037fe:	89 c5                	mov    %eax,%ebp
  803800:	31 d2                	xor    %edx,%edx
  803802:	89 c8                	mov    %ecx,%eax
  803804:	f7 f5                	div    %ebp
  803806:	89 c1                	mov    %eax,%ecx
  803808:	89 d8                	mov    %ebx,%eax
  80380a:	f7 f5                	div    %ebp
  80380c:	89 cf                	mov    %ecx,%edi
  80380e:	89 fa                	mov    %edi,%edx
  803810:	83 c4 1c             	add    $0x1c,%esp
  803813:	5b                   	pop    %ebx
  803814:	5e                   	pop    %esi
  803815:	5f                   	pop    %edi
  803816:	5d                   	pop    %ebp
  803817:	c3                   	ret    
  803818:	39 ce                	cmp    %ecx,%esi
  80381a:	77 28                	ja     803844 <__udivdi3+0x7c>
  80381c:	0f bd fe             	bsr    %esi,%edi
  80381f:	83 f7 1f             	xor    $0x1f,%edi
  803822:	75 40                	jne    803864 <__udivdi3+0x9c>
  803824:	39 ce                	cmp    %ecx,%esi
  803826:	72 0a                	jb     803832 <__udivdi3+0x6a>
  803828:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80382c:	0f 87 9e 00 00 00    	ja     8038d0 <__udivdi3+0x108>
  803832:	b8 01 00 00 00       	mov    $0x1,%eax
  803837:	89 fa                	mov    %edi,%edx
  803839:	83 c4 1c             	add    $0x1c,%esp
  80383c:	5b                   	pop    %ebx
  80383d:	5e                   	pop    %esi
  80383e:	5f                   	pop    %edi
  80383f:	5d                   	pop    %ebp
  803840:	c3                   	ret    
  803841:	8d 76 00             	lea    0x0(%esi),%esi
  803844:	31 ff                	xor    %edi,%edi
  803846:	31 c0                	xor    %eax,%eax
  803848:	89 fa                	mov    %edi,%edx
  80384a:	83 c4 1c             	add    $0x1c,%esp
  80384d:	5b                   	pop    %ebx
  80384e:	5e                   	pop    %esi
  80384f:	5f                   	pop    %edi
  803850:	5d                   	pop    %ebp
  803851:	c3                   	ret    
  803852:	66 90                	xchg   %ax,%ax
  803854:	89 d8                	mov    %ebx,%eax
  803856:	f7 f7                	div    %edi
  803858:	31 ff                	xor    %edi,%edi
  80385a:	89 fa                	mov    %edi,%edx
  80385c:	83 c4 1c             	add    $0x1c,%esp
  80385f:	5b                   	pop    %ebx
  803860:	5e                   	pop    %esi
  803861:	5f                   	pop    %edi
  803862:	5d                   	pop    %ebp
  803863:	c3                   	ret    
  803864:	bd 20 00 00 00       	mov    $0x20,%ebp
  803869:	89 eb                	mov    %ebp,%ebx
  80386b:	29 fb                	sub    %edi,%ebx
  80386d:	89 f9                	mov    %edi,%ecx
  80386f:	d3 e6                	shl    %cl,%esi
  803871:	89 c5                	mov    %eax,%ebp
  803873:	88 d9                	mov    %bl,%cl
  803875:	d3 ed                	shr    %cl,%ebp
  803877:	89 e9                	mov    %ebp,%ecx
  803879:	09 f1                	or     %esi,%ecx
  80387b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80387f:	89 f9                	mov    %edi,%ecx
  803881:	d3 e0                	shl    %cl,%eax
  803883:	89 c5                	mov    %eax,%ebp
  803885:	89 d6                	mov    %edx,%esi
  803887:	88 d9                	mov    %bl,%cl
  803889:	d3 ee                	shr    %cl,%esi
  80388b:	89 f9                	mov    %edi,%ecx
  80388d:	d3 e2                	shl    %cl,%edx
  80388f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803893:	88 d9                	mov    %bl,%cl
  803895:	d3 e8                	shr    %cl,%eax
  803897:	09 c2                	or     %eax,%edx
  803899:	89 d0                	mov    %edx,%eax
  80389b:	89 f2                	mov    %esi,%edx
  80389d:	f7 74 24 0c          	divl   0xc(%esp)
  8038a1:	89 d6                	mov    %edx,%esi
  8038a3:	89 c3                	mov    %eax,%ebx
  8038a5:	f7 e5                	mul    %ebp
  8038a7:	39 d6                	cmp    %edx,%esi
  8038a9:	72 19                	jb     8038c4 <__udivdi3+0xfc>
  8038ab:	74 0b                	je     8038b8 <__udivdi3+0xf0>
  8038ad:	89 d8                	mov    %ebx,%eax
  8038af:	31 ff                	xor    %edi,%edi
  8038b1:	e9 58 ff ff ff       	jmp    80380e <__udivdi3+0x46>
  8038b6:	66 90                	xchg   %ax,%ax
  8038b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038bc:	89 f9                	mov    %edi,%ecx
  8038be:	d3 e2                	shl    %cl,%edx
  8038c0:	39 c2                	cmp    %eax,%edx
  8038c2:	73 e9                	jae    8038ad <__udivdi3+0xe5>
  8038c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038c7:	31 ff                	xor    %edi,%edi
  8038c9:	e9 40 ff ff ff       	jmp    80380e <__udivdi3+0x46>
  8038ce:	66 90                	xchg   %ax,%ax
  8038d0:	31 c0                	xor    %eax,%eax
  8038d2:	e9 37 ff ff ff       	jmp    80380e <__udivdi3+0x46>
  8038d7:	90                   	nop

008038d8 <__umoddi3>:
  8038d8:	55                   	push   %ebp
  8038d9:	57                   	push   %edi
  8038da:	56                   	push   %esi
  8038db:	53                   	push   %ebx
  8038dc:	83 ec 1c             	sub    $0x1c,%esp
  8038df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038f7:	89 f3                	mov    %esi,%ebx
  8038f9:	89 fa                	mov    %edi,%edx
  8038fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038ff:	89 34 24             	mov    %esi,(%esp)
  803902:	85 c0                	test   %eax,%eax
  803904:	75 1a                	jne    803920 <__umoddi3+0x48>
  803906:	39 f7                	cmp    %esi,%edi
  803908:	0f 86 a2 00 00 00    	jbe    8039b0 <__umoddi3+0xd8>
  80390e:	89 c8                	mov    %ecx,%eax
  803910:	89 f2                	mov    %esi,%edx
  803912:	f7 f7                	div    %edi
  803914:	89 d0                	mov    %edx,%eax
  803916:	31 d2                	xor    %edx,%edx
  803918:	83 c4 1c             	add    $0x1c,%esp
  80391b:	5b                   	pop    %ebx
  80391c:	5e                   	pop    %esi
  80391d:	5f                   	pop    %edi
  80391e:	5d                   	pop    %ebp
  80391f:	c3                   	ret    
  803920:	39 f0                	cmp    %esi,%eax
  803922:	0f 87 ac 00 00 00    	ja     8039d4 <__umoddi3+0xfc>
  803928:	0f bd e8             	bsr    %eax,%ebp
  80392b:	83 f5 1f             	xor    $0x1f,%ebp
  80392e:	0f 84 ac 00 00 00    	je     8039e0 <__umoddi3+0x108>
  803934:	bf 20 00 00 00       	mov    $0x20,%edi
  803939:	29 ef                	sub    %ebp,%edi
  80393b:	89 fe                	mov    %edi,%esi
  80393d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803941:	89 e9                	mov    %ebp,%ecx
  803943:	d3 e0                	shl    %cl,%eax
  803945:	89 d7                	mov    %edx,%edi
  803947:	89 f1                	mov    %esi,%ecx
  803949:	d3 ef                	shr    %cl,%edi
  80394b:	09 c7                	or     %eax,%edi
  80394d:	89 e9                	mov    %ebp,%ecx
  80394f:	d3 e2                	shl    %cl,%edx
  803951:	89 14 24             	mov    %edx,(%esp)
  803954:	89 d8                	mov    %ebx,%eax
  803956:	d3 e0                	shl    %cl,%eax
  803958:	89 c2                	mov    %eax,%edx
  80395a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80395e:	d3 e0                	shl    %cl,%eax
  803960:	89 44 24 04          	mov    %eax,0x4(%esp)
  803964:	8b 44 24 08          	mov    0x8(%esp),%eax
  803968:	89 f1                	mov    %esi,%ecx
  80396a:	d3 e8                	shr    %cl,%eax
  80396c:	09 d0                	or     %edx,%eax
  80396e:	d3 eb                	shr    %cl,%ebx
  803970:	89 da                	mov    %ebx,%edx
  803972:	f7 f7                	div    %edi
  803974:	89 d3                	mov    %edx,%ebx
  803976:	f7 24 24             	mull   (%esp)
  803979:	89 c6                	mov    %eax,%esi
  80397b:	89 d1                	mov    %edx,%ecx
  80397d:	39 d3                	cmp    %edx,%ebx
  80397f:	0f 82 87 00 00 00    	jb     803a0c <__umoddi3+0x134>
  803985:	0f 84 91 00 00 00    	je     803a1c <__umoddi3+0x144>
  80398b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80398f:	29 f2                	sub    %esi,%edx
  803991:	19 cb                	sbb    %ecx,%ebx
  803993:	89 d8                	mov    %ebx,%eax
  803995:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803999:	d3 e0                	shl    %cl,%eax
  80399b:	89 e9                	mov    %ebp,%ecx
  80399d:	d3 ea                	shr    %cl,%edx
  80399f:	09 d0                	or     %edx,%eax
  8039a1:	89 e9                	mov    %ebp,%ecx
  8039a3:	d3 eb                	shr    %cl,%ebx
  8039a5:	89 da                	mov    %ebx,%edx
  8039a7:	83 c4 1c             	add    $0x1c,%esp
  8039aa:	5b                   	pop    %ebx
  8039ab:	5e                   	pop    %esi
  8039ac:	5f                   	pop    %edi
  8039ad:	5d                   	pop    %ebp
  8039ae:	c3                   	ret    
  8039af:	90                   	nop
  8039b0:	89 fd                	mov    %edi,%ebp
  8039b2:	85 ff                	test   %edi,%edi
  8039b4:	75 0b                	jne    8039c1 <__umoddi3+0xe9>
  8039b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039bb:	31 d2                	xor    %edx,%edx
  8039bd:	f7 f7                	div    %edi
  8039bf:	89 c5                	mov    %eax,%ebp
  8039c1:	89 f0                	mov    %esi,%eax
  8039c3:	31 d2                	xor    %edx,%edx
  8039c5:	f7 f5                	div    %ebp
  8039c7:	89 c8                	mov    %ecx,%eax
  8039c9:	f7 f5                	div    %ebp
  8039cb:	89 d0                	mov    %edx,%eax
  8039cd:	e9 44 ff ff ff       	jmp    803916 <__umoddi3+0x3e>
  8039d2:	66 90                	xchg   %ax,%ax
  8039d4:	89 c8                	mov    %ecx,%eax
  8039d6:	89 f2                	mov    %esi,%edx
  8039d8:	83 c4 1c             	add    $0x1c,%esp
  8039db:	5b                   	pop    %ebx
  8039dc:	5e                   	pop    %esi
  8039dd:	5f                   	pop    %edi
  8039de:	5d                   	pop    %ebp
  8039df:	c3                   	ret    
  8039e0:	3b 04 24             	cmp    (%esp),%eax
  8039e3:	72 06                	jb     8039eb <__umoddi3+0x113>
  8039e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039e9:	77 0f                	ja     8039fa <__umoddi3+0x122>
  8039eb:	89 f2                	mov    %esi,%edx
  8039ed:	29 f9                	sub    %edi,%ecx
  8039ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039f3:	89 14 24             	mov    %edx,(%esp)
  8039f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039fe:	8b 14 24             	mov    (%esp),%edx
  803a01:	83 c4 1c             	add    $0x1c,%esp
  803a04:	5b                   	pop    %ebx
  803a05:	5e                   	pop    %esi
  803a06:	5f                   	pop    %edi
  803a07:	5d                   	pop    %ebp
  803a08:	c3                   	ret    
  803a09:	8d 76 00             	lea    0x0(%esi),%esi
  803a0c:	2b 04 24             	sub    (%esp),%eax
  803a0f:	19 fa                	sbb    %edi,%edx
  803a11:	89 d1                	mov    %edx,%ecx
  803a13:	89 c6                	mov    %eax,%esi
  803a15:	e9 71 ff ff ff       	jmp    80398b <__umoddi3+0xb3>
  803a1a:	66 90                	xchg   %ax,%ax
  803a1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a20:	72 ea                	jb     803a0c <__umoddi3+0x134>
  803a22:	89 d9                	mov    %ebx,%ecx
  803a24:	e9 62 ff ff ff       	jmp    80398b <__umoddi3+0xb3>
