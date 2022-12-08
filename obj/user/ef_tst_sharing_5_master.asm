
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
  80008d:	68 00 39 80 00       	push   $0x803900
  800092:	6a 12                	push   $0x12
  800094:	68 1c 39 80 00       	push   $0x80391c
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 3c 39 80 00       	push   $0x80393c
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 70 39 80 00       	push   $0x803970
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 cc 39 80 00       	push   $0x8039cc
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 ff 1b 00 00       	call   801cd2 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 00 3a 80 00       	push   $0x803a00
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
  8000ff:	68 41 3a 80 00       	push   $0x803a41
  800104:	e8 74 1b 00 00       	call   801c7d <sys_create_env>
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
  800128:	68 41 3a 80 00       	push   $0x803a41
  80012d:	e8 4b 1b 00 00       	call   801c7d <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 ce 18 00 00       	call   801a0b <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 4f 3a 80 00       	push   $0x803a4f
  80014f:	e8 df 16 00 00       	call   801833 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 54 3a 80 00       	push   $0x803a54
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 74 3a 80 00       	push   $0x803a74
  80017b:	6a 26                	push   $0x26
  80017d:	68 1c 39 80 00       	push   $0x80391c
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 7c 18 00 00       	call   801a0b <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 e0 3a 80 00       	push   $0x803ae0
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 1c 39 80 00       	push   $0x80391c
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 18 1c 00 00       	call   801dc9 <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 df 1a 00 00       	call   801c9b <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 d1 1a 00 00       	call   801c9b <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 5e 3b 80 00       	push   $0x803b5e
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 e3 33 00 00       	call   8035cd <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 51 1c 00 00       	call   801e43 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 75 3b 80 00       	push   $0x803b75
  8001ff:	6a 33                	push   $0x33
  800201:	68 1c 39 80 00       	push   $0x80391c
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 95 16 00 00       	call   8018ab <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 84 3b 80 00       	push   $0x803b84
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 dd 17 00 00       	call   801a0b <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 a4 3b 80 00       	push   $0x803ba4
  800248:	6a 38                	push   $0x38
  80024a:	68 1c 39 80 00       	push   $0x80391c
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 d4 3b 80 00       	push   $0x803bd4
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 f8 3b 80 00       	push   $0x803bf8
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
  80028d:	68 28 3c 80 00       	push   $0x803c28
  800292:	e8 e6 19 00 00       	call   801c7d <sys_create_env>
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
  8002b6:	68 38 3c 80 00       	push   $0x803c38
  8002bb:	e8 bd 19 00 00       	call   801c7d <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 48 3c 80 00       	push   $0x803c48
  8002d5:	e8 59 15 00 00       	call   801833 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 4c 3c 80 00       	push   $0x803c4c
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 4f 3a 80 00       	push   $0x803a4f
  8002ff:	e8 2f 15 00 00       	call   801833 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 54 3a 80 00       	push   $0x803a54
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 aa 1a 00 00       	call   801dc9 <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 71 19 00 00       	call   801c9b <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 63 19 00 00       	call   801c9b <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 85 32 00 00       	call   8035cd <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 bb 16 00 00       	call   801a0b <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 4d 15 00 00       	call   8018ab <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 6c 3c 80 00       	push   $0x803c6c
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 2f 15 00 00       	call   8018ab <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 82 3c 80 00       	push   $0x803c82
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 77 16 00 00       	call   801a0b <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 98 3c 80 00       	push   $0x803c98
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 1c 39 80 00       	push   $0x80391c
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 6a 1a 00 00       	call   801e29 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 3d 3d 80 00       	push   $0x803d3d
  8003cb:	e8 63 14 00 00       	call   801833 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 20 19 00 00       	call   801d04 <sys_getparentenvid>
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
  8003fa:	68 4d 3d 80 00       	push   $0x803d4d
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 a5 18 00 00       	call   801cb7 <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 97 18 00 00       	call   801cb7 <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 89 18 00 00       	call   801cb7 <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 7b 18 00 00       	call   801cb7 <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 b9 18 00 00       	call   801d04 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 53 3d 80 00       	push   $0x803d53
  800453:	50                   	push   %eax
  800454:	e8 0e 14 00 00       	call   801867 <sget>
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
  800479:	e8 6d 18 00 00       	call   801ceb <sys_getenvindex>
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
  8004e4:	e8 0f 16 00 00       	call   801af8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 7c 3d 80 00       	push   $0x803d7c
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
  800514:	68 a4 3d 80 00       	push   $0x803da4
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
  800545:	68 cc 3d 80 00       	push   $0x803dcc
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 24 3e 80 00       	push   $0x803e24
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 7c 3d 80 00       	push   $0x803d7c
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 8f 15 00 00       	call   801b12 <sys_enable_interrupt>

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
  800596:	e8 1c 17 00 00       	call   801cb7 <sys_destroy_env>
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
  8005a7:	e8 71 17 00 00       	call   801d1d <sys_exit_env>
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
  8005d0:	68 38 3e 80 00       	push   $0x803e38
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 3d 3e 80 00       	push   $0x803e3d
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
  80060d:	68 59 3e 80 00       	push   $0x803e59
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
  800639:	68 5c 3e 80 00       	push   $0x803e5c
  80063e:	6a 26                	push   $0x26
  800640:	68 a8 3e 80 00       	push   $0x803ea8
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
  80070b:	68 b4 3e 80 00       	push   $0x803eb4
  800710:	6a 3a                	push   $0x3a
  800712:	68 a8 3e 80 00       	push   $0x803ea8
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
  80077b:	68 08 3f 80 00       	push   $0x803f08
  800780:	6a 44                	push   $0x44
  800782:	68 a8 3e 80 00       	push   $0x803ea8
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
  8007d5:	e8 70 11 00 00       	call   80194a <sys_cputs>
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
  80084c:	e8 f9 10 00 00       	call   80194a <sys_cputs>
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
  800896:	e8 5d 12 00 00       	call   801af8 <sys_disable_interrupt>
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
  8008b6:	e8 57 12 00 00       	call   801b12 <sys_enable_interrupt>
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
  800900:	e8 7f 2d 00 00       	call   803684 <__udivdi3>
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
  800950:	e8 3f 2e 00 00       	call   803794 <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 74 41 80 00       	add    $0x804174,%eax
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
  800aab:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
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
  800b8c:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 85 41 80 00       	push   $0x804185
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
  800bb1:	68 8e 41 80 00       	push   $0x80418e
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
  800bde:	be 91 41 80 00       	mov    $0x804191,%esi
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
  801604:	68 f0 42 80 00       	push   $0x8042f0
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
  8016d4:	e8 b5 03 00 00       	call   801a8e <sys_allocate_chunk>
  8016d9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016dc:	a1 20 51 80 00       	mov    0x805120,%eax
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	50                   	push   %eax
  8016e5:	e8 2a 0a 00 00       	call   802114 <initialize_MemBlocksList>
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
  801712:	68 15 43 80 00       	push   $0x804315
  801717:	6a 33                	push   $0x33
  801719:	68 33 43 80 00       	push   $0x804333
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
  801791:	68 40 43 80 00       	push   $0x804340
  801796:	6a 34                	push   $0x34
  801798:	68 33 43 80 00       	push   $0x804333
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
  8017ee:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017f1:	e8 f7 fd ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  8017f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017fa:	75 07                	jne    801803 <malloc+0x18>
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801801:	eb 14                	jmp    801817 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 64 43 80 00       	push   $0x804364
  80180b:	6a 46                	push   $0x46
  80180d:	68 33 43 80 00       	push   $0x804333
  801812:	e8 98 ed ff ff       	call   8005af <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80181f:	83 ec 04             	sub    $0x4,%esp
  801822:	68 8c 43 80 00       	push   $0x80438c
  801827:	6a 61                	push   $0x61
  801829:	68 33 43 80 00       	push   $0x804333
  80182e:	e8 7c ed ff ff       	call   8005af <_panic>

00801833 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 18             	sub    $0x18,%esp
  801839:	8b 45 10             	mov    0x10(%ebp),%eax
  80183c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80183f:	e8 a9 fd ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  801844:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801848:	75 07                	jne    801851 <smalloc+0x1e>
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	eb 14                	jmp    801865 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	68 b0 43 80 00       	push   $0x8043b0
  801859:	6a 76                	push   $0x76
  80185b:	68 33 43 80 00       	push   $0x804333
  801860:	e8 4a ed ff ff       	call   8005af <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80186d:	e8 7b fd ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	68 d8 43 80 00       	push   $0x8043d8
  80187a:	68 93 00 00 00       	push   $0x93
  80187f:	68 33 43 80 00       	push   $0x804333
  801884:	e8 26 ed ff ff       	call   8005af <_panic>

00801889 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80188f:	e8 59 fd ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	68 fc 43 80 00       	push   $0x8043fc
  80189c:	68 c5 00 00 00       	push   $0xc5
  8018a1:	68 33 43 80 00       	push   $0x804333
  8018a6:	e8 04 ed ff ff       	call   8005af <_panic>

008018ab <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	68 24 44 80 00       	push   $0x804424
  8018b9:	68 d9 00 00 00       	push   $0xd9
  8018be:	68 33 43 80 00       	push   $0x804333
  8018c3:	e8 e7 ec ff ff       	call   8005af <_panic>

008018c8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	68 48 44 80 00       	push   $0x804448
  8018d6:	68 e4 00 00 00       	push   $0xe4
  8018db:	68 33 43 80 00       	push   $0x804333
  8018e0:	e8 ca ec ff ff       	call   8005af <_panic>

008018e5 <shrink>:

}
void shrink(uint32 newSize)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	68 48 44 80 00       	push   $0x804448
  8018f3:	68 e9 00 00 00       	push   $0xe9
  8018f8:	68 33 43 80 00       	push   $0x804333
  8018fd:	e8 ad ec ff ff       	call   8005af <_panic>

00801902 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	68 48 44 80 00       	push   $0x804448
  801910:	68 ee 00 00 00       	push   $0xee
  801915:	68 33 43 80 00       	push   $0x804333
  80191a:	e8 90 ec ff ff       	call   8005af <_panic>

0080191f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	57                   	push   %edi
  801923:	56                   	push   %esi
  801924:	53                   	push   %ebx
  801925:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801931:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801934:	8b 7d 18             	mov    0x18(%ebp),%edi
  801937:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80193a:	cd 30                	int    $0x30
  80193c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	5b                   	pop    %ebx
  801946:	5e                   	pop    %esi
  801947:	5f                   	pop    %edi
  801948:	5d                   	pop    %ebp
  801949:	c3                   	ret    

0080194a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	8b 45 10             	mov    0x10(%ebp),%eax
  801953:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801956:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	52                   	push   %edx
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	50                   	push   %eax
  801966:	6a 00                	push   $0x0
  801968:	e8 b2 ff ff ff       	call   80191f <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	90                   	nop
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_cgetc>:

int
sys_cgetc(void)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 01                	push   $0x1
  801982:	e8 98 ff ff ff       	call   80191f <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 05                	push   $0x5
  80199f:	e8 7b ff ff ff       	call   80191f <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	56                   	push   %esi
  8019ad:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8019b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	56                   	push   %esi
  8019be:	53                   	push   %ebx
  8019bf:	51                   	push   %ecx
  8019c0:	52                   	push   %edx
  8019c1:	50                   	push   %eax
  8019c2:	6a 06                	push   $0x6
  8019c4:	e8 56 ff ff ff       	call   80191f <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5e                   	pop    %esi
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    

008019d3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	52                   	push   %edx
  8019e3:	50                   	push   %eax
  8019e4:	6a 07                	push   $0x7
  8019e6:	e8 34 ff ff ff       	call   80191f <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	ff 75 08             	pushl  0x8(%ebp)
  8019ff:	6a 08                	push   $0x8
  801a01:	e8 19 ff ff ff       	call   80191f <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 09                	push   $0x9
  801a1a:	e8 00 ff ff ff       	call   80191f <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 0a                	push   $0xa
  801a33:	e8 e7 fe ff ff       	call   80191f <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 0b                	push   $0xb
  801a4c:	e8 ce fe ff ff       	call   80191f <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	6a 0f                	push   $0xf
  801a67:	e8 b3 fe ff ff       	call   80191f <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
	return;
  801a6f:	90                   	nop
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	ff 75 08             	pushl  0x8(%ebp)
  801a81:	6a 10                	push   $0x10
  801a83:	e8 97 fe ff ff       	call   80191f <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8b:	90                   	nop
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	ff 75 10             	pushl  0x10(%ebp)
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	6a 11                	push   $0x11
  801aa0:	e8 7a fe ff ff       	call   80191f <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa8:	90                   	nop
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 0c                	push   $0xc
  801aba:	e8 60 fe ff ff       	call   80191f <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	ff 75 08             	pushl  0x8(%ebp)
  801ad2:	6a 0d                	push   $0xd
  801ad4:	e8 46 fe ff ff       	call   80191f <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 0e                	push   $0xe
  801aed:	e8 2d fe ff ff       	call   80191f <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	90                   	nop
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 13                	push   $0x13
  801b07:	e8 13 fe ff ff       	call   80191f <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 14                	push   $0x14
  801b21:	e8 f9 fd ff ff       	call   80191f <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	90                   	nop
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_cputc>:


void
sys_cputc(const char c)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 04             	sub    $0x4,%esp
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b38:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	50                   	push   %eax
  801b45:	6a 15                	push   $0x15
  801b47:	e8 d3 fd ff ff       	call   80191f <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 16                	push   $0x16
  801b61:	e8 b9 fd ff ff       	call   80191f <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	90                   	nop
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	50                   	push   %eax
  801b7c:	6a 17                	push   $0x17
  801b7e:	e8 9c fd ff ff       	call   80191f <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 1a                	push   $0x1a
  801b9b:	e8 7f fd ff ff       	call   80191f <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	52                   	push   %edx
  801bb5:	50                   	push   %eax
  801bb6:	6a 18                	push   $0x18
  801bb8:	e8 62 fd ff ff       	call   80191f <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	90                   	nop
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 19                	push   $0x19
  801bd6:	e8 44 fd ff ff       	call   80191f <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	90                   	nop
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bed:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bf0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	51                   	push   %ecx
  801bfa:	52                   	push   %edx
  801bfb:	ff 75 0c             	pushl  0xc(%ebp)
  801bfe:	50                   	push   %eax
  801bff:	6a 1b                	push   $0x1b
  801c01:	e8 19 fd ff ff       	call   80191f <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	52                   	push   %edx
  801c1b:	50                   	push   %eax
  801c1c:	6a 1c                	push   $0x1c
  801c1e:	e8 fc fc ff ff       	call   80191f <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	51                   	push   %ecx
  801c39:	52                   	push   %edx
  801c3a:	50                   	push   %eax
  801c3b:	6a 1d                	push   $0x1d
  801c3d:	e8 dd fc ff ff       	call   80191f <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	52                   	push   %edx
  801c57:	50                   	push   %eax
  801c58:	6a 1e                	push   $0x1e
  801c5a:	e8 c0 fc ff ff       	call   80191f <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 1f                	push   $0x1f
  801c73:	e8 a7 fc ff ff       	call   80191f <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	6a 00                	push   $0x0
  801c85:	ff 75 14             	pushl  0x14(%ebp)
  801c88:	ff 75 10             	pushl  0x10(%ebp)
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	50                   	push   %eax
  801c8f:	6a 20                	push   $0x20
  801c91:	e8 89 fc ff ff       	call   80191f <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	50                   	push   %eax
  801caa:	6a 21                	push   $0x21
  801cac:	e8 6e fc ff ff       	call   80191f <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	90                   	nop
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	50                   	push   %eax
  801cc6:	6a 22                	push   $0x22
  801cc8:	e8 52 fc ff ff       	call   80191f <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 02                	push   $0x2
  801ce1:	e8 39 fc ff ff       	call   80191f <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 03                	push   $0x3
  801cfa:	e8 20 fc ff ff       	call   80191f <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 04                	push   $0x4
  801d13:	e8 07 fc ff ff       	call   80191f <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_exit_env>:


void sys_exit_env(void)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 23                	push   $0x23
  801d2c:	e8 ee fb ff ff       	call   80191f <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	90                   	nop
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d40:	8d 50 04             	lea    0x4(%eax),%edx
  801d43:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	52                   	push   %edx
  801d4d:	50                   	push   %eax
  801d4e:	6a 24                	push   $0x24
  801d50:	e8 ca fb ff ff       	call   80191f <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
	return result;
  801d58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d61:	89 01                	mov    %eax,(%ecx)
  801d63:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	c9                   	leave  
  801d6a:	c2 04 00             	ret    $0x4

00801d6d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	ff 75 10             	pushl  0x10(%ebp)
  801d77:	ff 75 0c             	pushl  0xc(%ebp)
  801d7a:	ff 75 08             	pushl  0x8(%ebp)
  801d7d:	6a 12                	push   $0x12
  801d7f:	e8 9b fb ff ff       	call   80191f <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
	return ;
  801d87:	90                   	nop
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_rcr2>:
uint32 sys_rcr2()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 25                	push   $0x25
  801d99:	e8 81 fb ff ff       	call   80191f <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 04             	sub    $0x4,%esp
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801daf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	50                   	push   %eax
  801dbc:	6a 26                	push   $0x26
  801dbe:	e8 5c fb ff ff       	call   80191f <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc6:	90                   	nop
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <rsttst>:
void rsttst()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 28                	push   $0x28
  801dd8:	e8 42 fb ff ff       	call   80191f <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
	return ;
  801de0:	90                   	nop
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 04             	sub    $0x4,%esp
  801de9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801def:	8b 55 18             	mov    0x18(%ebp),%edx
  801df2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df6:	52                   	push   %edx
  801df7:	50                   	push   %eax
  801df8:	ff 75 10             	pushl  0x10(%ebp)
  801dfb:	ff 75 0c             	pushl  0xc(%ebp)
  801dfe:	ff 75 08             	pushl  0x8(%ebp)
  801e01:	6a 27                	push   $0x27
  801e03:	e8 17 fb ff ff       	call   80191f <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0b:	90                   	nop
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <chktst>:
void chktst(uint32 n)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	6a 29                	push   $0x29
  801e1e:	e8 fc fa ff ff       	call   80191f <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
	return ;
  801e26:	90                   	nop
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <inctst>:

void inctst()
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 2a                	push   $0x2a
  801e38:	e8 e2 fa ff ff       	call   80191f <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e40:	90                   	nop
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <gettst>:
uint32 gettst()
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 2b                	push   $0x2b
  801e52:	e8 c8 fa ff ff       	call   80191f <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 2c                	push   $0x2c
  801e6e:	e8 ac fa ff ff       	call   80191f <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
  801e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e79:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e7d:	75 07                	jne    801e86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e84:	eb 05                	jmp    801e8b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 2c                	push   $0x2c
  801e9f:	e8 7b fa ff ff       	call   80191f <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
  801ea7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eaa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eae:	75 07                	jne    801eb7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eb0:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb5:	eb 05                	jmp    801ebc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 2c                	push   $0x2c
  801ed0:	e8 4a fa ff ff       	call   80191f <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
  801ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801edb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801edf:	75 07                	jne    801ee8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ee1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee6:	eb 05                	jmp    801eed <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 2c                	push   $0x2c
  801f01:	e8 19 fa ff ff       	call   80191f <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
  801f09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f0c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f10:	75 07                	jne    801f19 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f12:	b8 01 00 00 00       	mov    $0x1,%eax
  801f17:	eb 05                	jmp    801f1e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	ff 75 08             	pushl  0x8(%ebp)
  801f2e:	6a 2d                	push   $0x2d
  801f30:	e8 ea f9 ff ff       	call   80191f <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
	return ;
  801f38:	90                   	nop
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	53                   	push   %ebx
  801f4e:	51                   	push   %ecx
  801f4f:	52                   	push   %edx
  801f50:	50                   	push   %eax
  801f51:	6a 2e                	push   $0x2e
  801f53:	e8 c7 f9 ff ff       	call   80191f <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	52                   	push   %edx
  801f70:	50                   	push   %eax
  801f71:	6a 2f                	push   $0x2f
  801f73:	e8 a7 f9 ff ff       	call   80191f <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f83:	83 ec 0c             	sub    $0xc,%esp
  801f86:	68 58 44 80 00       	push   $0x804458
  801f8b:	e8 d3 e8 ff ff       	call   800863 <cprintf>
  801f90:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	68 84 44 80 00       	push   $0x804484
  801fa2:	e8 bc e8 ff ff       	call   800863 <cprintf>
  801fa7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801faa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fae:	a1 38 51 80 00       	mov    0x805138,%eax
  801fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb6:	eb 56                	jmp    80200e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fbc:	74 1c                	je     801fda <print_mem_block_lists+0x5d>
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	8b 50 08             	mov    0x8(%eax),%edx
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc7:	8b 48 08             	mov    0x8(%eax),%ecx
  801fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcd:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd0:	01 c8                	add    %ecx,%eax
  801fd2:	39 c2                	cmp    %eax,%edx
  801fd4:	73 04                	jae    801fda <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fd6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 50 08             	mov    0x8(%eax),%edx
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe6:	01 c2                	add    %eax,%edx
  801fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801feb:	8b 40 08             	mov    0x8(%eax),%eax
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	52                   	push   %edx
  801ff2:	50                   	push   %eax
  801ff3:	68 99 44 80 00       	push   $0x804499
  801ff8:	e8 66 e8 ff ff       	call   800863 <cprintf>
  801ffd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802003:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802006:	a1 40 51 80 00       	mov    0x805140,%eax
  80200b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802012:	74 07                	je     80201b <print_mem_block_lists+0x9e>
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	8b 00                	mov    (%eax),%eax
  802019:	eb 05                	jmp    802020 <print_mem_block_lists+0xa3>
  80201b:	b8 00 00 00 00       	mov    $0x0,%eax
  802020:	a3 40 51 80 00       	mov    %eax,0x805140
  802025:	a1 40 51 80 00       	mov    0x805140,%eax
  80202a:	85 c0                	test   %eax,%eax
  80202c:	75 8a                	jne    801fb8 <print_mem_block_lists+0x3b>
  80202e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802032:	75 84                	jne    801fb8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802034:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802038:	75 10                	jne    80204a <print_mem_block_lists+0xcd>
  80203a:	83 ec 0c             	sub    $0xc,%esp
  80203d:	68 a8 44 80 00       	push   $0x8044a8
  802042:	e8 1c e8 ff ff       	call   800863 <cprintf>
  802047:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80204a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	68 cc 44 80 00       	push   $0x8044cc
  802059:	e8 05 e8 ff ff       	call   800863 <cprintf>
  80205e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802061:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802065:	a1 40 50 80 00       	mov    0x805040,%eax
  80206a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80206d:	eb 56                	jmp    8020c5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80206f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802073:	74 1c                	je     802091 <print_mem_block_lists+0x114>
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	8b 50 08             	mov    0x8(%eax),%edx
  80207b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207e:	8b 48 08             	mov    0x8(%eax),%ecx
  802081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802084:	8b 40 0c             	mov    0xc(%eax),%eax
  802087:	01 c8                	add    %ecx,%eax
  802089:	39 c2                	cmp    %eax,%edx
  80208b:	73 04                	jae    802091 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80208d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	8b 50 08             	mov    0x8(%eax),%edx
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	8b 40 0c             	mov    0xc(%eax),%eax
  80209d:	01 c2                	add    %eax,%edx
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	8b 40 08             	mov    0x8(%eax),%eax
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	68 99 44 80 00       	push   $0x804499
  8020af:	e8 af e7 ff ff       	call   800863 <cprintf>
  8020b4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020bd:	a1 48 50 80 00       	mov    0x805048,%eax
  8020c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c9:	74 07                	je     8020d2 <print_mem_block_lists+0x155>
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	8b 00                	mov    (%eax),%eax
  8020d0:	eb 05                	jmp    8020d7 <print_mem_block_lists+0x15a>
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d7:	a3 48 50 80 00       	mov    %eax,0x805048
  8020dc:	a1 48 50 80 00       	mov    0x805048,%eax
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	75 8a                	jne    80206f <print_mem_block_lists+0xf2>
  8020e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e9:	75 84                	jne    80206f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020eb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ef:	75 10                	jne    802101 <print_mem_block_lists+0x184>
  8020f1:	83 ec 0c             	sub    $0xc,%esp
  8020f4:	68 e4 44 80 00       	push   $0x8044e4
  8020f9:	e8 65 e7 ff ff       	call   800863 <cprintf>
  8020fe:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802101:	83 ec 0c             	sub    $0xc,%esp
  802104:	68 58 44 80 00       	push   $0x804458
  802109:	e8 55 e7 ff ff       	call   800863 <cprintf>
  80210e:	83 c4 10             	add    $0x10,%esp

}
  802111:	90                   	nop
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80211a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802121:	00 00 00 
  802124:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80212b:	00 00 00 
  80212e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802135:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802138:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80213f:	e9 9e 00 00 00       	jmp    8021e2 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802144:	a1 50 50 80 00       	mov    0x805050,%eax
  802149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214c:	c1 e2 04             	shl    $0x4,%edx
  80214f:	01 d0                	add    %edx,%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	75 14                	jne    802169 <initialize_MemBlocksList+0x55>
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	68 0c 45 80 00       	push   $0x80450c
  80215d:	6a 46                	push   $0x46
  80215f:	68 2f 45 80 00       	push   $0x80452f
  802164:	e8 46 e4 ff ff       	call   8005af <_panic>
  802169:	a1 50 50 80 00       	mov    0x805050,%eax
  80216e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802171:	c1 e2 04             	shl    $0x4,%edx
  802174:	01 d0                	add    %edx,%eax
  802176:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80217c:	89 10                	mov    %edx,(%eax)
  80217e:	8b 00                	mov    (%eax),%eax
  802180:	85 c0                	test   %eax,%eax
  802182:	74 18                	je     80219c <initialize_MemBlocksList+0x88>
  802184:	a1 48 51 80 00       	mov    0x805148,%eax
  802189:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80218f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802192:	c1 e1 04             	shl    $0x4,%ecx
  802195:	01 ca                	add    %ecx,%edx
  802197:	89 50 04             	mov    %edx,0x4(%eax)
  80219a:	eb 12                	jmp    8021ae <initialize_MemBlocksList+0x9a>
  80219c:	a1 50 50 80 00       	mov    0x805050,%eax
  8021a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a4:	c1 e2 04             	shl    $0x4,%edx
  8021a7:	01 d0                	add    %edx,%eax
  8021a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021ae:	a1 50 50 80 00       	mov    0x805050,%eax
  8021b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b6:	c1 e2 04             	shl    $0x4,%edx
  8021b9:	01 d0                	add    %edx,%eax
  8021bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8021c0:	a1 50 50 80 00       	mov    0x805050,%eax
  8021c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c8:	c1 e2 04             	shl    $0x4,%edx
  8021cb:	01 d0                	add    %edx,%eax
  8021cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8021d9:	40                   	inc    %eax
  8021da:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021df:	ff 45 f4             	incl   -0xc(%ebp)
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021e8:	0f 82 56 ff ff ff    	jb     802144 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021ee:	90                   	nop
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	8b 00                	mov    (%eax),%eax
  8021fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ff:	eb 19                	jmp    80221a <find_block+0x29>
	{
		if(va==point->sva)
  802201:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802204:	8b 40 08             	mov    0x8(%eax),%eax
  802207:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80220a:	75 05                	jne    802211 <find_block+0x20>
		   return point;
  80220c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220f:	eb 36                	jmp    802247 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	8b 40 08             	mov    0x8(%eax),%eax
  802217:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80221a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80221e:	74 07                	je     802227 <find_block+0x36>
  802220:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	eb 05                	jmp    80222c <find_block+0x3b>
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
  80222c:	8b 55 08             	mov    0x8(%ebp),%edx
  80222f:	89 42 08             	mov    %eax,0x8(%edx)
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	8b 40 08             	mov    0x8(%eax),%eax
  802238:	85 c0                	test   %eax,%eax
  80223a:	75 c5                	jne    802201 <find_block+0x10>
  80223c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802240:	75 bf                	jne    802201 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802242:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80224f:	a1 40 50 80 00       	mov    0x805040,%eax
  802254:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802257:	a1 44 50 80 00       	mov    0x805044,%eax
  80225c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80225f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802262:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802265:	74 24                	je     80228b <insert_sorted_allocList+0x42>
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	8b 50 08             	mov    0x8(%eax),%edx
  80226d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802270:	8b 40 08             	mov    0x8(%eax),%eax
  802273:	39 c2                	cmp    %eax,%edx
  802275:	76 14                	jbe    80228b <insert_sorted_allocList+0x42>
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	8b 50 08             	mov    0x8(%eax),%edx
  80227d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802280:	8b 40 08             	mov    0x8(%eax),%eax
  802283:	39 c2                	cmp    %eax,%edx
  802285:	0f 82 60 01 00 00    	jb     8023eb <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80228b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228f:	75 65                	jne    8022f6 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802291:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802295:	75 14                	jne    8022ab <insert_sorted_allocList+0x62>
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	68 0c 45 80 00       	push   $0x80450c
  80229f:	6a 6b                	push   $0x6b
  8022a1:	68 2f 45 80 00       	push   $0x80452f
  8022a6:	e8 04 e3 ff ff       	call   8005af <_panic>
  8022ab:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	89 10                	mov    %edx,(%eax)
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8b 00                	mov    (%eax),%eax
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	74 0d                	je     8022cc <insert_sorted_allocList+0x83>
  8022bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8022c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ca:	eb 08                	jmp    8022d4 <insert_sorted_allocList+0x8b>
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 40 50 80 00       	mov    %eax,0x805040
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022eb:	40                   	inc    %eax
  8022ec:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022f1:	e9 dc 01 00 00       	jmp    8024d2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	8b 50 08             	mov    0x8(%eax),%edx
  8022fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ff:	8b 40 08             	mov    0x8(%eax),%eax
  802302:	39 c2                	cmp    %eax,%edx
  802304:	77 6c                	ja     802372 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802306:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80230a:	74 06                	je     802312 <insert_sorted_allocList+0xc9>
  80230c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802310:	75 14                	jne    802326 <insert_sorted_allocList+0xdd>
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	68 48 45 80 00       	push   $0x804548
  80231a:	6a 6f                	push   $0x6f
  80231c:	68 2f 45 80 00       	push   $0x80452f
  802321:	e8 89 e2 ff ff       	call   8005af <_panic>
  802326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802329:	8b 50 04             	mov    0x4(%eax),%edx
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	89 50 04             	mov    %edx,0x4(%eax)
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802338:	89 10                	mov    %edx,(%eax)
  80233a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233d:	8b 40 04             	mov    0x4(%eax),%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	74 0d                	je     802351 <insert_sorted_allocList+0x108>
  802344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802347:	8b 40 04             	mov    0x4(%eax),%eax
  80234a:	8b 55 08             	mov    0x8(%ebp),%edx
  80234d:	89 10                	mov    %edx,(%eax)
  80234f:	eb 08                	jmp    802359 <insert_sorted_allocList+0x110>
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	a3 40 50 80 00       	mov    %eax,0x805040
  802359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235c:	8b 55 08             	mov    0x8(%ebp),%edx
  80235f:	89 50 04             	mov    %edx,0x4(%eax)
  802362:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802367:	40                   	inc    %eax
  802368:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80236d:	e9 60 01 00 00       	jmp    8024d2 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	8b 50 08             	mov    0x8(%eax),%edx
  802378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237b:	8b 40 08             	mov    0x8(%eax),%eax
  80237e:	39 c2                	cmp    %eax,%edx
  802380:	0f 82 4c 01 00 00    	jb     8024d2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238a:	75 14                	jne    8023a0 <insert_sorted_allocList+0x157>
  80238c:	83 ec 04             	sub    $0x4,%esp
  80238f:	68 80 45 80 00       	push   $0x804580
  802394:	6a 73                	push   $0x73
  802396:	68 2f 45 80 00       	push   $0x80452f
  80239b:	e8 0f e2 ff ff       	call   8005af <_panic>
  8023a0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	89 50 04             	mov    %edx,0x4(%eax)
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	8b 40 04             	mov    0x4(%eax),%eax
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	74 0c                	je     8023c2 <insert_sorted_allocList+0x179>
  8023b6:	a1 44 50 80 00       	mov    0x805044,%eax
  8023bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8023be:	89 10                	mov    %edx,(%eax)
  8023c0:	eb 08                	jmp    8023ca <insert_sorted_allocList+0x181>
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	a3 40 50 80 00       	mov    %eax,0x805040
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	a3 44 50 80 00       	mov    %eax,0x805044
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023db:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023e0:	40                   	inc    %eax
  8023e1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023e6:	e9 e7 00 00 00       	jmp    8024d2 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023f8:	a1 40 50 80 00       	mov    0x805040,%eax
  8023fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802400:	e9 9d 00 00 00       	jmp    8024a2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	8b 50 08             	mov    0x8(%eax),%edx
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 40 08             	mov    0x8(%eax),%eax
  802419:	39 c2                	cmp    %eax,%edx
  80241b:	76 7d                	jbe    80249a <insert_sorted_allocList+0x251>
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	8b 50 08             	mov    0x8(%eax),%edx
  802423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802426:	8b 40 08             	mov    0x8(%eax),%eax
  802429:	39 c2                	cmp    %eax,%edx
  80242b:	73 6d                	jae    80249a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80242d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802431:	74 06                	je     802439 <insert_sorted_allocList+0x1f0>
  802433:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802437:	75 14                	jne    80244d <insert_sorted_allocList+0x204>
  802439:	83 ec 04             	sub    $0x4,%esp
  80243c:	68 a4 45 80 00       	push   $0x8045a4
  802441:	6a 7f                	push   $0x7f
  802443:	68 2f 45 80 00       	push   $0x80452f
  802448:	e8 62 e1 ff ff       	call   8005af <_panic>
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 10                	mov    (%eax),%edx
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	89 10                	mov    %edx,(%eax)
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	74 0b                	je     80246b <insert_sorted_allocList+0x222>
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 00                	mov    (%eax),%eax
  802465:	8b 55 08             	mov    0x8(%ebp),%edx
  802468:	89 50 04             	mov    %edx,0x4(%eax)
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 55 08             	mov    0x8(%ebp),%edx
  802471:	89 10                	mov    %edx,(%eax)
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802479:	89 50 04             	mov    %edx,0x4(%eax)
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	75 08                	jne    80248d <insert_sorted_allocList+0x244>
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	a3 44 50 80 00       	mov    %eax,0x805044
  80248d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802492:	40                   	inc    %eax
  802493:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802498:	eb 39                	jmp    8024d3 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80249a:	a1 48 50 80 00       	mov    0x805048,%eax
  80249f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a6:	74 07                	je     8024af <insert_sorted_allocList+0x266>
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	eb 05                	jmp    8024b4 <insert_sorted_allocList+0x26b>
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	a3 48 50 80 00       	mov    %eax,0x805048
  8024b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	0f 85 3f ff ff ff    	jne    802405 <insert_sorted_allocList+0x1bc>
  8024c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ca:	0f 85 35 ff ff ff    	jne    802405 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024d0:	eb 01                	jmp    8024d3 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024d2:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024d3:	90                   	nop
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8024e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e4:	e9 85 01 00 00       	jmp    80266e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f2:	0f 82 6e 01 00 00    	jb     802666 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802501:	0f 85 8a 00 00 00    	jne    802591 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802507:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250b:	75 17                	jne    802524 <alloc_block_FF+0x4e>
  80250d:	83 ec 04             	sub    $0x4,%esp
  802510:	68 d8 45 80 00       	push   $0x8045d8
  802515:	68 93 00 00 00       	push   $0x93
  80251a:	68 2f 45 80 00       	push   $0x80452f
  80251f:	e8 8b e0 ff ff       	call   8005af <_panic>
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	74 10                	je     80253d <alloc_block_FF+0x67>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802535:	8b 52 04             	mov    0x4(%edx),%edx
  802538:	89 50 04             	mov    %edx,0x4(%eax)
  80253b:	eb 0b                	jmp    802548 <alloc_block_FF+0x72>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	85 c0                	test   %eax,%eax
  802550:	74 0f                	je     802561 <alloc_block_FF+0x8b>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 04             	mov    0x4(%eax),%eax
  802558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255b:	8b 12                	mov    (%edx),%edx
  80255d:	89 10                	mov    %edx,(%eax)
  80255f:	eb 0a                	jmp    80256b <alloc_block_FF+0x95>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	a3 38 51 80 00       	mov    %eax,0x805138
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257e:	a1 44 51 80 00       	mov    0x805144,%eax
  802583:	48                   	dec    %eax
  802584:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	e9 10 01 00 00       	jmp    8026a1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 40 0c             	mov    0xc(%eax),%eax
  802597:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259a:	0f 86 c6 00 00 00    	jbe    802666 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8025a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 50 08             	mov    0x8(%eax),%edx
  8025ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ba:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c1:	75 17                	jne    8025da <alloc_block_FF+0x104>
  8025c3:	83 ec 04             	sub    $0x4,%esp
  8025c6:	68 d8 45 80 00       	push   $0x8045d8
  8025cb:	68 9b 00 00 00       	push   $0x9b
  8025d0:	68 2f 45 80 00       	push   $0x80452f
  8025d5:	e8 d5 df ff ff       	call   8005af <_panic>
  8025da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	74 10                	je     8025f3 <alloc_block_FF+0x11d>
  8025e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025eb:	8b 52 04             	mov    0x4(%edx),%edx
  8025ee:	89 50 04             	mov    %edx,0x4(%eax)
  8025f1:	eb 0b                	jmp    8025fe <alloc_block_FF+0x128>
  8025f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 0f                	je     802617 <alloc_block_FF+0x141>
  802608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260b:	8b 40 04             	mov    0x4(%eax),%eax
  80260e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802611:	8b 12                	mov    (%edx),%edx
  802613:	89 10                	mov    %edx,(%eax)
  802615:	eb 0a                	jmp    802621 <alloc_block_FF+0x14b>
  802617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	a3 48 51 80 00       	mov    %eax,0x805148
  802621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802624:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802634:	a1 54 51 80 00       	mov    0x805154,%eax
  802639:	48                   	dec    %eax
  80263a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 50 08             	mov    0x8(%eax),%edx
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	01 c2                	add    %eax,%edx
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 40 0c             	mov    0xc(%eax),%eax
  802656:	2b 45 08             	sub    0x8(%ebp),%eax
  802659:	89 c2                	mov    %eax,%edx
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802664:	eb 3b                	jmp    8026a1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802666:	a1 40 51 80 00       	mov    0x805140,%eax
  80266b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	74 07                	je     80267b <alloc_block_FF+0x1a5>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	eb 05                	jmp    802680 <alloc_block_FF+0x1aa>
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	a3 40 51 80 00       	mov    %eax,0x805140
  802685:	a1 40 51 80 00       	mov    0x805140,%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	0f 85 57 fe ff ff    	jne    8024e9 <alloc_block_FF+0x13>
  802692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802696:	0f 85 4d fe ff ff    	jne    8024e9 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
  8026a6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026b0:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b8:	e9 df 00 00 00       	jmp    80279c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c6:	0f 82 c8 00 00 00    	jb     802794 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d5:	0f 85 8a 00 00 00    	jne    802765 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026df:	75 17                	jne    8026f8 <alloc_block_BF+0x55>
  8026e1:	83 ec 04             	sub    $0x4,%esp
  8026e4:	68 d8 45 80 00       	push   $0x8045d8
  8026e9:	68 b7 00 00 00       	push   $0xb7
  8026ee:	68 2f 45 80 00       	push   $0x80452f
  8026f3:	e8 b7 de ff ff       	call   8005af <_panic>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	74 10                	je     802711 <alloc_block_BF+0x6e>
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802709:	8b 52 04             	mov    0x4(%edx),%edx
  80270c:	89 50 04             	mov    %edx,0x4(%eax)
  80270f:	eb 0b                	jmp    80271c <alloc_block_BF+0x79>
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	74 0f                	je     802735 <alloc_block_BF+0x92>
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 04             	mov    0x4(%eax),%eax
  80272c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272f:	8b 12                	mov    (%edx),%edx
  802731:	89 10                	mov    %edx,(%eax)
  802733:	eb 0a                	jmp    80273f <alloc_block_BF+0x9c>
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	a3 38 51 80 00       	mov    %eax,0x805138
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802752:	a1 44 51 80 00       	mov    0x805144,%eax
  802757:	48                   	dec    %eax
  802758:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	e9 4d 01 00 00       	jmp    8028b2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 40 0c             	mov    0xc(%eax),%eax
  80276b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80276e:	76 24                	jbe    802794 <alloc_block_BF+0xf1>
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 0c             	mov    0xc(%eax),%eax
  802776:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802779:	73 19                	jae    802794 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80277b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 40 0c             	mov    0xc(%eax),%eax
  802788:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 08             	mov    0x8(%eax),%eax
  802791:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802794:	a1 40 51 80 00       	mov    0x805140,%eax
  802799:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a0:	74 07                	je     8027a9 <alloc_block_BF+0x106>
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 00                	mov    (%eax),%eax
  8027a7:	eb 05                	jmp    8027ae <alloc_block_BF+0x10b>
  8027a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ae:	a3 40 51 80 00       	mov    %eax,0x805140
  8027b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	0f 85 fd fe ff ff    	jne    8026bd <alloc_block_BF+0x1a>
  8027c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c4:	0f 85 f3 fe ff ff    	jne    8026bd <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027ce:	0f 84 d9 00 00 00    	je     8028ad <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8027d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e2:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027eb:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027f2:	75 17                	jne    80280b <alloc_block_BF+0x168>
  8027f4:	83 ec 04             	sub    $0x4,%esp
  8027f7:	68 d8 45 80 00       	push   $0x8045d8
  8027fc:	68 c7 00 00 00       	push   $0xc7
  802801:	68 2f 45 80 00       	push   $0x80452f
  802806:	e8 a4 dd ff ff       	call   8005af <_panic>
  80280b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	85 c0                	test   %eax,%eax
  802812:	74 10                	je     802824 <alloc_block_BF+0x181>
  802814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80281c:	8b 52 04             	mov    0x4(%edx),%edx
  80281f:	89 50 04             	mov    %edx,0x4(%eax)
  802822:	eb 0b                	jmp    80282f <alloc_block_BF+0x18c>
  802824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802827:	8b 40 04             	mov    0x4(%eax),%eax
  80282a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80282f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802832:	8b 40 04             	mov    0x4(%eax),%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	74 0f                	je     802848 <alloc_block_BF+0x1a5>
  802839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802842:	8b 12                	mov    (%edx),%edx
  802844:	89 10                	mov    %edx,(%eax)
  802846:	eb 0a                	jmp    802852 <alloc_block_BF+0x1af>
  802848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	a3 48 51 80 00       	mov    %eax,0x805148
  802852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802855:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802865:	a1 54 51 80 00       	mov    0x805154,%eax
  80286a:	48                   	dec    %eax
  80286b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802870:	83 ec 08             	sub    $0x8,%esp
  802873:	ff 75 ec             	pushl  -0x14(%ebp)
  802876:	68 38 51 80 00       	push   $0x805138
  80287b:	e8 71 f9 ff ff       	call   8021f1 <find_block>
  802880:	83 c4 10             	add    $0x10,%esp
  802883:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802886:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802889:	8b 50 08             	mov    0x8(%eax),%edx
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	01 c2                	add    %eax,%edx
  802891:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802894:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289a:	8b 40 0c             	mov    0xc(%eax),%eax
  80289d:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a0:	89 c2                	mov    %eax,%edx
  8028a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ab:	eb 05                	jmp    8028b2 <alloc_block_BF+0x20f>
	}
	return NULL;
  8028ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028ba:	a1 28 50 80 00       	mov    0x805028,%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	0f 85 de 01 00 00    	jne    802aa5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8028cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cf:	e9 9e 01 00 00       	jmp    802a72 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028dd:	0f 82 87 01 00 00    	jb     802a6a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ec:	0f 85 95 00 00 00    	jne    802987 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f6:	75 17                	jne    80290f <alloc_block_NF+0x5b>
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	68 d8 45 80 00       	push   $0x8045d8
  802900:	68 e0 00 00 00       	push   $0xe0
  802905:	68 2f 45 80 00       	push   $0x80452f
  80290a:	e8 a0 dc ff ff       	call   8005af <_panic>
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	74 10                	je     802928 <alloc_block_NF+0x74>
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802920:	8b 52 04             	mov    0x4(%edx),%edx
  802923:	89 50 04             	mov    %edx,0x4(%eax)
  802926:	eb 0b                	jmp    802933 <alloc_block_NF+0x7f>
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	74 0f                	je     80294c <alloc_block_NF+0x98>
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 40 04             	mov    0x4(%eax),%eax
  802943:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802946:	8b 12                	mov    (%edx),%edx
  802948:	89 10                	mov    %edx,(%eax)
  80294a:	eb 0a                	jmp    802956 <alloc_block_NF+0xa2>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	a3 38 51 80 00       	mov    %eax,0x805138
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802969:	a1 44 51 80 00       	mov    0x805144,%eax
  80296e:	48                   	dec    %eax
  80296f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 40 08             	mov    0x8(%eax),%eax
  80297a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	e9 f8 04 00 00       	jmp    802e7f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 40 0c             	mov    0xc(%eax),%eax
  80298d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802990:	0f 86 d4 00 00 00    	jbe    802a6a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802996:	a1 48 51 80 00       	mov    0x805148,%eax
  80299b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 50 08             	mov    0x8(%eax),%edx
  8029a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029b7:	75 17                	jne    8029d0 <alloc_block_NF+0x11c>
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	68 d8 45 80 00       	push   $0x8045d8
  8029c1:	68 e9 00 00 00       	push   $0xe9
  8029c6:	68 2f 45 80 00       	push   $0x80452f
  8029cb:	e8 df db ff ff       	call   8005af <_panic>
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 10                	je     8029e9 <alloc_block_NF+0x135>
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e1:	8b 52 04             	mov    0x4(%edx),%edx
  8029e4:	89 50 04             	mov    %edx,0x4(%eax)
  8029e7:	eb 0b                	jmp    8029f4 <alloc_block_NF+0x140>
  8029e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	74 0f                	je     802a0d <alloc_block_NF+0x159>
  8029fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a01:	8b 40 04             	mov    0x4(%eax),%eax
  802a04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a07:	8b 12                	mov    (%edx),%edx
  802a09:	89 10                	mov    %edx,(%eax)
  802a0b:	eb 0a                	jmp    802a17 <alloc_block_NF+0x163>
  802a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	a3 48 51 80 00       	mov    %eax,0x805148
  802a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2a:	a1 54 51 80 00       	mov    0x805154,%eax
  802a2f:	48                   	dec    %eax
  802a30:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a38:	8b 40 08             	mov    0x8(%eax),%eax
  802a3b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 50 08             	mov    0x8(%eax),%edx
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	01 c2                	add    %eax,%edx
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 40 0c             	mov    0xc(%eax),%eax
  802a57:	2b 45 08             	sub    0x8(%ebp),%eax
  802a5a:	89 c2                	mov    %eax,%edx
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a65:	e9 15 04 00 00       	jmp    802e7f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a6a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a76:	74 07                	je     802a7f <alloc_block_NF+0x1cb>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	eb 05                	jmp    802a84 <alloc_block_NF+0x1d0>
  802a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a84:	a3 40 51 80 00       	mov    %eax,0x805140
  802a89:	a1 40 51 80 00       	mov    0x805140,%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	0f 85 3e fe ff ff    	jne    8028d4 <alloc_block_NF+0x20>
  802a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9a:	0f 85 34 fe ff ff    	jne    8028d4 <alloc_block_NF+0x20>
  802aa0:	e9 d5 03 00 00       	jmp    802e7a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa5:	a1 38 51 80 00       	mov    0x805138,%eax
  802aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aad:	e9 b1 01 00 00       	jmp    802c63 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 50 08             	mov    0x8(%eax),%edx
  802ab8:	a1 28 50 80 00       	mov    0x805028,%eax
  802abd:	39 c2                	cmp    %eax,%edx
  802abf:	0f 82 96 01 00 00    	jb     802c5b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  802acb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ace:	0f 82 87 01 00 00    	jb     802c5b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 40 0c             	mov    0xc(%eax),%eax
  802ada:	3b 45 08             	cmp    0x8(%ebp),%eax
  802add:	0f 85 95 00 00 00    	jne    802b78 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae7:	75 17                	jne    802b00 <alloc_block_NF+0x24c>
  802ae9:	83 ec 04             	sub    $0x4,%esp
  802aec:	68 d8 45 80 00       	push   $0x8045d8
  802af1:	68 fc 00 00 00       	push   $0xfc
  802af6:	68 2f 45 80 00       	push   $0x80452f
  802afb:	e8 af da ff ff       	call   8005af <_panic>
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	85 c0                	test   %eax,%eax
  802b07:	74 10                	je     802b19 <alloc_block_NF+0x265>
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b11:	8b 52 04             	mov    0x4(%edx),%edx
  802b14:	89 50 04             	mov    %edx,0x4(%eax)
  802b17:	eb 0b                	jmp    802b24 <alloc_block_NF+0x270>
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 40 04             	mov    0x4(%eax),%eax
  802b1f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 04             	mov    0x4(%eax),%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	74 0f                	je     802b3d <alloc_block_NF+0x289>
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 40 04             	mov    0x4(%eax),%eax
  802b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b37:	8b 12                	mov    (%edx),%edx
  802b39:	89 10                	mov    %edx,(%eax)
  802b3b:	eb 0a                	jmp    802b47 <alloc_block_NF+0x293>
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	a3 38 51 80 00       	mov    %eax,0x805138
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5a:	a1 44 51 80 00       	mov    0x805144,%eax
  802b5f:	48                   	dec    %eax
  802b60:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 40 08             	mov    0x8(%eax),%eax
  802b6b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	e9 07 03 00 00       	jmp    802e7f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b81:	0f 86 d4 00 00 00    	jbe    802c5b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b87:	a1 48 51 80 00       	mov    0x805148,%eax
  802b8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 50 08             	mov    0x8(%eax),%edx
  802b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b98:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ba4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ba8:	75 17                	jne    802bc1 <alloc_block_NF+0x30d>
  802baa:	83 ec 04             	sub    $0x4,%esp
  802bad:	68 d8 45 80 00       	push   $0x8045d8
  802bb2:	68 04 01 00 00       	push   $0x104
  802bb7:	68 2f 45 80 00       	push   $0x80452f
  802bbc:	e8 ee d9 ff ff       	call   8005af <_panic>
  802bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 10                	je     802bda <alloc_block_NF+0x326>
  802bca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bd2:	8b 52 04             	mov    0x4(%edx),%edx
  802bd5:	89 50 04             	mov    %edx,0x4(%eax)
  802bd8:	eb 0b                	jmp    802be5 <alloc_block_NF+0x331>
  802bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdd:	8b 40 04             	mov    0x4(%eax),%eax
  802be0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 0f                	je     802bfe <alloc_block_NF+0x34a>
  802bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf2:	8b 40 04             	mov    0x4(%eax),%eax
  802bf5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf8:	8b 12                	mov    (%edx),%edx
  802bfa:	89 10                	mov    %edx,(%eax)
  802bfc:	eb 0a                	jmp    802c08 <alloc_block_NF+0x354>
  802bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	a3 48 51 80 00       	mov    %eax,0x805148
  802c08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1b:	a1 54 51 80 00       	mov    0x805154,%eax
  802c20:	48                   	dec    %eax
  802c21:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c29:	8b 40 08             	mov    0x8(%eax),%eax
  802c2c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 50 08             	mov    0x8(%eax),%edx
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	01 c2                	add    %eax,%edx
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 40 0c             	mov    0xc(%eax),%eax
  802c48:	2b 45 08             	sub    0x8(%ebp),%eax
  802c4b:	89 c2                	mov    %eax,%edx
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c56:	e9 24 02 00 00       	jmp    802e7f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c67:	74 07                	je     802c70 <alloc_block_NF+0x3bc>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	eb 05                	jmp    802c75 <alloc_block_NF+0x3c1>
  802c70:	b8 00 00 00 00       	mov    $0x0,%eax
  802c75:	a3 40 51 80 00       	mov    %eax,0x805140
  802c7a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	0f 85 2b fe ff ff    	jne    802ab2 <alloc_block_NF+0x1fe>
  802c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8b:	0f 85 21 fe ff ff    	jne    802ab2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c91:	a1 38 51 80 00       	mov    0x805138,%eax
  802c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c99:	e9 ae 01 00 00       	jmp    802e4c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 50 08             	mov    0x8(%eax),%edx
  802ca4:	a1 28 50 80 00       	mov    0x805028,%eax
  802ca9:	39 c2                	cmp    %eax,%edx
  802cab:	0f 83 93 01 00 00    	jae    802e44 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cba:	0f 82 84 01 00 00    	jb     802e44 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc9:	0f 85 95 00 00 00    	jne    802d64 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd3:	75 17                	jne    802cec <alloc_block_NF+0x438>
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	68 d8 45 80 00       	push   $0x8045d8
  802cdd:	68 14 01 00 00       	push   $0x114
  802ce2:	68 2f 45 80 00       	push   $0x80452f
  802ce7:	e8 c3 d8 ff ff       	call   8005af <_panic>
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 10                	je     802d05 <alloc_block_NF+0x451>
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfd:	8b 52 04             	mov    0x4(%edx),%edx
  802d00:	89 50 04             	mov    %edx,0x4(%eax)
  802d03:	eb 0b                	jmp    802d10 <alloc_block_NF+0x45c>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0f                	je     802d29 <alloc_block_NF+0x475>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d23:	8b 12                	mov    (%edx),%edx
  802d25:	89 10                	mov    %edx,(%eax)
  802d27:	eb 0a                	jmp    802d33 <alloc_block_NF+0x47f>
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d46:	a1 44 51 80 00       	mov    0x805144,%eax
  802d4b:	48                   	dec    %eax
  802d4c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 40 08             	mov    0x8(%eax),%eax
  802d57:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	e9 1b 01 00 00       	jmp    802e7f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d6d:	0f 86 d1 00 00 00    	jbe    802e44 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d73:	a1 48 51 80 00       	mov    0x805148,%eax
  802d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 50 08             	mov    0x8(%eax),%edx
  802d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d84:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d94:	75 17                	jne    802dad <alloc_block_NF+0x4f9>
  802d96:	83 ec 04             	sub    $0x4,%esp
  802d99:	68 d8 45 80 00       	push   $0x8045d8
  802d9e:	68 1c 01 00 00       	push   $0x11c
  802da3:	68 2f 45 80 00       	push   $0x80452f
  802da8:	e8 02 d8 ff ff       	call   8005af <_panic>
  802dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 10                	je     802dc6 <alloc_block_NF+0x512>
  802db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dbe:	8b 52 04             	mov    0x4(%edx),%edx
  802dc1:	89 50 04             	mov    %edx,0x4(%eax)
  802dc4:	eb 0b                	jmp    802dd1 <alloc_block_NF+0x51d>
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	8b 40 04             	mov    0x4(%eax),%eax
  802dcc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0f                	je     802dea <alloc_block_NF+0x536>
  802ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de4:	8b 12                	mov    (%edx),%edx
  802de6:	89 10                	mov    %edx,(%eax)
  802de8:	eb 0a                	jmp    802df4 <alloc_block_NF+0x540>
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	a3 48 51 80 00       	mov    %eax,0x805148
  802df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e07:	a1 54 51 80 00       	mov    0x805154,%eax
  802e0c:	48                   	dec    %eax
  802e0d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e15:	8b 40 08             	mov    0x8(%eax),%eax
  802e18:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 50 08             	mov    0x8(%eax),%edx
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	01 c2                	add    %eax,%edx
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 40 0c             	mov    0xc(%eax),%eax
  802e34:	2b 45 08             	sub    0x8(%ebp),%eax
  802e37:	89 c2                	mov    %eax,%edx
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e42:	eb 3b                	jmp    802e7f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e44:	a1 40 51 80 00       	mov    0x805140,%eax
  802e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	74 07                	je     802e59 <alloc_block_NF+0x5a5>
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	eb 05                	jmp    802e5e <alloc_block_NF+0x5aa>
  802e59:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5e:	a3 40 51 80 00       	mov    %eax,0x805140
  802e63:	a1 40 51 80 00       	mov    0x805140,%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	0f 85 2e fe ff ff    	jne    802c9e <alloc_block_NF+0x3ea>
  802e70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e74:	0f 85 24 fe ff ff    	jne    802c9e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e7f:	c9                   	leave  
  802e80:	c3                   	ret    

00802e81 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e81:	55                   	push   %ebp
  802e82:	89 e5                	mov    %esp,%ebp
  802e84:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e87:	a1 38 51 80 00       	mov    0x805138,%eax
  802e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e8f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e94:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e97:	a1 38 51 80 00       	mov    0x805138,%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	74 14                	je     802eb4 <insert_sorted_with_merge_freeList+0x33>
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	8b 50 08             	mov    0x8(%eax),%edx
  802ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea9:	8b 40 08             	mov    0x8(%eax),%eax
  802eac:	39 c2                	cmp    %eax,%edx
  802eae:	0f 87 9b 01 00 00    	ja     80304f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802eb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb8:	75 17                	jne    802ed1 <insert_sorted_with_merge_freeList+0x50>
  802eba:	83 ec 04             	sub    $0x4,%esp
  802ebd:	68 0c 45 80 00       	push   $0x80450c
  802ec2:	68 38 01 00 00       	push   $0x138
  802ec7:	68 2f 45 80 00       	push   $0x80452f
  802ecc:	e8 de d6 ff ff       	call   8005af <_panic>
  802ed1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	89 10                	mov    %edx,(%eax)
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	85 c0                	test   %eax,%eax
  802ee3:	74 0d                	je     802ef2 <insert_sorted_with_merge_freeList+0x71>
  802ee5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eea:	8b 55 08             	mov    0x8(%ebp),%edx
  802eed:	89 50 04             	mov    %edx,0x4(%eax)
  802ef0:	eb 08                	jmp    802efa <insert_sorted_with_merge_freeList+0x79>
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	a3 38 51 80 00       	mov    %eax,0x805138
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f11:	40                   	inc    %eax
  802f12:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f1b:	0f 84 a8 06 00 00    	je     8035c9 <insert_sorted_with_merge_freeList+0x748>
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	8b 50 08             	mov    0x8(%eax),%edx
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2d:	01 c2                	add    %eax,%edx
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	8b 40 08             	mov    0x8(%eax),%eax
  802f35:	39 c2                	cmp    %eax,%edx
  802f37:	0f 85 8c 06 00 00    	jne    8035c9 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	8b 50 0c             	mov    0xc(%eax),%edx
  802f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f46:	8b 40 0c             	mov    0xc(%eax),%eax
  802f49:	01 c2                	add    %eax,%edx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f55:	75 17                	jne    802f6e <insert_sorted_with_merge_freeList+0xed>
  802f57:	83 ec 04             	sub    $0x4,%esp
  802f5a:	68 d8 45 80 00       	push   $0x8045d8
  802f5f:	68 3c 01 00 00       	push   $0x13c
  802f64:	68 2f 45 80 00       	push   $0x80452f
  802f69:	e8 41 d6 ff ff       	call   8005af <_panic>
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	85 c0                	test   %eax,%eax
  802f75:	74 10                	je     802f87 <insert_sorted_with_merge_freeList+0x106>
  802f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f7f:	8b 52 04             	mov    0x4(%edx),%edx
  802f82:	89 50 04             	mov    %edx,0x4(%eax)
  802f85:	eb 0b                	jmp    802f92 <insert_sorted_with_merge_freeList+0x111>
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	74 0f                	je     802fab <insert_sorted_with_merge_freeList+0x12a>
  802f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9f:	8b 40 04             	mov    0x4(%eax),%eax
  802fa2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa5:	8b 12                	mov    (%edx),%edx
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	eb 0a                	jmp    802fb5 <insert_sorted_with_merge_freeList+0x134>
  802fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc8:	a1 44 51 80 00       	mov    0x805144,%eax
  802fcd:	48                   	dec    %eax
  802fce:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fe7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802feb:	75 17                	jne    803004 <insert_sorted_with_merge_freeList+0x183>
  802fed:	83 ec 04             	sub    $0x4,%esp
  802ff0:	68 0c 45 80 00       	push   $0x80450c
  802ff5:	68 3f 01 00 00       	push   $0x13f
  802ffa:	68 2f 45 80 00       	push   $0x80452f
  802fff:	e8 ab d5 ff ff       	call   8005af <_panic>
  803004:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80300a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300d:	89 10                	mov    %edx,(%eax)
  80300f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803012:	8b 00                	mov    (%eax),%eax
  803014:	85 c0                	test   %eax,%eax
  803016:	74 0d                	je     803025 <insert_sorted_with_merge_freeList+0x1a4>
  803018:	a1 48 51 80 00       	mov    0x805148,%eax
  80301d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803020:	89 50 04             	mov    %edx,0x4(%eax)
  803023:	eb 08                	jmp    80302d <insert_sorted_with_merge_freeList+0x1ac>
  803025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803028:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80302d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803030:	a3 48 51 80 00       	mov    %eax,0x805148
  803035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803038:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303f:	a1 54 51 80 00       	mov    0x805154,%eax
  803044:	40                   	inc    %eax
  803045:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80304a:	e9 7a 05 00 00       	jmp    8035c9 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	8b 50 08             	mov    0x8(%eax),%edx
  803055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803058:	8b 40 08             	mov    0x8(%eax),%eax
  80305b:	39 c2                	cmp    %eax,%edx
  80305d:	0f 82 14 01 00 00    	jb     803177 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803063:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803066:	8b 50 08             	mov    0x8(%eax),%edx
  803069:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306c:	8b 40 0c             	mov    0xc(%eax),%eax
  80306f:	01 c2                	add    %eax,%edx
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	8b 40 08             	mov    0x8(%eax),%eax
  803077:	39 c2                	cmp    %eax,%edx
  803079:	0f 85 90 00 00 00    	jne    80310f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80307f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803082:	8b 50 0c             	mov    0xc(%eax),%edx
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	8b 40 0c             	mov    0xc(%eax),%eax
  80308b:	01 c2                	add    %eax,%edx
  80308d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803090:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ab:	75 17                	jne    8030c4 <insert_sorted_with_merge_freeList+0x243>
  8030ad:	83 ec 04             	sub    $0x4,%esp
  8030b0:	68 0c 45 80 00       	push   $0x80450c
  8030b5:	68 49 01 00 00       	push   $0x149
  8030ba:	68 2f 45 80 00       	push   $0x80452f
  8030bf:	e8 eb d4 ff ff       	call   8005af <_panic>
  8030c4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	89 10                	mov    %edx,(%eax)
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0d                	je     8030e5 <insert_sorted_with_merge_freeList+0x264>
  8030d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	eb 08                	jmp    8030ed <insert_sorted_with_merge_freeList+0x26c>
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ff:	a1 54 51 80 00       	mov    0x805154,%eax
  803104:	40                   	inc    %eax
  803105:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80310a:	e9 bb 04 00 00       	jmp    8035ca <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80310f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803113:	75 17                	jne    80312c <insert_sorted_with_merge_freeList+0x2ab>
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	68 80 45 80 00       	push   $0x804580
  80311d:	68 4c 01 00 00       	push   $0x14c
  803122:	68 2f 45 80 00       	push   $0x80452f
  803127:	e8 83 d4 ff ff       	call   8005af <_panic>
  80312c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	89 50 04             	mov    %edx,0x4(%eax)
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	8b 40 04             	mov    0x4(%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	74 0c                	je     80314e <insert_sorted_with_merge_freeList+0x2cd>
  803142:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803147:	8b 55 08             	mov    0x8(%ebp),%edx
  80314a:	89 10                	mov    %edx,(%eax)
  80314c:	eb 08                	jmp    803156 <insert_sorted_with_merge_freeList+0x2d5>
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	a3 38 51 80 00       	mov    %eax,0x805138
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803167:	a1 44 51 80 00       	mov    0x805144,%eax
  80316c:	40                   	inc    %eax
  80316d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803172:	e9 53 04 00 00       	jmp    8035ca <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803177:	a1 38 51 80 00       	mov    0x805138,%eax
  80317c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317f:	e9 15 04 00 00       	jmp    803599 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	8b 50 08             	mov    0x8(%eax),%edx
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 40 08             	mov    0x8(%eax),%eax
  803198:	39 c2                	cmp    %eax,%edx
  80319a:	0f 86 f1 03 00 00    	jbe    803591 <insert_sorted_with_merge_freeList+0x710>
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	8b 50 08             	mov    0x8(%eax),%edx
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	8b 40 08             	mov    0x8(%eax),%eax
  8031ac:	39 c2                	cmp    %eax,%edx
  8031ae:	0f 83 dd 03 00 00    	jae    803591 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c0:	01 c2                	add    %eax,%edx
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	8b 40 08             	mov    0x8(%eax),%eax
  8031c8:	39 c2                	cmp    %eax,%edx
  8031ca:	0f 85 b9 01 00 00    	jne    803389 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	8b 50 08             	mov    0x8(%eax),%edx
  8031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031dc:	01 c2                	add    %eax,%edx
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	8b 40 08             	mov    0x8(%eax),%eax
  8031e4:	39 c2                	cmp    %eax,%edx
  8031e6:	0f 85 0d 01 00 00    	jne    8032f9 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f8:	01 c2                	add    %eax,%edx
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803200:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803204:	75 17                	jne    80321d <insert_sorted_with_merge_freeList+0x39c>
  803206:	83 ec 04             	sub    $0x4,%esp
  803209:	68 d8 45 80 00       	push   $0x8045d8
  80320e:	68 5c 01 00 00       	push   $0x15c
  803213:	68 2f 45 80 00       	push   $0x80452f
  803218:	e8 92 d3 ff ff       	call   8005af <_panic>
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	8b 00                	mov    (%eax),%eax
  803222:	85 c0                	test   %eax,%eax
  803224:	74 10                	je     803236 <insert_sorted_with_merge_freeList+0x3b5>
  803226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803229:	8b 00                	mov    (%eax),%eax
  80322b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322e:	8b 52 04             	mov    0x4(%edx),%edx
  803231:	89 50 04             	mov    %edx,0x4(%eax)
  803234:	eb 0b                	jmp    803241 <insert_sorted_with_merge_freeList+0x3c0>
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	8b 40 04             	mov    0x4(%eax),%eax
  80323c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803244:	8b 40 04             	mov    0x4(%eax),%eax
  803247:	85 c0                	test   %eax,%eax
  803249:	74 0f                	je     80325a <insert_sorted_with_merge_freeList+0x3d9>
  80324b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324e:	8b 40 04             	mov    0x4(%eax),%eax
  803251:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803254:	8b 12                	mov    (%edx),%edx
  803256:	89 10                	mov    %edx,(%eax)
  803258:	eb 0a                	jmp    803264 <insert_sorted_with_merge_freeList+0x3e3>
  80325a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325d:	8b 00                	mov    (%eax),%eax
  80325f:	a3 38 51 80 00       	mov    %eax,0x805138
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803277:	a1 44 51 80 00       	mov    0x805144,%eax
  80327c:	48                   	dec    %eax
  80327d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803282:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803285:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803296:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80329a:	75 17                	jne    8032b3 <insert_sorted_with_merge_freeList+0x432>
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 0c 45 80 00       	push   $0x80450c
  8032a4:	68 5f 01 00 00       	push   $0x15f
  8032a9:	68 2f 45 80 00       	push   $0x80452f
  8032ae:	e8 fc d2 ff ff       	call   8005af <_panic>
  8032b3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bc:	89 10                	mov    %edx,(%eax)
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	8b 00                	mov    (%eax),%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 0d                	je     8032d4 <insert_sorted_with_merge_freeList+0x453>
  8032c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8032cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cf:	89 50 04             	mov    %edx,0x4(%eax)
  8032d2:	eb 08                	jmp    8032dc <insert_sorted_with_merge_freeList+0x45b>
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032df:	a3 48 51 80 00       	mov    %eax,0x805148
  8032e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ee:	a1 54 51 80 00       	mov    0x805154,%eax
  8032f3:	40                   	inc    %eax
  8032f4:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803302:	8b 40 0c             	mov    0xc(%eax),%eax
  803305:	01 c2                	add    %eax,%edx
  803307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803321:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803325:	75 17                	jne    80333e <insert_sorted_with_merge_freeList+0x4bd>
  803327:	83 ec 04             	sub    $0x4,%esp
  80332a:	68 0c 45 80 00       	push   $0x80450c
  80332f:	68 64 01 00 00       	push   $0x164
  803334:	68 2f 45 80 00       	push   $0x80452f
  803339:	e8 71 d2 ff ff       	call   8005af <_panic>
  80333e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	89 10                	mov    %edx,(%eax)
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 0d                	je     80335f <insert_sorted_with_merge_freeList+0x4de>
  803352:	a1 48 51 80 00       	mov    0x805148,%eax
  803357:	8b 55 08             	mov    0x8(%ebp),%edx
  80335a:	89 50 04             	mov    %edx,0x4(%eax)
  80335d:	eb 08                	jmp    803367 <insert_sorted_with_merge_freeList+0x4e6>
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	a3 48 51 80 00       	mov    %eax,0x805148
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803379:	a1 54 51 80 00       	mov    0x805154,%eax
  80337e:	40                   	inc    %eax
  80337f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803384:	e9 41 02 00 00       	jmp    8035ca <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	8b 50 08             	mov    0x8(%eax),%edx
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	8b 40 0c             	mov    0xc(%eax),%eax
  803395:	01 c2                	add    %eax,%edx
  803397:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339a:	8b 40 08             	mov    0x8(%eax),%eax
  80339d:	39 c2                	cmp    %eax,%edx
  80339f:	0f 85 7c 01 00 00    	jne    803521 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033a9:	74 06                	je     8033b1 <insert_sorted_with_merge_freeList+0x530>
  8033ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033af:	75 17                	jne    8033c8 <insert_sorted_with_merge_freeList+0x547>
  8033b1:	83 ec 04             	sub    $0x4,%esp
  8033b4:	68 48 45 80 00       	push   $0x804548
  8033b9:	68 69 01 00 00       	push   $0x169
  8033be:	68 2f 45 80 00       	push   $0x80452f
  8033c3:	e8 e7 d1 ff ff       	call   8005af <_panic>
  8033c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cb:	8b 50 04             	mov    0x4(%eax),%edx
  8033ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d1:	89 50 04             	mov    %edx,0x4(%eax)
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033da:	89 10                	mov    %edx,(%eax)
  8033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033df:	8b 40 04             	mov    0x4(%eax),%eax
  8033e2:	85 c0                	test   %eax,%eax
  8033e4:	74 0d                	je     8033f3 <insert_sorted_with_merge_freeList+0x572>
  8033e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e9:	8b 40 04             	mov    0x4(%eax),%eax
  8033ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ef:	89 10                	mov    %edx,(%eax)
  8033f1:	eb 08                	jmp    8033fb <insert_sorted_with_merge_freeList+0x57a>
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803401:	89 50 04             	mov    %edx,0x4(%eax)
  803404:	a1 44 51 80 00       	mov    0x805144,%eax
  803409:	40                   	inc    %eax
  80340a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	8b 50 0c             	mov    0xc(%eax),%edx
  803415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803418:	8b 40 0c             	mov    0xc(%eax),%eax
  80341b:	01 c2                	add    %eax,%edx
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803423:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803427:	75 17                	jne    803440 <insert_sorted_with_merge_freeList+0x5bf>
  803429:	83 ec 04             	sub    $0x4,%esp
  80342c:	68 d8 45 80 00       	push   $0x8045d8
  803431:	68 6b 01 00 00       	push   $0x16b
  803436:	68 2f 45 80 00       	push   $0x80452f
  80343b:	e8 6f d1 ff ff       	call   8005af <_panic>
  803440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	85 c0                	test   %eax,%eax
  803447:	74 10                	je     803459 <insert_sorted_with_merge_freeList+0x5d8>
  803449:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344c:	8b 00                	mov    (%eax),%eax
  80344e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803451:	8b 52 04             	mov    0x4(%edx),%edx
  803454:	89 50 04             	mov    %edx,0x4(%eax)
  803457:	eb 0b                	jmp    803464 <insert_sorted_with_merge_freeList+0x5e3>
  803459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345c:	8b 40 04             	mov    0x4(%eax),%eax
  80345f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803464:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803467:	8b 40 04             	mov    0x4(%eax),%eax
  80346a:	85 c0                	test   %eax,%eax
  80346c:	74 0f                	je     80347d <insert_sorted_with_merge_freeList+0x5fc>
  80346e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803471:	8b 40 04             	mov    0x4(%eax),%eax
  803474:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803477:	8b 12                	mov    (%edx),%edx
  803479:	89 10                	mov    %edx,(%eax)
  80347b:	eb 0a                	jmp    803487 <insert_sorted_with_merge_freeList+0x606>
  80347d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	a3 38 51 80 00       	mov    %eax,0x805138
  803487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803493:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349a:	a1 44 51 80 00       	mov    0x805144,%eax
  80349f:	48                   	dec    %eax
  8034a0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034bd:	75 17                	jne    8034d6 <insert_sorted_with_merge_freeList+0x655>
  8034bf:	83 ec 04             	sub    $0x4,%esp
  8034c2:	68 0c 45 80 00       	push   $0x80450c
  8034c7:	68 6e 01 00 00       	push   $0x16e
  8034cc:	68 2f 45 80 00       	push   $0x80452f
  8034d1:	e8 d9 d0 ff ff       	call   8005af <_panic>
  8034d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034df:	89 10                	mov    %edx,(%eax)
  8034e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	85 c0                	test   %eax,%eax
  8034e8:	74 0d                	je     8034f7 <insert_sorted_with_merge_freeList+0x676>
  8034ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034f2:	89 50 04             	mov    %edx,0x4(%eax)
  8034f5:	eb 08                	jmp    8034ff <insert_sorted_with_merge_freeList+0x67e>
  8034f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803502:	a3 48 51 80 00       	mov    %eax,0x805148
  803507:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803511:	a1 54 51 80 00       	mov    0x805154,%eax
  803516:	40                   	inc    %eax
  803517:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80351c:	e9 a9 00 00 00       	jmp    8035ca <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803525:	74 06                	je     80352d <insert_sorted_with_merge_freeList+0x6ac>
  803527:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80352b:	75 17                	jne    803544 <insert_sorted_with_merge_freeList+0x6c3>
  80352d:	83 ec 04             	sub    $0x4,%esp
  803530:	68 a4 45 80 00       	push   $0x8045a4
  803535:	68 73 01 00 00       	push   $0x173
  80353a:	68 2f 45 80 00       	push   $0x80452f
  80353f:	e8 6b d0 ff ff       	call   8005af <_panic>
  803544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803547:	8b 10                	mov    (%eax),%edx
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	89 10                	mov    %edx,(%eax)
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	74 0b                	je     803562 <insert_sorted_with_merge_freeList+0x6e1>
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	8b 55 08             	mov    0x8(%ebp),%edx
  80355f:	89 50 04             	mov    %edx,0x4(%eax)
  803562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803565:	8b 55 08             	mov    0x8(%ebp),%edx
  803568:	89 10                	mov    %edx,(%eax)
  80356a:	8b 45 08             	mov    0x8(%ebp),%eax
  80356d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803570:	89 50 04             	mov    %edx,0x4(%eax)
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	8b 00                	mov    (%eax),%eax
  803578:	85 c0                	test   %eax,%eax
  80357a:	75 08                	jne    803584 <insert_sorted_with_merge_freeList+0x703>
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803584:	a1 44 51 80 00       	mov    0x805144,%eax
  803589:	40                   	inc    %eax
  80358a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80358f:	eb 39                	jmp    8035ca <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803591:	a1 40 51 80 00       	mov    0x805140,%eax
  803596:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359d:	74 07                	je     8035a6 <insert_sorted_with_merge_freeList+0x725>
  80359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a2:	8b 00                	mov    (%eax),%eax
  8035a4:	eb 05                	jmp    8035ab <insert_sorted_with_merge_freeList+0x72a>
  8035a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ab:	a3 40 51 80 00       	mov    %eax,0x805140
  8035b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8035b5:	85 c0                	test   %eax,%eax
  8035b7:	0f 85 c7 fb ff ff    	jne    803184 <insert_sorted_with_merge_freeList+0x303>
  8035bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c1:	0f 85 bd fb ff ff    	jne    803184 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035c7:	eb 01                	jmp    8035ca <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035c9:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035ca:	90                   	nop
  8035cb:	c9                   	leave  
  8035cc:	c3                   	ret    

008035cd <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8035cd:	55                   	push   %ebp
  8035ce:	89 e5                	mov    %esp,%ebp
  8035d0:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8035d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d6:	89 d0                	mov    %edx,%eax
  8035d8:	c1 e0 02             	shl    $0x2,%eax
  8035db:	01 d0                	add    %edx,%eax
  8035dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035e4:	01 d0                	add    %edx,%eax
  8035e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035ed:	01 d0                	add    %edx,%eax
  8035ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8035f6:	01 d0                	add    %edx,%eax
  8035f8:	c1 e0 04             	shl    $0x4,%eax
  8035fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8035fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803605:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803608:	83 ec 0c             	sub    $0xc,%esp
  80360b:	50                   	push   %eax
  80360c:	e8 26 e7 ff ff       	call   801d37 <sys_get_virtual_time>
  803611:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803614:	eb 41                	jmp    803657 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803616:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803619:	83 ec 0c             	sub    $0xc,%esp
  80361c:	50                   	push   %eax
  80361d:	e8 15 e7 ff ff       	call   801d37 <sys_get_virtual_time>
  803622:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803625:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362b:	29 c2                	sub    %eax,%edx
  80362d:	89 d0                	mov    %edx,%eax
  80362f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803632:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803638:	89 d1                	mov    %edx,%ecx
  80363a:	29 c1                	sub    %eax,%ecx
  80363c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80363f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803642:	39 c2                	cmp    %eax,%edx
  803644:	0f 97 c0             	seta   %al
  803647:	0f b6 c0             	movzbl %al,%eax
  80364a:	29 c1                	sub    %eax,%ecx
  80364c:	89 c8                	mov    %ecx,%eax
  80364e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803651:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803654:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80365d:	72 b7                	jb     803616 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80365f:	90                   	nop
  803660:	c9                   	leave  
  803661:	c3                   	ret    

00803662 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803662:	55                   	push   %ebp
  803663:	89 e5                	mov    %esp,%ebp
  803665:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803668:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80366f:	eb 03                	jmp    803674 <busy_wait+0x12>
  803671:	ff 45 fc             	incl   -0x4(%ebp)
  803674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803677:	3b 45 08             	cmp    0x8(%ebp),%eax
  80367a:	72 f5                	jb     803671 <busy_wait+0xf>
	return i;
  80367c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80367f:	c9                   	leave  
  803680:	c3                   	ret    
  803681:	66 90                	xchg   %ax,%ax
  803683:	90                   	nop

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
