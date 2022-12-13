
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
  80008c:	68 e0 37 80 00       	push   $0x8037e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 37 80 00       	push   $0x8037fc
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
  8000ad:	68 14 38 80 00       	push   $0x803814
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 48 38 80 00       	push   $0x803848
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 a4 38 80 00       	push   $0x8038a4
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 d8 38 80 00       	push   $0x8038d8
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 20 39 80 00       	push   $0x803920
  8000f9:	e8 cf 15 00 00       	call   8016cd <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 96 18 00 00       	call   80199f <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 20 39 80 00       	push   $0x803920
  80011b:	e8 ad 15 00 00       	call   8016cd <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 24 39 80 00       	push   $0x803924
  800134:	6a 24                	push   $0x24
  800136:	68 fc 37 80 00       	push   $0x8037fc
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 5a 18 00 00       	call   80199f <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 78 39 80 00       	push   $0x803978
  800156:	6a 25                	push   $0x25
  800158:	68 fc 37 80 00       	push   $0x8037fc
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 d4 39 80 00       	push   $0x8039d4
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 28 18 00 00       	call   80199f <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 2c 3a 80 00       	push   $0x803a2c
  80018e:	e8 3a 15 00 00       	call   8016cd <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 30 3a 80 00       	push   $0x803a30
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 fc 37 80 00       	push   $0x8037fc
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 e7 17 00 00       	call   80199f <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 a4 3a 80 00       	push   $0x803aa4
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 fc 37 80 00       	push   $0x8037fc
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 18 3b 80 00       	push   $0x803b18
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 0e 1a 00 00       	call   801bf8 <sys_getMaxShares>
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
  800227:	68 8c 3b 80 00       	push   $0x803b8c
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 fc 37 80 00       	push   $0x8037fc
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
  80024f:	68 bc 3b 80 00       	push   $0x803bbc
  800254:	e8 74 14 00 00       	call   8016cd <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 94 19 00 00       	call   801bf8 <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 c8 3b 80 00       	push   $0x803bc8
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 fc 37 80 00       	push   $0x8037fc
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
  80029c:	68 44 3c 80 00       	push   $0x803c44
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 fc 37 80 00       	push   $0x8037fc
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 d0 3c 80 00       	push   $0x803cd0
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
  8002c6:	e8 b4 19 00 00       	call   801c7f <sys_getenvindex>
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
  800331:	e8 56 17 00 00       	call   801a8c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 48 3d 80 00       	push   $0x803d48
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
  800361:	68 70 3d 80 00       	push   $0x803d70
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
  800392:	68 98 3d 80 00       	push   $0x803d98
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 f0 3d 80 00       	push   $0x803df0
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 48 3d 80 00       	push   $0x803d48
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 d6 16 00 00       	call   801aa6 <sys_enable_interrupt>

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
  8003e3:	e8 63 18 00 00       	call   801c4b <sys_destroy_env>
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
  8003f4:	e8 b8 18 00 00       	call   801cb1 <sys_exit_env>
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
  80041d:	68 04 3e 80 00       	push   $0x803e04
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 09 3e 80 00       	push   $0x803e09
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
  80045a:	68 25 3e 80 00       	push   $0x803e25
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
  800486:	68 28 3e 80 00       	push   $0x803e28
  80048b:	6a 26                	push   $0x26
  80048d:	68 74 3e 80 00       	push   $0x803e74
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
  800558:	68 80 3e 80 00       	push   $0x803e80
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 74 3e 80 00       	push   $0x803e74
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
  8005c8:	68 d4 3e 80 00       	push   $0x803ed4
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 74 3e 80 00       	push   $0x803e74
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
  800622:	e8 b7 12 00 00       	call   8018de <sys_cputs>
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
  800699:	e8 40 12 00 00       	call   8018de <sys_cputs>
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
  8006e3:	e8 a4 13 00 00       	call   801a8c <sys_disable_interrupt>
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
  800703:	e8 9e 13 00 00       	call   801aa6 <sys_enable_interrupt>
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
  80074d:	e8 12 2e 00 00       	call   803564 <__udivdi3>
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
  80079d:	e8 d2 2e 00 00       	call   803674 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 34 41 80 00       	add    $0x804134,%eax
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
  8008f8:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
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
  8009d9:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 45 41 80 00       	push   $0x804145
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
  8009fe:	68 4e 41 80 00       	push   $0x80414e
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
  800a2b:	be 51 41 80 00       	mov    $0x804151,%esi
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
  801451:	68 b0 42 80 00       	push   $0x8042b0
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
  801521:	e8 fc 04 00 00       	call   801a22 <sys_allocate_chunk>
  801526:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801529:	a1 20 51 80 00       	mov    0x805120,%eax
  80152e:	83 ec 0c             	sub    $0xc,%esp
  801531:	50                   	push   %eax
  801532:	e8 71 0b 00 00       	call   8020a8 <initialize_MemBlocksList>
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
  80155f:	68 d5 42 80 00       	push   $0x8042d5
  801564:	6a 33                	push   $0x33
  801566:	68 f3 42 80 00       	push   $0x8042f3
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
  8015de:	68 00 43 80 00       	push   $0x804300
  8015e3:	6a 34                	push   $0x34
  8015e5:	68 f3 42 80 00       	push   $0x8042f3
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
  801676:	e8 75 07 00 00       	call   801df0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80167b:	85 c0                	test   %eax,%eax
  80167d:	74 11                	je     801690 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	ff 75 e8             	pushl  -0x18(%ebp)
  801685:	e8 e0 0d 00 00       	call   80246a <alloc_block_FF>
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
  80169c:	e8 3c 0b 00 00       	call   8021dd <insert_sorted_allocList>
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
  8016bc:	68 24 43 80 00       	push   $0x804324
  8016c1:	6a 6f                	push   $0x6f
  8016c3:	68 f3 42 80 00       	push   $0x8042f3
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
  8016e2:	75 0a                	jne    8016ee <smalloc+0x21>
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	e9 8b 00 00 00       	jmp    801779 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016ee:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fb:	01 d0                	add    %edx,%eax
  8016fd:	48                   	dec    %eax
  8016fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801704:	ba 00 00 00 00       	mov    $0x0,%edx
  801709:	f7 75 f0             	divl   -0x10(%ebp)
  80170c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170f:	29 d0                	sub    %edx,%eax
  801711:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801714:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80171b:	e8 d0 06 00 00       	call   801df0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801720:	85 c0                	test   %eax,%eax
  801722:	74 11                	je     801735 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801724:	83 ec 0c             	sub    $0xc,%esp
  801727:	ff 75 e8             	pushl  -0x18(%ebp)
  80172a:	e8 3b 0d 00 00       	call   80246a <alloc_block_FF>
  80172f:	83 c4 10             	add    $0x10,%esp
  801732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801735:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801739:	74 39                	je     801774 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173e:	8b 40 08             	mov    0x8(%eax),%eax
  801741:	89 c2                	mov    %eax,%edx
  801743:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801747:	52                   	push   %edx
  801748:	50                   	push   %eax
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	ff 75 08             	pushl  0x8(%ebp)
  80174f:	e8 21 04 00 00       	call   801b75 <sys_createSharedObject>
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80175a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80175e:	74 14                	je     801774 <smalloc+0xa7>
  801760:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801764:	74 0e                	je     801774 <smalloc+0xa7>
  801766:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80176a:	74 08                	je     801774 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176f:	8b 40 08             	mov    0x8(%eax),%eax
  801772:	eb 05                	jmp    801779 <smalloc+0xac>
	}
	return NULL;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801781:	e8 b4 fc ff ff       	call   80143a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801786:	83 ec 08             	sub    $0x8,%esp
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	e8 0b 04 00 00       	call   801b9f <sys_getSizeOfSharedObject>
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80179a:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80179e:	74 76                	je     801816 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017a0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ad:	01 d0                	add    %edx,%eax
  8017af:	48                   	dec    %eax
  8017b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bb:	f7 75 ec             	divl   -0x14(%ebp)
  8017be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c1:	29 d0                	sub    %edx,%eax
  8017c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8017c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017cd:	e8 1e 06 00 00       	call   801df0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 11                	je     8017e7 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017dc:	e8 89 0c 00 00       	call   80246a <alloc_block_FF>
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8017e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017eb:	74 29                	je     801816 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8017ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f0:	8b 40 08             	mov    0x8(%eax),%eax
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	50                   	push   %eax
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	ff 75 08             	pushl  0x8(%ebp)
  8017fd:	e8 ba 03 00 00       	call   801bbc <sys_getSharedObject>
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801808:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80180c:	74 08                	je     801816 <sget+0x9b>
				return (void *)mem_block->sva;
  80180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801811:	8b 40 08             	mov    0x8(%eax),%eax
  801814:	eb 05                	jmp    80181b <sget+0xa0>
		}
	}
	return (void *)NULL;
  801816:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801823:	e8 12 fc ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801828:	83 ec 04             	sub    $0x4,%esp
  80182b:	68 48 43 80 00       	push   $0x804348
  801830:	68 f1 00 00 00       	push   $0xf1
  801835:	68 f3 42 80 00       	push   $0x8042f3
  80183a:	e8 bd eb ff ff       	call   8003fc <_panic>

0080183f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	68 70 43 80 00       	push   $0x804370
  80184d:	68 05 01 00 00       	push   $0x105
  801852:	68 f3 42 80 00       	push   $0x8042f3
  801857:	e8 a0 eb ff ff       	call   8003fc <_panic>

0080185c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	68 94 43 80 00       	push   $0x804394
  80186a:	68 10 01 00 00       	push   $0x110
  80186f:	68 f3 42 80 00       	push   $0x8042f3
  801874:	e8 83 eb ff ff       	call   8003fc <_panic>

00801879 <shrink>:

}
void shrink(uint32 newSize)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	68 94 43 80 00       	push   $0x804394
  801887:	68 15 01 00 00       	push   $0x115
  80188c:	68 f3 42 80 00       	push   $0x8042f3
  801891:	e8 66 eb ff ff       	call   8003fc <_panic>

00801896 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189c:	83 ec 04             	sub    $0x4,%esp
  80189f:	68 94 43 80 00       	push   $0x804394
  8018a4:	68 1a 01 00 00       	push   $0x11a
  8018a9:	68 f3 42 80 00       	push   $0x8042f3
  8018ae:	e8 49 eb ff ff       	call   8003fc <_panic>

008018b3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	57                   	push   %edi
  8018b7:	56                   	push   %esi
  8018b8:	53                   	push   %ebx
  8018b9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018cb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ce:	cd 30                	int    $0x30
  8018d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	5b                   	pop    %ebx
  8018da:	5e                   	pop    %esi
  8018db:	5f                   	pop    %edi
  8018dc:	5d                   	pop    %ebp
  8018dd:	c3                   	ret    

008018de <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 04             	sub    $0x4,%esp
  8018e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	52                   	push   %edx
  8018f6:	ff 75 0c             	pushl  0xc(%ebp)
  8018f9:	50                   	push   %eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	e8 b2 ff ff ff       	call   8018b3 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	90                   	nop
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_cgetc>:

int
sys_cgetc(void)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 01                	push   $0x1
  801916:	e8 98 ff ff ff       	call   8018b3 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	52                   	push   %edx
  801930:	50                   	push   %eax
  801931:	6a 05                	push   $0x5
  801933:	e8 7b ff ff ff       	call   8018b3 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801942:	8b 75 18             	mov    0x18(%ebp),%esi
  801945:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801948:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	56                   	push   %esi
  801952:	53                   	push   %ebx
  801953:	51                   	push   %ecx
  801954:	52                   	push   %edx
  801955:	50                   	push   %eax
  801956:	6a 06                	push   $0x6
  801958:	e8 56 ff ff ff       	call   8018b3 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    

00801967 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80196a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	52                   	push   %edx
  801977:	50                   	push   %eax
  801978:	6a 07                	push   $0x7
  80197a:	e8 34 ff ff ff       	call   8018b3 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	6a 08                	push   $0x8
  801995:	e8 19 ff ff ff       	call   8018b3 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 09                	push   $0x9
  8019ae:	e8 00 ff ff ff       	call   8018b3 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 0a                	push   $0xa
  8019c7:	e8 e7 fe ff ff       	call   8018b3 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 0b                	push   $0xb
  8019e0:	e8 ce fe ff ff       	call   8018b3 <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	ff 75 08             	pushl  0x8(%ebp)
  8019f9:	6a 0f                	push   $0xf
  8019fb:	e8 b3 fe ff ff       	call   8018b3 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
	return;
  801a03:	90                   	nop
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	ff 75 08             	pushl  0x8(%ebp)
  801a15:	6a 10                	push   $0x10
  801a17:	e8 97 fe ff ff       	call   8018b3 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1f:	90                   	nop
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	ff 75 10             	pushl  0x10(%ebp)
  801a2c:	ff 75 0c             	pushl  0xc(%ebp)
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	6a 11                	push   $0x11
  801a34:	e8 7a fe ff ff       	call   8018b3 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3c:	90                   	nop
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 0c                	push   $0xc
  801a4e:	e8 60 fe ff ff       	call   8018b3 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	6a 0d                	push   $0xd
  801a68:	e8 46 fe ff ff       	call   8018b3 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 0e                	push   $0xe
  801a81:	e8 2d fe ff ff       	call   8018b3 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	90                   	nop
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 13                	push   $0x13
  801a9b:	e8 13 fe ff ff       	call   8018b3 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 14                	push   $0x14
  801ab5:	e8 f9 fd ff ff       	call   8018b3 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	90                   	nop
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801acc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	50                   	push   %eax
  801ad9:	6a 15                	push   $0x15
  801adb:	e8 d3 fd ff ff       	call   8018b3 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	90                   	nop
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 16                	push   $0x16
  801af5:	e8 b9 fd ff ff       	call   8018b3 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	90                   	nop
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	ff 75 0c             	pushl  0xc(%ebp)
  801b0f:	50                   	push   %eax
  801b10:	6a 17                	push   $0x17
  801b12:	e8 9c fd ff ff       	call   8018b3 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	52                   	push   %edx
  801b2c:	50                   	push   %eax
  801b2d:	6a 1a                	push   $0x1a
  801b2f:	e8 7f fd ff ff       	call   8018b3 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 18                	push   $0x18
  801b4c:	e8 62 fd ff ff       	call   8018b3 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	52                   	push   %edx
  801b67:	50                   	push   %eax
  801b68:	6a 19                	push   $0x19
  801b6a:	e8 44 fd ff ff       	call   8018b3 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	90                   	nop
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b81:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b84:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	51                   	push   %ecx
  801b8e:	52                   	push   %edx
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	50                   	push   %eax
  801b93:	6a 1b                	push   $0x1b
  801b95:	e8 19 fd ff ff       	call   8018b3 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	52                   	push   %edx
  801baf:	50                   	push   %eax
  801bb0:	6a 1c                	push   $0x1c
  801bb2:	e8 fc fc ff ff       	call   8018b3 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bbf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	51                   	push   %ecx
  801bcd:	52                   	push   %edx
  801bce:	50                   	push   %eax
  801bcf:	6a 1d                	push   $0x1d
  801bd1:	e8 dd fc ff ff       	call   8018b3 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	52                   	push   %edx
  801beb:	50                   	push   %eax
  801bec:	6a 1e                	push   $0x1e
  801bee:	e8 c0 fc ff ff       	call   8018b3 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 1f                	push   $0x1f
  801c07:	e8 a7 fc ff ff       	call   8018b3 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	6a 00                	push   $0x0
  801c19:	ff 75 14             	pushl  0x14(%ebp)
  801c1c:	ff 75 10             	pushl  0x10(%ebp)
  801c1f:	ff 75 0c             	pushl  0xc(%ebp)
  801c22:	50                   	push   %eax
  801c23:	6a 20                	push   $0x20
  801c25:	e8 89 fc ff ff       	call   8018b3 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	50                   	push   %eax
  801c3e:	6a 21                	push   $0x21
  801c40:	e8 6e fc ff ff       	call   8018b3 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	90                   	nop
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	50                   	push   %eax
  801c5a:	6a 22                	push   $0x22
  801c5c:	e8 52 fc ff ff       	call   8018b3 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 02                	push   $0x2
  801c75:	e8 39 fc ff ff       	call   8018b3 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 03                	push   $0x3
  801c8e:	e8 20 fc ff ff       	call   8018b3 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 04                	push   $0x4
  801ca7:	e8 07 fc ff ff       	call   8018b3 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_exit_env>:


void sys_exit_env(void)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 23                	push   $0x23
  801cc0:	e8 ee fb ff ff       	call   8018b3 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	90                   	nop
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cd1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd4:	8d 50 04             	lea    0x4(%eax),%edx
  801cd7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	52                   	push   %edx
  801ce1:	50                   	push   %eax
  801ce2:	6a 24                	push   $0x24
  801ce4:	e8 ca fb ff ff       	call   8018b3 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
	return result;
  801cec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cf5:	89 01                	mov    %eax,(%ecx)
  801cf7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	c9                   	leave  
  801cfe:	c2 04 00             	ret    $0x4

00801d01 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	ff 75 10             	pushl  0x10(%ebp)
  801d0b:	ff 75 0c             	pushl  0xc(%ebp)
  801d0e:	ff 75 08             	pushl  0x8(%ebp)
  801d11:	6a 12                	push   $0x12
  801d13:	e8 9b fb ff ff       	call   8018b3 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1b:	90                   	nop
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_rcr2>:
uint32 sys_rcr2()
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 25                	push   $0x25
  801d2d:	e8 81 fb ff ff       	call   8018b3 <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 04             	sub    $0x4,%esp
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d43:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	50                   	push   %eax
  801d50:	6a 26                	push   $0x26
  801d52:	e8 5c fb ff ff       	call   8018b3 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5a:	90                   	nop
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <rsttst>:
void rsttst()
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 28                	push   $0x28
  801d6c:	e8 42 fb ff ff       	call   8018b3 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
	return ;
  801d74:	90                   	nop
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 04             	sub    $0x4,%esp
  801d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d83:	8b 55 18             	mov    0x18(%ebp),%edx
  801d86:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8a:	52                   	push   %edx
  801d8b:	50                   	push   %eax
  801d8c:	ff 75 10             	pushl  0x10(%ebp)
  801d8f:	ff 75 0c             	pushl  0xc(%ebp)
  801d92:	ff 75 08             	pushl  0x8(%ebp)
  801d95:	6a 27                	push   $0x27
  801d97:	e8 17 fb ff ff       	call   8018b3 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9f:	90                   	nop
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <chktst>:
void chktst(uint32 n)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	ff 75 08             	pushl  0x8(%ebp)
  801db0:	6a 29                	push   $0x29
  801db2:	e8 fc fa ff ff       	call   8018b3 <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dba:	90                   	nop
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <inctst>:

void inctst()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 2a                	push   $0x2a
  801dcc:	e8 e2 fa ff ff       	call   8018b3 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd4:	90                   	nop
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <gettst>:
uint32 gettst()
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 2b                	push   $0x2b
  801de6:	e8 c8 fa ff ff       	call   8018b3 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 2c                	push   $0x2c
  801e02:	e8 ac fa ff ff       	call   8018b3 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
  801e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e0d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e11:	75 07                	jne    801e1a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e13:	b8 01 00 00 00       	mov    $0x1,%eax
  801e18:	eb 05                	jmp    801e1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 2c                	push   $0x2c
  801e33:	e8 7b fa ff ff       	call   8018b3 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
  801e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e3e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e42:	75 07                	jne    801e4b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e44:	b8 01 00 00 00       	mov    $0x1,%eax
  801e49:	eb 05                	jmp    801e50 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 2c                	push   $0x2c
  801e64:	e8 4a fa ff ff       	call   8018b3 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
  801e6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e6f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e73:	75 07                	jne    801e7c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e75:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7a:	eb 05                	jmp    801e81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 2c                	push   $0x2c
  801e95:	e8 19 fa ff ff       	call   8018b3 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
  801e9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ea0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ea4:	75 07                	jne    801ead <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eab:	eb 05                	jmp    801eb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	ff 75 08             	pushl  0x8(%ebp)
  801ec2:	6a 2d                	push   $0x2d
  801ec4:	e8 ea f9 ff ff       	call   8018b3 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecc:	90                   	nop
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ed3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	6a 00                	push   $0x0
  801ee1:	53                   	push   %ebx
  801ee2:	51                   	push   %ecx
  801ee3:	52                   	push   %edx
  801ee4:	50                   	push   %eax
  801ee5:	6a 2e                	push   $0x2e
  801ee7:	e8 c7 f9 ff ff       	call   8018b3 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ef7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	52                   	push   %edx
  801f04:	50                   	push   %eax
  801f05:	6a 2f                	push   $0x2f
  801f07:	e8 a7 f9 ff ff       	call   8018b3 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f17:	83 ec 0c             	sub    $0xc,%esp
  801f1a:	68 a4 43 80 00       	push   $0x8043a4
  801f1f:	e8 8c e7 ff ff       	call   8006b0 <cprintf>
  801f24:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f27:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f2e:	83 ec 0c             	sub    $0xc,%esp
  801f31:	68 d0 43 80 00       	push   $0x8043d0
  801f36:	e8 75 e7 ff ff       	call   8006b0 <cprintf>
  801f3b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f3e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f42:	a1 38 51 80 00       	mov    0x805138,%eax
  801f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4a:	eb 56                	jmp    801fa2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f50:	74 1c                	je     801f6e <print_mem_block_lists+0x5d>
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 50 08             	mov    0x8(%eax),%edx
  801f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5b:	8b 48 08             	mov    0x8(%eax),%ecx
  801f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f61:	8b 40 0c             	mov    0xc(%eax),%eax
  801f64:	01 c8                	add    %ecx,%eax
  801f66:	39 c2                	cmp    %eax,%edx
  801f68:	73 04                	jae    801f6e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f6a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	8b 50 08             	mov    0x8(%eax),%edx
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7a:	01 c2                	add    %eax,%edx
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	8b 40 08             	mov    0x8(%eax),%eax
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	52                   	push   %edx
  801f86:	50                   	push   %eax
  801f87:	68 e5 43 80 00       	push   $0x8043e5
  801f8c:	e8 1f e7 ff ff       	call   8006b0 <cprintf>
  801f91:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f9a:	a1 40 51 80 00       	mov    0x805140,%eax
  801f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa6:	74 07                	je     801faf <print_mem_block_lists+0x9e>
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	8b 00                	mov    (%eax),%eax
  801fad:	eb 05                	jmp    801fb4 <print_mem_block_lists+0xa3>
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	a3 40 51 80 00       	mov    %eax,0x805140
  801fb9:	a1 40 51 80 00       	mov    0x805140,%eax
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	75 8a                	jne    801f4c <print_mem_block_lists+0x3b>
  801fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc6:	75 84                	jne    801f4c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fc8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fcc:	75 10                	jne    801fde <print_mem_block_lists+0xcd>
  801fce:	83 ec 0c             	sub    $0xc,%esp
  801fd1:	68 f4 43 80 00       	push   $0x8043f4
  801fd6:	e8 d5 e6 ff ff       	call   8006b0 <cprintf>
  801fdb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fde:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	68 18 44 80 00       	push   $0x804418
  801fed:	e8 be e6 ff ff       	call   8006b0 <cprintf>
  801ff2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ff5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ff9:	a1 40 50 80 00       	mov    0x805040,%eax
  801ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802001:	eb 56                	jmp    802059 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802003:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802007:	74 1c                	je     802025 <print_mem_block_lists+0x114>
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 50 08             	mov    0x8(%eax),%edx
  80200f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802012:	8b 48 08             	mov    0x8(%eax),%ecx
  802015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802018:	8b 40 0c             	mov    0xc(%eax),%eax
  80201b:	01 c8                	add    %ecx,%eax
  80201d:	39 c2                	cmp    %eax,%edx
  80201f:	73 04                	jae    802025 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802021:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802028:	8b 50 08             	mov    0x8(%eax),%edx
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	8b 40 0c             	mov    0xc(%eax),%eax
  802031:	01 c2                	add    %eax,%edx
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	8b 40 08             	mov    0x8(%eax),%eax
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	52                   	push   %edx
  80203d:	50                   	push   %eax
  80203e:	68 e5 43 80 00       	push   $0x8043e5
  802043:	e8 68 e6 ff ff       	call   8006b0 <cprintf>
  802048:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802051:	a1 48 50 80 00       	mov    0x805048,%eax
  802056:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802059:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205d:	74 07                	je     802066 <print_mem_block_lists+0x155>
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	8b 00                	mov    (%eax),%eax
  802064:	eb 05                	jmp    80206b <print_mem_block_lists+0x15a>
  802066:	b8 00 00 00 00       	mov    $0x0,%eax
  80206b:	a3 48 50 80 00       	mov    %eax,0x805048
  802070:	a1 48 50 80 00       	mov    0x805048,%eax
  802075:	85 c0                	test   %eax,%eax
  802077:	75 8a                	jne    802003 <print_mem_block_lists+0xf2>
  802079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207d:	75 84                	jne    802003 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80207f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802083:	75 10                	jne    802095 <print_mem_block_lists+0x184>
  802085:	83 ec 0c             	sub    $0xc,%esp
  802088:	68 30 44 80 00       	push   $0x804430
  80208d:	e8 1e e6 ff ff       	call   8006b0 <cprintf>
  802092:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802095:	83 ec 0c             	sub    $0xc,%esp
  802098:	68 a4 43 80 00       	push   $0x8043a4
  80209d:	e8 0e e6 ff ff       	call   8006b0 <cprintf>
  8020a2:	83 c4 10             	add    $0x10,%esp

}
  8020a5:	90                   	nop
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020ae:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020b5:	00 00 00 
  8020b8:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020bf:	00 00 00 
  8020c2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020c9:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020d3:	e9 9e 00 00 00       	jmp    802176 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020d8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e0:	c1 e2 04             	shl    $0x4,%edx
  8020e3:	01 d0                	add    %edx,%eax
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	75 14                	jne    8020fd <initialize_MemBlocksList+0x55>
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	68 58 44 80 00       	push   $0x804458
  8020f1:	6a 46                	push   $0x46
  8020f3:	68 7b 44 80 00       	push   $0x80447b
  8020f8:	e8 ff e2 ff ff       	call   8003fc <_panic>
  8020fd:	a1 50 50 80 00       	mov    0x805050,%eax
  802102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802105:	c1 e2 04             	shl    $0x4,%edx
  802108:	01 d0                	add    %edx,%eax
  80210a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802110:	89 10                	mov    %edx,(%eax)
  802112:	8b 00                	mov    (%eax),%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	74 18                	je     802130 <initialize_MemBlocksList+0x88>
  802118:	a1 48 51 80 00       	mov    0x805148,%eax
  80211d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802123:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802126:	c1 e1 04             	shl    $0x4,%ecx
  802129:	01 ca                	add    %ecx,%edx
  80212b:	89 50 04             	mov    %edx,0x4(%eax)
  80212e:	eb 12                	jmp    802142 <initialize_MemBlocksList+0x9a>
  802130:	a1 50 50 80 00       	mov    0x805050,%eax
  802135:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802138:	c1 e2 04             	shl    $0x4,%edx
  80213b:	01 d0                	add    %edx,%eax
  80213d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802142:	a1 50 50 80 00       	mov    0x805050,%eax
  802147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214a:	c1 e2 04             	shl    $0x4,%edx
  80214d:	01 d0                	add    %edx,%eax
  80214f:	a3 48 51 80 00       	mov    %eax,0x805148
  802154:	a1 50 50 80 00       	mov    0x805050,%eax
  802159:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215c:	c1 e2 04             	shl    $0x4,%edx
  80215f:	01 d0                	add    %edx,%eax
  802161:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802168:	a1 54 51 80 00       	mov    0x805154,%eax
  80216d:	40                   	inc    %eax
  80216e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802173:	ff 45 f4             	incl   -0xc(%ebp)
  802176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802179:	3b 45 08             	cmp    0x8(%ebp),%eax
  80217c:	0f 82 56 ff ff ff    	jb     8020d8 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802182:	90                   	nop
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	8b 00                	mov    (%eax),%eax
  802190:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802193:	eb 19                	jmp    8021ae <find_block+0x29>
	{
		if(va==point->sva)
  802195:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802198:	8b 40 08             	mov    0x8(%eax),%eax
  80219b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80219e:	75 05                	jne    8021a5 <find_block+0x20>
		   return point;
  8021a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a3:	eb 36                	jmp    8021db <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	8b 40 08             	mov    0x8(%eax),%eax
  8021ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b2:	74 07                	je     8021bb <find_block+0x36>
  8021b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	eb 05                	jmp    8021c0 <find_block+0x3b>
  8021bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c3:	89 42 08             	mov    %eax,0x8(%edx)
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	8b 40 08             	mov    0x8(%eax),%eax
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	75 c5                	jne    802195 <find_block+0x10>
  8021d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d4:	75 bf                	jne    802195 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021e3:	a1 40 50 80 00       	mov    0x805040,%eax
  8021e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021eb:	a1 44 50 80 00       	mov    0x805044,%eax
  8021f0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021f9:	74 24                	je     80221f <insert_sorted_allocList+0x42>
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	8b 50 08             	mov    0x8(%eax),%edx
  802201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802204:	8b 40 08             	mov    0x8(%eax),%eax
  802207:	39 c2                	cmp    %eax,%edx
  802209:	76 14                	jbe    80221f <insert_sorted_allocList+0x42>
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	8b 50 08             	mov    0x8(%eax),%edx
  802211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802214:	8b 40 08             	mov    0x8(%eax),%eax
  802217:	39 c2                	cmp    %eax,%edx
  802219:	0f 82 60 01 00 00    	jb     80237f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80221f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802223:	75 65                	jne    80228a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802225:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802229:	75 14                	jne    80223f <insert_sorted_allocList+0x62>
  80222b:	83 ec 04             	sub    $0x4,%esp
  80222e:	68 58 44 80 00       	push   $0x804458
  802233:	6a 6b                	push   $0x6b
  802235:	68 7b 44 80 00       	push   $0x80447b
  80223a:	e8 bd e1 ff ff       	call   8003fc <_panic>
  80223f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	89 10                	mov    %edx,(%eax)
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	85 c0                	test   %eax,%eax
  802251:	74 0d                	je     802260 <insert_sorted_allocList+0x83>
  802253:	a1 40 50 80 00       	mov    0x805040,%eax
  802258:	8b 55 08             	mov    0x8(%ebp),%edx
  80225b:	89 50 04             	mov    %edx,0x4(%eax)
  80225e:	eb 08                	jmp    802268 <insert_sorted_allocList+0x8b>
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	a3 44 50 80 00       	mov    %eax,0x805044
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	a3 40 50 80 00       	mov    %eax,0x805040
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80227f:	40                   	inc    %eax
  802280:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802285:	e9 dc 01 00 00       	jmp    802466 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	8b 50 08             	mov    0x8(%eax),%edx
  802290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802293:	8b 40 08             	mov    0x8(%eax),%eax
  802296:	39 c2                	cmp    %eax,%edx
  802298:	77 6c                	ja     802306 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80229a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80229e:	74 06                	je     8022a6 <insert_sorted_allocList+0xc9>
  8022a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a4:	75 14                	jne    8022ba <insert_sorted_allocList+0xdd>
  8022a6:	83 ec 04             	sub    $0x4,%esp
  8022a9:	68 94 44 80 00       	push   $0x804494
  8022ae:	6a 6f                	push   $0x6f
  8022b0:	68 7b 44 80 00       	push   $0x80447b
  8022b5:	e8 42 e1 ff ff       	call   8003fc <_panic>
  8022ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bd:	8b 50 04             	mov    0x4(%eax),%edx
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022cc:	89 10                	mov    %edx,(%eax)
  8022ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d1:	8b 40 04             	mov    0x4(%eax),%eax
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	74 0d                	je     8022e5 <insert_sorted_allocList+0x108>
  8022d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e1:	89 10                	mov    %edx,(%eax)
  8022e3:	eb 08                	jmp    8022ed <insert_sorted_allocList+0x110>
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	a3 40 50 80 00       	mov    %eax,0x805040
  8022ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f3:	89 50 04             	mov    %edx,0x4(%eax)
  8022f6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022fb:	40                   	inc    %eax
  8022fc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802301:	e9 60 01 00 00       	jmp    802466 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	8b 50 08             	mov    0x8(%eax),%edx
  80230c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230f:	8b 40 08             	mov    0x8(%eax),%eax
  802312:	39 c2                	cmp    %eax,%edx
  802314:	0f 82 4c 01 00 00    	jb     802466 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80231a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80231e:	75 14                	jne    802334 <insert_sorted_allocList+0x157>
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	68 cc 44 80 00       	push   $0x8044cc
  802328:	6a 73                	push   $0x73
  80232a:	68 7b 44 80 00       	push   $0x80447b
  80232f:	e8 c8 e0 ff ff       	call   8003fc <_panic>
  802334:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	89 50 04             	mov    %edx,0x4(%eax)
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	8b 40 04             	mov    0x4(%eax),%eax
  802346:	85 c0                	test   %eax,%eax
  802348:	74 0c                	je     802356 <insert_sorted_allocList+0x179>
  80234a:	a1 44 50 80 00       	mov    0x805044,%eax
  80234f:	8b 55 08             	mov    0x8(%ebp),%edx
  802352:	89 10                	mov    %edx,(%eax)
  802354:	eb 08                	jmp    80235e <insert_sorted_allocList+0x181>
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	a3 40 50 80 00       	mov    %eax,0x805040
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	a3 44 50 80 00       	mov    %eax,0x805044
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802374:	40                   	inc    %eax
  802375:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80237a:	e9 e7 00 00 00       	jmp    802466 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80237f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802382:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802385:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80238c:	a1 40 50 80 00       	mov    0x805040,%eax
  802391:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802394:	e9 9d 00 00 00       	jmp    802436 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	8b 50 08             	mov    0x8(%eax),%edx
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 40 08             	mov    0x8(%eax),%eax
  8023ad:	39 c2                	cmp    %eax,%edx
  8023af:	76 7d                	jbe    80242e <insert_sorted_allocList+0x251>
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	8b 50 08             	mov    0x8(%eax),%edx
  8023b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ba:	8b 40 08             	mov    0x8(%eax),%eax
  8023bd:	39 c2                	cmp    %eax,%edx
  8023bf:	73 6d                	jae    80242e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c5:	74 06                	je     8023cd <insert_sorted_allocList+0x1f0>
  8023c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023cb:	75 14                	jne    8023e1 <insert_sorted_allocList+0x204>
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	68 f0 44 80 00       	push   $0x8044f0
  8023d5:	6a 7f                	push   $0x7f
  8023d7:	68 7b 44 80 00       	push   $0x80447b
  8023dc:	e8 1b e0 ff ff       	call   8003fc <_panic>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 10                	mov    (%eax),%edx
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	89 10                	mov    %edx,(%eax)
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	74 0b                	je     8023ff <insert_sorted_allocList+0x222>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fc:	89 50 04             	mov    %edx,0x4(%eax)
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 55 08             	mov    0x8(%ebp),%edx
  802405:	89 10                	mov    %edx,(%eax)
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240d:	89 50 04             	mov    %edx,0x4(%eax)
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	85 c0                	test   %eax,%eax
  802417:	75 08                	jne    802421 <insert_sorted_allocList+0x244>
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	a3 44 50 80 00       	mov    %eax,0x805044
  802421:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802426:	40                   	inc    %eax
  802427:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80242c:	eb 39                	jmp    802467 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80242e:	a1 48 50 80 00       	mov    0x805048,%eax
  802433:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243a:	74 07                	je     802443 <insert_sorted_allocList+0x266>
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 00                	mov    (%eax),%eax
  802441:	eb 05                	jmp    802448 <insert_sorted_allocList+0x26b>
  802443:	b8 00 00 00 00       	mov    $0x0,%eax
  802448:	a3 48 50 80 00       	mov    %eax,0x805048
  80244d:	a1 48 50 80 00       	mov    0x805048,%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	0f 85 3f ff ff ff    	jne    802399 <insert_sorted_allocList+0x1bc>
  80245a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245e:	0f 85 35 ff ff ff    	jne    802399 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802464:	eb 01                	jmp    802467 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802466:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802467:	90                   	nop
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802470:	a1 38 51 80 00       	mov    0x805138,%eax
  802475:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802478:	e9 85 01 00 00       	jmp    802602 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 40 0c             	mov    0xc(%eax),%eax
  802483:	3b 45 08             	cmp    0x8(%ebp),%eax
  802486:	0f 82 6e 01 00 00    	jb     8025fa <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 40 0c             	mov    0xc(%eax),%eax
  802492:	3b 45 08             	cmp    0x8(%ebp),%eax
  802495:	0f 85 8a 00 00 00    	jne    802525 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80249b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249f:	75 17                	jne    8024b8 <alloc_block_FF+0x4e>
  8024a1:	83 ec 04             	sub    $0x4,%esp
  8024a4:	68 24 45 80 00       	push   $0x804524
  8024a9:	68 93 00 00 00       	push   $0x93
  8024ae:	68 7b 44 80 00       	push   $0x80447b
  8024b3:	e8 44 df ff ff       	call   8003fc <_panic>
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	74 10                	je     8024d1 <alloc_block_FF+0x67>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c9:	8b 52 04             	mov    0x4(%edx),%edx
  8024cc:	89 50 04             	mov    %edx,0x4(%eax)
  8024cf:	eb 0b                	jmp    8024dc <alloc_block_FF+0x72>
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 40 04             	mov    0x4(%eax),%eax
  8024d7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 40 04             	mov    0x4(%eax),%eax
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	74 0f                	je     8024f5 <alloc_block_FF+0x8b>
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ef:	8b 12                	mov    (%edx),%edx
  8024f1:	89 10                	mov    %edx,(%eax)
  8024f3:	eb 0a                	jmp    8024ff <alloc_block_FF+0x95>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802512:	a1 44 51 80 00       	mov    0x805144,%eax
  802517:	48                   	dec    %eax
  802518:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	e9 10 01 00 00       	jmp    802635 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 40 0c             	mov    0xc(%eax),%eax
  80252b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252e:	0f 86 c6 00 00 00    	jbe    8025fa <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802534:	a1 48 51 80 00       	mov    0x805148,%eax
  802539:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 50 08             	mov    0x8(%eax),%edx
  802542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802545:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254b:	8b 55 08             	mov    0x8(%ebp),%edx
  80254e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802551:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802555:	75 17                	jne    80256e <alloc_block_FF+0x104>
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 24 45 80 00       	push   $0x804524
  80255f:	68 9b 00 00 00       	push   $0x9b
  802564:	68 7b 44 80 00       	push   $0x80447b
  802569:	e8 8e de ff ff       	call   8003fc <_panic>
  80256e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802571:	8b 00                	mov    (%eax),%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 10                	je     802587 <alloc_block_FF+0x11d>
  802577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257f:	8b 52 04             	mov    0x4(%edx),%edx
  802582:	89 50 04             	mov    %edx,0x4(%eax)
  802585:	eb 0b                	jmp    802592 <alloc_block_FF+0x128>
  802587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 0f                	je     8025ab <alloc_block_FF+0x141>
  80259c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a5:	8b 12                	mov    (%edx),%edx
  8025a7:	89 10                	mov    %edx,(%eax)
  8025a9:	eb 0a                	jmp    8025b5 <alloc_block_FF+0x14b>
  8025ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8025b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c8:	a1 54 51 80 00       	mov    0x805154,%eax
  8025cd:	48                   	dec    %eax
  8025ce:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 50 08             	mov    0x8(%eax),%edx
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	01 c2                	add    %eax,%edx
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ed:	89 c2                	mov    %eax,%edx
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f8:	eb 3b                	jmp    802635 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802606:	74 07                	je     80260f <alloc_block_FF+0x1a5>
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 00                	mov    (%eax),%eax
  80260d:	eb 05                	jmp    802614 <alloc_block_FF+0x1aa>
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	a3 40 51 80 00       	mov    %eax,0x805140
  802619:	a1 40 51 80 00       	mov    0x805140,%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	0f 85 57 fe ff ff    	jne    80247d <alloc_block_FF+0x13>
  802626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262a:	0f 85 4d fe ff ff    	jne    80247d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802630:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
  80263a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80263d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802644:	a1 38 51 80 00       	mov    0x805138,%eax
  802649:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264c:	e9 df 00 00 00       	jmp    802730 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 0c             	mov    0xc(%eax),%eax
  802657:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265a:	0f 82 c8 00 00 00    	jb     802728 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 0c             	mov    0xc(%eax),%eax
  802666:	3b 45 08             	cmp    0x8(%ebp),%eax
  802669:	0f 85 8a 00 00 00    	jne    8026f9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80266f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802673:	75 17                	jne    80268c <alloc_block_BF+0x55>
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 24 45 80 00       	push   $0x804524
  80267d:	68 b7 00 00 00       	push   $0xb7
  802682:	68 7b 44 80 00       	push   $0x80447b
  802687:	e8 70 dd ff ff       	call   8003fc <_panic>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 10                	je     8026a5 <alloc_block_BF+0x6e>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269d:	8b 52 04             	mov    0x4(%edx),%edx
  8026a0:	89 50 04             	mov    %edx,0x4(%eax)
  8026a3:	eb 0b                	jmp    8026b0 <alloc_block_BF+0x79>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0f                	je     8026c9 <alloc_block_BF+0x92>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c3:	8b 12                	mov    (%edx),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 0a                	jmp    8026d3 <alloc_block_BF+0x9c>
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e6:	a1 44 51 80 00       	mov    0x805144,%eax
  8026eb:	48                   	dec    %eax
  8026ec:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	e9 4d 01 00 00       	jmp    802846 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802702:	76 24                	jbe    802728 <alloc_block_BF+0xf1>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80270d:	73 19                	jae    802728 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80270f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 40 0c             	mov    0xc(%eax),%eax
  80271c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 08             	mov    0x8(%eax),%eax
  802725:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802728:	a1 40 51 80 00       	mov    0x805140,%eax
  80272d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802734:	74 07                	je     80273d <alloc_block_BF+0x106>
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	eb 05                	jmp    802742 <alloc_block_BF+0x10b>
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	a3 40 51 80 00       	mov    %eax,0x805140
  802747:	a1 40 51 80 00       	mov    0x805140,%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	0f 85 fd fe ff ff    	jne    802651 <alloc_block_BF+0x1a>
  802754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802758:	0f 85 f3 fe ff ff    	jne    802651 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80275e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802762:	0f 84 d9 00 00 00    	je     802841 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802768:	a1 48 51 80 00       	mov    0x805148,%eax
  80276d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802773:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802776:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277c:	8b 55 08             	mov    0x8(%ebp),%edx
  80277f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802782:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802786:	75 17                	jne    80279f <alloc_block_BF+0x168>
  802788:	83 ec 04             	sub    $0x4,%esp
  80278b:	68 24 45 80 00       	push   $0x804524
  802790:	68 c7 00 00 00       	push   $0xc7
  802795:	68 7b 44 80 00       	push   $0x80447b
  80279a:	e8 5d dc ff ff       	call   8003fc <_panic>
  80279f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a2:	8b 00                	mov    (%eax),%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	74 10                	je     8027b8 <alloc_block_BF+0x181>
  8027a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b0:	8b 52 04             	mov    0x4(%edx),%edx
  8027b3:	89 50 04             	mov    %edx,0x4(%eax)
  8027b6:	eb 0b                	jmp    8027c3 <alloc_block_BF+0x18c>
  8027b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bb:	8b 40 04             	mov    0x4(%eax),%eax
  8027be:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c6:	8b 40 04             	mov    0x4(%eax),%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	74 0f                	je     8027dc <alloc_block_BF+0x1a5>
  8027cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d0:	8b 40 04             	mov    0x4(%eax),%eax
  8027d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d6:	8b 12                	mov    (%edx),%edx
  8027d8:	89 10                	mov    %edx,(%eax)
  8027da:	eb 0a                	jmp    8027e6 <alloc_block_BF+0x1af>
  8027dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8027e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f9:	a1 54 51 80 00       	mov    0x805154,%eax
  8027fe:	48                   	dec    %eax
  8027ff:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802804:	83 ec 08             	sub    $0x8,%esp
  802807:	ff 75 ec             	pushl  -0x14(%ebp)
  80280a:	68 38 51 80 00       	push   $0x805138
  80280f:	e8 71 f9 ff ff       	call   802185 <find_block>
  802814:	83 c4 10             	add    $0x10,%esp
  802817:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80281a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281d:	8b 50 08             	mov    0x8(%eax),%edx
  802820:	8b 45 08             	mov    0x8(%ebp),%eax
  802823:	01 c2                	add    %eax,%edx
  802825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802828:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80282b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282e:	8b 40 0c             	mov    0xc(%eax),%eax
  802831:	2b 45 08             	sub    0x8(%ebp),%eax
  802834:	89 c2                	mov    %eax,%edx
  802836:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802839:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80283c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283f:	eb 05                	jmp    802846 <alloc_block_BF+0x20f>
	}
	return NULL;
  802841:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802848:	55                   	push   %ebp
  802849:	89 e5                	mov    %esp,%ebp
  80284b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80284e:	a1 28 50 80 00       	mov    0x805028,%eax
  802853:	85 c0                	test   %eax,%eax
  802855:	0f 85 de 01 00 00    	jne    802a39 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80285b:	a1 38 51 80 00       	mov    0x805138,%eax
  802860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802863:	e9 9e 01 00 00       	jmp    802a06 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 40 0c             	mov    0xc(%eax),%eax
  80286e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802871:	0f 82 87 01 00 00    	jb     8029fe <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 40 0c             	mov    0xc(%eax),%eax
  80287d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802880:	0f 85 95 00 00 00    	jne    80291b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802886:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288a:	75 17                	jne    8028a3 <alloc_block_NF+0x5b>
  80288c:	83 ec 04             	sub    $0x4,%esp
  80288f:	68 24 45 80 00       	push   $0x804524
  802894:	68 e0 00 00 00       	push   $0xe0
  802899:	68 7b 44 80 00       	push   $0x80447b
  80289e:	e8 59 db ff ff       	call   8003fc <_panic>
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	74 10                	je     8028bc <alloc_block_NF+0x74>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b4:	8b 52 04             	mov    0x4(%edx),%edx
  8028b7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ba:	eb 0b                	jmp    8028c7 <alloc_block_NF+0x7f>
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 40 04             	mov    0x4(%eax),%eax
  8028c2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 40 04             	mov    0x4(%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 0f                	je     8028e0 <alloc_block_NF+0x98>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 04             	mov    0x4(%eax),%eax
  8028d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028da:	8b 12                	mov    (%edx),%edx
  8028dc:	89 10                	mov    %edx,(%eax)
  8028de:	eb 0a                	jmp    8028ea <alloc_block_NF+0xa2>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fd:	a1 44 51 80 00       	mov    0x805144,%eax
  802902:	48                   	dec    %eax
  802903:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 08             	mov    0x8(%eax),%eax
  80290e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	e9 f8 04 00 00       	jmp    802e13 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 40 0c             	mov    0xc(%eax),%eax
  802921:	3b 45 08             	cmp    0x8(%ebp),%eax
  802924:	0f 86 d4 00 00 00    	jbe    8029fe <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80292a:	a1 48 51 80 00       	mov    0x805148,%eax
  80292f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 50 08             	mov    0x8(%eax),%edx
  802938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80293e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802941:	8b 55 08             	mov    0x8(%ebp),%edx
  802944:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802947:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80294b:	75 17                	jne    802964 <alloc_block_NF+0x11c>
  80294d:	83 ec 04             	sub    $0x4,%esp
  802950:	68 24 45 80 00       	push   $0x804524
  802955:	68 e9 00 00 00       	push   $0xe9
  80295a:	68 7b 44 80 00       	push   $0x80447b
  80295f:	e8 98 da ff ff       	call   8003fc <_panic>
  802964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802967:	8b 00                	mov    (%eax),%eax
  802969:	85 c0                	test   %eax,%eax
  80296b:	74 10                	je     80297d <alloc_block_NF+0x135>
  80296d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802975:	8b 52 04             	mov    0x4(%edx),%edx
  802978:	89 50 04             	mov    %edx,0x4(%eax)
  80297b:	eb 0b                	jmp    802988 <alloc_block_NF+0x140>
  80297d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802980:	8b 40 04             	mov    0x4(%eax),%eax
  802983:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298b:	8b 40 04             	mov    0x4(%eax),%eax
  80298e:	85 c0                	test   %eax,%eax
  802990:	74 0f                	je     8029a1 <alloc_block_NF+0x159>
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	8b 40 04             	mov    0x4(%eax),%eax
  802998:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80299b:	8b 12                	mov    (%edx),%edx
  80299d:	89 10                	mov    %edx,(%eax)
  80299f:	eb 0a                	jmp    8029ab <alloc_block_NF+0x163>
  8029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029be:	a1 54 51 80 00       	mov    0x805154,%eax
  8029c3:	48                   	dec    %eax
  8029c4:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cc:	8b 40 08             	mov    0x8(%eax),%eax
  8029cf:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 50 08             	mov    0x8(%eax),%edx
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	01 c2                	add    %eax,%edx
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ee:	89 c2                	mov    %eax,%edx
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	e9 15 04 00 00       	jmp    802e13 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029fe:	a1 40 51 80 00       	mov    0x805140,%eax
  802a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0a:	74 07                	je     802a13 <alloc_block_NF+0x1cb>
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 00                	mov    (%eax),%eax
  802a11:	eb 05                	jmp    802a18 <alloc_block_NF+0x1d0>
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
  802a18:	a3 40 51 80 00       	mov    %eax,0x805140
  802a1d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	0f 85 3e fe ff ff    	jne    802868 <alloc_block_NF+0x20>
  802a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2e:	0f 85 34 fe ff ff    	jne    802868 <alloc_block_NF+0x20>
  802a34:	e9 d5 03 00 00       	jmp    802e0e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a39:	a1 38 51 80 00       	mov    0x805138,%eax
  802a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a41:	e9 b1 01 00 00       	jmp    802bf7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 50 08             	mov    0x8(%eax),%edx
  802a4c:	a1 28 50 80 00       	mov    0x805028,%eax
  802a51:	39 c2                	cmp    %eax,%edx
  802a53:	0f 82 96 01 00 00    	jb     802bef <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a62:	0f 82 87 01 00 00    	jb     802bef <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a71:	0f 85 95 00 00 00    	jne    802b0c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7b:	75 17                	jne    802a94 <alloc_block_NF+0x24c>
  802a7d:	83 ec 04             	sub    $0x4,%esp
  802a80:	68 24 45 80 00       	push   $0x804524
  802a85:	68 fc 00 00 00       	push   $0xfc
  802a8a:	68 7b 44 80 00       	push   $0x80447b
  802a8f:	e8 68 d9 ff ff       	call   8003fc <_panic>
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 00                	mov    (%eax),%eax
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	74 10                	je     802aad <alloc_block_NF+0x265>
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 00                	mov    (%eax),%eax
  802aa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa5:	8b 52 04             	mov    0x4(%edx),%edx
  802aa8:	89 50 04             	mov    %edx,0x4(%eax)
  802aab:	eb 0b                	jmp    802ab8 <alloc_block_NF+0x270>
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 40 04             	mov    0x4(%eax),%eax
  802ab3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 40 04             	mov    0x4(%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 0f                	je     802ad1 <alloc_block_NF+0x289>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 40 04             	mov    0x4(%eax),%eax
  802ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acb:	8b 12                	mov    (%edx),%edx
  802acd:	89 10                	mov    %edx,(%eax)
  802acf:	eb 0a                	jmp    802adb <alloc_block_NF+0x293>
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	a3 38 51 80 00       	mov    %eax,0x805138
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aee:	a1 44 51 80 00       	mov    0x805144,%eax
  802af3:	48                   	dec    %eax
  802af4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 40 08             	mov    0x8(%eax),%eax
  802aff:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	e9 07 03 00 00       	jmp    802e13 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b12:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b15:	0f 86 d4 00 00 00    	jbe    802bef <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b1b:	a1 48 51 80 00       	mov    0x805148,%eax
  802b20:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 50 08             	mov    0x8(%eax),%edx
  802b29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b32:	8b 55 08             	mov    0x8(%ebp),%edx
  802b35:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b38:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b3c:	75 17                	jne    802b55 <alloc_block_NF+0x30d>
  802b3e:	83 ec 04             	sub    $0x4,%esp
  802b41:	68 24 45 80 00       	push   $0x804524
  802b46:	68 04 01 00 00       	push   $0x104
  802b4b:	68 7b 44 80 00       	push   $0x80447b
  802b50:	e8 a7 d8 ff ff       	call   8003fc <_panic>
  802b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	74 10                	je     802b6e <alloc_block_NF+0x326>
  802b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b66:	8b 52 04             	mov    0x4(%edx),%edx
  802b69:	89 50 04             	mov    %edx,0x4(%eax)
  802b6c:	eb 0b                	jmp    802b79 <alloc_block_NF+0x331>
  802b6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b71:	8b 40 04             	mov    0x4(%eax),%eax
  802b74:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7c:	8b 40 04             	mov    0x4(%eax),%eax
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	74 0f                	je     802b92 <alloc_block_NF+0x34a>
  802b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b8c:	8b 12                	mov    (%edx),%edx
  802b8e:	89 10                	mov    %edx,(%eax)
  802b90:	eb 0a                	jmp    802b9c <alloc_block_NF+0x354>
  802b92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	a3 48 51 80 00       	mov    %eax,0x805148
  802b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802baf:	a1 54 51 80 00       	mov    0x805154,%eax
  802bb4:	48                   	dec    %eax
  802bb5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbd:	8b 40 08             	mov    0x8(%eax),%eax
  802bc0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 50 08             	mov    0x8(%eax),%edx
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	01 c2                	add    %eax,%edx
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdc:	2b 45 08             	sub    0x8(%ebp),%eax
  802bdf:	89 c2                	mov    %eax,%edx
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bea:	e9 24 02 00 00       	jmp    802e13 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bef:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfb:	74 07                	je     802c04 <alloc_block_NF+0x3bc>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	eb 05                	jmp    802c09 <alloc_block_NF+0x3c1>
  802c04:	b8 00 00 00 00       	mov    $0x0,%eax
  802c09:	a3 40 51 80 00       	mov    %eax,0x805140
  802c0e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	0f 85 2b fe ff ff    	jne    802a46 <alloc_block_NF+0x1fe>
  802c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1f:	0f 85 21 fe ff ff    	jne    802a46 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c25:	a1 38 51 80 00       	mov    0x805138,%eax
  802c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2d:	e9 ae 01 00 00       	jmp    802de0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 50 08             	mov    0x8(%eax),%edx
  802c38:	a1 28 50 80 00       	mov    0x805028,%eax
  802c3d:	39 c2                	cmp    %eax,%edx
  802c3f:	0f 83 93 01 00 00    	jae    802dd8 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c4e:	0f 82 84 01 00 00    	jb     802dd8 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c5d:	0f 85 95 00 00 00    	jne    802cf8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c67:	75 17                	jne    802c80 <alloc_block_NF+0x438>
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	68 24 45 80 00       	push   $0x804524
  802c71:	68 14 01 00 00       	push   $0x114
  802c76:	68 7b 44 80 00       	push   $0x80447b
  802c7b:	e8 7c d7 ff ff       	call   8003fc <_panic>
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 10                	je     802c99 <alloc_block_NF+0x451>
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c91:	8b 52 04             	mov    0x4(%edx),%edx
  802c94:	89 50 04             	mov    %edx,0x4(%eax)
  802c97:	eb 0b                	jmp    802ca4 <alloc_block_NF+0x45c>
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 40 04             	mov    0x4(%eax),%eax
  802c9f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	85 c0                	test   %eax,%eax
  802cac:	74 0f                	je     802cbd <alloc_block_NF+0x475>
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 40 04             	mov    0x4(%eax),%eax
  802cb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb7:	8b 12                	mov    (%edx),%edx
  802cb9:	89 10                	mov    %edx,(%eax)
  802cbb:	eb 0a                	jmp    802cc7 <alloc_block_NF+0x47f>
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cda:	a1 44 51 80 00       	mov    0x805144,%eax
  802cdf:	48                   	dec    %eax
  802ce0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 08             	mov    0x8(%eax),%eax
  802ceb:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	e9 1b 01 00 00       	jmp    802e13 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d01:	0f 86 d1 00 00 00    	jbe    802dd8 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d07:	a1 48 51 80 00       	mov    0x805148,%eax
  802d0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 50 08             	mov    0x8(%eax),%edx
  802d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d18:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d21:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d28:	75 17                	jne    802d41 <alloc_block_NF+0x4f9>
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	68 24 45 80 00       	push   $0x804524
  802d32:	68 1c 01 00 00       	push   $0x11c
  802d37:	68 7b 44 80 00       	push   $0x80447b
  802d3c:	e8 bb d6 ff ff       	call   8003fc <_panic>
  802d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	85 c0                	test   %eax,%eax
  802d48:	74 10                	je     802d5a <alloc_block_NF+0x512>
  802d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d52:	8b 52 04             	mov    0x4(%edx),%edx
  802d55:	89 50 04             	mov    %edx,0x4(%eax)
  802d58:	eb 0b                	jmp    802d65 <alloc_block_NF+0x51d>
  802d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5d:	8b 40 04             	mov    0x4(%eax),%eax
  802d60:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d68:	8b 40 04             	mov    0x4(%eax),%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	74 0f                	je     802d7e <alloc_block_NF+0x536>
  802d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d72:	8b 40 04             	mov    0x4(%eax),%eax
  802d75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d78:	8b 12                	mov    (%edx),%edx
  802d7a:	89 10                	mov    %edx,(%eax)
  802d7c:	eb 0a                	jmp    802d88 <alloc_block_NF+0x540>
  802d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d81:	8b 00                	mov    (%eax),%eax
  802d83:	a3 48 51 80 00       	mov    %eax,0x805148
  802d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9b:	a1 54 51 80 00       	mov    0x805154,%eax
  802da0:	48                   	dec    %eax
  802da1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da9:	8b 40 08             	mov    0x8(%eax),%eax
  802dac:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 50 08             	mov    0x8(%eax),%edx
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	01 c2                	add    %eax,%edx
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc8:	2b 45 08             	sub    0x8(%ebp),%eax
  802dcb:	89 c2                	mov    %eax,%edx
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd6:	eb 3b                	jmp    802e13 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dd8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de4:	74 07                	je     802ded <alloc_block_NF+0x5a5>
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	eb 05                	jmp    802df2 <alloc_block_NF+0x5aa>
  802ded:	b8 00 00 00 00       	mov    $0x0,%eax
  802df2:	a3 40 51 80 00       	mov    %eax,0x805140
  802df7:	a1 40 51 80 00       	mov    0x805140,%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	0f 85 2e fe ff ff    	jne    802c32 <alloc_block_NF+0x3ea>
  802e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e08:	0f 85 24 fe ff ff    	jne    802c32 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e13:	c9                   	leave  
  802e14:	c3                   	ret    

00802e15 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e15:	55                   	push   %ebp
  802e16:	89 e5                	mov    %esp,%ebp
  802e18:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e23:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e28:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e2b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e30:	85 c0                	test   %eax,%eax
  802e32:	74 14                	je     802e48 <insert_sorted_with_merge_freeList+0x33>
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 50 08             	mov    0x8(%eax),%edx
  802e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3d:	8b 40 08             	mov    0x8(%eax),%eax
  802e40:	39 c2                	cmp    %eax,%edx
  802e42:	0f 87 9b 01 00 00    	ja     802fe3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4c:	75 17                	jne    802e65 <insert_sorted_with_merge_freeList+0x50>
  802e4e:	83 ec 04             	sub    $0x4,%esp
  802e51:	68 58 44 80 00       	push   $0x804458
  802e56:	68 38 01 00 00       	push   $0x138
  802e5b:	68 7b 44 80 00       	push   $0x80447b
  802e60:	e8 97 d5 ff ff       	call   8003fc <_panic>
  802e65:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	89 10                	mov    %edx,(%eax)
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	74 0d                	je     802e86 <insert_sorted_with_merge_freeList+0x71>
  802e79:	a1 38 51 80 00       	mov    0x805138,%eax
  802e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e81:	89 50 04             	mov    %edx,0x4(%eax)
  802e84:	eb 08                	jmp    802e8e <insert_sorted_with_merge_freeList+0x79>
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	a3 38 51 80 00       	mov    %eax,0x805138
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea5:	40                   	inc    %eax
  802ea6:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eaf:	0f 84 a8 06 00 00    	je     80355d <insert_sorted_with_merge_freeList+0x748>
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 50 08             	mov    0x8(%eax),%edx
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec1:	01 c2                	add    %eax,%edx
  802ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec6:	8b 40 08             	mov    0x8(%eax),%eax
  802ec9:	39 c2                	cmp    %eax,%edx
  802ecb:	0f 85 8c 06 00 00    	jne    80355d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	8b 40 0c             	mov    0xc(%eax),%eax
  802edd:	01 c2                	add    %eax,%edx
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ee5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee9:	75 17                	jne    802f02 <insert_sorted_with_merge_freeList+0xed>
  802eeb:	83 ec 04             	sub    $0x4,%esp
  802eee:	68 24 45 80 00       	push   $0x804524
  802ef3:	68 3c 01 00 00       	push   $0x13c
  802ef8:	68 7b 44 80 00       	push   $0x80447b
  802efd:	e8 fa d4 ff ff       	call   8003fc <_panic>
  802f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f05:	8b 00                	mov    (%eax),%eax
  802f07:	85 c0                	test   %eax,%eax
  802f09:	74 10                	je     802f1b <insert_sorted_with_merge_freeList+0x106>
  802f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f13:	8b 52 04             	mov    0x4(%edx),%edx
  802f16:	89 50 04             	mov    %edx,0x4(%eax)
  802f19:	eb 0b                	jmp    802f26 <insert_sorted_with_merge_freeList+0x111>
  802f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1e:	8b 40 04             	mov    0x4(%eax),%eax
  802f21:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f29:	8b 40 04             	mov    0x4(%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 0f                	je     802f3f <insert_sorted_with_merge_freeList+0x12a>
  802f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f33:	8b 40 04             	mov    0x4(%eax),%eax
  802f36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f39:	8b 12                	mov    (%edx),%edx
  802f3b:	89 10                	mov    %edx,(%eax)
  802f3d:	eb 0a                	jmp    802f49 <insert_sorted_with_merge_freeList+0x134>
  802f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	a3 38 51 80 00       	mov    %eax,0x805138
  802f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f61:	48                   	dec    %eax
  802f62:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7f:	75 17                	jne    802f98 <insert_sorted_with_merge_freeList+0x183>
  802f81:	83 ec 04             	sub    $0x4,%esp
  802f84:	68 58 44 80 00       	push   $0x804458
  802f89:	68 3f 01 00 00       	push   $0x13f
  802f8e:	68 7b 44 80 00       	push   $0x80447b
  802f93:	e8 64 d4 ff ff       	call   8003fc <_panic>
  802f98:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	89 10                	mov    %edx,(%eax)
  802fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 0d                	je     802fb9 <insert_sorted_with_merge_freeList+0x1a4>
  802fac:	a1 48 51 80 00       	mov    0x805148,%eax
  802fb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb4:	89 50 04             	mov    %edx,0x4(%eax)
  802fb7:	eb 08                	jmp    802fc1 <insert_sorted_with_merge_freeList+0x1ac>
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd3:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd8:	40                   	inc    %eax
  802fd9:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fde:	e9 7a 05 00 00       	jmp    80355d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	8b 50 08             	mov    0x8(%eax),%edx
  802fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fec:	8b 40 08             	mov    0x8(%eax),%eax
  802fef:	39 c2                	cmp    %eax,%edx
  802ff1:	0f 82 14 01 00 00    	jb     80310b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffa:	8b 50 08             	mov    0x8(%eax),%edx
  802ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803000:	8b 40 0c             	mov    0xc(%eax),%eax
  803003:	01 c2                	add    %eax,%edx
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	8b 40 08             	mov    0x8(%eax),%eax
  80300b:	39 c2                	cmp    %eax,%edx
  80300d:	0f 85 90 00 00 00    	jne    8030a3 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803016:	8b 50 0c             	mov    0xc(%eax),%edx
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	8b 40 0c             	mov    0xc(%eax),%eax
  80301f:	01 c2                	add    %eax,%edx
  803021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803024:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80303b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303f:	75 17                	jne    803058 <insert_sorted_with_merge_freeList+0x243>
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	68 58 44 80 00       	push   $0x804458
  803049:	68 49 01 00 00       	push   $0x149
  80304e:	68 7b 44 80 00       	push   $0x80447b
  803053:	e8 a4 d3 ff ff       	call   8003fc <_panic>
  803058:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	89 10                	mov    %edx,(%eax)
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	74 0d                	je     803079 <insert_sorted_with_merge_freeList+0x264>
  80306c:	a1 48 51 80 00       	mov    0x805148,%eax
  803071:	8b 55 08             	mov    0x8(%ebp),%edx
  803074:	89 50 04             	mov    %edx,0x4(%eax)
  803077:	eb 08                	jmp    803081 <insert_sorted_with_merge_freeList+0x26c>
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	a3 48 51 80 00       	mov    %eax,0x805148
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803093:	a1 54 51 80 00       	mov    0x805154,%eax
  803098:	40                   	inc    %eax
  803099:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80309e:	e9 bb 04 00 00       	jmp    80355e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a7:	75 17                	jne    8030c0 <insert_sorted_with_merge_freeList+0x2ab>
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	68 cc 44 80 00       	push   $0x8044cc
  8030b1:	68 4c 01 00 00       	push   $0x14c
  8030b6:	68 7b 44 80 00       	push   $0x80447b
  8030bb:	e8 3c d3 ff ff       	call   8003fc <_panic>
  8030c0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	89 50 04             	mov    %edx,0x4(%eax)
  8030cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cf:	8b 40 04             	mov    0x4(%eax),%eax
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	74 0c                	je     8030e2 <insert_sorted_with_merge_freeList+0x2cd>
  8030d6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030db:	8b 55 08             	mov    0x8(%ebp),%edx
  8030de:	89 10                	mov    %edx,(%eax)
  8030e0:	eb 08                	jmp    8030ea <insert_sorted_with_merge_freeList+0x2d5>
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fb:	a1 44 51 80 00       	mov    0x805144,%eax
  803100:	40                   	inc    %eax
  803101:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803106:	e9 53 04 00 00       	jmp    80355e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80310b:	a1 38 51 80 00       	mov    0x805138,%eax
  803110:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803113:	e9 15 04 00 00       	jmp    80352d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	8b 50 08             	mov    0x8(%eax),%edx
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 40 08             	mov    0x8(%eax),%eax
  80312c:	39 c2                	cmp    %eax,%edx
  80312e:	0f 86 f1 03 00 00    	jbe    803525 <insert_sorted_with_merge_freeList+0x710>
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8b 50 08             	mov    0x8(%eax),%edx
  80313a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313d:	8b 40 08             	mov    0x8(%eax),%eax
  803140:	39 c2                	cmp    %eax,%edx
  803142:	0f 83 dd 03 00 00    	jae    803525 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	8b 50 08             	mov    0x8(%eax),%edx
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 40 0c             	mov    0xc(%eax),%eax
  803154:	01 c2                	add    %eax,%edx
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	8b 40 08             	mov    0x8(%eax),%eax
  80315c:	39 c2                	cmp    %eax,%edx
  80315e:	0f 85 b9 01 00 00    	jne    80331d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	8b 50 08             	mov    0x8(%eax),%edx
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	8b 40 0c             	mov    0xc(%eax),%eax
  803170:	01 c2                	add    %eax,%edx
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	8b 40 08             	mov    0x8(%eax),%eax
  803178:	39 c2                	cmp    %eax,%edx
  80317a:	0f 85 0d 01 00 00    	jne    80328d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 50 0c             	mov    0xc(%eax),%edx
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	8b 40 0c             	mov    0xc(%eax),%eax
  80318c:	01 c2                	add    %eax,%edx
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803194:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803198:	75 17                	jne    8031b1 <insert_sorted_with_merge_freeList+0x39c>
  80319a:	83 ec 04             	sub    $0x4,%esp
  80319d:	68 24 45 80 00       	push   $0x804524
  8031a2:	68 5c 01 00 00       	push   $0x15c
  8031a7:	68 7b 44 80 00       	push   $0x80447b
  8031ac:	e8 4b d2 ff ff       	call   8003fc <_panic>
  8031b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b4:	8b 00                	mov    (%eax),%eax
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	74 10                	je     8031ca <insert_sorted_with_merge_freeList+0x3b5>
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	8b 00                	mov    (%eax),%eax
  8031bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c2:	8b 52 04             	mov    0x4(%edx),%edx
  8031c5:	89 50 04             	mov    %edx,0x4(%eax)
  8031c8:	eb 0b                	jmp    8031d5 <insert_sorted_with_merge_freeList+0x3c0>
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	8b 40 04             	mov    0x4(%eax),%eax
  8031d0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d8:	8b 40 04             	mov    0x4(%eax),%eax
  8031db:	85 c0                	test   %eax,%eax
  8031dd:	74 0f                	je     8031ee <insert_sorted_with_merge_freeList+0x3d9>
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	8b 40 04             	mov    0x4(%eax),%eax
  8031e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e8:	8b 12                	mov    (%edx),%edx
  8031ea:	89 10                	mov    %edx,(%eax)
  8031ec:	eb 0a                	jmp    8031f8 <insert_sorted_with_merge_freeList+0x3e3>
  8031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803201:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803204:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320b:	a1 44 51 80 00       	mov    0x805144,%eax
  803210:	48                   	dec    %eax
  803211:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80322a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80322e:	75 17                	jne    803247 <insert_sorted_with_merge_freeList+0x432>
  803230:	83 ec 04             	sub    $0x4,%esp
  803233:	68 58 44 80 00       	push   $0x804458
  803238:	68 5f 01 00 00       	push   $0x15f
  80323d:	68 7b 44 80 00       	push   $0x80447b
  803242:	e8 b5 d1 ff ff       	call   8003fc <_panic>
  803247:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80324d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803250:	89 10                	mov    %edx,(%eax)
  803252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	74 0d                	je     803268 <insert_sorted_with_merge_freeList+0x453>
  80325b:	a1 48 51 80 00       	mov    0x805148,%eax
  803260:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803263:	89 50 04             	mov    %edx,0x4(%eax)
  803266:	eb 08                	jmp    803270 <insert_sorted_with_merge_freeList+0x45b>
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	a3 48 51 80 00       	mov    %eax,0x805148
  803278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803282:	a1 54 51 80 00       	mov    0x805154,%eax
  803287:	40                   	inc    %eax
  803288:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	8b 50 0c             	mov    0xc(%eax),%edx
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	8b 40 0c             	mov    0xc(%eax),%eax
  803299:	01 c2                	add    %eax,%edx
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b9:	75 17                	jne    8032d2 <insert_sorted_with_merge_freeList+0x4bd>
  8032bb:	83 ec 04             	sub    $0x4,%esp
  8032be:	68 58 44 80 00       	push   $0x804458
  8032c3:	68 64 01 00 00       	push   $0x164
  8032c8:	68 7b 44 80 00       	push   $0x80447b
  8032cd:	e8 2a d1 ff ff       	call   8003fc <_panic>
  8032d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	89 10                	mov    %edx,(%eax)
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	85 c0                	test   %eax,%eax
  8032e4:	74 0d                	je     8032f3 <insert_sorted_with_merge_freeList+0x4de>
  8032e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8032eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ee:	89 50 04             	mov    %edx,0x4(%eax)
  8032f1:	eb 08                	jmp    8032fb <insert_sorted_with_merge_freeList+0x4e6>
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	a3 48 51 80 00       	mov    %eax,0x805148
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330d:	a1 54 51 80 00       	mov    0x805154,%eax
  803312:	40                   	inc    %eax
  803313:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803318:	e9 41 02 00 00       	jmp    80355e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	8b 50 08             	mov    0x8(%eax),%edx
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	8b 40 0c             	mov    0xc(%eax),%eax
  803329:	01 c2                	add    %eax,%edx
  80332b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332e:	8b 40 08             	mov    0x8(%eax),%eax
  803331:	39 c2                	cmp    %eax,%edx
  803333:	0f 85 7c 01 00 00    	jne    8034b5 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803339:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80333d:	74 06                	je     803345 <insert_sorted_with_merge_freeList+0x530>
  80333f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803343:	75 17                	jne    80335c <insert_sorted_with_merge_freeList+0x547>
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 94 44 80 00       	push   $0x804494
  80334d:	68 69 01 00 00       	push   $0x169
  803352:	68 7b 44 80 00       	push   $0x80447b
  803357:	e8 a0 d0 ff ff       	call   8003fc <_panic>
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	8b 50 04             	mov    0x4(%eax),%edx
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	89 50 04             	mov    %edx,0x4(%eax)
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80336e:	89 10                	mov    %edx,(%eax)
  803370:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	85 c0                	test   %eax,%eax
  803378:	74 0d                	je     803387 <insert_sorted_with_merge_freeList+0x572>
  80337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337d:	8b 40 04             	mov    0x4(%eax),%eax
  803380:	8b 55 08             	mov    0x8(%ebp),%edx
  803383:	89 10                	mov    %edx,(%eax)
  803385:	eb 08                	jmp    80338f <insert_sorted_with_merge_freeList+0x57a>
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	a3 38 51 80 00       	mov    %eax,0x805138
  80338f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803392:	8b 55 08             	mov    0x8(%ebp),%edx
  803395:	89 50 04             	mov    %edx,0x4(%eax)
  803398:	a1 44 51 80 00       	mov    0x805144,%eax
  80339d:	40                   	inc    %eax
  80339e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8033af:	01 c2                	add    %eax,%edx
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033bb:	75 17                	jne    8033d4 <insert_sorted_with_merge_freeList+0x5bf>
  8033bd:	83 ec 04             	sub    $0x4,%esp
  8033c0:	68 24 45 80 00       	push   $0x804524
  8033c5:	68 6b 01 00 00       	push   $0x16b
  8033ca:	68 7b 44 80 00       	push   $0x80447b
  8033cf:	e8 28 d0 ff ff       	call   8003fc <_panic>
  8033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d7:	8b 00                	mov    (%eax),%eax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	74 10                	je     8033ed <insert_sorted_with_merge_freeList+0x5d8>
  8033dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033e5:	8b 52 04             	mov    0x4(%edx),%edx
  8033e8:	89 50 04             	mov    %edx,0x4(%eax)
  8033eb:	eb 0b                	jmp    8033f8 <insert_sorted_with_merge_freeList+0x5e3>
  8033ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f0:	8b 40 04             	mov    0x4(%eax),%eax
  8033f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fb:	8b 40 04             	mov    0x4(%eax),%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	74 0f                	je     803411 <insert_sorted_with_merge_freeList+0x5fc>
  803402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803405:	8b 40 04             	mov    0x4(%eax),%eax
  803408:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80340b:	8b 12                	mov    (%edx),%edx
  80340d:	89 10                	mov    %edx,(%eax)
  80340f:	eb 0a                	jmp    80341b <insert_sorted_with_merge_freeList+0x606>
  803411:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	a3 38 51 80 00       	mov    %eax,0x805138
  80341b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803427:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342e:	a1 44 51 80 00       	mov    0x805144,%eax
  803433:	48                   	dec    %eax
  803434:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803439:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803443:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803446:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80344d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803451:	75 17                	jne    80346a <insert_sorted_with_merge_freeList+0x655>
  803453:	83 ec 04             	sub    $0x4,%esp
  803456:	68 58 44 80 00       	push   $0x804458
  80345b:	68 6e 01 00 00       	push   $0x16e
  803460:	68 7b 44 80 00       	push   $0x80447b
  803465:	e8 92 cf ff ff       	call   8003fc <_panic>
  80346a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803473:	89 10                	mov    %edx,(%eax)
  803475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803478:	8b 00                	mov    (%eax),%eax
  80347a:	85 c0                	test   %eax,%eax
  80347c:	74 0d                	je     80348b <insert_sorted_with_merge_freeList+0x676>
  80347e:	a1 48 51 80 00       	mov    0x805148,%eax
  803483:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803486:	89 50 04             	mov    %edx,0x4(%eax)
  803489:	eb 08                	jmp    803493 <insert_sorted_with_merge_freeList+0x67e>
  80348b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803496:	a3 48 51 80 00       	mov    %eax,0x805148
  80349b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8034aa:	40                   	inc    %eax
  8034ab:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034b0:	e9 a9 00 00 00       	jmp    80355e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b9:	74 06                	je     8034c1 <insert_sorted_with_merge_freeList+0x6ac>
  8034bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034bf:	75 17                	jne    8034d8 <insert_sorted_with_merge_freeList+0x6c3>
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	68 f0 44 80 00       	push   $0x8044f0
  8034c9:	68 73 01 00 00       	push   $0x173
  8034ce:	68 7b 44 80 00       	push   $0x80447b
  8034d3:	e8 24 cf ff ff       	call   8003fc <_panic>
  8034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034db:	8b 10                	mov    (%eax),%edx
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	89 10                	mov    %edx,(%eax)
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	8b 00                	mov    (%eax),%eax
  8034e7:	85 c0                	test   %eax,%eax
  8034e9:	74 0b                	je     8034f6 <insert_sorted_with_merge_freeList+0x6e1>
  8034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ee:	8b 00                	mov    (%eax),%eax
  8034f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f3:	89 50 04             	mov    %edx,0x4(%eax)
  8034f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034fc:	89 10                	mov    %edx,(%eax)
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803504:	89 50 04             	mov    %edx,0x4(%eax)
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	8b 00                	mov    (%eax),%eax
  80350c:	85 c0                	test   %eax,%eax
  80350e:	75 08                	jne    803518 <insert_sorted_with_merge_freeList+0x703>
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803518:	a1 44 51 80 00       	mov    0x805144,%eax
  80351d:	40                   	inc    %eax
  80351e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803523:	eb 39                	jmp    80355e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803525:	a1 40 51 80 00       	mov    0x805140,%eax
  80352a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80352d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803531:	74 07                	je     80353a <insert_sorted_with_merge_freeList+0x725>
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	eb 05                	jmp    80353f <insert_sorted_with_merge_freeList+0x72a>
  80353a:	b8 00 00 00 00       	mov    $0x0,%eax
  80353f:	a3 40 51 80 00       	mov    %eax,0x805140
  803544:	a1 40 51 80 00       	mov    0x805140,%eax
  803549:	85 c0                	test   %eax,%eax
  80354b:	0f 85 c7 fb ff ff    	jne    803118 <insert_sorted_with_merge_freeList+0x303>
  803551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803555:	0f 85 bd fb ff ff    	jne    803118 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80355b:	eb 01                	jmp    80355e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80355d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80355e:	90                   	nop
  80355f:	c9                   	leave  
  803560:	c3                   	ret    
  803561:	66 90                	xchg   %ax,%ax
  803563:	90                   	nop

00803564 <__udivdi3>:
  803564:	55                   	push   %ebp
  803565:	57                   	push   %edi
  803566:	56                   	push   %esi
  803567:	53                   	push   %ebx
  803568:	83 ec 1c             	sub    $0x1c,%esp
  80356b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80356f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803573:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803577:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80357b:	89 ca                	mov    %ecx,%edx
  80357d:	89 f8                	mov    %edi,%eax
  80357f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803583:	85 f6                	test   %esi,%esi
  803585:	75 2d                	jne    8035b4 <__udivdi3+0x50>
  803587:	39 cf                	cmp    %ecx,%edi
  803589:	77 65                	ja     8035f0 <__udivdi3+0x8c>
  80358b:	89 fd                	mov    %edi,%ebp
  80358d:	85 ff                	test   %edi,%edi
  80358f:	75 0b                	jne    80359c <__udivdi3+0x38>
  803591:	b8 01 00 00 00       	mov    $0x1,%eax
  803596:	31 d2                	xor    %edx,%edx
  803598:	f7 f7                	div    %edi
  80359a:	89 c5                	mov    %eax,%ebp
  80359c:	31 d2                	xor    %edx,%edx
  80359e:	89 c8                	mov    %ecx,%eax
  8035a0:	f7 f5                	div    %ebp
  8035a2:	89 c1                	mov    %eax,%ecx
  8035a4:	89 d8                	mov    %ebx,%eax
  8035a6:	f7 f5                	div    %ebp
  8035a8:	89 cf                	mov    %ecx,%edi
  8035aa:	89 fa                	mov    %edi,%edx
  8035ac:	83 c4 1c             	add    $0x1c,%esp
  8035af:	5b                   	pop    %ebx
  8035b0:	5e                   	pop    %esi
  8035b1:	5f                   	pop    %edi
  8035b2:	5d                   	pop    %ebp
  8035b3:	c3                   	ret    
  8035b4:	39 ce                	cmp    %ecx,%esi
  8035b6:	77 28                	ja     8035e0 <__udivdi3+0x7c>
  8035b8:	0f bd fe             	bsr    %esi,%edi
  8035bb:	83 f7 1f             	xor    $0x1f,%edi
  8035be:	75 40                	jne    803600 <__udivdi3+0x9c>
  8035c0:	39 ce                	cmp    %ecx,%esi
  8035c2:	72 0a                	jb     8035ce <__udivdi3+0x6a>
  8035c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035c8:	0f 87 9e 00 00 00    	ja     80366c <__udivdi3+0x108>
  8035ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d3:	89 fa                	mov    %edi,%edx
  8035d5:	83 c4 1c             	add    $0x1c,%esp
  8035d8:	5b                   	pop    %ebx
  8035d9:	5e                   	pop    %esi
  8035da:	5f                   	pop    %edi
  8035db:	5d                   	pop    %ebp
  8035dc:	c3                   	ret    
  8035dd:	8d 76 00             	lea    0x0(%esi),%esi
  8035e0:	31 ff                	xor    %edi,%edi
  8035e2:	31 c0                	xor    %eax,%eax
  8035e4:	89 fa                	mov    %edi,%edx
  8035e6:	83 c4 1c             	add    $0x1c,%esp
  8035e9:	5b                   	pop    %ebx
  8035ea:	5e                   	pop    %esi
  8035eb:	5f                   	pop    %edi
  8035ec:	5d                   	pop    %ebp
  8035ed:	c3                   	ret    
  8035ee:	66 90                	xchg   %ax,%ax
  8035f0:	89 d8                	mov    %ebx,%eax
  8035f2:	f7 f7                	div    %edi
  8035f4:	31 ff                	xor    %edi,%edi
  8035f6:	89 fa                	mov    %edi,%edx
  8035f8:	83 c4 1c             	add    $0x1c,%esp
  8035fb:	5b                   	pop    %ebx
  8035fc:	5e                   	pop    %esi
  8035fd:	5f                   	pop    %edi
  8035fe:	5d                   	pop    %ebp
  8035ff:	c3                   	ret    
  803600:	bd 20 00 00 00       	mov    $0x20,%ebp
  803605:	89 eb                	mov    %ebp,%ebx
  803607:	29 fb                	sub    %edi,%ebx
  803609:	89 f9                	mov    %edi,%ecx
  80360b:	d3 e6                	shl    %cl,%esi
  80360d:	89 c5                	mov    %eax,%ebp
  80360f:	88 d9                	mov    %bl,%cl
  803611:	d3 ed                	shr    %cl,%ebp
  803613:	89 e9                	mov    %ebp,%ecx
  803615:	09 f1                	or     %esi,%ecx
  803617:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80361b:	89 f9                	mov    %edi,%ecx
  80361d:	d3 e0                	shl    %cl,%eax
  80361f:	89 c5                	mov    %eax,%ebp
  803621:	89 d6                	mov    %edx,%esi
  803623:	88 d9                	mov    %bl,%cl
  803625:	d3 ee                	shr    %cl,%esi
  803627:	89 f9                	mov    %edi,%ecx
  803629:	d3 e2                	shl    %cl,%edx
  80362b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80362f:	88 d9                	mov    %bl,%cl
  803631:	d3 e8                	shr    %cl,%eax
  803633:	09 c2                	or     %eax,%edx
  803635:	89 d0                	mov    %edx,%eax
  803637:	89 f2                	mov    %esi,%edx
  803639:	f7 74 24 0c          	divl   0xc(%esp)
  80363d:	89 d6                	mov    %edx,%esi
  80363f:	89 c3                	mov    %eax,%ebx
  803641:	f7 e5                	mul    %ebp
  803643:	39 d6                	cmp    %edx,%esi
  803645:	72 19                	jb     803660 <__udivdi3+0xfc>
  803647:	74 0b                	je     803654 <__udivdi3+0xf0>
  803649:	89 d8                	mov    %ebx,%eax
  80364b:	31 ff                	xor    %edi,%edi
  80364d:	e9 58 ff ff ff       	jmp    8035aa <__udivdi3+0x46>
  803652:	66 90                	xchg   %ax,%ax
  803654:	8b 54 24 08          	mov    0x8(%esp),%edx
  803658:	89 f9                	mov    %edi,%ecx
  80365a:	d3 e2                	shl    %cl,%edx
  80365c:	39 c2                	cmp    %eax,%edx
  80365e:	73 e9                	jae    803649 <__udivdi3+0xe5>
  803660:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803663:	31 ff                	xor    %edi,%edi
  803665:	e9 40 ff ff ff       	jmp    8035aa <__udivdi3+0x46>
  80366a:	66 90                	xchg   %ax,%ax
  80366c:	31 c0                	xor    %eax,%eax
  80366e:	e9 37 ff ff ff       	jmp    8035aa <__udivdi3+0x46>
  803673:	90                   	nop

00803674 <__umoddi3>:
  803674:	55                   	push   %ebp
  803675:	57                   	push   %edi
  803676:	56                   	push   %esi
  803677:	53                   	push   %ebx
  803678:	83 ec 1c             	sub    $0x1c,%esp
  80367b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80367f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803683:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803687:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80368b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80368f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803693:	89 f3                	mov    %esi,%ebx
  803695:	89 fa                	mov    %edi,%edx
  803697:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80369b:	89 34 24             	mov    %esi,(%esp)
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	75 1a                	jne    8036bc <__umoddi3+0x48>
  8036a2:	39 f7                	cmp    %esi,%edi
  8036a4:	0f 86 a2 00 00 00    	jbe    80374c <__umoddi3+0xd8>
  8036aa:	89 c8                	mov    %ecx,%eax
  8036ac:	89 f2                	mov    %esi,%edx
  8036ae:	f7 f7                	div    %edi
  8036b0:	89 d0                	mov    %edx,%eax
  8036b2:	31 d2                	xor    %edx,%edx
  8036b4:	83 c4 1c             	add    $0x1c,%esp
  8036b7:	5b                   	pop    %ebx
  8036b8:	5e                   	pop    %esi
  8036b9:	5f                   	pop    %edi
  8036ba:	5d                   	pop    %ebp
  8036bb:	c3                   	ret    
  8036bc:	39 f0                	cmp    %esi,%eax
  8036be:	0f 87 ac 00 00 00    	ja     803770 <__umoddi3+0xfc>
  8036c4:	0f bd e8             	bsr    %eax,%ebp
  8036c7:	83 f5 1f             	xor    $0x1f,%ebp
  8036ca:	0f 84 ac 00 00 00    	je     80377c <__umoddi3+0x108>
  8036d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8036d5:	29 ef                	sub    %ebp,%edi
  8036d7:	89 fe                	mov    %edi,%esi
  8036d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036dd:	89 e9                	mov    %ebp,%ecx
  8036df:	d3 e0                	shl    %cl,%eax
  8036e1:	89 d7                	mov    %edx,%edi
  8036e3:	89 f1                	mov    %esi,%ecx
  8036e5:	d3 ef                	shr    %cl,%edi
  8036e7:	09 c7                	or     %eax,%edi
  8036e9:	89 e9                	mov    %ebp,%ecx
  8036eb:	d3 e2                	shl    %cl,%edx
  8036ed:	89 14 24             	mov    %edx,(%esp)
  8036f0:	89 d8                	mov    %ebx,%eax
  8036f2:	d3 e0                	shl    %cl,%eax
  8036f4:	89 c2                	mov    %eax,%edx
  8036f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036fa:	d3 e0                	shl    %cl,%eax
  8036fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803700:	8b 44 24 08          	mov    0x8(%esp),%eax
  803704:	89 f1                	mov    %esi,%ecx
  803706:	d3 e8                	shr    %cl,%eax
  803708:	09 d0                	or     %edx,%eax
  80370a:	d3 eb                	shr    %cl,%ebx
  80370c:	89 da                	mov    %ebx,%edx
  80370e:	f7 f7                	div    %edi
  803710:	89 d3                	mov    %edx,%ebx
  803712:	f7 24 24             	mull   (%esp)
  803715:	89 c6                	mov    %eax,%esi
  803717:	89 d1                	mov    %edx,%ecx
  803719:	39 d3                	cmp    %edx,%ebx
  80371b:	0f 82 87 00 00 00    	jb     8037a8 <__umoddi3+0x134>
  803721:	0f 84 91 00 00 00    	je     8037b8 <__umoddi3+0x144>
  803727:	8b 54 24 04          	mov    0x4(%esp),%edx
  80372b:	29 f2                	sub    %esi,%edx
  80372d:	19 cb                	sbb    %ecx,%ebx
  80372f:	89 d8                	mov    %ebx,%eax
  803731:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803735:	d3 e0                	shl    %cl,%eax
  803737:	89 e9                	mov    %ebp,%ecx
  803739:	d3 ea                	shr    %cl,%edx
  80373b:	09 d0                	or     %edx,%eax
  80373d:	89 e9                	mov    %ebp,%ecx
  80373f:	d3 eb                	shr    %cl,%ebx
  803741:	89 da                	mov    %ebx,%edx
  803743:	83 c4 1c             	add    $0x1c,%esp
  803746:	5b                   	pop    %ebx
  803747:	5e                   	pop    %esi
  803748:	5f                   	pop    %edi
  803749:	5d                   	pop    %ebp
  80374a:	c3                   	ret    
  80374b:	90                   	nop
  80374c:	89 fd                	mov    %edi,%ebp
  80374e:	85 ff                	test   %edi,%edi
  803750:	75 0b                	jne    80375d <__umoddi3+0xe9>
  803752:	b8 01 00 00 00       	mov    $0x1,%eax
  803757:	31 d2                	xor    %edx,%edx
  803759:	f7 f7                	div    %edi
  80375b:	89 c5                	mov    %eax,%ebp
  80375d:	89 f0                	mov    %esi,%eax
  80375f:	31 d2                	xor    %edx,%edx
  803761:	f7 f5                	div    %ebp
  803763:	89 c8                	mov    %ecx,%eax
  803765:	f7 f5                	div    %ebp
  803767:	89 d0                	mov    %edx,%eax
  803769:	e9 44 ff ff ff       	jmp    8036b2 <__umoddi3+0x3e>
  80376e:	66 90                	xchg   %ax,%ax
  803770:	89 c8                	mov    %ecx,%eax
  803772:	89 f2                	mov    %esi,%edx
  803774:	83 c4 1c             	add    $0x1c,%esp
  803777:	5b                   	pop    %ebx
  803778:	5e                   	pop    %esi
  803779:	5f                   	pop    %edi
  80377a:	5d                   	pop    %ebp
  80377b:	c3                   	ret    
  80377c:	3b 04 24             	cmp    (%esp),%eax
  80377f:	72 06                	jb     803787 <__umoddi3+0x113>
  803781:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803785:	77 0f                	ja     803796 <__umoddi3+0x122>
  803787:	89 f2                	mov    %esi,%edx
  803789:	29 f9                	sub    %edi,%ecx
  80378b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80378f:	89 14 24             	mov    %edx,(%esp)
  803792:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803796:	8b 44 24 04          	mov    0x4(%esp),%eax
  80379a:	8b 14 24             	mov    (%esp),%edx
  80379d:	83 c4 1c             	add    $0x1c,%esp
  8037a0:	5b                   	pop    %ebx
  8037a1:	5e                   	pop    %esi
  8037a2:	5f                   	pop    %edi
  8037a3:	5d                   	pop    %ebp
  8037a4:	c3                   	ret    
  8037a5:	8d 76 00             	lea    0x0(%esi),%esi
  8037a8:	2b 04 24             	sub    (%esp),%eax
  8037ab:	19 fa                	sbb    %edi,%edx
  8037ad:	89 d1                	mov    %edx,%ecx
  8037af:	89 c6                	mov    %eax,%esi
  8037b1:	e9 71 ff ff ff       	jmp    803727 <__umoddi3+0xb3>
  8037b6:	66 90                	xchg   %ax,%ax
  8037b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037bc:	72 ea                	jb     8037a8 <__umoddi3+0x134>
  8037be:	89 d9                	mov    %ebx,%ecx
  8037c0:	e9 62 ff ff ff       	jmp    803727 <__umoddi3+0xb3>
