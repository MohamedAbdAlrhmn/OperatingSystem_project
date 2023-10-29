
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
  80008d:	68 00 3b 80 00       	push   $0x803b00
  800092:	6a 12                	push   $0x12
  800094:	68 1c 3b 80 00       	push   $0x803b1c
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 3c 3b 80 00       	push   $0x803b3c
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 70 3b 80 00       	push   $0x803b70
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 cc 3b 80 00       	push   $0x803bcc
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 fc 1d 00 00       	call   801ecf <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 00 3c 80 00       	push   $0x803c00
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
  8000ff:	68 41 3c 80 00       	push   $0x803c41
  800104:	e8 71 1d 00 00       	call   801e7a <sys_create_env>
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
  800128:	68 41 3c 80 00       	push   $0x803c41
  80012d:	e8 48 1d 00 00       	call   801e7a <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 cb 1a 00 00       	call   801c08 <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 4f 3c 80 00       	push   $0x803c4f
  80014f:	e8 e2 17 00 00       	call   801936 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 54 3c 80 00       	push   $0x803c54
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 74 3c 80 00       	push   $0x803c74
  80017b:	6a 26                	push   $0x26
  80017d:	68 1c 3b 80 00       	push   $0x803b1c
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 79 1a 00 00       	call   801c08 <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 e0 3c 80 00       	push   $0x803ce0
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 1c 3b 80 00       	push   $0x803b1c
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 15 1e 00 00       	call   801fc6 <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 dc 1c 00 00       	call   801e98 <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 ce 1c 00 00       	call   801e98 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 5e 3d 80 00       	push   $0x803d5e
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 e0 35 00 00       	call   8037ca <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 4e 1e 00 00       	call   802040 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 75 3d 80 00       	push   $0x803d75
  8001ff:	6a 33                	push   $0x33
  800201:	68 1c 3b 80 00       	push   $0x803b1c
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 92 18 00 00       	call   801aa8 <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 84 3d 80 00       	push   $0x803d84
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 da 19 00 00       	call   801c08 <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 a4 3d 80 00       	push   $0x803da4
  800248:	6a 38                	push   $0x38
  80024a:	68 1c 3b 80 00       	push   $0x803b1c
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 d4 3d 80 00       	push   $0x803dd4
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 f8 3d 80 00       	push   $0x803df8
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
  80028d:	68 28 3e 80 00       	push   $0x803e28
  800292:	e8 e3 1b 00 00       	call   801e7a <sys_create_env>
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
  8002b6:	68 38 3e 80 00       	push   $0x803e38
  8002bb:	e8 ba 1b 00 00       	call   801e7a <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 48 3e 80 00       	push   $0x803e48
  8002d5:	e8 5c 16 00 00       	call   801936 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 4c 3e 80 00       	push   $0x803e4c
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 4f 3c 80 00       	push   $0x803c4f
  8002ff:	e8 32 16 00 00       	call   801936 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 54 3c 80 00       	push   $0x803c54
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 a7 1c 00 00       	call   801fc6 <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 6e 1b 00 00       	call   801e98 <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 60 1b 00 00       	call   801e98 <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 82 34 00 00       	call   8037ca <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 b8 18 00 00       	call   801c08 <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 4a 17 00 00       	call   801aa8 <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 6c 3e 80 00       	push   $0x803e6c
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 2c 17 00 00       	call   801aa8 <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 82 3e 80 00       	push   $0x803e82
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 74 18 00 00       	call   801c08 <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 98 3e 80 00       	push   $0x803e98
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 1c 3b 80 00       	push   $0x803b1c
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 67 1c 00 00       	call   802026 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 3d 3f 80 00       	push   $0x803f3d
  8003cb:	e8 66 15 00 00       	call   801936 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 1d 1b 00 00       	call   801f01 <sys_getparentenvid>
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
  8003fa:	68 4d 3f 80 00       	push   $0x803f4d
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 a2 1a 00 00       	call   801eb4 <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 94 1a 00 00       	call   801eb4 <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 86 1a 00 00       	call   801eb4 <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 78 1a 00 00       	call   801eb4 <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 b6 1a 00 00       	call   801f01 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 53 3f 80 00       	push   $0x803f53
  800453:	50                   	push   %eax
  800454:	e8 8b 15 00 00       	call   8019e4 <sget>
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
  800479:	e8 6a 1a 00 00       	call   801ee8 <sys_getenvindex>
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
  8004e4:	e8 0c 18 00 00       	call   801cf5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 7c 3f 80 00       	push   $0x803f7c
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
  800514:	68 a4 3f 80 00       	push   $0x803fa4
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
  800545:	68 cc 3f 80 00       	push   $0x803fcc
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 24 40 80 00       	push   $0x804024
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 7c 3f 80 00       	push   $0x803f7c
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 8c 17 00 00       	call   801d0f <sys_enable_interrupt>

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
  800596:	e8 19 19 00 00       	call   801eb4 <sys_destroy_env>
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
  8005a7:	e8 6e 19 00 00       	call   801f1a <sys_exit_env>
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
  8005d0:	68 38 40 80 00       	push   $0x804038
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 3d 40 80 00       	push   $0x80403d
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
  80060d:	68 59 40 80 00       	push   $0x804059
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
  800639:	68 5c 40 80 00       	push   $0x80405c
  80063e:	6a 26                	push   $0x26
  800640:	68 a8 40 80 00       	push   $0x8040a8
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
  80070b:	68 b4 40 80 00       	push   $0x8040b4
  800710:	6a 3a                	push   $0x3a
  800712:	68 a8 40 80 00       	push   $0x8040a8
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
  80077b:	68 08 41 80 00       	push   $0x804108
  800780:	6a 44                	push   $0x44
  800782:	68 a8 40 80 00       	push   $0x8040a8
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
  8007d5:	e8 6d 13 00 00       	call   801b47 <sys_cputs>
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
  80084c:	e8 f6 12 00 00       	call   801b47 <sys_cputs>
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
  800896:	e8 5a 14 00 00       	call   801cf5 <sys_disable_interrupt>
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
  8008b6:	e8 54 14 00 00       	call   801d0f <sys_enable_interrupt>
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
  800900:	e8 7b 2f 00 00       	call   803880 <__udivdi3>
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
  800950:	e8 3b 30 00 00       	call   803990 <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 74 43 80 00       	add    $0x804374,%eax
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
  800aab:	8b 04 85 98 43 80 00 	mov    0x804398(,%eax,4),%eax
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
  800b8c:	8b 34 9d e0 41 80 00 	mov    0x8041e0(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 85 43 80 00       	push   $0x804385
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
  800bb1:	68 8e 43 80 00       	push   $0x80438e
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
  800bde:	be 91 43 80 00       	mov    $0x804391,%esi
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
  801604:	68 f0 44 80 00       	push   $0x8044f0
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
  8016d4:	e8 b2 05 00 00       	call   801c8b <sys_allocate_chunk>
  8016d9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016dc:	a1 20 51 80 00       	mov    0x805120,%eax
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	50                   	push   %eax
  8016e5:	e8 27 0c 00 00       	call   802311 <initialize_MemBlocksList>
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
  801712:	68 15 45 80 00       	push   $0x804515
  801717:	6a 33                	push   $0x33
  801719:	68 33 45 80 00       	push   $0x804533
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
  801791:	68 40 45 80 00       	push   $0x804540
  801796:	6a 34                	push   $0x34
  801798:	68 33 45 80 00       	push   $0x804533
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
  801829:	e8 2b 08 00 00       	call   802059 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80182e:	85 c0                	test   %eax,%eax
  801830:	74 11                	je     801843 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	ff 75 e8             	pushl  -0x18(%ebp)
  801838:	e8 96 0e 00 00       	call   8026d3 <alloc_block_FF>
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
  80184f:	e8 f2 0b 00 00       	call   802446 <insert_sorted_allocList>
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
  801869:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	83 ec 08             	sub    $0x8,%esp
  801872:	50                   	push   %eax
  801873:	68 40 50 80 00       	push   $0x805040
  801878:	e8 71 0b 00 00       	call   8023ee <find_block>
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801887:	0f 84 a6 00 00 00    	je     801933 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  80188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801890:	8b 50 0c             	mov    0xc(%eax),%edx
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	8b 40 08             	mov    0x8(%eax),%eax
  801899:	83 ec 08             	sub    $0x8,%esp
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	e8 b0 03 00 00       	call   801c53 <sys_free_user_mem>
  8018a3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8018a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018aa:	75 14                	jne    8018c0 <free+0x5a>
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	68 15 45 80 00       	push   $0x804515
  8018b4:	6a 74                	push   $0x74
  8018b6:	68 33 45 80 00       	push   $0x804533
  8018bb:	e8 ef ec ff ff       	call   8005af <_panic>
  8018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c3:	8b 00                	mov    (%eax),%eax
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	74 10                	je     8018d9 <free+0x73>
  8018c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d1:	8b 52 04             	mov    0x4(%edx),%edx
  8018d4:	89 50 04             	mov    %edx,0x4(%eax)
  8018d7:	eb 0b                	jmp    8018e4 <free+0x7e>
  8018d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dc:	8b 40 04             	mov    0x4(%eax),%eax
  8018df:	a3 44 50 80 00       	mov    %eax,0x805044
  8018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e7:	8b 40 04             	mov    0x4(%eax),%eax
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	74 0f                	je     8018fd <free+0x97>
  8018ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f1:	8b 40 04             	mov    0x4(%eax),%eax
  8018f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f7:	8b 12                	mov    (%edx),%edx
  8018f9:	89 10                	mov    %edx,(%eax)
  8018fb:	eb 0a                	jmp    801907 <free+0xa1>
  8018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801900:	8b 00                	mov    (%eax),%eax
  801902:	a3 40 50 80 00       	mov    %eax,0x805040
  801907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80191a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80191f:	48                   	dec    %eax
  801920:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	ff 75 f4             	pushl  -0xc(%ebp)
  80192b:	e8 4e 17 00 00       	call   80307e <insert_sorted_with_merge_freeList>
  801930:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	83 ec 08             	sub    $0x8,%esp
  801872:	50                   	push   %eax
  801873:	68 40 50 80 00       	push   $0x805040
  801878:	e8 71 0b 00 00       	call   8023ee <find_block>
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801887:	0f 84 a6 00 00 00    	je     801933 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  80188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801890:	8b 50 0c             	mov    0xc(%eax),%edx
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	8b 40 08             	mov    0x8(%eax),%eax
  801899:	83 ec 08             	sub    $0x8,%esp
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	e8 b0 03 00 00       	call   801c53 <sys_free_user_mem>
  8018a3:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  8018a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018aa:	75 14                	jne    8018c0 <free+0x5a>
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	68 15 45 80 00       	push   $0x804515
  8018b4:	6a 7a                	push   $0x7a
  8018b6:	68 33 45 80 00       	push   $0x804533
  8018bb:	e8 ef ec ff ff       	call   8005af <_panic>
  8018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c3:	8b 00                	mov    (%eax),%eax
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	74 10                	je     8018d9 <free+0x73>
  8018c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d1:	8b 52 04             	mov    0x4(%edx),%edx
  8018d4:	89 50 04             	mov    %edx,0x4(%eax)
  8018d7:	eb 0b                	jmp    8018e4 <free+0x7e>
  8018d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dc:	8b 40 04             	mov    0x4(%eax),%eax
  8018df:	a3 44 50 80 00       	mov    %eax,0x805044
  8018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e7:	8b 40 04             	mov    0x4(%eax),%eax
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	74 0f                	je     8018fd <free+0x97>
  8018ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f1:	8b 40 04             	mov    0x4(%eax),%eax
  8018f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f7:	8b 12                	mov    (%edx),%edx
  8018f9:	89 10                	mov    %edx,(%eax)
  8018fb:	eb 0a                	jmp    801907 <free+0xa1>
  8018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801900:	8b 00                	mov    (%eax),%eax
  801902:	a3 40 50 80 00       	mov    %eax,0x805040
  801907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80191a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80191f:	48                   	dec    %eax
  801920:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	ff 75 f4             	pushl  -0xc(%ebp)
  80192b:	e8 4e 17 00 00       	call   80307e <insert_sorted_with_merge_freeList>
  801930:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801933:	90                   	nop
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 38             	sub    $0x38,%esp
  80193c:	8b 45 10             	mov    0x10(%ebp),%eax
  80193f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801942:	e8 a6 fc ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  801947:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80194b:	75 0a                	jne    801957 <smalloc+0x21>
  80194d:	b8 00 00 00 00       	mov    $0x0,%eax
  801952:	e9 8b 00 00 00       	jmp    8019e2 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801957:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801964:	01 d0                	add    %edx,%eax
  801966:	48                   	dec    %eax
  801967:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80196a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196d:	ba 00 00 00 00       	mov    $0x0,%edx
  801972:	f7 75 f0             	divl   -0x10(%ebp)
  801975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801978:	29 d0                	sub    %edx,%eax
  80197a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80197d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801984:	e8 d0 06 00 00       	call   802059 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801989:	85 c0                	test   %eax,%eax
  80198b:	74 11                	je     80199e <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80198d:	83 ec 0c             	sub    $0xc,%esp
  801990:	ff 75 e8             	pushl  -0x18(%ebp)
  801993:	e8 3b 0d 00 00       	call   8026d3 <alloc_block_FF>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80199e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019a2:	74 39                	je     8019dd <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8019a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a7:	8b 40 08             	mov    0x8(%eax),%eax
  8019aa:	89 c2                	mov    %eax,%edx
  8019ac:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019b0:	52                   	push   %edx
  8019b1:	50                   	push   %eax
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	e8 21 04 00 00       	call   801dde <sys_createSharedObject>
  8019bd:	83 c4 10             	add    $0x10,%esp
  8019c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8019c3:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8019c7:	74 14                	je     8019dd <smalloc+0xa7>
  8019c9:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8019cd:	74 0e                	je     8019dd <smalloc+0xa7>
  8019cf:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8019d3:	74 08                	je     8019dd <smalloc+0xa7>
			return (void*) mem_block->sva;
  8019d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d8:	8b 40 08             	mov    0x8(%eax),%eax
  8019db:	eb 05                	jmp    8019e2 <smalloc+0xac>
	}
	return NULL;
  8019dd:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019ea:	e8 fe fb ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019ef:	83 ec 08             	sub    $0x8,%esp
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	ff 75 08             	pushl  0x8(%ebp)
  8019f8:	e8 0b 04 00 00       	call   801e08 <sys_getSizeOfSharedObject>
  8019fd:	83 c4 10             	add    $0x10,%esp
  801a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801a03:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801a07:	74 76                	je     801a7f <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a09:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a16:	01 d0                	add    %edx,%eax
  801a18:	48                   	dec    %eax
  801a19:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a24:	f7 75 ec             	divl   -0x14(%ebp)
  801a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a2a:	29 d0                	sub    %edx,%eax
  801a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801a2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a36:	e8 1e 06 00 00       	call   802059 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	74 11                	je     801a50 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801a3f:	83 ec 0c             	sub    $0xc,%esp
  801a42:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a45:	e8 89 0c 00 00       	call   8026d3 <alloc_block_FF>
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a54:	74 29                	je     801a7f <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a59:	8b 40 08             	mov    0x8(%eax),%eax
  801a5c:	83 ec 04             	sub    $0x4,%esp
  801a5f:	50                   	push   %eax
  801a60:	ff 75 0c             	pushl  0xc(%ebp)
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	e8 ba 03 00 00       	call   801e25 <sys_getSharedObject>
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801a71:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801a75:	74 08                	je     801a7f <sget+0x9b>
				return (void *)mem_block->sva;
  801a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7a:	8b 40 08             	mov    0x8(%eax),%eax
  801a7d:	eb 05                	jmp    801a84 <sget+0xa0>
		}
	}
	return NULL;
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a8c:	e8 5c fb ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a91:	83 ec 04             	sub    $0x4,%esp
  801a94:	68 64 45 80 00       	push   $0x804564
<<<<<<< HEAD
  801a99:	68 fc 00 00 00       	push   $0xfc
=======
  801a99:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801a9e:	68 33 45 80 00       	push   $0x804533
  801aa3:	e8 07 eb ff ff       	call   8005af <_panic>

00801aa8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	68 8c 45 80 00       	push   $0x80458c
<<<<<<< HEAD
  801ab6:	68 10 01 00 00       	push   $0x110
=======
  801ab6:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801abb:	68 33 45 80 00       	push   $0x804533
  801ac0:	e8 ea ea ff ff       	call   8005af <_panic>

00801ac5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	68 b0 45 80 00       	push   $0x8045b0
<<<<<<< HEAD
  801ad3:	68 1b 01 00 00       	push   $0x11b
=======
  801ad3:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801ad8:	68 33 45 80 00       	push   $0x804533
  801add:	e8 cd ea ff ff       	call   8005af <_panic>

00801ae2 <shrink>:

}
void shrink(uint32 newSize)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	68 b0 45 80 00       	push   $0x8045b0
<<<<<<< HEAD
  801af0:	68 20 01 00 00       	push   $0x120
=======
  801af0:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801af5:	68 33 45 80 00       	push   $0x804533
  801afa:	e8 b0 ea ff ff       	call   8005af <_panic>

00801aff <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	68 b0 45 80 00       	push   $0x8045b0
<<<<<<< HEAD
  801b0d:	68 25 01 00 00       	push   $0x125
=======
  801b0d:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801b12:	68 33 45 80 00       	push   $0x804533
  801b17:	e8 93 ea ff ff       	call   8005af <_panic>

00801b1c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	57                   	push   %edi
  801b20:	56                   	push   %esi
  801b21:	53                   	push   %ebx
  801b22:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b2e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b31:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b34:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b37:	cd 30                	int    $0x30
  801b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5e                   	pop    %esi
  801b44:	5f                   	pop    %edi
  801b45:	5d                   	pop    %ebp
  801b46:	c3                   	ret    

00801b47 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b53:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	52                   	push   %edx
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	50                   	push   %eax
  801b63:	6a 00                	push   $0x0
  801b65:	e8 b2 ff ff ff       	call   801b1c <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	90                   	nop
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 01                	push   $0x1
  801b7f:	e8 98 ff ff ff       	call   801b1c <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 05                	push   $0x5
  801b9c:	e8 7b ff ff ff       	call   801b1c <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	56                   	push   %esi
  801baa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bab:	8b 75 18             	mov    0x18(%ebp),%esi
  801bae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	51                   	push   %ecx
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	6a 06                	push   $0x6
  801bc1:	e8 56 ff ff ff       	call   801b1c <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5e                   	pop    %esi
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    

00801bd0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	52                   	push   %edx
  801be0:	50                   	push   %eax
  801be1:	6a 07                	push   $0x7
  801be3:	e8 34 ff ff ff       	call   801b1c <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	ff 75 08             	pushl  0x8(%ebp)
  801bfc:	6a 08                	push   $0x8
  801bfe:	e8 19 ff ff ff       	call   801b1c <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 09                	push   $0x9
  801c17:	e8 00 ff ff ff       	call   801b1c <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 0a                	push   $0xa
  801c30:	e8 e7 fe ff ff       	call   801b1c <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 0b                	push   $0xb
  801c49:	e8 ce fe ff ff       	call   801b1c <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	ff 75 0c             	pushl  0xc(%ebp)
  801c5f:	ff 75 08             	pushl  0x8(%ebp)
  801c62:	6a 0f                	push   $0xf
  801c64:	e8 b3 fe ff ff       	call   801b1c <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
	return;
  801c6c:	90                   	nop
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	ff 75 08             	pushl  0x8(%ebp)
  801c7e:	6a 10                	push   $0x10
  801c80:	e8 97 fe ff ff       	call   801b1c <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
	return ;
  801c88:	90                   	nop
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	ff 75 10             	pushl  0x10(%ebp)
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	6a 11                	push   $0x11
  801c9d:	e8 7a fe ff ff       	call   801b1c <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca5:	90                   	nop
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 0c                	push   $0xc
  801cb7:	e8 60 fe ff ff       	call   801b1c <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	ff 75 08             	pushl  0x8(%ebp)
  801ccf:	6a 0d                	push   $0xd
  801cd1:	e8 46 fe ff ff       	call   801b1c <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 0e                	push   $0xe
  801cea:	e8 2d fe ff ff       	call   801b1c <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	90                   	nop
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 13                	push   $0x13
  801d04:	e8 13 fe ff ff       	call   801b1c <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	90                   	nop
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 14                	push   $0x14
  801d1e:	e8 f9 fd ff ff       	call   801b1c <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	90                   	nop
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d35:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	50                   	push   %eax
  801d42:	6a 15                	push   $0x15
  801d44:	e8 d3 fd ff ff       	call   801b1c <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	90                   	nop
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 16                	push   $0x16
  801d5e:	e8 b9 fd ff ff       	call   801b1c <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	90                   	nop
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	50                   	push   %eax
  801d79:	6a 17                	push   $0x17
  801d7b:	e8 9c fd ff ff       	call   801b1c <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	52                   	push   %edx
  801d95:	50                   	push   %eax
  801d96:	6a 1a                	push   $0x1a
  801d98:	e8 7f fd ff ff       	call   801b1c <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	52                   	push   %edx
  801db2:	50                   	push   %eax
  801db3:	6a 18                	push   $0x18
  801db5:	e8 62 fd ff ff       	call   801b1c <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	90                   	nop
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	52                   	push   %edx
  801dd0:	50                   	push   %eax
  801dd1:	6a 19                	push   $0x19
  801dd3:	e8 44 fd ff ff       	call   801b1c <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
}
  801ddb:	90                   	nop
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	8b 45 10             	mov    0x10(%ebp),%eax
  801de7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ded:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	6a 00                	push   $0x0
  801df6:	51                   	push   %ecx
  801df7:	52                   	push   %edx
  801df8:	ff 75 0c             	pushl  0xc(%ebp)
  801dfb:	50                   	push   %eax
  801dfc:	6a 1b                	push   $0x1b
  801dfe:	e8 19 fd ff ff       	call   801b1c <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	52                   	push   %edx
  801e18:	50                   	push   %eax
  801e19:	6a 1c                	push   $0x1c
  801e1b:	e8 fc fc ff ff       	call   801b1c <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	51                   	push   %ecx
  801e36:	52                   	push   %edx
  801e37:	50                   	push   %eax
  801e38:	6a 1d                	push   $0x1d
  801e3a:	e8 dd fc ff ff       	call   801b1c <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	52                   	push   %edx
  801e54:	50                   	push   %eax
  801e55:	6a 1e                	push   $0x1e
  801e57:	e8 c0 fc ff ff       	call   801b1c <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 1f                	push   $0x1f
  801e70:	e8 a7 fc ff ff       	call   801b1c <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	ff 75 14             	pushl  0x14(%ebp)
  801e85:	ff 75 10             	pushl  0x10(%ebp)
  801e88:	ff 75 0c             	pushl  0xc(%ebp)
  801e8b:	50                   	push   %eax
  801e8c:	6a 20                	push   $0x20
  801e8e:	e8 89 fc ff ff       	call   801b1c <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	50                   	push   %eax
  801ea7:	6a 21                	push   $0x21
  801ea9:	e8 6e fc ff ff       	call   801b1c <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
}
  801eb1:	90                   	nop
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	50                   	push   %eax
  801ec3:	6a 22                	push   $0x22
  801ec5:	e8 52 fc ff ff       	call   801b1c <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 02                	push   $0x2
  801ede:	e8 39 fc ff ff       	call   801b1c <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 03                	push   $0x3
  801ef7:	e8 20 fc ff ff       	call   801b1c <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 04                	push   $0x4
  801f10:	e8 07 fc ff ff       	call   801b1c <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_exit_env>:


void sys_exit_env(void)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 23                	push   $0x23
  801f29:	e8 ee fb ff ff       	call   801b1c <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	90                   	nop
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f3a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f3d:	8d 50 04             	lea    0x4(%eax),%edx
  801f40:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	52                   	push   %edx
  801f4a:	50                   	push   %eax
  801f4b:	6a 24                	push   $0x24
  801f4d:	e8 ca fb ff ff       	call   801b1c <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
	return result;
  801f55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f5e:	89 01                	mov    %eax,(%ecx)
  801f60:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	c9                   	leave  
  801f67:	c2 04 00             	ret    $0x4

00801f6a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	ff 75 10             	pushl  0x10(%ebp)
  801f74:	ff 75 0c             	pushl  0xc(%ebp)
  801f77:	ff 75 08             	pushl  0x8(%ebp)
  801f7a:	6a 12                	push   $0x12
  801f7c:	e8 9b fb ff ff       	call   801b1c <syscall>
  801f81:	83 c4 18             	add    $0x18,%esp
	return ;
  801f84:	90                   	nop
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 25                	push   $0x25
  801f96:	e8 81 fb ff ff       	call   801b1c <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 04             	sub    $0x4,%esp
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fac:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	50                   	push   %eax
  801fb9:	6a 26                	push   $0x26
  801fbb:	e8 5c fb ff ff       	call   801b1c <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc3:	90                   	nop
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <rsttst>:
void rsttst()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 28                	push   $0x28
  801fd5:	e8 42 fb ff ff       	call   801b1c <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdd:	90                   	nop
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 04             	sub    $0x4,%esp
  801fe6:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fec:	8b 55 18             	mov    0x18(%ebp),%edx
  801fef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ff3:	52                   	push   %edx
  801ff4:	50                   	push   %eax
  801ff5:	ff 75 10             	pushl  0x10(%ebp)
  801ff8:	ff 75 0c             	pushl  0xc(%ebp)
  801ffb:	ff 75 08             	pushl  0x8(%ebp)
  801ffe:	6a 27                	push   $0x27
  802000:	e8 17 fb ff ff       	call   801b1c <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
	return ;
  802008:	90                   	nop
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <chktst>:
void chktst(uint32 n)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	ff 75 08             	pushl  0x8(%ebp)
  802019:	6a 29                	push   $0x29
  80201b:	e8 fc fa ff ff       	call   801b1c <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
	return ;
  802023:	90                   	nop
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <inctst>:

void inctst()
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 2a                	push   $0x2a
  802035:	e8 e2 fa ff ff       	call   801b1c <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp
	return ;
  80203d:	90                   	nop
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <gettst>:
uint32 gettst()
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 2b                	push   $0x2b
  80204f:	e8 c8 fa ff ff       	call   801b1c <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 2c                	push   $0x2c
  80206b:	e8 ac fa ff ff       	call   801b1c <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
  802073:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802076:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80207a:	75 07                	jne    802083 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80207c:	b8 01 00 00 00       	mov    $0x1,%eax
  802081:	eb 05                	jmp    802088 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 2c                	push   $0x2c
  80209c:	e8 7b fa ff ff       	call   801b1c <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
  8020a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020a7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020ab:	75 07                	jne    8020b4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b2:	eb 05                	jmp    8020b9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 2c                	push   $0x2c
  8020cd:	e8 4a fa ff ff       	call   801b1c <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
  8020d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020d8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020dc:	75 07                	jne    8020e5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020de:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e3:	eb 05                	jmp    8020ea <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 2c                	push   $0x2c
  8020fe:	e8 19 fa ff ff       	call   801b1c <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
  802106:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802109:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80210d:	75 07                	jne    802116 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80210f:	b8 01 00 00 00       	mov    $0x1,%eax
  802114:	eb 05                	jmp    80211b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	ff 75 08             	pushl  0x8(%ebp)
  80212b:	6a 2d                	push   $0x2d
  80212d:	e8 ea f9 ff ff       	call   801b1c <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
	return ;
  802135:	90                   	nop
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80213c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802142:	8b 55 0c             	mov    0xc(%ebp),%edx
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	6a 00                	push   $0x0
  80214a:	53                   	push   %ebx
  80214b:	51                   	push   %ecx
  80214c:	52                   	push   %edx
  80214d:	50                   	push   %eax
  80214e:	6a 2e                	push   $0x2e
  802150:	e8 c7 f9 ff ff       	call   801b1c <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802160:	8b 55 0c             	mov    0xc(%ebp),%edx
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	52                   	push   %edx
  80216d:	50                   	push   %eax
  80216e:	6a 2f                	push   $0x2f
  802170:	e8 a7 f9 ff ff       	call   801b1c <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802180:	83 ec 0c             	sub    $0xc,%esp
  802183:	68 c0 45 80 00       	push   $0x8045c0
  802188:	e8 d6 e6 ff ff       	call   800863 <cprintf>
  80218d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802190:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802197:	83 ec 0c             	sub    $0xc,%esp
  80219a:	68 ec 45 80 00       	push   $0x8045ec
  80219f:	e8 bf e6 ff ff       	call   800863 <cprintf>
  8021a4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021a7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021ab:	a1 38 51 80 00       	mov    0x805138,%eax
  8021b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b3:	eb 56                	jmp    80220b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b9:	74 1c                	je     8021d7 <print_mem_block_lists+0x5d>
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	8b 50 08             	mov    0x8(%eax),%edx
  8021c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c4:	8b 48 08             	mov    0x8(%eax),%ecx
  8021c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8021cd:	01 c8                	add    %ecx,%eax
  8021cf:	39 c2                	cmp    %eax,%edx
  8021d1:	73 04                	jae    8021d7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021d3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 50 08             	mov    0x8(%eax),%edx
  8021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e3:	01 c2                	add    %eax,%edx
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	8b 40 08             	mov    0x8(%eax),%eax
  8021eb:	83 ec 04             	sub    $0x4,%esp
  8021ee:	52                   	push   %edx
  8021ef:	50                   	push   %eax
  8021f0:	68 01 46 80 00       	push   $0x804601
  8021f5:	e8 69 e6 ff ff       	call   800863 <cprintf>
  8021fa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802203:	a1 40 51 80 00       	mov    0x805140,%eax
  802208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220f:	74 07                	je     802218 <print_mem_block_lists+0x9e>
  802211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802214:	8b 00                	mov    (%eax),%eax
  802216:	eb 05                	jmp    80221d <print_mem_block_lists+0xa3>
  802218:	b8 00 00 00 00       	mov    $0x0,%eax
  80221d:	a3 40 51 80 00       	mov    %eax,0x805140
  802222:	a1 40 51 80 00       	mov    0x805140,%eax
  802227:	85 c0                	test   %eax,%eax
  802229:	75 8a                	jne    8021b5 <print_mem_block_lists+0x3b>
  80222b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222f:	75 84                	jne    8021b5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802231:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802235:	75 10                	jne    802247 <print_mem_block_lists+0xcd>
  802237:	83 ec 0c             	sub    $0xc,%esp
  80223a:	68 10 46 80 00       	push   $0x804610
  80223f:	e8 1f e6 ff ff       	call   800863 <cprintf>
  802244:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802247:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80224e:	83 ec 0c             	sub    $0xc,%esp
  802251:	68 34 46 80 00       	push   $0x804634
  802256:	e8 08 e6 ff ff       	call   800863 <cprintf>
  80225b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80225e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802262:	a1 40 50 80 00       	mov    0x805040,%eax
  802267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226a:	eb 56                	jmp    8022c2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80226c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802270:	74 1c                	je     80228e <print_mem_block_lists+0x114>
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 50 08             	mov    0x8(%eax),%edx
  802278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227b:	8b 48 08             	mov    0x8(%eax),%ecx
  80227e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802281:	8b 40 0c             	mov    0xc(%eax),%eax
  802284:	01 c8                	add    %ecx,%eax
  802286:	39 c2                	cmp    %eax,%edx
  802288:	73 04                	jae    80228e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80228a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	8b 50 08             	mov    0x8(%eax),%edx
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 40 0c             	mov    0xc(%eax),%eax
  80229a:	01 c2                	add    %eax,%edx
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 40 08             	mov    0x8(%eax),%eax
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	52                   	push   %edx
  8022a6:	50                   	push   %eax
  8022a7:	68 01 46 80 00       	push   $0x804601
  8022ac:	e8 b2 e5 ff ff       	call   800863 <cprintf>
  8022b1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022ba:	a1 48 50 80 00       	mov    0x805048,%eax
  8022bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c6:	74 07                	je     8022cf <print_mem_block_lists+0x155>
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 00                	mov    (%eax),%eax
  8022cd:	eb 05                	jmp    8022d4 <print_mem_block_lists+0x15a>
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d4:	a3 48 50 80 00       	mov    %eax,0x805048
  8022d9:	a1 48 50 80 00       	mov    0x805048,%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	75 8a                	jne    80226c <print_mem_block_lists+0xf2>
  8022e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e6:	75 84                	jne    80226c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022e8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022ec:	75 10                	jne    8022fe <print_mem_block_lists+0x184>
  8022ee:	83 ec 0c             	sub    $0xc,%esp
  8022f1:	68 4c 46 80 00       	push   $0x80464c
  8022f6:	e8 68 e5 ff ff       	call   800863 <cprintf>
  8022fb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022fe:	83 ec 0c             	sub    $0xc,%esp
  802301:	68 c0 45 80 00       	push   $0x8045c0
  802306:	e8 58 e5 ff ff       	call   800863 <cprintf>
  80230b:	83 c4 10             	add    $0x10,%esp

}
  80230e:	90                   	nop
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802317:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80231e:	00 00 00 
  802321:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802328:	00 00 00 
  80232b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802332:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802335:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80233c:	e9 9e 00 00 00       	jmp    8023df <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802341:	a1 50 50 80 00       	mov    0x805050,%eax
  802346:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802349:	c1 e2 04             	shl    $0x4,%edx
  80234c:	01 d0                	add    %edx,%eax
  80234e:	85 c0                	test   %eax,%eax
  802350:	75 14                	jne    802366 <initialize_MemBlocksList+0x55>
  802352:	83 ec 04             	sub    $0x4,%esp
  802355:	68 74 46 80 00       	push   $0x804674
  80235a:	6a 46                	push   $0x46
  80235c:	68 97 46 80 00       	push   $0x804697
  802361:	e8 49 e2 ff ff       	call   8005af <_panic>
  802366:	a1 50 50 80 00       	mov    0x805050,%eax
  80236b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236e:	c1 e2 04             	shl    $0x4,%edx
  802371:	01 d0                	add    %edx,%eax
  802373:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802379:	89 10                	mov    %edx,(%eax)
  80237b:	8b 00                	mov    (%eax),%eax
  80237d:	85 c0                	test   %eax,%eax
  80237f:	74 18                	je     802399 <initialize_MemBlocksList+0x88>
  802381:	a1 48 51 80 00       	mov    0x805148,%eax
  802386:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80238c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80238f:	c1 e1 04             	shl    $0x4,%ecx
  802392:	01 ca                	add    %ecx,%edx
  802394:	89 50 04             	mov    %edx,0x4(%eax)
  802397:	eb 12                	jmp    8023ab <initialize_MemBlocksList+0x9a>
  802399:	a1 50 50 80 00       	mov    0x805050,%eax
  80239e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a1:	c1 e2 04             	shl    $0x4,%edx
  8023a4:	01 d0                	add    %edx,%eax
  8023a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8023b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b3:	c1 e2 04             	shl    $0x4,%edx
  8023b6:	01 d0                	add    %edx,%eax
  8023b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8023bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c5:	c1 e2 04             	shl    $0x4,%edx
  8023c8:	01 d0                	add    %edx,%eax
  8023ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d1:	a1 54 51 80 00       	mov    0x805154,%eax
  8023d6:	40                   	inc    %eax
  8023d7:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8023dc:	ff 45 f4             	incl   -0xc(%ebp)
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e5:	0f 82 56 ff ff ff    	jb     802341 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8023eb:	90                   	nop
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023fc:	eb 19                	jmp    802417 <find_block+0x29>
	{
		if(va==point->sva)
  8023fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802401:	8b 40 08             	mov    0x8(%eax),%eax
  802404:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802407:	75 05                	jne    80240e <find_block+0x20>
		   return point;
  802409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80240c:	eb 36                	jmp    802444 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	8b 40 08             	mov    0x8(%eax),%eax
  802414:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802417:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80241b:	74 07                	je     802424 <find_block+0x36>
  80241d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802420:	8b 00                	mov    (%eax),%eax
  802422:	eb 05                	jmp    802429 <find_block+0x3b>
  802424:	b8 00 00 00 00       	mov    $0x0,%eax
  802429:	8b 55 08             	mov    0x8(%ebp),%edx
  80242c:	89 42 08             	mov    %eax,0x8(%edx)
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	8b 40 08             	mov    0x8(%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	75 c5                	jne    8023fe <find_block+0x10>
  802439:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80243d:	75 bf                	jne    8023fe <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80243f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
  802449:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80244c:	a1 40 50 80 00       	mov    0x805040,%eax
  802451:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802454:	a1 44 50 80 00       	mov    0x805044,%eax
  802459:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80245c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802462:	74 24                	je     802488 <insert_sorted_allocList+0x42>
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	8b 50 08             	mov    0x8(%eax),%edx
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246d:	8b 40 08             	mov    0x8(%eax),%eax
  802470:	39 c2                	cmp    %eax,%edx
  802472:	76 14                	jbe    802488 <insert_sorted_allocList+0x42>
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	8b 50 08             	mov    0x8(%eax),%edx
  80247a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247d:	8b 40 08             	mov    0x8(%eax),%eax
  802480:	39 c2                	cmp    %eax,%edx
  802482:	0f 82 60 01 00 00    	jb     8025e8 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80248c:	75 65                	jne    8024f3 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80248e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802492:	75 14                	jne    8024a8 <insert_sorted_allocList+0x62>
  802494:	83 ec 04             	sub    $0x4,%esp
  802497:	68 74 46 80 00       	push   $0x804674
  80249c:	6a 6b                	push   $0x6b
  80249e:	68 97 46 80 00       	push   $0x804697
  8024a3:	e8 07 e1 ff ff       	call   8005af <_panic>
  8024a8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b1:	89 10                	mov    %edx,(%eax)
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 0d                	je     8024c9 <insert_sorted_allocList+0x83>
  8024bc:	a1 40 50 80 00       	mov    0x805040,%eax
  8024c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c4:	89 50 04             	mov    %edx,0x4(%eax)
  8024c7:	eb 08                	jmp    8024d1 <insert_sorted_allocList+0x8b>
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	a3 44 50 80 00       	mov    %eax,0x805044
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	a3 40 50 80 00       	mov    %eax,0x805040
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024e8:	40                   	inc    %eax
  8024e9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ee:	e9 dc 01 00 00       	jmp    8026cf <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	8b 50 08             	mov    0x8(%eax),%edx
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 40 08             	mov    0x8(%eax),%eax
  8024ff:	39 c2                	cmp    %eax,%edx
  802501:	77 6c                	ja     80256f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802503:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802507:	74 06                	je     80250f <insert_sorted_allocList+0xc9>
  802509:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250d:	75 14                	jne    802523 <insert_sorted_allocList+0xdd>
  80250f:	83 ec 04             	sub    $0x4,%esp
  802512:	68 b0 46 80 00       	push   $0x8046b0
  802517:	6a 6f                	push   $0x6f
  802519:	68 97 46 80 00       	push   $0x804697
  80251e:	e8 8c e0 ff ff       	call   8005af <_panic>
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	8b 50 04             	mov    0x4(%eax),%edx
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	89 50 04             	mov    %edx,0x4(%eax)
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802535:	89 10                	mov    %edx,(%eax)
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	8b 40 04             	mov    0x4(%eax),%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 0d                	je     80254e <insert_sorted_allocList+0x108>
  802541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802544:	8b 40 04             	mov    0x4(%eax),%eax
  802547:	8b 55 08             	mov    0x8(%ebp),%edx
  80254a:	89 10                	mov    %edx,(%eax)
  80254c:	eb 08                	jmp    802556 <insert_sorted_allocList+0x110>
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	a3 40 50 80 00       	mov    %eax,0x805040
  802556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802559:	8b 55 08             	mov    0x8(%ebp),%edx
  80255c:	89 50 04             	mov    %edx,0x4(%eax)
  80255f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802564:	40                   	inc    %eax
  802565:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80256a:	e9 60 01 00 00       	jmp    8026cf <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	8b 50 08             	mov    0x8(%eax),%edx
  802575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802578:	8b 40 08             	mov    0x8(%eax),%eax
  80257b:	39 c2                	cmp    %eax,%edx
  80257d:	0f 82 4c 01 00 00    	jb     8026cf <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802583:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802587:	75 14                	jne    80259d <insert_sorted_allocList+0x157>
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	68 e8 46 80 00       	push   $0x8046e8
  802591:	6a 73                	push   $0x73
  802593:	68 97 46 80 00       	push   $0x804697
  802598:	e8 12 e0 ff ff       	call   8005af <_panic>
  80259d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	89 50 04             	mov    %edx,0x4(%eax)
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	8b 40 04             	mov    0x4(%eax),%eax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	74 0c                	je     8025bf <insert_sorted_allocList+0x179>
  8025b3:	a1 44 50 80 00       	mov    0x805044,%eax
  8025b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025bb:	89 10                	mov    %edx,(%eax)
  8025bd:	eb 08                	jmp    8025c7 <insert_sorted_allocList+0x181>
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	a3 40 50 80 00       	mov    %eax,0x805040
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	a3 44 50 80 00       	mov    %eax,0x805044
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025dd:	40                   	inc    %eax
  8025de:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025e3:	e9 e7 00 00 00       	jmp    8026cf <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8025ee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025f5:	a1 40 50 80 00       	mov    0x805040,%eax
  8025fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fd:	e9 9d 00 00 00       	jmp    80269f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	8b 50 08             	mov    0x8(%eax),%edx
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 08             	mov    0x8(%eax),%eax
  802616:	39 c2                	cmp    %eax,%edx
  802618:	76 7d                	jbe    802697 <insert_sorted_allocList+0x251>
  80261a:	8b 45 08             	mov    0x8(%ebp),%eax
  80261d:	8b 50 08             	mov    0x8(%eax),%edx
  802620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802623:	8b 40 08             	mov    0x8(%eax),%eax
  802626:	39 c2                	cmp    %eax,%edx
  802628:	73 6d                	jae    802697 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80262a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262e:	74 06                	je     802636 <insert_sorted_allocList+0x1f0>
  802630:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802634:	75 14                	jne    80264a <insert_sorted_allocList+0x204>
  802636:	83 ec 04             	sub    $0x4,%esp
  802639:	68 0c 47 80 00       	push   $0x80470c
  80263e:	6a 7f                	push   $0x7f
  802640:	68 97 46 80 00       	push   $0x804697
  802645:	e8 65 df ff ff       	call   8005af <_panic>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 10                	mov    (%eax),%edx
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	89 10                	mov    %edx,(%eax)
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	8b 00                	mov    (%eax),%eax
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 0b                	je     802668 <insert_sorted_allocList+0x222>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	8b 55 08             	mov    0x8(%ebp),%edx
  802665:	89 50 04             	mov    %edx,0x4(%eax)
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 55 08             	mov    0x8(%ebp),%edx
  80266e:	89 10                	mov    %edx,(%eax)
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802676:	89 50 04             	mov    %edx,0x4(%eax)
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	8b 00                	mov    (%eax),%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	75 08                	jne    80268a <insert_sorted_allocList+0x244>
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	a3 44 50 80 00       	mov    %eax,0x805044
  80268a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80268f:	40                   	inc    %eax
  802690:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802695:	eb 39                	jmp    8026d0 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802697:	a1 48 50 80 00       	mov    0x805048,%eax
  80269c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a3:	74 07                	je     8026ac <insert_sorted_allocList+0x266>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	eb 05                	jmp    8026b1 <insert_sorted_allocList+0x26b>
  8026ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b1:	a3 48 50 80 00       	mov    %eax,0x805048
  8026b6:	a1 48 50 80 00       	mov    0x805048,%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	0f 85 3f ff ff ff    	jne    802602 <insert_sorted_allocList+0x1bc>
  8026c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c7:	0f 85 35 ff ff ff    	jne    802602 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026cd:	eb 01                	jmp    8026d0 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026cf:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026d0:	90                   	nop
  8026d1:	c9                   	leave  
  8026d2:	c3                   	ret    

008026d3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
  8026d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8026de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e1:	e9 85 01 00 00       	jmp    80286b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ef:	0f 82 6e 01 00 00    	jb     802863 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fe:	0f 85 8a 00 00 00    	jne    80278e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802708:	75 17                	jne    802721 <alloc_block_FF+0x4e>
  80270a:	83 ec 04             	sub    $0x4,%esp
  80270d:	68 40 47 80 00       	push   $0x804740
  802712:	68 93 00 00 00       	push   $0x93
  802717:	68 97 46 80 00       	push   $0x804697
  80271c:	e8 8e de ff ff       	call   8005af <_panic>
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	85 c0                	test   %eax,%eax
  802728:	74 10                	je     80273a <alloc_block_FF+0x67>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802732:	8b 52 04             	mov    0x4(%edx),%edx
  802735:	89 50 04             	mov    %edx,0x4(%eax)
  802738:	eb 0b                	jmp    802745 <alloc_block_FF+0x72>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 40 04             	mov    0x4(%eax),%eax
  802740:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 40 04             	mov    0x4(%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 0f                	je     80275e <alloc_block_FF+0x8b>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 40 04             	mov    0x4(%eax),%eax
  802755:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802758:	8b 12                	mov    (%edx),%edx
  80275a:	89 10                	mov    %edx,(%eax)
  80275c:	eb 0a                	jmp    802768 <alloc_block_FF+0x95>
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	a3 38 51 80 00       	mov    %eax,0x805138
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277b:	a1 44 51 80 00       	mov    0x805144,%eax
  802780:	48                   	dec    %eax
  802781:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	e9 10 01 00 00       	jmp    80289e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 40 0c             	mov    0xc(%eax),%eax
  802794:	3b 45 08             	cmp    0x8(%ebp),%eax
  802797:	0f 86 c6 00 00 00    	jbe    802863 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80279d:	a1 48 51 80 00       	mov    0x805148,%eax
  8027a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 50 08             	mov    0x8(%eax),%edx
  8027ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ae:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b7:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027be:	75 17                	jne    8027d7 <alloc_block_FF+0x104>
  8027c0:	83 ec 04             	sub    $0x4,%esp
  8027c3:	68 40 47 80 00       	push   $0x804740
  8027c8:	68 9b 00 00 00       	push   $0x9b
  8027cd:	68 97 46 80 00       	push   $0x804697
  8027d2:	e8 d8 dd ff ff       	call   8005af <_panic>
  8027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	74 10                	je     8027f0 <alloc_block_FF+0x11d>
  8027e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e3:	8b 00                	mov    (%eax),%eax
  8027e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e8:	8b 52 04             	mov    0x4(%edx),%edx
  8027eb:	89 50 04             	mov    %edx,0x4(%eax)
  8027ee:	eb 0b                	jmp    8027fb <alloc_block_FF+0x128>
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	8b 40 04             	mov    0x4(%eax),%eax
  8027f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fe:	8b 40 04             	mov    0x4(%eax),%eax
  802801:	85 c0                	test   %eax,%eax
  802803:	74 0f                	je     802814 <alloc_block_FF+0x141>
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	8b 40 04             	mov    0x4(%eax),%eax
  80280b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80280e:	8b 12                	mov    (%edx),%edx
  802810:	89 10                	mov    %edx,(%eax)
  802812:	eb 0a                	jmp    80281e <alloc_block_FF+0x14b>
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	a3 48 51 80 00       	mov    %eax,0x805148
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802831:	a1 54 51 80 00       	mov    0x805154,%eax
  802836:	48                   	dec    %eax
  802837:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 50 08             	mov    0x8(%eax),%edx
  802842:	8b 45 08             	mov    0x8(%ebp),%eax
  802845:	01 c2                	add    %eax,%edx
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8b 40 0c             	mov    0xc(%eax),%eax
  802853:	2b 45 08             	sub    0x8(%ebp),%eax
  802856:	89 c2                	mov    %eax,%edx
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80285e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802861:	eb 3b                	jmp    80289e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802863:	a1 40 51 80 00       	mov    0x805140,%eax
  802868:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286f:	74 07                	je     802878 <alloc_block_FF+0x1a5>
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	eb 05                	jmp    80287d <alloc_block_FF+0x1aa>
  802878:	b8 00 00 00 00       	mov    $0x0,%eax
  80287d:	a3 40 51 80 00       	mov    %eax,0x805140
  802882:	a1 40 51 80 00       	mov    0x805140,%eax
  802887:	85 c0                	test   %eax,%eax
  802889:	0f 85 57 fe ff ff    	jne    8026e6 <alloc_block_FF+0x13>
  80288f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802893:	0f 85 4d fe ff ff    	jne    8026e6 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802899:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80289e:	c9                   	leave  
  80289f:	c3                   	ret    

008028a0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8028a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028ad:	a1 38 51 80 00       	mov    0x805138,%eax
  8028b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b5:	e9 df 00 00 00       	jmp    802999 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c3:	0f 82 c8 00 00 00    	jb     802991 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d2:	0f 85 8a 00 00 00    	jne    802962 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8028d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028dc:	75 17                	jne    8028f5 <alloc_block_BF+0x55>
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	68 40 47 80 00       	push   $0x804740
  8028e6:	68 b7 00 00 00       	push   $0xb7
  8028eb:	68 97 46 80 00       	push   $0x804697
  8028f0:	e8 ba dc ff ff       	call   8005af <_panic>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 10                	je     80290e <alloc_block_BF+0x6e>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802906:	8b 52 04             	mov    0x4(%edx),%edx
  802909:	89 50 04             	mov    %edx,0x4(%eax)
  80290c:	eb 0b                	jmp    802919 <alloc_block_BF+0x79>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 0f                	je     802932 <alloc_block_BF+0x92>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292c:	8b 12                	mov    (%edx),%edx
  80292e:	89 10                	mov    %edx,(%eax)
  802930:	eb 0a                	jmp    80293c <alloc_block_BF+0x9c>
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	a3 38 51 80 00       	mov    %eax,0x805138
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294f:	a1 44 51 80 00       	mov    0x805144,%eax
  802954:	48                   	dec    %eax
  802955:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	e9 4d 01 00 00       	jmp    802aaf <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 40 0c             	mov    0xc(%eax),%eax
  802968:	3b 45 08             	cmp    0x8(%ebp),%eax
  80296b:	76 24                	jbe    802991 <alloc_block_BF+0xf1>
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 0c             	mov    0xc(%eax),%eax
  802973:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802976:	73 19                	jae    802991 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802978:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 40 0c             	mov    0xc(%eax),%eax
  802985:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 08             	mov    0x8(%eax),%eax
  80298e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802991:	a1 40 51 80 00       	mov    0x805140,%eax
  802996:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802999:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299d:	74 07                	je     8029a6 <alloc_block_BF+0x106>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	eb 05                	jmp    8029ab <alloc_block_BF+0x10b>
  8029a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ab:	a3 40 51 80 00       	mov    %eax,0x805140
  8029b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	0f 85 fd fe ff ff    	jne    8028ba <alloc_block_BF+0x1a>
  8029bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c1:	0f 85 f3 fe ff ff    	jne    8028ba <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8029c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029cb:	0f 84 d9 00 00 00    	je     802aaa <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8029d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029df:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8029e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e8:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8029eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029ef:	75 17                	jne    802a08 <alloc_block_BF+0x168>
  8029f1:	83 ec 04             	sub    $0x4,%esp
  8029f4:	68 40 47 80 00       	push   $0x804740
  8029f9:	68 c7 00 00 00       	push   $0xc7
  8029fe:	68 97 46 80 00       	push   $0x804697
  802a03:	e8 a7 db ff ff       	call   8005af <_panic>
  802a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0b:	8b 00                	mov    (%eax),%eax
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	74 10                	je     802a21 <alloc_block_BF+0x181>
  802a11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a14:	8b 00                	mov    (%eax),%eax
  802a16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a19:	8b 52 04             	mov    0x4(%edx),%edx
  802a1c:	89 50 04             	mov    %edx,0x4(%eax)
  802a1f:	eb 0b                	jmp    802a2c <alloc_block_BF+0x18c>
  802a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a24:	8b 40 04             	mov    0x4(%eax),%eax
  802a27:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a2f:	8b 40 04             	mov    0x4(%eax),%eax
  802a32:	85 c0                	test   %eax,%eax
  802a34:	74 0f                	je     802a45 <alloc_block_BF+0x1a5>
  802a36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a39:	8b 40 04             	mov    0x4(%eax),%eax
  802a3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a3f:	8b 12                	mov    (%edx),%edx
  802a41:	89 10                	mov    %edx,(%eax)
  802a43:	eb 0a                	jmp    802a4f <alloc_block_BF+0x1af>
  802a45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	a3 48 51 80 00       	mov    %eax,0x805148
  802a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a62:	a1 54 51 80 00       	mov    0x805154,%eax
  802a67:	48                   	dec    %eax
  802a68:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a6d:	83 ec 08             	sub    $0x8,%esp
  802a70:	ff 75 ec             	pushl  -0x14(%ebp)
  802a73:	68 38 51 80 00       	push   $0x805138
  802a78:	e8 71 f9 ff ff       	call   8023ee <find_block>
  802a7d:	83 c4 10             	add    $0x10,%esp
  802a80:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a86:	8b 50 08             	mov    0x8(%eax),%edx
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	01 c2                	add    %eax,%edx
  802a8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a91:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a97:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a9d:	89 c2                	mov    %eax,%edx
  802a9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa8:	eb 05                	jmp    802aaf <alloc_block_BF+0x20f>
	}
	return NULL;
  802aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aaf:	c9                   	leave  
  802ab0:	c3                   	ret    

00802ab1 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ab1:	55                   	push   %ebp
  802ab2:	89 e5                	mov    %esp,%ebp
  802ab4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ab7:	a1 28 50 80 00       	mov    0x805028,%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	0f 85 de 01 00 00    	jne    802ca2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ac4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802acc:	e9 9e 01 00 00       	jmp    802c6f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ada:	0f 82 87 01 00 00    	jb     802c67 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae9:	0f 85 95 00 00 00    	jne    802b84 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af3:	75 17                	jne    802b0c <alloc_block_NF+0x5b>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 40 47 80 00       	push   $0x804740
  802afd:	68 e0 00 00 00       	push   $0xe0
  802b02:	68 97 46 80 00       	push   $0x804697
  802b07:	e8 a3 da ff ff       	call   8005af <_panic>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 10                	je     802b25 <alloc_block_NF+0x74>
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1d:	8b 52 04             	mov    0x4(%edx),%edx
  802b20:	89 50 04             	mov    %edx,0x4(%eax)
  802b23:	eb 0b                	jmp    802b30 <alloc_block_NF+0x7f>
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 0f                	je     802b49 <alloc_block_NF+0x98>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b43:	8b 12                	mov    (%edx),%edx
  802b45:	89 10                	mov    %edx,(%eax)
  802b47:	eb 0a                	jmp    802b53 <alloc_block_NF+0xa2>
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b66:	a1 44 51 80 00       	mov    0x805144,%eax
  802b6b:	48                   	dec    %eax
  802b6c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	8b 40 08             	mov    0x8(%eax),%eax
  802b77:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	e9 f8 04 00 00       	jmp    80307c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8d:	0f 86 d4 00 00 00    	jbe    802c67 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b93:	a1 48 51 80 00       	mov    0x805148,%eax
  802b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	8b 55 08             	mov    0x8(%ebp),%edx
  802bad:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb4:	75 17                	jne    802bcd <alloc_block_NF+0x11c>
  802bb6:	83 ec 04             	sub    $0x4,%esp
  802bb9:	68 40 47 80 00       	push   $0x804740
  802bbe:	68 e9 00 00 00       	push   $0xe9
  802bc3:	68 97 46 80 00       	push   $0x804697
  802bc8:	e8 e2 d9 ff ff       	call   8005af <_panic>
  802bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	74 10                	je     802be6 <alloc_block_NF+0x135>
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bde:	8b 52 04             	mov    0x4(%edx),%edx
  802be1:	89 50 04             	mov    %edx,0x4(%eax)
  802be4:	eb 0b                	jmp    802bf1 <alloc_block_NF+0x140>
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf4:	8b 40 04             	mov    0x4(%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 0f                	je     802c0a <alloc_block_NF+0x159>
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c04:	8b 12                	mov    (%edx),%edx
  802c06:	89 10                	mov    %edx,(%eax)
  802c08:	eb 0a                	jmp    802c14 <alloc_block_NF+0x163>
  802c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c27:	a1 54 51 80 00       	mov    0x805154,%eax
  802c2c:	48                   	dec    %eax
  802c2d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c35:	8b 40 08             	mov    0x8(%eax),%eax
  802c38:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 50 08             	mov    0x8(%eax),%edx
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	01 c2                	add    %eax,%edx
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 40 0c             	mov    0xc(%eax),%eax
  802c54:	2b 45 08             	sub    0x8(%ebp),%eax
  802c57:	89 c2                	mov    %eax,%edx
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c62:	e9 15 04 00 00       	jmp    80307c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c67:	a1 40 51 80 00       	mov    0x805140,%eax
  802c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c73:	74 07                	je     802c7c <alloc_block_NF+0x1cb>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	eb 05                	jmp    802c81 <alloc_block_NF+0x1d0>
  802c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c81:	a3 40 51 80 00       	mov    %eax,0x805140
  802c86:	a1 40 51 80 00       	mov    0x805140,%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	0f 85 3e fe ff ff    	jne    802ad1 <alloc_block_NF+0x20>
  802c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c97:	0f 85 34 fe ff ff    	jne    802ad1 <alloc_block_NF+0x20>
  802c9d:	e9 d5 03 00 00       	jmp    803077 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ca2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802caa:	e9 b1 01 00 00       	jmp    802e60 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 50 08             	mov    0x8(%eax),%edx
  802cb5:	a1 28 50 80 00       	mov    0x805028,%eax
  802cba:	39 c2                	cmp    %eax,%edx
  802cbc:	0f 82 96 01 00 00    	jb     802e58 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ccb:	0f 82 87 01 00 00    	jb     802e58 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cda:	0f 85 95 00 00 00    	jne    802d75 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ce0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce4:	75 17                	jne    802cfd <alloc_block_NF+0x24c>
  802ce6:	83 ec 04             	sub    $0x4,%esp
  802ce9:	68 40 47 80 00       	push   $0x804740
  802cee:	68 fc 00 00 00       	push   $0xfc
  802cf3:	68 97 46 80 00       	push   $0x804697
  802cf8:	e8 b2 d8 ff ff       	call   8005af <_panic>
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 00                	mov    (%eax),%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	74 10                	je     802d16 <alloc_block_NF+0x265>
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0e:	8b 52 04             	mov    0x4(%edx),%edx
  802d11:	89 50 04             	mov    %edx,0x4(%eax)
  802d14:	eb 0b                	jmp    802d21 <alloc_block_NF+0x270>
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 40 04             	mov    0x4(%eax),%eax
  802d1c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 40 04             	mov    0x4(%eax),%eax
  802d27:	85 c0                	test   %eax,%eax
  802d29:	74 0f                	je     802d3a <alloc_block_NF+0x289>
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 40 04             	mov    0x4(%eax),%eax
  802d31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d34:	8b 12                	mov    (%edx),%edx
  802d36:	89 10                	mov    %edx,(%eax)
  802d38:	eb 0a                	jmp    802d44 <alloc_block_NF+0x293>
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d57:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5c:	48                   	dec    %eax
  802d5d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 40 08             	mov    0x8(%eax),%eax
  802d68:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	e9 07 03 00 00       	jmp    80307c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7e:	0f 86 d4 00 00 00    	jbe    802e58 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d84:	a1 48 51 80 00       	mov    0x805148,%eax
  802d89:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 50 08             	mov    0x8(%eax),%edx
  802d92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d95:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802da1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802da5:	75 17                	jne    802dbe <alloc_block_NF+0x30d>
  802da7:	83 ec 04             	sub    $0x4,%esp
  802daa:	68 40 47 80 00       	push   $0x804740
  802daf:	68 04 01 00 00       	push   $0x104
  802db4:	68 97 46 80 00       	push   $0x804697
  802db9:	e8 f1 d7 ff ff       	call   8005af <_panic>
  802dbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	74 10                	je     802dd7 <alloc_block_NF+0x326>
  802dc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dcf:	8b 52 04             	mov    0x4(%edx),%edx
  802dd2:	89 50 04             	mov    %edx,0x4(%eax)
  802dd5:	eb 0b                	jmp    802de2 <alloc_block_NF+0x331>
  802dd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802de2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de5:	8b 40 04             	mov    0x4(%eax),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 0f                	je     802dfb <alloc_block_NF+0x34a>
  802dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802df5:	8b 12                	mov    (%edx),%edx
  802df7:	89 10                	mov    %edx,(%eax)
  802df9:	eb 0a                	jmp    802e05 <alloc_block_NF+0x354>
  802dfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	a3 48 51 80 00       	mov    %eax,0x805148
  802e05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e18:	a1 54 51 80 00       	mov    0x805154,%eax
  802e1d:	48                   	dec    %eax
  802e1e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e26:	8b 40 08             	mov    0x8(%eax),%eax
  802e29:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 50 08             	mov    0x8(%eax),%edx
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	01 c2                	add    %eax,%edx
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 40 0c             	mov    0xc(%eax),%eax
  802e45:	2b 45 08             	sub    0x8(%ebp),%eax
  802e48:	89 c2                	mov    %eax,%edx
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e53:	e9 24 02 00 00       	jmp    80307c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e58:	a1 40 51 80 00       	mov    0x805140,%eax
  802e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e64:	74 07                	je     802e6d <alloc_block_NF+0x3bc>
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	eb 05                	jmp    802e72 <alloc_block_NF+0x3c1>
  802e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e72:	a3 40 51 80 00       	mov    %eax,0x805140
  802e77:	a1 40 51 80 00       	mov    0x805140,%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	0f 85 2b fe ff ff    	jne    802caf <alloc_block_NF+0x1fe>
  802e84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e88:	0f 85 21 fe ff ff    	jne    802caf <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e8e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e96:	e9 ae 01 00 00       	jmp    803049 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ea1:	a1 28 50 80 00       	mov    0x805028,%eax
  802ea6:	39 c2                	cmp    %eax,%edx
  802ea8:	0f 83 93 01 00 00    	jae    803041 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb7:	0f 82 84 01 00 00    	jb     803041 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec6:	0f 85 95 00 00 00    	jne    802f61 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed0:	75 17                	jne    802ee9 <alloc_block_NF+0x438>
  802ed2:	83 ec 04             	sub    $0x4,%esp
  802ed5:	68 40 47 80 00       	push   $0x804740
  802eda:	68 14 01 00 00       	push   $0x114
  802edf:	68 97 46 80 00       	push   $0x804697
  802ee4:	e8 c6 d6 ff ff       	call   8005af <_panic>
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 10                	je     802f02 <alloc_block_NF+0x451>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efa:	8b 52 04             	mov    0x4(%edx),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
  802f00:	eb 0b                	jmp    802f0d <alloc_block_NF+0x45c>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 0f                	je     802f26 <alloc_block_NF+0x475>
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f20:	8b 12                	mov    (%edx),%edx
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	eb 0a                	jmp    802f30 <alloc_block_NF+0x47f>
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f43:	a1 44 51 80 00       	mov    0x805144,%eax
  802f48:	48                   	dec    %eax
  802f49:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 08             	mov    0x8(%eax),%eax
  802f54:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	e9 1b 01 00 00       	jmp    80307c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 40 0c             	mov    0xc(%eax),%eax
  802f67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f6a:	0f 86 d1 00 00 00    	jbe    803041 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f70:	a1 48 51 80 00       	mov    0x805148,%eax
  802f75:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 50 08             	mov    0x8(%eax),%edx
  802f7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f81:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f87:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f91:	75 17                	jne    802faa <alloc_block_NF+0x4f9>
  802f93:	83 ec 04             	sub    $0x4,%esp
  802f96:	68 40 47 80 00       	push   $0x804740
  802f9b:	68 1c 01 00 00       	push   $0x11c
  802fa0:	68 97 46 80 00       	push   $0x804697
  802fa5:	e8 05 d6 ff ff       	call   8005af <_panic>
  802faa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	74 10                	je     802fc3 <alloc_block_NF+0x512>
  802fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fbb:	8b 52 04             	mov    0x4(%edx),%edx
  802fbe:	89 50 04             	mov    %edx,0x4(%eax)
  802fc1:	eb 0b                	jmp    802fce <alloc_block_NF+0x51d>
  802fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc6:	8b 40 04             	mov    0x4(%eax),%eax
  802fc9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	74 0f                	je     802fe7 <alloc_block_NF+0x536>
  802fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdb:	8b 40 04             	mov    0x4(%eax),%eax
  802fde:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fe1:	8b 12                	mov    (%edx),%edx
  802fe3:	89 10                	mov    %edx,(%eax)
  802fe5:	eb 0a                	jmp    802ff1 <alloc_block_NF+0x540>
  802fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fea:	8b 00                	mov    (%eax),%eax
  802fec:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803004:	a1 54 51 80 00       	mov    0x805154,%eax
  803009:	48                   	dec    %eax
  80300a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80300f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803012:	8b 40 08             	mov    0x8(%eax),%eax
  803015:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 50 08             	mov    0x8(%eax),%edx
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	01 c2                	add    %eax,%edx
  803025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803028:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 40 0c             	mov    0xc(%eax),%eax
  803031:	2b 45 08             	sub    0x8(%ebp),%eax
  803034:	89 c2                	mov    %eax,%edx
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80303c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303f:	eb 3b                	jmp    80307c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803041:	a1 40 51 80 00       	mov    0x805140,%eax
  803046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304d:	74 07                	je     803056 <alloc_block_NF+0x5a5>
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	eb 05                	jmp    80305b <alloc_block_NF+0x5aa>
  803056:	b8 00 00 00 00       	mov    $0x0,%eax
  80305b:	a3 40 51 80 00       	mov    %eax,0x805140
  803060:	a1 40 51 80 00       	mov    0x805140,%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	0f 85 2e fe ff ff    	jne    802e9b <alloc_block_NF+0x3ea>
  80306d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803071:	0f 85 24 fe ff ff    	jne    802e9b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803077:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80307c:	c9                   	leave  
  80307d:	c3                   	ret    

0080307e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80307e:	55                   	push   %ebp
  80307f:	89 e5                	mov    %esp,%ebp
  803081:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803084:	a1 38 51 80 00       	mov    0x805138,%eax
  803089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80308c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803091:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803094:	a1 38 51 80 00       	mov    0x805138,%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	74 14                	je     8030b1 <insert_sorted_with_merge_freeList+0x33>
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 50 08             	mov    0x8(%eax),%edx
  8030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a6:	8b 40 08             	mov    0x8(%eax),%eax
  8030a9:	39 c2                	cmp    %eax,%edx
  8030ab:	0f 87 9b 01 00 00    	ja     80324c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b5:	75 17                	jne    8030ce <insert_sorted_with_merge_freeList+0x50>
  8030b7:	83 ec 04             	sub    $0x4,%esp
  8030ba:	68 74 46 80 00       	push   $0x804674
  8030bf:	68 38 01 00 00       	push   $0x138
  8030c4:	68 97 46 80 00       	push   $0x804697
  8030c9:	e8 e1 d4 ff ff       	call   8005af <_panic>
  8030ce:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	89 10                	mov    %edx,(%eax)
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 0d                	je     8030ef <insert_sorted_with_merge_freeList+0x71>
  8030e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	eb 08                	jmp    8030f7 <insert_sorted_with_merge_freeList+0x79>
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803109:	a1 44 51 80 00       	mov    0x805144,%eax
  80310e:	40                   	inc    %eax
  80310f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803114:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803118:	0f 84 a8 06 00 00    	je     8037c6 <insert_sorted_with_merge_freeList+0x748>
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	8b 50 08             	mov    0x8(%eax),%edx
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	8b 40 0c             	mov    0xc(%eax),%eax
  80312a:	01 c2                	add    %eax,%edx
  80312c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312f:	8b 40 08             	mov    0x8(%eax),%eax
  803132:	39 c2                	cmp    %eax,%edx
  803134:	0f 85 8c 06 00 00    	jne    8037c6 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	8b 50 0c             	mov    0xc(%eax),%edx
  803140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803143:	8b 40 0c             	mov    0xc(%eax),%eax
  803146:	01 c2                	add    %eax,%edx
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80314e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803152:	75 17                	jne    80316b <insert_sorted_with_merge_freeList+0xed>
  803154:	83 ec 04             	sub    $0x4,%esp
  803157:	68 40 47 80 00       	push   $0x804740
  80315c:	68 3c 01 00 00       	push   $0x13c
  803161:	68 97 46 80 00       	push   $0x804697
  803166:	e8 44 d4 ff ff       	call   8005af <_panic>
  80316b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316e:	8b 00                	mov    (%eax),%eax
  803170:	85 c0                	test   %eax,%eax
  803172:	74 10                	je     803184 <insert_sorted_with_merge_freeList+0x106>
  803174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803177:	8b 00                	mov    (%eax),%eax
  803179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80317c:	8b 52 04             	mov    0x4(%edx),%edx
  80317f:	89 50 04             	mov    %edx,0x4(%eax)
  803182:	eb 0b                	jmp    80318f <insert_sorted_with_merge_freeList+0x111>
  803184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803187:	8b 40 04             	mov    0x4(%eax),%eax
  80318a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80318f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803192:	8b 40 04             	mov    0x4(%eax),%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	74 0f                	je     8031a8 <insert_sorted_with_merge_freeList+0x12a>
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	8b 40 04             	mov    0x4(%eax),%eax
  80319f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a2:	8b 12                	mov    (%edx),%edx
  8031a4:	89 10                	mov    %edx,(%eax)
  8031a6:	eb 0a                	jmp    8031b2 <insert_sorted_with_merge_freeList+0x134>
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ca:	48                   	dec    %eax
  8031cb:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8031d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8031da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031e8:	75 17                	jne    803201 <insert_sorted_with_merge_freeList+0x183>
  8031ea:	83 ec 04             	sub    $0x4,%esp
  8031ed:	68 74 46 80 00       	push   $0x804674
  8031f2:	68 3f 01 00 00       	push   $0x13f
  8031f7:	68 97 46 80 00       	push   $0x804697
  8031fc:	e8 ae d3 ff ff       	call   8005af <_panic>
  803201:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320a:	89 10                	mov    %edx,(%eax)
  80320c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	85 c0                	test   %eax,%eax
  803213:	74 0d                	je     803222 <insert_sorted_with_merge_freeList+0x1a4>
  803215:	a1 48 51 80 00       	mov    0x805148,%eax
  80321a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80321d:	89 50 04             	mov    %edx,0x4(%eax)
  803220:	eb 08                	jmp    80322a <insert_sorted_with_merge_freeList+0x1ac>
  803222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803225:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80322a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322d:	a3 48 51 80 00       	mov    %eax,0x805148
  803232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803235:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323c:	a1 54 51 80 00       	mov    0x805154,%eax
  803241:	40                   	inc    %eax
  803242:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803247:	e9 7a 05 00 00       	jmp    8037c6 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	8b 50 08             	mov    0x8(%eax),%edx
  803252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803255:	8b 40 08             	mov    0x8(%eax),%eax
  803258:	39 c2                	cmp    %eax,%edx
  80325a:	0f 82 14 01 00 00    	jb     803374 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803260:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803263:	8b 50 08             	mov    0x8(%eax),%edx
  803266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803269:	8b 40 0c             	mov    0xc(%eax),%eax
  80326c:	01 c2                	add    %eax,%edx
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	8b 40 08             	mov    0x8(%eax),%eax
  803274:	39 c2                	cmp    %eax,%edx
  803276:	0f 85 90 00 00 00    	jne    80330c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80327c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327f:	8b 50 0c             	mov    0xc(%eax),%edx
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	8b 40 0c             	mov    0xc(%eax),%eax
  803288:	01 c2                	add    %eax,%edx
  80328a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a8:	75 17                	jne    8032c1 <insert_sorted_with_merge_freeList+0x243>
  8032aa:	83 ec 04             	sub    $0x4,%esp
  8032ad:	68 74 46 80 00       	push   $0x804674
  8032b2:	68 49 01 00 00       	push   $0x149
  8032b7:	68 97 46 80 00       	push   $0x804697
  8032bc:	e8 ee d2 ff ff       	call   8005af <_panic>
  8032c1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	89 10                	mov    %edx,(%eax)
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	8b 00                	mov    (%eax),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	74 0d                	je     8032e2 <insert_sorted_with_merge_freeList+0x264>
  8032d5:	a1 48 51 80 00       	mov    0x805148,%eax
  8032da:	8b 55 08             	mov    0x8(%ebp),%edx
  8032dd:	89 50 04             	mov    %edx,0x4(%eax)
  8032e0:	eb 08                	jmp    8032ea <insert_sorted_with_merge_freeList+0x26c>
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fc:	a1 54 51 80 00       	mov    0x805154,%eax
  803301:	40                   	inc    %eax
  803302:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803307:	e9 bb 04 00 00       	jmp    8037c7 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80330c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803310:	75 17                	jne    803329 <insert_sorted_with_merge_freeList+0x2ab>
  803312:	83 ec 04             	sub    $0x4,%esp
  803315:	68 e8 46 80 00       	push   $0x8046e8
  80331a:	68 4c 01 00 00       	push   $0x14c
  80331f:	68 97 46 80 00       	push   $0x804697
  803324:	e8 86 d2 ff ff       	call   8005af <_panic>
  803329:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	89 50 04             	mov    %edx,0x4(%eax)
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	8b 40 04             	mov    0x4(%eax),%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	74 0c                	je     80334b <insert_sorted_with_merge_freeList+0x2cd>
  80333f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803344:	8b 55 08             	mov    0x8(%ebp),%edx
  803347:	89 10                	mov    %edx,(%eax)
  803349:	eb 08                	jmp    803353 <insert_sorted_with_merge_freeList+0x2d5>
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	a3 38 51 80 00       	mov    %eax,0x805138
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803364:	a1 44 51 80 00       	mov    0x805144,%eax
  803369:	40                   	inc    %eax
  80336a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80336f:	e9 53 04 00 00       	jmp    8037c7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803374:	a1 38 51 80 00       	mov    0x805138,%eax
  803379:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337c:	e9 15 04 00 00       	jmp    803796 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	8b 50 08             	mov    0x8(%eax),%edx
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	8b 40 08             	mov    0x8(%eax),%eax
  803395:	39 c2                	cmp    %eax,%edx
  803397:	0f 86 f1 03 00 00    	jbe    80378e <insert_sorted_with_merge_freeList+0x710>
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	8b 50 08             	mov    0x8(%eax),%edx
  8033a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a6:	8b 40 08             	mov    0x8(%eax),%eax
  8033a9:	39 c2                	cmp    %eax,%edx
  8033ab:	0f 83 dd 03 00 00    	jae    80378e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8033b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b4:	8b 50 08             	mov    0x8(%eax),%edx
  8033b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8033bd:	01 c2                	add    %eax,%edx
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	8b 40 08             	mov    0x8(%eax),%eax
  8033c5:	39 c2                	cmp    %eax,%edx
  8033c7:	0f 85 b9 01 00 00    	jne    803586 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	8b 50 08             	mov    0x8(%eax),%edx
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d9:	01 c2                	add    %eax,%edx
  8033db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033de:	8b 40 08             	mov    0x8(%eax),%eax
  8033e1:	39 c2                	cmp    %eax,%edx
  8033e3:	0f 85 0d 01 00 00    	jne    8034f6 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f5:	01 c2                	add    %eax,%edx
  8033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fa:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803401:	75 17                	jne    80341a <insert_sorted_with_merge_freeList+0x39c>
  803403:	83 ec 04             	sub    $0x4,%esp
  803406:	68 40 47 80 00       	push   $0x804740
  80340b:	68 5c 01 00 00       	push   $0x15c
  803410:	68 97 46 80 00       	push   $0x804697
  803415:	e8 95 d1 ff ff       	call   8005af <_panic>
  80341a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341d:	8b 00                	mov    (%eax),%eax
  80341f:	85 c0                	test   %eax,%eax
  803421:	74 10                	je     803433 <insert_sorted_with_merge_freeList+0x3b5>
  803423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342b:	8b 52 04             	mov    0x4(%edx),%edx
  80342e:	89 50 04             	mov    %edx,0x4(%eax)
  803431:	eb 0b                	jmp    80343e <insert_sorted_with_merge_freeList+0x3c0>
  803433:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803436:	8b 40 04             	mov    0x4(%eax),%eax
  803439:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80343e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803441:	8b 40 04             	mov    0x4(%eax),%eax
  803444:	85 c0                	test   %eax,%eax
  803446:	74 0f                	je     803457 <insert_sorted_with_merge_freeList+0x3d9>
  803448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344b:	8b 40 04             	mov    0x4(%eax),%eax
  80344e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803451:	8b 12                	mov    (%edx),%edx
  803453:	89 10                	mov    %edx,(%eax)
  803455:	eb 0a                	jmp    803461 <insert_sorted_with_merge_freeList+0x3e3>
  803457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345a:	8b 00                	mov    (%eax),%eax
  80345c:	a3 38 51 80 00       	mov    %eax,0x805138
  803461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803464:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803474:	a1 44 51 80 00       	mov    0x805144,%eax
  803479:	48                   	dec    %eax
  80347a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80347f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803482:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803489:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803493:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803497:	75 17                	jne    8034b0 <insert_sorted_with_merge_freeList+0x432>
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	68 74 46 80 00       	push   $0x804674
  8034a1:	68 5f 01 00 00       	push   $0x15f
  8034a6:	68 97 46 80 00       	push   $0x804697
  8034ab:	e8 ff d0 ff ff       	call   8005af <_panic>
  8034b0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b9:	89 10                	mov    %edx,(%eax)
  8034bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	85 c0                	test   %eax,%eax
  8034c2:	74 0d                	je     8034d1 <insert_sorted_with_merge_freeList+0x453>
  8034c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034cc:	89 50 04             	mov    %edx,0x4(%eax)
  8034cf:	eb 08                	jmp    8034d9 <insert_sorted_with_merge_freeList+0x45b>
  8034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8034f0:	40                   	inc    %eax
  8034f1:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8034f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803502:	01 c2                	add    %eax,%edx
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80351e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803522:	75 17                	jne    80353b <insert_sorted_with_merge_freeList+0x4bd>
  803524:	83 ec 04             	sub    $0x4,%esp
  803527:	68 74 46 80 00       	push   $0x804674
  80352c:	68 64 01 00 00       	push   $0x164
  803531:	68 97 46 80 00       	push   $0x804697
  803536:	e8 74 d0 ff ff       	call   8005af <_panic>
  80353b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	89 10                	mov    %edx,(%eax)
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	8b 00                	mov    (%eax),%eax
  80354b:	85 c0                	test   %eax,%eax
  80354d:	74 0d                	je     80355c <insert_sorted_with_merge_freeList+0x4de>
  80354f:	a1 48 51 80 00       	mov    0x805148,%eax
  803554:	8b 55 08             	mov    0x8(%ebp),%edx
  803557:	89 50 04             	mov    %edx,0x4(%eax)
  80355a:	eb 08                	jmp    803564 <insert_sorted_with_merge_freeList+0x4e6>
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	a3 48 51 80 00       	mov    %eax,0x805148
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803576:	a1 54 51 80 00       	mov    0x805154,%eax
  80357b:	40                   	inc    %eax
  80357c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803581:	e9 41 02 00 00       	jmp    8037c7 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	8b 50 08             	mov    0x8(%eax),%edx
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	8b 40 0c             	mov    0xc(%eax),%eax
  803592:	01 c2                	add    %eax,%edx
  803594:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803597:	8b 40 08             	mov    0x8(%eax),%eax
  80359a:	39 c2                	cmp    %eax,%edx
  80359c:	0f 85 7c 01 00 00    	jne    80371e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8035a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035a6:	74 06                	je     8035ae <insert_sorted_with_merge_freeList+0x530>
  8035a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ac:	75 17                	jne    8035c5 <insert_sorted_with_merge_freeList+0x547>
  8035ae:	83 ec 04             	sub    $0x4,%esp
  8035b1:	68 b0 46 80 00       	push   $0x8046b0
  8035b6:	68 69 01 00 00       	push   $0x169
  8035bb:	68 97 46 80 00       	push   $0x804697
  8035c0:	e8 ea cf ff ff       	call   8005af <_panic>
  8035c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c8:	8b 50 04             	mov    0x4(%eax),%edx
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	89 50 04             	mov    %edx,0x4(%eax)
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d7:	89 10                	mov    %edx,(%eax)
  8035d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dc:	8b 40 04             	mov    0x4(%eax),%eax
  8035df:	85 c0                	test   %eax,%eax
  8035e1:	74 0d                	je     8035f0 <insert_sorted_with_merge_freeList+0x572>
  8035e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e6:	8b 40 04             	mov    0x4(%eax),%eax
  8035e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ec:	89 10                	mov    %edx,(%eax)
  8035ee:	eb 08                	jmp    8035f8 <insert_sorted_with_merge_freeList+0x57a>
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8035f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8035fe:	89 50 04             	mov    %edx,0x4(%eax)
  803601:	a1 44 51 80 00       	mov    0x805144,%eax
  803606:	40                   	inc    %eax
  803607:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80360c:	8b 45 08             	mov    0x8(%ebp),%eax
  80360f:	8b 50 0c             	mov    0xc(%eax),%edx
  803612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803615:	8b 40 0c             	mov    0xc(%eax),%eax
  803618:	01 c2                	add    %eax,%edx
  80361a:	8b 45 08             	mov    0x8(%ebp),%eax
  80361d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803620:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803624:	75 17                	jne    80363d <insert_sorted_with_merge_freeList+0x5bf>
  803626:	83 ec 04             	sub    $0x4,%esp
  803629:	68 40 47 80 00       	push   $0x804740
  80362e:	68 6b 01 00 00       	push   $0x16b
  803633:	68 97 46 80 00       	push   $0x804697
  803638:	e8 72 cf ff ff       	call   8005af <_panic>
  80363d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803640:	8b 00                	mov    (%eax),%eax
  803642:	85 c0                	test   %eax,%eax
  803644:	74 10                	je     803656 <insert_sorted_with_merge_freeList+0x5d8>
  803646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803649:	8b 00                	mov    (%eax),%eax
  80364b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80364e:	8b 52 04             	mov    0x4(%edx),%edx
  803651:	89 50 04             	mov    %edx,0x4(%eax)
  803654:	eb 0b                	jmp    803661 <insert_sorted_with_merge_freeList+0x5e3>
  803656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803659:	8b 40 04             	mov    0x4(%eax),%eax
  80365c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803661:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803664:	8b 40 04             	mov    0x4(%eax),%eax
  803667:	85 c0                	test   %eax,%eax
  803669:	74 0f                	je     80367a <insert_sorted_with_merge_freeList+0x5fc>
  80366b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366e:	8b 40 04             	mov    0x4(%eax),%eax
  803671:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803674:	8b 12                	mov    (%edx),%edx
  803676:	89 10                	mov    %edx,(%eax)
  803678:	eb 0a                	jmp    803684 <insert_sorted_with_merge_freeList+0x606>
  80367a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367d:	8b 00                	mov    (%eax),%eax
  80367f:	a3 38 51 80 00       	mov    %eax,0x805138
  803684:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803687:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80368d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803690:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803697:	a1 44 51 80 00       	mov    0x805144,%eax
  80369c:	48                   	dec    %eax
  80369d:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8036a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8036ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036ba:	75 17                	jne    8036d3 <insert_sorted_with_merge_freeList+0x655>
  8036bc:	83 ec 04             	sub    $0x4,%esp
  8036bf:	68 74 46 80 00       	push   $0x804674
  8036c4:	68 6e 01 00 00       	push   $0x16e
  8036c9:	68 97 46 80 00       	push   $0x804697
  8036ce:	e8 dc ce ff ff       	call   8005af <_panic>
  8036d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036dc:	89 10                	mov    %edx,(%eax)
  8036de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e1:	8b 00                	mov    (%eax),%eax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	74 0d                	je     8036f4 <insert_sorted_with_merge_freeList+0x676>
  8036e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ef:	89 50 04             	mov    %edx,0x4(%eax)
  8036f2:	eb 08                	jmp    8036fc <insert_sorted_with_merge_freeList+0x67e>
  8036f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ff:	a3 48 51 80 00       	mov    %eax,0x805148
  803704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803707:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370e:	a1 54 51 80 00       	mov    0x805154,%eax
  803713:	40                   	inc    %eax
  803714:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803719:	e9 a9 00 00 00       	jmp    8037c7 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80371e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803722:	74 06                	je     80372a <insert_sorted_with_merge_freeList+0x6ac>
  803724:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803728:	75 17                	jne    803741 <insert_sorted_with_merge_freeList+0x6c3>
  80372a:	83 ec 04             	sub    $0x4,%esp
  80372d:	68 0c 47 80 00       	push   $0x80470c
  803732:	68 73 01 00 00       	push   $0x173
  803737:	68 97 46 80 00       	push   $0x804697
  80373c:	e8 6e ce ff ff       	call   8005af <_panic>
  803741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803744:	8b 10                	mov    (%eax),%edx
  803746:	8b 45 08             	mov    0x8(%ebp),%eax
  803749:	89 10                	mov    %edx,(%eax)
  80374b:	8b 45 08             	mov    0x8(%ebp),%eax
  80374e:	8b 00                	mov    (%eax),%eax
  803750:	85 c0                	test   %eax,%eax
  803752:	74 0b                	je     80375f <insert_sorted_with_merge_freeList+0x6e1>
  803754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	8b 55 08             	mov    0x8(%ebp),%edx
  80375c:	89 50 04             	mov    %edx,0x4(%eax)
  80375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803762:	8b 55 08             	mov    0x8(%ebp),%edx
  803765:	89 10                	mov    %edx,(%eax)
  803767:	8b 45 08             	mov    0x8(%ebp),%eax
  80376a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80376d:	89 50 04             	mov    %edx,0x4(%eax)
  803770:	8b 45 08             	mov    0x8(%ebp),%eax
  803773:	8b 00                	mov    (%eax),%eax
  803775:	85 c0                	test   %eax,%eax
  803777:	75 08                	jne    803781 <insert_sorted_with_merge_freeList+0x703>
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803781:	a1 44 51 80 00       	mov    0x805144,%eax
  803786:	40                   	inc    %eax
  803787:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80378c:	eb 39                	jmp    8037c7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80378e:	a1 40 51 80 00       	mov    0x805140,%eax
  803793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80379a:	74 07                	je     8037a3 <insert_sorted_with_merge_freeList+0x725>
  80379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	eb 05                	jmp    8037a8 <insert_sorted_with_merge_freeList+0x72a>
  8037a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a8:	a3 40 51 80 00       	mov    %eax,0x805140
  8037ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8037b2:	85 c0                	test   %eax,%eax
  8037b4:	0f 85 c7 fb ff ff    	jne    803381 <insert_sorted_with_merge_freeList+0x303>
  8037ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037be:	0f 85 bd fb ff ff    	jne    803381 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037c4:	eb 01                	jmp    8037c7 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037c6:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037c7:	90                   	nop
  8037c8:	c9                   	leave  
  8037c9:	c3                   	ret    

008037ca <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8037ca:	55                   	push   %ebp
  8037cb:	89 e5                	mov    %esp,%ebp
  8037cd:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8037d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d3:	89 d0                	mov    %edx,%eax
  8037d5:	c1 e0 02             	shl    $0x2,%eax
  8037d8:	01 d0                	add    %edx,%eax
  8037da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037e1:	01 d0                	add    %edx,%eax
  8037e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037ea:	01 d0                	add    %edx,%eax
  8037ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037f3:	01 d0                	add    %edx,%eax
  8037f5:	c1 e0 04             	shl    $0x4,%eax
  8037f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8037fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803802:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803805:	83 ec 0c             	sub    $0xc,%esp
  803808:	50                   	push   %eax
  803809:	e8 26 e7 ff ff       	call   801f34 <sys_get_virtual_time>
  80380e:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803811:	eb 41                	jmp    803854 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803813:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803816:	83 ec 0c             	sub    $0xc,%esp
  803819:	50                   	push   %eax
  80381a:	e8 15 e7 ff ff       	call   801f34 <sys_get_virtual_time>
  80381f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803822:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803825:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803828:	29 c2                	sub    %eax,%edx
  80382a:	89 d0                	mov    %edx,%eax
  80382c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80382f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803832:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803835:	89 d1                	mov    %edx,%ecx
  803837:	29 c1                	sub    %eax,%ecx
  803839:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80383c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80383f:	39 c2                	cmp    %eax,%edx
  803841:	0f 97 c0             	seta   %al
  803844:	0f b6 c0             	movzbl %al,%eax
  803847:	29 c1                	sub    %eax,%ecx
  803849:	89 c8                	mov    %ecx,%eax
  80384b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80384e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803851:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803857:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80385a:	72 b7                	jb     803813 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80385c:	90                   	nop
  80385d:	c9                   	leave  
  80385e:	c3                   	ret    

0080385f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80385f:	55                   	push   %ebp
  803860:	89 e5                	mov    %esp,%ebp
  803862:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803865:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80386c:	eb 03                	jmp    803871 <busy_wait+0x12>
  80386e:	ff 45 fc             	incl   -0x4(%ebp)
  803871:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803874:	3b 45 08             	cmp    0x8(%ebp),%eax
  803877:	72 f5                	jb     80386e <busy_wait+0xf>
	return i;
  803879:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80387c:	c9                   	leave  
  80387d:	c3                   	ret    
  80387e:	66 90                	xchg   %ax,%ax

00803880 <__udivdi3>:
  803880:	55                   	push   %ebp
  803881:	57                   	push   %edi
  803882:	56                   	push   %esi
  803883:	53                   	push   %ebx
  803884:	83 ec 1c             	sub    $0x1c,%esp
  803887:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80388b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80388f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803893:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803897:	89 ca                	mov    %ecx,%edx
  803899:	89 f8                	mov    %edi,%eax
  80389b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80389f:	85 f6                	test   %esi,%esi
  8038a1:	75 2d                	jne    8038d0 <__udivdi3+0x50>
  8038a3:	39 cf                	cmp    %ecx,%edi
  8038a5:	77 65                	ja     80390c <__udivdi3+0x8c>
  8038a7:	89 fd                	mov    %edi,%ebp
  8038a9:	85 ff                	test   %edi,%edi
  8038ab:	75 0b                	jne    8038b8 <__udivdi3+0x38>
  8038ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8038b2:	31 d2                	xor    %edx,%edx
  8038b4:	f7 f7                	div    %edi
  8038b6:	89 c5                	mov    %eax,%ebp
  8038b8:	31 d2                	xor    %edx,%edx
  8038ba:	89 c8                	mov    %ecx,%eax
  8038bc:	f7 f5                	div    %ebp
  8038be:	89 c1                	mov    %eax,%ecx
  8038c0:	89 d8                	mov    %ebx,%eax
  8038c2:	f7 f5                	div    %ebp
  8038c4:	89 cf                	mov    %ecx,%edi
  8038c6:	89 fa                	mov    %edi,%edx
  8038c8:	83 c4 1c             	add    $0x1c,%esp
  8038cb:	5b                   	pop    %ebx
  8038cc:	5e                   	pop    %esi
  8038cd:	5f                   	pop    %edi
  8038ce:	5d                   	pop    %ebp
  8038cf:	c3                   	ret    
  8038d0:	39 ce                	cmp    %ecx,%esi
  8038d2:	77 28                	ja     8038fc <__udivdi3+0x7c>
  8038d4:	0f bd fe             	bsr    %esi,%edi
  8038d7:	83 f7 1f             	xor    $0x1f,%edi
  8038da:	75 40                	jne    80391c <__udivdi3+0x9c>
  8038dc:	39 ce                	cmp    %ecx,%esi
  8038de:	72 0a                	jb     8038ea <__udivdi3+0x6a>
  8038e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038e4:	0f 87 9e 00 00 00    	ja     803988 <__udivdi3+0x108>
  8038ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ef:	89 fa                	mov    %edi,%edx
  8038f1:	83 c4 1c             	add    $0x1c,%esp
  8038f4:	5b                   	pop    %ebx
  8038f5:	5e                   	pop    %esi
  8038f6:	5f                   	pop    %edi
  8038f7:	5d                   	pop    %ebp
  8038f8:	c3                   	ret    
  8038f9:	8d 76 00             	lea    0x0(%esi),%esi
  8038fc:	31 ff                	xor    %edi,%edi
  8038fe:	31 c0                	xor    %eax,%eax
  803900:	89 fa                	mov    %edi,%edx
  803902:	83 c4 1c             	add    $0x1c,%esp
  803905:	5b                   	pop    %ebx
  803906:	5e                   	pop    %esi
  803907:	5f                   	pop    %edi
  803908:	5d                   	pop    %ebp
  803909:	c3                   	ret    
  80390a:	66 90                	xchg   %ax,%ax
  80390c:	89 d8                	mov    %ebx,%eax
  80390e:	f7 f7                	div    %edi
  803910:	31 ff                	xor    %edi,%edi
  803912:	89 fa                	mov    %edi,%edx
  803914:	83 c4 1c             	add    $0x1c,%esp
  803917:	5b                   	pop    %ebx
  803918:	5e                   	pop    %esi
  803919:	5f                   	pop    %edi
  80391a:	5d                   	pop    %ebp
  80391b:	c3                   	ret    
  80391c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803921:	89 eb                	mov    %ebp,%ebx
  803923:	29 fb                	sub    %edi,%ebx
  803925:	89 f9                	mov    %edi,%ecx
  803927:	d3 e6                	shl    %cl,%esi
  803929:	89 c5                	mov    %eax,%ebp
  80392b:	88 d9                	mov    %bl,%cl
  80392d:	d3 ed                	shr    %cl,%ebp
  80392f:	89 e9                	mov    %ebp,%ecx
  803931:	09 f1                	or     %esi,%ecx
  803933:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803937:	89 f9                	mov    %edi,%ecx
  803939:	d3 e0                	shl    %cl,%eax
  80393b:	89 c5                	mov    %eax,%ebp
  80393d:	89 d6                	mov    %edx,%esi
  80393f:	88 d9                	mov    %bl,%cl
  803941:	d3 ee                	shr    %cl,%esi
  803943:	89 f9                	mov    %edi,%ecx
  803945:	d3 e2                	shl    %cl,%edx
  803947:	8b 44 24 08          	mov    0x8(%esp),%eax
  80394b:	88 d9                	mov    %bl,%cl
  80394d:	d3 e8                	shr    %cl,%eax
  80394f:	09 c2                	or     %eax,%edx
  803951:	89 d0                	mov    %edx,%eax
  803953:	89 f2                	mov    %esi,%edx
  803955:	f7 74 24 0c          	divl   0xc(%esp)
  803959:	89 d6                	mov    %edx,%esi
  80395b:	89 c3                	mov    %eax,%ebx
  80395d:	f7 e5                	mul    %ebp
  80395f:	39 d6                	cmp    %edx,%esi
  803961:	72 19                	jb     80397c <__udivdi3+0xfc>
  803963:	74 0b                	je     803970 <__udivdi3+0xf0>
  803965:	89 d8                	mov    %ebx,%eax
  803967:	31 ff                	xor    %edi,%edi
  803969:	e9 58 ff ff ff       	jmp    8038c6 <__udivdi3+0x46>
  80396e:	66 90                	xchg   %ax,%ax
  803970:	8b 54 24 08          	mov    0x8(%esp),%edx
  803974:	89 f9                	mov    %edi,%ecx
  803976:	d3 e2                	shl    %cl,%edx
  803978:	39 c2                	cmp    %eax,%edx
  80397a:	73 e9                	jae    803965 <__udivdi3+0xe5>
  80397c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80397f:	31 ff                	xor    %edi,%edi
  803981:	e9 40 ff ff ff       	jmp    8038c6 <__udivdi3+0x46>
  803986:	66 90                	xchg   %ax,%ax
  803988:	31 c0                	xor    %eax,%eax
  80398a:	e9 37 ff ff ff       	jmp    8038c6 <__udivdi3+0x46>
  80398f:	90                   	nop

00803990 <__umoddi3>:
  803990:	55                   	push   %ebp
  803991:	57                   	push   %edi
  803992:	56                   	push   %esi
  803993:	53                   	push   %ebx
  803994:	83 ec 1c             	sub    $0x1c,%esp
  803997:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80399b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80399f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039af:	89 f3                	mov    %esi,%ebx
  8039b1:	89 fa                	mov    %edi,%edx
  8039b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039b7:	89 34 24             	mov    %esi,(%esp)
  8039ba:	85 c0                	test   %eax,%eax
  8039bc:	75 1a                	jne    8039d8 <__umoddi3+0x48>
  8039be:	39 f7                	cmp    %esi,%edi
  8039c0:	0f 86 a2 00 00 00    	jbe    803a68 <__umoddi3+0xd8>
  8039c6:	89 c8                	mov    %ecx,%eax
  8039c8:	89 f2                	mov    %esi,%edx
  8039ca:	f7 f7                	div    %edi
  8039cc:	89 d0                	mov    %edx,%eax
  8039ce:	31 d2                	xor    %edx,%edx
  8039d0:	83 c4 1c             	add    $0x1c,%esp
  8039d3:	5b                   	pop    %ebx
  8039d4:	5e                   	pop    %esi
  8039d5:	5f                   	pop    %edi
  8039d6:	5d                   	pop    %ebp
  8039d7:	c3                   	ret    
  8039d8:	39 f0                	cmp    %esi,%eax
  8039da:	0f 87 ac 00 00 00    	ja     803a8c <__umoddi3+0xfc>
  8039e0:	0f bd e8             	bsr    %eax,%ebp
  8039e3:	83 f5 1f             	xor    $0x1f,%ebp
  8039e6:	0f 84 ac 00 00 00    	je     803a98 <__umoddi3+0x108>
  8039ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8039f1:	29 ef                	sub    %ebp,%edi
  8039f3:	89 fe                	mov    %edi,%esi
  8039f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039f9:	89 e9                	mov    %ebp,%ecx
  8039fb:	d3 e0                	shl    %cl,%eax
  8039fd:	89 d7                	mov    %edx,%edi
  8039ff:	89 f1                	mov    %esi,%ecx
  803a01:	d3 ef                	shr    %cl,%edi
  803a03:	09 c7                	or     %eax,%edi
  803a05:	89 e9                	mov    %ebp,%ecx
  803a07:	d3 e2                	shl    %cl,%edx
  803a09:	89 14 24             	mov    %edx,(%esp)
  803a0c:	89 d8                	mov    %ebx,%eax
  803a0e:	d3 e0                	shl    %cl,%eax
  803a10:	89 c2                	mov    %eax,%edx
  803a12:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a16:	d3 e0                	shl    %cl,%eax
  803a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a20:	89 f1                	mov    %esi,%ecx
  803a22:	d3 e8                	shr    %cl,%eax
  803a24:	09 d0                	or     %edx,%eax
  803a26:	d3 eb                	shr    %cl,%ebx
  803a28:	89 da                	mov    %ebx,%edx
  803a2a:	f7 f7                	div    %edi
  803a2c:	89 d3                	mov    %edx,%ebx
  803a2e:	f7 24 24             	mull   (%esp)
  803a31:	89 c6                	mov    %eax,%esi
  803a33:	89 d1                	mov    %edx,%ecx
  803a35:	39 d3                	cmp    %edx,%ebx
  803a37:	0f 82 87 00 00 00    	jb     803ac4 <__umoddi3+0x134>
  803a3d:	0f 84 91 00 00 00    	je     803ad4 <__umoddi3+0x144>
  803a43:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a47:	29 f2                	sub    %esi,%edx
  803a49:	19 cb                	sbb    %ecx,%ebx
  803a4b:	89 d8                	mov    %ebx,%eax
  803a4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a51:	d3 e0                	shl    %cl,%eax
  803a53:	89 e9                	mov    %ebp,%ecx
  803a55:	d3 ea                	shr    %cl,%edx
  803a57:	09 d0                	or     %edx,%eax
  803a59:	89 e9                	mov    %ebp,%ecx
  803a5b:	d3 eb                	shr    %cl,%ebx
  803a5d:	89 da                	mov    %ebx,%edx
  803a5f:	83 c4 1c             	add    $0x1c,%esp
  803a62:	5b                   	pop    %ebx
  803a63:	5e                   	pop    %esi
  803a64:	5f                   	pop    %edi
  803a65:	5d                   	pop    %ebp
  803a66:	c3                   	ret    
  803a67:	90                   	nop
  803a68:	89 fd                	mov    %edi,%ebp
  803a6a:	85 ff                	test   %edi,%edi
  803a6c:	75 0b                	jne    803a79 <__umoddi3+0xe9>
  803a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a73:	31 d2                	xor    %edx,%edx
  803a75:	f7 f7                	div    %edi
  803a77:	89 c5                	mov    %eax,%ebp
  803a79:	89 f0                	mov    %esi,%eax
  803a7b:	31 d2                	xor    %edx,%edx
  803a7d:	f7 f5                	div    %ebp
  803a7f:	89 c8                	mov    %ecx,%eax
  803a81:	f7 f5                	div    %ebp
  803a83:	89 d0                	mov    %edx,%eax
  803a85:	e9 44 ff ff ff       	jmp    8039ce <__umoddi3+0x3e>
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	89 c8                	mov    %ecx,%eax
  803a8e:	89 f2                	mov    %esi,%edx
  803a90:	83 c4 1c             	add    $0x1c,%esp
  803a93:	5b                   	pop    %ebx
  803a94:	5e                   	pop    %esi
  803a95:	5f                   	pop    %edi
  803a96:	5d                   	pop    %ebp
  803a97:	c3                   	ret    
  803a98:	3b 04 24             	cmp    (%esp),%eax
  803a9b:	72 06                	jb     803aa3 <__umoddi3+0x113>
  803a9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803aa1:	77 0f                	ja     803ab2 <__umoddi3+0x122>
  803aa3:	89 f2                	mov    %esi,%edx
  803aa5:	29 f9                	sub    %edi,%ecx
  803aa7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aab:	89 14 24             	mov    %edx,(%esp)
  803aae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ab6:	8b 14 24             	mov    (%esp),%edx
  803ab9:	83 c4 1c             	add    $0x1c,%esp
  803abc:	5b                   	pop    %ebx
  803abd:	5e                   	pop    %esi
  803abe:	5f                   	pop    %edi
  803abf:	5d                   	pop    %ebp
  803ac0:	c3                   	ret    
  803ac1:	8d 76 00             	lea    0x0(%esi),%esi
  803ac4:	2b 04 24             	sub    (%esp),%eax
  803ac7:	19 fa                	sbb    %edi,%edx
  803ac9:	89 d1                	mov    %edx,%ecx
  803acb:	89 c6                	mov    %eax,%esi
  803acd:	e9 71 ff ff ff       	jmp    803a43 <__umoddi3+0xb3>
  803ad2:	66 90                	xchg   %ax,%ax
  803ad4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ad8:	72 ea                	jb     803ac4 <__umoddi3+0x134>
  803ada:	89 d9                	mov    %ebx,%ecx
  803adc:	e9 62 ff ff ff       	jmp    803a43 <__umoddi3+0xb3>
