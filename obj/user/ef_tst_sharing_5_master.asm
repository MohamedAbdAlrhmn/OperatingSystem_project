
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
  80008d:	68 60 39 80 00       	push   $0x803960
  800092:	6a 12                	push   $0x12
  800094:	68 7c 39 80 00       	push   $0x80397c
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 9c 39 80 00       	push   $0x80399c
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 d0 39 80 00       	push   $0x8039d0
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 2c 3a 80 00       	push   $0x803a2c
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 67 1c 00 00       	call   801d3a <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 60 3a 80 00       	push   $0x803a60
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
  8000ff:	68 a1 3a 80 00       	push   $0x803aa1
  800104:	e8 dc 1b 00 00       	call   801ce5 <sys_create_env>
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
  800128:	68 a1 3a 80 00       	push   $0x803aa1
  80012d:	e8 b3 1b 00 00       	call   801ce5 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 36 19 00 00       	call   801a73 <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 af 3a 80 00       	push   $0x803aaf
  80014f:	e8 df 16 00 00       	call   801833 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 b4 3a 80 00       	push   $0x803ab4
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 d4 3a 80 00       	push   $0x803ad4
  80017b:	6a 26                	push   $0x26
  80017d:	68 7c 39 80 00       	push   $0x80397c
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 e4 18 00 00       	call   801a73 <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 40 3b 80 00       	push   $0x803b40
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 7c 39 80 00       	push   $0x80397c
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 80 1c 00 00       	call   801e31 <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 47 1b 00 00       	call   801d03 <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 39 1b 00 00       	call   801d03 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 be 3b 80 00       	push   $0x803bbe
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 4b 34 00 00       	call   803635 <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 b9 1c 00 00       	call   801eab <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 d5 3b 80 00       	push   $0x803bd5
  8001ff:	6a 33                	push   $0x33
  800201:	68 7c 39 80 00       	push   $0x80397c
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 fd 16 00 00       	call   801913 <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 e4 3b 80 00       	push   $0x803be4
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 45 18 00 00       	call   801a73 <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 04 3c 80 00       	push   $0x803c04
  800248:	6a 38                	push   $0x38
  80024a:	68 7c 39 80 00       	push   $0x80397c
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 34 3c 80 00       	push   $0x803c34
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 58 3c 80 00       	push   $0x803c58
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
  80028d:	68 88 3c 80 00       	push   $0x803c88
  800292:	e8 4e 1a 00 00       	call   801ce5 <sys_create_env>
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
  8002b6:	68 98 3c 80 00       	push   $0x803c98
  8002bb:	e8 25 1a 00 00       	call   801ce5 <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 a8 3c 80 00       	push   $0x803ca8
  8002d5:	e8 59 15 00 00       	call   801833 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 ac 3c 80 00       	push   $0x803cac
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 af 3a 80 00       	push   $0x803aaf
  8002ff:	e8 2f 15 00 00       	call   801833 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 b4 3a 80 00       	push   $0x803ab4
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 12 1b 00 00       	call   801e31 <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 d9 19 00 00       	call   801d03 <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 cb 19 00 00       	call   801d03 <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 ed 32 00 00       	call   803635 <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 23 17 00 00       	call   801a73 <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 b5 15 00 00       	call   801913 <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 cc 3c 80 00       	push   $0x803ccc
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 97 15 00 00       	call   801913 <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 e2 3c 80 00       	push   $0x803ce2
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 df 16 00 00       	call   801a73 <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 f8 3c 80 00       	push   $0x803cf8
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 7c 39 80 00       	push   $0x80397c
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 d2 1a 00 00       	call   801e91 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 9d 3d 80 00       	push   $0x803d9d
  8003cb:	e8 63 14 00 00       	call   801833 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 88 19 00 00       	call   801d6c <sys_getparentenvid>
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
  8003fa:	68 ad 3d 80 00       	push   $0x803dad
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 0d 19 00 00       	call   801d1f <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 ff 18 00 00       	call   801d1f <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 f1 18 00 00       	call   801d1f <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 e3 18 00 00       	call   801d1f <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 21 19 00 00       	call   801d6c <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 b3 3d 80 00       	push   $0x803db3
  800453:	50                   	push   %eax
  800454:	e8 76 14 00 00       	call   8018cf <sget>
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
  800479:	e8 d5 18 00 00       	call   801d53 <sys_getenvindex>
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
  8004e4:	e8 77 16 00 00       	call   801b60 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 dc 3d 80 00       	push   $0x803ddc
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
  800514:	68 04 3e 80 00       	push   $0x803e04
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
  800545:	68 2c 3e 80 00       	push   $0x803e2c
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 84 3e 80 00       	push   $0x803e84
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 dc 3d 80 00       	push   $0x803ddc
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 f7 15 00 00       	call   801b7a <sys_enable_interrupt>

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
  800596:	e8 84 17 00 00       	call   801d1f <sys_destroy_env>
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
  8005a7:	e8 d9 17 00 00       	call   801d85 <sys_exit_env>
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
  8005d0:	68 98 3e 80 00       	push   $0x803e98
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 9d 3e 80 00       	push   $0x803e9d
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
  80060d:	68 b9 3e 80 00       	push   $0x803eb9
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
  800639:	68 bc 3e 80 00       	push   $0x803ebc
  80063e:	6a 26                	push   $0x26
  800640:	68 08 3f 80 00       	push   $0x803f08
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
  80070b:	68 14 3f 80 00       	push   $0x803f14
  800710:	6a 3a                	push   $0x3a
  800712:	68 08 3f 80 00       	push   $0x803f08
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
  80077b:	68 68 3f 80 00       	push   $0x803f68
  800780:	6a 44                	push   $0x44
  800782:	68 08 3f 80 00       	push   $0x803f08
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
  8007d5:	e8 d8 11 00 00       	call   8019b2 <sys_cputs>
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
  80084c:	e8 61 11 00 00       	call   8019b2 <sys_cputs>
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
  800896:	e8 c5 12 00 00       	call   801b60 <sys_disable_interrupt>
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
  8008b6:	e8 bf 12 00 00       	call   801b7a <sys_enable_interrupt>
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
  800900:	e8 e7 2d 00 00       	call   8036ec <__udivdi3>
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
  800950:	e8 a7 2e 00 00       	call   8037fc <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 d4 41 80 00       	add    $0x8041d4,%eax
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
  800aab:	8b 04 85 f8 41 80 00 	mov    0x8041f8(,%eax,4),%eax
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
  800b8c:	8b 34 9d 40 40 80 00 	mov    0x804040(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 e5 41 80 00       	push   $0x8041e5
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
  800bb1:	68 ee 41 80 00       	push   $0x8041ee
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
  800bde:	be f1 41 80 00       	mov    $0x8041f1,%esi
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
  801604:	68 50 43 80 00       	push   $0x804350
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
  8016d4:	e8 1d 04 00 00       	call   801af6 <sys_allocate_chunk>
  8016d9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016dc:	a1 20 51 80 00       	mov    0x805120,%eax
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	50                   	push   %eax
  8016e5:	e8 92 0a 00 00       	call   80217c <initialize_MemBlocksList>
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
  801712:	68 75 43 80 00       	push   $0x804375
  801717:	6a 33                	push   $0x33
  801719:	68 93 43 80 00       	push   $0x804393
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
  801791:	68 a0 43 80 00       	push   $0x8043a0
  801796:	6a 34                	push   $0x34
  801798:	68 93 43 80 00       	push   $0x804393
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
  801806:	68 c4 43 80 00       	push   $0x8043c4
  80180b:	6a 46                	push   $0x46
  80180d:	68 93 43 80 00       	push   $0x804393
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
  801822:	68 ec 43 80 00       	push   $0x8043ec
  801827:	6a 61                	push   $0x61
  801829:	68 93 43 80 00       	push   $0x804393
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
  801848:	75 07                	jne    801851 <smalloc+0x1e>
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	eb 7c                	jmp    8018cd <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801851:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185e:	01 d0                	add    %edx,%eax
  801860:	48                   	dec    %eax
  801861:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801867:	ba 00 00 00 00       	mov    $0x0,%edx
  80186c:	f7 75 f0             	divl   -0x10(%ebp)
  80186f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801872:	29 d0                	sub    %edx,%eax
  801874:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801877:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80187e:	e8 41 06 00 00       	call   801ec4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801883:	85 c0                	test   %eax,%eax
  801885:	74 11                	je     801898 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	ff 75 e8             	pushl  -0x18(%ebp)
  80188d:	e8 ac 0c 00 00       	call   80253e <alloc_block_FF>
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80189c:	74 2a                	je     8018c8 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a1:	8b 40 08             	mov    0x8(%eax),%eax
  8018a4:	89 c2                	mov    %eax,%edx
  8018a6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	e8 92 03 00 00       	call   801c49 <sys_createSharedObject>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8018bd:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8018c1:	74 05                	je     8018c8 <smalloc+0x95>
			return (void*)virtual_address;
  8018c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c6:	eb 05                	jmp    8018cd <smalloc+0x9a>
	}
	return NULL;
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d5:	e8 13 fd ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	68 10 44 80 00       	push   $0x804410
  8018e2:	68 a2 00 00 00       	push   $0xa2
  8018e7:	68 93 43 80 00       	push   $0x804393
  8018ec:	e8 be ec ff ff       	call   8005af <_panic>

008018f1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018f7:	e8 f1 fc ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	68 34 44 80 00       	push   $0x804434
  801904:	68 e6 00 00 00       	push   $0xe6
  801909:	68 93 43 80 00       	push   $0x804393
  80190e:	e8 9c ec ff ff       	call   8005af <_panic>

00801913 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801919:	83 ec 04             	sub    $0x4,%esp
  80191c:	68 5c 44 80 00       	push   $0x80445c
  801921:	68 fa 00 00 00       	push   $0xfa
  801926:	68 93 43 80 00       	push   $0x804393
  80192b:	e8 7f ec ff ff       	call   8005af <_panic>

00801930 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801936:	83 ec 04             	sub    $0x4,%esp
  801939:	68 80 44 80 00       	push   $0x804480
  80193e:	68 05 01 00 00       	push   $0x105
  801943:	68 93 43 80 00       	push   $0x804393
  801948:	e8 62 ec ff ff       	call   8005af <_panic>

0080194d <shrink>:

}
void shrink(uint32 newSize)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801953:	83 ec 04             	sub    $0x4,%esp
  801956:	68 80 44 80 00       	push   $0x804480
  80195b:	68 0a 01 00 00       	push   $0x10a
  801960:	68 93 43 80 00       	push   $0x804393
  801965:	e8 45 ec ff ff       	call   8005af <_panic>

0080196a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801970:	83 ec 04             	sub    $0x4,%esp
  801973:	68 80 44 80 00       	push   $0x804480
  801978:	68 0f 01 00 00       	push   $0x10f
  80197d:	68 93 43 80 00       	push   $0x804393
  801982:	e8 28 ec ff ff       	call   8005af <_panic>

00801987 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	57                   	push   %edi
  80198b:	56                   	push   %esi
  80198c:	53                   	push   %ebx
  80198d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8b 55 0c             	mov    0xc(%ebp),%edx
  801996:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801999:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80199c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80199f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019a2:	cd 30                	int    $0x30
  8019a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	5b                   	pop    %ebx
  8019ae:	5e                   	pop    %esi
  8019af:	5f                   	pop    %edi
  8019b0:	5d                   	pop    %ebp
  8019b1:	c3                   	ret    

008019b2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	52                   	push   %edx
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	50                   	push   %eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	e8 b2 ff ff ff       	call   801987 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_cgetc>:

int
sys_cgetc(void)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 01                	push   $0x1
  8019ea:	e8 98 ff ff ff       	call   801987 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	52                   	push   %edx
  801a04:	50                   	push   %eax
  801a05:	6a 05                	push   $0x5
  801a07:	e8 7b ff ff ff       	call   801987 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	56                   	push   %esi
  801a15:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a16:	8b 75 18             	mov    0x18(%ebp),%esi
  801a19:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	56                   	push   %esi
  801a26:	53                   	push   %ebx
  801a27:	51                   	push   %ecx
  801a28:	52                   	push   %edx
  801a29:	50                   	push   %eax
  801a2a:	6a 06                	push   $0x6
  801a2c:	e8 56 ff ff ff       	call   801987 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5d                   	pop    %ebp
  801a3a:	c3                   	ret    

00801a3b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	52                   	push   %edx
  801a4b:	50                   	push   %eax
  801a4c:	6a 07                	push   $0x7
  801a4e:	e8 34 ff ff ff       	call   801987 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	ff 75 0c             	pushl  0xc(%ebp)
  801a64:	ff 75 08             	pushl  0x8(%ebp)
  801a67:	6a 08                	push   $0x8
  801a69:	e8 19 ff ff ff       	call   801987 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 09                	push   $0x9
  801a82:	e8 00 ff ff ff       	call   801987 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 0a                	push   $0xa
  801a9b:	e8 e7 fe ff ff       	call   801987 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 0b                	push   $0xb
  801ab4:	e8 ce fe ff ff       	call   801987 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	ff 75 0c             	pushl  0xc(%ebp)
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	6a 0f                	push   $0xf
  801acf:	e8 b3 fe ff ff       	call   801987 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
	return;
  801ad7:	90                   	nop
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	ff 75 0c             	pushl  0xc(%ebp)
  801ae6:	ff 75 08             	pushl  0x8(%ebp)
  801ae9:	6a 10                	push   $0x10
  801aeb:	e8 97 fe ff ff       	call   801987 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
	return ;
  801af3:	90                   	nop
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 10             	pushl  0x10(%ebp)
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	ff 75 08             	pushl  0x8(%ebp)
  801b06:	6a 11                	push   $0x11
  801b08:	e8 7a fe ff ff       	call   801987 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b10:	90                   	nop
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 0c                	push   $0xc
  801b22:	e8 60 fe ff ff       	call   801987 <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	6a 0d                	push   $0xd
  801b3c:	e8 46 fe ff ff       	call   801987 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 0e                	push   $0xe
  801b55:	e8 2d fe ff ff       	call   801987 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	90                   	nop
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 13                	push   $0x13
  801b6f:	e8 13 fe ff ff       	call   801987 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	90                   	nop
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 14                	push   $0x14
  801b89:	e8 f9 fd ff ff       	call   801987 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	90                   	nop
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 04             	sub    $0x4,%esp
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ba0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	50                   	push   %eax
  801bad:	6a 15                	push   $0x15
  801baf:	e8 d3 fd ff ff       	call   801987 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	90                   	nop
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 16                	push   $0x16
  801bc9:	e8 b9 fd ff ff       	call   801987 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	90                   	nop
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	50                   	push   %eax
  801be4:	6a 17                	push   $0x17
  801be6:	e8 9c fd ff ff       	call   801987 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	52                   	push   %edx
  801c00:	50                   	push   %eax
  801c01:	6a 1a                	push   $0x1a
  801c03:	e8 7f fd ff ff       	call   801987 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	52                   	push   %edx
  801c1d:	50                   	push   %eax
  801c1e:	6a 18                	push   $0x18
  801c20:	e8 62 fd ff ff       	call   801987 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	90                   	nop
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	52                   	push   %edx
  801c3b:	50                   	push   %eax
  801c3c:	6a 19                	push   $0x19
  801c3e:	e8 44 fd ff ff       	call   801987 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c52:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c55:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c58:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	6a 00                	push   $0x0
  801c61:	51                   	push   %ecx
  801c62:	52                   	push   %edx
  801c63:	ff 75 0c             	pushl  0xc(%ebp)
  801c66:	50                   	push   %eax
  801c67:	6a 1b                	push   $0x1b
  801c69:	e8 19 fd ff ff       	call   801987 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	52                   	push   %edx
  801c83:	50                   	push   %eax
  801c84:	6a 1c                	push   $0x1c
  801c86:	e8 fc fc ff ff       	call   801987 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c93:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	51                   	push   %ecx
  801ca1:	52                   	push   %edx
  801ca2:	50                   	push   %eax
  801ca3:	6a 1d                	push   $0x1d
  801ca5:	e8 dd fc ff ff       	call   801987 <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	52                   	push   %edx
  801cbf:	50                   	push   %eax
  801cc0:	6a 1e                	push   $0x1e
  801cc2:	e8 c0 fc ff ff       	call   801987 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 1f                	push   $0x1f
  801cdb:	e8 a7 fc ff ff       	call   801987 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	ff 75 14             	pushl  0x14(%ebp)
  801cf0:	ff 75 10             	pushl  0x10(%ebp)
  801cf3:	ff 75 0c             	pushl  0xc(%ebp)
  801cf6:	50                   	push   %eax
  801cf7:	6a 20                	push   $0x20
  801cf9:	e8 89 fc ff ff       	call   801987 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	50                   	push   %eax
  801d12:	6a 21                	push   $0x21
  801d14:	e8 6e fc ff ff       	call   801987 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	90                   	nop
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	50                   	push   %eax
  801d2e:	6a 22                	push   $0x22
  801d30:	e8 52 fc ff ff       	call   801987 <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 02                	push   $0x2
  801d49:	e8 39 fc ff ff       	call   801987 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 03                	push   $0x3
  801d62:	e8 20 fc ff ff       	call   801987 <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 04                	push   $0x4
  801d7b:	e8 07 fc ff ff       	call   801987 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_exit_env>:


void sys_exit_env(void)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 23                	push   $0x23
  801d94:	e8 ee fb ff ff       	call   801987 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	90                   	nop
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801da5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da8:	8d 50 04             	lea    0x4(%eax),%edx
  801dab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 24                	push   $0x24
  801db8:	e8 ca fb ff ff       	call   801987 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
	return result;
  801dc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dc9:	89 01                	mov    %eax,(%ecx)
  801dcb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	c9                   	leave  
  801dd2:	c2 04 00             	ret    $0x4

00801dd5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	ff 75 10             	pushl  0x10(%ebp)
  801ddf:	ff 75 0c             	pushl  0xc(%ebp)
  801de2:	ff 75 08             	pushl  0x8(%ebp)
  801de5:	6a 12                	push   $0x12
  801de7:	e8 9b fb ff ff       	call   801987 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
	return ;
  801def:	90                   	nop
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 25                	push   $0x25
  801e01:	e8 81 fb ff ff       	call   801987 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	83 ec 04             	sub    $0x4,%esp
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e17:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	50                   	push   %eax
  801e24:	6a 26                	push   $0x26
  801e26:	e8 5c fb ff ff       	call   801987 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2e:	90                   	nop
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <rsttst>:
void rsttst()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 28                	push   $0x28
  801e40:	e8 42 fb ff ff       	call   801987 <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
	return ;
  801e48:	90                   	nop
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	8b 45 14             	mov    0x14(%ebp),%eax
  801e54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e57:	8b 55 18             	mov    0x18(%ebp),%edx
  801e5a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5e:	52                   	push   %edx
  801e5f:	50                   	push   %eax
  801e60:	ff 75 10             	pushl  0x10(%ebp)
  801e63:	ff 75 0c             	pushl  0xc(%ebp)
  801e66:	ff 75 08             	pushl  0x8(%ebp)
  801e69:	6a 27                	push   $0x27
  801e6b:	e8 17 fb ff ff       	call   801987 <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
	return ;
  801e73:	90                   	nop
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <chktst>:
void chktst(uint32 n)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	ff 75 08             	pushl  0x8(%ebp)
  801e84:	6a 29                	push   $0x29
  801e86:	e8 fc fa ff ff       	call   801987 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8e:	90                   	nop
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <inctst>:

void inctst()
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 2a                	push   $0x2a
  801ea0:	e8 e2 fa ff ff       	call   801987 <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea8:	90                   	nop
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <gettst>:
uint32 gettst()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 2b                	push   $0x2b
  801eba:	e8 c8 fa ff ff       	call   801987 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 2c                	push   $0x2c
  801ed6:	e8 ac fa ff ff       	call   801987 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
  801ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ee1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ee5:	75 07                	jne    801eee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ee7:	b8 01 00 00 00       	mov    $0x1,%eax
  801eec:	eb 05                	jmp    801ef3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 2c                	push   $0x2c
  801f07:	e8 7b fa ff ff       	call   801987 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
  801f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f12:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f16:	75 07                	jne    801f1f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f18:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1d:	eb 05                	jmp    801f24 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 2c                	push   $0x2c
  801f38:	e8 4a fa ff ff       	call   801987 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
  801f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f43:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f47:	75 07                	jne    801f50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f49:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4e:	eb 05                	jmp    801f55 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 2c                	push   $0x2c
  801f69:	e8 19 fa ff ff       	call   801987 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
  801f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f74:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f78:	75 07                	jne    801f81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7f:	eb 05                	jmp    801f86 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	ff 75 08             	pushl  0x8(%ebp)
  801f96:	6a 2d                	push   $0x2d
  801f98:	e8 ea f9 ff ff       	call   801987 <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa0:	90                   	nop
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fa7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801faa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	53                   	push   %ebx
  801fb6:	51                   	push   %ecx
  801fb7:	52                   	push   %edx
  801fb8:	50                   	push   %eax
  801fb9:	6a 2e                	push   $0x2e
  801fbb:	e8 c7 f9 ff ff       	call   801987 <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
}
  801fc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	52                   	push   %edx
  801fd8:	50                   	push   %eax
  801fd9:	6a 2f                	push   $0x2f
  801fdb:	e8 a7 f9 ff ff       	call   801987 <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	68 90 44 80 00       	push   $0x804490
  801ff3:	e8 6b e8 ff ff       	call   800863 <cprintf>
  801ff8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ffb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802002:	83 ec 0c             	sub    $0xc,%esp
  802005:	68 bc 44 80 00       	push   $0x8044bc
  80200a:	e8 54 e8 ff ff       	call   800863 <cprintf>
  80200f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802012:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802016:	a1 38 51 80 00       	mov    0x805138,%eax
  80201b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201e:	eb 56                	jmp    802076 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802020:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802024:	74 1c                	je     802042 <print_mem_block_lists+0x5d>
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	8b 50 08             	mov    0x8(%eax),%edx
  80202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202f:	8b 48 08             	mov    0x8(%eax),%ecx
  802032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802035:	8b 40 0c             	mov    0xc(%eax),%eax
  802038:	01 c8                	add    %ecx,%eax
  80203a:	39 c2                	cmp    %eax,%edx
  80203c:	73 04                	jae    802042 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80203e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	8b 50 08             	mov    0x8(%eax),%edx
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	8b 40 0c             	mov    0xc(%eax),%eax
  80204e:	01 c2                	add    %eax,%edx
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	8b 40 08             	mov    0x8(%eax),%eax
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	68 d1 44 80 00       	push   $0x8044d1
  802060:	e8 fe e7 ff ff       	call   800863 <cprintf>
  802065:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80206e:	a1 40 51 80 00       	mov    0x805140,%eax
  802073:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802076:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207a:	74 07                	je     802083 <print_mem_block_lists+0x9e>
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	8b 00                	mov    (%eax),%eax
  802081:	eb 05                	jmp    802088 <print_mem_block_lists+0xa3>
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
  802088:	a3 40 51 80 00       	mov    %eax,0x805140
  80208d:	a1 40 51 80 00       	mov    0x805140,%eax
  802092:	85 c0                	test   %eax,%eax
  802094:	75 8a                	jne    802020 <print_mem_block_lists+0x3b>
  802096:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209a:	75 84                	jne    802020 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80209c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020a0:	75 10                	jne    8020b2 <print_mem_block_lists+0xcd>
  8020a2:	83 ec 0c             	sub    $0xc,%esp
  8020a5:	68 e0 44 80 00       	push   $0x8044e0
  8020aa:	e8 b4 e7 ff ff       	call   800863 <cprintf>
  8020af:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	68 04 45 80 00       	push   $0x804504
  8020c1:	e8 9d e7 ff ff       	call   800863 <cprintf>
  8020c6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020c9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8020d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d5:	eb 56                	jmp    80212d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020db:	74 1c                	je     8020f9 <print_mem_block_lists+0x114>
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	8b 50 08             	mov    0x8(%eax),%edx
  8020e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e6:	8b 48 08             	mov    0x8(%eax),%ecx
  8020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ef:	01 c8                	add    %ecx,%eax
  8020f1:	39 c2                	cmp    %eax,%edx
  8020f3:	73 04                	jae    8020f9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020f5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	8b 50 08             	mov    0x8(%eax),%edx
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	8b 40 0c             	mov    0xc(%eax),%eax
  802105:	01 c2                	add    %eax,%edx
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	8b 40 08             	mov    0x8(%eax),%eax
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	52                   	push   %edx
  802111:	50                   	push   %eax
  802112:	68 d1 44 80 00       	push   $0x8044d1
  802117:	e8 47 e7 ff ff       	call   800863 <cprintf>
  80211c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802125:	a1 48 50 80 00       	mov    0x805048,%eax
  80212a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802131:	74 07                	je     80213a <print_mem_block_lists+0x155>
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	eb 05                	jmp    80213f <print_mem_block_lists+0x15a>
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
  80213f:	a3 48 50 80 00       	mov    %eax,0x805048
  802144:	a1 48 50 80 00       	mov    0x805048,%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	75 8a                	jne    8020d7 <print_mem_block_lists+0xf2>
  80214d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802151:	75 84                	jne    8020d7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802153:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802157:	75 10                	jne    802169 <print_mem_block_lists+0x184>
  802159:	83 ec 0c             	sub    $0xc,%esp
  80215c:	68 1c 45 80 00       	push   $0x80451c
  802161:	e8 fd e6 ff ff       	call   800863 <cprintf>
  802166:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	68 90 44 80 00       	push   $0x804490
  802171:	e8 ed e6 ff ff       	call   800863 <cprintf>
  802176:	83 c4 10             	add    $0x10,%esp

}
  802179:	90                   	nop
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802182:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802189:	00 00 00 
  80218c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802193:	00 00 00 
  802196:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80219d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8021a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021a7:	e9 9e 00 00 00       	jmp    80224a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8021ac:	a1 50 50 80 00       	mov    0x805050,%eax
  8021b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b4:	c1 e2 04             	shl    $0x4,%edx
  8021b7:	01 d0                	add    %edx,%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	75 14                	jne    8021d1 <initialize_MemBlocksList+0x55>
  8021bd:	83 ec 04             	sub    $0x4,%esp
  8021c0:	68 44 45 80 00       	push   $0x804544
  8021c5:	6a 46                	push   $0x46
  8021c7:	68 67 45 80 00       	push   $0x804567
  8021cc:	e8 de e3 ff ff       	call   8005af <_panic>
  8021d1:	a1 50 50 80 00       	mov    0x805050,%eax
  8021d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d9:	c1 e2 04             	shl    $0x4,%edx
  8021dc:	01 d0                	add    %edx,%eax
  8021de:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021e4:	89 10                	mov    %edx,(%eax)
  8021e6:	8b 00                	mov    (%eax),%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	74 18                	je     802204 <initialize_MemBlocksList+0x88>
  8021ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8021f1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021fa:	c1 e1 04             	shl    $0x4,%ecx
  8021fd:	01 ca                	add    %ecx,%edx
  8021ff:	89 50 04             	mov    %edx,0x4(%eax)
  802202:	eb 12                	jmp    802216 <initialize_MemBlocksList+0x9a>
  802204:	a1 50 50 80 00       	mov    0x805050,%eax
  802209:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220c:	c1 e2 04             	shl    $0x4,%edx
  80220f:	01 d0                	add    %edx,%eax
  802211:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802216:	a1 50 50 80 00       	mov    0x805050,%eax
  80221b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221e:	c1 e2 04             	shl    $0x4,%edx
  802221:	01 d0                	add    %edx,%eax
  802223:	a3 48 51 80 00       	mov    %eax,0x805148
  802228:	a1 50 50 80 00       	mov    0x805050,%eax
  80222d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802230:	c1 e2 04             	shl    $0x4,%edx
  802233:	01 d0                	add    %edx,%eax
  802235:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80223c:	a1 54 51 80 00       	mov    0x805154,%eax
  802241:	40                   	inc    %eax
  802242:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802247:	ff 45 f4             	incl   -0xc(%ebp)
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802250:	0f 82 56 ff ff ff    	jb     8021ac <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802256:	90                   	nop
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	8b 00                	mov    (%eax),%eax
  802264:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802267:	eb 19                	jmp    802282 <find_block+0x29>
	{
		if(va==point->sva)
  802269:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80226c:	8b 40 08             	mov    0x8(%eax),%eax
  80226f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802272:	75 05                	jne    802279 <find_block+0x20>
		   return point;
  802274:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802277:	eb 36                	jmp    8022af <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	8b 40 08             	mov    0x8(%eax),%eax
  80227f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802282:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802286:	74 07                	je     80228f <find_block+0x36>
  802288:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80228b:	8b 00                	mov    (%eax),%eax
  80228d:	eb 05                	jmp    802294 <find_block+0x3b>
  80228f:	b8 00 00 00 00       	mov    $0x0,%eax
  802294:	8b 55 08             	mov    0x8(%ebp),%edx
  802297:	89 42 08             	mov    %eax,0x8(%edx)
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	8b 40 08             	mov    0x8(%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	75 c5                	jne    802269 <find_block+0x10>
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a8:	75 bf                	jne    802269 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8022aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8022b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8022bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8022bf:	a1 44 50 80 00       	mov    0x805044,%eax
  8022c4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8022c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022cd:	74 24                	je     8022f3 <insert_sorted_allocList+0x42>
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	8b 50 08             	mov    0x8(%eax),%edx
  8022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d8:	8b 40 08             	mov    0x8(%eax),%eax
  8022db:	39 c2                	cmp    %eax,%edx
  8022dd:	76 14                	jbe    8022f3 <insert_sorted_allocList+0x42>
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8b 50 08             	mov    0x8(%eax),%edx
  8022e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e8:	8b 40 08             	mov    0x8(%eax),%eax
  8022eb:	39 c2                	cmp    %eax,%edx
  8022ed:	0f 82 60 01 00 00    	jb     802453 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022f7:	75 65                	jne    80235e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022fd:	75 14                	jne    802313 <insert_sorted_allocList+0x62>
  8022ff:	83 ec 04             	sub    $0x4,%esp
  802302:	68 44 45 80 00       	push   $0x804544
  802307:	6a 6b                	push   $0x6b
  802309:	68 67 45 80 00       	push   $0x804567
  80230e:	e8 9c e2 ff ff       	call   8005af <_panic>
  802313:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	89 10                	mov    %edx,(%eax)
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	74 0d                	je     802334 <insert_sorted_allocList+0x83>
  802327:	a1 40 50 80 00       	mov    0x805040,%eax
  80232c:	8b 55 08             	mov    0x8(%ebp),%edx
  80232f:	89 50 04             	mov    %edx,0x4(%eax)
  802332:	eb 08                	jmp    80233c <insert_sorted_allocList+0x8b>
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 44 50 80 00       	mov    %eax,0x805044
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	a3 40 50 80 00       	mov    %eax,0x805040
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802353:	40                   	inc    %eax
  802354:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802359:	e9 dc 01 00 00       	jmp    80253a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	8b 50 08             	mov    0x8(%eax),%edx
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	8b 40 08             	mov    0x8(%eax),%eax
  80236a:	39 c2                	cmp    %eax,%edx
  80236c:	77 6c                	ja     8023da <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80236e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802372:	74 06                	je     80237a <insert_sorted_allocList+0xc9>
  802374:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802378:	75 14                	jne    80238e <insert_sorted_allocList+0xdd>
  80237a:	83 ec 04             	sub    $0x4,%esp
  80237d:	68 80 45 80 00       	push   $0x804580
  802382:	6a 6f                	push   $0x6f
  802384:	68 67 45 80 00       	push   $0x804567
  802389:	e8 21 e2 ff ff       	call   8005af <_panic>
  80238e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802391:	8b 50 04             	mov    0x4(%eax),%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	89 50 04             	mov    %edx,0x4(%eax)
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a0:	89 10                	mov    %edx,(%eax)
  8023a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a5:	8b 40 04             	mov    0x4(%eax),%eax
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	74 0d                	je     8023b9 <insert_sorted_allocList+0x108>
  8023ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023af:	8b 40 04             	mov    0x4(%eax),%eax
  8023b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b5:	89 10                	mov    %edx,(%eax)
  8023b7:	eb 08                	jmp    8023c1 <insert_sorted_allocList+0x110>
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	a3 40 50 80 00       	mov    %eax,0x805040
  8023c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c7:	89 50 04             	mov    %edx,0x4(%eax)
  8023ca:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023cf:	40                   	inc    %eax
  8023d0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023d5:	e9 60 01 00 00       	jmp    80253a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8b 50 08             	mov    0x8(%eax),%edx
  8023e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e3:	8b 40 08             	mov    0x8(%eax),%eax
  8023e6:	39 c2                	cmp    %eax,%edx
  8023e8:	0f 82 4c 01 00 00    	jb     80253a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f2:	75 14                	jne    802408 <insert_sorted_allocList+0x157>
  8023f4:	83 ec 04             	sub    $0x4,%esp
  8023f7:	68 b8 45 80 00       	push   $0x8045b8
  8023fc:	6a 73                	push   $0x73
  8023fe:	68 67 45 80 00       	push   $0x804567
  802403:	e8 a7 e1 ff ff       	call   8005af <_panic>
  802408:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	89 50 04             	mov    %edx,0x4(%eax)
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	8b 40 04             	mov    0x4(%eax),%eax
  80241a:	85 c0                	test   %eax,%eax
  80241c:	74 0c                	je     80242a <insert_sorted_allocList+0x179>
  80241e:	a1 44 50 80 00       	mov    0x805044,%eax
  802423:	8b 55 08             	mov    0x8(%ebp),%edx
  802426:	89 10                	mov    %edx,(%eax)
  802428:	eb 08                	jmp    802432 <insert_sorted_allocList+0x181>
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	a3 40 50 80 00       	mov    %eax,0x805040
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	a3 44 50 80 00       	mov    %eax,0x805044
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802443:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802448:	40                   	inc    %eax
  802449:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80244e:	e9 e7 00 00 00       	jmp    80253a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802456:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802459:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802460:	a1 40 50 80 00       	mov    0x805040,%eax
  802465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802468:	e9 9d 00 00 00       	jmp    80250a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	8b 50 08             	mov    0x8(%eax),%edx
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 40 08             	mov    0x8(%eax),%eax
  802481:	39 c2                	cmp    %eax,%edx
  802483:	76 7d                	jbe    802502 <insert_sorted_allocList+0x251>
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	8b 50 08             	mov    0x8(%eax),%edx
  80248b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80248e:	8b 40 08             	mov    0x8(%eax),%eax
  802491:	39 c2                	cmp    %eax,%edx
  802493:	73 6d                	jae    802502 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802499:	74 06                	je     8024a1 <insert_sorted_allocList+0x1f0>
  80249b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80249f:	75 14                	jne    8024b5 <insert_sorted_allocList+0x204>
  8024a1:	83 ec 04             	sub    $0x4,%esp
  8024a4:	68 dc 45 80 00       	push   $0x8045dc
  8024a9:	6a 7f                	push   $0x7f
  8024ab:	68 67 45 80 00       	push   $0x804567
  8024b0:	e8 fa e0 ff ff       	call   8005af <_panic>
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 10                	mov    (%eax),%edx
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	89 10                	mov    %edx,(%eax)
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 0b                	je     8024d3 <insert_sorted_allocList+0x222>
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d0:	89 50 04             	mov    %edx,0x4(%eax)
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d9:	89 10                	mov    %edx,(%eax)
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e1:	89 50 04             	mov    %edx,0x4(%eax)
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	75 08                	jne    8024f5 <insert_sorted_allocList+0x244>
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	a3 44 50 80 00       	mov    %eax,0x805044
  8024f5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024fa:	40                   	inc    %eax
  8024fb:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802500:	eb 39                	jmp    80253b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802502:	a1 48 50 80 00       	mov    0x805048,%eax
  802507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250e:	74 07                	je     802517 <insert_sorted_allocList+0x266>
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 00                	mov    (%eax),%eax
  802515:	eb 05                	jmp    80251c <insert_sorted_allocList+0x26b>
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
  80251c:	a3 48 50 80 00       	mov    %eax,0x805048
  802521:	a1 48 50 80 00       	mov    0x805048,%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	0f 85 3f ff ff ff    	jne    80246d <insert_sorted_allocList+0x1bc>
  80252e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802532:	0f 85 35 ff ff ff    	jne    80246d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802538:	eb 01                	jmp    80253b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80253a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80253b:	90                   	nop
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
  802541:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802544:	a1 38 51 80 00       	mov    0x805138,%eax
  802549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254c:	e9 85 01 00 00       	jmp    8026d6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 0c             	mov    0xc(%eax),%eax
  802557:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255a:	0f 82 6e 01 00 00    	jb     8026ce <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 40 0c             	mov    0xc(%eax),%eax
  802566:	3b 45 08             	cmp    0x8(%ebp),%eax
  802569:	0f 85 8a 00 00 00    	jne    8025f9 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80256f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802573:	75 17                	jne    80258c <alloc_block_FF+0x4e>
  802575:	83 ec 04             	sub    $0x4,%esp
  802578:	68 10 46 80 00       	push   $0x804610
  80257d:	68 93 00 00 00       	push   $0x93
  802582:	68 67 45 80 00       	push   $0x804567
  802587:	e8 23 e0 ff ff       	call   8005af <_panic>
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 00                	mov    (%eax),%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	74 10                	je     8025a5 <alloc_block_FF+0x67>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259d:	8b 52 04             	mov    0x4(%edx),%edx
  8025a0:	89 50 04             	mov    %edx,0x4(%eax)
  8025a3:	eb 0b                	jmp    8025b0 <alloc_block_FF+0x72>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 40 04             	mov    0x4(%eax),%eax
  8025ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 40 04             	mov    0x4(%eax),%eax
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 0f                	je     8025c9 <alloc_block_FF+0x8b>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 40 04             	mov    0x4(%eax),%eax
  8025c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c3:	8b 12                	mov    (%edx),%edx
  8025c5:	89 10                	mov    %edx,(%eax)
  8025c7:	eb 0a                	jmp    8025d3 <alloc_block_FF+0x95>
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 00                	mov    (%eax),%eax
  8025ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e6:	a1 44 51 80 00       	mov    0x805144,%eax
  8025eb:	48                   	dec    %eax
  8025ec:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	e9 10 01 00 00       	jmp    802709 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802602:	0f 86 c6 00 00 00    	jbe    8026ce <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802608:	a1 48 51 80 00       	mov    0x805148,%eax
  80260d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 50 08             	mov    0x8(%eax),%edx
  802616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802619:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80261c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261f:	8b 55 08             	mov    0x8(%ebp),%edx
  802622:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802625:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802629:	75 17                	jne    802642 <alloc_block_FF+0x104>
  80262b:	83 ec 04             	sub    $0x4,%esp
  80262e:	68 10 46 80 00       	push   $0x804610
  802633:	68 9b 00 00 00       	push   $0x9b
  802638:	68 67 45 80 00       	push   $0x804567
  80263d:	e8 6d df ff ff       	call   8005af <_panic>
  802642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	85 c0                	test   %eax,%eax
  802649:	74 10                	je     80265b <alloc_block_FF+0x11d>
  80264b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802653:	8b 52 04             	mov    0x4(%edx),%edx
  802656:	89 50 04             	mov    %edx,0x4(%eax)
  802659:	eb 0b                	jmp    802666 <alloc_block_FF+0x128>
  80265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802669:	8b 40 04             	mov    0x4(%eax),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	74 0f                	je     80267f <alloc_block_FF+0x141>
  802670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802673:	8b 40 04             	mov    0x4(%eax),%eax
  802676:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802679:	8b 12                	mov    (%edx),%edx
  80267b:	89 10                	mov    %edx,(%eax)
  80267d:	eb 0a                	jmp    802689 <alloc_block_FF+0x14b>
  80267f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	a3 48 51 80 00       	mov    %eax,0x805148
  802689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802695:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269c:	a1 54 51 80 00       	mov    0x805154,%eax
  8026a1:	48                   	dec    %eax
  8026a2:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 50 08             	mov    0x8(%eax),%edx
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	01 c2                	add    %eax,%edx
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026be:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c1:	89 c2                	mov    %eax,%edx
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8026c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cc:	eb 3b                	jmp    802709 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026ce:	a1 40 51 80 00       	mov    0x805140,%eax
  8026d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026da:	74 07                	je     8026e3 <alloc_block_FF+0x1a5>
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	eb 05                	jmp    8026e8 <alloc_block_FF+0x1aa>
  8026e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e8:	a3 40 51 80 00       	mov    %eax,0x805140
  8026ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	0f 85 57 fe ff ff    	jne    802551 <alloc_block_FF+0x13>
  8026fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fe:	0f 85 4d fe ff ff    	jne    802551 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
  80270e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802711:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802718:	a1 38 51 80 00       	mov    0x805138,%eax
  80271d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802720:	e9 df 00 00 00       	jmp    802804 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 40 0c             	mov    0xc(%eax),%eax
  80272b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272e:	0f 82 c8 00 00 00    	jb     8027fc <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 0c             	mov    0xc(%eax),%eax
  80273a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273d:	0f 85 8a 00 00 00    	jne    8027cd <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802747:	75 17                	jne    802760 <alloc_block_BF+0x55>
  802749:	83 ec 04             	sub    $0x4,%esp
  80274c:	68 10 46 80 00       	push   $0x804610
  802751:	68 b7 00 00 00       	push   $0xb7
  802756:	68 67 45 80 00       	push   $0x804567
  80275b:	e8 4f de ff ff       	call   8005af <_panic>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	74 10                	je     802779 <alloc_block_BF+0x6e>
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802771:	8b 52 04             	mov    0x4(%edx),%edx
  802774:	89 50 04             	mov    %edx,0x4(%eax)
  802777:	eb 0b                	jmp    802784 <alloc_block_BF+0x79>
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 0f                	je     80279d <alloc_block_BF+0x92>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 40 04             	mov    0x4(%eax),%eax
  802794:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802797:	8b 12                	mov    (%edx),%edx
  802799:	89 10                	mov    %edx,(%eax)
  80279b:	eb 0a                	jmp    8027a7 <alloc_block_BF+0x9c>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	a3 38 51 80 00       	mov    %eax,0x805138
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ba:	a1 44 51 80 00       	mov    0x805144,%eax
  8027bf:	48                   	dec    %eax
  8027c0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	e9 4d 01 00 00       	jmp    80291a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d6:	76 24                	jbe    8027fc <alloc_block_BF+0xf1>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027e1:	73 19                	jae    8027fc <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8027e3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 08             	mov    0x8(%eax),%eax
  8027f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802801:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802808:	74 07                	je     802811 <alloc_block_BF+0x106>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	eb 05                	jmp    802816 <alloc_block_BF+0x10b>
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
  802816:	a3 40 51 80 00       	mov    %eax,0x805140
  80281b:	a1 40 51 80 00       	mov    0x805140,%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	0f 85 fd fe ff ff    	jne    802725 <alloc_block_BF+0x1a>
  802828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282c:	0f 85 f3 fe ff ff    	jne    802725 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802832:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802836:	0f 84 d9 00 00 00    	je     802915 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80283c:	a1 48 51 80 00       	mov    0x805148,%eax
  802841:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802847:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80284a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80284d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802850:	8b 55 08             	mov    0x8(%ebp),%edx
  802853:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802856:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80285a:	75 17                	jne    802873 <alloc_block_BF+0x168>
  80285c:	83 ec 04             	sub    $0x4,%esp
  80285f:	68 10 46 80 00       	push   $0x804610
  802864:	68 c7 00 00 00       	push   $0xc7
  802869:	68 67 45 80 00       	push   $0x804567
  80286e:	e8 3c dd ff ff       	call   8005af <_panic>
  802873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802876:	8b 00                	mov    (%eax),%eax
  802878:	85 c0                	test   %eax,%eax
  80287a:	74 10                	je     80288c <alloc_block_BF+0x181>
  80287c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802884:	8b 52 04             	mov    0x4(%edx),%edx
  802887:	89 50 04             	mov    %edx,0x4(%eax)
  80288a:	eb 0b                	jmp    802897 <alloc_block_BF+0x18c>
  80288c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289a:	8b 40 04             	mov    0x4(%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	74 0f                	je     8028b0 <alloc_block_BF+0x1a5>
  8028a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a4:	8b 40 04             	mov    0x4(%eax),%eax
  8028a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028aa:	8b 12                	mov    (%edx),%edx
  8028ac:	89 10                	mov    %edx,(%eax)
  8028ae:	eb 0a                	jmp    8028ba <alloc_block_BF+0x1af>
  8028b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b3:	8b 00                	mov    (%eax),%eax
  8028b5:	a3 48 51 80 00       	mov    %eax,0x805148
  8028ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8028d2:	48                   	dec    %eax
  8028d3:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028d8:	83 ec 08             	sub    $0x8,%esp
  8028db:	ff 75 ec             	pushl  -0x14(%ebp)
  8028de:	68 38 51 80 00       	push   $0x805138
  8028e3:	e8 71 f9 ff ff       	call   802259 <find_block>
  8028e8:	83 c4 10             	add    $0x10,%esp
  8028eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f1:	8b 50 08             	mov    0x8(%eax),%edx
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	01 c2                	add    %eax,%edx
  8028f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028fc:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802902:	8b 40 0c             	mov    0xc(%eax),%eax
  802905:	2b 45 08             	sub    0x8(%ebp),%eax
  802908:	89 c2                	mov    %eax,%edx
  80290a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802913:	eb 05                	jmp    80291a <alloc_block_BF+0x20f>
	}
	return NULL;
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
  80291f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802922:	a1 28 50 80 00       	mov    0x805028,%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	0f 85 de 01 00 00    	jne    802b0d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80292f:	a1 38 51 80 00       	mov    0x805138,%eax
  802934:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802937:	e9 9e 01 00 00       	jmp    802ada <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 0c             	mov    0xc(%eax),%eax
  802942:	3b 45 08             	cmp    0x8(%ebp),%eax
  802945:	0f 82 87 01 00 00    	jb     802ad2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 40 0c             	mov    0xc(%eax),%eax
  802951:	3b 45 08             	cmp    0x8(%ebp),%eax
  802954:	0f 85 95 00 00 00    	jne    8029ef <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80295a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295e:	75 17                	jne    802977 <alloc_block_NF+0x5b>
  802960:	83 ec 04             	sub    $0x4,%esp
  802963:	68 10 46 80 00       	push   $0x804610
  802968:	68 e0 00 00 00       	push   $0xe0
  80296d:	68 67 45 80 00       	push   $0x804567
  802972:	e8 38 dc ff ff       	call   8005af <_panic>
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 10                	je     802990 <alloc_block_NF+0x74>
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802988:	8b 52 04             	mov    0x4(%edx),%edx
  80298b:	89 50 04             	mov    %edx,0x4(%eax)
  80298e:	eb 0b                	jmp    80299b <alloc_block_NF+0x7f>
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 04             	mov    0x4(%eax),%eax
  802996:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 40 04             	mov    0x4(%eax),%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	74 0f                	je     8029b4 <alloc_block_NF+0x98>
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 40 04             	mov    0x4(%eax),%eax
  8029ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ae:	8b 12                	mov    (%edx),%edx
  8029b0:	89 10                	mov    %edx,(%eax)
  8029b2:	eb 0a                	jmp    8029be <alloc_block_NF+0xa2>
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8029d6:	48                   	dec    %eax
  8029d7:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 40 08             	mov    0x8(%eax),%eax
  8029e2:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	e9 f8 04 00 00       	jmp    802ee7 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f8:	0f 86 d4 00 00 00    	jbe    802ad2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029fe:	a1 48 51 80 00       	mov    0x805148,%eax
  802a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 50 08             	mov    0x8(%eax),%edx
  802a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	8b 55 08             	mov    0x8(%ebp),%edx
  802a18:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a1f:	75 17                	jne    802a38 <alloc_block_NF+0x11c>
  802a21:	83 ec 04             	sub    $0x4,%esp
  802a24:	68 10 46 80 00       	push   $0x804610
  802a29:	68 e9 00 00 00       	push   $0xe9
  802a2e:	68 67 45 80 00       	push   $0x804567
  802a33:	e8 77 db ff ff       	call   8005af <_panic>
  802a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 10                	je     802a51 <alloc_block_NF+0x135>
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	8b 00                	mov    (%eax),%eax
  802a46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a49:	8b 52 04             	mov    0x4(%edx),%edx
  802a4c:	89 50 04             	mov    %edx,0x4(%eax)
  802a4f:	eb 0b                	jmp    802a5c <alloc_block_NF+0x140>
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	8b 40 04             	mov    0x4(%eax),%eax
  802a57:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 40 04             	mov    0x4(%eax),%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	74 0f                	je     802a75 <alloc_block_NF+0x159>
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a6f:	8b 12                	mov    (%edx),%edx
  802a71:	89 10                	mov    %edx,(%eax)
  802a73:	eb 0a                	jmp    802a7f <alloc_block_NF+0x163>
  802a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a78:	8b 00                	mov    (%eax),%eax
  802a7a:	a3 48 51 80 00       	mov    %eax,0x805148
  802a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a92:	a1 54 51 80 00       	mov    0x805154,%eax
  802a97:	48                   	dec    %eax
  802a98:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa0:	8b 40 08             	mov    0x8(%eax),%eax
  802aa3:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 50 08             	mov    0x8(%eax),%edx
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	01 c2                	add    %eax,%edx
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 40 0c             	mov    0xc(%eax),%eax
  802abf:	2b 45 08             	sub    0x8(%ebp),%eax
  802ac2:	89 c2                	mov    %eax,%edx
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acd:	e9 15 04 00 00       	jmp    802ee7 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ad2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ada:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ade:	74 07                	je     802ae7 <alloc_block_NF+0x1cb>
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	eb 05                	jmp    802aec <alloc_block_NF+0x1d0>
  802ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aec:	a3 40 51 80 00       	mov    %eax,0x805140
  802af1:	a1 40 51 80 00       	mov    0x805140,%eax
  802af6:	85 c0                	test   %eax,%eax
  802af8:	0f 85 3e fe ff ff    	jne    80293c <alloc_block_NF+0x20>
  802afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b02:	0f 85 34 fe ff ff    	jne    80293c <alloc_block_NF+0x20>
  802b08:	e9 d5 03 00 00       	jmp    802ee2 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b15:	e9 b1 01 00 00       	jmp    802ccb <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 50 08             	mov    0x8(%eax),%edx
  802b20:	a1 28 50 80 00       	mov    0x805028,%eax
  802b25:	39 c2                	cmp    %eax,%edx
  802b27:	0f 82 96 01 00 00    	jb     802cc3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 40 0c             	mov    0xc(%eax),%eax
  802b33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b36:	0f 82 87 01 00 00    	jb     802cc3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b42:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b45:	0f 85 95 00 00 00    	jne    802be0 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4f:	75 17                	jne    802b68 <alloc_block_NF+0x24c>
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	68 10 46 80 00       	push   $0x804610
  802b59:	68 fc 00 00 00       	push   $0xfc
  802b5e:	68 67 45 80 00       	push   $0x804567
  802b63:	e8 47 da ff ff       	call   8005af <_panic>
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	85 c0                	test   %eax,%eax
  802b6f:	74 10                	je     802b81 <alloc_block_NF+0x265>
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b79:	8b 52 04             	mov    0x4(%edx),%edx
  802b7c:	89 50 04             	mov    %edx,0x4(%eax)
  802b7f:	eb 0b                	jmp    802b8c <alloc_block_NF+0x270>
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 04             	mov    0x4(%eax),%eax
  802b87:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 04             	mov    0x4(%eax),%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	74 0f                	je     802ba5 <alloc_block_NF+0x289>
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 40 04             	mov    0x4(%eax),%eax
  802b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9f:	8b 12                	mov    (%edx),%edx
  802ba1:	89 10                	mov    %edx,(%eax)
  802ba3:	eb 0a                	jmp    802baf <alloc_block_NF+0x293>
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	a3 38 51 80 00       	mov    %eax,0x805138
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc2:	a1 44 51 80 00       	mov    0x805144,%eax
  802bc7:	48                   	dec    %eax
  802bc8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 40 08             	mov    0x8(%eax),%eax
  802bd3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	e9 07 03 00 00       	jmp    802ee7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 40 0c             	mov    0xc(%eax),%eax
  802be6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be9:	0f 86 d4 00 00 00    	jbe    802cc3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bef:	a1 48 51 80 00       	mov    0x805148,%eax
  802bf4:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 50 08             	mov    0x8(%eax),%edx
  802bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c00:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c06:	8b 55 08             	mov    0x8(%ebp),%edx
  802c09:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c10:	75 17                	jne    802c29 <alloc_block_NF+0x30d>
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	68 10 46 80 00       	push   $0x804610
  802c1a:	68 04 01 00 00       	push   $0x104
  802c1f:	68 67 45 80 00       	push   $0x804567
  802c24:	e8 86 d9 ff ff       	call   8005af <_panic>
  802c29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 10                	je     802c42 <alloc_block_NF+0x326>
  802c32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c3a:	8b 52 04             	mov    0x4(%edx),%edx
  802c3d:	89 50 04             	mov    %edx,0x4(%eax)
  802c40:	eb 0b                	jmp    802c4d <alloc_block_NF+0x331>
  802c42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c45:	8b 40 04             	mov    0x4(%eax),%eax
  802c48:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	74 0f                	je     802c66 <alloc_block_NF+0x34a>
  802c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c60:	8b 12                	mov    (%edx),%edx
  802c62:	89 10                	mov    %edx,(%eax)
  802c64:	eb 0a                	jmp    802c70 <alloc_block_NF+0x354>
  802c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	a3 48 51 80 00       	mov    %eax,0x805148
  802c70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c83:	a1 54 51 80 00       	mov    0x805154,%eax
  802c88:	48                   	dec    %eax
  802c89:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c91:	8b 40 08             	mov    0x8(%eax),%eax
  802c94:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 50 08             	mov    0x8(%eax),%edx
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	01 c2                	add    %eax,%edx
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb0:	2b 45 08             	sub    0x8(%ebp),%eax
  802cb3:	89 c2                	mov    %eax,%edx
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbe:	e9 24 02 00 00       	jmp    802ee7 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cc3:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ccb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccf:	74 07                	je     802cd8 <alloc_block_NF+0x3bc>
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	eb 05                	jmp    802cdd <alloc_block_NF+0x3c1>
  802cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdd:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	0f 85 2b fe ff ff    	jne    802b1a <alloc_block_NF+0x1fe>
  802cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf3:	0f 85 21 fe ff ff    	jne    802b1a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cf9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d01:	e9 ae 01 00 00       	jmp    802eb4 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 50 08             	mov    0x8(%eax),%edx
  802d0c:	a1 28 50 80 00       	mov    0x805028,%eax
  802d11:	39 c2                	cmp    %eax,%edx
  802d13:	0f 83 93 01 00 00    	jae    802eac <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d22:	0f 82 84 01 00 00    	jb     802eac <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d31:	0f 85 95 00 00 00    	jne    802dcc <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3b:	75 17                	jne    802d54 <alloc_block_NF+0x438>
  802d3d:	83 ec 04             	sub    $0x4,%esp
  802d40:	68 10 46 80 00       	push   $0x804610
  802d45:	68 14 01 00 00       	push   $0x114
  802d4a:	68 67 45 80 00       	push   $0x804567
  802d4f:	e8 5b d8 ff ff       	call   8005af <_panic>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	74 10                	je     802d6d <alloc_block_NF+0x451>
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d65:	8b 52 04             	mov    0x4(%edx),%edx
  802d68:	89 50 04             	mov    %edx,0x4(%eax)
  802d6b:	eb 0b                	jmp    802d78 <alloc_block_NF+0x45c>
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 04             	mov    0x4(%eax),%eax
  802d73:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 0f                	je     802d91 <alloc_block_NF+0x475>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 40 04             	mov    0x4(%eax),%eax
  802d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8b:	8b 12                	mov    (%edx),%edx
  802d8d:	89 10                	mov    %edx,(%eax)
  802d8f:	eb 0a                	jmp    802d9b <alloc_block_NF+0x47f>
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	a3 38 51 80 00       	mov    %eax,0x805138
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dae:	a1 44 51 80 00       	mov    0x805144,%eax
  802db3:	48                   	dec    %eax
  802db4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 40 08             	mov    0x8(%eax),%eax
  802dbf:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	e9 1b 01 00 00       	jmp    802ee7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd5:	0f 86 d1 00 00 00    	jbe    802eac <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ddb:	a1 48 51 80 00       	mov    0x805148,%eax
  802de0:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 50 08             	mov    0x8(%eax),%edx
  802de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dec:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df2:	8b 55 08             	mov    0x8(%ebp),%edx
  802df5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802df8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dfc:	75 17                	jne    802e15 <alloc_block_NF+0x4f9>
  802dfe:	83 ec 04             	sub    $0x4,%esp
  802e01:	68 10 46 80 00       	push   $0x804610
  802e06:	68 1c 01 00 00       	push   $0x11c
  802e0b:	68 67 45 80 00       	push   $0x804567
  802e10:	e8 9a d7 ff ff       	call   8005af <_panic>
  802e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e18:	8b 00                	mov    (%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 10                	je     802e2e <alloc_block_NF+0x512>
  802e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e26:	8b 52 04             	mov    0x4(%edx),%edx
  802e29:	89 50 04             	mov    %edx,0x4(%eax)
  802e2c:	eb 0b                	jmp    802e39 <alloc_block_NF+0x51d>
  802e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e31:	8b 40 04             	mov    0x4(%eax),%eax
  802e34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 0f                	je     802e52 <alloc_block_NF+0x536>
  802e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e4c:	8b 12                	mov    (%edx),%edx
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	eb 0a                	jmp    802e5c <alloc_block_NF+0x540>
  802e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	a3 48 51 80 00       	mov    %eax,0x805148
  802e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6f:	a1 54 51 80 00       	mov    0x805154,%eax
  802e74:	48                   	dec    %eax
  802e75:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7d:	8b 40 08             	mov    0x8(%eax),%eax
  802e80:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 50 08             	mov    0x8(%eax),%edx
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	01 c2                	add    %eax,%edx
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e9f:	89 c2                	mov    %eax,%edx
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaa:	eb 3b                	jmp    802ee7 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802eac:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb8:	74 07                	je     802ec1 <alloc_block_NF+0x5a5>
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	eb 05                	jmp    802ec6 <alloc_block_NF+0x5aa>
  802ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec6:	a3 40 51 80 00       	mov    %eax,0x805140
  802ecb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed0:	85 c0                	test   %eax,%eax
  802ed2:	0f 85 2e fe ff ff    	jne    802d06 <alloc_block_NF+0x3ea>
  802ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edc:	0f 85 24 fe ff ff    	jne    802d06 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ee2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee7:	c9                   	leave  
  802ee8:	c3                   	ret    

00802ee9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ee9:	55                   	push   %ebp
  802eea:	89 e5                	mov    %esp,%ebp
  802eec:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802eef:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ef7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802efc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802eff:	a1 38 51 80 00       	mov    0x805138,%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	74 14                	je     802f1c <insert_sorted_with_merge_freeList+0x33>
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	8b 50 08             	mov    0x8(%eax),%edx
  802f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f11:	8b 40 08             	mov    0x8(%eax),%eax
  802f14:	39 c2                	cmp    %eax,%edx
  802f16:	0f 87 9b 01 00 00    	ja     8030b7 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f20:	75 17                	jne    802f39 <insert_sorted_with_merge_freeList+0x50>
  802f22:	83 ec 04             	sub    $0x4,%esp
  802f25:	68 44 45 80 00       	push   $0x804544
  802f2a:	68 38 01 00 00       	push   $0x138
  802f2f:	68 67 45 80 00       	push   $0x804567
  802f34:	e8 76 d6 ff ff       	call   8005af <_panic>
  802f39:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	89 10                	mov    %edx,(%eax)
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 00                	mov    (%eax),%eax
  802f49:	85 c0                	test   %eax,%eax
  802f4b:	74 0d                	je     802f5a <insert_sorted_with_merge_freeList+0x71>
  802f4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f52:	8b 55 08             	mov    0x8(%ebp),%edx
  802f55:	89 50 04             	mov    %edx,0x4(%eax)
  802f58:	eb 08                	jmp    802f62 <insert_sorted_with_merge_freeList+0x79>
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	a3 38 51 80 00       	mov    %eax,0x805138
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f74:	a1 44 51 80 00       	mov    0x805144,%eax
  802f79:	40                   	inc    %eax
  802f7a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f83:	0f 84 a8 06 00 00    	je     803631 <insert_sorted_with_merge_freeList+0x748>
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 50 08             	mov    0x8(%eax),%edx
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 40 0c             	mov    0xc(%eax),%eax
  802f95:	01 c2                	add    %eax,%edx
  802f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9a:	8b 40 08             	mov    0x8(%eax),%eax
  802f9d:	39 c2                	cmp    %eax,%edx
  802f9f:	0f 85 8c 06 00 00    	jne    803631 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	8b 50 0c             	mov    0xc(%eax),%edx
  802fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fae:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb1:	01 c2                	add    %eax,%edx
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802fb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fbd:	75 17                	jne    802fd6 <insert_sorted_with_merge_freeList+0xed>
  802fbf:	83 ec 04             	sub    $0x4,%esp
  802fc2:	68 10 46 80 00       	push   $0x804610
  802fc7:	68 3c 01 00 00       	push   $0x13c
  802fcc:	68 67 45 80 00       	push   $0x804567
  802fd1:	e8 d9 d5 ff ff       	call   8005af <_panic>
  802fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	74 10                	je     802fef <insert_sorted_with_merge_freeList+0x106>
  802fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe7:	8b 52 04             	mov    0x4(%edx),%edx
  802fea:	89 50 04             	mov    %edx,0x4(%eax)
  802fed:	eb 0b                	jmp    802ffa <insert_sorted_with_merge_freeList+0x111>
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	74 0f                	je     803013 <insert_sorted_with_merge_freeList+0x12a>
  803004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803007:	8b 40 04             	mov    0x4(%eax),%eax
  80300a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300d:	8b 12                	mov    (%edx),%edx
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	eb 0a                	jmp    80301d <insert_sorted_with_merge_freeList+0x134>
  803013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	a3 38 51 80 00       	mov    %eax,0x805138
  80301d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803020:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803030:	a1 44 51 80 00       	mov    0x805144,%eax
  803035:	48                   	dec    %eax
  803036:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803048:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80304f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803053:	75 17                	jne    80306c <insert_sorted_with_merge_freeList+0x183>
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 44 45 80 00       	push   $0x804544
  80305d:	68 3f 01 00 00       	push   $0x13f
  803062:	68 67 45 80 00       	push   $0x804567
  803067:	e8 43 d5 ff ff       	call   8005af <_panic>
  80306c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803075:	89 10                	mov    %edx,(%eax)
  803077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	74 0d                	je     80308d <insert_sorted_with_merge_freeList+0x1a4>
  803080:	a1 48 51 80 00       	mov    0x805148,%eax
  803085:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803088:	89 50 04             	mov    %edx,0x4(%eax)
  80308b:	eb 08                	jmp    803095 <insert_sorted_with_merge_freeList+0x1ac>
  80308d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803090:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803098:	a3 48 51 80 00       	mov    %eax,0x805148
  80309d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ac:	40                   	inc    %eax
  8030ad:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030b2:	e9 7a 05 00 00       	jmp    803631 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	8b 50 08             	mov    0x8(%eax),%edx
  8030bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c0:	8b 40 08             	mov    0x8(%eax),%eax
  8030c3:	39 c2                	cmp    %eax,%edx
  8030c5:	0f 82 14 01 00 00    	jb     8031df <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8030cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ce:	8b 50 08             	mov    0x8(%eax),%edx
  8030d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d7:	01 c2                	add    %eax,%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 40 08             	mov    0x8(%eax),%eax
  8030df:	39 c2                	cmp    %eax,%edx
  8030e1:	0f 85 90 00 00 00    	jne    803177 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ea:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f3:	01 c2                	add    %eax,%edx
  8030f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f8:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80310f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803113:	75 17                	jne    80312c <insert_sorted_with_merge_freeList+0x243>
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	68 44 45 80 00       	push   $0x804544
  80311d:	68 49 01 00 00       	push   $0x149
  803122:	68 67 45 80 00       	push   $0x804567
  803127:	e8 83 d4 ff ff       	call   8005af <_panic>
  80312c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	89 10                	mov    %edx,(%eax)
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	8b 00                	mov    (%eax),%eax
  80313c:	85 c0                	test   %eax,%eax
  80313e:	74 0d                	je     80314d <insert_sorted_with_merge_freeList+0x264>
  803140:	a1 48 51 80 00       	mov    0x805148,%eax
  803145:	8b 55 08             	mov    0x8(%ebp),%edx
  803148:	89 50 04             	mov    %edx,0x4(%eax)
  80314b:	eb 08                	jmp    803155 <insert_sorted_with_merge_freeList+0x26c>
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	a3 48 51 80 00       	mov    %eax,0x805148
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803167:	a1 54 51 80 00       	mov    0x805154,%eax
  80316c:	40                   	inc    %eax
  80316d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803172:	e9 bb 04 00 00       	jmp    803632 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803177:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317b:	75 17                	jne    803194 <insert_sorted_with_merge_freeList+0x2ab>
  80317d:	83 ec 04             	sub    $0x4,%esp
  803180:	68 b8 45 80 00       	push   $0x8045b8
  803185:	68 4c 01 00 00       	push   $0x14c
  80318a:	68 67 45 80 00       	push   $0x804567
  80318f:	e8 1b d4 ff ff       	call   8005af <_panic>
  803194:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	89 50 04             	mov    %edx,0x4(%eax)
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	8b 40 04             	mov    0x4(%eax),%eax
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	74 0c                	je     8031b6 <insert_sorted_with_merge_freeList+0x2cd>
  8031aa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031af:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b2:	89 10                	mov    %edx,(%eax)
  8031b4:	eb 08                	jmp    8031be <insert_sorted_with_merge_freeList+0x2d5>
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d4:	40                   	inc    %eax
  8031d5:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031da:	e9 53 04 00 00       	jmp    803632 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031df:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e7:	e9 15 04 00 00       	jmp    803601 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	8b 50 08             	mov    0x8(%eax),%edx
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 40 08             	mov    0x8(%eax),%eax
  803200:	39 c2                	cmp    %eax,%edx
  803202:	0f 86 f1 03 00 00    	jbe    8035f9 <insert_sorted_with_merge_freeList+0x710>
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	8b 50 08             	mov    0x8(%eax),%edx
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	8b 40 08             	mov    0x8(%eax),%eax
  803214:	39 c2                	cmp    %eax,%edx
  803216:	0f 83 dd 03 00 00    	jae    8035f9 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	8b 50 08             	mov    0x8(%eax),%edx
  803222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803225:	8b 40 0c             	mov    0xc(%eax),%eax
  803228:	01 c2                	add    %eax,%edx
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	8b 40 08             	mov    0x8(%eax),%eax
  803230:	39 c2                	cmp    %eax,%edx
  803232:	0f 85 b9 01 00 00    	jne    8033f1 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	8b 50 08             	mov    0x8(%eax),%edx
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	8b 40 0c             	mov    0xc(%eax),%eax
  803244:	01 c2                	add    %eax,%edx
  803246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803249:	8b 40 08             	mov    0x8(%eax),%eax
  80324c:	39 c2                	cmp    %eax,%edx
  80324e:	0f 85 0d 01 00 00    	jne    803361 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803257:	8b 50 0c             	mov    0xc(%eax),%edx
  80325a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325d:	8b 40 0c             	mov    0xc(%eax),%eax
  803260:	01 c2                	add    %eax,%edx
  803262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803265:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803268:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80326c:	75 17                	jne    803285 <insert_sorted_with_merge_freeList+0x39c>
  80326e:	83 ec 04             	sub    $0x4,%esp
  803271:	68 10 46 80 00       	push   $0x804610
  803276:	68 5c 01 00 00       	push   $0x15c
  80327b:	68 67 45 80 00       	push   $0x804567
  803280:	e8 2a d3 ff ff       	call   8005af <_panic>
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	8b 00                	mov    (%eax),%eax
  80328a:	85 c0                	test   %eax,%eax
  80328c:	74 10                	je     80329e <insert_sorted_with_merge_freeList+0x3b5>
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803296:	8b 52 04             	mov    0x4(%edx),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	eb 0b                	jmp    8032a9 <insert_sorted_with_merge_freeList+0x3c0>
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	8b 40 04             	mov    0x4(%eax),%eax
  8032a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	74 0f                	je     8032c2 <insert_sorted_with_merge_freeList+0x3d9>
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	8b 40 04             	mov    0x4(%eax),%eax
  8032b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032bc:	8b 12                	mov    (%edx),%edx
  8032be:	89 10                	mov    %edx,(%eax)
  8032c0:	eb 0a                	jmp    8032cc <insert_sorted_with_merge_freeList+0x3e3>
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	8b 00                	mov    (%eax),%eax
  8032c7:	a3 38 51 80 00       	mov    %eax,0x805138
  8032cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032df:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e4:	48                   	dec    %eax
  8032e5:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803302:	75 17                	jne    80331b <insert_sorted_with_merge_freeList+0x432>
  803304:	83 ec 04             	sub    $0x4,%esp
  803307:	68 44 45 80 00       	push   $0x804544
  80330c:	68 5f 01 00 00       	push   $0x15f
  803311:	68 67 45 80 00       	push   $0x804567
  803316:	e8 94 d2 ff ff       	call   8005af <_panic>
  80331b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803324:	89 10                	mov    %edx,(%eax)
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	74 0d                	je     80333c <insert_sorted_with_merge_freeList+0x453>
  80332f:	a1 48 51 80 00       	mov    0x805148,%eax
  803334:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803337:	89 50 04             	mov    %edx,0x4(%eax)
  80333a:	eb 08                	jmp    803344 <insert_sorted_with_merge_freeList+0x45b>
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803347:	a3 48 51 80 00       	mov    %eax,0x805148
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803356:	a1 54 51 80 00       	mov    0x805154,%eax
  80335b:	40                   	inc    %eax
  80335c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803364:	8b 50 0c             	mov    0xc(%eax),%edx
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	8b 40 0c             	mov    0xc(%eax),%eax
  80336d:	01 c2                	add    %eax,%edx
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803389:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338d:	75 17                	jne    8033a6 <insert_sorted_with_merge_freeList+0x4bd>
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	68 44 45 80 00       	push   $0x804544
  803397:	68 64 01 00 00       	push   $0x164
  80339c:	68 67 45 80 00       	push   $0x804567
  8033a1:	e8 09 d2 ff ff       	call   8005af <_panic>
  8033a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	89 10                	mov    %edx,(%eax)
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	8b 00                	mov    (%eax),%eax
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	74 0d                	je     8033c7 <insert_sorted_with_merge_freeList+0x4de>
  8033ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8033bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c2:	89 50 04             	mov    %edx,0x4(%eax)
  8033c5:	eb 08                	jmp    8033cf <insert_sorted_with_merge_freeList+0x4e6>
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8033e6:	40                   	inc    %eax
  8033e7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033ec:	e9 41 02 00 00       	jmp    803632 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	8b 50 08             	mov    0x8(%eax),%edx
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fd:	01 c2                	add    %eax,%edx
  8033ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803402:	8b 40 08             	mov    0x8(%eax),%eax
  803405:	39 c2                	cmp    %eax,%edx
  803407:	0f 85 7c 01 00 00    	jne    803589 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80340d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803411:	74 06                	je     803419 <insert_sorted_with_merge_freeList+0x530>
  803413:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803417:	75 17                	jne    803430 <insert_sorted_with_merge_freeList+0x547>
  803419:	83 ec 04             	sub    $0x4,%esp
  80341c:	68 80 45 80 00       	push   $0x804580
  803421:	68 69 01 00 00       	push   $0x169
  803426:	68 67 45 80 00       	push   $0x804567
  80342b:	e8 7f d1 ff ff       	call   8005af <_panic>
  803430:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803433:	8b 50 04             	mov    0x4(%eax),%edx
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	89 50 04             	mov    %edx,0x4(%eax)
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803442:	89 10                	mov    %edx,(%eax)
  803444:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803447:	8b 40 04             	mov    0x4(%eax),%eax
  80344a:	85 c0                	test   %eax,%eax
  80344c:	74 0d                	je     80345b <insert_sorted_with_merge_freeList+0x572>
  80344e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803451:	8b 40 04             	mov    0x4(%eax),%eax
  803454:	8b 55 08             	mov    0x8(%ebp),%edx
  803457:	89 10                	mov    %edx,(%eax)
  803459:	eb 08                	jmp    803463 <insert_sorted_with_merge_freeList+0x57a>
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	a3 38 51 80 00       	mov    %eax,0x805138
  803463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803466:	8b 55 08             	mov    0x8(%ebp),%edx
  803469:	89 50 04             	mov    %edx,0x4(%eax)
  80346c:	a1 44 51 80 00       	mov    0x805144,%eax
  803471:	40                   	inc    %eax
  803472:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	8b 50 0c             	mov    0xc(%eax),%edx
  80347d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803480:	8b 40 0c             	mov    0xc(%eax),%eax
  803483:	01 c2                	add    %eax,%edx
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80348b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80348f:	75 17                	jne    8034a8 <insert_sorted_with_merge_freeList+0x5bf>
  803491:	83 ec 04             	sub    $0x4,%esp
  803494:	68 10 46 80 00       	push   $0x804610
  803499:	68 6b 01 00 00       	push   $0x16b
  80349e:	68 67 45 80 00       	push   $0x804567
  8034a3:	e8 07 d1 ff ff       	call   8005af <_panic>
  8034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	85 c0                	test   %eax,%eax
  8034af:	74 10                	je     8034c1 <insert_sorted_with_merge_freeList+0x5d8>
  8034b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034b9:	8b 52 04             	mov    0x4(%edx),%edx
  8034bc:	89 50 04             	mov    %edx,0x4(%eax)
  8034bf:	eb 0b                	jmp    8034cc <insert_sorted_with_merge_freeList+0x5e3>
  8034c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c4:	8b 40 04             	mov    0x4(%eax),%eax
  8034c7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cf:	8b 40 04             	mov    0x4(%eax),%eax
  8034d2:	85 c0                	test   %eax,%eax
  8034d4:	74 0f                	je     8034e5 <insert_sorted_with_merge_freeList+0x5fc>
  8034d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d9:	8b 40 04             	mov    0x4(%eax),%eax
  8034dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034df:	8b 12                	mov    (%edx),%edx
  8034e1:	89 10                	mov    %edx,(%eax)
  8034e3:	eb 0a                	jmp    8034ef <insert_sorted_with_merge_freeList+0x606>
  8034e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	a3 38 51 80 00       	mov    %eax,0x805138
  8034ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803502:	a1 44 51 80 00       	mov    0x805144,%eax
  803507:	48                   	dec    %eax
  803508:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80350d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803510:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803517:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803521:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803525:	75 17                	jne    80353e <insert_sorted_with_merge_freeList+0x655>
  803527:	83 ec 04             	sub    $0x4,%esp
  80352a:	68 44 45 80 00       	push   $0x804544
  80352f:	68 6e 01 00 00       	push   $0x16e
  803534:	68 67 45 80 00       	push   $0x804567
  803539:	e8 71 d0 ff ff       	call   8005af <_panic>
  80353e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803544:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803547:	89 10                	mov    %edx,(%eax)
  803549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354c:	8b 00                	mov    (%eax),%eax
  80354e:	85 c0                	test   %eax,%eax
  803550:	74 0d                	je     80355f <insert_sorted_with_merge_freeList+0x676>
  803552:	a1 48 51 80 00       	mov    0x805148,%eax
  803557:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80355a:	89 50 04             	mov    %edx,0x4(%eax)
  80355d:	eb 08                	jmp    803567 <insert_sorted_with_merge_freeList+0x67e>
  80355f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803562:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803567:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356a:	a3 48 51 80 00       	mov    %eax,0x805148
  80356f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803579:	a1 54 51 80 00       	mov    0x805154,%eax
  80357e:	40                   	inc    %eax
  80357f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803584:	e9 a9 00 00 00       	jmp    803632 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80358d:	74 06                	je     803595 <insert_sorted_with_merge_freeList+0x6ac>
  80358f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803593:	75 17                	jne    8035ac <insert_sorted_with_merge_freeList+0x6c3>
  803595:	83 ec 04             	sub    $0x4,%esp
  803598:	68 dc 45 80 00       	push   $0x8045dc
  80359d:	68 73 01 00 00       	push   $0x173
  8035a2:	68 67 45 80 00       	push   $0x804567
  8035a7:	e8 03 d0 ff ff       	call   8005af <_panic>
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	8b 10                	mov    (%eax),%edx
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	89 10                	mov    %edx,(%eax)
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	8b 00                	mov    (%eax),%eax
  8035bb:	85 c0                	test   %eax,%eax
  8035bd:	74 0b                	je     8035ca <insert_sorted_with_merge_freeList+0x6e1>
  8035bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c2:	8b 00                	mov    (%eax),%eax
  8035c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d0:	89 10                	mov    %edx,(%eax)
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d8:	89 50 04             	mov    %edx,0x4(%eax)
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	8b 00                	mov    (%eax),%eax
  8035e0:	85 c0                	test   %eax,%eax
  8035e2:	75 08                	jne    8035ec <insert_sorted_with_merge_freeList+0x703>
  8035e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8035f1:	40                   	inc    %eax
  8035f2:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035f7:	eb 39                	jmp    803632 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8035fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803605:	74 07                	je     80360e <insert_sorted_with_merge_freeList+0x725>
  803607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	eb 05                	jmp    803613 <insert_sorted_with_merge_freeList+0x72a>
  80360e:	b8 00 00 00 00       	mov    $0x0,%eax
  803613:	a3 40 51 80 00       	mov    %eax,0x805140
  803618:	a1 40 51 80 00       	mov    0x805140,%eax
  80361d:	85 c0                	test   %eax,%eax
  80361f:	0f 85 c7 fb ff ff    	jne    8031ec <insert_sorted_with_merge_freeList+0x303>
  803625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803629:	0f 85 bd fb ff ff    	jne    8031ec <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80362f:	eb 01                	jmp    803632 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803631:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803632:	90                   	nop
  803633:	c9                   	leave  
  803634:	c3                   	ret    

00803635 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803635:	55                   	push   %ebp
  803636:	89 e5                	mov    %esp,%ebp
  803638:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80363b:	8b 55 08             	mov    0x8(%ebp),%edx
  80363e:	89 d0                	mov    %edx,%eax
  803640:	c1 e0 02             	shl    $0x2,%eax
  803643:	01 d0                	add    %edx,%eax
  803645:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80364c:	01 d0                	add    %edx,%eax
  80364e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803655:	01 d0                	add    %edx,%eax
  803657:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80365e:	01 d0                	add    %edx,%eax
  803660:	c1 e0 04             	shl    $0x4,%eax
  803663:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803666:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80366d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803670:	83 ec 0c             	sub    $0xc,%esp
  803673:	50                   	push   %eax
  803674:	e8 26 e7 ff ff       	call   801d9f <sys_get_virtual_time>
  803679:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80367c:	eb 41                	jmp    8036bf <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80367e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803681:	83 ec 0c             	sub    $0xc,%esp
  803684:	50                   	push   %eax
  803685:	e8 15 e7 ff ff       	call   801d9f <sys_get_virtual_time>
  80368a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80368d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803693:	29 c2                	sub    %eax,%edx
  803695:	89 d0                	mov    %edx,%eax
  803697:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80369a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80369d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a0:	89 d1                	mov    %edx,%ecx
  8036a2:	29 c1                	sub    %eax,%ecx
  8036a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8036a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036aa:	39 c2                	cmp    %eax,%edx
  8036ac:	0f 97 c0             	seta   %al
  8036af:	0f b6 c0             	movzbl %al,%eax
  8036b2:	29 c1                	sub    %eax,%ecx
  8036b4:	89 c8                	mov    %ecx,%eax
  8036b6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8036b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8036bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8036bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8036c5:	72 b7                	jb     80367e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8036c7:	90                   	nop
  8036c8:	c9                   	leave  
  8036c9:	c3                   	ret    

008036ca <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8036ca:	55                   	push   %ebp
  8036cb:	89 e5                	mov    %esp,%ebp
  8036cd:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8036d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8036d7:	eb 03                	jmp    8036dc <busy_wait+0x12>
  8036d9:	ff 45 fc             	incl   -0x4(%ebp)
  8036dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8036df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036e2:	72 f5                	jb     8036d9 <busy_wait+0xf>
	return i;
  8036e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8036e7:	c9                   	leave  
  8036e8:	c3                   	ret    
  8036e9:	66 90                	xchg   %ax,%ax
  8036eb:	90                   	nop

008036ec <__udivdi3>:
  8036ec:	55                   	push   %ebp
  8036ed:	57                   	push   %edi
  8036ee:	56                   	push   %esi
  8036ef:	53                   	push   %ebx
  8036f0:	83 ec 1c             	sub    $0x1c,%esp
  8036f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803703:	89 ca                	mov    %ecx,%edx
  803705:	89 f8                	mov    %edi,%eax
  803707:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80370b:	85 f6                	test   %esi,%esi
  80370d:	75 2d                	jne    80373c <__udivdi3+0x50>
  80370f:	39 cf                	cmp    %ecx,%edi
  803711:	77 65                	ja     803778 <__udivdi3+0x8c>
  803713:	89 fd                	mov    %edi,%ebp
  803715:	85 ff                	test   %edi,%edi
  803717:	75 0b                	jne    803724 <__udivdi3+0x38>
  803719:	b8 01 00 00 00       	mov    $0x1,%eax
  80371e:	31 d2                	xor    %edx,%edx
  803720:	f7 f7                	div    %edi
  803722:	89 c5                	mov    %eax,%ebp
  803724:	31 d2                	xor    %edx,%edx
  803726:	89 c8                	mov    %ecx,%eax
  803728:	f7 f5                	div    %ebp
  80372a:	89 c1                	mov    %eax,%ecx
  80372c:	89 d8                	mov    %ebx,%eax
  80372e:	f7 f5                	div    %ebp
  803730:	89 cf                	mov    %ecx,%edi
  803732:	89 fa                	mov    %edi,%edx
  803734:	83 c4 1c             	add    $0x1c,%esp
  803737:	5b                   	pop    %ebx
  803738:	5e                   	pop    %esi
  803739:	5f                   	pop    %edi
  80373a:	5d                   	pop    %ebp
  80373b:	c3                   	ret    
  80373c:	39 ce                	cmp    %ecx,%esi
  80373e:	77 28                	ja     803768 <__udivdi3+0x7c>
  803740:	0f bd fe             	bsr    %esi,%edi
  803743:	83 f7 1f             	xor    $0x1f,%edi
  803746:	75 40                	jne    803788 <__udivdi3+0x9c>
  803748:	39 ce                	cmp    %ecx,%esi
  80374a:	72 0a                	jb     803756 <__udivdi3+0x6a>
  80374c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803750:	0f 87 9e 00 00 00    	ja     8037f4 <__udivdi3+0x108>
  803756:	b8 01 00 00 00       	mov    $0x1,%eax
  80375b:	89 fa                	mov    %edi,%edx
  80375d:	83 c4 1c             	add    $0x1c,%esp
  803760:	5b                   	pop    %ebx
  803761:	5e                   	pop    %esi
  803762:	5f                   	pop    %edi
  803763:	5d                   	pop    %ebp
  803764:	c3                   	ret    
  803765:	8d 76 00             	lea    0x0(%esi),%esi
  803768:	31 ff                	xor    %edi,%edi
  80376a:	31 c0                	xor    %eax,%eax
  80376c:	89 fa                	mov    %edi,%edx
  80376e:	83 c4 1c             	add    $0x1c,%esp
  803771:	5b                   	pop    %ebx
  803772:	5e                   	pop    %esi
  803773:	5f                   	pop    %edi
  803774:	5d                   	pop    %ebp
  803775:	c3                   	ret    
  803776:	66 90                	xchg   %ax,%ax
  803778:	89 d8                	mov    %ebx,%eax
  80377a:	f7 f7                	div    %edi
  80377c:	31 ff                	xor    %edi,%edi
  80377e:	89 fa                	mov    %edi,%edx
  803780:	83 c4 1c             	add    $0x1c,%esp
  803783:	5b                   	pop    %ebx
  803784:	5e                   	pop    %esi
  803785:	5f                   	pop    %edi
  803786:	5d                   	pop    %ebp
  803787:	c3                   	ret    
  803788:	bd 20 00 00 00       	mov    $0x20,%ebp
  80378d:	89 eb                	mov    %ebp,%ebx
  80378f:	29 fb                	sub    %edi,%ebx
  803791:	89 f9                	mov    %edi,%ecx
  803793:	d3 e6                	shl    %cl,%esi
  803795:	89 c5                	mov    %eax,%ebp
  803797:	88 d9                	mov    %bl,%cl
  803799:	d3 ed                	shr    %cl,%ebp
  80379b:	89 e9                	mov    %ebp,%ecx
  80379d:	09 f1                	or     %esi,%ecx
  80379f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037a3:	89 f9                	mov    %edi,%ecx
  8037a5:	d3 e0                	shl    %cl,%eax
  8037a7:	89 c5                	mov    %eax,%ebp
  8037a9:	89 d6                	mov    %edx,%esi
  8037ab:	88 d9                	mov    %bl,%cl
  8037ad:	d3 ee                	shr    %cl,%esi
  8037af:	89 f9                	mov    %edi,%ecx
  8037b1:	d3 e2                	shl    %cl,%edx
  8037b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037b7:	88 d9                	mov    %bl,%cl
  8037b9:	d3 e8                	shr    %cl,%eax
  8037bb:	09 c2                	or     %eax,%edx
  8037bd:	89 d0                	mov    %edx,%eax
  8037bf:	89 f2                	mov    %esi,%edx
  8037c1:	f7 74 24 0c          	divl   0xc(%esp)
  8037c5:	89 d6                	mov    %edx,%esi
  8037c7:	89 c3                	mov    %eax,%ebx
  8037c9:	f7 e5                	mul    %ebp
  8037cb:	39 d6                	cmp    %edx,%esi
  8037cd:	72 19                	jb     8037e8 <__udivdi3+0xfc>
  8037cf:	74 0b                	je     8037dc <__udivdi3+0xf0>
  8037d1:	89 d8                	mov    %ebx,%eax
  8037d3:	31 ff                	xor    %edi,%edi
  8037d5:	e9 58 ff ff ff       	jmp    803732 <__udivdi3+0x46>
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037e0:	89 f9                	mov    %edi,%ecx
  8037e2:	d3 e2                	shl    %cl,%edx
  8037e4:	39 c2                	cmp    %eax,%edx
  8037e6:	73 e9                	jae    8037d1 <__udivdi3+0xe5>
  8037e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037eb:	31 ff                	xor    %edi,%edi
  8037ed:	e9 40 ff ff ff       	jmp    803732 <__udivdi3+0x46>
  8037f2:	66 90                	xchg   %ax,%ax
  8037f4:	31 c0                	xor    %eax,%eax
  8037f6:	e9 37 ff ff ff       	jmp    803732 <__udivdi3+0x46>
  8037fb:	90                   	nop

008037fc <__umoddi3>:
  8037fc:	55                   	push   %ebp
  8037fd:	57                   	push   %edi
  8037fe:	56                   	push   %esi
  8037ff:	53                   	push   %ebx
  803800:	83 ec 1c             	sub    $0x1c,%esp
  803803:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803807:	8b 74 24 34          	mov    0x34(%esp),%esi
  80380b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80380f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803813:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803817:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80381b:	89 f3                	mov    %esi,%ebx
  80381d:	89 fa                	mov    %edi,%edx
  80381f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803823:	89 34 24             	mov    %esi,(%esp)
  803826:	85 c0                	test   %eax,%eax
  803828:	75 1a                	jne    803844 <__umoddi3+0x48>
  80382a:	39 f7                	cmp    %esi,%edi
  80382c:	0f 86 a2 00 00 00    	jbe    8038d4 <__umoddi3+0xd8>
  803832:	89 c8                	mov    %ecx,%eax
  803834:	89 f2                	mov    %esi,%edx
  803836:	f7 f7                	div    %edi
  803838:	89 d0                	mov    %edx,%eax
  80383a:	31 d2                	xor    %edx,%edx
  80383c:	83 c4 1c             	add    $0x1c,%esp
  80383f:	5b                   	pop    %ebx
  803840:	5e                   	pop    %esi
  803841:	5f                   	pop    %edi
  803842:	5d                   	pop    %ebp
  803843:	c3                   	ret    
  803844:	39 f0                	cmp    %esi,%eax
  803846:	0f 87 ac 00 00 00    	ja     8038f8 <__umoddi3+0xfc>
  80384c:	0f bd e8             	bsr    %eax,%ebp
  80384f:	83 f5 1f             	xor    $0x1f,%ebp
  803852:	0f 84 ac 00 00 00    	je     803904 <__umoddi3+0x108>
  803858:	bf 20 00 00 00       	mov    $0x20,%edi
  80385d:	29 ef                	sub    %ebp,%edi
  80385f:	89 fe                	mov    %edi,%esi
  803861:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803865:	89 e9                	mov    %ebp,%ecx
  803867:	d3 e0                	shl    %cl,%eax
  803869:	89 d7                	mov    %edx,%edi
  80386b:	89 f1                	mov    %esi,%ecx
  80386d:	d3 ef                	shr    %cl,%edi
  80386f:	09 c7                	or     %eax,%edi
  803871:	89 e9                	mov    %ebp,%ecx
  803873:	d3 e2                	shl    %cl,%edx
  803875:	89 14 24             	mov    %edx,(%esp)
  803878:	89 d8                	mov    %ebx,%eax
  80387a:	d3 e0                	shl    %cl,%eax
  80387c:	89 c2                	mov    %eax,%edx
  80387e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803882:	d3 e0                	shl    %cl,%eax
  803884:	89 44 24 04          	mov    %eax,0x4(%esp)
  803888:	8b 44 24 08          	mov    0x8(%esp),%eax
  80388c:	89 f1                	mov    %esi,%ecx
  80388e:	d3 e8                	shr    %cl,%eax
  803890:	09 d0                	or     %edx,%eax
  803892:	d3 eb                	shr    %cl,%ebx
  803894:	89 da                	mov    %ebx,%edx
  803896:	f7 f7                	div    %edi
  803898:	89 d3                	mov    %edx,%ebx
  80389a:	f7 24 24             	mull   (%esp)
  80389d:	89 c6                	mov    %eax,%esi
  80389f:	89 d1                	mov    %edx,%ecx
  8038a1:	39 d3                	cmp    %edx,%ebx
  8038a3:	0f 82 87 00 00 00    	jb     803930 <__umoddi3+0x134>
  8038a9:	0f 84 91 00 00 00    	je     803940 <__umoddi3+0x144>
  8038af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038b3:	29 f2                	sub    %esi,%edx
  8038b5:	19 cb                	sbb    %ecx,%ebx
  8038b7:	89 d8                	mov    %ebx,%eax
  8038b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038bd:	d3 e0                	shl    %cl,%eax
  8038bf:	89 e9                	mov    %ebp,%ecx
  8038c1:	d3 ea                	shr    %cl,%edx
  8038c3:	09 d0                	or     %edx,%eax
  8038c5:	89 e9                	mov    %ebp,%ecx
  8038c7:	d3 eb                	shr    %cl,%ebx
  8038c9:	89 da                	mov    %ebx,%edx
  8038cb:	83 c4 1c             	add    $0x1c,%esp
  8038ce:	5b                   	pop    %ebx
  8038cf:	5e                   	pop    %esi
  8038d0:	5f                   	pop    %edi
  8038d1:	5d                   	pop    %ebp
  8038d2:	c3                   	ret    
  8038d3:	90                   	nop
  8038d4:	89 fd                	mov    %edi,%ebp
  8038d6:	85 ff                	test   %edi,%edi
  8038d8:	75 0b                	jne    8038e5 <__umoddi3+0xe9>
  8038da:	b8 01 00 00 00       	mov    $0x1,%eax
  8038df:	31 d2                	xor    %edx,%edx
  8038e1:	f7 f7                	div    %edi
  8038e3:	89 c5                	mov    %eax,%ebp
  8038e5:	89 f0                	mov    %esi,%eax
  8038e7:	31 d2                	xor    %edx,%edx
  8038e9:	f7 f5                	div    %ebp
  8038eb:	89 c8                	mov    %ecx,%eax
  8038ed:	f7 f5                	div    %ebp
  8038ef:	89 d0                	mov    %edx,%eax
  8038f1:	e9 44 ff ff ff       	jmp    80383a <__umoddi3+0x3e>
  8038f6:	66 90                	xchg   %ax,%ax
  8038f8:	89 c8                	mov    %ecx,%eax
  8038fa:	89 f2                	mov    %esi,%edx
  8038fc:	83 c4 1c             	add    $0x1c,%esp
  8038ff:	5b                   	pop    %ebx
  803900:	5e                   	pop    %esi
  803901:	5f                   	pop    %edi
  803902:	5d                   	pop    %ebp
  803903:	c3                   	ret    
  803904:	3b 04 24             	cmp    (%esp),%eax
  803907:	72 06                	jb     80390f <__umoddi3+0x113>
  803909:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80390d:	77 0f                	ja     80391e <__umoddi3+0x122>
  80390f:	89 f2                	mov    %esi,%edx
  803911:	29 f9                	sub    %edi,%ecx
  803913:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803917:	89 14 24             	mov    %edx,(%esp)
  80391a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80391e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803922:	8b 14 24             	mov    (%esp),%edx
  803925:	83 c4 1c             	add    $0x1c,%esp
  803928:	5b                   	pop    %ebx
  803929:	5e                   	pop    %esi
  80392a:	5f                   	pop    %edi
  80392b:	5d                   	pop    %ebp
  80392c:	c3                   	ret    
  80392d:	8d 76 00             	lea    0x0(%esi),%esi
  803930:	2b 04 24             	sub    (%esp),%eax
  803933:	19 fa                	sbb    %edi,%edx
  803935:	89 d1                	mov    %edx,%ecx
  803937:	89 c6                	mov    %eax,%esi
  803939:	e9 71 ff ff ff       	jmp    8038af <__umoddi3+0xb3>
  80393e:	66 90                	xchg   %ax,%ax
  803940:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803944:	72 ea                	jb     803930 <__umoddi3+0x134>
  803946:	89 d9                	mov    %ebx,%ecx
  803948:	e9 62 ff ff ff       	jmp    8038af <__umoddi3+0xb3>
