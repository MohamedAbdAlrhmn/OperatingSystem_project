
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
  80008c:	68 80 38 80 00       	push   $0x803880
  800091:	6a 12                	push   $0x12
  800093:	68 9c 38 80 00       	push   $0x80389c
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
  8000ad:	68 b4 38 80 00       	push   $0x8038b4
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 e8 38 80 00       	push   $0x8038e8
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 44 39 80 00       	push   $0x803944
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 78 39 80 00       	push   $0x803978
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 c0 39 80 00       	push   $0x8039c0
  8000f9:	e8 85 16 00 00       	call   801783 <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 4c 19 00 00       	call   801a55 <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 c0 39 80 00       	push   $0x8039c0
  80011b:	e8 63 16 00 00       	call   801783 <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 c4 39 80 00       	push   $0x8039c4
  800134:	6a 24                	push   $0x24
  800136:	68 9c 38 80 00       	push   $0x80389c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 10 19 00 00       	call   801a55 <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 18 3a 80 00       	push   $0x803a18
  800156:	6a 25                	push   $0x25
  800158:	68 9c 38 80 00       	push   $0x80389c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 74 3a 80 00       	push   $0x803a74
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 de 18 00 00       	call   801a55 <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 cc 3a 80 00       	push   $0x803acc
  80018e:	e8 f0 15 00 00       	call   801783 <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 d0 3a 80 00       	push   $0x803ad0
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 9c 38 80 00       	push   $0x80389c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 9d 18 00 00       	call   801a55 <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 44 3b 80 00       	push   $0x803b44
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 9c 38 80 00       	push   $0x80389c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 b8 3b 80 00       	push   $0x803bb8
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 c4 1a 00 00       	call   801cae <sys_getMaxShares>
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
  800213:	e8 6b 15 00 00       	call   801783 <smalloc>
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80021e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800222:	75 14                	jne    800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 2c 3c 80 00       	push   $0x803c2c
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 9c 38 80 00       	push   $0x80389c
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
  80024f:	68 5c 3c 80 00       	push   $0x803c5c
  800254:	e8 2a 15 00 00       	call   801783 <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 4a 1a 00 00       	call   801cae <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 68 3c 80 00       	push   $0x803c68
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 9c 38 80 00       	push   $0x80389c
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
  80029c:	68 e4 3c 80 00       	push   $0x803ce4
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 9c 38 80 00       	push   $0x80389c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 70 3d 80 00       	push   $0x803d70
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
  8002c6:	e8 6a 1a 00 00       	call   801d35 <sys_getenvindex>
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
  800331:	e8 0c 18 00 00       	call   801b42 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 e8 3d 80 00       	push   $0x803de8
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
  800361:	68 10 3e 80 00       	push   $0x803e10
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
  800392:	68 38 3e 80 00       	push   $0x803e38
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 90 3e 80 00       	push   $0x803e90
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 e8 3d 80 00       	push   $0x803de8
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 8c 17 00 00       	call   801b5c <sys_enable_interrupt>

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
  8003e3:	e8 19 19 00 00       	call   801d01 <sys_destroy_env>
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
  8003f4:	e8 6e 19 00 00       	call   801d67 <sys_exit_env>
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
  80041d:	68 a4 3e 80 00       	push   $0x803ea4
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 a9 3e 80 00       	push   $0x803ea9
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
  80045a:	68 c5 3e 80 00       	push   $0x803ec5
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
  800486:	68 c8 3e 80 00       	push   $0x803ec8
  80048b:	6a 26                	push   $0x26
  80048d:	68 14 3f 80 00       	push   $0x803f14
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
  800558:	68 20 3f 80 00       	push   $0x803f20
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 14 3f 80 00       	push   $0x803f14
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
  8005c8:	68 74 3f 80 00       	push   $0x803f74
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 14 3f 80 00       	push   $0x803f14
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
  800622:	e8 6d 13 00 00       	call   801994 <sys_cputs>
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
  800699:	e8 f6 12 00 00       	call   801994 <sys_cputs>
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
  8006e3:	e8 5a 14 00 00       	call   801b42 <sys_disable_interrupt>
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
  800703:	e8 54 14 00 00       	call   801b5c <sys_enable_interrupt>
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
  80074d:	e8 c6 2e 00 00       	call   803618 <__udivdi3>
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
  80079d:	e8 86 2f 00 00       	call   803728 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 d4 41 80 00       	add    $0x8041d4,%eax
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
  8008f8:	8b 04 85 f8 41 80 00 	mov    0x8041f8(,%eax,4),%eax
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
  8009d9:	8b 34 9d 40 40 80 00 	mov    0x804040(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 e5 41 80 00       	push   $0x8041e5
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
  8009fe:	68 ee 41 80 00       	push   $0x8041ee
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
  800a2b:	be f1 41 80 00       	mov    $0x8041f1,%esi
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
  801451:	68 50 43 80 00       	push   $0x804350
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
  801521:	e8 b2 05 00 00       	call   801ad8 <sys_allocate_chunk>
  801526:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801529:	a1 20 51 80 00       	mov    0x805120,%eax
  80152e:	83 ec 0c             	sub    $0xc,%esp
  801531:	50                   	push   %eax
  801532:	e8 27 0c 00 00       	call   80215e <initialize_MemBlocksList>
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
  80155f:	68 75 43 80 00       	push   $0x804375
  801564:	6a 33                	push   $0x33
  801566:	68 93 43 80 00       	push   $0x804393
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
  8015de:	68 a0 43 80 00       	push   $0x8043a0
  8015e3:	6a 34                	push   $0x34
  8015e5:	68 93 43 80 00       	push   $0x804393
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
  801676:	e8 2b 08 00 00       	call   801ea6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80167b:	85 c0                	test   %eax,%eax
  80167d:	74 11                	je     801690 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	ff 75 e8             	pushl  -0x18(%ebp)
  801685:	e8 96 0e 00 00       	call   802520 <alloc_block_FF>
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
  80169c:	e8 f2 0b 00 00       	call   802293 <insert_sorted_allocList>
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
  8016b6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	83 ec 08             	sub    $0x8,%esp
  8016bf:	50                   	push   %eax
  8016c0:	68 40 50 80 00       	push   $0x805040
  8016c5:	e8 71 0b 00 00       	call   80223b <find_block>
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8016d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016d4:	0f 84 a6 00 00 00    	je     801780 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	8b 50 0c             	mov    0xc(%eax),%edx
  8016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e3:	8b 40 08             	mov    0x8(%eax),%eax
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	52                   	push   %edx
  8016ea:	50                   	push   %eax
  8016eb:	e8 b0 03 00 00       	call   801aa0 <sys_free_user_mem>
  8016f0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8016f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016f7:	75 14                	jne    80170d <free+0x5a>
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	68 75 43 80 00       	push   $0x804375
  801701:	6a 74                	push   $0x74
  801703:	68 93 43 80 00       	push   $0x804393
  801708:	e8 ef ec ff ff       	call   8003fc <_panic>
  80170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801710:	8b 00                	mov    (%eax),%eax
  801712:	85 c0                	test   %eax,%eax
  801714:	74 10                	je     801726 <free+0x73>
  801716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171e:	8b 52 04             	mov    0x4(%edx),%edx
  801721:	89 50 04             	mov    %edx,0x4(%eax)
  801724:	eb 0b                	jmp    801731 <free+0x7e>
  801726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801729:	8b 40 04             	mov    0x4(%eax),%eax
  80172c:	a3 44 50 80 00       	mov    %eax,0x805044
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	8b 40 04             	mov    0x4(%eax),%eax
  801737:	85 c0                	test   %eax,%eax
  801739:	74 0f                	je     80174a <free+0x97>
  80173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173e:	8b 40 04             	mov    0x4(%eax),%eax
  801741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801744:	8b 12                	mov    (%edx),%edx
  801746:	89 10                	mov    %edx,(%eax)
  801748:	eb 0a                	jmp    801754 <free+0xa1>
  80174a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174d:	8b 00                	mov    (%eax),%eax
  80174f:	a3 40 50 80 00       	mov    %eax,0x805040
  801754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801757:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80175d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801760:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801767:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80176c:	48                   	dec    %eax
  80176d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801772:	83 ec 0c             	sub    $0xc,%esp
  801775:	ff 75 f4             	pushl  -0xc(%ebp)
  801778:	e8 4e 17 00 00       	call   802ecb <insert_sorted_with_merge_freeList>
  80177d:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 38             	sub    $0x38,%esp
  801789:	8b 45 10             	mov    0x10(%ebp),%eax
  80178c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178f:	e8 a6 fc ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  801794:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801798:	75 0a                	jne    8017a4 <smalloc+0x21>
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax
  80179f:	e9 8b 00 00 00       	jmp    80182f <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017a4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	01 d0                	add    %edx,%eax
  8017b3:	48                   	dec    %eax
  8017b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bf:	f7 75 f0             	divl   -0x10(%ebp)
  8017c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c5:	29 d0                	sub    %edx,%eax
  8017c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017d1:	e8 d0 06 00 00       	call   801ea6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	74 11                	je     8017eb <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017da:	83 ec 0c             	sub    $0xc,%esp
  8017dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8017e0:	e8 3b 0d 00 00       	call   802520 <alloc_block_FF>
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8017eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ef:	74 39                	je     80182a <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f4:	8b 40 08             	mov    0x8(%eax),%eax
  8017f7:	89 c2                	mov    %eax,%edx
  8017f9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017fd:	52                   	push   %edx
  8017fe:	50                   	push   %eax
  8017ff:	ff 75 0c             	pushl  0xc(%ebp)
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	e8 21 04 00 00       	call   801c2b <sys_createSharedObject>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801810:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801814:	74 14                	je     80182a <smalloc+0xa7>
  801816:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80181a:	74 0e                	je     80182a <smalloc+0xa7>
  80181c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801820:	74 08                	je     80182a <smalloc+0xa7>
			return (void*) mem_block->sva;
  801822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801825:	8b 40 08             	mov    0x8(%eax),%eax
  801828:	eb 05                	jmp    80182f <smalloc+0xac>
	}
	return NULL;
  80182a:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801837:	e8 fe fb ff ff       	call   80143a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80183c:	83 ec 08             	sub    $0x8,%esp
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	ff 75 08             	pushl  0x8(%ebp)
  801845:	e8 0b 04 00 00       	call   801c55 <sys_getSizeOfSharedObject>
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801850:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801854:	74 76                	je     8018cc <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801856:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80185d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	48                   	dec    %eax
  801866:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801869:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80186c:	ba 00 00 00 00       	mov    $0x0,%edx
  801871:	f7 75 ec             	divl   -0x14(%ebp)
  801874:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801877:	29 d0                	sub    %edx,%eax
  801879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80187c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801883:	e8 1e 06 00 00       	call   801ea6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801888:	85 c0                	test   %eax,%eax
  80188a:	74 11                	je     80189d <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80188c:	83 ec 0c             	sub    $0xc,%esp
  80188f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801892:	e8 89 0c 00 00       	call   802520 <alloc_block_FF>
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80189d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018a1:	74 29                	je     8018cc <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8018a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a6:	8b 40 08             	mov    0x8(%eax),%eax
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	50                   	push   %eax
  8018ad:	ff 75 0c             	pushl  0xc(%ebp)
  8018b0:	ff 75 08             	pushl  0x8(%ebp)
  8018b3:	e8 ba 03 00 00       	call   801c72 <sys_getSharedObject>
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8018be:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8018c2:	74 08                	je     8018cc <sget+0x9b>
				return (void *)mem_block->sva;
  8018c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c7:	8b 40 08             	mov    0x8(%eax),%eax
  8018ca:	eb 05                	jmp    8018d1 <sget+0xa0>
		}
	}
	return NULL;
  8018cc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d9:	e8 5c fb ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018de:	83 ec 04             	sub    $0x4,%esp
  8018e1:	68 c4 43 80 00       	push   $0x8043c4
  8018e6:	68 f7 00 00 00       	push   $0xf7
  8018eb:	68 93 43 80 00       	push   $0x804393
  8018f0:	e8 07 eb ff ff       	call   8003fc <_panic>

008018f5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	68 ec 43 80 00       	push   $0x8043ec
  801903:	68 0b 01 00 00       	push   $0x10b
  801908:	68 93 43 80 00       	push   $0x804393
  80190d:	e8 ea ea ff ff       	call   8003fc <_panic>

00801912 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801918:	83 ec 04             	sub    $0x4,%esp
  80191b:	68 10 44 80 00       	push   $0x804410
  801920:	68 16 01 00 00       	push   $0x116
  801925:	68 93 43 80 00       	push   $0x804393
  80192a:	e8 cd ea ff ff       	call   8003fc <_panic>

0080192f <shrink>:

}
void shrink(uint32 newSize)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	68 10 44 80 00       	push   $0x804410
  80193d:	68 1b 01 00 00       	push   $0x11b
  801942:	68 93 43 80 00       	push   $0x804393
  801947:	e8 b0 ea ff ff       	call   8003fc <_panic>

0080194c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	68 10 44 80 00       	push   $0x804410
  80195a:	68 20 01 00 00       	push   $0x120
  80195f:	68 93 43 80 00       	push   $0x804393
  801964:	e8 93 ea ff ff       	call   8003fc <_panic>

00801969 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	57                   	push   %edi
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
  80196f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801981:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801984:	cd 30                	int    $0x30
  801986:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801989:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5f                   	pop    %edi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    

00801994 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	8b 45 10             	mov    0x10(%ebp),%eax
  80199d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	52                   	push   %edx
  8019ac:	ff 75 0c             	pushl  0xc(%ebp)
  8019af:	50                   	push   %eax
  8019b0:	6a 00                	push   $0x0
  8019b2:	e8 b2 ff ff ff       	call   801969 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	90                   	nop
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 01                	push   $0x1
  8019cc:	e8 98 ff ff ff       	call   801969 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	52                   	push   %edx
  8019e6:	50                   	push   %eax
  8019e7:	6a 05                	push   $0x5
  8019e9:	e8 7b ff ff ff       	call   801969 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	56                   	push   %esi
  8019f7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019f8:	8b 75 18             	mov    0x18(%ebp),%esi
  8019fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	56                   	push   %esi
  801a08:	53                   	push   %ebx
  801a09:	51                   	push   %ecx
  801a0a:	52                   	push   %edx
  801a0b:	50                   	push   %eax
  801a0c:	6a 06                	push   $0x6
  801a0e:	e8 56 ff ff ff       	call   801969 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a19:	5b                   	pop    %ebx
  801a1a:	5e                   	pop    %esi
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    

00801a1d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	52                   	push   %edx
  801a2d:	50                   	push   %eax
  801a2e:	6a 07                	push   $0x7
  801a30:	e8 34 ff ff ff       	call   801969 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	ff 75 08             	pushl  0x8(%ebp)
  801a49:	6a 08                	push   $0x8
  801a4b:	e8 19 ff ff ff       	call   801969 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 09                	push   $0x9
  801a64:	e8 00 ff ff ff       	call   801969 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 0a                	push   $0xa
  801a7d:	e8 e7 fe ff ff       	call   801969 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 0b                	push   $0xb
  801a96:	e8 ce fe ff ff       	call   801969 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	ff 75 0c             	pushl  0xc(%ebp)
  801aac:	ff 75 08             	pushl  0x8(%ebp)
  801aaf:	6a 0f                	push   $0xf
  801ab1:	e8 b3 fe ff ff       	call   801969 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
	return;
  801ab9:	90                   	nop
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	ff 75 08             	pushl  0x8(%ebp)
  801acb:	6a 10                	push   $0x10
  801acd:	e8 97 fe ff ff       	call   801969 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad5:	90                   	nop
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	ff 75 10             	pushl  0x10(%ebp)
  801ae2:	ff 75 0c             	pushl  0xc(%ebp)
  801ae5:	ff 75 08             	pushl  0x8(%ebp)
  801ae8:	6a 11                	push   $0x11
  801aea:	e8 7a fe ff ff       	call   801969 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
	return ;
  801af2:	90                   	nop
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 0c                	push   $0xc
  801b04:	e8 60 fe ff ff       	call   801969 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	ff 75 08             	pushl  0x8(%ebp)
  801b1c:	6a 0d                	push   $0xd
  801b1e:	e8 46 fe ff ff       	call   801969 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 0e                	push   $0xe
  801b37:	e8 2d fe ff ff       	call   801969 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	90                   	nop
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 13                	push   $0x13
  801b51:	e8 13 fe ff ff       	call   801969 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	90                   	nop
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 14                	push   $0x14
  801b6b:	e8 f9 fd ff ff       	call   801969 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 04             	sub    $0x4,%esp
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b82:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	50                   	push   %eax
  801b8f:	6a 15                	push   $0x15
  801b91:	e8 d3 fd ff ff       	call   801969 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	90                   	nop
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 16                	push   $0x16
  801bab:	e8 b9 fd ff ff       	call   801969 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	90                   	nop
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	50                   	push   %eax
  801bc6:	6a 17                	push   $0x17
  801bc8:	e8 9c fd ff ff       	call   801969 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	52                   	push   %edx
  801be2:	50                   	push   %eax
  801be3:	6a 1a                	push   $0x1a
  801be5:	e8 7f fd ff ff       	call   801969 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	52                   	push   %edx
  801bff:	50                   	push   %eax
  801c00:	6a 18                	push   $0x18
  801c02:	e8 62 fd ff ff       	call   801969 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	90                   	nop
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	52                   	push   %edx
  801c1d:	50                   	push   %eax
  801c1e:	6a 19                	push   $0x19
  801c20:	e8 44 fd ff ff       	call   801969 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	90                   	nop
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c37:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c3a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	6a 00                	push   $0x0
  801c43:	51                   	push   %ecx
  801c44:	52                   	push   %edx
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	50                   	push   %eax
  801c49:	6a 1b                	push   $0x1b
  801c4b:	e8 19 fd ff ff       	call   801969 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	52                   	push   %edx
  801c65:	50                   	push   %eax
  801c66:	6a 1c                	push   $0x1c
  801c68:	e8 fc fc ff ff       	call   801969 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	51                   	push   %ecx
  801c83:	52                   	push   %edx
  801c84:	50                   	push   %eax
  801c85:	6a 1d                	push   $0x1d
  801c87:	e8 dd fc ff ff       	call   801969 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	52                   	push   %edx
  801ca1:	50                   	push   %eax
  801ca2:	6a 1e                	push   $0x1e
  801ca4:	e8 c0 fc ff ff       	call   801969 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 1f                	push   $0x1f
  801cbd:	e8 a7 fc ff ff       	call   801969 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	ff 75 14             	pushl  0x14(%ebp)
  801cd2:	ff 75 10             	pushl  0x10(%ebp)
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	50                   	push   %eax
  801cd9:	6a 20                	push   $0x20
  801cdb:	e8 89 fc ff ff       	call   801969 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	50                   	push   %eax
  801cf4:	6a 21                	push   $0x21
  801cf6:	e8 6e fc ff ff       	call   801969 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	90                   	nop
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	50                   	push   %eax
  801d10:	6a 22                	push   $0x22
  801d12:	e8 52 fc ff ff       	call   801969 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 02                	push   $0x2
  801d2b:	e8 39 fc ff ff       	call   801969 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 03                	push   $0x3
  801d44:	e8 20 fc ff ff       	call   801969 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 04                	push   $0x4
  801d5d:	e8 07 fc ff ff       	call   801969 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_exit_env>:


void sys_exit_env(void)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 23                	push   $0x23
  801d76:	e8 ee fb ff ff       	call   801969 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	90                   	nop
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d8a:	8d 50 04             	lea    0x4(%eax),%edx
  801d8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	52                   	push   %edx
  801d97:	50                   	push   %eax
  801d98:	6a 24                	push   $0x24
  801d9a:	e8 ca fb ff ff       	call   801969 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
	return result;
  801da2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801da8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dab:	89 01                	mov    %eax,(%ecx)
  801dad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	c9                   	leave  
  801db4:	c2 04 00             	ret    $0x4

00801db7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	ff 75 10             	pushl  0x10(%ebp)
  801dc1:	ff 75 0c             	pushl  0xc(%ebp)
  801dc4:	ff 75 08             	pushl  0x8(%ebp)
  801dc7:	6a 12                	push   $0x12
  801dc9:	e8 9b fb ff ff       	call   801969 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd1:	90                   	nop
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 25                	push   $0x25
  801de3:	e8 81 fb ff ff       	call   801969 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 04             	sub    $0x4,%esp
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801df9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	50                   	push   %eax
  801e06:	6a 26                	push   $0x26
  801e08:	e8 5c fb ff ff       	call   801969 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e10:	90                   	nop
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <rsttst>:
void rsttst()
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 28                	push   $0x28
  801e22:	e8 42 fb ff ff       	call   801969 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2a:	90                   	nop
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 04             	sub    $0x4,%esp
  801e33:	8b 45 14             	mov    0x14(%ebp),%eax
  801e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e39:	8b 55 18             	mov    0x18(%ebp),%edx
  801e3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e40:	52                   	push   %edx
  801e41:	50                   	push   %eax
  801e42:	ff 75 10             	pushl  0x10(%ebp)
  801e45:	ff 75 0c             	pushl  0xc(%ebp)
  801e48:	ff 75 08             	pushl  0x8(%ebp)
  801e4b:	6a 27                	push   $0x27
  801e4d:	e8 17 fb ff ff       	call   801969 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
	return ;
  801e55:	90                   	nop
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <chktst>:
void chktst(uint32 n)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	6a 29                	push   $0x29
  801e68:	e8 fc fa ff ff       	call   801969 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e70:	90                   	nop
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <inctst>:

void inctst()
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 2a                	push   $0x2a
  801e82:	e8 e2 fa ff ff       	call   801969 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8a:	90                   	nop
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <gettst>:
uint32 gettst()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 2b                	push   $0x2b
  801e9c:	e8 c8 fa ff ff       	call   801969 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 2c                	push   $0x2c
  801eb8:	e8 ac fa ff ff       	call   801969 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
  801ec0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ec3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ec7:	75 07                	jne    801ed0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ec9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ece:	eb 05                	jmp    801ed5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 2c                	push   $0x2c
  801ee9:	e8 7b fa ff ff       	call   801969 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
  801ef1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ef4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ef8:	75 07                	jne    801f01 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801efa:	b8 01 00 00 00       	mov    $0x1,%eax
  801eff:	eb 05                	jmp    801f06 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 2c                	push   $0x2c
  801f1a:	e8 4a fa ff ff       	call   801969 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
  801f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f25:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f29:	75 07                	jne    801f32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f30:	eb 05                	jmp    801f37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 2c                	push   $0x2c
  801f4b:	e8 19 fa ff ff       	call   801969 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
  801f53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f56:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f5a:	75 07                	jne    801f63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f61:	eb 05                	jmp    801f68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	ff 75 08             	pushl  0x8(%ebp)
  801f78:	6a 2d                	push   $0x2d
  801f7a:	e8 ea f9 ff ff       	call   801969 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f82:	90                   	nop
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	53                   	push   %ebx
  801f98:	51                   	push   %ecx
  801f99:	52                   	push   %edx
  801f9a:	50                   	push   %eax
  801f9b:	6a 2e                	push   $0x2e
  801f9d:	e8 c7 f9 ff ff       	call   801969 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	52                   	push   %edx
  801fba:	50                   	push   %eax
  801fbb:	6a 2f                	push   $0x2f
  801fbd:	e8 a7 f9 ff ff       	call   801969 <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	68 20 44 80 00       	push   $0x804420
  801fd5:	e8 d6 e6 ff ff       	call   8006b0 <cprintf>
  801fda:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fdd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	68 4c 44 80 00       	push   $0x80444c
  801fec:	e8 bf e6 ff ff       	call   8006b0 <cprintf>
  801ff1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ff4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ff8:	a1 38 51 80 00       	mov    0x805138,%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802000:	eb 56                	jmp    802058 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802002:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802006:	74 1c                	je     802024 <print_mem_block_lists+0x5d>
  802008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200b:	8b 50 08             	mov    0x8(%eax),%edx
  80200e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802011:	8b 48 08             	mov    0x8(%eax),%ecx
  802014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802017:	8b 40 0c             	mov    0xc(%eax),%eax
  80201a:	01 c8                	add    %ecx,%eax
  80201c:	39 c2                	cmp    %eax,%edx
  80201e:	73 04                	jae    802024 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802020:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	8b 50 08             	mov    0x8(%eax),%edx
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 40 0c             	mov    0xc(%eax),%eax
  802030:	01 c2                	add    %eax,%edx
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	8b 40 08             	mov    0x8(%eax),%eax
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	52                   	push   %edx
  80203c:	50                   	push   %eax
  80203d:	68 61 44 80 00       	push   $0x804461
  802042:	e8 69 e6 ff ff       	call   8006b0 <cprintf>
  802047:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802050:	a1 40 51 80 00       	mov    0x805140,%eax
  802055:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802058:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205c:	74 07                	je     802065 <print_mem_block_lists+0x9e>
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	8b 00                	mov    (%eax),%eax
  802063:	eb 05                	jmp    80206a <print_mem_block_lists+0xa3>
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	a3 40 51 80 00       	mov    %eax,0x805140
  80206f:	a1 40 51 80 00       	mov    0x805140,%eax
  802074:	85 c0                	test   %eax,%eax
  802076:	75 8a                	jne    802002 <print_mem_block_lists+0x3b>
  802078:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207c:	75 84                	jne    802002 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80207e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802082:	75 10                	jne    802094 <print_mem_block_lists+0xcd>
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	68 70 44 80 00       	push   $0x804470
  80208c:	e8 1f e6 ff ff       	call   8006b0 <cprintf>
  802091:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802094:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80209b:	83 ec 0c             	sub    $0xc,%esp
  80209e:	68 94 44 80 00       	push   $0x804494
  8020a3:	e8 08 e6 ff ff       	call   8006b0 <cprintf>
  8020a8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020ab:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020af:	a1 40 50 80 00       	mov    0x805040,%eax
  8020b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b7:	eb 56                	jmp    80210f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020bd:	74 1c                	je     8020db <print_mem_block_lists+0x114>
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 50 08             	mov    0x8(%eax),%edx
  8020c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c8:	8b 48 08             	mov    0x8(%eax),%ecx
  8020cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d1:	01 c8                	add    %ecx,%eax
  8020d3:	39 c2                	cmp    %eax,%edx
  8020d5:	73 04                	jae    8020db <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020d7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	8b 50 08             	mov    0x8(%eax),%edx
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e7:	01 c2                	add    %eax,%edx
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	8b 40 08             	mov    0x8(%eax),%eax
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	52                   	push   %edx
  8020f3:	50                   	push   %eax
  8020f4:	68 61 44 80 00       	push   $0x804461
  8020f9:	e8 b2 e5 ff ff       	call   8006b0 <cprintf>
  8020fe:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802104:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802107:	a1 48 50 80 00       	mov    0x805048,%eax
  80210c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80210f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802113:	74 07                	je     80211c <print_mem_block_lists+0x155>
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	8b 00                	mov    (%eax),%eax
  80211a:	eb 05                	jmp    802121 <print_mem_block_lists+0x15a>
  80211c:	b8 00 00 00 00       	mov    $0x0,%eax
  802121:	a3 48 50 80 00       	mov    %eax,0x805048
  802126:	a1 48 50 80 00       	mov    0x805048,%eax
  80212b:	85 c0                	test   %eax,%eax
  80212d:	75 8a                	jne    8020b9 <print_mem_block_lists+0xf2>
  80212f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802133:	75 84                	jne    8020b9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802135:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802139:	75 10                	jne    80214b <print_mem_block_lists+0x184>
  80213b:	83 ec 0c             	sub    $0xc,%esp
  80213e:	68 ac 44 80 00       	push   $0x8044ac
  802143:	e8 68 e5 ff ff       	call   8006b0 <cprintf>
  802148:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	68 20 44 80 00       	push   $0x804420
  802153:	e8 58 e5 ff ff       	call   8006b0 <cprintf>
  802158:	83 c4 10             	add    $0x10,%esp

}
  80215b:	90                   	nop
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802164:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80216b:	00 00 00 
  80216e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802175:	00 00 00 
  802178:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80217f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802189:	e9 9e 00 00 00       	jmp    80222c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80218e:	a1 50 50 80 00       	mov    0x805050,%eax
  802193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802196:	c1 e2 04             	shl    $0x4,%edx
  802199:	01 d0                	add    %edx,%eax
  80219b:	85 c0                	test   %eax,%eax
  80219d:	75 14                	jne    8021b3 <initialize_MemBlocksList+0x55>
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	68 d4 44 80 00       	push   $0x8044d4
  8021a7:	6a 46                	push   $0x46
  8021a9:	68 f7 44 80 00       	push   $0x8044f7
  8021ae:	e8 49 e2 ff ff       	call   8003fc <_panic>
  8021b3:	a1 50 50 80 00       	mov    0x805050,%eax
  8021b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bb:	c1 e2 04             	shl    $0x4,%edx
  8021be:	01 d0                	add    %edx,%eax
  8021c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021c6:	89 10                	mov    %edx,(%eax)
  8021c8:	8b 00                	mov    (%eax),%eax
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	74 18                	je     8021e6 <initialize_MemBlocksList+0x88>
  8021ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8021d3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021dc:	c1 e1 04             	shl    $0x4,%ecx
  8021df:	01 ca                	add    %ecx,%edx
  8021e1:	89 50 04             	mov    %edx,0x4(%eax)
  8021e4:	eb 12                	jmp    8021f8 <initialize_MemBlocksList+0x9a>
  8021e6:	a1 50 50 80 00       	mov    0x805050,%eax
  8021eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ee:	c1 e2 04             	shl    $0x4,%edx
  8021f1:	01 d0                	add    %edx,%eax
  8021f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021f8:	a1 50 50 80 00       	mov    0x805050,%eax
  8021fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802200:	c1 e2 04             	shl    $0x4,%edx
  802203:	01 d0                	add    %edx,%eax
  802205:	a3 48 51 80 00       	mov    %eax,0x805148
  80220a:	a1 50 50 80 00       	mov    0x805050,%eax
  80220f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802212:	c1 e2 04             	shl    $0x4,%edx
  802215:	01 d0                	add    %edx,%eax
  802217:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80221e:	a1 54 51 80 00       	mov    0x805154,%eax
  802223:	40                   	inc    %eax
  802224:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802229:	ff 45 f4             	incl   -0xc(%ebp)
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802232:	0f 82 56 ff ff ff    	jb     80218e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802238:	90                   	nop
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802249:	eb 19                	jmp    802264 <find_block+0x29>
	{
		if(va==point->sva)
  80224b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224e:	8b 40 08             	mov    0x8(%eax),%eax
  802251:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802254:	75 05                	jne    80225b <find_block+0x20>
		   return point;
  802256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802259:	eb 36                	jmp    802291 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	8b 40 08             	mov    0x8(%eax),%eax
  802261:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802264:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802268:	74 07                	je     802271 <find_block+0x36>
  80226a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80226d:	8b 00                	mov    (%eax),%eax
  80226f:	eb 05                	jmp    802276 <find_block+0x3b>
  802271:	b8 00 00 00 00       	mov    $0x0,%eax
  802276:	8b 55 08             	mov    0x8(%ebp),%edx
  802279:	89 42 08             	mov    %eax,0x8(%edx)
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	8b 40 08             	mov    0x8(%eax),%eax
  802282:	85 c0                	test   %eax,%eax
  802284:	75 c5                	jne    80224b <find_block+0x10>
  802286:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80228a:	75 bf                	jne    80224b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80228c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802299:	a1 40 50 80 00       	mov    0x805040,%eax
  80229e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8022a1:	a1 44 50 80 00       	mov    0x805044,%eax
  8022a6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8022a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022af:	74 24                	je     8022d5 <insert_sorted_allocList+0x42>
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	8b 50 08             	mov    0x8(%eax),%edx
  8022b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ba:	8b 40 08             	mov    0x8(%eax),%eax
  8022bd:	39 c2                	cmp    %eax,%edx
  8022bf:	76 14                	jbe    8022d5 <insert_sorted_allocList+0x42>
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	8b 50 08             	mov    0x8(%eax),%edx
  8022c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ca:	8b 40 08             	mov    0x8(%eax),%eax
  8022cd:	39 c2                	cmp    %eax,%edx
  8022cf:	0f 82 60 01 00 00    	jb     802435 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d9:	75 65                	jne    802340 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022df:	75 14                	jne    8022f5 <insert_sorted_allocList+0x62>
  8022e1:	83 ec 04             	sub    $0x4,%esp
  8022e4:	68 d4 44 80 00       	push   $0x8044d4
  8022e9:	6a 6b                	push   $0x6b
  8022eb:	68 f7 44 80 00       	push   $0x8044f7
  8022f0:	e8 07 e1 ff ff       	call   8003fc <_panic>
  8022f5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	89 10                	mov    %edx,(%eax)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8b 00                	mov    (%eax),%eax
  802305:	85 c0                	test   %eax,%eax
  802307:	74 0d                	je     802316 <insert_sorted_allocList+0x83>
  802309:	a1 40 50 80 00       	mov    0x805040,%eax
  80230e:	8b 55 08             	mov    0x8(%ebp),%edx
  802311:	89 50 04             	mov    %edx,0x4(%eax)
  802314:	eb 08                	jmp    80231e <insert_sorted_allocList+0x8b>
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	a3 44 50 80 00       	mov    %eax,0x805044
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	a3 40 50 80 00       	mov    %eax,0x805040
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802330:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802335:	40                   	inc    %eax
  802336:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80233b:	e9 dc 01 00 00       	jmp    80251c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	8b 50 08             	mov    0x8(%eax),%edx
  802346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802349:	8b 40 08             	mov    0x8(%eax),%eax
  80234c:	39 c2                	cmp    %eax,%edx
  80234e:	77 6c                	ja     8023bc <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802350:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802354:	74 06                	je     80235c <insert_sorted_allocList+0xc9>
  802356:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235a:	75 14                	jne    802370 <insert_sorted_allocList+0xdd>
  80235c:	83 ec 04             	sub    $0x4,%esp
  80235f:	68 10 45 80 00       	push   $0x804510
  802364:	6a 6f                	push   $0x6f
  802366:	68 f7 44 80 00       	push   $0x8044f7
  80236b:	e8 8c e0 ff ff       	call   8003fc <_panic>
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	8b 50 04             	mov    0x4(%eax),%edx
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	89 50 04             	mov    %edx,0x4(%eax)
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802382:	89 10                	mov    %edx,(%eax)
  802384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802387:	8b 40 04             	mov    0x4(%eax),%eax
  80238a:	85 c0                	test   %eax,%eax
  80238c:	74 0d                	je     80239b <insert_sorted_allocList+0x108>
  80238e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802391:	8b 40 04             	mov    0x4(%eax),%eax
  802394:	8b 55 08             	mov    0x8(%ebp),%edx
  802397:	89 10                	mov    %edx,(%eax)
  802399:	eb 08                	jmp    8023a3 <insert_sorted_allocList+0x110>
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	a3 40 50 80 00       	mov    %eax,0x805040
  8023a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a9:	89 50 04             	mov    %edx,0x4(%eax)
  8023ac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023b1:	40                   	inc    %eax
  8023b2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023b7:	e9 60 01 00 00       	jmp    80251c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	8b 50 08             	mov    0x8(%eax),%edx
  8023c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c5:	8b 40 08             	mov    0x8(%eax),%eax
  8023c8:	39 c2                	cmp    %eax,%edx
  8023ca:	0f 82 4c 01 00 00    	jb     80251c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d4:	75 14                	jne    8023ea <insert_sorted_allocList+0x157>
  8023d6:	83 ec 04             	sub    $0x4,%esp
  8023d9:	68 48 45 80 00       	push   $0x804548
  8023de:	6a 73                	push   $0x73
  8023e0:	68 f7 44 80 00       	push   $0x8044f7
  8023e5:	e8 12 e0 ff ff       	call   8003fc <_panic>
  8023ea:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	89 50 04             	mov    %edx,0x4(%eax)
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	8b 40 04             	mov    0x4(%eax),%eax
  8023fc:	85 c0                	test   %eax,%eax
  8023fe:	74 0c                	je     80240c <insert_sorted_allocList+0x179>
  802400:	a1 44 50 80 00       	mov    0x805044,%eax
  802405:	8b 55 08             	mov    0x8(%ebp),%edx
  802408:	89 10                	mov    %edx,(%eax)
  80240a:	eb 08                	jmp    802414 <insert_sorted_allocList+0x181>
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	a3 40 50 80 00       	mov    %eax,0x805040
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	a3 44 50 80 00       	mov    %eax,0x805044
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802425:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80242a:	40                   	inc    %eax
  80242b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802430:	e9 e7 00 00 00       	jmp    80251c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802438:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80243b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802442:	a1 40 50 80 00       	mov    0x805040,%eax
  802447:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244a:	e9 9d 00 00 00       	jmp    8024ec <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 00                	mov    (%eax),%eax
  802454:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	8b 50 08             	mov    0x8(%eax),%edx
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 40 08             	mov    0x8(%eax),%eax
  802463:	39 c2                	cmp    %eax,%edx
  802465:	76 7d                	jbe    8024e4 <insert_sorted_allocList+0x251>
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	8b 50 08             	mov    0x8(%eax),%edx
  80246d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802470:	8b 40 08             	mov    0x8(%eax),%eax
  802473:	39 c2                	cmp    %eax,%edx
  802475:	73 6d                	jae    8024e4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247b:	74 06                	je     802483 <insert_sorted_allocList+0x1f0>
  80247d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802481:	75 14                	jne    802497 <insert_sorted_allocList+0x204>
  802483:	83 ec 04             	sub    $0x4,%esp
  802486:	68 6c 45 80 00       	push   $0x80456c
  80248b:	6a 7f                	push   $0x7f
  80248d:	68 f7 44 80 00       	push   $0x8044f7
  802492:	e8 65 df ff ff       	call   8003fc <_panic>
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 10                	mov    (%eax),%edx
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	89 10                	mov    %edx,(%eax)
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	74 0b                	je     8024b5 <insert_sorted_allocList+0x222>
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b2:	89 50 04             	mov    %edx,0x4(%eax)
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bb:	89 10                	mov    %edx,(%eax)
  8024bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c3:	89 50 04             	mov    %edx,0x4(%eax)
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	8b 00                	mov    (%eax),%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	75 08                	jne    8024d7 <insert_sorted_allocList+0x244>
  8024cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d2:	a3 44 50 80 00       	mov    %eax,0x805044
  8024d7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024dc:	40                   	inc    %eax
  8024dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024e2:	eb 39                	jmp    80251d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024e4:	a1 48 50 80 00       	mov    0x805048,%eax
  8024e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f0:	74 07                	je     8024f9 <insert_sorted_allocList+0x266>
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	eb 05                	jmp    8024fe <insert_sorted_allocList+0x26b>
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fe:	a3 48 50 80 00       	mov    %eax,0x805048
  802503:	a1 48 50 80 00       	mov    0x805048,%eax
  802508:	85 c0                	test   %eax,%eax
  80250a:	0f 85 3f ff ff ff    	jne    80244f <insert_sorted_allocList+0x1bc>
  802510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802514:	0f 85 35 ff ff ff    	jne    80244f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80251a:	eb 01                	jmp    80251d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80251c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80251d:	90                   	nop
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802526:	a1 38 51 80 00       	mov    0x805138,%eax
  80252b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252e:	e9 85 01 00 00       	jmp    8026b8 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 0c             	mov    0xc(%eax),%eax
  802539:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253c:	0f 82 6e 01 00 00    	jb     8026b0 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 0c             	mov    0xc(%eax),%eax
  802548:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254b:	0f 85 8a 00 00 00    	jne    8025db <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	75 17                	jne    80256e <alloc_block_FF+0x4e>
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 a0 45 80 00       	push   $0x8045a0
  80255f:	68 93 00 00 00       	push   $0x93
  802564:	68 f7 44 80 00       	push   $0x8044f7
  802569:	e8 8e de ff ff       	call   8003fc <_panic>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 00                	mov    (%eax),%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 10                	je     802587 <alloc_block_FF+0x67>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257f:	8b 52 04             	mov    0x4(%edx),%edx
  802582:	89 50 04             	mov    %edx,0x4(%eax)
  802585:	eb 0b                	jmp    802592 <alloc_block_FF+0x72>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 0f                	je     8025ab <alloc_block_FF+0x8b>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a5:	8b 12                	mov    (%edx),%edx
  8025a7:	89 10                	mov    %edx,(%eax)
  8025a9:	eb 0a                	jmp    8025b5 <alloc_block_FF+0x95>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8025cd:	48                   	dec    %eax
  8025ce:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	e9 10 01 00 00       	jmp    8026eb <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e4:	0f 86 c6 00 00 00    	jbe    8026b0 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8025ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 50 08             	mov    0x8(%eax),%edx
  8025f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fb:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802601:	8b 55 08             	mov    0x8(%ebp),%edx
  802604:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80260b:	75 17                	jne    802624 <alloc_block_FF+0x104>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 a0 45 80 00       	push   $0x8045a0
  802615:	68 9b 00 00 00       	push   $0x9b
  80261a:	68 f7 44 80 00       	push   $0x8044f7
  80261f:	e8 d8 dd ff ff       	call   8003fc <_panic>
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	8b 00                	mov    (%eax),%eax
  802629:	85 c0                	test   %eax,%eax
  80262b:	74 10                	je     80263d <alloc_block_FF+0x11d>
  80262d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802635:	8b 52 04             	mov    0x4(%edx),%edx
  802638:	89 50 04             	mov    %edx,0x4(%eax)
  80263b:	eb 0b                	jmp    802648 <alloc_block_FF+0x128>
  80263d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802640:	8b 40 04             	mov    0x4(%eax),%eax
  802643:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	74 0f                	je     802661 <alloc_block_FF+0x141>
  802652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802655:	8b 40 04             	mov    0x4(%eax),%eax
  802658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80265b:	8b 12                	mov    (%edx),%edx
  80265d:	89 10                	mov    %edx,(%eax)
  80265f:	eb 0a                	jmp    80266b <alloc_block_FF+0x14b>
  802661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	a3 48 51 80 00       	mov    %eax,0x805148
  80266b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802677:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267e:	a1 54 51 80 00       	mov    0x805154,%eax
  802683:	48                   	dec    %eax
  802684:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 50 08             	mov    0x8(%eax),%edx
  80268f:	8b 45 08             	mov    0x8(%ebp),%eax
  802692:	01 c2                	add    %eax,%edx
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a3:	89 c2                	mov    %eax,%edx
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	eb 3b                	jmp    8026eb <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8026b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bc:	74 07                	je     8026c5 <alloc_block_FF+0x1a5>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	eb 05                	jmp    8026ca <alloc_block_FF+0x1aa>
  8026c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8026cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	0f 85 57 fe ff ff    	jne    802533 <alloc_block_FF+0x13>
  8026dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e0:	0f 85 4d fe ff ff    	jne    802533 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802702:	e9 df 00 00 00       	jmp    8027e6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 40 0c             	mov    0xc(%eax),%eax
  80270d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802710:	0f 82 c8 00 00 00    	jb     8027de <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 40 0c             	mov    0xc(%eax),%eax
  80271c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80271f:	0f 85 8a 00 00 00    	jne    8027af <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802725:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802729:	75 17                	jne    802742 <alloc_block_BF+0x55>
  80272b:	83 ec 04             	sub    $0x4,%esp
  80272e:	68 a0 45 80 00       	push   $0x8045a0
  802733:	68 b7 00 00 00       	push   $0xb7
  802738:	68 f7 44 80 00       	push   $0x8044f7
  80273d:	e8 ba dc ff ff       	call   8003fc <_panic>
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	74 10                	je     80275b <alloc_block_BF+0x6e>
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802753:	8b 52 04             	mov    0x4(%edx),%edx
  802756:	89 50 04             	mov    %edx,0x4(%eax)
  802759:	eb 0b                	jmp    802766 <alloc_block_BF+0x79>
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 40 04             	mov    0x4(%eax),%eax
  802761:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	74 0f                	je     80277f <alloc_block_BF+0x92>
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 04             	mov    0x4(%eax),%eax
  802776:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802779:	8b 12                	mov    (%edx),%edx
  80277b:	89 10                	mov    %edx,(%eax)
  80277d:	eb 0a                	jmp    802789 <alloc_block_BF+0x9c>
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	a3 38 51 80 00       	mov    %eax,0x805138
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279c:	a1 44 51 80 00       	mov    0x805144,%eax
  8027a1:	48                   	dec    %eax
  8027a2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	e9 4d 01 00 00       	jmp    8028fc <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b8:	76 24                	jbe    8027de <alloc_block_BF+0xf1>
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027c3:	73 19                	jae    8027de <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8027c5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 08             	mov    0x8(%eax),%eax
  8027db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027de:	a1 40 51 80 00       	mov    0x805140,%eax
  8027e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ea:	74 07                	je     8027f3 <alloc_block_BF+0x106>
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 00                	mov    (%eax),%eax
  8027f1:	eb 05                	jmp    8027f8 <alloc_block_BF+0x10b>
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8027fd:	a1 40 51 80 00       	mov    0x805140,%eax
  802802:	85 c0                	test   %eax,%eax
  802804:	0f 85 fd fe ff ff    	jne    802707 <alloc_block_BF+0x1a>
  80280a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280e:	0f 85 f3 fe ff ff    	jne    802707 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802814:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802818:	0f 84 d9 00 00 00    	je     8028f7 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80281e:	a1 48 51 80 00       	mov    0x805148,%eax
  802823:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802829:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80282c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80282f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802832:	8b 55 08             	mov    0x8(%ebp),%edx
  802835:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802838:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80283c:	75 17                	jne    802855 <alloc_block_BF+0x168>
  80283e:	83 ec 04             	sub    $0x4,%esp
  802841:	68 a0 45 80 00       	push   $0x8045a0
  802846:	68 c7 00 00 00       	push   $0xc7
  80284b:	68 f7 44 80 00       	push   $0x8044f7
  802850:	e8 a7 db ff ff       	call   8003fc <_panic>
  802855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	74 10                	je     80286e <alloc_block_BF+0x181>
  80285e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802861:	8b 00                	mov    (%eax),%eax
  802863:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802866:	8b 52 04             	mov    0x4(%edx),%edx
  802869:	89 50 04             	mov    %edx,0x4(%eax)
  80286c:	eb 0b                	jmp    802879 <alloc_block_BF+0x18c>
  80286e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802871:	8b 40 04             	mov    0x4(%eax),%eax
  802874:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287c:	8b 40 04             	mov    0x4(%eax),%eax
  80287f:	85 c0                	test   %eax,%eax
  802881:	74 0f                	je     802892 <alloc_block_BF+0x1a5>
  802883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802886:	8b 40 04             	mov    0x4(%eax),%eax
  802889:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80288c:	8b 12                	mov    (%edx),%edx
  80288e:	89 10                	mov    %edx,(%eax)
  802890:	eb 0a                	jmp    80289c <alloc_block_BF+0x1af>
  802892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	a3 48 51 80 00       	mov    %eax,0x805148
  80289c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028af:	a1 54 51 80 00       	mov    0x805154,%eax
  8028b4:	48                   	dec    %eax
  8028b5:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028ba:	83 ec 08             	sub    $0x8,%esp
  8028bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8028c0:	68 38 51 80 00       	push   $0x805138
  8028c5:	e8 71 f9 ff ff       	call   80223b <find_block>
  8028ca:	83 c4 10             	add    $0x10,%esp
  8028cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d3:	8b 50 08             	mov    0x8(%eax),%edx
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	01 c2                	add    %eax,%edx
  8028db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028de:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e7:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ea:	89 c2                	mov    %eax,%edx
  8028ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ef:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f5:	eb 05                	jmp    8028fc <alloc_block_BF+0x20f>
	}
	return NULL;
  8028f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028fc:	c9                   	leave  
  8028fd:	c3                   	ret    

008028fe <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028fe:	55                   	push   %ebp
  8028ff:	89 e5                	mov    %esp,%ebp
  802901:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802904:	a1 28 50 80 00       	mov    0x805028,%eax
  802909:	85 c0                	test   %eax,%eax
  80290b:	0f 85 de 01 00 00    	jne    802aef <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802911:	a1 38 51 80 00       	mov    0x805138,%eax
  802916:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802919:	e9 9e 01 00 00       	jmp    802abc <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	3b 45 08             	cmp    0x8(%ebp),%eax
  802927:	0f 82 87 01 00 00    	jb     802ab4 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 40 0c             	mov    0xc(%eax),%eax
  802933:	3b 45 08             	cmp    0x8(%ebp),%eax
  802936:	0f 85 95 00 00 00    	jne    8029d1 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80293c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802940:	75 17                	jne    802959 <alloc_block_NF+0x5b>
  802942:	83 ec 04             	sub    $0x4,%esp
  802945:	68 a0 45 80 00       	push   $0x8045a0
  80294a:	68 e0 00 00 00       	push   $0xe0
  80294f:	68 f7 44 80 00       	push   $0x8044f7
  802954:	e8 a3 da ff ff       	call   8003fc <_panic>
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	74 10                	je     802972 <alloc_block_NF+0x74>
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296a:	8b 52 04             	mov    0x4(%edx),%edx
  80296d:	89 50 04             	mov    %edx,0x4(%eax)
  802970:	eb 0b                	jmp    80297d <alloc_block_NF+0x7f>
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 40 04             	mov    0x4(%eax),%eax
  802983:	85 c0                	test   %eax,%eax
  802985:	74 0f                	je     802996 <alloc_block_NF+0x98>
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 40 04             	mov    0x4(%eax),%eax
  80298d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802990:	8b 12                	mov    (%edx),%edx
  802992:	89 10                	mov    %edx,(%eax)
  802994:	eb 0a                	jmp    8029a0 <alloc_block_NF+0xa2>
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 00                	mov    (%eax),%eax
  80299b:	a3 38 51 80 00       	mov    %eax,0x805138
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b8:	48                   	dec    %eax
  8029b9:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 40 08             	mov    0x8(%eax),%eax
  8029c4:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	e9 f8 04 00 00       	jmp    802ec9 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029da:	0f 86 d4 00 00 00    	jbe    802ab4 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8029e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 50 08             	mov    0x8(%eax),%edx
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fa:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a01:	75 17                	jne    802a1a <alloc_block_NF+0x11c>
  802a03:	83 ec 04             	sub    $0x4,%esp
  802a06:	68 a0 45 80 00       	push   $0x8045a0
  802a0b:	68 e9 00 00 00       	push   $0xe9
  802a10:	68 f7 44 80 00       	push   $0x8044f7
  802a15:	e8 e2 d9 ff ff       	call   8003fc <_panic>
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	8b 00                	mov    (%eax),%eax
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	74 10                	je     802a33 <alloc_block_NF+0x135>
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a2b:	8b 52 04             	mov    0x4(%edx),%edx
  802a2e:	89 50 04             	mov    %edx,0x4(%eax)
  802a31:	eb 0b                	jmp    802a3e <alloc_block_NF+0x140>
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	8b 40 04             	mov    0x4(%eax),%eax
  802a39:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a41:	8b 40 04             	mov    0x4(%eax),%eax
  802a44:	85 c0                	test   %eax,%eax
  802a46:	74 0f                	je     802a57 <alloc_block_NF+0x159>
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	8b 40 04             	mov    0x4(%eax),%eax
  802a4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a51:	8b 12                	mov    (%edx),%edx
  802a53:	89 10                	mov    %edx,(%eax)
  802a55:	eb 0a                	jmp    802a61 <alloc_block_NF+0x163>
  802a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	a3 48 51 80 00       	mov    %eax,0x805148
  802a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a74:	a1 54 51 80 00       	mov    0x805154,%eax
  802a79:	48                   	dec    %eax
  802a7a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a82:	8b 40 08             	mov    0x8(%eax),%eax
  802a85:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	8b 50 08             	mov    0x8(%eax),%edx
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	01 c2                	add    %eax,%edx
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa1:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa4:	89 c2                	mov    %eax,%edx
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaf:	e9 15 04 00 00       	jmp    802ec9 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ab4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac0:	74 07                	je     802ac9 <alloc_block_NF+0x1cb>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	eb 05                	jmp    802ace <alloc_block_NF+0x1d0>
  802ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ace:	a3 40 51 80 00       	mov    %eax,0x805140
  802ad3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	0f 85 3e fe ff ff    	jne    80291e <alloc_block_NF+0x20>
  802ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae4:	0f 85 34 fe ff ff    	jne    80291e <alloc_block_NF+0x20>
  802aea:	e9 d5 03 00 00       	jmp    802ec4 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aef:	a1 38 51 80 00       	mov    0x805138,%eax
  802af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af7:	e9 b1 01 00 00       	jmp    802cad <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 50 08             	mov    0x8(%eax),%edx
  802b02:	a1 28 50 80 00       	mov    0x805028,%eax
  802b07:	39 c2                	cmp    %eax,%edx
  802b09:	0f 82 96 01 00 00    	jb     802ca5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 0c             	mov    0xc(%eax),%eax
  802b15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b18:	0f 82 87 01 00 00    	jb     802ca5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 40 0c             	mov    0xc(%eax),%eax
  802b24:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b27:	0f 85 95 00 00 00    	jne    802bc2 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b31:	75 17                	jne    802b4a <alloc_block_NF+0x24c>
  802b33:	83 ec 04             	sub    $0x4,%esp
  802b36:	68 a0 45 80 00       	push   $0x8045a0
  802b3b:	68 fc 00 00 00       	push   $0xfc
  802b40:	68 f7 44 80 00       	push   $0x8044f7
  802b45:	e8 b2 d8 ff ff       	call   8003fc <_panic>
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	85 c0                	test   %eax,%eax
  802b51:	74 10                	je     802b63 <alloc_block_NF+0x265>
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5b:	8b 52 04             	mov    0x4(%edx),%edx
  802b5e:	89 50 04             	mov    %edx,0x4(%eax)
  802b61:	eb 0b                	jmp    802b6e <alloc_block_NF+0x270>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 40 04             	mov    0x4(%eax),%eax
  802b74:	85 c0                	test   %eax,%eax
  802b76:	74 0f                	je     802b87 <alloc_block_NF+0x289>
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 40 04             	mov    0x4(%eax),%eax
  802b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b81:	8b 12                	mov    (%edx),%edx
  802b83:	89 10                	mov    %edx,(%eax)
  802b85:	eb 0a                	jmp    802b91 <alloc_block_NF+0x293>
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	a3 38 51 80 00       	mov    %eax,0x805138
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba9:	48                   	dec    %eax
  802baa:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 40 08             	mov    0x8(%eax),%eax
  802bb5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	e9 07 03 00 00       	jmp    802ec9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bcb:	0f 86 d4 00 00 00    	jbe    802ca5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bd1:	a1 48 51 80 00       	mov    0x805148,%eax
  802bd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 50 08             	mov    0x8(%eax),%edx
  802bdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be8:	8b 55 08             	mov    0x8(%ebp),%edx
  802beb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bf2:	75 17                	jne    802c0b <alloc_block_NF+0x30d>
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	68 a0 45 80 00       	push   $0x8045a0
  802bfc:	68 04 01 00 00       	push   $0x104
  802c01:	68 f7 44 80 00       	push   $0x8044f7
  802c06:	e8 f1 d7 ff ff       	call   8003fc <_panic>
  802c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	74 10                	je     802c24 <alloc_block_NF+0x326>
  802c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c1c:	8b 52 04             	mov    0x4(%edx),%edx
  802c1f:	89 50 04             	mov    %edx,0x4(%eax)
  802c22:	eb 0b                	jmp    802c2f <alloc_block_NF+0x331>
  802c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c27:	8b 40 04             	mov    0x4(%eax),%eax
  802c2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	74 0f                	je     802c48 <alloc_block_NF+0x34a>
  802c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c42:	8b 12                	mov    (%edx),%edx
  802c44:	89 10                	mov    %edx,(%eax)
  802c46:	eb 0a                	jmp    802c52 <alloc_block_NF+0x354>
  802c48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	a3 48 51 80 00       	mov    %eax,0x805148
  802c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c65:	a1 54 51 80 00       	mov    0x805154,%eax
  802c6a:	48                   	dec    %eax
  802c6b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c73:	8b 40 08             	mov    0x8(%eax),%eax
  802c76:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 50 08             	mov    0x8(%eax),%edx
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	01 c2                	add    %eax,%edx
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c92:	2b 45 08             	sub    0x8(%ebp),%eax
  802c95:	89 c2                	mov    %eax,%edx
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca0:	e9 24 02 00 00       	jmp    802ec9 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ca5:	a1 40 51 80 00       	mov    0x805140,%eax
  802caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb1:	74 07                	je     802cba <alloc_block_NF+0x3bc>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	eb 05                	jmp    802cbf <alloc_block_NF+0x3c1>
  802cba:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbf:	a3 40 51 80 00       	mov    %eax,0x805140
  802cc4:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	0f 85 2b fe ff ff    	jne    802afc <alloc_block_NF+0x1fe>
  802cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd5:	0f 85 21 fe ff ff    	jne    802afc <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cdb:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce3:	e9 ae 01 00 00       	jmp    802e96 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 50 08             	mov    0x8(%eax),%edx
  802cee:	a1 28 50 80 00       	mov    0x805028,%eax
  802cf3:	39 c2                	cmp    %eax,%edx
  802cf5:	0f 83 93 01 00 00    	jae    802e8e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802d01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d04:	0f 82 84 01 00 00    	jb     802e8e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d13:	0f 85 95 00 00 00    	jne    802dae <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1d:	75 17                	jne    802d36 <alloc_block_NF+0x438>
  802d1f:	83 ec 04             	sub    $0x4,%esp
  802d22:	68 a0 45 80 00       	push   $0x8045a0
  802d27:	68 14 01 00 00       	push   $0x114
  802d2c:	68 f7 44 80 00       	push   $0x8044f7
  802d31:	e8 c6 d6 ff ff       	call   8003fc <_panic>
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	74 10                	je     802d4f <alloc_block_NF+0x451>
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d47:	8b 52 04             	mov    0x4(%edx),%edx
  802d4a:	89 50 04             	mov    %edx,0x4(%eax)
  802d4d:	eb 0b                	jmp    802d5a <alloc_block_NF+0x45c>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 40 04             	mov    0x4(%eax),%eax
  802d55:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 40 04             	mov    0x4(%eax),%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	74 0f                	je     802d73 <alloc_block_NF+0x475>
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 40 04             	mov    0x4(%eax),%eax
  802d6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6d:	8b 12                	mov    (%edx),%edx
  802d6f:	89 10                	mov    %edx,(%eax)
  802d71:	eb 0a                	jmp    802d7d <alloc_block_NF+0x47f>
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 00                	mov    (%eax),%eax
  802d78:	a3 38 51 80 00       	mov    %eax,0x805138
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d90:	a1 44 51 80 00       	mov    0x805144,%eax
  802d95:	48                   	dec    %eax
  802d96:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 40 08             	mov    0x8(%eax),%eax
  802da1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	e9 1b 01 00 00       	jmp    802ec9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 40 0c             	mov    0xc(%eax),%eax
  802db4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802db7:	0f 86 d1 00 00 00    	jbe    802e8e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dbd:	a1 48 51 80 00       	mov    0x805148,%eax
  802dc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 50 08             	mov    0x8(%eax),%edx
  802dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dce:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dde:	75 17                	jne    802df7 <alloc_block_NF+0x4f9>
  802de0:	83 ec 04             	sub    $0x4,%esp
  802de3:	68 a0 45 80 00       	push   $0x8045a0
  802de8:	68 1c 01 00 00       	push   $0x11c
  802ded:	68 f7 44 80 00       	push   $0x8044f7
  802df2:	e8 05 d6 ff ff       	call   8003fc <_panic>
  802df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	85 c0                	test   %eax,%eax
  802dfe:	74 10                	je     802e10 <alloc_block_NF+0x512>
  802e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e08:	8b 52 04             	mov    0x4(%edx),%edx
  802e0b:	89 50 04             	mov    %edx,0x4(%eax)
  802e0e:	eb 0b                	jmp    802e1b <alloc_block_NF+0x51d>
  802e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1e:	8b 40 04             	mov    0x4(%eax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	74 0f                	je     802e34 <alloc_block_NF+0x536>
  802e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e2e:	8b 12                	mov    (%edx),%edx
  802e30:	89 10                	mov    %edx,(%eax)
  802e32:	eb 0a                	jmp    802e3e <alloc_block_NF+0x540>
  802e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	a3 48 51 80 00       	mov    %eax,0x805148
  802e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e51:	a1 54 51 80 00       	mov    0x805154,%eax
  802e56:	48                   	dec    %eax
  802e57:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5f:	8b 40 08             	mov    0x8(%eax),%eax
  802e62:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 50 08             	mov    0x8(%eax),%edx
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	01 c2                	add    %eax,%edx
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7e:	2b 45 08             	sub    0x8(%ebp),%eax
  802e81:	89 c2                	mov    %eax,%edx
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8c:	eb 3b                	jmp    802ec9 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e8e:	a1 40 51 80 00       	mov    0x805140,%eax
  802e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9a:	74 07                	je     802ea3 <alloc_block_NF+0x5a5>
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 00                	mov    (%eax),%eax
  802ea1:	eb 05                	jmp    802ea8 <alloc_block_NF+0x5aa>
  802ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea8:	a3 40 51 80 00       	mov    %eax,0x805140
  802ead:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	0f 85 2e fe ff ff    	jne    802ce8 <alloc_block_NF+0x3ea>
  802eba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebe:	0f 85 24 fe ff ff    	jne    802ce8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ec9:	c9                   	leave  
  802eca:	c3                   	ret    

00802ecb <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ecb:	55                   	push   %ebp
  802ecc:	89 e5                	mov    %esp,%ebp
  802ece:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ed1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ed9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ede:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ee1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 14                	je     802efe <insert_sorted_with_merge_freeList+0x33>
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	8b 50 08             	mov    0x8(%eax),%edx
  802ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef3:	8b 40 08             	mov    0x8(%eax),%eax
  802ef6:	39 c2                	cmp    %eax,%edx
  802ef8:	0f 87 9b 01 00 00    	ja     803099 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802efe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f02:	75 17                	jne    802f1b <insert_sorted_with_merge_freeList+0x50>
  802f04:	83 ec 04             	sub    $0x4,%esp
  802f07:	68 d4 44 80 00       	push   $0x8044d4
  802f0c:	68 38 01 00 00       	push   $0x138
  802f11:	68 f7 44 80 00       	push   $0x8044f7
  802f16:	e8 e1 d4 ff ff       	call   8003fc <_panic>
  802f1b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	89 10                	mov    %edx,(%eax)
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	85 c0                	test   %eax,%eax
  802f2d:	74 0d                	je     802f3c <insert_sorted_with_merge_freeList+0x71>
  802f2f:	a1 38 51 80 00       	mov    0x805138,%eax
  802f34:	8b 55 08             	mov    0x8(%ebp),%edx
  802f37:	89 50 04             	mov    %edx,0x4(%eax)
  802f3a:	eb 08                	jmp    802f44 <insert_sorted_with_merge_freeList+0x79>
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	a3 38 51 80 00       	mov    %eax,0x805138
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f56:	a1 44 51 80 00       	mov    0x805144,%eax
  802f5b:	40                   	inc    %eax
  802f5c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f65:	0f 84 a8 06 00 00    	je     803613 <insert_sorted_with_merge_freeList+0x748>
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	01 c2                	add    %eax,%edx
  802f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7c:	8b 40 08             	mov    0x8(%eax),%eax
  802f7f:	39 c2                	cmp    %eax,%edx
  802f81:	0f 85 8c 06 00 00    	jne    803613 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f90:	8b 40 0c             	mov    0xc(%eax),%eax
  802f93:	01 c2                	add    %eax,%edx
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f9f:	75 17                	jne    802fb8 <insert_sorted_with_merge_freeList+0xed>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 a0 45 80 00       	push   $0x8045a0
  802fa9:	68 3c 01 00 00       	push   $0x13c
  802fae:	68 f7 44 80 00       	push   $0x8044f7
  802fb3:	e8 44 d4 ff ff       	call   8003fc <_panic>
  802fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	74 10                	je     802fd1 <insert_sorted_with_merge_freeList+0x106>
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc9:	8b 52 04             	mov    0x4(%edx),%edx
  802fcc:	89 50 04             	mov    %edx,0x4(%eax)
  802fcf:	eb 0b                	jmp    802fdc <insert_sorted_with_merge_freeList+0x111>
  802fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 0f                	je     802ff5 <insert_sorted_with_merge_freeList+0x12a>
  802fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe9:	8b 40 04             	mov    0x4(%eax),%eax
  802fec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fef:	8b 12                	mov    (%edx),%edx
  802ff1:	89 10                	mov    %edx,(%eax)
  802ff3:	eb 0a                	jmp    802fff <insert_sorted_with_merge_freeList+0x134>
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	a3 38 51 80 00       	mov    %eax,0x805138
  802fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803002:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803012:	a1 44 51 80 00       	mov    0x805144,%eax
  803017:	48                   	dec    %eax
  803018:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80301d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803020:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803031:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803035:	75 17                	jne    80304e <insert_sorted_with_merge_freeList+0x183>
  803037:	83 ec 04             	sub    $0x4,%esp
  80303a:	68 d4 44 80 00       	push   $0x8044d4
  80303f:	68 3f 01 00 00       	push   $0x13f
  803044:	68 f7 44 80 00       	push   $0x8044f7
  803049:	e8 ae d3 ff ff       	call   8003fc <_panic>
  80304e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803057:	89 10                	mov    %edx,(%eax)
  803059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 0d                	je     80306f <insert_sorted_with_merge_freeList+0x1a4>
  803062:	a1 48 51 80 00       	mov    0x805148,%eax
  803067:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80306a:	89 50 04             	mov    %edx,0x4(%eax)
  80306d:	eb 08                	jmp    803077 <insert_sorted_with_merge_freeList+0x1ac>
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307a:	a3 48 51 80 00       	mov    %eax,0x805148
  80307f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803082:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803089:	a1 54 51 80 00       	mov    0x805154,%eax
  80308e:	40                   	inc    %eax
  80308f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803094:	e9 7a 05 00 00       	jmp    803613 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	8b 50 08             	mov    0x8(%eax),%edx
  80309f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a2:	8b 40 08             	mov    0x8(%eax),%eax
  8030a5:	39 c2                	cmp    %eax,%edx
  8030a7:	0f 82 14 01 00 00    	jb     8031c1 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8030ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b0:	8b 50 08             	mov    0x8(%eax),%edx
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b9:	01 c2                	add    %eax,%edx
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	8b 40 08             	mov    0x8(%eax),%eax
  8030c1:	39 c2                	cmp    %eax,%edx
  8030c3:	0f 85 90 00 00 00    	jne    803159 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d5:	01 c2                	add    %eax,%edx
  8030d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030da:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f5:	75 17                	jne    80310e <insert_sorted_with_merge_freeList+0x243>
  8030f7:	83 ec 04             	sub    $0x4,%esp
  8030fa:	68 d4 44 80 00       	push   $0x8044d4
  8030ff:	68 49 01 00 00       	push   $0x149
  803104:	68 f7 44 80 00       	push   $0x8044f7
  803109:	e8 ee d2 ff ff       	call   8003fc <_panic>
  80310e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	89 10                	mov    %edx,(%eax)
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	74 0d                	je     80312f <insert_sorted_with_merge_freeList+0x264>
  803122:	a1 48 51 80 00       	mov    0x805148,%eax
  803127:	8b 55 08             	mov    0x8(%ebp),%edx
  80312a:	89 50 04             	mov    %edx,0x4(%eax)
  80312d:	eb 08                	jmp    803137 <insert_sorted_with_merge_freeList+0x26c>
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	a3 48 51 80 00       	mov    %eax,0x805148
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803149:	a1 54 51 80 00       	mov    0x805154,%eax
  80314e:	40                   	inc    %eax
  80314f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803154:	e9 bb 04 00 00       	jmp    803614 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803159:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315d:	75 17                	jne    803176 <insert_sorted_with_merge_freeList+0x2ab>
  80315f:	83 ec 04             	sub    $0x4,%esp
  803162:	68 48 45 80 00       	push   $0x804548
  803167:	68 4c 01 00 00       	push   $0x14c
  80316c:	68 f7 44 80 00       	push   $0x8044f7
  803171:	e8 86 d2 ff ff       	call   8003fc <_panic>
  803176:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	89 50 04             	mov    %edx,0x4(%eax)
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	8b 40 04             	mov    0x4(%eax),%eax
  803188:	85 c0                	test   %eax,%eax
  80318a:	74 0c                	je     803198 <insert_sorted_with_merge_freeList+0x2cd>
  80318c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803191:	8b 55 08             	mov    0x8(%ebp),%edx
  803194:	89 10                	mov    %edx,(%eax)
  803196:	eb 08                	jmp    8031a0 <insert_sorted_with_merge_freeList+0x2d5>
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b6:	40                   	inc    %eax
  8031b7:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031bc:	e9 53 04 00 00       	jmp    803614 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031c1:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c9:	e9 15 04 00 00       	jmp    8035e3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d9:	8b 50 08             	mov    0x8(%eax),%edx
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 40 08             	mov    0x8(%eax),%eax
  8031e2:	39 c2                	cmp    %eax,%edx
  8031e4:	0f 86 f1 03 00 00    	jbe    8035db <insert_sorted_with_merge_freeList+0x710>
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	8b 50 08             	mov    0x8(%eax),%edx
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	8b 40 08             	mov    0x8(%eax),%eax
  8031f6:	39 c2                	cmp    %eax,%edx
  8031f8:	0f 83 dd 03 00 00    	jae    8035db <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803201:	8b 50 08             	mov    0x8(%eax),%edx
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	8b 40 0c             	mov    0xc(%eax),%eax
  80320a:	01 c2                	add    %eax,%edx
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	8b 40 08             	mov    0x8(%eax),%eax
  803212:	39 c2                	cmp    %eax,%edx
  803214:	0f 85 b9 01 00 00    	jne    8033d3 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	8b 50 08             	mov    0x8(%eax),%edx
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	8b 40 0c             	mov    0xc(%eax),%eax
  803226:	01 c2                	add    %eax,%edx
  803228:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322b:	8b 40 08             	mov    0x8(%eax),%eax
  80322e:	39 c2                	cmp    %eax,%edx
  803230:	0f 85 0d 01 00 00    	jne    803343 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803239:	8b 50 0c             	mov    0xc(%eax),%edx
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	8b 40 0c             	mov    0xc(%eax),%eax
  803242:	01 c2                	add    %eax,%edx
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80324a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80324e:	75 17                	jne    803267 <insert_sorted_with_merge_freeList+0x39c>
  803250:	83 ec 04             	sub    $0x4,%esp
  803253:	68 a0 45 80 00       	push   $0x8045a0
  803258:	68 5c 01 00 00       	push   $0x15c
  80325d:	68 f7 44 80 00       	push   $0x8044f7
  803262:	e8 95 d1 ff ff       	call   8003fc <_panic>
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	8b 00                	mov    (%eax),%eax
  80326c:	85 c0                	test   %eax,%eax
  80326e:	74 10                	je     803280 <insert_sorted_with_merge_freeList+0x3b5>
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803278:	8b 52 04             	mov    0x4(%edx),%edx
  80327b:	89 50 04             	mov    %edx,0x4(%eax)
  80327e:	eb 0b                	jmp    80328b <insert_sorted_with_merge_freeList+0x3c0>
  803280:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803283:	8b 40 04             	mov    0x4(%eax),%eax
  803286:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328e:	8b 40 04             	mov    0x4(%eax),%eax
  803291:	85 c0                	test   %eax,%eax
  803293:	74 0f                	je     8032a4 <insert_sorted_with_merge_freeList+0x3d9>
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	8b 40 04             	mov    0x4(%eax),%eax
  80329b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329e:	8b 12                	mov    (%edx),%edx
  8032a0:	89 10                	mov    %edx,(%eax)
  8032a2:	eb 0a                	jmp    8032ae <insert_sorted_with_merge_freeList+0x3e3>
  8032a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8032c6:	48                   	dec    %eax
  8032c7:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e4:	75 17                	jne    8032fd <insert_sorted_with_merge_freeList+0x432>
  8032e6:	83 ec 04             	sub    $0x4,%esp
  8032e9:	68 d4 44 80 00       	push   $0x8044d4
  8032ee:	68 5f 01 00 00       	push   $0x15f
  8032f3:	68 f7 44 80 00       	push   $0x8044f7
  8032f8:	e8 ff d0 ff ff       	call   8003fc <_panic>
  8032fd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803303:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803306:	89 10                	mov    %edx,(%eax)
  803308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	85 c0                	test   %eax,%eax
  80330f:	74 0d                	je     80331e <insert_sorted_with_merge_freeList+0x453>
  803311:	a1 48 51 80 00       	mov    0x805148,%eax
  803316:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803319:	89 50 04             	mov    %edx,0x4(%eax)
  80331c:	eb 08                	jmp    803326 <insert_sorted_with_merge_freeList+0x45b>
  80331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803321:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	a3 48 51 80 00       	mov    %eax,0x805148
  80332e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803331:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803338:	a1 54 51 80 00       	mov    0x805154,%eax
  80333d:	40                   	inc    %eax
  80333e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	8b 50 0c             	mov    0xc(%eax),%edx
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	8b 40 0c             	mov    0xc(%eax),%eax
  80334f:	01 c2                	add    %eax,%edx
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80336b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336f:	75 17                	jne    803388 <insert_sorted_with_merge_freeList+0x4bd>
  803371:	83 ec 04             	sub    $0x4,%esp
  803374:	68 d4 44 80 00       	push   $0x8044d4
  803379:	68 64 01 00 00       	push   $0x164
  80337e:	68 f7 44 80 00       	push   $0x8044f7
  803383:	e8 74 d0 ff ff       	call   8003fc <_panic>
  803388:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	89 10                	mov    %edx,(%eax)
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	85 c0                	test   %eax,%eax
  80339a:	74 0d                	je     8033a9 <insert_sorted_with_merge_freeList+0x4de>
  80339c:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a4:	89 50 04             	mov    %edx,0x4(%eax)
  8033a7:	eb 08                	jmp    8033b1 <insert_sorted_with_merge_freeList+0x4e6>
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c8:	40                   	inc    %eax
  8033c9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033ce:	e9 41 02 00 00       	jmp    803614 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	8b 50 08             	mov    0x8(%eax),%edx
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033df:	01 c2                	add    %eax,%edx
  8033e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e4:	8b 40 08             	mov    0x8(%eax),%eax
  8033e7:	39 c2                	cmp    %eax,%edx
  8033e9:	0f 85 7c 01 00 00    	jne    80356b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033f3:	74 06                	je     8033fb <insert_sorted_with_merge_freeList+0x530>
  8033f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f9:	75 17                	jne    803412 <insert_sorted_with_merge_freeList+0x547>
  8033fb:	83 ec 04             	sub    $0x4,%esp
  8033fe:	68 10 45 80 00       	push   $0x804510
  803403:	68 69 01 00 00       	push   $0x169
  803408:	68 f7 44 80 00       	push   $0x8044f7
  80340d:	e8 ea cf ff ff       	call   8003fc <_panic>
  803412:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803415:	8b 50 04             	mov    0x4(%eax),%edx
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	89 50 04             	mov    %edx,0x4(%eax)
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803424:	89 10                	mov    %edx,(%eax)
  803426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803429:	8b 40 04             	mov    0x4(%eax),%eax
  80342c:	85 c0                	test   %eax,%eax
  80342e:	74 0d                	je     80343d <insert_sorted_with_merge_freeList+0x572>
  803430:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803433:	8b 40 04             	mov    0x4(%eax),%eax
  803436:	8b 55 08             	mov    0x8(%ebp),%edx
  803439:	89 10                	mov    %edx,(%eax)
  80343b:	eb 08                	jmp    803445 <insert_sorted_with_merge_freeList+0x57a>
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	a3 38 51 80 00       	mov    %eax,0x805138
  803445:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803448:	8b 55 08             	mov    0x8(%ebp),%edx
  80344b:	89 50 04             	mov    %edx,0x4(%eax)
  80344e:	a1 44 51 80 00       	mov    0x805144,%eax
  803453:	40                   	inc    %eax
  803454:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 50 0c             	mov    0xc(%eax),%edx
  80345f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803462:	8b 40 0c             	mov    0xc(%eax),%eax
  803465:	01 c2                	add    %eax,%edx
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80346d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803471:	75 17                	jne    80348a <insert_sorted_with_merge_freeList+0x5bf>
  803473:	83 ec 04             	sub    $0x4,%esp
  803476:	68 a0 45 80 00       	push   $0x8045a0
  80347b:	68 6b 01 00 00       	push   $0x16b
  803480:	68 f7 44 80 00       	push   $0x8044f7
  803485:	e8 72 cf ff ff       	call   8003fc <_panic>
  80348a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348d:	8b 00                	mov    (%eax),%eax
  80348f:	85 c0                	test   %eax,%eax
  803491:	74 10                	je     8034a3 <insert_sorted_with_merge_freeList+0x5d8>
  803493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803496:	8b 00                	mov    (%eax),%eax
  803498:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80349b:	8b 52 04             	mov    0x4(%edx),%edx
  80349e:	89 50 04             	mov    %edx,0x4(%eax)
  8034a1:	eb 0b                	jmp    8034ae <insert_sorted_with_merge_freeList+0x5e3>
  8034a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a6:	8b 40 04             	mov    0x4(%eax),%eax
  8034a9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b1:	8b 40 04             	mov    0x4(%eax),%eax
  8034b4:	85 c0                	test   %eax,%eax
  8034b6:	74 0f                	je     8034c7 <insert_sorted_with_merge_freeList+0x5fc>
  8034b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bb:	8b 40 04             	mov    0x4(%eax),%eax
  8034be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034c1:	8b 12                	mov    (%edx),%edx
  8034c3:	89 10                	mov    %edx,(%eax)
  8034c5:	eb 0a                	jmp    8034d1 <insert_sorted_with_merge_freeList+0x606>
  8034c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	a3 38 51 80 00       	mov    %eax,0x805138
  8034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8034e9:	48                   	dec    %eax
  8034ea:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803503:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803507:	75 17                	jne    803520 <insert_sorted_with_merge_freeList+0x655>
  803509:	83 ec 04             	sub    $0x4,%esp
  80350c:	68 d4 44 80 00       	push   $0x8044d4
  803511:	68 6e 01 00 00       	push   $0x16e
  803516:	68 f7 44 80 00       	push   $0x8044f7
  80351b:	e8 dc ce ff ff       	call   8003fc <_panic>
  803520:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803529:	89 10                	mov    %edx,(%eax)
  80352b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352e:	8b 00                	mov    (%eax),%eax
  803530:	85 c0                	test   %eax,%eax
  803532:	74 0d                	je     803541 <insert_sorted_with_merge_freeList+0x676>
  803534:	a1 48 51 80 00       	mov    0x805148,%eax
  803539:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80353c:	89 50 04             	mov    %edx,0x4(%eax)
  80353f:	eb 08                	jmp    803549 <insert_sorted_with_merge_freeList+0x67e>
  803541:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803544:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354c:	a3 48 51 80 00       	mov    %eax,0x805148
  803551:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355b:	a1 54 51 80 00       	mov    0x805154,%eax
  803560:	40                   	inc    %eax
  803561:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803566:	e9 a9 00 00 00       	jmp    803614 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80356b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356f:	74 06                	je     803577 <insert_sorted_with_merge_freeList+0x6ac>
  803571:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803575:	75 17                	jne    80358e <insert_sorted_with_merge_freeList+0x6c3>
  803577:	83 ec 04             	sub    $0x4,%esp
  80357a:	68 6c 45 80 00       	push   $0x80456c
  80357f:	68 73 01 00 00       	push   $0x173
  803584:	68 f7 44 80 00       	push   $0x8044f7
  803589:	e8 6e ce ff ff       	call   8003fc <_panic>
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	8b 10                	mov    (%eax),%edx
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	89 10                	mov    %edx,(%eax)
  803598:	8b 45 08             	mov    0x8(%ebp),%eax
  80359b:	8b 00                	mov    (%eax),%eax
  80359d:	85 c0                	test   %eax,%eax
  80359f:	74 0b                	je     8035ac <insert_sorted_with_merge_freeList+0x6e1>
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	8b 00                	mov    (%eax),%eax
  8035a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a9:	89 50 04             	mov    %edx,0x4(%eax)
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	8b 55 08             	mov    0x8(%ebp),%edx
  8035b2:	89 10                	mov    %edx,(%eax)
  8035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ba:	89 50 04             	mov    %edx,0x4(%eax)
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	75 08                	jne    8035ce <insert_sorted_with_merge_freeList+0x703>
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8035d3:	40                   	inc    %eax
  8035d4:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035d9:	eb 39                	jmp    803614 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035db:	a1 40 51 80 00       	mov    0x805140,%eax
  8035e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e7:	74 07                	je     8035f0 <insert_sorted_with_merge_freeList+0x725>
  8035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ec:	8b 00                	mov    (%eax),%eax
  8035ee:	eb 05                	jmp    8035f5 <insert_sorted_with_merge_freeList+0x72a>
  8035f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f5:	a3 40 51 80 00       	mov    %eax,0x805140
  8035fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8035ff:	85 c0                	test   %eax,%eax
  803601:	0f 85 c7 fb ff ff    	jne    8031ce <insert_sorted_with_merge_freeList+0x303>
  803607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360b:	0f 85 bd fb ff ff    	jne    8031ce <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803611:	eb 01                	jmp    803614 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803613:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803614:	90                   	nop
  803615:	c9                   	leave  
  803616:	c3                   	ret    
  803617:	90                   	nop

00803618 <__udivdi3>:
  803618:	55                   	push   %ebp
  803619:	57                   	push   %edi
  80361a:	56                   	push   %esi
  80361b:	53                   	push   %ebx
  80361c:	83 ec 1c             	sub    $0x1c,%esp
  80361f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803623:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803627:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80362b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80362f:	89 ca                	mov    %ecx,%edx
  803631:	89 f8                	mov    %edi,%eax
  803633:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803637:	85 f6                	test   %esi,%esi
  803639:	75 2d                	jne    803668 <__udivdi3+0x50>
  80363b:	39 cf                	cmp    %ecx,%edi
  80363d:	77 65                	ja     8036a4 <__udivdi3+0x8c>
  80363f:	89 fd                	mov    %edi,%ebp
  803641:	85 ff                	test   %edi,%edi
  803643:	75 0b                	jne    803650 <__udivdi3+0x38>
  803645:	b8 01 00 00 00       	mov    $0x1,%eax
  80364a:	31 d2                	xor    %edx,%edx
  80364c:	f7 f7                	div    %edi
  80364e:	89 c5                	mov    %eax,%ebp
  803650:	31 d2                	xor    %edx,%edx
  803652:	89 c8                	mov    %ecx,%eax
  803654:	f7 f5                	div    %ebp
  803656:	89 c1                	mov    %eax,%ecx
  803658:	89 d8                	mov    %ebx,%eax
  80365a:	f7 f5                	div    %ebp
  80365c:	89 cf                	mov    %ecx,%edi
  80365e:	89 fa                	mov    %edi,%edx
  803660:	83 c4 1c             	add    $0x1c,%esp
  803663:	5b                   	pop    %ebx
  803664:	5e                   	pop    %esi
  803665:	5f                   	pop    %edi
  803666:	5d                   	pop    %ebp
  803667:	c3                   	ret    
  803668:	39 ce                	cmp    %ecx,%esi
  80366a:	77 28                	ja     803694 <__udivdi3+0x7c>
  80366c:	0f bd fe             	bsr    %esi,%edi
  80366f:	83 f7 1f             	xor    $0x1f,%edi
  803672:	75 40                	jne    8036b4 <__udivdi3+0x9c>
  803674:	39 ce                	cmp    %ecx,%esi
  803676:	72 0a                	jb     803682 <__udivdi3+0x6a>
  803678:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80367c:	0f 87 9e 00 00 00    	ja     803720 <__udivdi3+0x108>
  803682:	b8 01 00 00 00       	mov    $0x1,%eax
  803687:	89 fa                	mov    %edi,%edx
  803689:	83 c4 1c             	add    $0x1c,%esp
  80368c:	5b                   	pop    %ebx
  80368d:	5e                   	pop    %esi
  80368e:	5f                   	pop    %edi
  80368f:	5d                   	pop    %ebp
  803690:	c3                   	ret    
  803691:	8d 76 00             	lea    0x0(%esi),%esi
  803694:	31 ff                	xor    %edi,%edi
  803696:	31 c0                	xor    %eax,%eax
  803698:	89 fa                	mov    %edi,%edx
  80369a:	83 c4 1c             	add    $0x1c,%esp
  80369d:	5b                   	pop    %ebx
  80369e:	5e                   	pop    %esi
  80369f:	5f                   	pop    %edi
  8036a0:	5d                   	pop    %ebp
  8036a1:	c3                   	ret    
  8036a2:	66 90                	xchg   %ax,%ax
  8036a4:	89 d8                	mov    %ebx,%eax
  8036a6:	f7 f7                	div    %edi
  8036a8:	31 ff                	xor    %edi,%edi
  8036aa:	89 fa                	mov    %edi,%edx
  8036ac:	83 c4 1c             	add    $0x1c,%esp
  8036af:	5b                   	pop    %ebx
  8036b0:	5e                   	pop    %esi
  8036b1:	5f                   	pop    %edi
  8036b2:	5d                   	pop    %ebp
  8036b3:	c3                   	ret    
  8036b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036b9:	89 eb                	mov    %ebp,%ebx
  8036bb:	29 fb                	sub    %edi,%ebx
  8036bd:	89 f9                	mov    %edi,%ecx
  8036bf:	d3 e6                	shl    %cl,%esi
  8036c1:	89 c5                	mov    %eax,%ebp
  8036c3:	88 d9                	mov    %bl,%cl
  8036c5:	d3 ed                	shr    %cl,%ebp
  8036c7:	89 e9                	mov    %ebp,%ecx
  8036c9:	09 f1                	or     %esi,%ecx
  8036cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036cf:	89 f9                	mov    %edi,%ecx
  8036d1:	d3 e0                	shl    %cl,%eax
  8036d3:	89 c5                	mov    %eax,%ebp
  8036d5:	89 d6                	mov    %edx,%esi
  8036d7:	88 d9                	mov    %bl,%cl
  8036d9:	d3 ee                	shr    %cl,%esi
  8036db:	89 f9                	mov    %edi,%ecx
  8036dd:	d3 e2                	shl    %cl,%edx
  8036df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036e3:	88 d9                	mov    %bl,%cl
  8036e5:	d3 e8                	shr    %cl,%eax
  8036e7:	09 c2                	or     %eax,%edx
  8036e9:	89 d0                	mov    %edx,%eax
  8036eb:	89 f2                	mov    %esi,%edx
  8036ed:	f7 74 24 0c          	divl   0xc(%esp)
  8036f1:	89 d6                	mov    %edx,%esi
  8036f3:	89 c3                	mov    %eax,%ebx
  8036f5:	f7 e5                	mul    %ebp
  8036f7:	39 d6                	cmp    %edx,%esi
  8036f9:	72 19                	jb     803714 <__udivdi3+0xfc>
  8036fb:	74 0b                	je     803708 <__udivdi3+0xf0>
  8036fd:	89 d8                	mov    %ebx,%eax
  8036ff:	31 ff                	xor    %edi,%edi
  803701:	e9 58 ff ff ff       	jmp    80365e <__udivdi3+0x46>
  803706:	66 90                	xchg   %ax,%ax
  803708:	8b 54 24 08          	mov    0x8(%esp),%edx
  80370c:	89 f9                	mov    %edi,%ecx
  80370e:	d3 e2                	shl    %cl,%edx
  803710:	39 c2                	cmp    %eax,%edx
  803712:	73 e9                	jae    8036fd <__udivdi3+0xe5>
  803714:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803717:	31 ff                	xor    %edi,%edi
  803719:	e9 40 ff ff ff       	jmp    80365e <__udivdi3+0x46>
  80371e:	66 90                	xchg   %ax,%ax
  803720:	31 c0                	xor    %eax,%eax
  803722:	e9 37 ff ff ff       	jmp    80365e <__udivdi3+0x46>
  803727:	90                   	nop

00803728 <__umoddi3>:
  803728:	55                   	push   %ebp
  803729:	57                   	push   %edi
  80372a:	56                   	push   %esi
  80372b:	53                   	push   %ebx
  80372c:	83 ec 1c             	sub    $0x1c,%esp
  80372f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803733:	8b 74 24 34          	mov    0x34(%esp),%esi
  803737:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80373b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80373f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803743:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803747:	89 f3                	mov    %esi,%ebx
  803749:	89 fa                	mov    %edi,%edx
  80374b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80374f:	89 34 24             	mov    %esi,(%esp)
  803752:	85 c0                	test   %eax,%eax
  803754:	75 1a                	jne    803770 <__umoddi3+0x48>
  803756:	39 f7                	cmp    %esi,%edi
  803758:	0f 86 a2 00 00 00    	jbe    803800 <__umoddi3+0xd8>
  80375e:	89 c8                	mov    %ecx,%eax
  803760:	89 f2                	mov    %esi,%edx
  803762:	f7 f7                	div    %edi
  803764:	89 d0                	mov    %edx,%eax
  803766:	31 d2                	xor    %edx,%edx
  803768:	83 c4 1c             	add    $0x1c,%esp
  80376b:	5b                   	pop    %ebx
  80376c:	5e                   	pop    %esi
  80376d:	5f                   	pop    %edi
  80376e:	5d                   	pop    %ebp
  80376f:	c3                   	ret    
  803770:	39 f0                	cmp    %esi,%eax
  803772:	0f 87 ac 00 00 00    	ja     803824 <__umoddi3+0xfc>
  803778:	0f bd e8             	bsr    %eax,%ebp
  80377b:	83 f5 1f             	xor    $0x1f,%ebp
  80377e:	0f 84 ac 00 00 00    	je     803830 <__umoddi3+0x108>
  803784:	bf 20 00 00 00       	mov    $0x20,%edi
  803789:	29 ef                	sub    %ebp,%edi
  80378b:	89 fe                	mov    %edi,%esi
  80378d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803791:	89 e9                	mov    %ebp,%ecx
  803793:	d3 e0                	shl    %cl,%eax
  803795:	89 d7                	mov    %edx,%edi
  803797:	89 f1                	mov    %esi,%ecx
  803799:	d3 ef                	shr    %cl,%edi
  80379b:	09 c7                	or     %eax,%edi
  80379d:	89 e9                	mov    %ebp,%ecx
  80379f:	d3 e2                	shl    %cl,%edx
  8037a1:	89 14 24             	mov    %edx,(%esp)
  8037a4:	89 d8                	mov    %ebx,%eax
  8037a6:	d3 e0                	shl    %cl,%eax
  8037a8:	89 c2                	mov    %eax,%edx
  8037aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037ae:	d3 e0                	shl    %cl,%eax
  8037b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037b8:	89 f1                	mov    %esi,%ecx
  8037ba:	d3 e8                	shr    %cl,%eax
  8037bc:	09 d0                	or     %edx,%eax
  8037be:	d3 eb                	shr    %cl,%ebx
  8037c0:	89 da                	mov    %ebx,%edx
  8037c2:	f7 f7                	div    %edi
  8037c4:	89 d3                	mov    %edx,%ebx
  8037c6:	f7 24 24             	mull   (%esp)
  8037c9:	89 c6                	mov    %eax,%esi
  8037cb:	89 d1                	mov    %edx,%ecx
  8037cd:	39 d3                	cmp    %edx,%ebx
  8037cf:	0f 82 87 00 00 00    	jb     80385c <__umoddi3+0x134>
  8037d5:	0f 84 91 00 00 00    	je     80386c <__umoddi3+0x144>
  8037db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037df:	29 f2                	sub    %esi,%edx
  8037e1:	19 cb                	sbb    %ecx,%ebx
  8037e3:	89 d8                	mov    %ebx,%eax
  8037e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037e9:	d3 e0                	shl    %cl,%eax
  8037eb:	89 e9                	mov    %ebp,%ecx
  8037ed:	d3 ea                	shr    %cl,%edx
  8037ef:	09 d0                	or     %edx,%eax
  8037f1:	89 e9                	mov    %ebp,%ecx
  8037f3:	d3 eb                	shr    %cl,%ebx
  8037f5:	89 da                	mov    %ebx,%edx
  8037f7:	83 c4 1c             	add    $0x1c,%esp
  8037fa:	5b                   	pop    %ebx
  8037fb:	5e                   	pop    %esi
  8037fc:	5f                   	pop    %edi
  8037fd:	5d                   	pop    %ebp
  8037fe:	c3                   	ret    
  8037ff:	90                   	nop
  803800:	89 fd                	mov    %edi,%ebp
  803802:	85 ff                	test   %edi,%edi
  803804:	75 0b                	jne    803811 <__umoddi3+0xe9>
  803806:	b8 01 00 00 00       	mov    $0x1,%eax
  80380b:	31 d2                	xor    %edx,%edx
  80380d:	f7 f7                	div    %edi
  80380f:	89 c5                	mov    %eax,%ebp
  803811:	89 f0                	mov    %esi,%eax
  803813:	31 d2                	xor    %edx,%edx
  803815:	f7 f5                	div    %ebp
  803817:	89 c8                	mov    %ecx,%eax
  803819:	f7 f5                	div    %ebp
  80381b:	89 d0                	mov    %edx,%eax
  80381d:	e9 44 ff ff ff       	jmp    803766 <__umoddi3+0x3e>
  803822:	66 90                	xchg   %ax,%ax
  803824:	89 c8                	mov    %ecx,%eax
  803826:	89 f2                	mov    %esi,%edx
  803828:	83 c4 1c             	add    $0x1c,%esp
  80382b:	5b                   	pop    %ebx
  80382c:	5e                   	pop    %esi
  80382d:	5f                   	pop    %edi
  80382e:	5d                   	pop    %ebp
  80382f:	c3                   	ret    
  803830:	3b 04 24             	cmp    (%esp),%eax
  803833:	72 06                	jb     80383b <__umoddi3+0x113>
  803835:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803839:	77 0f                	ja     80384a <__umoddi3+0x122>
  80383b:	89 f2                	mov    %esi,%edx
  80383d:	29 f9                	sub    %edi,%ecx
  80383f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803843:	89 14 24             	mov    %edx,(%esp)
  803846:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80384a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80384e:	8b 14 24             	mov    (%esp),%edx
  803851:	83 c4 1c             	add    $0x1c,%esp
  803854:	5b                   	pop    %ebx
  803855:	5e                   	pop    %esi
  803856:	5f                   	pop    %edi
  803857:	5d                   	pop    %ebp
  803858:	c3                   	ret    
  803859:	8d 76 00             	lea    0x0(%esi),%esi
  80385c:	2b 04 24             	sub    (%esp),%eax
  80385f:	19 fa                	sbb    %edi,%edx
  803861:	89 d1                	mov    %edx,%ecx
  803863:	89 c6                	mov    %eax,%esi
  803865:	e9 71 ff ff ff       	jmp    8037db <__umoddi3+0xb3>
  80386a:	66 90                	xchg   %ax,%ax
  80386c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803870:	72 ea                	jb     80385c <__umoddi3+0x134>
  803872:	89 d9                	mov    %ebx,%ecx
  803874:	e9 62 ff ff ff       	jmp    8037db <__umoddi3+0xb3>
