
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 8a 02 00 00       	call   8002c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 50 80 00       	mov    0x805020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 50 80 00       	mov    0x805020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 40 37 80 00       	push   $0x803740
  800091:	6a 12                	push   $0x12
  800093:	68 5c 37 80 00       	push   $0x80375c
  800098:	e8 5f 03 00 00       	call   8003fc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 91 15 00 00       	call   801638 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	68 74 37 80 00       	push   $0x803774
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 a8 37 80 00       	push   $0x8037a8
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 04 38 80 00       	push   $0x803804
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 38 38 80 00       	push   $0x803838
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 80 38 80 00       	push   $0x803880
  8000f9:	e8 cf 15 00 00       	call   8016cd <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 04 18 00 00       	call   80190d <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 80 38 80 00       	push   $0x803880
  80011b:	e8 ad 15 00 00       	call   8016cd <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 84 38 80 00       	push   $0x803884
  800134:	6a 24                	push   $0x24
  800136:	68 5c 37 80 00       	push   $0x80375c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 c8 17 00 00       	call   80190d <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 d8 38 80 00       	push   $0x8038d8
  800156:	6a 25                	push   $0x25
  800158:	68 5c 37 80 00       	push   $0x80375c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 34 39 80 00       	push   $0x803934
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 96 17 00 00       	call   80190d <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 8c 39 80 00       	push   $0x80398c
  80018e:	e8 3a 15 00 00       	call   8016cd <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 90 39 80 00       	push   $0x803990
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 5c 37 80 00       	push   $0x80375c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 55 17 00 00       	call   80190d <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 04 3a 80 00       	push   $0x803a04
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 5c 37 80 00       	push   $0x80375c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 78 3a 80 00       	push   $0x803a78
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 7c 19 00 00       	call   801b66 <sys_getMaxShares>
  8001ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f4:	eb 45                	jmp    80023b <_main+0x203>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  8001fc:	50                   	push   %eax
  8001fd:	ff 75 ec             	pushl  -0x14(%ebp)
  800200:	e8 d3 0f 00 00       	call   8011d8 <ltostr>
  800205:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	6a 01                	push   $0x1
  80020d:	6a 01                	push   $0x1
  80020f:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  800212:	50                   	push   %eax
  800213:	e8 b5 14 00 00       	call   8016cd <smalloc>
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80021e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800222:	75 14                	jne    800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 ec 3a 80 00       	push   $0x803aec
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 5c 37 80 00       	push   $0x80375c
  800233:	e8 c4 01 00 00       	call   8003fc <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  800238:	ff 45 ec             	incl   -0x14(%ebp)
  80023b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800244:	39 c2                	cmp    %eax,%edx
  800246:	77 ae                	ja     8001f6 <_main+0x1be>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	6a 01                	push   $0x1
  80024d:	6a 01                	push   $0x1
  80024f:	68 1c 3b 80 00       	push   $0x803b1c
  800254:	e8 74 14 00 00       	call   8016cd <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 02 19 00 00       	call   801b66 <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 28 3b 80 00       	push   $0x803b28
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 5c 37 80 00       	push   $0x80375c
  800284:	e8 73 01 00 00       	call   8003fc <_panic>
		//else
		if ((maxShares_after == 2*maxShares) && (z == NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS, krealloc should be invoked to double the size of shares array!!");
  800289:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800291:	75 1a                	jne    8002ad <_main+0x275>
  800293:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800297:	75 14                	jne    8002ad <_main+0x275>
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 a4 3b 80 00       	push   $0x803ba4
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 5c 37 80 00       	push   $0x80375c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 30 3c 80 00       	push   $0x803c30
  8002b5:	e8 f6 03 00 00       	call   8006b0 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp

	return;
  8002bd:	90                   	nop
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002c6:	e8 22 19 00 00       	call   801bed <sys_getenvindex>
  8002cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002d1:	89 d0                	mov    %edx,%eax
  8002d3:	c1 e0 03             	shl    $0x3,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	01 c0                	add    %eax,%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	c1 e0 04             	shl    $0x4,%eax
  8002e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ed:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002fd:	84 c0                	test   %al,%al
  8002ff:	74 0f                	je     800310 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800301:	a1 20 50 80 00       	mov    0x805020,%eax
  800306:	05 5c 05 00 00       	add    $0x55c,%eax
  80030b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x60>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800331:	e8 c4 16 00 00       	call   8019fa <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 a8 3c 80 00       	push   $0x803ca8
  80033e:	e8 6d 03 00 00       	call   8006b0 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800346:	a1 20 50 80 00       	mov    0x805020,%eax
  80034b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800351:	a1 20 50 80 00       	mov    0x805020,%eax
  800356:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	68 d0 3c 80 00       	push   $0x803cd0
  800366:	e8 45 03 00 00       	call   8006b0 <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036e:	a1 20 50 80 00       	mov    0x805020,%eax
  800373:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800379:	a1 20 50 80 00       	mov    0x805020,%eax
  80037e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800384:	a1 20 50 80 00       	mov    0x805020,%eax
  800389:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80038f:	51                   	push   %ecx
  800390:	52                   	push   %edx
  800391:	50                   	push   %eax
  800392:	68 f8 3c 80 00       	push   $0x803cf8
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 50 3d 80 00       	push   $0x803d50
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 a8 3c 80 00       	push   $0x803ca8
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 44 16 00 00       	call   801a14 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003d0:	e8 19 00 00 00       	call   8003ee <exit>
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	6a 00                	push   $0x0
  8003e3:	e8 d1 17 00 00       	call   801bb9 <sys_destroy_env>
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	90                   	nop
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <exit>:

void
exit(void)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f4:	e8 26 18 00 00       	call   801c1f <sys_exit_env>
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800402:	8d 45 10             	lea    0x10(%ebp),%eax
  800405:	83 c0 04             	add    $0x4,%eax
  800408:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80040b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800410:	85 c0                	test   %eax,%eax
  800412:	74 16                	je     80042a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800414:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 64 3d 80 00       	push   $0x803d64
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 69 3d 80 00       	push   $0x803d69
  80043b:	e8 70 02 00 00       	call   8006b0 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800443:	8b 45 10             	mov    0x10(%ebp),%eax
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 f4             	pushl  -0xc(%ebp)
  80044c:	50                   	push   %eax
  80044d:	e8 f3 01 00 00       	call   800645 <vcprintf>
  800452:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	6a 00                	push   $0x0
  80045a:	68 85 3d 80 00       	push   $0x803d85
  80045f:	e8 e1 01 00 00       	call   800645 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800467:	e8 82 ff ff ff       	call   8003ee <exit>

	// should not return here
	while (1) ;
  80046c:	eb fe                	jmp    80046c <_panic+0x70>

0080046e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800474:	a1 20 50 80 00       	mov    0x805020,%eax
  800479:	8b 50 74             	mov    0x74(%eax),%edx
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	39 c2                	cmp    %eax,%edx
  800481:	74 14                	je     800497 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	68 88 3d 80 00       	push   $0x803d88
  80048b:	6a 26                	push   $0x26
  80048d:	68 d4 3d 80 00       	push   $0x803dd4
  800492:	e8 65 ff ff ff       	call   8003fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80049e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a5:	e9 c2 00 00 00       	jmp    80056c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	75 08                	jne    8004c7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c2:	e9 a2 00 00 00       	jmp    800569 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d5:	eb 69                	jmp    800540 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004dc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	01 c0                	add    %eax,%eax
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	c1 e0 03             	shl    $0x3,%eax
  8004ee:	01 c8                	add    %ecx,%eax
  8004f0:	8a 40 04             	mov    0x4(%eax),%al
  8004f3:	84 c0                	test   %al,%al
  8004f5:	75 46                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800502:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800505:	89 d0                	mov    %edx,%eax
  800507:	01 c0                	add    %eax,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	c1 e0 03             	shl    $0x3,%eax
  80050e:	01 c8                	add    %ecx,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800518:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80051d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800522:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800530:	39 c2                	cmp    %eax,%edx
  800532:	75 09                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800534:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80053b:	eb 12                	jmp    80054f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053d:	ff 45 e8             	incl   -0x18(%ebp)
  800540:	a1 20 50 80 00       	mov    0x805020,%eax
  800545:	8b 50 74             	mov    0x74(%eax),%edx
  800548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	77 88                	ja     8004d7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800553:	75 14                	jne    800569 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 e0 3d 80 00       	push   $0x803de0
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 d4 3d 80 00       	push   $0x803dd4
  800564:	e8 93 fe ff ff       	call   8003fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800569:	ff 45 f0             	incl   -0x10(%ebp)
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800572:	0f 8c 32 ff ff ff    	jl     8004aa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800578:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800586:	eb 26                	jmp    8005ae <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800588:	a1 20 50 80 00       	mov    0x805020,%eax
  80058d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	01 c0                	add    %eax,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 03             	shl    $0x3,%eax
  80059f:	01 c8                	add    %ecx,%eax
  8005a1:	8a 40 04             	mov    0x4(%eax),%al
  8005a4:	3c 01                	cmp    $0x1,%al
  8005a6:	75 03                	jne    8005ab <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e0             	incl   -0x20(%ebp)
  8005ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b3:	8b 50 74             	mov    0x74(%eax),%edx
  8005b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b9:	39 c2                	cmp    %eax,%edx
  8005bb:	77 cb                	ja     800588 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c3:	74 14                	je     8005d9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 34 3e 80 00       	push   $0x803e34
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 d4 3d 80 00       	push   $0x803dd4
  8005d4:	e8 23 fe ff ff       	call   8003fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d9:	90                   	nop
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	89 0a                	mov    %ecx,(%edx)
  8005ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f2:	88 d1                	mov    %dl,%cl
  8005f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	3d ff 00 00 00       	cmp    $0xff,%eax
  800605:	75 2c                	jne    800633 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800607:	a0 24 50 80 00       	mov    0x805024,%al
  80060c:	0f b6 c0             	movzbl %al,%eax
  80060f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800612:	8b 12                	mov    (%edx),%edx
  800614:	89 d1                	mov    %edx,%ecx
  800616:	8b 55 0c             	mov    0xc(%ebp),%edx
  800619:	83 c2 08             	add    $0x8,%edx
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	50                   	push   %eax
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	e8 25 12 00 00       	call   80184c <sys_cputs>
  800627:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	8b 40 04             	mov    0x4(%eax),%eax
  800639:	8d 50 01             	lea    0x1(%eax),%edx
  80063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800655:	00 00 00 
	b.cnt = 0;
  800658:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	68 dc 05 80 00       	push   $0x8005dc
  800674:	e8 11 02 00 00       	call   80088a <vprintfmt>
  800679:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80067c:	a0 24 50 80 00       	mov    0x805024,%al
  800681:	0f b6 c0             	movzbl %al,%eax
  800684:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	50                   	push   %eax
  80068e:	52                   	push   %edx
  80068f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800695:	83 c0 08             	add    $0x8,%eax
  800698:	50                   	push   %eax
  800699:	e8 ae 11 00 00       	call   80184c <sys_cputs>
  80069e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a1:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8006a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b6:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8006bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	e8 73 ff ff ff       	call   800645 <vcprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e3:	e8 12 13 00 00       	call   8019fa <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	e8 48 ff ff ff       	call   800645 <vcprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800703:	e8 0c 13 00 00       	call   801a14 <sys_enable_interrupt>
	return cnt;
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	53                   	push   %ebx
  800711:	83 ec 14             	sub    $0x14,%esp
  800714:	8b 45 10             	mov    0x10(%ebp),%eax
  800717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800720:	8b 45 18             	mov    0x18(%ebp),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072b:	77 55                	ja     800782 <printnum+0x75>
  80072d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800730:	72 05                	jb     800737 <printnum+0x2a>
  800732:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800735:	77 4b                	ja     800782 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800737:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073d:	8b 45 18             	mov    0x18(%ebp),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	ff 75 f4             	pushl  -0xc(%ebp)
  80074a:	ff 75 f0             	pushl  -0x10(%ebp)
  80074d:	e8 7e 2d 00 00       	call   8034d0 <__udivdi3>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	ff 75 20             	pushl  0x20(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	ff 75 18             	pushl  0x18(%ebp)
  80075f:	52                   	push   %edx
  800760:	50                   	push   %eax
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	e8 a1 ff ff ff       	call   80070d <printnum>
  80076c:	83 c4 20             	add    $0x20,%esp
  80076f:	eb 1a                	jmp    80078b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	ff 75 20             	pushl  0x20(%ebp)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800782:	ff 4d 1c             	decl   0x1c(%ebp)
  800785:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800789:	7f e6                	jg     800771 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800799:	53                   	push   %ebx
  80079a:	51                   	push   %ecx
  80079b:	52                   	push   %edx
  80079c:	50                   	push   %eax
  80079d:	e8 3e 2e 00 00       	call   8035e0 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 94 40 80 00       	add    $0x804094,%eax
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f be c0             	movsbl %al,%eax
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	ff d0                	call   *%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	90                   	nop
  8007bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cb:	7e 1c                	jle    8007e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 50 08             	lea    0x8(%eax),%edx
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 10                	mov    %edx,(%eax)
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	83 e8 08             	sub    $0x8,%eax
  8007e2:	8b 50 04             	mov    0x4(%eax),%edx
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	eb 40                	jmp    800829 <getuint+0x65>
	else if (lflag)
  8007e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ed:	74 1e                	je     80080d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	89 10                	mov    %edx,(%eax)
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	eb 1c                	jmp    800829 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	8d 50 04             	lea    0x4(%eax),%edx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 10                	mov    %edx,(%eax)
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800832:	7e 1c                	jle    800850 <getint+0x25>
		return va_arg(*ap, long long);
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	8d 50 08             	lea    0x8(%eax),%edx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	89 10                	mov    %edx,(%eax)
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	83 e8 08             	sub    $0x8,%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	eb 38                	jmp    800888 <getint+0x5d>
	else if (lflag)
  800850:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800854:	74 1a                	je     800870 <getint+0x45>
		return va_arg(*ap, long);
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	8d 50 04             	lea    0x4(%eax),%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	89 10                	mov    %edx,(%eax)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	99                   	cltd   
  80086e:	eb 18                	jmp    800888 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	8d 50 04             	lea    0x4(%eax),%edx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	89 10                	mov    %edx,(%eax)
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	99                   	cltd   
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	56                   	push   %esi
  80088e:	53                   	push   %ebx
  80088f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800892:	eb 17                	jmp    8008ab <vprintfmt+0x21>
			if (ch == '\0')
  800894:	85 db                	test   %ebx,%ebx
  800896:	0f 84 af 03 00 00    	je     800c4b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	53                   	push   %ebx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f b6 d8             	movzbl %al,%ebx
  8008b9:	83 fb 25             	cmp    $0x25,%ebx
  8008bc:	75 d6                	jne    800894 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	8d 50 01             	lea    0x1(%eax),%edx
  8008e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e7:	8a 00                	mov    (%eax),%al
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ef:	83 f8 55             	cmp    $0x55,%eax
  8008f2:	0f 87 2b 03 00 00    	ja     800c23 <vprintfmt+0x399>
  8008f8:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
  8008ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800901:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800905:	eb d7                	jmp    8008de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800907:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090b:	eb d1                	jmp    8008de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800917:	89 d0                	mov    %edx,%eax
  800919:	c1 e0 02             	shl    $0x2,%eax
  80091c:	01 d0                	add    %edx,%eax
  80091e:	01 c0                	add    %eax,%eax
  800920:	01 d8                	add    %ebx,%eax
  800922:	83 e8 30             	sub    $0x30,%eax
  800925:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800928:	8b 45 10             	mov    0x10(%ebp),%eax
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800930:	83 fb 2f             	cmp    $0x2f,%ebx
  800933:	7e 3e                	jle    800973 <vprintfmt+0xe9>
  800935:	83 fb 39             	cmp    $0x39,%ebx
  800938:	7f 39                	jg     800973 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093d:	eb d5                	jmp    800914 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800953:	eb 1f                	jmp    800974 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	79 83                	jns    8008de <vprintfmt+0x54>
				width = 0;
  80095b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800967:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096e:	e9 6b ff ff ff       	jmp    8008de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800973:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800978:	0f 89 60 ff ff ff    	jns    8008de <vprintfmt+0x54>
				width = precision, precision = -1;
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800984:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098b:	e9 4e ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800990:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800993:	e9 46 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
			break;
  8009b8:	e9 89 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	83 c0 04             	add    $0x4,%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	83 e8 04             	sub    $0x4,%eax
  8009cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	79 02                	jns    8009d4 <vprintfmt+0x14a>
				err = -err;
  8009d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d4:	83 fb 64             	cmp    $0x64,%ebx
  8009d7:	7f 0b                	jg     8009e4 <vprintfmt+0x15a>
  8009d9:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 a5 40 80 00       	push   $0x8040a5
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 5e 02 00 00       	call   800c53 <printfmt>
  8009f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f8:	e9 49 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fd:	56                   	push   %esi
  8009fe:	68 ae 40 80 00       	push   $0x8040ae
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	ff 75 08             	pushl  0x8(%ebp)
  800a09:	e8 45 02 00 00       	call   800c53 <printfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
			break;
  800a11:	e9 30 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 e8 04             	sub    $0x4,%eax
  800a25:	8b 30                	mov    (%eax),%esi
  800a27:	85 f6                	test   %esi,%esi
  800a29:	75 05                	jne    800a30 <vprintfmt+0x1a6>
				p = "(null)";
  800a2b:	be b1 40 80 00       	mov    $0x8040b1,%esi
			if (width > 0 && padc != '-')
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	7e 6d                	jle    800aa3 <vprintfmt+0x219>
  800a36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3a:	74 67                	je     800aa3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	50                   	push   %eax
  800a43:	56                   	push   %esi
  800a44:	e8 0c 03 00 00       	call   800d55 <strnlen>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4f:	eb 16                	jmp    800a67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	50                   	push   %eax
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a64:	ff 4d e4             	decl   -0x1c(%ebp)
  800a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6b:	7f e4                	jg     800a51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6d:	eb 34                	jmp    800aa3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a73:	74 1c                	je     800a91 <vprintfmt+0x207>
  800a75:	83 fb 1f             	cmp    $0x1f,%ebx
  800a78:	7e 05                	jle    800a7f <vprintfmt+0x1f5>
  800a7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7d:	7e 12                	jle    800a91 <vprintfmt+0x207>
					putch('?', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 3f                	push   $0x3f
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	eb 0f                	jmp    800aa0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa0:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	8d 70 01             	lea    0x1(%eax),%esi
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	0f be d8             	movsbl %al,%ebx
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	74 24                	je     800ad5 <vprintfmt+0x24b>
  800ab1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab5:	78 b8                	js     800a6f <vprintfmt+0x1e5>
  800ab7:	ff 4d e0             	decl   -0x20(%ebp)
  800aba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abe:	79 af                	jns    800a6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac0:	eb 13                	jmp    800ad5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	6a 20                	push   $0x20
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad9:	7f e7                	jg     800ac2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adb:	e9 66 01 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	e8 3c fd ff ff       	call   80082b <getint>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afe:	85 d2                	test   %edx,%edx
  800b00:	79 23                	jns    800b25 <vprintfmt+0x29b>
				putch('-', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 2d                	push   $0x2d
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b18:	f7 d8                	neg    %eax
  800b1a:	83 d2 00             	adc    $0x0,%edx
  800b1d:	f7 da                	neg    %edx
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2c:	e9 bc 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 e8             	pushl  -0x18(%ebp)
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3a:	50                   	push   %eax
  800b3b:	e8 84 fc ff ff       	call   8007c4 <getuint>
  800b40:	83 c4 10             	add    $0x10,%esp
  800b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b50:	e9 98 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	6a 58                	push   $0x58
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 58                	push   $0x58
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 58                	push   $0x58
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			break;
  800b85:	e9 bc 00 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 30                	push   $0x30
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 78                	push   $0x78
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	83 c0 04             	add    $0x4,%eax
  800bb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bcc:	eb 1f                	jmp    800bed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 e7 fb ff ff       	call   8007c4 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf4:	83 ec 04             	sub    $0x4,%esp
  800bf7:	52                   	push   %edx
  800bf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bff:	ff 75 f0             	pushl  -0x10(%ebp)
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 00 fb ff ff       	call   80070d <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
			break;
  800c10:	eb 34                	jmp    800c46 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	53                   	push   %ebx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			break;
  800c21:	eb 23                	jmp    800c46 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 25                	push   $0x25
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c33:	ff 4d 10             	decl   0x10(%ebp)
  800c36:	eb 03                	jmp    800c3b <vprintfmt+0x3b1>
  800c38:	ff 4d 10             	decl   0x10(%ebp)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	48                   	dec    %eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	3c 25                	cmp    $0x25,%al
  800c43:	75 f3                	jne    800c38 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c45:	90                   	nop
		}
	}
  800c46:	e9 47 fc ff ff       	jmp    800892 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c59:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5c:	83 c0 04             	add    $0x4,%eax
  800c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	50                   	push   %eax
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 16 fc ff ff       	call   80088a <vprintfmt>
  800c74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c77:	90                   	nop
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8b 40 08             	mov    0x8(%eax),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8b 10                	mov    (%eax),%edx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 40 04             	mov    0x4(%eax),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	73 12                	jae    800cad <sprintputch+0x33>
		*b->buf++ = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 10                	mov    %dl,(%eax)
}
  800cad:	90                   	nop
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	01 d0                	add    %edx,%eax
  800cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd5:	74 06                	je     800cdd <vsnprintf+0x2d>
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	7f 07                	jg     800ce4 <vsnprintf+0x34>
		return -E_INVAL;
  800cdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce2:	eb 20                	jmp    800d04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce4:	ff 75 14             	pushl  0x14(%ebp)
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	68 7a 0c 80 00       	push   $0x800c7a
  800cf3:	e8 92 fb ff ff       	call   80088a <vprintfmt>
  800cf8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1b:	50                   	push   %eax
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 89 ff ff ff       	call   800cb0 <vsnprintf>
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3f:	eb 06                	jmp    800d47 <strlen+0x15>
		n++;
  800d41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d44:	ff 45 08             	incl   0x8(%ebp)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	84 c0                	test   %al,%al
  800d4e:	75 f1                	jne    800d41 <strlen+0xf>
		n++;
	return n;
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d62:	eb 09                	jmp    800d6d <strnlen+0x18>
		n++;
  800d64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	ff 4d 0c             	decl   0xc(%ebp)
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	74 09                	je     800d7c <strnlen+0x27>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	75 e8                	jne    800d64 <strnlen+0xf>
		n++;
	return n;
  800d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d8d:	90                   	nop
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 08             	mov    %edx,0x8(%ebp)
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da0:	8a 12                	mov    (%edx),%dl
  800da2:	88 10                	mov    %dl,(%eax)
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	75 e4                	jne    800d8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc2:	eb 1f                	jmp    800de3 <strncpy+0x34>
		*dst++ = *src;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8d 50 01             	lea    0x1(%eax),%edx
  800dca:	89 55 08             	mov    %edx,0x8(%ebp)
  800dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd0:	8a 12                	mov    (%edx),%dl
  800dd2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	74 03                	je     800de0 <strncpy+0x31>
			src++;
  800ddd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de0:	ff 45 fc             	incl   -0x4(%ebp)
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de9:	72 d9                	jb     800dc4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	74 30                	je     800e32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e02:	eb 16                	jmp    800e1a <strlcpy+0x2a>
			*dst++ = *src++;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1a:	ff 4d 10             	decl   0x10(%ebp)
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	74 09                	je     800e2c <strlcpy+0x3c>
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 d8                	jne    800e04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e38:	29 c2                	sub    %eax,%edx
  800e3a:	89 d0                	mov    %edx,%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e41:	eb 06                	jmp    800e49 <strcmp+0xb>
		p++, q++;
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	74 0e                	je     800e60 <strcmp+0x22>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 10                	mov    (%eax),%dl
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	38 c2                	cmp    %al,%dl
  800e5e:	74 e3                	je     800e43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 d0             	movzbl %al,%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 c0             	movzbl %al,%eax
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	89 d0                	mov    %edx,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e79:	eb 09                	jmp    800e84 <strncmp+0xe>
		n--, p++, q++;
  800e7b:	ff 4d 10             	decl   0x10(%ebp)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e88:	74 17                	je     800ea1 <strncmp+0x2b>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 0e                	je     800ea1 <strncmp+0x2b>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	38 c2                	cmp    %al,%dl
  800e9f:	74 da                	je     800e7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	75 07                	jne    800eae <strncmp+0x38>
		return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	eb 14                	jmp    800ec2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 d0             	movzbl %al,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 c0             	movzbl %al,%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed0:	eb 12                	jmp    800ee4 <strchr+0x20>
		if (*s == c)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eda:	75 05                	jne    800ee1 <strchr+0x1d>
			return (char *) s;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	eb 11                	jmp    800ef2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 e5                	jne    800ed2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 04             	sub    $0x4,%esp
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f00:	eb 0d                	jmp    800f0f <strfind+0x1b>
		if (*s == c)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0a:	74 0e                	je     800f1a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f0c:	ff 45 08             	incl   0x8(%ebp)
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	75 ea                	jne    800f02 <strfind+0xe>
  800f18:	eb 01                	jmp    800f1b <strfind+0x27>
		if (*s == c)
			break;
  800f1a:	90                   	nop
	return (char *) s;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f32:	eb 0e                	jmp    800f42 <memset+0x22>
		*p++ = c;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	8d 50 01             	lea    0x1(%eax),%edx
  800f3a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f42:	ff 4d f8             	decl   -0x8(%ebp)
  800f45:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f49:	79 e9                	jns    800f34 <memset+0x14>
		*p++ = c;

	return v;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f62:	eb 16                	jmp    800f7a <memcpy+0x2a>
		*d++ = *s++;
  800f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f76:	8a 12                	mov    (%edx),%dl
  800f78:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 dd                	jne    800f64 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa4:	73 50                	jae    800ff6 <memmove+0x6a>
  800fa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb1:	76 43                	jbe    800ff6 <memmove+0x6a>
		s += n;
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbf:	eb 10                	jmp    800fd1 <memmove+0x45>
			*--d = *--s;
  800fc1:	ff 4d f8             	decl   -0x8(%ebp)
  800fc4:	ff 4d fc             	decl   -0x4(%ebp)
  800fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fca:	8a 10                	mov    (%eax),%dl
  800fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	75 e3                	jne    800fc1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fde:	eb 23                	jmp    801003 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff2:	8a 12                	mov    (%edx),%dl
  800ff4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fff:	85 c0                	test   %eax,%eax
  801001:	75 dd                	jne    800fe0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101a:	eb 2a                	jmp    801046 <memcmp+0x3e>
		if (*s1 != *s2)
  80101c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101f:	8a 10                	mov    (%eax),%dl
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	38 c2                	cmp    %al,%dl
  801028:	74 16                	je     801040 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 d0             	movzbl %al,%edx
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 c0             	movzbl %al,%eax
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	eb 18                	jmp    801058 <memcmp+0x50>
		s1++, s2++;
  801040:	ff 45 fc             	incl   -0x4(%ebp)
  801043:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104c:	89 55 10             	mov    %edx,0x10(%ebp)
  80104f:	85 c0                	test   %eax,%eax
  801051:	75 c9                	jne    80101c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106b:	eb 15                	jmp    801082 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	39 c2                	cmp    %eax,%edx
  80107d:	74 0d                	je     80108c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80107f:	ff 45 08             	incl   0x8(%ebp)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801088:	72 e3                	jb     80106d <memfind+0x13>
  80108a:	eb 01                	jmp    80108d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108c:	90                   	nop
	return (void *) s;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a6:	eb 03                	jmp    8010ab <strtol+0x19>
		s++;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 20                	cmp    $0x20,%al
  8010b2:	74 f4                	je     8010a8 <strtol+0x16>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 09                	cmp    $0x9,%al
  8010bb:	74 eb                	je     8010a8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 2b                	cmp    $0x2b,%al
  8010c4:	75 05                	jne    8010cb <strtol+0x39>
		s++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	eb 13                	jmp    8010de <strtol+0x4c>
	else if (*s == '-')
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 2d                	cmp    $0x2d,%al
  8010d2:	75 0a                	jne    8010de <strtol+0x4c>
		s++, neg = 1;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e2:	74 06                	je     8010ea <strtol+0x58>
  8010e4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e8:	75 20                	jne    80110a <strtol+0x78>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 30                	cmp    $0x30,%al
  8010f1:	75 17                	jne    80110a <strtol+0x78>
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	40                   	inc    %eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	3c 78                	cmp    $0x78,%al
  8010fb:	75 0d                	jne    80110a <strtol+0x78>
		s += 2, base = 16;
  8010fd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801101:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801108:	eb 28                	jmp    801132 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110e:	75 15                	jne    801125 <strtol+0x93>
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 30                	cmp    $0x30,%al
  801117:	75 0c                	jne    801125 <strtol+0x93>
		s++, base = 8;
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801123:	eb 0d                	jmp    801132 <strtol+0xa0>
	else if (base == 0)
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	75 07                	jne    801132 <strtol+0xa0>
		base = 10;
  80112b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 2f                	cmp    $0x2f,%al
  801139:	7e 19                	jle    801154 <strtol+0xc2>
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 39                	cmp    $0x39,%al
  801142:	7f 10                	jg     801154 <strtol+0xc2>
			dig = *s - '0';
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	83 e8 30             	sub    $0x30,%eax
  80114f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801152:	eb 42                	jmp    801196 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 60                	cmp    $0x60,%al
  80115b:	7e 19                	jle    801176 <strtol+0xe4>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3c 7a                	cmp    $0x7a,%al
  801164:	7f 10                	jg     801176 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f be c0             	movsbl %al,%eax
  80116e:	83 e8 57             	sub    $0x57,%eax
  801171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801174:	eb 20                	jmp    801196 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 40                	cmp    $0x40,%al
  80117d:	7e 39                	jle    8011b8 <strtol+0x126>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 5a                	cmp    $0x5a,%al
  801186:	7f 30                	jg     8011b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f be c0             	movsbl %al,%eax
  801190:	83 e8 37             	sub    $0x37,%eax
  801193:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801199:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119c:	7d 19                	jge    8011b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b2:	e9 7b ff ff ff       	jmp    801132 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bc:	74 08                	je     8011c6 <strtol+0x134>
		*endptr = (char *) s;
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ca:	74 07                	je     8011d3 <strtol+0x141>
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	f7 d8                	neg    %eax
  8011d1:	eb 03                	jmp    8011d6 <strtol+0x144>
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f0:	79 13                	jns    801205 <ltostr+0x2d>
	{
		neg = 1;
  8011f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801202:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80120d:	99                   	cltd   
  80120e:	f7 f9                	idiv   %ecx
  801210:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801226:	83 c2 30             	add    $0x30,%edx
  801229:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801233:	f7 e9                	imul   %ecx
  801235:	c1 fa 02             	sar    $0x2,%edx
  801238:	89 c8                	mov    %ecx,%eax
  80123a:	c1 f8 1f             	sar    $0x1f,%eax
  80123d:	29 c2                	sub    %eax,%edx
  80123f:	89 d0                	mov    %edx,%eax
  801241:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124c:	f7 e9                	imul   %ecx
  80124e:	c1 fa 02             	sar    $0x2,%edx
  801251:	89 c8                	mov    %ecx,%eax
  801253:	c1 f8 1f             	sar    $0x1f,%eax
  801256:	29 c2                	sub    %eax,%edx
  801258:	89 d0                	mov    %edx,%eax
  80125a:	c1 e0 02             	shl    $0x2,%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	01 c0                	add    %eax,%eax
  801261:	29 c1                	sub    %eax,%ecx
  801263:	89 ca                	mov    %ecx,%edx
  801265:	85 d2                	test   %edx,%edx
  801267:	75 9c                	jne    801205 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801273:	48                   	dec    %eax
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801277:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127b:	74 3d                	je     8012ba <ltostr+0xe2>
		start = 1 ;
  80127d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801284:	eb 34                	jmp    8012ba <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c0:	7c c4                	jl     801286 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cd:	90                   	nop
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 54 fa ff ff       	call   800d32 <strlen>
  8012de:	83 c4 04             	add    $0x4,%esp
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	e8 46 fa ff ff       	call   800d32 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801300:	eb 17                	jmp    801319 <strcconcat+0x49>
		final[s] = str1[s] ;
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 c8                	add    %ecx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801316:	ff 45 fc             	incl   -0x4(%ebp)
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131f:	7c e1                	jl     801302 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132f:	eb 1f                	jmp    801350 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	01 c2                	add    %eax,%edx
  801341:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c8                	add    %ecx,%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134d:	ff 45 f8             	incl   -0x8(%ebp)
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c d9                	jl     801331 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801358:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135b:	8b 45 10             	mov    0x10(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801372:	8b 45 14             	mov    0x14(%ebp),%eax
  801375:	8b 00                	mov    (%eax),%eax
  801377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801389:	eb 0c                	jmp    801397 <strsplit+0x31>
			*string++ = 0;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8d 50 01             	lea    0x1(%eax),%edx
  801391:	89 55 08             	mov    %edx,0x8(%ebp)
  801394:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	84 c0                	test   %al,%al
  80139e:	74 18                	je     8013b8 <strsplit+0x52>
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	0f be c0             	movsbl %al,%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	e8 13 fb ff ff       	call   800ec4 <strchr>
  8013b1:	83 c4 08             	add    $0x8,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	75 d3                	jne    80138b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 5a                	je     80141b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c4:	8b 00                	mov    (%eax),%eax
  8013c6:	83 f8 0f             	cmp    $0xf,%eax
  8013c9:	75 07                	jne    8013d2 <strsplit+0x6c>
		{
			return 0;
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	eb 66                	jmp    801438 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013da:	8b 55 14             	mov    0x14(%ebp),%edx
  8013dd:	89 0a                	mov    %ecx,(%edx)
  8013df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	01 c2                	add    %eax,%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f0:	eb 03                	jmp    8013f5 <strsplit+0x8f>
			string++;
  8013f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	84 c0                	test   %al,%al
  8013fc:	74 8b                	je     801389 <strsplit+0x23>
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	0f be c0             	movsbl %al,%eax
  801406:	50                   	push   %eax
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	e8 b5 fa ff ff       	call   800ec4 <strchr>
  80140f:	83 c4 08             	add    $0x8,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	74 dc                	je     8013f2 <strsplit+0x8c>
			string++;
	}
  801416:	e9 6e ff ff ff       	jmp    801389 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801433:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801440:	a1 04 50 80 00       	mov    0x805004,%eax
  801445:	85 c0                	test   %eax,%eax
  801447:	74 1f                	je     801468 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801449:	e8 1d 00 00 00       	call   80146b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	68 10 42 80 00       	push   $0x804210
  801456:	e8 55 f2 ff ff       	call   8006b0 <cprintf>
  80145b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80145e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801465:	00 00 00 
	}
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801471:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801478:	00 00 00 
  80147b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801482:	00 00 00 
  801485:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80148c:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80148f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801496:	00 00 00 
  801499:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8014a0:	00 00 00 
  8014a3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8014aa:	00 00 00 
	uint32 arr_size = 0;
  8014ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8014b4:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8014bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014c8:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8014cd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8014d4:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8014d7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8014de:	a1 20 51 80 00       	mov    0x805120,%eax
  8014e3:	c1 e0 04             	shl    $0x4,%eax
  8014e6:	89 c2                	mov    %eax,%edx
  8014e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014eb:	01 d0                	add    %edx,%eax
  8014ed:	48                   	dec    %eax
  8014ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8014f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f9:	f7 75 ec             	divl   -0x14(%ebp)
  8014fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ff:	29 d0                	sub    %edx,%eax
  801501:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801504:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80150b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801513:	2d 00 10 00 00       	sub    $0x1000,%eax
  801518:	83 ec 04             	sub    $0x4,%esp
  80151b:	6a 06                	push   $0x6
  80151d:	ff 75 f4             	pushl  -0xc(%ebp)
  801520:	50                   	push   %eax
  801521:	e8 6a 04 00 00       	call   801990 <sys_allocate_chunk>
  801526:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801529:	a1 20 51 80 00       	mov    0x805120,%eax
  80152e:	83 ec 0c             	sub    $0xc,%esp
  801531:	50                   	push   %eax
  801532:	e8 df 0a 00 00       	call   802016 <initialize_MemBlocksList>
  801537:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  80153a:	a1 48 51 80 00       	mov    0x805148,%eax
  80153f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801545:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80154c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801556:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80155a:	75 14                	jne    801570 <initialize_dyn_block_system+0x105>
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	68 35 42 80 00       	push   $0x804235
  801564:	6a 33                	push   $0x33
  801566:	68 53 42 80 00       	push   $0x804253
  80156b:	e8 8c ee ff ff       	call   8003fc <_panic>
  801570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801573:	8b 00                	mov    (%eax),%eax
  801575:	85 c0                	test   %eax,%eax
  801577:	74 10                	je     801589 <initialize_dyn_block_system+0x11e>
  801579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157c:	8b 00                	mov    (%eax),%eax
  80157e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801581:	8b 52 04             	mov    0x4(%edx),%edx
  801584:	89 50 04             	mov    %edx,0x4(%eax)
  801587:	eb 0b                	jmp    801594 <initialize_dyn_block_system+0x129>
  801589:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158c:	8b 40 04             	mov    0x4(%eax),%eax
  80158f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801597:	8b 40 04             	mov    0x4(%eax),%eax
  80159a:	85 c0                	test   %eax,%eax
  80159c:	74 0f                	je     8015ad <initialize_dyn_block_system+0x142>
  80159e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a1:	8b 40 04             	mov    0x4(%eax),%eax
  8015a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015a7:	8b 12                	mov    (%edx),%edx
  8015a9:	89 10                	mov    %edx,(%eax)
  8015ab:	eb 0a                	jmp    8015b7 <initialize_dyn_block_system+0x14c>
  8015ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b0:	8b 00                	mov    (%eax),%eax
  8015b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8015b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8015cf:	48                   	dec    %eax
  8015d0:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8015d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015d9:	75 14                	jne    8015ef <initialize_dyn_block_system+0x184>
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 60 42 80 00       	push   $0x804260
  8015e3:	6a 34                	push   $0x34
  8015e5:	68 53 42 80 00       	push   $0x804253
  8015ea:	e8 0d ee ff ff       	call   8003fc <_panic>
  8015ef:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8015f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f8:	89 10                	mov    %edx,(%eax)
  8015fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015fd:	8b 00                	mov    (%eax),%eax
  8015ff:	85 c0                	test   %eax,%eax
  801601:	74 0d                	je     801610 <initialize_dyn_block_system+0x1a5>
  801603:	a1 38 51 80 00       	mov    0x805138,%eax
  801608:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80160b:	89 50 04             	mov    %edx,0x4(%eax)
  80160e:	eb 08                	jmp    801618 <initialize_dyn_block_system+0x1ad>
  801610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801613:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161b:	a3 38 51 80 00       	mov    %eax,0x805138
  801620:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801623:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80162a:	a1 44 51 80 00       	mov    0x805144,%eax
  80162f:	40                   	inc    %eax
  801630:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801635:	90                   	nop
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163e:	e8 f7 fd ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  801643:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801647:	75 07                	jne    801650 <malloc+0x18>
  801649:	b8 00 00 00 00       	mov    $0x0,%eax
  80164e:	eb 61                	jmp    8016b1 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801650:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801657:	8b 55 08             	mov    0x8(%ebp),%edx
  80165a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165d:	01 d0                	add    %edx,%eax
  80165f:	48                   	dec    %eax
  801660:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801666:	ba 00 00 00 00       	mov    $0x0,%edx
  80166b:	f7 75 f0             	divl   -0x10(%ebp)
  80166e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801671:	29 d0                	sub    %edx,%eax
  801673:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801676:	e8 e3 06 00 00       	call   801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80167b:	85 c0                	test   %eax,%eax
  80167d:	74 11                	je     801690 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	ff 75 e8             	pushl  -0x18(%ebp)
  801685:	e8 4e 0d 00 00       	call   8023d8 <alloc_block_FF>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801694:	74 16                	je     8016ac <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801696:	83 ec 0c             	sub    $0xc,%esp
  801699:	ff 75 f4             	pushl  -0xc(%ebp)
  80169c:	e8 aa 0a 00 00       	call   80214b <insert_sorted_allocList>
  8016a1:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  8016a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a7:	8b 40 08             	mov    0x8(%eax),%eax
  8016aa:	eb 05                	jmp    8016b1 <malloc+0x79>
	}

    return NULL;
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8016b9:	83 ec 04             	sub    $0x4,%esp
  8016bc:	68 84 42 80 00       	push   $0x804284
  8016c1:	6a 6f                	push   $0x6f
  8016c3:	68 53 42 80 00       	push   $0x804253
  8016c8:	e8 2f ed ff ff       	call   8003fc <_panic>

008016cd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	83 ec 38             	sub    $0x38,%esp
  8016d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d9:	e8 5c fd ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  8016de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016e2:	75 07                	jne    8016eb <smalloc+0x1e>
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	eb 7c                	jmp    801767 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016eb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f8:	01 d0                	add    %edx,%eax
  8016fa:	48                   	dec    %eax
  8016fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801701:	ba 00 00 00 00       	mov    $0x0,%edx
  801706:	f7 75 f0             	divl   -0x10(%ebp)
  801709:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170c:	29 d0                	sub    %edx,%eax
  80170e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801711:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801718:	e8 41 06 00 00       	call   801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80171d:	85 c0                	test   %eax,%eax
  80171f:	74 11                	je     801732 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	ff 75 e8             	pushl  -0x18(%ebp)
  801727:	e8 ac 0c 00 00       	call   8023d8 <alloc_block_FF>
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801736:	74 2a                	je     801762 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173b:	8b 40 08             	mov    0x8(%eax),%eax
  80173e:	89 c2                	mov    %eax,%edx
  801740:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801744:	52                   	push   %edx
  801745:	50                   	push   %eax
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	ff 75 08             	pushl  0x8(%ebp)
  80174c:	e8 92 03 00 00       	call   801ae3 <sys_createSharedObject>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801757:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80175b:	74 05                	je     801762 <smalloc+0x95>
			return (void*)virtual_address;
  80175d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801760:	eb 05                	jmp    801767 <smalloc+0x9a>
	}
	return NULL;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176f:	e8 c6 fc ff ff       	call   80143a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801774:	83 ec 04             	sub    $0x4,%esp
  801777:	68 a8 42 80 00       	push   $0x8042a8
  80177c:	68 b0 00 00 00       	push   $0xb0
  801781:	68 53 42 80 00       	push   $0x804253
  801786:	e8 71 ec ff ff       	call   8003fc <_panic>

0080178b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801791:	e8 a4 fc ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	68 cc 42 80 00       	push   $0x8042cc
  80179e:	68 f4 00 00 00       	push   $0xf4
  8017a3:	68 53 42 80 00       	push   $0x804253
  8017a8:	e8 4f ec ff ff       	call   8003fc <_panic>

008017ad <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	68 f4 42 80 00       	push   $0x8042f4
  8017bb:	68 08 01 00 00       	push   $0x108
  8017c0:	68 53 42 80 00       	push   $0x804253
  8017c5:	e8 32 ec ff ff       	call   8003fc <_panic>

008017ca <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	68 18 43 80 00       	push   $0x804318
  8017d8:	68 13 01 00 00       	push   $0x113
  8017dd:	68 53 42 80 00       	push   $0x804253
  8017e2:	e8 15 ec ff ff       	call   8003fc <_panic>

008017e7 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	68 18 43 80 00       	push   $0x804318
  8017f5:	68 18 01 00 00       	push   $0x118
  8017fa:	68 53 42 80 00       	push   $0x804253
  8017ff:	e8 f8 eb ff ff       	call   8003fc <_panic>

00801804 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	68 18 43 80 00       	push   $0x804318
  801812:	68 1d 01 00 00       	push   $0x11d
  801817:	68 53 42 80 00       	push   $0x804253
  80181c:	e8 db eb ff ff       	call   8003fc <_panic>

00801821 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	57                   	push   %edi
  801825:	56                   	push   %esi
  801826:	53                   	push   %ebx
  801827:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801833:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801836:	8b 7d 18             	mov    0x18(%ebp),%edi
  801839:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80183c:	cd 30                	int    $0x30
  80183e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	5b                   	pop    %ebx
  801848:	5e                   	pop    %esi
  801849:	5f                   	pop    %edi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    

0080184c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801858:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	52                   	push   %edx
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	50                   	push   %eax
  801868:	6a 00                	push   $0x0
  80186a:	e8 b2 ff ff ff       	call   801821 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	90                   	nop
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_cgetc>:

int
sys_cgetc(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 01                	push   $0x1
  801884:	e8 98 ff ff ff       	call   801821 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 05                	push   $0x5
  8018a1:	e8 7b ff ff ff       	call   801821 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b0:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	51                   	push   %ecx
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 06                	push   $0x6
  8018c6:	e8 56 ff ff ff       	call   801821 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    

008018d5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 07                	push   $0x7
  8018e8:	e8 34 ff ff ff       	call   801821 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	6a 08                	push   $0x8
  801903:	e8 19 ff ff ff       	call   801821 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 09                	push   $0x9
  80191c:	e8 00 ff ff ff       	call   801821 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 0a                	push   $0xa
  801935:	e8 e7 fe ff ff       	call   801821 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 0b                	push   $0xb
  80194e:	e8 ce fe ff ff       	call   801821 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 0f                	push   $0xf
  801969:	e8 b3 fe ff ff       	call   801821 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 10                	push   $0x10
  801985:	e8 97 fe ff ff       	call   801821 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return ;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	6a 11                	push   $0x11
  8019a2:	e8 7a fe ff ff       	call   801821 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019aa:	90                   	nop
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 0c                	push   $0xc
  8019bc:	e8 60 fe ff ff       	call   801821 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 0d                	push   $0xd
  8019d6:	e8 46 fe ff ff       	call   801821 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 0e                	push   $0xe
  8019ef:	e8 2d fe ff ff       	call   801821 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 13                	push   $0x13
  801a09:	e8 13 fe ff ff       	call   801821 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 14                	push   $0x14
  801a23:	e8 f9 fd ff ff       	call   801821 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	50                   	push   %eax
  801a47:	6a 15                	push   $0x15
  801a49:	e8 d3 fd ff ff       	call   801821 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	90                   	nop
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 16                	push   $0x16
  801a63:	e8 b9 fd ff ff       	call   801821 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	50                   	push   %eax
  801a7e:	6a 17                	push   $0x17
  801a80:	e8 9c fd ff ff       	call   801821 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	6a 1a                	push   $0x1a
  801a9d:	e8 7f fd ff ff       	call   801821 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	6a 18                	push   $0x18
  801aba:	e8 62 fd ff ff       	call   801821 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	90                   	nop
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	52                   	push   %edx
  801ad5:	50                   	push   %eax
  801ad6:	6a 19                	push   $0x19
  801ad8:	e8 44 fd ff ff       	call   801821 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	90                   	nop
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	51                   	push   %ecx
  801afc:	52                   	push   %edx
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	50                   	push   %eax
  801b01:	6a 1b                	push   $0x1b
  801b03:	e8 19 fd ff ff       	call   801821 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 1c                	push   $0x1c
  801b20:	e8 fc fc ff ff       	call   801821 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	51                   	push   %ecx
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 1d                	push   $0x1d
  801b3f:	e8 dd fc ff ff       	call   801821 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	52                   	push   %edx
  801b59:	50                   	push   %eax
  801b5a:	6a 1e                	push   $0x1e
  801b5c:	e8 c0 fc ff ff       	call   801821 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 1f                	push   $0x1f
  801b75:	e8 a7 fc ff ff       	call   801821 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	ff 75 14             	pushl  0x14(%ebp)
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	50                   	push   %eax
  801b91:	6a 20                	push   $0x20
  801b93:	e8 89 fc ff ff       	call   801821 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	50                   	push   %eax
  801bac:	6a 21                	push   $0x21
  801bae:	e8 6e fc ff ff       	call   801821 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	90                   	nop
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	50                   	push   %eax
  801bc8:	6a 22                	push   $0x22
  801bca:	e8 52 fc ff ff       	call   801821 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 02                	push   $0x2
  801be3:	e8 39 fc ff ff       	call   801821 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 03                	push   $0x3
  801bfc:	e8 20 fc ff ff       	call   801821 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 04                	push   $0x4
  801c15:	e8 07 fc ff ff       	call   801821 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_exit_env>:


void sys_exit_env(void)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 23                	push   $0x23
  801c2e:	e8 ee fb ff ff       	call   801821 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	90                   	nop
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c42:	8d 50 04             	lea    0x4(%eax),%edx
  801c45:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	52                   	push   %edx
  801c4f:	50                   	push   %eax
  801c50:	6a 24                	push   $0x24
  801c52:	e8 ca fb ff ff       	call   801821 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return result;
  801c5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c63:	89 01                	mov    %eax,(%ecx)
  801c65:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	c9                   	leave  
  801c6c:	c2 04 00             	ret    $0x4

00801c6f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	ff 75 10             	pushl  0x10(%ebp)
  801c79:	ff 75 0c             	pushl  0xc(%ebp)
  801c7c:	ff 75 08             	pushl  0x8(%ebp)
  801c7f:	6a 12                	push   $0x12
  801c81:	e8 9b fb ff ff       	call   801821 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
	return ;
  801c89:	90                   	nop
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 25                	push   $0x25
  801c9b:	e8 81 fb ff ff       	call   801821 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 04             	sub    $0x4,%esp
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cb1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	50                   	push   %eax
  801cbe:	6a 26                	push   $0x26
  801cc0:	e8 5c fb ff ff       	call   801821 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc8:	90                   	nop
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <rsttst>:
void rsttst()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 28                	push   $0x28
  801cda:	e8 42 fb ff ff       	call   801821 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cf1:	8b 55 18             	mov    0x18(%ebp),%edx
  801cf4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	ff 75 10             	pushl  0x10(%ebp)
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	6a 27                	push   $0x27
  801d05:	e8 17 fb ff ff       	call   801821 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0d:	90                   	nop
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <chktst>:
void chktst(uint32 n)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	ff 75 08             	pushl  0x8(%ebp)
  801d1e:	6a 29                	push   $0x29
  801d20:	e8 fc fa ff ff       	call   801821 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
	return ;
  801d28:	90                   	nop
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <inctst>:

void inctst()
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 2a                	push   $0x2a
  801d3a:	e8 e2 fa ff ff       	call   801821 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d42:	90                   	nop
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <gettst>:
uint32 gettst()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 2b                	push   $0x2b
  801d54:	e8 c8 fa ff ff       	call   801821 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 2c                	push   $0x2c
  801d70:	e8 ac fa ff ff       	call   801821 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
  801d78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d7b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d7f:	75 07                	jne    801d88 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	eb 05                	jmp    801d8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 2c                	push   $0x2c
  801da1:	e8 7b fa ff ff       	call   801821 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
  801da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dac:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801db0:	75 07                	jne    801db9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801db2:	b8 01 00 00 00       	mov    $0x1,%eax
  801db7:	eb 05                	jmp    801dbe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 2c                	push   $0x2c
  801dd2:	e8 4a fa ff ff       	call   801821 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
  801dda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ddd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801de1:	75 07                	jne    801dea <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801de3:	b8 01 00 00 00       	mov    $0x1,%eax
  801de8:	eb 05                	jmp    801def <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 2c                	push   $0x2c
  801e03:	e8 19 fa ff ff       	call   801821 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
  801e0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e0e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e12:	75 07                	jne    801e1b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e14:	b8 01 00 00 00       	mov    $0x1,%eax
  801e19:	eb 05                	jmp    801e20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	6a 2d                	push   $0x2d
  801e32:	e8 ea f9 ff ff       	call   801821 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3a:	90                   	nop
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	53                   	push   %ebx
  801e50:	51                   	push   %ecx
  801e51:	52                   	push   %edx
  801e52:	50                   	push   %eax
  801e53:	6a 2e                	push   $0x2e
  801e55:	e8 c7 f9 ff ff       	call   801821 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	52                   	push   %edx
  801e72:	50                   	push   %eax
  801e73:	6a 2f                	push   $0x2f
  801e75:	e8 a7 f9 ff ff       	call   801821 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e85:	83 ec 0c             	sub    $0xc,%esp
  801e88:	68 28 43 80 00       	push   $0x804328
  801e8d:	e8 1e e8 ff ff       	call   8006b0 <cprintf>
  801e92:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	68 54 43 80 00       	push   $0x804354
  801ea4:	e8 07 e8 ff ff       	call   8006b0 <cprintf>
  801ea9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eac:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eb0:	a1 38 51 80 00       	mov    0x805138,%eax
  801eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb8:	eb 56                	jmp    801f10 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ebe:	74 1c                	je     801edc <print_mem_block_lists+0x5d>
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	8b 50 08             	mov    0x8(%eax),%edx
  801ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec9:	8b 48 08             	mov    0x8(%eax),%ecx
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed2:	01 c8                	add    %ecx,%eax
  801ed4:	39 c2                	cmp    %eax,%edx
  801ed6:	73 04                	jae    801edc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ed8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	8b 50 08             	mov    0x8(%eax),%edx
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee8:	01 c2                	add    %eax,%edx
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	8b 40 08             	mov    0x8(%eax),%eax
  801ef0:	83 ec 04             	sub    $0x4,%esp
  801ef3:	52                   	push   %edx
  801ef4:	50                   	push   %eax
  801ef5:	68 69 43 80 00       	push   $0x804369
  801efa:	e8 b1 e7 ff ff       	call   8006b0 <cprintf>
  801eff:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f08:	a1 40 51 80 00       	mov    0x805140,%eax
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f14:	74 07                	je     801f1d <print_mem_block_lists+0x9e>
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	8b 00                	mov    (%eax),%eax
  801f1b:	eb 05                	jmp    801f22 <print_mem_block_lists+0xa3>
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f22:	a3 40 51 80 00       	mov    %eax,0x805140
  801f27:	a1 40 51 80 00       	mov    0x805140,%eax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	75 8a                	jne    801eba <print_mem_block_lists+0x3b>
  801f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f34:	75 84                	jne    801eba <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f36:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f3a:	75 10                	jne    801f4c <print_mem_block_lists+0xcd>
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	68 78 43 80 00       	push   $0x804378
  801f44:	e8 67 e7 ff ff       	call   8006b0 <cprintf>
  801f49:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f53:	83 ec 0c             	sub    $0xc,%esp
  801f56:	68 9c 43 80 00       	push   $0x80439c
  801f5b:	e8 50 e7 ff ff       	call   8006b0 <cprintf>
  801f60:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f63:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f67:	a1 40 50 80 00       	mov    0x805040,%eax
  801f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6f:	eb 56                	jmp    801fc7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f75:	74 1c                	je     801f93 <print_mem_block_lists+0x114>
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 50 08             	mov    0x8(%eax),%edx
  801f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f80:	8b 48 08             	mov    0x8(%eax),%ecx
  801f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f86:	8b 40 0c             	mov    0xc(%eax),%eax
  801f89:	01 c8                	add    %ecx,%eax
  801f8b:	39 c2                	cmp    %eax,%edx
  801f8d:	73 04                	jae    801f93 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f8f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 50 08             	mov    0x8(%eax),%edx
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9f:	01 c2                	add    %eax,%edx
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	8b 40 08             	mov    0x8(%eax),%eax
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	52                   	push   %edx
  801fab:	50                   	push   %eax
  801fac:	68 69 43 80 00       	push   $0x804369
  801fb1:	e8 fa e6 ff ff       	call   8006b0 <cprintf>
  801fb6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fbf:	a1 48 50 80 00       	mov    0x805048,%eax
  801fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcb:	74 07                	je     801fd4 <print_mem_block_lists+0x155>
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	8b 00                	mov    (%eax),%eax
  801fd2:	eb 05                	jmp    801fd9 <print_mem_block_lists+0x15a>
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	a3 48 50 80 00       	mov    %eax,0x805048
  801fde:	a1 48 50 80 00       	mov    0x805048,%eax
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	75 8a                	jne    801f71 <print_mem_block_lists+0xf2>
  801fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801feb:	75 84                	jne    801f71 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fed:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ff1:	75 10                	jne    802003 <print_mem_block_lists+0x184>
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	68 b4 43 80 00       	push   $0x8043b4
  801ffb:	e8 b0 e6 ff ff       	call   8006b0 <cprintf>
  802000:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	68 28 43 80 00       	push   $0x804328
  80200b:	e8 a0 e6 ff ff       	call   8006b0 <cprintf>
  802010:	83 c4 10             	add    $0x10,%esp

}
  802013:	90                   	nop
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80201c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802023:	00 00 00 
  802026:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80202d:	00 00 00 
  802030:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802037:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80203a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802041:	e9 9e 00 00 00       	jmp    8020e4 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802046:	a1 50 50 80 00       	mov    0x805050,%eax
  80204b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204e:	c1 e2 04             	shl    $0x4,%edx
  802051:	01 d0                	add    %edx,%eax
  802053:	85 c0                	test   %eax,%eax
  802055:	75 14                	jne    80206b <initialize_MemBlocksList+0x55>
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	68 dc 43 80 00       	push   $0x8043dc
  80205f:	6a 46                	push   $0x46
  802061:	68 ff 43 80 00       	push   $0x8043ff
  802066:	e8 91 e3 ff ff       	call   8003fc <_panic>
  80206b:	a1 50 50 80 00       	mov    0x805050,%eax
  802070:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802073:	c1 e2 04             	shl    $0x4,%edx
  802076:	01 d0                	add    %edx,%eax
  802078:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80207e:	89 10                	mov    %edx,(%eax)
  802080:	8b 00                	mov    (%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	74 18                	je     80209e <initialize_MemBlocksList+0x88>
  802086:	a1 48 51 80 00       	mov    0x805148,%eax
  80208b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802091:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802094:	c1 e1 04             	shl    $0x4,%ecx
  802097:	01 ca                	add    %ecx,%edx
  802099:	89 50 04             	mov    %edx,0x4(%eax)
  80209c:	eb 12                	jmp    8020b0 <initialize_MemBlocksList+0x9a>
  80209e:	a1 50 50 80 00       	mov    0x805050,%eax
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	c1 e2 04             	shl    $0x4,%edx
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8020b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b8:	c1 e2 04             	shl    $0x4,%edx
  8020bb:	01 d0                	add    %edx,%eax
  8020bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8020c2:	a1 50 50 80 00       	mov    0x805050,%eax
  8020c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ca:	c1 e2 04             	shl    $0x4,%edx
  8020cd:	01 d0                	add    %edx,%eax
  8020cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8020db:	40                   	inc    %eax
  8020dc:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020e1:	ff 45 f4             	incl   -0xc(%ebp)
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ea:	0f 82 56 ff ff ff    	jb     802046 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020f0:	90                   	nop
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	8b 00                	mov    (%eax),%eax
  8020fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802101:	eb 19                	jmp    80211c <find_block+0x29>
	{
		if(va==point->sva)
  802103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802106:	8b 40 08             	mov    0x8(%eax),%eax
  802109:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80210c:	75 05                	jne    802113 <find_block+0x20>
		   return point;
  80210e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802111:	eb 36                	jmp    802149 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	8b 40 08             	mov    0x8(%eax),%eax
  802119:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802120:	74 07                	je     802129 <find_block+0x36>
  802122:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802125:	8b 00                	mov    (%eax),%eax
  802127:	eb 05                	jmp    80212e <find_block+0x3b>
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
  80212e:	8b 55 08             	mov    0x8(%ebp),%edx
  802131:	89 42 08             	mov    %eax,0x8(%edx)
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	8b 40 08             	mov    0x8(%eax),%eax
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 c5                	jne    802103 <find_block+0x10>
  80213e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802142:	75 bf                	jne    802103 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802144:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802151:	a1 40 50 80 00       	mov    0x805040,%eax
  802156:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802159:	a1 44 50 80 00       	mov    0x805044,%eax
  80215e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802164:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802167:	74 24                	je     80218d <insert_sorted_allocList+0x42>
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8b 50 08             	mov    0x8(%eax),%edx
  80216f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802172:	8b 40 08             	mov    0x8(%eax),%eax
  802175:	39 c2                	cmp    %eax,%edx
  802177:	76 14                	jbe    80218d <insert_sorted_allocList+0x42>
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	8b 50 08             	mov    0x8(%eax),%edx
  80217f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802182:	8b 40 08             	mov    0x8(%eax),%eax
  802185:	39 c2                	cmp    %eax,%edx
  802187:	0f 82 60 01 00 00    	jb     8022ed <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80218d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802191:	75 65                	jne    8021f8 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802197:	75 14                	jne    8021ad <insert_sorted_allocList+0x62>
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	68 dc 43 80 00       	push   $0x8043dc
  8021a1:	6a 6b                	push   $0x6b
  8021a3:	68 ff 43 80 00       	push   $0x8043ff
  8021a8:	e8 4f e2 ff ff       	call   8003fc <_panic>
  8021ad:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	89 10                	mov    %edx,(%eax)
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	8b 00                	mov    (%eax),%eax
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	74 0d                	je     8021ce <insert_sorted_allocList+0x83>
  8021c1:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c9:	89 50 04             	mov    %edx,0x4(%eax)
  8021cc:	eb 08                	jmp    8021d6 <insert_sorted_allocList+0x8b>
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	a3 44 50 80 00       	mov    %eax,0x805044
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	a3 40 50 80 00       	mov    %eax,0x805040
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021ed:	40                   	inc    %eax
  8021ee:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f3:	e9 dc 01 00 00       	jmp    8023d4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	8b 50 08             	mov    0x8(%eax),%edx
  8021fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802201:	8b 40 08             	mov    0x8(%eax),%eax
  802204:	39 c2                	cmp    %eax,%edx
  802206:	77 6c                	ja     802274 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220c:	74 06                	je     802214 <insert_sorted_allocList+0xc9>
  80220e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802212:	75 14                	jne    802228 <insert_sorted_allocList+0xdd>
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	68 18 44 80 00       	push   $0x804418
  80221c:	6a 6f                	push   $0x6f
  80221e:	68 ff 43 80 00       	push   $0x8043ff
  802223:	e8 d4 e1 ff ff       	call   8003fc <_panic>
  802228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222b:	8b 50 04             	mov    0x4(%eax),%edx
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	89 50 04             	mov    %edx,0x4(%eax)
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80223a:	89 10                	mov    %edx,(%eax)
  80223c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223f:	8b 40 04             	mov    0x4(%eax),%eax
  802242:	85 c0                	test   %eax,%eax
  802244:	74 0d                	je     802253 <insert_sorted_allocList+0x108>
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	8b 40 04             	mov    0x4(%eax),%eax
  80224c:	8b 55 08             	mov    0x8(%ebp),%edx
  80224f:	89 10                	mov    %edx,(%eax)
  802251:	eb 08                	jmp    80225b <insert_sorted_allocList+0x110>
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	a3 40 50 80 00       	mov    %eax,0x805040
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225e:	8b 55 08             	mov    0x8(%ebp),%edx
  802261:	89 50 04             	mov    %edx,0x4(%eax)
  802264:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802269:	40                   	inc    %eax
  80226a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80226f:	e9 60 01 00 00       	jmp    8023d4 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	8b 50 08             	mov    0x8(%eax),%edx
  80227a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227d:	8b 40 08             	mov    0x8(%eax),%eax
  802280:	39 c2                	cmp    %eax,%edx
  802282:	0f 82 4c 01 00 00    	jb     8023d4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802288:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228c:	75 14                	jne    8022a2 <insert_sorted_allocList+0x157>
  80228e:	83 ec 04             	sub    $0x4,%esp
  802291:	68 50 44 80 00       	push   $0x804450
  802296:	6a 73                	push   $0x73
  802298:	68 ff 43 80 00       	push   $0x8043ff
  80229d:	e8 5a e1 ff ff       	call   8003fc <_panic>
  8022a2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	89 50 04             	mov    %edx,0x4(%eax)
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	8b 40 04             	mov    0x4(%eax),%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	74 0c                	je     8022c4 <insert_sorted_allocList+0x179>
  8022b8:	a1 44 50 80 00       	mov    0x805044,%eax
  8022bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c0:	89 10                	mov    %edx,(%eax)
  8022c2:	eb 08                	jmp    8022cc <insert_sorted_allocList+0x181>
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 40 50 80 00       	mov    %eax,0x805040
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022dd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e2:	40                   	inc    %eax
  8022e3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e8:	e9 e7 00 00 00       	jmp    8023d4 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8022ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802302:	e9 9d 00 00 00       	jmp    8023a4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 00                	mov    (%eax),%eax
  80230c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	8b 50 08             	mov    0x8(%eax),%edx
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	8b 40 08             	mov    0x8(%eax),%eax
  80231b:	39 c2                	cmp    %eax,%edx
  80231d:	76 7d                	jbe    80239c <insert_sorted_allocList+0x251>
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	8b 50 08             	mov    0x8(%eax),%edx
  802325:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802328:	8b 40 08             	mov    0x8(%eax),%eax
  80232b:	39 c2                	cmp    %eax,%edx
  80232d:	73 6d                	jae    80239c <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	74 06                	je     80233b <insert_sorted_allocList+0x1f0>
  802335:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802339:	75 14                	jne    80234f <insert_sorted_allocList+0x204>
  80233b:	83 ec 04             	sub    $0x4,%esp
  80233e:	68 74 44 80 00       	push   $0x804474
  802343:	6a 7f                	push   $0x7f
  802345:	68 ff 43 80 00       	push   $0x8043ff
  80234a:	e8 ad e0 ff ff       	call   8003fc <_panic>
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 10                	mov    (%eax),%edx
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	89 10                	mov    %edx,(%eax)
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	74 0b                	je     80236d <insert_sorted_allocList+0x222>
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	8b 55 08             	mov    0x8(%ebp),%edx
  80236a:	89 50 04             	mov    %edx,0x4(%eax)
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	8b 55 08             	mov    0x8(%ebp),%edx
  802373:	89 10                	mov    %edx,(%eax)
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	89 50 04             	mov    %edx,0x4(%eax)
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	8b 00                	mov    (%eax),%eax
  802383:	85 c0                	test   %eax,%eax
  802385:	75 08                	jne    80238f <insert_sorted_allocList+0x244>
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	a3 44 50 80 00       	mov    %eax,0x805044
  80238f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802394:	40                   	inc    %eax
  802395:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80239a:	eb 39                	jmp    8023d5 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80239c:	a1 48 50 80 00       	mov    0x805048,%eax
  8023a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a8:	74 07                	je     8023b1 <insert_sorted_allocList+0x266>
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	8b 00                	mov    (%eax),%eax
  8023af:	eb 05                	jmp    8023b6 <insert_sorted_allocList+0x26b>
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b6:	a3 48 50 80 00       	mov    %eax,0x805048
  8023bb:	a1 48 50 80 00       	mov    0x805048,%eax
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	0f 85 3f ff ff ff    	jne    802307 <insert_sorted_allocList+0x1bc>
  8023c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cc:	0f 85 35 ff ff ff    	jne    802307 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d2:	eb 01                	jmp    8023d5 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023d4:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d5:	90                   	nop
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023de:	a1 38 51 80 00       	mov    0x805138,%eax
  8023e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e6:	e9 85 01 00 00       	jmp    802570 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f4:	0f 82 6e 01 00 00    	jb     802568 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802400:	3b 45 08             	cmp    0x8(%ebp),%eax
  802403:	0f 85 8a 00 00 00    	jne    802493 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	75 17                	jne    802426 <alloc_block_FF+0x4e>
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 a8 44 80 00       	push   $0x8044a8
  802417:	68 93 00 00 00       	push   $0x93
  80241c:	68 ff 43 80 00       	push   $0x8043ff
  802421:	e8 d6 df ff ff       	call   8003fc <_panic>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	74 10                	je     80243f <alloc_block_FF+0x67>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802437:	8b 52 04             	mov    0x4(%edx),%edx
  80243a:	89 50 04             	mov    %edx,0x4(%eax)
  80243d:	eb 0b                	jmp    80244a <alloc_block_FF+0x72>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 04             	mov    0x4(%eax),%eax
  802445:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 04             	mov    0x4(%eax),%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 0f                	je     802463 <alloc_block_FF+0x8b>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	8b 12                	mov    (%edx),%edx
  80245f:	89 10                	mov    %edx,(%eax)
  802461:	eb 0a                	jmp    80246d <alloc_block_FF+0x95>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	a3 38 51 80 00       	mov    %eax,0x805138
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802480:	a1 44 51 80 00       	mov    0x805144,%eax
  802485:	48                   	dec    %eax
  802486:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	e9 10 01 00 00       	jmp    8025a3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 0c             	mov    0xc(%eax),%eax
  802499:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249c:	0f 86 c6 00 00 00    	jbe    802568 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8024a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 50 08             	mov    0x8(%eax),%edx
  8024b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bc:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c3:	75 17                	jne    8024dc <alloc_block_FF+0x104>
  8024c5:	83 ec 04             	sub    $0x4,%esp
  8024c8:	68 a8 44 80 00       	push   $0x8044a8
  8024cd:	68 9b 00 00 00       	push   $0x9b
  8024d2:	68 ff 43 80 00       	push   $0x8043ff
  8024d7:	e8 20 df ff ff       	call   8003fc <_panic>
  8024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 10                	je     8024f5 <alloc_block_FF+0x11d>
  8024e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ed:	8b 52 04             	mov    0x4(%edx),%edx
  8024f0:	89 50 04             	mov    %edx,0x4(%eax)
  8024f3:	eb 0b                	jmp    802500 <alloc_block_FF+0x128>
  8024f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 0f                	je     802519 <alloc_block_FF+0x141>
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802513:	8b 12                	mov    (%edx),%edx
  802515:	89 10                	mov    %edx,(%eax)
  802517:	eb 0a                	jmp    802523 <alloc_block_FF+0x14b>
  802519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	a3 48 51 80 00       	mov    %eax,0x805148
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802536:	a1 54 51 80 00       	mov    0x805154,%eax
  80253b:	48                   	dec    %eax
  80253c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 50 08             	mov    0x8(%eax),%edx
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	01 c2                	add    %eax,%edx
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 0c             	mov    0xc(%eax),%eax
  802558:	2b 45 08             	sub    0x8(%ebp),%eax
  80255b:	89 c2                	mov    %eax,%edx
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	eb 3b                	jmp    8025a3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802568:	a1 40 51 80 00       	mov    0x805140,%eax
  80256d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802574:	74 07                	je     80257d <alloc_block_FF+0x1a5>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 00                	mov    (%eax),%eax
  80257b:	eb 05                	jmp    802582 <alloc_block_FF+0x1aa>
  80257d:	b8 00 00 00 00       	mov    $0x0,%eax
  802582:	a3 40 51 80 00       	mov    %eax,0x805140
  802587:	a1 40 51 80 00       	mov    0x805140,%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	0f 85 57 fe ff ff    	jne    8023eb <alloc_block_FF+0x13>
  802594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802598:	0f 85 4d fe ff ff    	jne    8023eb <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80259e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8025b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ba:	e9 df 00 00 00       	jmp    80269e <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c8:	0f 82 c8 00 00 00    	jb     802696 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d7:	0f 85 8a 00 00 00    	jne    802667 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e1:	75 17                	jne    8025fa <alloc_block_BF+0x55>
  8025e3:	83 ec 04             	sub    $0x4,%esp
  8025e6:	68 a8 44 80 00       	push   $0x8044a8
  8025eb:	68 b7 00 00 00       	push   $0xb7
  8025f0:	68 ff 43 80 00       	push   $0x8043ff
  8025f5:	e8 02 de ff ff       	call   8003fc <_panic>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	74 10                	je     802613 <alloc_block_BF+0x6e>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260b:	8b 52 04             	mov    0x4(%edx),%edx
  80260e:	89 50 04             	mov    %edx,0x4(%eax)
  802611:	eb 0b                	jmp    80261e <alloc_block_BF+0x79>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 0f                	je     802637 <alloc_block_BF+0x92>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802631:	8b 12                	mov    (%edx),%edx
  802633:	89 10                	mov    %edx,(%eax)
  802635:	eb 0a                	jmp    802641 <alloc_block_BF+0x9c>
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	a3 38 51 80 00       	mov    %eax,0x805138
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802654:	a1 44 51 80 00       	mov    0x805144,%eax
  802659:	48                   	dec    %eax
  80265a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	e9 4d 01 00 00       	jmp    8027b4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 0c             	mov    0xc(%eax),%eax
  80266d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802670:	76 24                	jbe    802696 <alloc_block_BF+0xf1>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 40 0c             	mov    0xc(%eax),%eax
  802678:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80267b:	73 19                	jae    802696 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80267d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 0c             	mov    0xc(%eax),%eax
  80268a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 08             	mov    0x8(%eax),%eax
  802693:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802696:	a1 40 51 80 00       	mov    0x805140,%eax
  80269b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	74 07                	je     8026ab <alloc_block_BF+0x106>
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	eb 05                	jmp    8026b0 <alloc_block_BF+0x10b>
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	a3 40 51 80 00       	mov    %eax,0x805140
  8026b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	0f 85 fd fe ff ff    	jne    8025bf <alloc_block_BF+0x1a>
  8026c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c6:	0f 85 f3 fe ff ff    	jne    8025bf <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026d0:	0f 84 d9 00 00 00    	je     8027af <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026d6:	a1 48 51 80 00       	mov    0x805148,%eax
  8026db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e4:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ed:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026f4:	75 17                	jne    80270d <alloc_block_BF+0x168>
  8026f6:	83 ec 04             	sub    $0x4,%esp
  8026f9:	68 a8 44 80 00       	push   $0x8044a8
  8026fe:	68 c7 00 00 00       	push   $0xc7
  802703:	68 ff 43 80 00       	push   $0x8043ff
  802708:	e8 ef dc ff ff       	call   8003fc <_panic>
  80270d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802710:	8b 00                	mov    (%eax),%eax
  802712:	85 c0                	test   %eax,%eax
  802714:	74 10                	je     802726 <alloc_block_BF+0x181>
  802716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80271e:	8b 52 04             	mov    0x4(%edx),%edx
  802721:	89 50 04             	mov    %edx,0x4(%eax)
  802724:	eb 0b                	jmp    802731 <alloc_block_BF+0x18c>
  802726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802729:	8b 40 04             	mov    0x4(%eax),%eax
  80272c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	85 c0                	test   %eax,%eax
  802739:	74 0f                	je     80274a <alloc_block_BF+0x1a5>
  80273b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273e:	8b 40 04             	mov    0x4(%eax),%eax
  802741:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802744:	8b 12                	mov    (%edx),%edx
  802746:	89 10                	mov    %edx,(%eax)
  802748:	eb 0a                	jmp    802754 <alloc_block_BF+0x1af>
  80274a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	a3 48 51 80 00       	mov    %eax,0x805148
  802754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802757:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802760:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802767:	a1 54 51 80 00       	mov    0x805154,%eax
  80276c:	48                   	dec    %eax
  80276d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802772:	83 ec 08             	sub    $0x8,%esp
  802775:	ff 75 ec             	pushl  -0x14(%ebp)
  802778:	68 38 51 80 00       	push   $0x805138
  80277d:	e8 71 f9 ff ff       	call   8020f3 <find_block>
  802782:	83 c4 10             	add    $0x10,%esp
  802785:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802788:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278b:	8b 50 08             	mov    0x8(%eax),%edx
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	01 c2                	add    %eax,%edx
  802793:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802796:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279c:	8b 40 0c             	mov    0xc(%eax),%eax
  80279f:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a2:	89 c2                	mov    %eax,%edx
  8027a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ad:	eb 05                	jmp    8027b4 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027bc:	a1 28 50 80 00       	mov    0x805028,%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	0f 85 de 01 00 00    	jne    8029a7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8027ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d1:	e9 9e 01 00 00       	jmp    802974 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027df:	0f 82 87 01 00 00    	jb     80296c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ee:	0f 85 95 00 00 00    	jne    802889 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f8:	75 17                	jne    802811 <alloc_block_NF+0x5b>
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	68 a8 44 80 00       	push   $0x8044a8
  802802:	68 e0 00 00 00       	push   $0xe0
  802807:	68 ff 43 80 00       	push   $0x8043ff
  80280c:	e8 eb db ff ff       	call   8003fc <_panic>
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	85 c0                	test   %eax,%eax
  802818:	74 10                	je     80282a <alloc_block_NF+0x74>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802822:	8b 52 04             	mov    0x4(%edx),%edx
  802825:	89 50 04             	mov    %edx,0x4(%eax)
  802828:	eb 0b                	jmp    802835 <alloc_block_NF+0x7f>
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 40 04             	mov    0x4(%eax),%eax
  802830:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 0f                	je     80284e <alloc_block_NF+0x98>
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802848:	8b 12                	mov    (%edx),%edx
  80284a:	89 10                	mov    %edx,(%eax)
  80284c:	eb 0a                	jmp    802858 <alloc_block_NF+0xa2>
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	a3 38 51 80 00       	mov    %eax,0x805138
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286b:	a1 44 51 80 00       	mov    0x805144,%eax
  802870:	48                   	dec    %eax
  802871:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 08             	mov    0x8(%eax),%eax
  80287c:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	e9 f8 04 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 40 0c             	mov    0xc(%eax),%eax
  80288f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802892:	0f 86 d4 00 00 00    	jbe    80296c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802898:	a1 48 51 80 00       	mov    0x805148,%eax
  80289d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 50 08             	mov    0x8(%eax),%edx
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028af:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b9:	75 17                	jne    8028d2 <alloc_block_NF+0x11c>
  8028bb:	83 ec 04             	sub    $0x4,%esp
  8028be:	68 a8 44 80 00       	push   $0x8044a8
  8028c3:	68 e9 00 00 00       	push   $0xe9
  8028c8:	68 ff 43 80 00       	push   $0x8043ff
  8028cd:	e8 2a db ff ff       	call   8003fc <_panic>
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 10                	je     8028eb <alloc_block_NF+0x135>
  8028db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e3:	8b 52 04             	mov    0x4(%edx),%edx
  8028e6:	89 50 04             	mov    %edx,0x4(%eax)
  8028e9:	eb 0b                	jmp    8028f6 <alloc_block_NF+0x140>
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 0f                	je     80290f <alloc_block_NF+0x159>
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802903:	8b 40 04             	mov    0x4(%eax),%eax
  802906:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802909:	8b 12                	mov    (%edx),%edx
  80290b:	89 10                	mov    %edx,(%eax)
  80290d:	eb 0a                	jmp    802919 <alloc_block_NF+0x163>
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	a3 48 51 80 00       	mov    %eax,0x805148
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292c:	a1 54 51 80 00       	mov    0x805154,%eax
  802931:	48                   	dec    %eax
  802932:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 08             	mov    0x8(%eax),%eax
  80293d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 50 08             	mov    0x8(%eax),%edx
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	01 c2                	add    %eax,%edx
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 40 0c             	mov    0xc(%eax),%eax
  802959:	2b 45 08             	sub    0x8(%ebp),%eax
  80295c:	89 c2                	mov    %eax,%edx
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802967:	e9 15 04 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80296c:	a1 40 51 80 00       	mov    0x805140,%eax
  802971:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802974:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802978:	74 07                	je     802981 <alloc_block_NF+0x1cb>
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	eb 05                	jmp    802986 <alloc_block_NF+0x1d0>
  802981:	b8 00 00 00 00       	mov    $0x0,%eax
  802986:	a3 40 51 80 00       	mov    %eax,0x805140
  80298b:	a1 40 51 80 00       	mov    0x805140,%eax
  802990:	85 c0                	test   %eax,%eax
  802992:	0f 85 3e fe ff ff    	jne    8027d6 <alloc_block_NF+0x20>
  802998:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299c:	0f 85 34 fe ff ff    	jne    8027d6 <alloc_block_NF+0x20>
  8029a2:	e9 d5 03 00 00       	jmp    802d7c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029af:	e9 b1 01 00 00       	jmp    802b65 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ba:	a1 28 50 80 00       	mov    0x805028,%eax
  8029bf:	39 c2                	cmp    %eax,%edx
  8029c1:	0f 82 96 01 00 00    	jb     802b5d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d0:	0f 82 87 01 00 00    	jb     802b5d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029df:	0f 85 95 00 00 00    	jne    802a7a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e9:	75 17                	jne    802a02 <alloc_block_NF+0x24c>
  8029eb:	83 ec 04             	sub    $0x4,%esp
  8029ee:	68 a8 44 80 00       	push   $0x8044a8
  8029f3:	68 fc 00 00 00       	push   $0xfc
  8029f8:	68 ff 43 80 00       	push   $0x8043ff
  8029fd:	e8 fa d9 ff ff       	call   8003fc <_panic>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	85 c0                	test   %eax,%eax
  802a09:	74 10                	je     802a1b <alloc_block_NF+0x265>
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a13:	8b 52 04             	mov    0x4(%edx),%edx
  802a16:	89 50 04             	mov    %edx,0x4(%eax)
  802a19:	eb 0b                	jmp    802a26 <alloc_block_NF+0x270>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 40 04             	mov    0x4(%eax),%eax
  802a21:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 0f                	je     802a3f <alloc_block_NF+0x289>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a39:	8b 12                	mov    (%edx),%edx
  802a3b:	89 10                	mov    %edx,(%eax)
  802a3d:	eb 0a                	jmp    802a49 <alloc_block_NF+0x293>
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	8b 00                	mov    (%eax),%eax
  802a44:	a3 38 51 80 00       	mov    %eax,0x805138
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5c:	a1 44 51 80 00       	mov    0x805144,%eax
  802a61:	48                   	dec    %eax
  802a62:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 40 08             	mov    0x8(%eax),%eax
  802a6d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	e9 07 03 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a80:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a83:	0f 86 d4 00 00 00    	jbe    802b5d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a89:	a1 48 51 80 00       	mov    0x805148,%eax
  802a8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 50 08             	mov    0x8(%eax),%edx
  802a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aa6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aaa:	75 17                	jne    802ac3 <alloc_block_NF+0x30d>
  802aac:	83 ec 04             	sub    $0x4,%esp
  802aaf:	68 a8 44 80 00       	push   $0x8044a8
  802ab4:	68 04 01 00 00       	push   $0x104
  802ab9:	68 ff 43 80 00       	push   $0x8043ff
  802abe:	e8 39 d9 ff ff       	call   8003fc <_panic>
  802ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 10                	je     802adc <alloc_block_NF+0x326>
  802acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad4:	8b 52 04             	mov    0x4(%edx),%edx
  802ad7:	89 50 04             	mov    %edx,0x4(%eax)
  802ada:	eb 0b                	jmp    802ae7 <alloc_block_NF+0x331>
  802adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adf:	8b 40 04             	mov    0x4(%eax),%eax
  802ae2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 0f                	je     802b00 <alloc_block_NF+0x34a>
  802af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af4:	8b 40 04             	mov    0x4(%eax),%eax
  802af7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802afa:	8b 12                	mov    (%edx),%edx
  802afc:	89 10                	mov    %edx,(%eax)
  802afe:	eb 0a                	jmp    802b0a <alloc_block_NF+0x354>
  802b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	a3 48 51 80 00       	mov    %eax,0x805148
  802b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1d:	a1 54 51 80 00       	mov    0x805154,%eax
  802b22:	48                   	dec    %eax
  802b23:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2b:	8b 40 08             	mov    0x8(%eax),%eax
  802b2e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 50 08             	mov    0x8(%eax),%edx
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	01 c2                	add    %eax,%edx
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4a:	2b 45 08             	sub    0x8(%ebp),%eax
  802b4d:	89 c2                	mov    %eax,%edx
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b58:	e9 24 02 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b5d:	a1 40 51 80 00       	mov    0x805140,%eax
  802b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b69:	74 07                	je     802b72 <alloc_block_NF+0x3bc>
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	eb 05                	jmp    802b77 <alloc_block_NF+0x3c1>
  802b72:	b8 00 00 00 00       	mov    $0x0,%eax
  802b77:	a3 40 51 80 00       	mov    %eax,0x805140
  802b7c:	a1 40 51 80 00       	mov    0x805140,%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	0f 85 2b fe ff ff    	jne    8029b4 <alloc_block_NF+0x1fe>
  802b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8d:	0f 85 21 fe ff ff    	jne    8029b4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b93:	a1 38 51 80 00       	mov    0x805138,%eax
  802b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9b:	e9 ae 01 00 00       	jmp    802d4e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 50 08             	mov    0x8(%eax),%edx
  802ba6:	a1 28 50 80 00       	mov    0x805028,%eax
  802bab:	39 c2                	cmp    %eax,%edx
  802bad:	0f 83 93 01 00 00    	jae    802d46 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bbc:	0f 82 84 01 00 00    	jb     802d46 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bcb:	0f 85 95 00 00 00    	jne    802c66 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd5:	75 17                	jne    802bee <alloc_block_NF+0x438>
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	68 a8 44 80 00       	push   $0x8044a8
  802bdf:	68 14 01 00 00       	push   $0x114
  802be4:	68 ff 43 80 00       	push   $0x8043ff
  802be9:	e8 0e d8 ff ff       	call   8003fc <_panic>
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	74 10                	je     802c07 <alloc_block_NF+0x451>
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bff:	8b 52 04             	mov    0x4(%edx),%edx
  802c02:	89 50 04             	mov    %edx,0x4(%eax)
  802c05:	eb 0b                	jmp    802c12 <alloc_block_NF+0x45c>
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 40 04             	mov    0x4(%eax),%eax
  802c0d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 40 04             	mov    0x4(%eax),%eax
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	74 0f                	je     802c2b <alloc_block_NF+0x475>
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c25:	8b 12                	mov    (%edx),%edx
  802c27:	89 10                	mov    %edx,(%eax)
  802c29:	eb 0a                	jmp    802c35 <alloc_block_NF+0x47f>
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	a3 38 51 80 00       	mov    %eax,0x805138
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c48:	a1 44 51 80 00       	mov    0x805144,%eax
  802c4d:	48                   	dec    %eax
  802c4e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 08             	mov    0x8(%eax),%eax
  802c59:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	e9 1b 01 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c6f:	0f 86 d1 00 00 00    	jbe    802d46 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c75:	a1 48 51 80 00       	mov    0x805148,%eax
  802c7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 50 08             	mov    0x8(%eax),%edx
  802c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c86:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c96:	75 17                	jne    802caf <alloc_block_NF+0x4f9>
  802c98:	83 ec 04             	sub    $0x4,%esp
  802c9b:	68 a8 44 80 00       	push   $0x8044a8
  802ca0:	68 1c 01 00 00       	push   $0x11c
  802ca5:	68 ff 43 80 00       	push   $0x8043ff
  802caa:	e8 4d d7 ff ff       	call   8003fc <_panic>
  802caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	74 10                	je     802cc8 <alloc_block_NF+0x512>
  802cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc0:	8b 52 04             	mov    0x4(%edx),%edx
  802cc3:	89 50 04             	mov    %edx,0x4(%eax)
  802cc6:	eb 0b                	jmp    802cd3 <alloc_block_NF+0x51d>
  802cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd6:	8b 40 04             	mov    0x4(%eax),%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	74 0f                	je     802cec <alloc_block_NF+0x536>
  802cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce0:	8b 40 04             	mov    0x4(%eax),%eax
  802ce3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce6:	8b 12                	mov    (%edx),%edx
  802ce8:	89 10                	mov    %edx,(%eax)
  802cea:	eb 0a                	jmp    802cf6 <alloc_block_NF+0x540>
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d09:	a1 54 51 80 00       	mov    0x805154,%eax
  802d0e:	48                   	dec    %eax
  802d0f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d17:	8b 40 08             	mov    0x8(%eax),%eax
  802d1a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 50 08             	mov    0x8(%eax),%edx
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	01 c2                	add    %eax,%edx
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 40 0c             	mov    0xc(%eax),%eax
  802d36:	2b 45 08             	sub    0x8(%ebp),%eax
  802d39:	89 c2                	mov    %eax,%edx
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d44:	eb 3b                	jmp    802d81 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d46:	a1 40 51 80 00       	mov    0x805140,%eax
  802d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d52:	74 07                	je     802d5b <alloc_block_NF+0x5a5>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	eb 05                	jmp    802d60 <alloc_block_NF+0x5aa>
  802d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d60:	a3 40 51 80 00       	mov    %eax,0x805140
  802d65:	a1 40 51 80 00       	mov    0x805140,%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	0f 85 2e fe ff ff    	jne    802ba0 <alloc_block_NF+0x3ea>
  802d72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d76:	0f 85 24 fe ff ff    	jne    802ba0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d81:	c9                   	leave  
  802d82:	c3                   	ret    

00802d83 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d83:	55                   	push   %ebp
  802d84:	89 e5                	mov    %esp,%ebp
  802d86:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d89:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d91:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d96:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d99:	a1 38 51 80 00       	mov    0x805138,%eax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	74 14                	je     802db6 <insert_sorted_with_merge_freeList+0x33>
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dab:	8b 40 08             	mov    0x8(%eax),%eax
  802dae:	39 c2                	cmp    %eax,%edx
  802db0:	0f 87 9b 01 00 00    	ja     802f51 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802db6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dba:	75 17                	jne    802dd3 <insert_sorted_with_merge_freeList+0x50>
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	68 dc 43 80 00       	push   $0x8043dc
  802dc4:	68 38 01 00 00       	push   $0x138
  802dc9:	68 ff 43 80 00       	push   $0x8043ff
  802dce:	e8 29 d6 ff ff       	call   8003fc <_panic>
  802dd3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	89 10                	mov    %edx,(%eax)
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 0d                	je     802df4 <insert_sorted_with_merge_freeList+0x71>
  802de7:	a1 38 51 80 00       	mov    0x805138,%eax
  802dec:	8b 55 08             	mov    0x8(%ebp),%edx
  802def:	89 50 04             	mov    %edx,0x4(%eax)
  802df2:	eb 08                	jmp    802dfc <insert_sorted_with_merge_freeList+0x79>
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	a3 38 51 80 00       	mov    %eax,0x805138
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e13:	40                   	inc    %eax
  802e14:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1d:	0f 84 a8 06 00 00    	je     8034cb <insert_sorted_with_merge_freeList+0x748>
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	8b 50 08             	mov    0x8(%eax),%edx
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2f:	01 c2                	add    %eax,%edx
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e34:	8b 40 08             	mov    0x8(%eax),%eax
  802e37:	39 c2                	cmp    %eax,%edx
  802e39:	0f 85 8c 06 00 00    	jne    8034cb <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	8b 50 0c             	mov    0xc(%eax),%edx
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4b:	01 c2                	add    %eax,%edx
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e57:	75 17                	jne    802e70 <insert_sorted_with_merge_freeList+0xed>
  802e59:	83 ec 04             	sub    $0x4,%esp
  802e5c:	68 a8 44 80 00       	push   $0x8044a8
  802e61:	68 3c 01 00 00       	push   $0x13c
  802e66:	68 ff 43 80 00       	push   $0x8043ff
  802e6b:	e8 8c d5 ff ff       	call   8003fc <_panic>
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	74 10                	je     802e89 <insert_sorted_with_merge_freeList+0x106>
  802e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e81:	8b 52 04             	mov    0x4(%edx),%edx
  802e84:	89 50 04             	mov    %edx,0x4(%eax)
  802e87:	eb 0b                	jmp    802e94 <insert_sorted_with_merge_freeList+0x111>
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e97:	8b 40 04             	mov    0x4(%eax),%eax
  802e9a:	85 c0                	test   %eax,%eax
  802e9c:	74 0f                	je     802ead <insert_sorted_with_merge_freeList+0x12a>
  802e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea1:	8b 40 04             	mov    0x4(%eax),%eax
  802ea4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea7:	8b 12                	mov    (%edx),%edx
  802ea9:	89 10                	mov    %edx,(%eax)
  802eab:	eb 0a                	jmp    802eb7 <insert_sorted_with_merge_freeList+0x134>
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eca:	a1 44 51 80 00       	mov    0x805144,%eax
  802ecf:	48                   	dec    %eax
  802ed0:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ee9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eed:	75 17                	jne    802f06 <insert_sorted_with_merge_freeList+0x183>
  802eef:	83 ec 04             	sub    $0x4,%esp
  802ef2:	68 dc 43 80 00       	push   $0x8043dc
  802ef7:	68 3f 01 00 00       	push   $0x13f
  802efc:	68 ff 43 80 00       	push   $0x8043ff
  802f01:	e8 f6 d4 ff ff       	call   8003fc <_panic>
  802f06:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0f:	89 10                	mov    %edx,(%eax)
  802f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	85 c0                	test   %eax,%eax
  802f18:	74 0d                	je     802f27 <insert_sorted_with_merge_freeList+0x1a4>
  802f1a:	a1 48 51 80 00       	mov    0x805148,%eax
  802f1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f22:	89 50 04             	mov    %edx,0x4(%eax)
  802f25:	eb 08                	jmp    802f2f <insert_sorted_with_merge_freeList+0x1ac>
  802f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	a3 48 51 80 00       	mov    %eax,0x805148
  802f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f41:	a1 54 51 80 00       	mov    0x805154,%eax
  802f46:	40                   	inc    %eax
  802f47:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f4c:	e9 7a 05 00 00       	jmp    8034cb <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	8b 50 08             	mov    0x8(%eax),%edx
  802f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5a:	8b 40 08             	mov    0x8(%eax),%eax
  802f5d:	39 c2                	cmp    %eax,%edx
  802f5f:	0f 82 14 01 00 00    	jb     803079 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f68:	8b 50 08             	mov    0x8(%eax),%edx
  802f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f71:	01 c2                	add    %eax,%edx
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 40 08             	mov    0x8(%eax),%eax
  802f79:	39 c2                	cmp    %eax,%edx
  802f7b:	0f 85 90 00 00 00    	jne    803011 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f84:	8b 50 0c             	mov    0xc(%eax),%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8d:	01 c2                	add    %eax,%edx
  802f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f92:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fad:	75 17                	jne    802fc6 <insert_sorted_with_merge_freeList+0x243>
  802faf:	83 ec 04             	sub    $0x4,%esp
  802fb2:	68 dc 43 80 00       	push   $0x8043dc
  802fb7:	68 49 01 00 00       	push   $0x149
  802fbc:	68 ff 43 80 00       	push   $0x8043ff
  802fc1:	e8 36 d4 ff ff       	call   8003fc <_panic>
  802fc6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	89 10                	mov    %edx,(%eax)
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 0d                	je     802fe7 <insert_sorted_with_merge_freeList+0x264>
  802fda:	a1 48 51 80 00       	mov    0x805148,%eax
  802fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	eb 08                	jmp    802fef <insert_sorted_with_merge_freeList+0x26c>
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803001:	a1 54 51 80 00       	mov    0x805154,%eax
  803006:	40                   	inc    %eax
  803007:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80300c:	e9 bb 04 00 00       	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803011:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803015:	75 17                	jne    80302e <insert_sorted_with_merge_freeList+0x2ab>
  803017:	83 ec 04             	sub    $0x4,%esp
  80301a:	68 50 44 80 00       	push   $0x804450
  80301f:	68 4c 01 00 00       	push   $0x14c
  803024:	68 ff 43 80 00       	push   $0x8043ff
  803029:	e8 ce d3 ff ff       	call   8003fc <_panic>
  80302e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	89 50 04             	mov    %edx,0x4(%eax)
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8b 40 04             	mov    0x4(%eax),%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	74 0c                	je     803050 <insert_sorted_with_merge_freeList+0x2cd>
  803044:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803049:	8b 55 08             	mov    0x8(%ebp),%edx
  80304c:	89 10                	mov    %edx,(%eax)
  80304e:	eb 08                	jmp    803058 <insert_sorted_with_merge_freeList+0x2d5>
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	a3 38 51 80 00       	mov    %eax,0x805138
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803069:	a1 44 51 80 00       	mov    0x805144,%eax
  80306e:	40                   	inc    %eax
  80306f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803074:	e9 53 04 00 00       	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803079:	a1 38 51 80 00       	mov    0x805138,%eax
  80307e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803081:	e9 15 04 00 00       	jmp    80349b <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	8b 50 08             	mov    0x8(%eax),%edx
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 08             	mov    0x8(%eax),%eax
  80309a:	39 c2                	cmp    %eax,%edx
  80309c:	0f 86 f1 03 00 00    	jbe    803493 <insert_sorted_with_merge_freeList+0x710>
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 50 08             	mov    0x8(%eax),%edx
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	8b 40 08             	mov    0x8(%eax),%eax
  8030ae:	39 c2                	cmp    %eax,%edx
  8030b0:	0f 83 dd 03 00 00    	jae    803493 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	8b 50 08             	mov    0x8(%eax),%edx
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c2:	01 c2                	add    %eax,%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ca:	39 c2                	cmp    %eax,%edx
  8030cc:	0f 85 b9 01 00 00    	jne    80328b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	8b 50 08             	mov    0x8(%eax),%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 40 0c             	mov    0xc(%eax),%eax
  8030de:	01 c2                	add    %eax,%edx
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	8b 40 08             	mov    0x8(%eax),%eax
  8030e6:	39 c2                	cmp    %eax,%edx
  8030e8:	0f 85 0d 01 00 00    	jne    8031fb <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fa:	01 c2                	add    %eax,%edx
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803102:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803106:	75 17                	jne    80311f <insert_sorted_with_merge_freeList+0x39c>
  803108:	83 ec 04             	sub    $0x4,%esp
  80310b:	68 a8 44 80 00       	push   $0x8044a8
  803110:	68 5c 01 00 00       	push   $0x15c
  803115:	68 ff 43 80 00       	push   $0x8043ff
  80311a:	e8 dd d2 ff ff       	call   8003fc <_panic>
  80311f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	74 10                	je     803138 <insert_sorted_with_merge_freeList+0x3b5>
  803128:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803130:	8b 52 04             	mov    0x4(%edx),%edx
  803133:	89 50 04             	mov    %edx,0x4(%eax)
  803136:	eb 0b                	jmp    803143 <insert_sorted_with_merge_freeList+0x3c0>
  803138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313b:	8b 40 04             	mov    0x4(%eax),%eax
  80313e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803146:	8b 40 04             	mov    0x4(%eax),%eax
  803149:	85 c0                	test   %eax,%eax
  80314b:	74 0f                	je     80315c <insert_sorted_with_merge_freeList+0x3d9>
  80314d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803150:	8b 40 04             	mov    0x4(%eax),%eax
  803153:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803156:	8b 12                	mov    (%edx),%edx
  803158:	89 10                	mov    %edx,(%eax)
  80315a:	eb 0a                	jmp    803166 <insert_sorted_with_merge_freeList+0x3e3>
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	a3 38 51 80 00       	mov    %eax,0x805138
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803172:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803179:	a1 44 51 80 00       	mov    0x805144,%eax
  80317e:	48                   	dec    %eax
  80317f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80318e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803191:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803198:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319c:	75 17                	jne    8031b5 <insert_sorted_with_merge_freeList+0x432>
  80319e:	83 ec 04             	sub    $0x4,%esp
  8031a1:	68 dc 43 80 00       	push   $0x8043dc
  8031a6:	68 5f 01 00 00       	push   $0x15f
  8031ab:	68 ff 43 80 00       	push   $0x8043ff
  8031b0:	e8 47 d2 ff ff       	call   8003fc <_panic>
  8031b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031be:	89 10                	mov    %edx,(%eax)
  8031c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	85 c0                	test   %eax,%eax
  8031c7:	74 0d                	je     8031d6 <insert_sorted_with_merge_freeList+0x453>
  8031c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d1:	89 50 04             	mov    %edx,0x4(%eax)
  8031d4:	eb 08                	jmp    8031de <insert_sorted_with_merge_freeList+0x45b>
  8031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8031e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f5:	40                   	inc    %eax
  8031f6:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	8b 50 0c             	mov    0xc(%eax),%edx
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	8b 40 0c             	mov    0xc(%eax),%eax
  803207:	01 c2                	add    %eax,%edx
  803209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803223:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803227:	75 17                	jne    803240 <insert_sorted_with_merge_freeList+0x4bd>
  803229:	83 ec 04             	sub    $0x4,%esp
  80322c:	68 dc 43 80 00       	push   $0x8043dc
  803231:	68 64 01 00 00       	push   $0x164
  803236:	68 ff 43 80 00       	push   $0x8043ff
  80323b:	e8 bc d1 ff ff       	call   8003fc <_panic>
  803240:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	89 10                	mov    %edx,(%eax)
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	85 c0                	test   %eax,%eax
  803252:	74 0d                	je     803261 <insert_sorted_with_merge_freeList+0x4de>
  803254:	a1 48 51 80 00       	mov    0x805148,%eax
  803259:	8b 55 08             	mov    0x8(%ebp),%edx
  80325c:	89 50 04             	mov    %edx,0x4(%eax)
  80325f:	eb 08                	jmp    803269 <insert_sorted_with_merge_freeList+0x4e6>
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	a3 48 51 80 00       	mov    %eax,0x805148
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327b:	a1 54 51 80 00       	mov    0x805154,%eax
  803280:	40                   	inc    %eax
  803281:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803286:	e9 41 02 00 00       	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	8b 50 08             	mov    0x8(%eax),%edx
  803291:	8b 45 08             	mov    0x8(%ebp),%eax
  803294:	8b 40 0c             	mov    0xc(%eax),%eax
  803297:	01 c2                	add    %eax,%edx
  803299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329c:	8b 40 08             	mov    0x8(%eax),%eax
  80329f:	39 c2                	cmp    %eax,%edx
  8032a1:	0f 85 7c 01 00 00    	jne    803423 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ab:	74 06                	je     8032b3 <insert_sorted_with_merge_freeList+0x530>
  8032ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b1:	75 17                	jne    8032ca <insert_sorted_with_merge_freeList+0x547>
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 18 44 80 00       	push   $0x804418
  8032bb:	68 69 01 00 00       	push   $0x169
  8032c0:	68 ff 43 80 00       	push   $0x8043ff
  8032c5:	e8 32 d1 ff ff       	call   8003fc <_panic>
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 50 04             	mov    0x4(%eax),%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	89 50 04             	mov    %edx,0x4(%eax)
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032dc:	89 10                	mov    %edx,(%eax)
  8032de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e1:	8b 40 04             	mov    0x4(%eax),%eax
  8032e4:	85 c0                	test   %eax,%eax
  8032e6:	74 0d                	je     8032f5 <insert_sorted_with_merge_freeList+0x572>
  8032e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032eb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f1:	89 10                	mov    %edx,(%eax)
  8032f3:	eb 08                	jmp    8032fd <insert_sorted_with_merge_freeList+0x57a>
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803300:	8b 55 08             	mov    0x8(%ebp),%edx
  803303:	89 50 04             	mov    %edx,0x4(%eax)
  803306:	a1 44 51 80 00       	mov    0x805144,%eax
  80330b:	40                   	inc    %eax
  80330c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 50 0c             	mov    0xc(%eax),%edx
  803317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331a:	8b 40 0c             	mov    0xc(%eax),%eax
  80331d:	01 c2                	add    %eax,%edx
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803325:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803329:	75 17                	jne    803342 <insert_sorted_with_merge_freeList+0x5bf>
  80332b:	83 ec 04             	sub    $0x4,%esp
  80332e:	68 a8 44 80 00       	push   $0x8044a8
  803333:	68 6b 01 00 00       	push   $0x16b
  803338:	68 ff 43 80 00       	push   $0x8043ff
  80333d:	e8 ba d0 ff ff       	call   8003fc <_panic>
  803342:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 10                	je     80335b <insert_sorted_with_merge_freeList+0x5d8>
  80334b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803353:	8b 52 04             	mov    0x4(%edx),%edx
  803356:	89 50 04             	mov    %edx,0x4(%eax)
  803359:	eb 0b                	jmp    803366 <insert_sorted_with_merge_freeList+0x5e3>
  80335b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	8b 40 04             	mov    0x4(%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 0f                	je     80337f <insert_sorted_with_merge_freeList+0x5fc>
  803370:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803379:	8b 12                	mov    (%edx),%edx
  80337b:	89 10                	mov    %edx,(%eax)
  80337d:	eb 0a                	jmp    803389 <insert_sorted_with_merge_freeList+0x606>
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	a3 38 51 80 00       	mov    %eax,0x805138
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803392:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803395:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339c:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a1:	48                   	dec    %eax
  8033a2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033bf:	75 17                	jne    8033d8 <insert_sorted_with_merge_freeList+0x655>
  8033c1:	83 ec 04             	sub    $0x4,%esp
  8033c4:	68 dc 43 80 00       	push   $0x8043dc
  8033c9:	68 6e 01 00 00       	push   $0x16e
  8033ce:	68 ff 43 80 00       	push   $0x8043ff
  8033d3:	e8 24 d0 ff ff       	call   8003fc <_panic>
  8033d8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e1:	89 10                	mov    %edx,(%eax)
  8033e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e6:	8b 00                	mov    (%eax),%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	74 0d                	je     8033f9 <insert_sorted_with_merge_freeList+0x676>
  8033ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f4:	89 50 04             	mov    %edx,0x4(%eax)
  8033f7:	eb 08                	jmp    803401 <insert_sorted_with_merge_freeList+0x67e>
  8033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803404:	a3 48 51 80 00       	mov    %eax,0x805148
  803409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803413:	a1 54 51 80 00       	mov    0x805154,%eax
  803418:	40                   	inc    %eax
  803419:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80341e:	e9 a9 00 00 00       	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803427:	74 06                	je     80342f <insert_sorted_with_merge_freeList+0x6ac>
  803429:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342d:	75 17                	jne    803446 <insert_sorted_with_merge_freeList+0x6c3>
  80342f:	83 ec 04             	sub    $0x4,%esp
  803432:	68 74 44 80 00       	push   $0x804474
  803437:	68 73 01 00 00       	push   $0x173
  80343c:	68 ff 43 80 00       	push   $0x8043ff
  803441:	e8 b6 cf ff ff       	call   8003fc <_panic>
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	8b 10                	mov    (%eax),%edx
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	89 10                	mov    %edx,(%eax)
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	8b 00                	mov    (%eax),%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	74 0b                	je     803464 <insert_sorted_with_merge_freeList+0x6e1>
  803459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	8b 55 08             	mov    0x8(%ebp),%edx
  803461:	89 50 04             	mov    %edx,0x4(%eax)
  803464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803467:	8b 55 08             	mov    0x8(%ebp),%edx
  80346a:	89 10                	mov    %edx,(%eax)
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803472:	89 50 04             	mov    %edx,0x4(%eax)
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	8b 00                	mov    (%eax),%eax
  80347a:	85 c0                	test   %eax,%eax
  80347c:	75 08                	jne    803486 <insert_sorted_with_merge_freeList+0x703>
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803486:	a1 44 51 80 00       	mov    0x805144,%eax
  80348b:	40                   	inc    %eax
  80348c:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803491:	eb 39                	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803493:	a1 40 51 80 00       	mov    0x805140,%eax
  803498:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349f:	74 07                	je     8034a8 <insert_sorted_with_merge_freeList+0x725>
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	8b 00                	mov    (%eax),%eax
  8034a6:	eb 05                	jmp    8034ad <insert_sorted_with_merge_freeList+0x72a>
  8034a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ad:	a3 40 51 80 00       	mov    %eax,0x805140
  8034b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	0f 85 c7 fb ff ff    	jne    803086 <insert_sorted_with_merge_freeList+0x303>
  8034bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c3:	0f 85 bd fb ff ff    	jne    803086 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034c9:	eb 01                	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034cb:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034cc:	90                   	nop
  8034cd:	c9                   	leave  
  8034ce:	c3                   	ret    
  8034cf:	90                   	nop

008034d0 <__udivdi3>:
  8034d0:	55                   	push   %ebp
  8034d1:	57                   	push   %edi
  8034d2:	56                   	push   %esi
  8034d3:	53                   	push   %ebx
  8034d4:	83 ec 1c             	sub    $0x1c,%esp
  8034d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034e7:	89 ca                	mov    %ecx,%edx
  8034e9:	89 f8                	mov    %edi,%eax
  8034eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034ef:	85 f6                	test   %esi,%esi
  8034f1:	75 2d                	jne    803520 <__udivdi3+0x50>
  8034f3:	39 cf                	cmp    %ecx,%edi
  8034f5:	77 65                	ja     80355c <__udivdi3+0x8c>
  8034f7:	89 fd                	mov    %edi,%ebp
  8034f9:	85 ff                	test   %edi,%edi
  8034fb:	75 0b                	jne    803508 <__udivdi3+0x38>
  8034fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803502:	31 d2                	xor    %edx,%edx
  803504:	f7 f7                	div    %edi
  803506:	89 c5                	mov    %eax,%ebp
  803508:	31 d2                	xor    %edx,%edx
  80350a:	89 c8                	mov    %ecx,%eax
  80350c:	f7 f5                	div    %ebp
  80350e:	89 c1                	mov    %eax,%ecx
  803510:	89 d8                	mov    %ebx,%eax
  803512:	f7 f5                	div    %ebp
  803514:	89 cf                	mov    %ecx,%edi
  803516:	89 fa                	mov    %edi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	39 ce                	cmp    %ecx,%esi
  803522:	77 28                	ja     80354c <__udivdi3+0x7c>
  803524:	0f bd fe             	bsr    %esi,%edi
  803527:	83 f7 1f             	xor    $0x1f,%edi
  80352a:	75 40                	jne    80356c <__udivdi3+0x9c>
  80352c:	39 ce                	cmp    %ecx,%esi
  80352e:	72 0a                	jb     80353a <__udivdi3+0x6a>
  803530:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803534:	0f 87 9e 00 00 00    	ja     8035d8 <__udivdi3+0x108>
  80353a:	b8 01 00 00 00       	mov    $0x1,%eax
  80353f:	89 fa                	mov    %edi,%edx
  803541:	83 c4 1c             	add    $0x1c,%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5f                   	pop    %edi
  803547:	5d                   	pop    %ebp
  803548:	c3                   	ret    
  803549:	8d 76 00             	lea    0x0(%esi),%esi
  80354c:	31 ff                	xor    %edi,%edi
  80354e:	31 c0                	xor    %eax,%eax
  803550:	89 fa                	mov    %edi,%edx
  803552:	83 c4 1c             	add    $0x1c,%esp
  803555:	5b                   	pop    %ebx
  803556:	5e                   	pop    %esi
  803557:	5f                   	pop    %edi
  803558:	5d                   	pop    %ebp
  803559:	c3                   	ret    
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	89 d8                	mov    %ebx,%eax
  80355e:	f7 f7                	div    %edi
  803560:	31 ff                	xor    %edi,%edi
  803562:	89 fa                	mov    %edi,%edx
  803564:	83 c4 1c             	add    $0x1c,%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5f                   	pop    %edi
  80356a:	5d                   	pop    %ebp
  80356b:	c3                   	ret    
  80356c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803571:	89 eb                	mov    %ebp,%ebx
  803573:	29 fb                	sub    %edi,%ebx
  803575:	89 f9                	mov    %edi,%ecx
  803577:	d3 e6                	shl    %cl,%esi
  803579:	89 c5                	mov    %eax,%ebp
  80357b:	88 d9                	mov    %bl,%cl
  80357d:	d3 ed                	shr    %cl,%ebp
  80357f:	89 e9                	mov    %ebp,%ecx
  803581:	09 f1                	or     %esi,%ecx
  803583:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803587:	89 f9                	mov    %edi,%ecx
  803589:	d3 e0                	shl    %cl,%eax
  80358b:	89 c5                	mov    %eax,%ebp
  80358d:	89 d6                	mov    %edx,%esi
  80358f:	88 d9                	mov    %bl,%cl
  803591:	d3 ee                	shr    %cl,%esi
  803593:	89 f9                	mov    %edi,%ecx
  803595:	d3 e2                	shl    %cl,%edx
  803597:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359b:	88 d9                	mov    %bl,%cl
  80359d:	d3 e8                	shr    %cl,%eax
  80359f:	09 c2                	or     %eax,%edx
  8035a1:	89 d0                	mov    %edx,%eax
  8035a3:	89 f2                	mov    %esi,%edx
  8035a5:	f7 74 24 0c          	divl   0xc(%esp)
  8035a9:	89 d6                	mov    %edx,%esi
  8035ab:	89 c3                	mov    %eax,%ebx
  8035ad:	f7 e5                	mul    %ebp
  8035af:	39 d6                	cmp    %edx,%esi
  8035b1:	72 19                	jb     8035cc <__udivdi3+0xfc>
  8035b3:	74 0b                	je     8035c0 <__udivdi3+0xf0>
  8035b5:	89 d8                	mov    %ebx,%eax
  8035b7:	31 ff                	xor    %edi,%edi
  8035b9:	e9 58 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035be:	66 90                	xchg   %ax,%ax
  8035c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035c4:	89 f9                	mov    %edi,%ecx
  8035c6:	d3 e2                	shl    %cl,%edx
  8035c8:	39 c2                	cmp    %eax,%edx
  8035ca:	73 e9                	jae    8035b5 <__udivdi3+0xe5>
  8035cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035cf:	31 ff                	xor    %edi,%edi
  8035d1:	e9 40 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035d6:	66 90                	xchg   %ax,%ax
  8035d8:	31 c0                	xor    %eax,%eax
  8035da:	e9 37 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035df:	90                   	nop

008035e0 <__umoddi3>:
  8035e0:	55                   	push   %ebp
  8035e1:	57                   	push   %edi
  8035e2:	56                   	push   %esi
  8035e3:	53                   	push   %ebx
  8035e4:	83 ec 1c             	sub    $0x1c,%esp
  8035e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035ff:	89 f3                	mov    %esi,%ebx
  803601:	89 fa                	mov    %edi,%edx
  803603:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803607:	89 34 24             	mov    %esi,(%esp)
  80360a:	85 c0                	test   %eax,%eax
  80360c:	75 1a                	jne    803628 <__umoddi3+0x48>
  80360e:	39 f7                	cmp    %esi,%edi
  803610:	0f 86 a2 00 00 00    	jbe    8036b8 <__umoddi3+0xd8>
  803616:	89 c8                	mov    %ecx,%eax
  803618:	89 f2                	mov    %esi,%edx
  80361a:	f7 f7                	div    %edi
  80361c:	89 d0                	mov    %edx,%eax
  80361e:	31 d2                	xor    %edx,%edx
  803620:	83 c4 1c             	add    $0x1c,%esp
  803623:	5b                   	pop    %ebx
  803624:	5e                   	pop    %esi
  803625:	5f                   	pop    %edi
  803626:	5d                   	pop    %ebp
  803627:	c3                   	ret    
  803628:	39 f0                	cmp    %esi,%eax
  80362a:	0f 87 ac 00 00 00    	ja     8036dc <__umoddi3+0xfc>
  803630:	0f bd e8             	bsr    %eax,%ebp
  803633:	83 f5 1f             	xor    $0x1f,%ebp
  803636:	0f 84 ac 00 00 00    	je     8036e8 <__umoddi3+0x108>
  80363c:	bf 20 00 00 00       	mov    $0x20,%edi
  803641:	29 ef                	sub    %ebp,%edi
  803643:	89 fe                	mov    %edi,%esi
  803645:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803649:	89 e9                	mov    %ebp,%ecx
  80364b:	d3 e0                	shl    %cl,%eax
  80364d:	89 d7                	mov    %edx,%edi
  80364f:	89 f1                	mov    %esi,%ecx
  803651:	d3 ef                	shr    %cl,%edi
  803653:	09 c7                	or     %eax,%edi
  803655:	89 e9                	mov    %ebp,%ecx
  803657:	d3 e2                	shl    %cl,%edx
  803659:	89 14 24             	mov    %edx,(%esp)
  80365c:	89 d8                	mov    %ebx,%eax
  80365e:	d3 e0                	shl    %cl,%eax
  803660:	89 c2                	mov    %eax,%edx
  803662:	8b 44 24 08          	mov    0x8(%esp),%eax
  803666:	d3 e0                	shl    %cl,%eax
  803668:	89 44 24 04          	mov    %eax,0x4(%esp)
  80366c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803670:	89 f1                	mov    %esi,%ecx
  803672:	d3 e8                	shr    %cl,%eax
  803674:	09 d0                	or     %edx,%eax
  803676:	d3 eb                	shr    %cl,%ebx
  803678:	89 da                	mov    %ebx,%edx
  80367a:	f7 f7                	div    %edi
  80367c:	89 d3                	mov    %edx,%ebx
  80367e:	f7 24 24             	mull   (%esp)
  803681:	89 c6                	mov    %eax,%esi
  803683:	89 d1                	mov    %edx,%ecx
  803685:	39 d3                	cmp    %edx,%ebx
  803687:	0f 82 87 00 00 00    	jb     803714 <__umoddi3+0x134>
  80368d:	0f 84 91 00 00 00    	je     803724 <__umoddi3+0x144>
  803693:	8b 54 24 04          	mov    0x4(%esp),%edx
  803697:	29 f2                	sub    %esi,%edx
  803699:	19 cb                	sbb    %ecx,%ebx
  80369b:	89 d8                	mov    %ebx,%eax
  80369d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036a1:	d3 e0                	shl    %cl,%eax
  8036a3:	89 e9                	mov    %ebp,%ecx
  8036a5:	d3 ea                	shr    %cl,%edx
  8036a7:	09 d0                	or     %edx,%eax
  8036a9:	89 e9                	mov    %ebp,%ecx
  8036ab:	d3 eb                	shr    %cl,%ebx
  8036ad:	89 da                	mov    %ebx,%edx
  8036af:	83 c4 1c             	add    $0x1c,%esp
  8036b2:	5b                   	pop    %ebx
  8036b3:	5e                   	pop    %esi
  8036b4:	5f                   	pop    %edi
  8036b5:	5d                   	pop    %ebp
  8036b6:	c3                   	ret    
  8036b7:	90                   	nop
  8036b8:	89 fd                	mov    %edi,%ebp
  8036ba:	85 ff                	test   %edi,%edi
  8036bc:	75 0b                	jne    8036c9 <__umoddi3+0xe9>
  8036be:	b8 01 00 00 00       	mov    $0x1,%eax
  8036c3:	31 d2                	xor    %edx,%edx
  8036c5:	f7 f7                	div    %edi
  8036c7:	89 c5                	mov    %eax,%ebp
  8036c9:	89 f0                	mov    %esi,%eax
  8036cb:	31 d2                	xor    %edx,%edx
  8036cd:	f7 f5                	div    %ebp
  8036cf:	89 c8                	mov    %ecx,%eax
  8036d1:	f7 f5                	div    %ebp
  8036d3:	89 d0                	mov    %edx,%eax
  8036d5:	e9 44 ff ff ff       	jmp    80361e <__umoddi3+0x3e>
  8036da:	66 90                	xchg   %ax,%ax
  8036dc:	89 c8                	mov    %ecx,%eax
  8036de:	89 f2                	mov    %esi,%edx
  8036e0:	83 c4 1c             	add    $0x1c,%esp
  8036e3:	5b                   	pop    %ebx
  8036e4:	5e                   	pop    %esi
  8036e5:	5f                   	pop    %edi
  8036e6:	5d                   	pop    %ebp
  8036e7:	c3                   	ret    
  8036e8:	3b 04 24             	cmp    (%esp),%eax
  8036eb:	72 06                	jb     8036f3 <__umoddi3+0x113>
  8036ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036f1:	77 0f                	ja     803702 <__umoddi3+0x122>
  8036f3:	89 f2                	mov    %esi,%edx
  8036f5:	29 f9                	sub    %edi,%ecx
  8036f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036fb:	89 14 24             	mov    %edx,(%esp)
  8036fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803702:	8b 44 24 04          	mov    0x4(%esp),%eax
  803706:	8b 14 24             	mov    (%esp),%edx
  803709:	83 c4 1c             	add    $0x1c,%esp
  80370c:	5b                   	pop    %ebx
  80370d:	5e                   	pop    %esi
  80370e:	5f                   	pop    %edi
  80370f:	5d                   	pop    %ebp
  803710:	c3                   	ret    
  803711:	8d 76 00             	lea    0x0(%esi),%esi
  803714:	2b 04 24             	sub    (%esp),%eax
  803717:	19 fa                	sbb    %edi,%edx
  803719:	89 d1                	mov    %edx,%ecx
  80371b:	89 c6                	mov    %eax,%esi
  80371d:	e9 71 ff ff ff       	jmp    803693 <__umoddi3+0xb3>
  803722:	66 90                	xchg   %ax,%ax
  803724:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803728:	72 ea                	jb     803714 <__umoddi3+0x134>
  80372a:	89 d9                	mov    %ebx,%ecx
  80372c:	e9 62 ff ff ff       	jmp    803693 <__umoddi3+0xb3>
