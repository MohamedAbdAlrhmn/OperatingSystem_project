
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
  80008d:	68 80 39 80 00       	push   $0x803980
  800092:	6a 12                	push   $0x12
  800094:	68 9c 39 80 00       	push   $0x80399c
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 bc 39 80 00       	push   $0x8039bc
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 f0 39 80 00       	push   $0x8039f0
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 4c 3a 80 00       	push   $0x803a4c
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 8c 1c 00 00       	call   801d5f <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 80 3a 80 00       	push   $0x803a80
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
  8000ff:	68 c1 3a 80 00       	push   $0x803ac1
  800104:	e8 01 1c 00 00       	call   801d0a <sys_create_env>
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
  800128:	68 c1 3a 80 00       	push   $0x803ac1
  80012d:	e8 d8 1b 00 00       	call   801d0a <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 5b 19 00 00       	call   801a98 <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 cf 3a 80 00       	push   $0x803acf
  80014f:	e8 df 16 00 00       	call   801833 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 d4 3a 80 00       	push   $0x803ad4
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 f4 3a 80 00       	push   $0x803af4
  80017b:	6a 26                	push   $0x26
  80017d:	68 9c 39 80 00       	push   $0x80399c
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 09 19 00 00       	call   801a98 <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 60 3b 80 00       	push   $0x803b60
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 9c 39 80 00       	push   $0x80399c
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 a5 1c 00 00       	call   801e56 <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 6c 1b 00 00       	call   801d28 <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 5e 1b 00 00       	call   801d28 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 de 3b 80 00       	push   $0x803bde
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 70 34 00 00       	call   80365a <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 de 1c 00 00       	call   801ed0 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 f5 3b 80 00       	push   $0x803bf5
  8001ff:	6a 33                	push   $0x33
  800201:	68 9c 39 80 00       	push   $0x80399c
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 22 17 00 00       	call   801938 <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 04 3c 80 00       	push   $0x803c04
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 6a 18 00 00       	call   801a98 <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 24 3c 80 00       	push   $0x803c24
  800248:	6a 38                	push   $0x38
  80024a:	68 9c 39 80 00       	push   $0x80399c
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 54 3c 80 00       	push   $0x803c54
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 78 3c 80 00       	push   $0x803c78
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
  80028d:	68 a8 3c 80 00       	push   $0x803ca8
  800292:	e8 73 1a 00 00       	call   801d0a <sys_create_env>
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
  8002b6:	68 b8 3c 80 00       	push   $0x803cb8
  8002bb:	e8 4a 1a 00 00       	call   801d0a <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 c8 3c 80 00       	push   $0x803cc8
  8002d5:	e8 59 15 00 00       	call   801833 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 cc 3c 80 00       	push   $0x803ccc
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 cf 3a 80 00       	push   $0x803acf
  8002ff:	e8 2f 15 00 00       	call   801833 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 d4 3a 80 00       	push   $0x803ad4
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 37 1b 00 00       	call   801e56 <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 fe 19 00 00       	call   801d28 <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 f0 19 00 00       	call   801d28 <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 12 33 00 00       	call   80365a <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 48 17 00 00       	call   801a98 <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 da 15 00 00       	call   801938 <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 ec 3c 80 00       	push   $0x803cec
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 bc 15 00 00       	call   801938 <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 02 3d 80 00       	push   $0x803d02
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 04 17 00 00       	call   801a98 <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 18 3d 80 00       	push   $0x803d18
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 9c 39 80 00       	push   $0x80399c
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 f7 1a 00 00       	call   801eb6 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 bd 3d 80 00       	push   $0x803dbd
  8003cb:	e8 63 14 00 00       	call   801833 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 ad 19 00 00       	call   801d91 <sys_getparentenvid>
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
  8003fa:	68 cd 3d 80 00       	push   $0x803dcd
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 32 19 00 00       	call   801d44 <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 24 19 00 00       	call   801d44 <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 16 19 00 00       	call   801d44 <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 08 19 00 00       	call   801d44 <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 46 19 00 00       	call   801d91 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 d3 3d 80 00       	push   $0x803dd3
  800453:	50                   	push   %eax
  800454:	e8 9b 14 00 00       	call   8018f4 <sget>
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
  800479:	e8 fa 18 00 00       	call   801d78 <sys_getenvindex>
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
  8004e4:	e8 9c 16 00 00       	call   801b85 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 fc 3d 80 00       	push   $0x803dfc
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
  800514:	68 24 3e 80 00       	push   $0x803e24
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
  800545:	68 4c 3e 80 00       	push   $0x803e4c
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 a4 3e 80 00       	push   $0x803ea4
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 fc 3d 80 00       	push   $0x803dfc
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 1c 16 00 00       	call   801b9f <sys_enable_interrupt>

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
  800596:	e8 a9 17 00 00       	call   801d44 <sys_destroy_env>
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
  8005a7:	e8 fe 17 00 00       	call   801daa <sys_exit_env>
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
  8005d0:	68 b8 3e 80 00       	push   $0x803eb8
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 bd 3e 80 00       	push   $0x803ebd
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
  80060d:	68 d9 3e 80 00       	push   $0x803ed9
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
  800639:	68 dc 3e 80 00       	push   $0x803edc
  80063e:	6a 26                	push   $0x26
  800640:	68 28 3f 80 00       	push   $0x803f28
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
  80070b:	68 34 3f 80 00       	push   $0x803f34
  800710:	6a 3a                	push   $0x3a
  800712:	68 28 3f 80 00       	push   $0x803f28
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
  80077b:	68 88 3f 80 00       	push   $0x803f88
  800780:	6a 44                	push   $0x44
  800782:	68 28 3f 80 00       	push   $0x803f28
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
  8007d5:	e8 fd 11 00 00       	call   8019d7 <sys_cputs>
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
  80084c:	e8 86 11 00 00       	call   8019d7 <sys_cputs>
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
  800896:	e8 ea 12 00 00       	call   801b85 <sys_disable_interrupt>
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
  8008b6:	e8 e4 12 00 00       	call   801b9f <sys_enable_interrupt>
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
  800900:	e8 0b 2e 00 00       	call   803710 <__udivdi3>
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
  800950:	e8 cb 2e 00 00       	call   803820 <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 f4 41 80 00       	add    $0x8041f4,%eax
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
  800aab:	8b 04 85 18 42 80 00 	mov    0x804218(,%eax,4),%eax
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
  800b8c:	8b 34 9d 60 40 80 00 	mov    0x804060(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 05 42 80 00       	push   $0x804205
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
  800bb1:	68 0e 42 80 00       	push   $0x80420e
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
  800bde:	be 11 42 80 00       	mov    $0x804211,%esi
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
  801604:	68 70 43 80 00       	push   $0x804370
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
  8016d4:	e8 42 04 00 00       	call   801b1b <sys_allocate_chunk>
  8016d9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016dc:	a1 20 51 80 00       	mov    0x805120,%eax
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	50                   	push   %eax
  8016e5:	e8 b7 0a 00 00       	call   8021a1 <initialize_MemBlocksList>
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
  801712:	68 95 43 80 00       	push   $0x804395
  801717:	6a 33                	push   $0x33
  801719:	68 b3 43 80 00       	push   $0x8043b3
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
  801791:	68 c0 43 80 00       	push   $0x8043c0
  801796:	6a 34                	push   $0x34
  801798:	68 b3 43 80 00       	push   $0x8043b3
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
  801806:	68 e4 43 80 00       	push   $0x8043e4
  80180b:	6a 46                	push   $0x46
  80180d:	68 b3 43 80 00       	push   $0x8043b3
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
  801822:	68 0c 44 80 00       	push   $0x80440c
  801827:	6a 61                	push   $0x61
  801829:	68 b3 43 80 00       	push   $0x8043b3
  80182e:	e8 7c ed ff ff       	call   8005af <_panic>

00801833 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 38             	sub    $0x38,%esp
  801839:	8b 45 10             	mov    0x10(%ebp),%eax
  80183c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80183f:	e8 a9 fd ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  801844:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801848:	75 0a                	jne    801854 <smalloc+0x21>
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	e9 9e 00 00 00       	jmp    8018f2 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801854:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80185b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801861:	01 d0                	add    %edx,%eax
  801863:	48                   	dec    %eax
  801864:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186a:	ba 00 00 00 00       	mov    $0x0,%edx
  80186f:	f7 75 f0             	divl   -0x10(%ebp)
  801872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801875:	29 d0                	sub    %edx,%eax
  801877:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80187a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801881:	e8 63 06 00 00       	call   801ee9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801886:	85 c0                	test   %eax,%eax
  801888:	74 11                	je     80189b <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80188a:	83 ec 0c             	sub    $0xc,%esp
  80188d:	ff 75 e8             	pushl  -0x18(%ebp)
  801890:	e8 ce 0c 00 00       	call   802563 <alloc_block_FF>
  801895:	83 c4 10             	add    $0x10,%esp
  801898:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80189b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80189f:	74 4c                	je     8018ed <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	8b 40 08             	mov    0x8(%eax),%eax
  8018a7:	89 c2                	mov    %eax,%edx
  8018a9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	ff 75 08             	pushl  0x8(%ebp)
  8018b5:	e8 b4 03 00 00       	call   801c6e <sys_createSharedObject>
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8018c0:	83 ec 08             	sub    $0x8,%esp
  8018c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8018c6:	68 2f 44 80 00       	push   $0x80442f
  8018cb:	e8 93 ef ff ff       	call   800863 <cprintf>
  8018d0:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8018d3:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8018d7:	74 14                	je     8018ed <smalloc+0xba>
  8018d9:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8018dd:	74 0e                	je     8018ed <smalloc+0xba>
  8018df:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8018e3:	74 08                	je     8018ed <smalloc+0xba>
			return (void*) mem_block->sva;
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	8b 40 08             	mov    0x8(%eax),%eax
  8018eb:	eb 05                	jmp    8018f2 <smalloc+0xbf>
	}
	return NULL;
  8018ed:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018fa:	e8 ee fc ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	68 44 44 80 00       	push   $0x804444
  801907:	68 ab 00 00 00       	push   $0xab
  80190c:	68 b3 43 80 00       	push   $0x8043b3
  801911:	e8 99 ec ff ff       	call   8005af <_panic>

00801916 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80191c:	e8 cc fc ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	68 68 44 80 00       	push   $0x804468
  801929:	68 ef 00 00 00       	push   $0xef
  80192e:	68 b3 43 80 00       	push   $0x8043b3
  801933:	e8 77 ec ff ff       	call   8005af <_panic>

00801938 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	68 90 44 80 00       	push   $0x804490
  801946:	68 03 01 00 00       	push   $0x103
  80194b:	68 b3 43 80 00       	push   $0x8043b3
  801950:	e8 5a ec ff ff       	call   8005af <_panic>

00801955 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80195b:	83 ec 04             	sub    $0x4,%esp
  80195e:	68 b4 44 80 00       	push   $0x8044b4
  801963:	68 0e 01 00 00       	push   $0x10e
  801968:	68 b3 43 80 00       	push   $0x8043b3
  80196d:	e8 3d ec ff ff       	call   8005af <_panic>

00801972 <shrink>:

}
void shrink(uint32 newSize)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	68 b4 44 80 00       	push   $0x8044b4
  801980:	68 13 01 00 00       	push   $0x113
  801985:	68 b3 43 80 00       	push   $0x8043b3
  80198a:	e8 20 ec ff ff       	call   8005af <_panic>

0080198f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	68 b4 44 80 00       	push   $0x8044b4
  80199d:	68 18 01 00 00       	push   $0x118
  8019a2:	68 b3 43 80 00       	push   $0x8043b3
  8019a7:	e8 03 ec ff ff       	call   8005af <_panic>

008019ac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	57                   	push   %edi
  8019b0:	56                   	push   %esi
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019c4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019c7:	cd 30                	int    $0x30
  8019c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019cf:	83 c4 10             	add    $0x10,%esp
  8019d2:	5b                   	pop    %ebx
  8019d3:	5e                   	pop    %esi
  8019d4:	5f                   	pop    %edi
  8019d5:	5d                   	pop    %ebp
  8019d6:	c3                   	ret    

008019d7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	50                   	push   %eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	e8 b2 ff ff ff       	call   8019ac <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 01                	push   $0x1
  801a0f:	e8 98 ff ff ff       	call   8019ac <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	52                   	push   %edx
  801a29:	50                   	push   %eax
  801a2a:	6a 05                	push   $0x5
  801a2c:	e8 7b ff ff ff       	call   8019ac <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	56                   	push   %esi
  801a3a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a3b:	8b 75 18             	mov    0x18(%ebp),%esi
  801a3e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	56                   	push   %esi
  801a4b:	53                   	push   %ebx
  801a4c:	51                   	push   %ecx
  801a4d:	52                   	push   %edx
  801a4e:	50                   	push   %eax
  801a4f:	6a 06                	push   $0x6
  801a51:	e8 56 ff ff ff       	call   8019ac <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5c:	5b                   	pop    %ebx
  801a5d:	5e                   	pop    %esi
  801a5e:	5d                   	pop    %ebp
  801a5f:	c3                   	ret    

00801a60 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	52                   	push   %edx
  801a70:	50                   	push   %eax
  801a71:	6a 07                	push   $0x7
  801a73:	e8 34 ff ff ff       	call   8019ac <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	ff 75 0c             	pushl  0xc(%ebp)
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	6a 08                	push   $0x8
  801a8e:	e8 19 ff ff ff       	call   8019ac <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 09                	push   $0x9
  801aa7:	e8 00 ff ff ff       	call   8019ac <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 0a                	push   $0xa
  801ac0:	e8 e7 fe ff ff       	call   8019ac <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 0b                	push   $0xb
  801ad9:	e8 ce fe ff ff       	call   8019ac <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	ff 75 08             	pushl  0x8(%ebp)
  801af2:	6a 0f                	push   $0xf
  801af4:	e8 b3 fe ff ff       	call   8019ac <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
	return;
  801afc:	90                   	nop
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	ff 75 08             	pushl  0x8(%ebp)
  801b0e:	6a 10                	push   $0x10
  801b10:	e8 97 fe ff ff       	call   8019ac <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
	return ;
  801b18:	90                   	nop
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	ff 75 10             	pushl  0x10(%ebp)
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	6a 11                	push   $0x11
  801b2d:	e8 7a fe ff ff       	call   8019ac <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return ;
  801b35:	90                   	nop
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 0c                	push   $0xc
  801b47:	e8 60 fe ff ff       	call   8019ac <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	ff 75 08             	pushl  0x8(%ebp)
  801b5f:	6a 0d                	push   $0xd
  801b61:	e8 46 fe ff ff       	call   8019ac <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 0e                	push   $0xe
  801b7a:	e8 2d fe ff ff       	call   8019ac <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 13                	push   $0x13
  801b94:	e8 13 fe ff ff       	call   8019ac <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	90                   	nop
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 14                	push   $0x14
  801bae:	e8 f9 fd ff ff       	call   8019ac <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	90                   	nop
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_cputc>:


void
sys_cputc(const char c)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 04             	sub    $0x4,%esp
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bc5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	50                   	push   %eax
  801bd2:	6a 15                	push   $0x15
  801bd4:	e8 d3 fd ff ff       	call   8019ac <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	90                   	nop
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 16                	push   $0x16
  801bee:	e8 b9 fd ff ff       	call   8019ac <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	90                   	nop
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	50                   	push   %eax
  801c09:	6a 17                	push   $0x17
  801c0b:	e8 9c fd ff ff       	call   8019ac <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	52                   	push   %edx
  801c25:	50                   	push   %eax
  801c26:	6a 1a                	push   $0x1a
  801c28:	e8 7f fd ff ff       	call   8019ac <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	52                   	push   %edx
  801c42:	50                   	push   %eax
  801c43:	6a 18                	push   $0x18
  801c45:	e8 62 fd ff ff       	call   8019ac <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	90                   	nop
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	52                   	push   %edx
  801c60:	50                   	push   %eax
  801c61:	6a 19                	push   $0x19
  801c63:	e8 44 fd ff ff       	call   8019ac <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	90                   	nop
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	8b 45 10             	mov    0x10(%ebp),%eax
  801c77:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c7a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c7d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	51                   	push   %ecx
  801c87:	52                   	push   %edx
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	50                   	push   %eax
  801c8c:	6a 1b                	push   $0x1b
  801c8e:	e8 19 fd ff ff       	call   8019ac <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	52                   	push   %edx
  801ca8:	50                   	push   %eax
  801ca9:	6a 1c                	push   $0x1c
  801cab:	e8 fc fc ff ff       	call   8019ac <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	51                   	push   %ecx
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 1d                	push   $0x1d
  801cca:	e8 dd fc ff ff       	call   8019ac <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	6a 1e                	push   $0x1e
  801ce7:	e8 c0 fc ff ff       	call   8019ac <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 1f                	push   $0x1f
  801d00:	e8 a7 fc ff ff       	call   8019ac <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	6a 00                	push   $0x0
  801d12:	ff 75 14             	pushl  0x14(%ebp)
  801d15:	ff 75 10             	pushl  0x10(%ebp)
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	50                   	push   %eax
  801d1c:	6a 20                	push   $0x20
  801d1e:	e8 89 fc ff ff       	call   8019ac <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	50                   	push   %eax
  801d37:	6a 21                	push   $0x21
  801d39:	e8 6e fc ff ff       	call   8019ac <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	90                   	nop
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	50                   	push   %eax
  801d53:	6a 22                	push   $0x22
  801d55:	e8 52 fc ff ff       	call   8019ac <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 02                	push   $0x2
  801d6e:	e8 39 fc ff ff       	call   8019ac <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 03                	push   $0x3
  801d87:	e8 20 fc ff ff       	call   8019ac <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 04                	push   $0x4
  801da0:	e8 07 fc ff ff       	call   8019ac <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_exit_env>:


void sys_exit_env(void)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 23                	push   $0x23
  801db9:	e8 ee fb ff ff       	call   8019ac <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	90                   	nop
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dcd:	8d 50 04             	lea    0x4(%eax),%edx
  801dd0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	52                   	push   %edx
  801dda:	50                   	push   %eax
  801ddb:	6a 24                	push   $0x24
  801ddd:	e8 ca fb ff ff       	call   8019ac <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
	return result;
  801de5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801deb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dee:	89 01                	mov    %eax,(%ecx)
  801df0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	c9                   	leave  
  801df7:	c2 04 00             	ret    $0x4

00801dfa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	ff 75 10             	pushl  0x10(%ebp)
  801e04:	ff 75 0c             	pushl  0xc(%ebp)
  801e07:	ff 75 08             	pushl  0x8(%ebp)
  801e0a:	6a 12                	push   $0x12
  801e0c:	e8 9b fb ff ff       	call   8019ac <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
	return ;
  801e14:	90                   	nop
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 25                	push   $0x25
  801e26:	e8 81 fb ff ff       	call   8019ac <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e3c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	50                   	push   %eax
  801e49:	6a 26                	push   $0x26
  801e4b:	e8 5c fb ff ff       	call   8019ac <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
	return ;
  801e53:	90                   	nop
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <rsttst>:
void rsttst()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 28                	push   $0x28
  801e65:	e8 42 fb ff ff       	call   8019ac <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6d:	90                   	nop
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	8b 45 14             	mov    0x14(%ebp),%eax
  801e79:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e7c:	8b 55 18             	mov    0x18(%ebp),%edx
  801e7f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e83:	52                   	push   %edx
  801e84:	50                   	push   %eax
  801e85:	ff 75 10             	pushl  0x10(%ebp)
  801e88:	ff 75 0c             	pushl  0xc(%ebp)
  801e8b:	ff 75 08             	pushl  0x8(%ebp)
  801e8e:	6a 27                	push   $0x27
  801e90:	e8 17 fb ff ff       	call   8019ac <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
	return ;
  801e98:	90                   	nop
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <chktst>:
void chktst(uint32 n)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	ff 75 08             	pushl  0x8(%ebp)
  801ea9:	6a 29                	push   $0x29
  801eab:	e8 fc fa ff ff       	call   8019ac <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb3:	90                   	nop
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <inctst>:

void inctst()
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 2a                	push   $0x2a
  801ec5:	e8 e2 fa ff ff       	call   8019ac <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecd:	90                   	nop
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <gettst>:
uint32 gettst()
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 2b                	push   $0x2b
  801edf:	e8 c8 fa ff ff       	call   8019ac <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 2c                	push   $0x2c
  801efb:	e8 ac fa ff ff       	call   8019ac <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
  801f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f06:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f0a:	75 07                	jne    801f13 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f11:	eb 05                	jmp    801f18 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 2c                	push   $0x2c
  801f2c:	e8 7b fa ff ff       	call   8019ac <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
  801f34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f37:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f3b:	75 07                	jne    801f44 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f42:	eb 05                	jmp    801f49 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 2c                	push   $0x2c
  801f5d:	e8 4a fa ff ff       	call   8019ac <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
  801f65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f68:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f6c:	75 07                	jne    801f75 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f73:	eb 05                	jmp    801f7a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 2c                	push   $0x2c
  801f8e:	e8 19 fa ff ff       	call   8019ac <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
  801f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f99:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f9d:	75 07                	jne    801fa6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa4:	eb 05                	jmp    801fab <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	ff 75 08             	pushl  0x8(%ebp)
  801fbb:	6a 2d                	push   $0x2d
  801fbd:	e8 ea f9 ff ff       	call   8019ac <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc5:	90                   	nop
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fcc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fcf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	6a 00                	push   $0x0
  801fda:	53                   	push   %ebx
  801fdb:	51                   	push   %ecx
  801fdc:	52                   	push   %edx
  801fdd:	50                   	push   %eax
  801fde:	6a 2e                	push   $0x2e
  801fe0:	e8 c7 f9 ff ff       	call   8019ac <syscall>
  801fe5:	83 c4 18             	add    $0x18,%esp
}
  801fe8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	52                   	push   %edx
  801ffd:	50                   	push   %eax
  801ffe:	6a 2f                	push   $0x2f
  802000:	e8 a7 f9 ff ff       	call   8019ac <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	68 c4 44 80 00       	push   $0x8044c4
  802018:	e8 46 e8 ff ff       	call   800863 <cprintf>
  80201d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802020:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	68 f0 44 80 00       	push   $0x8044f0
  80202f:	e8 2f e8 ff ff       	call   800863 <cprintf>
  802034:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802037:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80203b:	a1 38 51 80 00       	mov    0x805138,%eax
  802040:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802043:	eb 56                	jmp    80209b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802045:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802049:	74 1c                	je     802067 <print_mem_block_lists+0x5d>
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	8b 50 08             	mov    0x8(%eax),%edx
  802051:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802054:	8b 48 08             	mov    0x8(%eax),%ecx
  802057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205a:	8b 40 0c             	mov    0xc(%eax),%eax
  80205d:	01 c8                	add    %ecx,%eax
  80205f:	39 c2                	cmp    %eax,%edx
  802061:	73 04                	jae    802067 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802063:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	8b 50 08             	mov    0x8(%eax),%edx
  80206d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802070:	8b 40 0c             	mov    0xc(%eax),%eax
  802073:	01 c2                	add    %eax,%edx
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	8b 40 08             	mov    0x8(%eax),%eax
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	52                   	push   %edx
  80207f:	50                   	push   %eax
  802080:	68 05 45 80 00       	push   $0x804505
  802085:	e8 d9 e7 ff ff       	call   800863 <cprintf>
  80208a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80208d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802093:	a1 40 51 80 00       	mov    0x805140,%eax
  802098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209f:	74 07                	je     8020a8 <print_mem_block_lists+0x9e>
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	8b 00                	mov    (%eax),%eax
  8020a6:	eb 05                	jmp    8020ad <print_mem_block_lists+0xa3>
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ad:	a3 40 51 80 00       	mov    %eax,0x805140
  8020b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	75 8a                	jne    802045 <print_mem_block_lists+0x3b>
  8020bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020bf:	75 84                	jne    802045 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020c1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020c5:	75 10                	jne    8020d7 <print_mem_block_lists+0xcd>
  8020c7:	83 ec 0c             	sub    $0xc,%esp
  8020ca:	68 14 45 80 00       	push   $0x804514
  8020cf:	e8 8f e7 ff ff       	call   800863 <cprintf>
  8020d4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020de:	83 ec 0c             	sub    $0xc,%esp
  8020e1:	68 38 45 80 00       	push   $0x804538
  8020e6:	e8 78 e7 ff ff       	call   800863 <cprintf>
  8020eb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020ee:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020f2:	a1 40 50 80 00       	mov    0x805040,%eax
  8020f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fa:	eb 56                	jmp    802152 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802100:	74 1c                	je     80211e <print_mem_block_lists+0x114>
  802102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802105:	8b 50 08             	mov    0x8(%eax),%edx
  802108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210b:	8b 48 08             	mov    0x8(%eax),%ecx
  80210e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802111:	8b 40 0c             	mov    0xc(%eax),%eax
  802114:	01 c8                	add    %ecx,%eax
  802116:	39 c2                	cmp    %eax,%edx
  802118:	73 04                	jae    80211e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80211a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80211e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802121:	8b 50 08             	mov    0x8(%eax),%edx
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 40 0c             	mov    0xc(%eax),%eax
  80212a:	01 c2                	add    %eax,%edx
  80212c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212f:	8b 40 08             	mov    0x8(%eax),%eax
  802132:	83 ec 04             	sub    $0x4,%esp
  802135:	52                   	push   %edx
  802136:	50                   	push   %eax
  802137:	68 05 45 80 00       	push   $0x804505
  80213c:	e8 22 e7 ff ff       	call   800863 <cprintf>
  802141:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80214a:	a1 48 50 80 00       	mov    0x805048,%eax
  80214f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802156:	74 07                	je     80215f <print_mem_block_lists+0x155>
  802158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215b:	8b 00                	mov    (%eax),%eax
  80215d:	eb 05                	jmp    802164 <print_mem_block_lists+0x15a>
  80215f:	b8 00 00 00 00       	mov    $0x0,%eax
  802164:	a3 48 50 80 00       	mov    %eax,0x805048
  802169:	a1 48 50 80 00       	mov    0x805048,%eax
  80216e:	85 c0                	test   %eax,%eax
  802170:	75 8a                	jne    8020fc <print_mem_block_lists+0xf2>
  802172:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802176:	75 84                	jne    8020fc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802178:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80217c:	75 10                	jne    80218e <print_mem_block_lists+0x184>
  80217e:	83 ec 0c             	sub    $0xc,%esp
  802181:	68 50 45 80 00       	push   $0x804550
  802186:	e8 d8 e6 ff ff       	call   800863 <cprintf>
  80218b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80218e:	83 ec 0c             	sub    $0xc,%esp
  802191:	68 c4 44 80 00       	push   $0x8044c4
  802196:	e8 c8 e6 ff ff       	call   800863 <cprintf>
  80219b:	83 c4 10             	add    $0x10,%esp

}
  80219e:	90                   	nop
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8021a7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8021ae:	00 00 00 
  8021b1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8021b8:	00 00 00 
  8021bb:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8021c2:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8021c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021cc:	e9 9e 00 00 00       	jmp    80226f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8021d1:	a1 50 50 80 00       	mov    0x805050,%eax
  8021d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d9:	c1 e2 04             	shl    $0x4,%edx
  8021dc:	01 d0                	add    %edx,%eax
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	75 14                	jne    8021f6 <initialize_MemBlocksList+0x55>
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	68 78 45 80 00       	push   $0x804578
  8021ea:	6a 46                	push   $0x46
  8021ec:	68 9b 45 80 00       	push   $0x80459b
  8021f1:	e8 b9 e3 ff ff       	call   8005af <_panic>
  8021f6:	a1 50 50 80 00       	mov    0x805050,%eax
  8021fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fe:	c1 e2 04             	shl    $0x4,%edx
  802201:	01 d0                	add    %edx,%eax
  802203:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802209:	89 10                	mov    %edx,(%eax)
  80220b:	8b 00                	mov    (%eax),%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	74 18                	je     802229 <initialize_MemBlocksList+0x88>
  802211:	a1 48 51 80 00       	mov    0x805148,%eax
  802216:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80221c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80221f:	c1 e1 04             	shl    $0x4,%ecx
  802222:	01 ca                	add    %ecx,%edx
  802224:	89 50 04             	mov    %edx,0x4(%eax)
  802227:	eb 12                	jmp    80223b <initialize_MemBlocksList+0x9a>
  802229:	a1 50 50 80 00       	mov    0x805050,%eax
  80222e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802231:	c1 e2 04             	shl    $0x4,%edx
  802234:	01 d0                	add    %edx,%eax
  802236:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80223b:	a1 50 50 80 00       	mov    0x805050,%eax
  802240:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802243:	c1 e2 04             	shl    $0x4,%edx
  802246:	01 d0                	add    %edx,%eax
  802248:	a3 48 51 80 00       	mov    %eax,0x805148
  80224d:	a1 50 50 80 00       	mov    0x805050,%eax
  802252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802255:	c1 e2 04             	shl    $0x4,%edx
  802258:	01 d0                	add    %edx,%eax
  80225a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802261:	a1 54 51 80 00       	mov    0x805154,%eax
  802266:	40                   	inc    %eax
  802267:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80226c:	ff 45 f4             	incl   -0xc(%ebp)
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	3b 45 08             	cmp    0x8(%ebp),%eax
  802275:	0f 82 56 ff ff ff    	jb     8021d1 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80227b:	90                   	nop
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	8b 00                	mov    (%eax),%eax
  802289:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80228c:	eb 19                	jmp    8022a7 <find_block+0x29>
	{
		if(va==point->sva)
  80228e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802291:	8b 40 08             	mov    0x8(%eax),%eax
  802294:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802297:	75 05                	jne    80229e <find_block+0x20>
		   return point;
  802299:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80229c:	eb 36                	jmp    8022d4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	8b 40 08             	mov    0x8(%eax),%eax
  8022a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022ab:	74 07                	je     8022b4 <find_block+0x36>
  8022ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022b0:	8b 00                	mov    (%eax),%eax
  8022b2:	eb 05                	jmp    8022b9 <find_block+0x3b>
  8022b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bc:	89 42 08             	mov    %eax,0x8(%edx)
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	8b 40 08             	mov    0x8(%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	75 c5                	jne    80228e <find_block+0x10>
  8022c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022cd:	75 bf                	jne    80228e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8022dc:	a1 40 50 80 00       	mov    0x805040,%eax
  8022e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8022e4:	a1 44 50 80 00       	mov    0x805044,%eax
  8022e9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8022ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022f2:	74 24                	je     802318 <insert_sorted_allocList+0x42>
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	8b 50 08             	mov    0x8(%eax),%edx
  8022fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fd:	8b 40 08             	mov    0x8(%eax),%eax
  802300:	39 c2                	cmp    %eax,%edx
  802302:	76 14                	jbe    802318 <insert_sorted_allocList+0x42>
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	8b 50 08             	mov    0x8(%eax),%edx
  80230a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230d:	8b 40 08             	mov    0x8(%eax),%eax
  802310:	39 c2                	cmp    %eax,%edx
  802312:	0f 82 60 01 00 00    	jb     802478 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80231c:	75 65                	jne    802383 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80231e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802322:	75 14                	jne    802338 <insert_sorted_allocList+0x62>
  802324:	83 ec 04             	sub    $0x4,%esp
  802327:	68 78 45 80 00       	push   $0x804578
  80232c:	6a 6b                	push   $0x6b
  80232e:	68 9b 45 80 00       	push   $0x80459b
  802333:	e8 77 e2 ff ff       	call   8005af <_panic>
  802338:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	89 10                	mov    %edx,(%eax)
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	8b 00                	mov    (%eax),%eax
  802348:	85 c0                	test   %eax,%eax
  80234a:	74 0d                	je     802359 <insert_sorted_allocList+0x83>
  80234c:	a1 40 50 80 00       	mov    0x805040,%eax
  802351:	8b 55 08             	mov    0x8(%ebp),%edx
  802354:	89 50 04             	mov    %edx,0x4(%eax)
  802357:	eb 08                	jmp    802361 <insert_sorted_allocList+0x8b>
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	a3 44 50 80 00       	mov    %eax,0x805044
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	a3 40 50 80 00       	mov    %eax,0x805040
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802373:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802378:	40                   	inc    %eax
  802379:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80237e:	e9 dc 01 00 00       	jmp    80255f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	8b 50 08             	mov    0x8(%eax),%edx
  802389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238c:	8b 40 08             	mov    0x8(%eax),%eax
  80238f:	39 c2                	cmp    %eax,%edx
  802391:	77 6c                	ja     8023ff <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802393:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802397:	74 06                	je     80239f <insert_sorted_allocList+0xc9>
  802399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239d:	75 14                	jne    8023b3 <insert_sorted_allocList+0xdd>
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	68 b4 45 80 00       	push   $0x8045b4
  8023a7:	6a 6f                	push   $0x6f
  8023a9:	68 9b 45 80 00       	push   $0x80459b
  8023ae:	e8 fc e1 ff ff       	call   8005af <_panic>
  8023b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b6:	8b 50 04             	mov    0x4(%eax),%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	89 50 04             	mov    %edx,0x4(%eax)
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c5:	89 10                	mov    %edx,(%eax)
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	8b 40 04             	mov    0x4(%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 0d                	je     8023de <insert_sorted_allocList+0x108>
  8023d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d4:	8b 40 04             	mov    0x4(%eax),%eax
  8023d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023da:	89 10                	mov    %edx,(%eax)
  8023dc:	eb 08                	jmp    8023e6 <insert_sorted_allocList+0x110>
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	a3 40 50 80 00       	mov    %eax,0x805040
  8023e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ec:	89 50 04             	mov    %edx,0x4(%eax)
  8023ef:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023f4:	40                   	inc    %eax
  8023f5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023fa:	e9 60 01 00 00       	jmp    80255f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8b 50 08             	mov    0x8(%eax),%edx
  802405:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802408:	8b 40 08             	mov    0x8(%eax),%eax
  80240b:	39 c2                	cmp    %eax,%edx
  80240d:	0f 82 4c 01 00 00    	jb     80255f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802413:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802417:	75 14                	jne    80242d <insert_sorted_allocList+0x157>
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	68 ec 45 80 00       	push   $0x8045ec
  802421:	6a 73                	push   $0x73
  802423:	68 9b 45 80 00       	push   $0x80459b
  802428:	e8 82 e1 ff ff       	call   8005af <_panic>
  80242d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	89 50 04             	mov    %edx,0x4(%eax)
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	8b 40 04             	mov    0x4(%eax),%eax
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 0c                	je     80244f <insert_sorted_allocList+0x179>
  802443:	a1 44 50 80 00       	mov    0x805044,%eax
  802448:	8b 55 08             	mov    0x8(%ebp),%edx
  80244b:	89 10                	mov    %edx,(%eax)
  80244d:	eb 08                	jmp    802457 <insert_sorted_allocList+0x181>
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	a3 40 50 80 00       	mov    %eax,0x805040
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	a3 44 50 80 00       	mov    %eax,0x805044
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802468:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80246d:	40                   	inc    %eax
  80246e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802473:	e9 e7 00 00 00       	jmp    80255f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80247e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802485:	a1 40 50 80 00       	mov    0x805040,%eax
  80248a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248d:	e9 9d 00 00 00       	jmp    80252f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 00                	mov    (%eax),%eax
  802497:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	8b 50 08             	mov    0x8(%eax),%edx
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 08             	mov    0x8(%eax),%eax
  8024a6:	39 c2                	cmp    %eax,%edx
  8024a8:	76 7d                	jbe    802527 <insert_sorted_allocList+0x251>
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	8b 50 08             	mov    0x8(%eax),%edx
  8024b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b3:	8b 40 08             	mov    0x8(%eax),%eax
  8024b6:	39 c2                	cmp    %eax,%edx
  8024b8:	73 6d                	jae    802527 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8024ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024be:	74 06                	je     8024c6 <insert_sorted_allocList+0x1f0>
  8024c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024c4:	75 14                	jne    8024da <insert_sorted_allocList+0x204>
  8024c6:	83 ec 04             	sub    $0x4,%esp
  8024c9:	68 10 46 80 00       	push   $0x804610
  8024ce:	6a 7f                	push   $0x7f
  8024d0:	68 9b 45 80 00       	push   $0x80459b
  8024d5:	e8 d5 e0 ff ff       	call   8005af <_panic>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 10                	mov    (%eax),%edx
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	89 10                	mov    %edx,(%eax)
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	74 0b                	je     8024f8 <insert_sorted_allocList+0x222>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f5:	89 50 04             	mov    %edx,0x4(%eax)
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fe:	89 10                	mov    %edx,(%eax)
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802506:	89 50 04             	mov    %edx,0x4(%eax)
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	8b 00                	mov    (%eax),%eax
  80250e:	85 c0                	test   %eax,%eax
  802510:	75 08                	jne    80251a <insert_sorted_allocList+0x244>
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	a3 44 50 80 00       	mov    %eax,0x805044
  80251a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80251f:	40                   	inc    %eax
  802520:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802525:	eb 39                	jmp    802560 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802527:	a1 48 50 80 00       	mov    0x805048,%eax
  80252c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802533:	74 07                	je     80253c <insert_sorted_allocList+0x266>
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	eb 05                	jmp    802541 <insert_sorted_allocList+0x26b>
  80253c:	b8 00 00 00 00       	mov    $0x0,%eax
  802541:	a3 48 50 80 00       	mov    %eax,0x805048
  802546:	a1 48 50 80 00       	mov    0x805048,%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	0f 85 3f ff ff ff    	jne    802492 <insert_sorted_allocList+0x1bc>
  802553:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802557:	0f 85 35 ff ff ff    	jne    802492 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80255d:	eb 01                	jmp    802560 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80255f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802560:	90                   	nop
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
  802566:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802569:	a1 38 51 80 00       	mov    0x805138,%eax
  80256e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802571:	e9 85 01 00 00       	jmp    8026fb <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 0c             	mov    0xc(%eax),%eax
  80257c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80257f:	0f 82 6e 01 00 00    	jb     8026f3 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 40 0c             	mov    0xc(%eax),%eax
  80258b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80258e:	0f 85 8a 00 00 00    	jne    80261e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802598:	75 17                	jne    8025b1 <alloc_block_FF+0x4e>
  80259a:	83 ec 04             	sub    $0x4,%esp
  80259d:	68 44 46 80 00       	push   $0x804644
  8025a2:	68 93 00 00 00       	push   $0x93
  8025a7:	68 9b 45 80 00       	push   $0x80459b
  8025ac:	e8 fe df ff ff       	call   8005af <_panic>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 10                	je     8025ca <alloc_block_FF+0x67>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c2:	8b 52 04             	mov    0x4(%edx),%edx
  8025c5:	89 50 04             	mov    %edx,0x4(%eax)
  8025c8:	eb 0b                	jmp    8025d5 <alloc_block_FF+0x72>
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 40 04             	mov    0x4(%eax),%eax
  8025d0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 40 04             	mov    0x4(%eax),%eax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	74 0f                	je     8025ee <alloc_block_FF+0x8b>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e8:	8b 12                	mov    (%edx),%edx
  8025ea:	89 10                	mov    %edx,(%eax)
  8025ec:	eb 0a                	jmp    8025f8 <alloc_block_FF+0x95>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80260b:	a1 44 51 80 00       	mov    0x805144,%eax
  802610:	48                   	dec    %eax
  802611:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	e9 10 01 00 00       	jmp    80272e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 0c             	mov    0xc(%eax),%eax
  802624:	3b 45 08             	cmp    0x8(%ebp),%eax
  802627:	0f 86 c6 00 00 00    	jbe    8026f3 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80262d:	a1 48 51 80 00       	mov    0x805148,%eax
  802632:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 50 08             	mov    0x8(%eax),%edx
  80263b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802644:	8b 55 08             	mov    0x8(%ebp),%edx
  802647:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80264a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80264e:	75 17                	jne    802667 <alloc_block_FF+0x104>
  802650:	83 ec 04             	sub    $0x4,%esp
  802653:	68 44 46 80 00       	push   $0x804644
  802658:	68 9b 00 00 00       	push   $0x9b
  80265d:	68 9b 45 80 00       	push   $0x80459b
  802662:	e8 48 df ff ff       	call   8005af <_panic>
  802667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	74 10                	je     802680 <alloc_block_FF+0x11d>
  802670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802678:	8b 52 04             	mov    0x4(%edx),%edx
  80267b:	89 50 04             	mov    %edx,0x4(%eax)
  80267e:	eb 0b                	jmp    80268b <alloc_block_FF+0x128>
  802680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802683:	8b 40 04             	mov    0x4(%eax),%eax
  802686:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80268b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268e:	8b 40 04             	mov    0x4(%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 0f                	je     8026a4 <alloc_block_FF+0x141>
  802695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802698:	8b 40 04             	mov    0x4(%eax),%eax
  80269b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80269e:	8b 12                	mov    (%edx),%edx
  8026a0:	89 10                	mov    %edx,(%eax)
  8026a2:	eb 0a                	jmp    8026ae <alloc_block_FF+0x14b>
  8026a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8026ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c1:	a1 54 51 80 00       	mov    0x805154,%eax
  8026c6:	48                   	dec    %eax
  8026c7:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 50 08             	mov    0x8(%eax),%edx
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	01 c2                	add    %eax,%edx
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8026e6:	89 c2                	mov    %eax,%edx
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8026ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f1:	eb 3b                	jmp    80272e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8026f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ff:	74 07                	je     802708 <alloc_block_FF+0x1a5>
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	eb 05                	jmp    80270d <alloc_block_FF+0x1aa>
  802708:	b8 00 00 00 00       	mov    $0x0,%eax
  80270d:	a3 40 51 80 00       	mov    %eax,0x805140
  802712:	a1 40 51 80 00       	mov    0x805140,%eax
  802717:	85 c0                	test   %eax,%eax
  802719:	0f 85 57 fe ff ff    	jne    802576 <alloc_block_FF+0x13>
  80271f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802723:	0f 85 4d fe ff ff    	jne    802576 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802736:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80273d:	a1 38 51 80 00       	mov    0x805138,%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802745:	e9 df 00 00 00       	jmp    802829 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 40 0c             	mov    0xc(%eax),%eax
  802750:	3b 45 08             	cmp    0x8(%ebp),%eax
  802753:	0f 82 c8 00 00 00    	jb     802821 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 40 0c             	mov    0xc(%eax),%eax
  80275f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802762:	0f 85 8a 00 00 00    	jne    8027f2 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802768:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276c:	75 17                	jne    802785 <alloc_block_BF+0x55>
  80276e:	83 ec 04             	sub    $0x4,%esp
  802771:	68 44 46 80 00       	push   $0x804644
  802776:	68 b7 00 00 00       	push   $0xb7
  80277b:	68 9b 45 80 00       	push   $0x80459b
  802780:	e8 2a de ff ff       	call   8005af <_panic>
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 10                	je     80279e <alloc_block_BF+0x6e>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802796:	8b 52 04             	mov    0x4(%edx),%edx
  802799:	89 50 04             	mov    %edx,0x4(%eax)
  80279c:	eb 0b                	jmp    8027a9 <alloc_block_BF+0x79>
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 40 04             	mov    0x4(%eax),%eax
  8027a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 40 04             	mov    0x4(%eax),%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	74 0f                	je     8027c2 <alloc_block_BF+0x92>
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 04             	mov    0x4(%eax),%eax
  8027b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bc:	8b 12                	mov    (%edx),%edx
  8027be:	89 10                	mov    %edx,(%eax)
  8027c0:	eb 0a                	jmp    8027cc <alloc_block_BF+0x9c>
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 00                	mov    (%eax),%eax
  8027c7:	a3 38 51 80 00       	mov    %eax,0x805138
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027df:	a1 44 51 80 00       	mov    0x805144,%eax
  8027e4:	48                   	dec    %eax
  8027e5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	e9 4d 01 00 00       	jmp    80293f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027fb:	76 24                	jbe    802821 <alloc_block_BF+0xf1>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 40 0c             	mov    0xc(%eax),%eax
  802803:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802806:	73 19                	jae    802821 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802808:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 40 0c             	mov    0xc(%eax),%eax
  802815:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 40 08             	mov    0x8(%eax),%eax
  80281e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802821:	a1 40 51 80 00       	mov    0x805140,%eax
  802826:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282d:	74 07                	je     802836 <alloc_block_BF+0x106>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	eb 05                	jmp    80283b <alloc_block_BF+0x10b>
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
  80283b:	a3 40 51 80 00       	mov    %eax,0x805140
  802840:	a1 40 51 80 00       	mov    0x805140,%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	0f 85 fd fe ff ff    	jne    80274a <alloc_block_BF+0x1a>
  80284d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802851:	0f 85 f3 fe ff ff    	jne    80274a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802857:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80285b:	0f 84 d9 00 00 00    	je     80293a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802861:	a1 48 51 80 00       	mov    0x805148,%eax
  802866:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80286f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802875:	8b 55 08             	mov    0x8(%ebp),%edx
  802878:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80287b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80287f:	75 17                	jne    802898 <alloc_block_BF+0x168>
  802881:	83 ec 04             	sub    $0x4,%esp
  802884:	68 44 46 80 00       	push   $0x804644
  802889:	68 c7 00 00 00       	push   $0xc7
  80288e:	68 9b 45 80 00       	push   $0x80459b
  802893:	e8 17 dd ff ff       	call   8005af <_panic>
  802898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	74 10                	je     8028b1 <alloc_block_BF+0x181>
  8028a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a4:	8b 00                	mov    (%eax),%eax
  8028a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a9:	8b 52 04             	mov    0x4(%edx),%edx
  8028ac:	89 50 04             	mov    %edx,0x4(%eax)
  8028af:	eb 0b                	jmp    8028bc <alloc_block_BF+0x18c>
  8028b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028bf:	8b 40 04             	mov    0x4(%eax),%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	74 0f                	je     8028d5 <alloc_block_BF+0x1a5>
  8028c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c9:	8b 40 04             	mov    0x4(%eax),%eax
  8028cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028cf:	8b 12                	mov    (%edx),%edx
  8028d1:	89 10                	mov    %edx,(%eax)
  8028d3:	eb 0a                	jmp    8028df <alloc_block_BF+0x1af>
  8028d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d8:	8b 00                	mov    (%eax),%eax
  8028da:	a3 48 51 80 00       	mov    %eax,0x805148
  8028df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8028f7:	48                   	dec    %eax
  8028f8:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028fd:	83 ec 08             	sub    $0x8,%esp
  802900:	ff 75 ec             	pushl  -0x14(%ebp)
  802903:	68 38 51 80 00       	push   $0x805138
  802908:	e8 71 f9 ff ff       	call   80227e <find_block>
  80290d:	83 c4 10             	add    $0x10,%esp
  802910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802916:	8b 50 08             	mov    0x8(%eax),%edx
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	01 c2                	add    %eax,%edx
  80291e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802921:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802924:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802927:	8b 40 0c             	mov    0xc(%eax),%eax
  80292a:	2b 45 08             	sub    0x8(%ebp),%eax
  80292d:	89 c2                	mov    %eax,%edx
  80292f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802932:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802938:	eb 05                	jmp    80293f <alloc_block_BF+0x20f>
	}
	return NULL;
  80293a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80293f:	c9                   	leave  
  802940:	c3                   	ret    

00802941 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802941:	55                   	push   %ebp
  802942:	89 e5                	mov    %esp,%ebp
  802944:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802947:	a1 28 50 80 00       	mov    0x805028,%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	0f 85 de 01 00 00    	jne    802b32 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802954:	a1 38 51 80 00       	mov    0x805138,%eax
  802959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295c:	e9 9e 01 00 00       	jmp    802aff <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 40 0c             	mov    0xc(%eax),%eax
  802967:	3b 45 08             	cmp    0x8(%ebp),%eax
  80296a:	0f 82 87 01 00 00    	jb     802af7 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 0c             	mov    0xc(%eax),%eax
  802976:	3b 45 08             	cmp    0x8(%ebp),%eax
  802979:	0f 85 95 00 00 00    	jne    802a14 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80297f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802983:	75 17                	jne    80299c <alloc_block_NF+0x5b>
  802985:	83 ec 04             	sub    $0x4,%esp
  802988:	68 44 46 80 00       	push   $0x804644
  80298d:	68 e0 00 00 00       	push   $0xe0
  802992:	68 9b 45 80 00       	push   $0x80459b
  802997:	e8 13 dc ff ff       	call   8005af <_panic>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	74 10                	je     8029b5 <alloc_block_NF+0x74>
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 00                	mov    (%eax),%eax
  8029aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ad:	8b 52 04             	mov    0x4(%edx),%edx
  8029b0:	89 50 04             	mov    %edx,0x4(%eax)
  8029b3:	eb 0b                	jmp    8029c0 <alloc_block_NF+0x7f>
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 40 04             	mov    0x4(%eax),%eax
  8029bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 40 04             	mov    0x4(%eax),%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 0f                	je     8029d9 <alloc_block_NF+0x98>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d3:	8b 12                	mov    (%edx),%edx
  8029d5:	89 10                	mov    %edx,(%eax)
  8029d7:	eb 0a                	jmp    8029e3 <alloc_block_NF+0xa2>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	a3 38 51 80 00       	mov    %eax,0x805138
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8029fb:	48                   	dec    %eax
  8029fc:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 40 08             	mov    0x8(%eax),%eax
  802a07:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	e9 f8 04 00 00       	jmp    802f0c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1d:	0f 86 d4 00 00 00    	jbe    802af7 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a23:	a1 48 51 80 00       	mov    0x805148,%eax
  802a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 50 08             	mov    0x8(%eax),%edx
  802a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a34:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a44:	75 17                	jne    802a5d <alloc_block_NF+0x11c>
  802a46:	83 ec 04             	sub    $0x4,%esp
  802a49:	68 44 46 80 00       	push   $0x804644
  802a4e:	68 e9 00 00 00       	push   $0xe9
  802a53:	68 9b 45 80 00       	push   $0x80459b
  802a58:	e8 52 db ff ff       	call   8005af <_panic>
  802a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	74 10                	je     802a76 <alloc_block_NF+0x135>
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a6e:	8b 52 04             	mov    0x4(%edx),%edx
  802a71:	89 50 04             	mov    %edx,0x4(%eax)
  802a74:	eb 0b                	jmp    802a81 <alloc_block_NF+0x140>
  802a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 0f                	je     802a9a <alloc_block_NF+0x159>
  802a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a94:	8b 12                	mov    (%edx),%edx
  802a96:	89 10                	mov    %edx,(%eax)
  802a98:	eb 0a                	jmp    802aa4 <alloc_block_NF+0x163>
  802a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9d:	8b 00                	mov    (%eax),%eax
  802a9f:	a3 48 51 80 00       	mov    %eax,0x805148
  802aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab7:	a1 54 51 80 00       	mov    0x805154,%eax
  802abc:	48                   	dec    %eax
  802abd:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	8b 40 08             	mov    0x8(%eax),%eax
  802ac8:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 50 08             	mov    0x8(%eax),%edx
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	01 c2                	add    %eax,%edx
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae7:	89 c2                	mov    %eax,%edx
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	e9 15 04 00 00       	jmp    802f0c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802af7:	a1 40 51 80 00       	mov    0x805140,%eax
  802afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b03:	74 07                	je     802b0c <alloc_block_NF+0x1cb>
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	eb 05                	jmp    802b11 <alloc_block_NF+0x1d0>
  802b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b11:	a3 40 51 80 00       	mov    %eax,0x805140
  802b16:	a1 40 51 80 00       	mov    0x805140,%eax
  802b1b:	85 c0                	test   %eax,%eax
  802b1d:	0f 85 3e fe ff ff    	jne    802961 <alloc_block_NF+0x20>
  802b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b27:	0f 85 34 fe ff ff    	jne    802961 <alloc_block_NF+0x20>
  802b2d:	e9 d5 03 00 00       	jmp    802f07 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b32:	a1 38 51 80 00       	mov    0x805138,%eax
  802b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b3a:	e9 b1 01 00 00       	jmp    802cf0 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 50 08             	mov    0x8(%eax),%edx
  802b45:	a1 28 50 80 00       	mov    0x805028,%eax
  802b4a:	39 c2                	cmp    %eax,%edx
  802b4c:	0f 82 96 01 00 00    	jb     802ce8 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 40 0c             	mov    0xc(%eax),%eax
  802b58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5b:	0f 82 87 01 00 00    	jb     802ce8 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 40 0c             	mov    0xc(%eax),%eax
  802b67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b6a:	0f 85 95 00 00 00    	jne    802c05 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b74:	75 17                	jne    802b8d <alloc_block_NF+0x24c>
  802b76:	83 ec 04             	sub    $0x4,%esp
  802b79:	68 44 46 80 00       	push   $0x804644
  802b7e:	68 fc 00 00 00       	push   $0xfc
  802b83:	68 9b 45 80 00       	push   $0x80459b
  802b88:	e8 22 da ff ff       	call   8005af <_panic>
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	74 10                	je     802ba6 <alloc_block_NF+0x265>
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 00                	mov    (%eax),%eax
  802b9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9e:	8b 52 04             	mov    0x4(%edx),%edx
  802ba1:	89 50 04             	mov    %edx,0x4(%eax)
  802ba4:	eb 0b                	jmp    802bb1 <alloc_block_NF+0x270>
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 40 04             	mov    0x4(%eax),%eax
  802bac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 40 04             	mov    0x4(%eax),%eax
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	74 0f                	je     802bca <alloc_block_NF+0x289>
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	8b 40 04             	mov    0x4(%eax),%eax
  802bc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc4:	8b 12                	mov    (%edx),%edx
  802bc6:	89 10                	mov    %edx,(%eax)
  802bc8:	eb 0a                	jmp    802bd4 <alloc_block_NF+0x293>
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	a3 38 51 80 00       	mov    %eax,0x805138
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be7:	a1 44 51 80 00       	mov    0x805144,%eax
  802bec:	48                   	dec    %eax
  802bed:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 40 08             	mov    0x8(%eax),%eax
  802bf8:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	e9 07 03 00 00       	jmp    802f0c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0e:	0f 86 d4 00 00 00    	jbe    802ce8 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c14:	a1 48 51 80 00       	mov    0x805148,%eax
  802c19:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 50 08             	mov    0x8(%eax),%edx
  802c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c25:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c35:	75 17                	jne    802c4e <alloc_block_NF+0x30d>
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	68 44 46 80 00       	push   $0x804644
  802c3f:	68 04 01 00 00       	push   $0x104
  802c44:	68 9b 45 80 00       	push   $0x80459b
  802c49:	e8 61 d9 ff ff       	call   8005af <_panic>
  802c4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c51:	8b 00                	mov    (%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	74 10                	je     802c67 <alloc_block_NF+0x326>
  802c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5a:	8b 00                	mov    (%eax),%eax
  802c5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c5f:	8b 52 04             	mov    0x4(%edx),%edx
  802c62:	89 50 04             	mov    %edx,0x4(%eax)
  802c65:	eb 0b                	jmp    802c72 <alloc_block_NF+0x331>
  802c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6a:	8b 40 04             	mov    0x4(%eax),%eax
  802c6d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c75:	8b 40 04             	mov    0x4(%eax),%eax
  802c78:	85 c0                	test   %eax,%eax
  802c7a:	74 0f                	je     802c8b <alloc_block_NF+0x34a>
  802c7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7f:	8b 40 04             	mov    0x4(%eax),%eax
  802c82:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c85:	8b 12                	mov    (%edx),%edx
  802c87:	89 10                	mov    %edx,(%eax)
  802c89:	eb 0a                	jmp    802c95 <alloc_block_NF+0x354>
  802c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	a3 48 51 80 00       	mov    %eax,0x805148
  802c95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca8:	a1 54 51 80 00       	mov    0x805154,%eax
  802cad:	48                   	dec    %eax
  802cae:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb6:	8b 40 08             	mov    0x8(%eax),%eax
  802cb9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 50 08             	mov    0x8(%eax),%edx
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	01 c2                	add    %eax,%edx
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd5:	2b 45 08             	sub    0x8(%ebp),%eax
  802cd8:	89 c2                	mov    %eax,%edx
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ce0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce3:	e9 24 02 00 00       	jmp    802f0c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ce8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf4:	74 07                	je     802cfd <alloc_block_NF+0x3bc>
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	eb 05                	jmp    802d02 <alloc_block_NF+0x3c1>
  802cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802d02:	a3 40 51 80 00       	mov    %eax,0x805140
  802d07:	a1 40 51 80 00       	mov    0x805140,%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	0f 85 2b fe ff ff    	jne    802b3f <alloc_block_NF+0x1fe>
  802d14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d18:	0f 85 21 fe ff ff    	jne    802b3f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d1e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	e9 ae 01 00 00       	jmp    802ed9 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 50 08             	mov    0x8(%eax),%edx
  802d31:	a1 28 50 80 00       	mov    0x805028,%eax
  802d36:	39 c2                	cmp    %eax,%edx
  802d38:	0f 83 93 01 00 00    	jae    802ed1 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 40 0c             	mov    0xc(%eax),%eax
  802d44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d47:	0f 82 84 01 00 00    	jb     802ed1 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 0c             	mov    0xc(%eax),%eax
  802d53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d56:	0f 85 95 00 00 00    	jne    802df1 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d60:	75 17                	jne    802d79 <alloc_block_NF+0x438>
  802d62:	83 ec 04             	sub    $0x4,%esp
  802d65:	68 44 46 80 00       	push   $0x804644
  802d6a:	68 14 01 00 00       	push   $0x114
  802d6f:	68 9b 45 80 00       	push   $0x80459b
  802d74:	e8 36 d8 ff ff       	call   8005af <_panic>
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 10                	je     802d92 <alloc_block_NF+0x451>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8a:	8b 52 04             	mov    0x4(%edx),%edx
  802d8d:	89 50 04             	mov    %edx,0x4(%eax)
  802d90:	eb 0b                	jmp    802d9d <alloc_block_NF+0x45c>
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 40 04             	mov    0x4(%eax),%eax
  802d98:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 40 04             	mov    0x4(%eax),%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 0f                	je     802db6 <alloc_block_NF+0x475>
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 40 04             	mov    0x4(%eax),%eax
  802dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db0:	8b 12                	mov    (%edx),%edx
  802db2:	89 10                	mov    %edx,(%eax)
  802db4:	eb 0a                	jmp    802dc0 <alloc_block_NF+0x47f>
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd3:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd8:	48                   	dec    %eax
  802dd9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 40 08             	mov    0x8(%eax),%eax
  802de4:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	e9 1b 01 00 00       	jmp    802f0c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 0c             	mov    0xc(%eax),%eax
  802df7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dfa:	0f 86 d1 00 00 00    	jbe    802ed1 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e00:	a1 48 51 80 00       	mov    0x805148,%eax
  802e05:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 50 08             	mov    0x8(%eax),%edx
  802e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e11:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e17:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e21:	75 17                	jne    802e3a <alloc_block_NF+0x4f9>
  802e23:	83 ec 04             	sub    $0x4,%esp
  802e26:	68 44 46 80 00       	push   $0x804644
  802e2b:	68 1c 01 00 00       	push   $0x11c
  802e30:	68 9b 45 80 00       	push   $0x80459b
  802e35:	e8 75 d7 ff ff       	call   8005af <_panic>
  802e3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 10                	je     802e53 <alloc_block_NF+0x512>
  802e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e4b:	8b 52 04             	mov    0x4(%edx),%edx
  802e4e:	89 50 04             	mov    %edx,0x4(%eax)
  802e51:	eb 0b                	jmp    802e5e <alloc_block_NF+0x51d>
  802e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e56:	8b 40 04             	mov    0x4(%eax),%eax
  802e59:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e61:	8b 40 04             	mov    0x4(%eax),%eax
  802e64:	85 c0                	test   %eax,%eax
  802e66:	74 0f                	je     802e77 <alloc_block_NF+0x536>
  802e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6b:	8b 40 04             	mov    0x4(%eax),%eax
  802e6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e71:	8b 12                	mov    (%edx),%edx
  802e73:	89 10                	mov    %edx,(%eax)
  802e75:	eb 0a                	jmp    802e81 <alloc_block_NF+0x540>
  802e77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e94:	a1 54 51 80 00       	mov    0x805154,%eax
  802e99:	48                   	dec    %eax
  802e9a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea2:	8b 40 08             	mov    0x8(%eax),%eax
  802ea5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 50 08             	mov    0x8(%eax),%edx
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	01 c2                	add    %eax,%edx
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ec4:	89 c2                	mov    %eax,%edx
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecf:	eb 3b                	jmp    802f0c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ed1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edd:	74 07                	je     802ee6 <alloc_block_NF+0x5a5>
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	eb 05                	jmp    802eeb <alloc_block_NF+0x5aa>
  802ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  802eeb:	a3 40 51 80 00       	mov    %eax,0x805140
  802ef0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	0f 85 2e fe ff ff    	jne    802d2b <alloc_block_NF+0x3ea>
  802efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f01:	0f 85 24 fe ff ff    	jne    802d2b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f0c:	c9                   	leave  
  802f0d:	c3                   	ret    

00802f0e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f0e:	55                   	push   %ebp
  802f0f:	89 e5                	mov    %esp,%ebp
  802f11:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802f14:	a1 38 51 80 00       	mov    0x805138,%eax
  802f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802f1c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f21:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802f24:	a1 38 51 80 00       	mov    0x805138,%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 14                	je     802f41 <insert_sorted_with_merge_freeList+0x33>
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 50 08             	mov    0x8(%eax),%edx
  802f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f36:	8b 40 08             	mov    0x8(%eax),%eax
  802f39:	39 c2                	cmp    %eax,%edx
  802f3b:	0f 87 9b 01 00 00    	ja     8030dc <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f45:	75 17                	jne    802f5e <insert_sorted_with_merge_freeList+0x50>
  802f47:	83 ec 04             	sub    $0x4,%esp
  802f4a:	68 78 45 80 00       	push   $0x804578
  802f4f:	68 38 01 00 00       	push   $0x138
  802f54:	68 9b 45 80 00       	push   $0x80459b
  802f59:	e8 51 d6 ff ff       	call   8005af <_panic>
  802f5e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	89 10                	mov    %edx,(%eax)
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	8b 00                	mov    (%eax),%eax
  802f6e:	85 c0                	test   %eax,%eax
  802f70:	74 0d                	je     802f7f <insert_sorted_with_merge_freeList+0x71>
  802f72:	a1 38 51 80 00       	mov    0x805138,%eax
  802f77:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7a:	89 50 04             	mov    %edx,0x4(%eax)
  802f7d:	eb 08                	jmp    802f87 <insert_sorted_with_merge_freeList+0x79>
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f99:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9e:	40                   	inc    %eax
  802f9f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fa8:	0f 84 a8 06 00 00    	je     803656 <insert_sorted_with_merge_freeList+0x748>
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	8b 50 08             	mov    0x8(%eax),%edx
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fba:	01 c2                	add    %eax,%edx
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	8b 40 08             	mov    0x8(%eax),%eax
  802fc2:	39 c2                	cmp    %eax,%edx
  802fc4:	0f 85 8c 06 00 00    	jne    803656 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	8b 50 0c             	mov    0xc(%eax),%edx
  802fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd6:	01 c2                	add    %eax,%edx
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802fde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe2:	75 17                	jne    802ffb <insert_sorted_with_merge_freeList+0xed>
  802fe4:	83 ec 04             	sub    $0x4,%esp
  802fe7:	68 44 46 80 00       	push   $0x804644
  802fec:	68 3c 01 00 00       	push   $0x13c
  802ff1:	68 9b 45 80 00       	push   $0x80459b
  802ff6:	e8 b4 d5 ff ff       	call   8005af <_panic>
  802ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffe:	8b 00                	mov    (%eax),%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	74 10                	je     803014 <insert_sorted_with_merge_freeList+0x106>
  803004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803007:	8b 00                	mov    (%eax),%eax
  803009:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300c:	8b 52 04             	mov    0x4(%edx),%edx
  80300f:	89 50 04             	mov    %edx,0x4(%eax)
  803012:	eb 0b                	jmp    80301f <insert_sorted_with_merge_freeList+0x111>
  803014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803017:	8b 40 04             	mov    0x4(%eax),%eax
  80301a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	74 0f                	je     803038 <insert_sorted_with_merge_freeList+0x12a>
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803032:	8b 12                	mov    (%edx),%edx
  803034:	89 10                	mov    %edx,(%eax)
  803036:	eb 0a                	jmp    803042 <insert_sorted_with_merge_freeList+0x134>
  803038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303b:	8b 00                	mov    (%eax),%eax
  80303d:	a3 38 51 80 00       	mov    %eax,0x805138
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80304b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803055:	a1 44 51 80 00       	mov    0x805144,%eax
  80305a:	48                   	dec    %eax
  80305b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803063:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80306a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803074:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803078:	75 17                	jne    803091 <insert_sorted_with_merge_freeList+0x183>
  80307a:	83 ec 04             	sub    $0x4,%esp
  80307d:	68 78 45 80 00       	push   $0x804578
  803082:	68 3f 01 00 00       	push   $0x13f
  803087:	68 9b 45 80 00       	push   $0x80459b
  80308c:	e8 1e d5 ff ff       	call   8005af <_panic>
  803091:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309a:	89 10                	mov    %edx,(%eax)
  80309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309f:	8b 00                	mov    (%eax),%eax
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	74 0d                	je     8030b2 <insert_sorted_with_merge_freeList+0x1a4>
  8030a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8030aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ad:	89 50 04             	mov    %edx,0x4(%eax)
  8030b0:	eb 08                	jmp    8030ba <insert_sorted_with_merge_freeList+0x1ac>
  8030b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8030c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8030d1:	40                   	inc    %eax
  8030d2:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030d7:	e9 7a 05 00 00       	jmp    803656 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	8b 50 08             	mov    0x8(%eax),%edx
  8030e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e5:	8b 40 08             	mov    0x8(%eax),%eax
  8030e8:	39 c2                	cmp    %eax,%edx
  8030ea:	0f 82 14 01 00 00    	jb     803204 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8030f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f3:	8b 50 08             	mov    0x8(%eax),%edx
  8030f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fc:	01 c2                	add    %eax,%edx
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 40 08             	mov    0x8(%eax),%eax
  803104:	39 c2                	cmp    %eax,%edx
  803106:	0f 85 90 00 00 00    	jne    80319c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80310c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310f:	8b 50 0c             	mov    0xc(%eax),%edx
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	8b 40 0c             	mov    0xc(%eax),%eax
  803118:	01 c2                	add    %eax,%edx
  80311a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803134:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803138:	75 17                	jne    803151 <insert_sorted_with_merge_freeList+0x243>
  80313a:	83 ec 04             	sub    $0x4,%esp
  80313d:	68 78 45 80 00       	push   $0x804578
  803142:	68 49 01 00 00       	push   $0x149
  803147:	68 9b 45 80 00       	push   $0x80459b
  80314c:	e8 5e d4 ff ff       	call   8005af <_panic>
  803151:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	85 c0                	test   %eax,%eax
  803163:	74 0d                	je     803172 <insert_sorted_with_merge_freeList+0x264>
  803165:	a1 48 51 80 00       	mov    0x805148,%eax
  80316a:	8b 55 08             	mov    0x8(%ebp),%edx
  80316d:	89 50 04             	mov    %edx,0x4(%eax)
  803170:	eb 08                	jmp    80317a <insert_sorted_with_merge_freeList+0x26c>
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 48 51 80 00       	mov    %eax,0x805148
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318c:	a1 54 51 80 00       	mov    0x805154,%eax
  803191:	40                   	inc    %eax
  803192:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803197:	e9 bb 04 00 00       	jmp    803657 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80319c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a0:	75 17                	jne    8031b9 <insert_sorted_with_merge_freeList+0x2ab>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 ec 45 80 00       	push   $0x8045ec
  8031aa:	68 4c 01 00 00       	push   $0x14c
  8031af:	68 9b 45 80 00       	push   $0x80459b
  8031b4:	e8 f6 d3 ff ff       	call   8005af <_panic>
  8031b9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	89 50 04             	mov    %edx,0x4(%eax)
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	8b 40 04             	mov    0x4(%eax),%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 0c                	je     8031db <insert_sorted_with_merge_freeList+0x2cd>
  8031cf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d7:	89 10                	mov    %edx,(%eax)
  8031d9:	eb 08                	jmp    8031e3 <insert_sorted_with_merge_freeList+0x2d5>
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	a3 38 51 80 00       	mov    %eax,0x805138
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f9:	40                   	inc    %eax
  8031fa:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031ff:	e9 53 04 00 00       	jmp    803657 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803204:	a1 38 51 80 00       	mov    0x805138,%eax
  803209:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320c:	e9 15 04 00 00       	jmp    803626 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	8b 50 08             	mov    0x8(%eax),%edx
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 40 08             	mov    0x8(%eax),%eax
  803225:	39 c2                	cmp    %eax,%edx
  803227:	0f 86 f1 03 00 00    	jbe    80361e <insert_sorted_with_merge_freeList+0x710>
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	8b 50 08             	mov    0x8(%eax),%edx
  803233:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803236:	8b 40 08             	mov    0x8(%eax),%eax
  803239:	39 c2                	cmp    %eax,%edx
  80323b:	0f 83 dd 03 00 00    	jae    80361e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	8b 50 08             	mov    0x8(%eax),%edx
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 40 0c             	mov    0xc(%eax),%eax
  80324d:	01 c2                	add    %eax,%edx
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	8b 40 08             	mov    0x8(%eax),%eax
  803255:	39 c2                	cmp    %eax,%edx
  803257:	0f 85 b9 01 00 00    	jne    803416 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	8b 50 08             	mov    0x8(%eax),%edx
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	8b 40 0c             	mov    0xc(%eax),%eax
  803269:	01 c2                	add    %eax,%edx
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	8b 40 08             	mov    0x8(%eax),%eax
  803271:	39 c2                	cmp    %eax,%edx
  803273:	0f 85 0d 01 00 00    	jne    803386 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 50 0c             	mov    0xc(%eax),%edx
  80327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803282:	8b 40 0c             	mov    0xc(%eax),%eax
  803285:	01 c2                	add    %eax,%edx
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80328d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803291:	75 17                	jne    8032aa <insert_sorted_with_merge_freeList+0x39c>
  803293:	83 ec 04             	sub    $0x4,%esp
  803296:	68 44 46 80 00       	push   $0x804644
  80329b:	68 5c 01 00 00       	push   $0x15c
  8032a0:	68 9b 45 80 00       	push   $0x80459b
  8032a5:	e8 05 d3 ff ff       	call   8005af <_panic>
  8032aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	74 10                	je     8032c3 <insert_sorted_with_merge_freeList+0x3b5>
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032bb:	8b 52 04             	mov    0x4(%edx),%edx
  8032be:	89 50 04             	mov    %edx,0x4(%eax)
  8032c1:	eb 0b                	jmp    8032ce <insert_sorted_with_merge_freeList+0x3c0>
  8032c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c6:	8b 40 04             	mov    0x4(%eax),%eax
  8032c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	8b 40 04             	mov    0x4(%eax),%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	74 0f                	je     8032e7 <insert_sorted_with_merge_freeList+0x3d9>
  8032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032db:	8b 40 04             	mov    0x4(%eax),%eax
  8032de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e1:	8b 12                	mov    (%edx),%edx
  8032e3:	89 10                	mov    %edx,(%eax)
  8032e5:	eb 0a                	jmp    8032f1 <insert_sorted_with_merge_freeList+0x3e3>
  8032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ea:	8b 00                	mov    (%eax),%eax
  8032ec:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803304:	a1 44 51 80 00       	mov    0x805144,%eax
  803309:	48                   	dec    %eax
  80330a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80330f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803312:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803323:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803327:	75 17                	jne    803340 <insert_sorted_with_merge_freeList+0x432>
  803329:	83 ec 04             	sub    $0x4,%esp
  80332c:	68 78 45 80 00       	push   $0x804578
  803331:	68 5f 01 00 00       	push   $0x15f
  803336:	68 9b 45 80 00       	push   $0x80459b
  80333b:	e8 6f d2 ff ff       	call   8005af <_panic>
  803340:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803346:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 0d                	je     803361 <insert_sorted_with_merge_freeList+0x453>
  803354:	a1 48 51 80 00       	mov    0x805148,%eax
  803359:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335c:	89 50 04             	mov    %edx,0x4(%eax)
  80335f:	eb 08                	jmp    803369 <insert_sorted_with_merge_freeList+0x45b>
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803369:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336c:	a3 48 51 80 00       	mov    %eax,0x805148
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337b:	a1 54 51 80 00       	mov    0x805154,%eax
  803380:	40                   	inc    %eax
  803381:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	8b 50 0c             	mov    0xc(%eax),%edx
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	8b 40 0c             	mov    0xc(%eax),%eax
  803392:	01 c2                	add    %eax,%edx
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b2:	75 17                	jne    8033cb <insert_sorted_with_merge_freeList+0x4bd>
  8033b4:	83 ec 04             	sub    $0x4,%esp
  8033b7:	68 78 45 80 00       	push   $0x804578
  8033bc:	68 64 01 00 00       	push   $0x164
  8033c1:	68 9b 45 80 00       	push   $0x80459b
  8033c6:	e8 e4 d1 ff ff       	call   8005af <_panic>
  8033cb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	89 10                	mov    %edx,(%eax)
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	8b 00                	mov    (%eax),%eax
  8033db:	85 c0                	test   %eax,%eax
  8033dd:	74 0d                	je     8033ec <insert_sorted_with_merge_freeList+0x4de>
  8033df:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ea:	eb 08                	jmp    8033f4 <insert_sorted_with_merge_freeList+0x4e6>
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803406:	a1 54 51 80 00       	mov    0x805154,%eax
  80340b:	40                   	inc    %eax
  80340c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803411:	e9 41 02 00 00       	jmp    803657 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	8b 50 08             	mov    0x8(%eax),%edx
  80341c:	8b 45 08             	mov    0x8(%ebp),%eax
  80341f:	8b 40 0c             	mov    0xc(%eax),%eax
  803422:	01 c2                	add    %eax,%edx
  803424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803427:	8b 40 08             	mov    0x8(%eax),%eax
  80342a:	39 c2                	cmp    %eax,%edx
  80342c:	0f 85 7c 01 00 00    	jne    8035ae <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803432:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803436:	74 06                	je     80343e <insert_sorted_with_merge_freeList+0x530>
  803438:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343c:	75 17                	jne    803455 <insert_sorted_with_merge_freeList+0x547>
  80343e:	83 ec 04             	sub    $0x4,%esp
  803441:	68 b4 45 80 00       	push   $0x8045b4
  803446:	68 69 01 00 00       	push   $0x169
  80344b:	68 9b 45 80 00       	push   $0x80459b
  803450:	e8 5a d1 ff ff       	call   8005af <_panic>
  803455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803458:	8b 50 04             	mov    0x4(%eax),%edx
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	89 50 04             	mov    %edx,0x4(%eax)
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803467:	89 10                	mov    %edx,(%eax)
  803469:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346c:	8b 40 04             	mov    0x4(%eax),%eax
  80346f:	85 c0                	test   %eax,%eax
  803471:	74 0d                	je     803480 <insert_sorted_with_merge_freeList+0x572>
  803473:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803476:	8b 40 04             	mov    0x4(%eax),%eax
  803479:	8b 55 08             	mov    0x8(%ebp),%edx
  80347c:	89 10                	mov    %edx,(%eax)
  80347e:	eb 08                	jmp    803488 <insert_sorted_with_merge_freeList+0x57a>
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	a3 38 51 80 00       	mov    %eax,0x805138
  803488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348b:	8b 55 08             	mov    0x8(%ebp),%edx
  80348e:	89 50 04             	mov    %edx,0x4(%eax)
  803491:	a1 44 51 80 00       	mov    0x805144,%eax
  803496:	40                   	inc    %eax
  803497:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	8b 50 0c             	mov    0xc(%eax),%edx
  8034a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a8:	01 c2                	add    %eax,%edx
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8034b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034b4:	75 17                	jne    8034cd <insert_sorted_with_merge_freeList+0x5bf>
  8034b6:	83 ec 04             	sub    $0x4,%esp
  8034b9:	68 44 46 80 00       	push   $0x804644
  8034be:	68 6b 01 00 00       	push   $0x16b
  8034c3:	68 9b 45 80 00       	push   $0x80459b
  8034c8:	e8 e2 d0 ff ff       	call   8005af <_panic>
  8034cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d0:	8b 00                	mov    (%eax),%eax
  8034d2:	85 c0                	test   %eax,%eax
  8034d4:	74 10                	je     8034e6 <insert_sorted_with_merge_freeList+0x5d8>
  8034d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d9:	8b 00                	mov    (%eax),%eax
  8034db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034de:	8b 52 04             	mov    0x4(%edx),%edx
  8034e1:	89 50 04             	mov    %edx,0x4(%eax)
  8034e4:	eb 0b                	jmp    8034f1 <insert_sorted_with_merge_freeList+0x5e3>
  8034e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e9:	8b 40 04             	mov    0x4(%eax),%eax
  8034ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f4:	8b 40 04             	mov    0x4(%eax),%eax
  8034f7:	85 c0                	test   %eax,%eax
  8034f9:	74 0f                	je     80350a <insert_sorted_with_merge_freeList+0x5fc>
  8034fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fe:	8b 40 04             	mov    0x4(%eax),%eax
  803501:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803504:	8b 12                	mov    (%edx),%edx
  803506:	89 10                	mov    %edx,(%eax)
  803508:	eb 0a                	jmp    803514 <insert_sorted_with_merge_freeList+0x606>
  80350a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350d:	8b 00                	mov    (%eax),%eax
  80350f:	a3 38 51 80 00       	mov    %eax,0x805138
  803514:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803517:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803520:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803527:	a1 44 51 80 00       	mov    0x805144,%eax
  80352c:	48                   	dec    %eax
  80352d:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803535:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80353c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803546:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80354a:	75 17                	jne    803563 <insert_sorted_with_merge_freeList+0x655>
  80354c:	83 ec 04             	sub    $0x4,%esp
  80354f:	68 78 45 80 00       	push   $0x804578
  803554:	68 6e 01 00 00       	push   $0x16e
  803559:	68 9b 45 80 00       	push   $0x80459b
  80355e:	e8 4c d0 ff ff       	call   8005af <_panic>
  803563:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803569:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356c:	89 10                	mov    %edx,(%eax)
  80356e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803571:	8b 00                	mov    (%eax),%eax
  803573:	85 c0                	test   %eax,%eax
  803575:	74 0d                	je     803584 <insert_sorted_with_merge_freeList+0x676>
  803577:	a1 48 51 80 00       	mov    0x805148,%eax
  80357c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80357f:	89 50 04             	mov    %edx,0x4(%eax)
  803582:	eb 08                	jmp    80358c <insert_sorted_with_merge_freeList+0x67e>
  803584:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803587:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80358c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358f:	a3 48 51 80 00       	mov    %eax,0x805148
  803594:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803597:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359e:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a3:	40                   	inc    %eax
  8035a4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035a9:	e9 a9 00 00 00       	jmp    803657 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8035ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b2:	74 06                	je     8035ba <insert_sorted_with_merge_freeList+0x6ac>
  8035b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b8:	75 17                	jne    8035d1 <insert_sorted_with_merge_freeList+0x6c3>
  8035ba:	83 ec 04             	sub    $0x4,%esp
  8035bd:	68 10 46 80 00       	push   $0x804610
  8035c2:	68 73 01 00 00       	push   $0x173
  8035c7:	68 9b 45 80 00       	push   $0x80459b
  8035cc:	e8 de cf ff ff       	call   8005af <_panic>
  8035d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d4:	8b 10                	mov    (%eax),%edx
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	89 10                	mov    %edx,(%eax)
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	8b 00                	mov    (%eax),%eax
  8035e0:	85 c0                	test   %eax,%eax
  8035e2:	74 0b                	je     8035ef <insert_sorted_with_merge_freeList+0x6e1>
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ec:	89 50 04             	mov    %edx,0x4(%eax)
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f5:	89 10                	mov    %edx,(%eax)
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035fd:	89 50 04             	mov    %edx,0x4(%eax)
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	85 c0                	test   %eax,%eax
  803607:	75 08                	jne    803611 <insert_sorted_with_merge_freeList+0x703>
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803611:	a1 44 51 80 00       	mov    0x805144,%eax
  803616:	40                   	inc    %eax
  803617:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80361c:	eb 39                	jmp    803657 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80361e:	a1 40 51 80 00       	mov    0x805140,%eax
  803623:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80362a:	74 07                	je     803633 <insert_sorted_with_merge_freeList+0x725>
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	8b 00                	mov    (%eax),%eax
  803631:	eb 05                	jmp    803638 <insert_sorted_with_merge_freeList+0x72a>
  803633:	b8 00 00 00 00       	mov    $0x0,%eax
  803638:	a3 40 51 80 00       	mov    %eax,0x805140
  80363d:	a1 40 51 80 00       	mov    0x805140,%eax
  803642:	85 c0                	test   %eax,%eax
  803644:	0f 85 c7 fb ff ff    	jne    803211 <insert_sorted_with_merge_freeList+0x303>
  80364a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364e:	0f 85 bd fb ff ff    	jne    803211 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803654:	eb 01                	jmp    803657 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803656:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803657:	90                   	nop
  803658:	c9                   	leave  
  803659:	c3                   	ret    

0080365a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80365a:	55                   	push   %ebp
  80365b:	89 e5                	mov    %esp,%ebp
  80365d:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803660:	8b 55 08             	mov    0x8(%ebp),%edx
  803663:	89 d0                	mov    %edx,%eax
  803665:	c1 e0 02             	shl    $0x2,%eax
  803668:	01 d0                	add    %edx,%eax
  80366a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803671:	01 d0                	add    %edx,%eax
  803673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80367a:	01 d0                	add    %edx,%eax
  80367c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803683:	01 d0                	add    %edx,%eax
  803685:	c1 e0 04             	shl    $0x4,%eax
  803688:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80368b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803692:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803695:	83 ec 0c             	sub    $0xc,%esp
  803698:	50                   	push   %eax
  803699:	e8 26 e7 ff ff       	call   801dc4 <sys_get_virtual_time>
  80369e:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8036a1:	eb 41                	jmp    8036e4 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8036a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8036a6:	83 ec 0c             	sub    $0xc,%esp
  8036a9:	50                   	push   %eax
  8036aa:	e8 15 e7 ff ff       	call   801dc4 <sys_get_virtual_time>
  8036af:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8036b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b8:	29 c2                	sub    %eax,%edx
  8036ba:	89 d0                	mov    %edx,%eax
  8036bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8036bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c5:	89 d1                	mov    %edx,%ecx
  8036c7:	29 c1                	sub    %eax,%ecx
  8036c9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8036cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036cf:	39 c2                	cmp    %eax,%edx
  8036d1:	0f 97 c0             	seta   %al
  8036d4:	0f b6 c0             	movzbl %al,%eax
  8036d7:	29 c1                	sub    %eax,%ecx
  8036d9:	89 c8                	mov    %ecx,%eax
  8036db:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8036de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8036ea:	72 b7                	jb     8036a3 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8036ec:	90                   	nop
  8036ed:	c9                   	leave  
  8036ee:	c3                   	ret    

008036ef <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8036ef:	55                   	push   %ebp
  8036f0:	89 e5                	mov    %esp,%ebp
  8036f2:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8036f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8036fc:	eb 03                	jmp    803701 <busy_wait+0x12>
  8036fe:	ff 45 fc             	incl   -0x4(%ebp)
  803701:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803704:	3b 45 08             	cmp    0x8(%ebp),%eax
  803707:	72 f5                	jb     8036fe <busy_wait+0xf>
	return i;
  803709:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80370c:	c9                   	leave  
  80370d:	c3                   	ret    
  80370e:	66 90                	xchg   %ax,%ax

00803710 <__udivdi3>:
  803710:	55                   	push   %ebp
  803711:	57                   	push   %edi
  803712:	56                   	push   %esi
  803713:	53                   	push   %ebx
  803714:	83 ec 1c             	sub    $0x1c,%esp
  803717:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80371b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80371f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803723:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803727:	89 ca                	mov    %ecx,%edx
  803729:	89 f8                	mov    %edi,%eax
  80372b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80372f:	85 f6                	test   %esi,%esi
  803731:	75 2d                	jne    803760 <__udivdi3+0x50>
  803733:	39 cf                	cmp    %ecx,%edi
  803735:	77 65                	ja     80379c <__udivdi3+0x8c>
  803737:	89 fd                	mov    %edi,%ebp
  803739:	85 ff                	test   %edi,%edi
  80373b:	75 0b                	jne    803748 <__udivdi3+0x38>
  80373d:	b8 01 00 00 00       	mov    $0x1,%eax
  803742:	31 d2                	xor    %edx,%edx
  803744:	f7 f7                	div    %edi
  803746:	89 c5                	mov    %eax,%ebp
  803748:	31 d2                	xor    %edx,%edx
  80374a:	89 c8                	mov    %ecx,%eax
  80374c:	f7 f5                	div    %ebp
  80374e:	89 c1                	mov    %eax,%ecx
  803750:	89 d8                	mov    %ebx,%eax
  803752:	f7 f5                	div    %ebp
  803754:	89 cf                	mov    %ecx,%edi
  803756:	89 fa                	mov    %edi,%edx
  803758:	83 c4 1c             	add    $0x1c,%esp
  80375b:	5b                   	pop    %ebx
  80375c:	5e                   	pop    %esi
  80375d:	5f                   	pop    %edi
  80375e:	5d                   	pop    %ebp
  80375f:	c3                   	ret    
  803760:	39 ce                	cmp    %ecx,%esi
  803762:	77 28                	ja     80378c <__udivdi3+0x7c>
  803764:	0f bd fe             	bsr    %esi,%edi
  803767:	83 f7 1f             	xor    $0x1f,%edi
  80376a:	75 40                	jne    8037ac <__udivdi3+0x9c>
  80376c:	39 ce                	cmp    %ecx,%esi
  80376e:	72 0a                	jb     80377a <__udivdi3+0x6a>
  803770:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803774:	0f 87 9e 00 00 00    	ja     803818 <__udivdi3+0x108>
  80377a:	b8 01 00 00 00       	mov    $0x1,%eax
  80377f:	89 fa                	mov    %edi,%edx
  803781:	83 c4 1c             	add    $0x1c,%esp
  803784:	5b                   	pop    %ebx
  803785:	5e                   	pop    %esi
  803786:	5f                   	pop    %edi
  803787:	5d                   	pop    %ebp
  803788:	c3                   	ret    
  803789:	8d 76 00             	lea    0x0(%esi),%esi
  80378c:	31 ff                	xor    %edi,%edi
  80378e:	31 c0                	xor    %eax,%eax
  803790:	89 fa                	mov    %edi,%edx
  803792:	83 c4 1c             	add    $0x1c,%esp
  803795:	5b                   	pop    %ebx
  803796:	5e                   	pop    %esi
  803797:	5f                   	pop    %edi
  803798:	5d                   	pop    %ebp
  803799:	c3                   	ret    
  80379a:	66 90                	xchg   %ax,%ax
  80379c:	89 d8                	mov    %ebx,%eax
  80379e:	f7 f7                	div    %edi
  8037a0:	31 ff                	xor    %edi,%edi
  8037a2:	89 fa                	mov    %edi,%edx
  8037a4:	83 c4 1c             	add    $0x1c,%esp
  8037a7:	5b                   	pop    %ebx
  8037a8:	5e                   	pop    %esi
  8037a9:	5f                   	pop    %edi
  8037aa:	5d                   	pop    %ebp
  8037ab:	c3                   	ret    
  8037ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037b1:	89 eb                	mov    %ebp,%ebx
  8037b3:	29 fb                	sub    %edi,%ebx
  8037b5:	89 f9                	mov    %edi,%ecx
  8037b7:	d3 e6                	shl    %cl,%esi
  8037b9:	89 c5                	mov    %eax,%ebp
  8037bb:	88 d9                	mov    %bl,%cl
  8037bd:	d3 ed                	shr    %cl,%ebp
  8037bf:	89 e9                	mov    %ebp,%ecx
  8037c1:	09 f1                	or     %esi,%ecx
  8037c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037c7:	89 f9                	mov    %edi,%ecx
  8037c9:	d3 e0                	shl    %cl,%eax
  8037cb:	89 c5                	mov    %eax,%ebp
  8037cd:	89 d6                	mov    %edx,%esi
  8037cf:	88 d9                	mov    %bl,%cl
  8037d1:	d3 ee                	shr    %cl,%esi
  8037d3:	89 f9                	mov    %edi,%ecx
  8037d5:	d3 e2                	shl    %cl,%edx
  8037d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037db:	88 d9                	mov    %bl,%cl
  8037dd:	d3 e8                	shr    %cl,%eax
  8037df:	09 c2                	or     %eax,%edx
  8037e1:	89 d0                	mov    %edx,%eax
  8037e3:	89 f2                	mov    %esi,%edx
  8037e5:	f7 74 24 0c          	divl   0xc(%esp)
  8037e9:	89 d6                	mov    %edx,%esi
  8037eb:	89 c3                	mov    %eax,%ebx
  8037ed:	f7 e5                	mul    %ebp
  8037ef:	39 d6                	cmp    %edx,%esi
  8037f1:	72 19                	jb     80380c <__udivdi3+0xfc>
  8037f3:	74 0b                	je     803800 <__udivdi3+0xf0>
  8037f5:	89 d8                	mov    %ebx,%eax
  8037f7:	31 ff                	xor    %edi,%edi
  8037f9:	e9 58 ff ff ff       	jmp    803756 <__udivdi3+0x46>
  8037fe:	66 90                	xchg   %ax,%ax
  803800:	8b 54 24 08          	mov    0x8(%esp),%edx
  803804:	89 f9                	mov    %edi,%ecx
  803806:	d3 e2                	shl    %cl,%edx
  803808:	39 c2                	cmp    %eax,%edx
  80380a:	73 e9                	jae    8037f5 <__udivdi3+0xe5>
  80380c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80380f:	31 ff                	xor    %edi,%edi
  803811:	e9 40 ff ff ff       	jmp    803756 <__udivdi3+0x46>
  803816:	66 90                	xchg   %ax,%ax
  803818:	31 c0                	xor    %eax,%eax
  80381a:	e9 37 ff ff ff       	jmp    803756 <__udivdi3+0x46>
  80381f:	90                   	nop

00803820 <__umoddi3>:
  803820:	55                   	push   %ebp
  803821:	57                   	push   %edi
  803822:	56                   	push   %esi
  803823:	53                   	push   %ebx
  803824:	83 ec 1c             	sub    $0x1c,%esp
  803827:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80382b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80382f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803833:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803837:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80383b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80383f:	89 f3                	mov    %esi,%ebx
  803841:	89 fa                	mov    %edi,%edx
  803843:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803847:	89 34 24             	mov    %esi,(%esp)
  80384a:	85 c0                	test   %eax,%eax
  80384c:	75 1a                	jne    803868 <__umoddi3+0x48>
  80384e:	39 f7                	cmp    %esi,%edi
  803850:	0f 86 a2 00 00 00    	jbe    8038f8 <__umoddi3+0xd8>
  803856:	89 c8                	mov    %ecx,%eax
  803858:	89 f2                	mov    %esi,%edx
  80385a:	f7 f7                	div    %edi
  80385c:	89 d0                	mov    %edx,%eax
  80385e:	31 d2                	xor    %edx,%edx
  803860:	83 c4 1c             	add    $0x1c,%esp
  803863:	5b                   	pop    %ebx
  803864:	5e                   	pop    %esi
  803865:	5f                   	pop    %edi
  803866:	5d                   	pop    %ebp
  803867:	c3                   	ret    
  803868:	39 f0                	cmp    %esi,%eax
  80386a:	0f 87 ac 00 00 00    	ja     80391c <__umoddi3+0xfc>
  803870:	0f bd e8             	bsr    %eax,%ebp
  803873:	83 f5 1f             	xor    $0x1f,%ebp
  803876:	0f 84 ac 00 00 00    	je     803928 <__umoddi3+0x108>
  80387c:	bf 20 00 00 00       	mov    $0x20,%edi
  803881:	29 ef                	sub    %ebp,%edi
  803883:	89 fe                	mov    %edi,%esi
  803885:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803889:	89 e9                	mov    %ebp,%ecx
  80388b:	d3 e0                	shl    %cl,%eax
  80388d:	89 d7                	mov    %edx,%edi
  80388f:	89 f1                	mov    %esi,%ecx
  803891:	d3 ef                	shr    %cl,%edi
  803893:	09 c7                	or     %eax,%edi
  803895:	89 e9                	mov    %ebp,%ecx
  803897:	d3 e2                	shl    %cl,%edx
  803899:	89 14 24             	mov    %edx,(%esp)
  80389c:	89 d8                	mov    %ebx,%eax
  80389e:	d3 e0                	shl    %cl,%eax
  8038a0:	89 c2                	mov    %eax,%edx
  8038a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038a6:	d3 e0                	shl    %cl,%eax
  8038a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038b0:	89 f1                	mov    %esi,%ecx
  8038b2:	d3 e8                	shr    %cl,%eax
  8038b4:	09 d0                	or     %edx,%eax
  8038b6:	d3 eb                	shr    %cl,%ebx
  8038b8:	89 da                	mov    %ebx,%edx
  8038ba:	f7 f7                	div    %edi
  8038bc:	89 d3                	mov    %edx,%ebx
  8038be:	f7 24 24             	mull   (%esp)
  8038c1:	89 c6                	mov    %eax,%esi
  8038c3:	89 d1                	mov    %edx,%ecx
  8038c5:	39 d3                	cmp    %edx,%ebx
  8038c7:	0f 82 87 00 00 00    	jb     803954 <__umoddi3+0x134>
  8038cd:	0f 84 91 00 00 00    	je     803964 <__umoddi3+0x144>
  8038d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038d7:	29 f2                	sub    %esi,%edx
  8038d9:	19 cb                	sbb    %ecx,%ebx
  8038db:	89 d8                	mov    %ebx,%eax
  8038dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038e1:	d3 e0                	shl    %cl,%eax
  8038e3:	89 e9                	mov    %ebp,%ecx
  8038e5:	d3 ea                	shr    %cl,%edx
  8038e7:	09 d0                	or     %edx,%eax
  8038e9:	89 e9                	mov    %ebp,%ecx
  8038eb:	d3 eb                	shr    %cl,%ebx
  8038ed:	89 da                	mov    %ebx,%edx
  8038ef:	83 c4 1c             	add    $0x1c,%esp
  8038f2:	5b                   	pop    %ebx
  8038f3:	5e                   	pop    %esi
  8038f4:	5f                   	pop    %edi
  8038f5:	5d                   	pop    %ebp
  8038f6:	c3                   	ret    
  8038f7:	90                   	nop
  8038f8:	89 fd                	mov    %edi,%ebp
  8038fa:	85 ff                	test   %edi,%edi
  8038fc:	75 0b                	jne    803909 <__umoddi3+0xe9>
  8038fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803903:	31 d2                	xor    %edx,%edx
  803905:	f7 f7                	div    %edi
  803907:	89 c5                	mov    %eax,%ebp
  803909:	89 f0                	mov    %esi,%eax
  80390b:	31 d2                	xor    %edx,%edx
  80390d:	f7 f5                	div    %ebp
  80390f:	89 c8                	mov    %ecx,%eax
  803911:	f7 f5                	div    %ebp
  803913:	89 d0                	mov    %edx,%eax
  803915:	e9 44 ff ff ff       	jmp    80385e <__umoddi3+0x3e>
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	89 c8                	mov    %ecx,%eax
  80391e:	89 f2                	mov    %esi,%edx
  803920:	83 c4 1c             	add    $0x1c,%esp
  803923:	5b                   	pop    %ebx
  803924:	5e                   	pop    %esi
  803925:	5f                   	pop    %edi
  803926:	5d                   	pop    %ebp
  803927:	c3                   	ret    
  803928:	3b 04 24             	cmp    (%esp),%eax
  80392b:	72 06                	jb     803933 <__umoddi3+0x113>
  80392d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803931:	77 0f                	ja     803942 <__umoddi3+0x122>
  803933:	89 f2                	mov    %esi,%edx
  803935:	29 f9                	sub    %edi,%ecx
  803937:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80393b:	89 14 24             	mov    %edx,(%esp)
  80393e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803942:	8b 44 24 04          	mov    0x4(%esp),%eax
  803946:	8b 14 24             	mov    (%esp),%edx
  803949:	83 c4 1c             	add    $0x1c,%esp
  80394c:	5b                   	pop    %ebx
  80394d:	5e                   	pop    %esi
  80394e:	5f                   	pop    %edi
  80394f:	5d                   	pop    %ebp
  803950:	c3                   	ret    
  803951:	8d 76 00             	lea    0x0(%esi),%esi
  803954:	2b 04 24             	sub    (%esp),%eax
  803957:	19 fa                	sbb    %edi,%edx
  803959:	89 d1                	mov    %edx,%ecx
  80395b:	89 c6                	mov    %eax,%esi
  80395d:	e9 71 ff ff ff       	jmp    8038d3 <__umoddi3+0xb3>
  803962:	66 90                	xchg   %ax,%ax
  803964:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803968:	72 ea                	jb     803954 <__umoddi3+0x134>
  80396a:	89 d9                	mov    %ebx,%ecx
  80396c:	e9 62 ff ff ff       	jmp    8038d3 <__umoddi3+0xb3>
