
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
  80008c:	68 00 37 80 00       	push   $0x803700
  800091:	6a 12                	push   $0x12
  800093:	68 1c 37 80 00       	push   $0x80371c
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
  8000ad:	68 34 37 80 00       	push   $0x803734
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 68 37 80 00       	push   $0x803768
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 c4 37 80 00       	push   $0x8037c4
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 f8 37 80 00       	push   $0x8037f8
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 40 38 80 00       	push   $0x803840
  8000f9:	e8 82 15 00 00       	call   801680 <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 b7 17 00 00       	call   8018c0 <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 40 38 80 00       	push   $0x803840
  80011b:	e8 60 15 00 00       	call   801680 <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 44 38 80 00       	push   $0x803844
  800134:	6a 24                	push   $0x24
  800136:	68 1c 37 80 00       	push   $0x80371c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 7b 17 00 00       	call   8018c0 <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 98 38 80 00       	push   $0x803898
  800156:	6a 25                	push   $0x25
  800158:	68 1c 37 80 00       	push   $0x80371c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 f4 38 80 00       	push   $0x8038f4
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 49 17 00 00       	call   8018c0 <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 4c 39 80 00       	push   $0x80394c
  80018e:	e8 ed 14 00 00       	call   801680 <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 50 39 80 00       	push   $0x803950
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 1c 37 80 00       	push   $0x80371c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 08 17 00 00       	call   8018c0 <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 c4 39 80 00       	push   $0x8039c4
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 1c 37 80 00       	push   $0x80371c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 38 3a 80 00       	push   $0x803a38
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 2f 19 00 00       	call   801b19 <sys_getMaxShares>
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
  800213:	e8 68 14 00 00       	call   801680 <smalloc>
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80021e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800222:	75 14                	jne    800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 ac 3a 80 00       	push   $0x803aac
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 1c 37 80 00       	push   $0x80371c
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
  80024f:	68 dc 3a 80 00       	push   $0x803adc
  800254:	e8 27 14 00 00       	call   801680 <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 b5 18 00 00       	call   801b19 <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 e8 3a 80 00       	push   $0x803ae8
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 1c 37 80 00       	push   $0x80371c
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
  80029c:	68 64 3b 80 00       	push   $0x803b64
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 1c 37 80 00       	push   $0x80371c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 f0 3b 80 00       	push   $0x803bf0
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
  8002c6:	e8 d5 18 00 00       	call   801ba0 <sys_getenvindex>
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
  800331:	e8 77 16 00 00       	call   8019ad <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 68 3c 80 00       	push   $0x803c68
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
  800361:	68 90 3c 80 00       	push   $0x803c90
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
  800392:	68 b8 3c 80 00       	push   $0x803cb8
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 10 3d 80 00       	push   $0x803d10
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 68 3c 80 00       	push   $0x803c68
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 f7 15 00 00       	call   8019c7 <sys_enable_interrupt>

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
  8003e3:	e8 84 17 00 00       	call   801b6c <sys_destroy_env>
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
  8003f4:	e8 d9 17 00 00       	call   801bd2 <sys_exit_env>
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
  80041d:	68 24 3d 80 00       	push   $0x803d24
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 29 3d 80 00       	push   $0x803d29
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
  80045a:	68 45 3d 80 00       	push   $0x803d45
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
  800486:	68 48 3d 80 00       	push   $0x803d48
  80048b:	6a 26                	push   $0x26
  80048d:	68 94 3d 80 00       	push   $0x803d94
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
  800558:	68 a0 3d 80 00       	push   $0x803da0
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 94 3d 80 00       	push   $0x803d94
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
  8005c8:	68 f4 3d 80 00       	push   $0x803df4
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 94 3d 80 00       	push   $0x803d94
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
  800622:	e8 d8 11 00 00       	call   8017ff <sys_cputs>
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
  800699:	e8 61 11 00 00       	call   8017ff <sys_cputs>
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
  8006e3:	e8 c5 12 00 00       	call   8019ad <sys_disable_interrupt>
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
  800703:	e8 bf 12 00 00       	call   8019c7 <sys_enable_interrupt>
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
  80074d:	e8 32 2d 00 00       	call   803484 <__udivdi3>
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
  80079d:	e8 f2 2d 00 00       	call   803594 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 54 40 80 00       	add    $0x804054,%eax
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
  8008f8:	8b 04 85 78 40 80 00 	mov    0x804078(,%eax,4),%eax
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
  8009d9:	8b 34 9d c0 3e 80 00 	mov    0x803ec0(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 65 40 80 00       	push   $0x804065
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
  8009fe:	68 6e 40 80 00       	push   $0x80406e
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
  800a2b:	be 71 40 80 00       	mov    $0x804071,%esi
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
  801451:	68 d0 41 80 00       	push   $0x8041d0
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
  801521:	e8 1d 04 00 00       	call   801943 <sys_allocate_chunk>
  801526:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801529:	a1 20 51 80 00       	mov    0x805120,%eax
  80152e:	83 ec 0c             	sub    $0xc,%esp
  801531:	50                   	push   %eax
  801532:	e8 92 0a 00 00       	call   801fc9 <initialize_MemBlocksList>
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
  80155f:	68 f5 41 80 00       	push   $0x8041f5
  801564:	6a 33                	push   $0x33
  801566:	68 13 42 80 00       	push   $0x804213
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
  8015de:	68 20 42 80 00       	push   $0x804220
  8015e3:	6a 34                	push   $0x34
  8015e5:	68 13 42 80 00       	push   $0x804213
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
  80163b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163e:	e8 f7 fd ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  801643:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801647:	75 07                	jne    801650 <malloc+0x18>
  801649:	b8 00 00 00 00       	mov    $0x0,%eax
  80164e:	eb 14                	jmp    801664 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	68 44 42 80 00       	push   $0x804244
  801658:	6a 46                	push   $0x46
  80165a:	68 13 42 80 00       	push   $0x804213
  80165f:	e8 98 ed ff ff       	call   8003fc <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	68 6c 42 80 00       	push   $0x80426c
  801674:	6a 61                	push   $0x61
  801676:	68 13 42 80 00       	push   $0x804213
  80167b:	e8 7c ed ff ff       	call   8003fc <_panic>

00801680 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 38             	sub    $0x38,%esp
  801686:	8b 45 10             	mov    0x10(%ebp),%eax
  801689:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80168c:	e8 a9 fd ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  801691:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801695:	75 07                	jne    80169e <smalloc+0x1e>
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
  80169c:	eb 7c                	jmp    80171a <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80169e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ab:	01 d0                	add    %edx,%eax
  8016ad:	48                   	dec    %eax
  8016ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	f7 75 f0             	divl   -0x10(%ebp)
  8016bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bf:	29 d0                	sub    %edx,%eax
  8016c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016c4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016cb:	e8 41 06 00 00       	call   801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	74 11                	je     8016e5 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8016d4:	83 ec 0c             	sub    $0xc,%esp
  8016d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8016da:	e8 ac 0c 00 00       	call   80238b <alloc_block_FF>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e9:	74 2a                	je     801715 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ee:	8b 40 08             	mov    0x8(%eax),%eax
  8016f1:	89 c2                	mov    %eax,%edx
  8016f3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016f7:	52                   	push   %edx
  8016f8:	50                   	push   %eax
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	ff 75 08             	pushl  0x8(%ebp)
  8016ff:	e8 92 03 00 00       	call   801a96 <sys_createSharedObject>
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80170a:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80170e:	74 05                	je     801715 <smalloc+0x95>
			return (void*)virtual_address;
  801710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801713:	eb 05                	jmp    80171a <smalloc+0x9a>
	}
	return NULL;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801722:	e8 13 fd ff ff       	call   80143a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801727:	83 ec 04             	sub    $0x4,%esp
  80172a:	68 90 42 80 00       	push   $0x804290
  80172f:	68 a2 00 00 00       	push   $0xa2
  801734:	68 13 42 80 00       	push   $0x804213
  801739:	e8 be ec ff ff       	call   8003fc <_panic>

0080173e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801744:	e8 f1 fc ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	68 b4 42 80 00       	push   $0x8042b4
  801751:	68 e6 00 00 00       	push   $0xe6
  801756:	68 13 42 80 00       	push   $0x804213
  80175b:	e8 9c ec ff ff       	call   8003fc <_panic>

00801760 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	68 dc 42 80 00       	push   $0x8042dc
  80176e:	68 fa 00 00 00       	push   $0xfa
  801773:	68 13 42 80 00       	push   $0x804213
  801778:	e8 7f ec ff ff       	call   8003fc <_panic>

0080177d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	68 00 43 80 00       	push   $0x804300
  80178b:	68 05 01 00 00       	push   $0x105
  801790:	68 13 42 80 00       	push   $0x804213
  801795:	e8 62 ec ff ff       	call   8003fc <_panic>

0080179a <shrink>:

}
void shrink(uint32 newSize)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	68 00 43 80 00       	push   $0x804300
  8017a8:	68 0a 01 00 00       	push   $0x10a
  8017ad:	68 13 42 80 00       	push   $0x804213
  8017b2:	e8 45 ec ff ff       	call   8003fc <_panic>

008017b7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 00 43 80 00       	push   $0x804300
  8017c5:	68 0f 01 00 00       	push   $0x10f
  8017ca:	68 13 42 80 00       	push   $0x804213
  8017cf:	e8 28 ec ff ff       	call   8003fc <_panic>

008017d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	57                   	push   %edi
  8017d8:	56                   	push   %esi
  8017d9:	53                   	push   %ebx
  8017da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017ef:	cd 30                	int    $0x30
  8017f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5e                   	pop    %esi
  8017fc:	5f                   	pop    %edi
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80180b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	52                   	push   %edx
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	50                   	push   %eax
  80181b:	6a 00                	push   $0x0
  80181d:	e8 b2 ff ff ff       	call   8017d4 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	90                   	nop
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_cgetc>:

int
sys_cgetc(void)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 01                	push   $0x1
  801837:	e8 98 ff ff ff       	call   8017d4 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801844:	8b 55 0c             	mov    0xc(%ebp),%edx
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	52                   	push   %edx
  801851:	50                   	push   %eax
  801852:	6a 05                	push   $0x5
  801854:	e8 7b ff ff ff       	call   8017d4 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	56                   	push   %esi
  801862:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801863:	8b 75 18             	mov    0x18(%ebp),%esi
  801866:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801869:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	51                   	push   %ecx
  801875:	52                   	push   %edx
  801876:	50                   	push   %eax
  801877:	6a 06                	push   $0x6
  801879:	e8 56 ff ff ff       	call   8017d4 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801884:	5b                   	pop    %ebx
  801885:	5e                   	pop    %esi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	52                   	push   %edx
  801898:	50                   	push   %eax
  801899:	6a 07                	push   $0x7
  80189b:	e8 34 ff ff ff       	call   8017d4 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff 75 0c             	pushl  0xc(%ebp)
  8018b1:	ff 75 08             	pushl  0x8(%ebp)
  8018b4:	6a 08                	push   $0x8
  8018b6:	e8 19 ff ff ff       	call   8017d4 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 09                	push   $0x9
  8018cf:	e8 00 ff ff ff       	call   8017d4 <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 0a                	push   $0xa
  8018e8:	e8 e7 fe ff ff       	call   8017d4 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 0b                	push   $0xb
  801901:	e8 ce fe ff ff       	call   8017d4 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	ff 75 0c             	pushl  0xc(%ebp)
  801917:	ff 75 08             	pushl  0x8(%ebp)
  80191a:	6a 0f                	push   $0xf
  80191c:	e8 b3 fe ff ff       	call   8017d4 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
	return;
  801924:	90                   	nop
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	6a 10                	push   $0x10
  801938:	e8 97 fe ff ff       	call   8017d4 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
	return ;
  801940:	90                   	nop
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	ff 75 10             	pushl  0x10(%ebp)
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 11                	push   $0x11
  801955:	e8 7a fe ff ff       	call   8017d4 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
	return ;
  80195d:	90                   	nop
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 0c                	push   $0xc
  80196f:	e8 60 fe ff ff       	call   8017d4 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	ff 75 08             	pushl  0x8(%ebp)
  801987:	6a 0d                	push   $0xd
  801989:	e8 46 fe ff ff       	call   8017d4 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 0e                	push   $0xe
  8019a2:	e8 2d fe ff ff       	call   8017d4 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	90                   	nop
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 13                	push   $0x13
  8019bc:	e8 13 fe ff ff       	call   8017d4 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	90                   	nop
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 14                	push   $0x14
  8019d6:	e8 f9 fd ff ff       	call   8017d4 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	50                   	push   %eax
  8019fa:	6a 15                	push   $0x15
  8019fc:	e8 d3 fd ff ff       	call   8017d4 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	90                   	nop
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 16                	push   $0x16
  801a16:	e8 b9 fd ff ff       	call   8017d4 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	90                   	nop
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	50                   	push   %eax
  801a31:	6a 17                	push   $0x17
  801a33:	e8 9c fd ff ff       	call   8017d4 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 1a                	push   $0x1a
  801a50:	e8 7f fd ff ff       	call   8017d4 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	6a 18                	push   $0x18
  801a6d:	e8 62 fd ff ff       	call   8017d4 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	90                   	nop
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 19                	push   $0x19
  801a8b:	e8 44 fd ff ff       	call   8017d4 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aa2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	51                   	push   %ecx
  801aaf:	52                   	push   %edx
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	50                   	push   %eax
  801ab4:	6a 1b                	push   $0x1b
  801ab6:	e8 19 fd ff ff       	call   8017d4 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	6a 1c                	push   $0x1c
  801ad3:	e8 fc fc ff ff       	call   8017d4 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	51                   	push   %ecx
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 1d                	push   $0x1d
  801af2:	e8 dd fc ff ff       	call   8017d4 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	6a 1e                	push   $0x1e
  801b0f:	e8 c0 fc ff ff       	call   8017d4 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 1f                	push   $0x1f
  801b28:	e8 a7 fc ff ff       	call   8017d4 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 14             	pushl  0x14(%ebp)
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	50                   	push   %eax
  801b44:	6a 20                	push   $0x20
  801b46:	e8 89 fc ff ff       	call   8017d4 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	50                   	push   %eax
  801b5f:	6a 21                	push   $0x21
  801b61:	e8 6e fc ff ff       	call   8017d4 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	90                   	nop
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	50                   	push   %eax
  801b7b:	6a 22                	push   $0x22
  801b7d:	e8 52 fc ff ff       	call   8017d4 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 02                	push   $0x2
  801b96:	e8 39 fc ff ff       	call   8017d4 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 03                	push   $0x3
  801baf:	e8 20 fc ff ff       	call   8017d4 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 04                	push   $0x4
  801bc8:	e8 07 fc ff ff       	call   8017d4 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 23                	push   $0x23
  801be1:	e8 ee fb ff ff       	call   8017d4 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	90                   	nop
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf5:	8d 50 04             	lea    0x4(%eax),%edx
  801bf8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	52                   	push   %edx
  801c02:	50                   	push   %eax
  801c03:	6a 24                	push   $0x24
  801c05:	e8 ca fb ff ff       	call   8017d4 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c16:	89 01                	mov    %eax,(%ecx)
  801c18:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	c9                   	leave  
  801c1f:	c2 04 00             	ret    $0x4

00801c22 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	ff 75 10             	pushl  0x10(%ebp)
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	ff 75 08             	pushl  0x8(%ebp)
  801c32:	6a 12                	push   $0x12
  801c34:	e8 9b fb ff ff       	call   8017d4 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3c:	90                   	nop
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 25                	push   $0x25
  801c4e:	e8 81 fb ff ff       	call   8017d4 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c64:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	50                   	push   %eax
  801c71:	6a 26                	push   $0x26
  801c73:	e8 5c fb ff ff       	call   8017d4 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <rsttst>:
void rsttst()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 28                	push   $0x28
  801c8d:	e8 42 fb ff ff       	call   8017d4 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca4:	8b 55 18             	mov    0x18(%ebp),%edx
  801ca7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cab:	52                   	push   %edx
  801cac:	50                   	push   %eax
  801cad:	ff 75 10             	pushl  0x10(%ebp)
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	ff 75 08             	pushl  0x8(%ebp)
  801cb6:	6a 27                	push   $0x27
  801cb8:	e8 17 fb ff ff       	call   8017d4 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc0:	90                   	nop
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <chktst>:
void chktst(uint32 n)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	ff 75 08             	pushl  0x8(%ebp)
  801cd1:	6a 29                	push   $0x29
  801cd3:	e8 fc fa ff ff       	call   8017d4 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <inctst>:

void inctst()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 2a                	push   $0x2a
  801ced:	e8 e2 fa ff ff       	call   8017d4 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf5:	90                   	nop
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <gettst>:
uint32 gettst()
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 2b                	push   $0x2b
  801d07:	e8 c8 fa ff ff       	call   8017d4 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 2c                	push   $0x2c
  801d23:	e8 ac fa ff ff       	call   8017d4 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
  801d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d2e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d32:	75 07                	jne    801d3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d34:	b8 01 00 00 00       	mov    $0x1,%eax
  801d39:	eb 05                	jmp    801d40 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 2c                	push   $0x2c
  801d54:	e8 7b fa ff ff       	call   8017d4 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
  801d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d5f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d63:	75 07                	jne    801d6c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d65:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6a:	eb 05                	jmp    801d71 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 2c                	push   $0x2c
  801d85:	e8 4a fa ff ff       	call   8017d4 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
  801d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d90:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d94:	75 07                	jne    801d9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	eb 05                	jmp    801da2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 2c                	push   $0x2c
  801db6:	e8 19 fa ff ff       	call   8017d4 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
  801dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc5:	75 07                	jne    801dce <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcc:	eb 05                	jmp    801dd3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	6a 2d                	push   $0x2d
  801de5:	e8 ea f9 ff ff       	call   8017d4 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	6a 00                	push   $0x0
  801e02:	53                   	push   %ebx
  801e03:	51                   	push   %ecx
  801e04:	52                   	push   %edx
  801e05:	50                   	push   %eax
  801e06:	6a 2e                	push   $0x2e
  801e08:	e8 c7 f9 ff ff       	call   8017d4 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
}
  801e10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	52                   	push   %edx
  801e25:	50                   	push   %eax
  801e26:	6a 2f                	push   $0x2f
  801e28:	e8 a7 f9 ff ff       	call   8017d4 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e38:	83 ec 0c             	sub    $0xc,%esp
  801e3b:	68 10 43 80 00       	push   $0x804310
  801e40:	e8 6b e8 ff ff       	call   8006b0 <cprintf>
  801e45:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e48:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e4f:	83 ec 0c             	sub    $0xc,%esp
  801e52:	68 3c 43 80 00       	push   $0x80433c
  801e57:	e8 54 e8 ff ff       	call   8006b0 <cprintf>
  801e5c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e5f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e63:	a1 38 51 80 00       	mov    0x805138,%eax
  801e68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6b:	eb 56                	jmp    801ec3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e71:	74 1c                	je     801e8f <print_mem_block_lists+0x5d>
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	8b 50 08             	mov    0x8(%eax),%edx
  801e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e82:	8b 40 0c             	mov    0xc(%eax),%eax
  801e85:	01 c8                	add    %ecx,%eax
  801e87:	39 c2                	cmp    %eax,%edx
  801e89:	73 04                	jae    801e8f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e8b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e92:	8b 50 08             	mov    0x8(%eax),%edx
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9b:	01 c2                	add    %eax,%edx
  801e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea0:	8b 40 08             	mov    0x8(%eax),%eax
  801ea3:	83 ec 04             	sub    $0x4,%esp
  801ea6:	52                   	push   %edx
  801ea7:	50                   	push   %eax
  801ea8:	68 51 43 80 00       	push   $0x804351
  801ead:	e8 fe e7 ff ff       	call   8006b0 <cprintf>
  801eb2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ebb:	a1 40 51 80 00       	mov    0x805140,%eax
  801ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec7:	74 07                	je     801ed0 <print_mem_block_lists+0x9e>
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	8b 00                	mov    (%eax),%eax
  801ece:	eb 05                	jmp    801ed5 <print_mem_block_lists+0xa3>
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed5:	a3 40 51 80 00       	mov    %eax,0x805140
  801eda:	a1 40 51 80 00       	mov    0x805140,%eax
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	75 8a                	jne    801e6d <print_mem_block_lists+0x3b>
  801ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee7:	75 84                	jne    801e6d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ee9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eed:	75 10                	jne    801eff <print_mem_block_lists+0xcd>
  801eef:	83 ec 0c             	sub    $0xc,%esp
  801ef2:	68 60 43 80 00       	push   $0x804360
  801ef7:	e8 b4 e7 ff ff       	call   8006b0 <cprintf>
  801efc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801eff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f06:	83 ec 0c             	sub    $0xc,%esp
  801f09:	68 84 43 80 00       	push   $0x804384
  801f0e:	e8 9d e7 ff ff       	call   8006b0 <cprintf>
  801f13:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f16:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f1a:	a1 40 50 80 00       	mov    0x805040,%eax
  801f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f22:	eb 56                	jmp    801f7a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f28:	74 1c                	je     801f46 <print_mem_block_lists+0x114>
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 50 08             	mov    0x8(%eax),%edx
  801f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f33:	8b 48 08             	mov    0x8(%eax),%ecx
  801f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f39:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3c:	01 c8                	add    %ecx,%eax
  801f3e:	39 c2                	cmp    %eax,%edx
  801f40:	73 04                	jae    801f46 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f42:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f49:	8b 50 08             	mov    0x8(%eax),%edx
  801f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f52:	01 c2                	add    %eax,%edx
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	8b 40 08             	mov    0x8(%eax),%eax
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	52                   	push   %edx
  801f5e:	50                   	push   %eax
  801f5f:	68 51 43 80 00       	push   $0x804351
  801f64:	e8 47 e7 ff ff       	call   8006b0 <cprintf>
  801f69:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f72:	a1 48 50 80 00       	mov    0x805048,%eax
  801f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7e:	74 07                	je     801f87 <print_mem_block_lists+0x155>
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	8b 00                	mov    (%eax),%eax
  801f85:	eb 05                	jmp    801f8c <print_mem_block_lists+0x15a>
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	a3 48 50 80 00       	mov    %eax,0x805048
  801f91:	a1 48 50 80 00       	mov    0x805048,%eax
  801f96:	85 c0                	test   %eax,%eax
  801f98:	75 8a                	jne    801f24 <print_mem_block_lists+0xf2>
  801f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9e:	75 84                	jne    801f24 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa4:	75 10                	jne    801fb6 <print_mem_block_lists+0x184>
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	68 9c 43 80 00       	push   $0x80439c
  801fae:	e8 fd e6 ff ff       	call   8006b0 <cprintf>
  801fb3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	68 10 43 80 00       	push   $0x804310
  801fbe:	e8 ed e6 ff ff       	call   8006b0 <cprintf>
  801fc3:	83 c4 10             	add    $0x10,%esp

}
  801fc6:	90                   	nop
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fcf:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fd6:	00 00 00 
  801fd9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801fe0:	00 00 00 
  801fe3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fea:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ff4:	e9 9e 00 00 00       	jmp    802097 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ff9:	a1 50 50 80 00       	mov    0x805050,%eax
  801ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802001:	c1 e2 04             	shl    $0x4,%edx
  802004:	01 d0                	add    %edx,%eax
  802006:	85 c0                	test   %eax,%eax
  802008:	75 14                	jne    80201e <initialize_MemBlocksList+0x55>
  80200a:	83 ec 04             	sub    $0x4,%esp
  80200d:	68 c4 43 80 00       	push   $0x8043c4
  802012:	6a 46                	push   $0x46
  802014:	68 e7 43 80 00       	push   $0x8043e7
  802019:	e8 de e3 ff ff       	call   8003fc <_panic>
  80201e:	a1 50 50 80 00       	mov    0x805050,%eax
  802023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802026:	c1 e2 04             	shl    $0x4,%edx
  802029:	01 d0                	add    %edx,%eax
  80202b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802031:	89 10                	mov    %edx,(%eax)
  802033:	8b 00                	mov    (%eax),%eax
  802035:	85 c0                	test   %eax,%eax
  802037:	74 18                	je     802051 <initialize_MemBlocksList+0x88>
  802039:	a1 48 51 80 00       	mov    0x805148,%eax
  80203e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802044:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802047:	c1 e1 04             	shl    $0x4,%ecx
  80204a:	01 ca                	add    %ecx,%edx
  80204c:	89 50 04             	mov    %edx,0x4(%eax)
  80204f:	eb 12                	jmp    802063 <initialize_MemBlocksList+0x9a>
  802051:	a1 50 50 80 00       	mov    0x805050,%eax
  802056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802059:	c1 e2 04             	shl    $0x4,%edx
  80205c:	01 d0                	add    %edx,%eax
  80205e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802063:	a1 50 50 80 00       	mov    0x805050,%eax
  802068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206b:	c1 e2 04             	shl    $0x4,%edx
  80206e:	01 d0                	add    %edx,%eax
  802070:	a3 48 51 80 00       	mov    %eax,0x805148
  802075:	a1 50 50 80 00       	mov    0x805050,%eax
  80207a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207d:	c1 e2 04             	shl    $0x4,%edx
  802080:	01 d0                	add    %edx,%eax
  802082:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802089:	a1 54 51 80 00       	mov    0x805154,%eax
  80208e:	40                   	inc    %eax
  80208f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802094:	ff 45 f4             	incl   -0xc(%ebp)
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80209d:	0f 82 56 ff ff ff    	jb     801ff9 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020a3:	90                   	nop
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	8b 00                	mov    (%eax),%eax
  8020b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020b4:	eb 19                	jmp    8020cf <find_block+0x29>
	{
		if(va==point->sva)
  8020b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b9:	8b 40 08             	mov    0x8(%eax),%eax
  8020bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020bf:	75 05                	jne    8020c6 <find_block+0x20>
		   return point;
  8020c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c4:	eb 36                	jmp    8020fc <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	8b 40 08             	mov    0x8(%eax),%eax
  8020cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020d3:	74 07                	je     8020dc <find_block+0x36>
  8020d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	eb 05                	jmp    8020e1 <find_block+0x3b>
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e4:	89 42 08             	mov    %eax,0x8(%edx)
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	8b 40 08             	mov    0x8(%eax),%eax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	75 c5                	jne    8020b6 <find_block+0x10>
  8020f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f5:	75 bf                	jne    8020b6 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802104:	a1 40 50 80 00       	mov    0x805040,%eax
  802109:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80210c:	a1 44 50 80 00       	mov    0x805044,%eax
  802111:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802117:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80211a:	74 24                	je     802140 <insert_sorted_allocList+0x42>
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	8b 50 08             	mov    0x8(%eax),%edx
  802122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802125:	8b 40 08             	mov    0x8(%eax),%eax
  802128:	39 c2                	cmp    %eax,%edx
  80212a:	76 14                	jbe    802140 <insert_sorted_allocList+0x42>
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	8b 50 08             	mov    0x8(%eax),%edx
  802132:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802135:	8b 40 08             	mov    0x8(%eax),%eax
  802138:	39 c2                	cmp    %eax,%edx
  80213a:	0f 82 60 01 00 00    	jb     8022a0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802140:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802144:	75 65                	jne    8021ab <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802146:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214a:	75 14                	jne    802160 <insert_sorted_allocList+0x62>
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	68 c4 43 80 00       	push   $0x8043c4
  802154:	6a 6b                	push   $0x6b
  802156:	68 e7 43 80 00       	push   $0x8043e7
  80215b:	e8 9c e2 ff ff       	call   8003fc <_panic>
  802160:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	89 10                	mov    %edx,(%eax)
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	85 c0                	test   %eax,%eax
  802172:	74 0d                	je     802181 <insert_sorted_allocList+0x83>
  802174:	a1 40 50 80 00       	mov    0x805040,%eax
  802179:	8b 55 08             	mov    0x8(%ebp),%edx
  80217c:	89 50 04             	mov    %edx,0x4(%eax)
  80217f:	eb 08                	jmp    802189 <insert_sorted_allocList+0x8b>
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	a3 44 50 80 00       	mov    %eax,0x805044
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	a3 40 50 80 00       	mov    %eax,0x805040
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80219b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021a0:	40                   	inc    %eax
  8021a1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021a6:	e9 dc 01 00 00       	jmp    802387 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	8b 50 08             	mov    0x8(%eax),%edx
  8021b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b4:	8b 40 08             	mov    0x8(%eax),%eax
  8021b7:	39 c2                	cmp    %eax,%edx
  8021b9:	77 6c                	ja     802227 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021bf:	74 06                	je     8021c7 <insert_sorted_allocList+0xc9>
  8021c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c5:	75 14                	jne    8021db <insert_sorted_allocList+0xdd>
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	68 00 44 80 00       	push   $0x804400
  8021cf:	6a 6f                	push   $0x6f
  8021d1:	68 e7 43 80 00       	push   $0x8043e7
  8021d6:	e8 21 e2 ff ff       	call   8003fc <_panic>
  8021db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021de:	8b 50 04             	mov    0x4(%eax),%edx
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	89 50 04             	mov    %edx,0x4(%eax)
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ed:	89 10                	mov    %edx,(%eax)
  8021ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f2:	8b 40 04             	mov    0x4(%eax),%eax
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	74 0d                	je     802206 <insert_sorted_allocList+0x108>
  8021f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fc:	8b 40 04             	mov    0x4(%eax),%eax
  8021ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802202:	89 10                	mov    %edx,(%eax)
  802204:	eb 08                	jmp    80220e <insert_sorted_allocList+0x110>
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 40 50 80 00       	mov    %eax,0x805040
  80220e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802211:	8b 55 08             	mov    0x8(%ebp),%edx
  802214:	89 50 04             	mov    %edx,0x4(%eax)
  802217:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80221c:	40                   	inc    %eax
  80221d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802222:	e9 60 01 00 00       	jmp    802387 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	8b 50 08             	mov    0x8(%eax),%edx
  80222d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802230:	8b 40 08             	mov    0x8(%eax),%eax
  802233:	39 c2                	cmp    %eax,%edx
  802235:	0f 82 4c 01 00 00    	jb     802387 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80223b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223f:	75 14                	jne    802255 <insert_sorted_allocList+0x157>
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	68 38 44 80 00       	push   $0x804438
  802249:	6a 73                	push   $0x73
  80224b:	68 e7 43 80 00       	push   $0x8043e7
  802250:	e8 a7 e1 ff ff       	call   8003fc <_panic>
  802255:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	89 50 04             	mov    %edx,0x4(%eax)
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	8b 40 04             	mov    0x4(%eax),%eax
  802267:	85 c0                	test   %eax,%eax
  802269:	74 0c                	je     802277 <insert_sorted_allocList+0x179>
  80226b:	a1 44 50 80 00       	mov    0x805044,%eax
  802270:	8b 55 08             	mov    0x8(%ebp),%edx
  802273:	89 10                	mov    %edx,(%eax)
  802275:	eb 08                	jmp    80227f <insert_sorted_allocList+0x181>
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	a3 40 50 80 00       	mov    %eax,0x805040
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	a3 44 50 80 00       	mov    %eax,0x805044
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802290:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802295:	40                   	inc    %eax
  802296:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80229b:	e9 e7 00 00 00       	jmp    802387 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022a6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022ad:	a1 40 50 80 00       	mov    0x805040,%eax
  8022b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b5:	e9 9d 00 00 00       	jmp    802357 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	8b 00                	mov    (%eax),%eax
  8022bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	8b 50 08             	mov    0x8(%eax),%edx
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ce:	39 c2                	cmp    %eax,%edx
  8022d0:	76 7d                	jbe    80234f <insert_sorted_allocList+0x251>
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	8b 50 08             	mov    0x8(%eax),%edx
  8022d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022db:	8b 40 08             	mov    0x8(%eax),%eax
  8022de:	39 c2                	cmp    %eax,%edx
  8022e0:	73 6d                	jae    80234f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e6:	74 06                	je     8022ee <insert_sorted_allocList+0x1f0>
  8022e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ec:	75 14                	jne    802302 <insert_sorted_allocList+0x204>
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	68 5c 44 80 00       	push   $0x80445c
  8022f6:	6a 7f                	push   $0x7f
  8022f8:	68 e7 43 80 00       	push   $0x8043e7
  8022fd:	e8 fa e0 ff ff       	call   8003fc <_panic>
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 10                	mov    (%eax),%edx
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	89 10                	mov    %edx,(%eax)
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	8b 00                	mov    (%eax),%eax
  802311:	85 c0                	test   %eax,%eax
  802313:	74 0b                	je     802320 <insert_sorted_allocList+0x222>
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	8b 00                	mov    (%eax),%eax
  80231a:	8b 55 08             	mov    0x8(%ebp),%edx
  80231d:	89 50 04             	mov    %edx,0x4(%eax)
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 55 08             	mov    0x8(%ebp),%edx
  802326:	89 10                	mov    %edx,(%eax)
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232e:	89 50 04             	mov    %edx,0x4(%eax)
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	8b 00                	mov    (%eax),%eax
  802336:	85 c0                	test   %eax,%eax
  802338:	75 08                	jne    802342 <insert_sorted_allocList+0x244>
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	a3 44 50 80 00       	mov    %eax,0x805044
  802342:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802347:	40                   	inc    %eax
  802348:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80234d:	eb 39                	jmp    802388 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80234f:	a1 48 50 80 00       	mov    0x805048,%eax
  802354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235b:	74 07                	je     802364 <insert_sorted_allocList+0x266>
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	8b 00                	mov    (%eax),%eax
  802362:	eb 05                	jmp    802369 <insert_sorted_allocList+0x26b>
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
  802369:	a3 48 50 80 00       	mov    %eax,0x805048
  80236e:	a1 48 50 80 00       	mov    0x805048,%eax
  802373:	85 c0                	test   %eax,%eax
  802375:	0f 85 3f ff ff ff    	jne    8022ba <insert_sorted_allocList+0x1bc>
  80237b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237f:	0f 85 35 ff ff ff    	jne    8022ba <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802385:	eb 01                	jmp    802388 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802387:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802388:	90                   	nop
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802391:	a1 38 51 80 00       	mov    0x805138,%eax
  802396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802399:	e9 85 01 00 00       	jmp    802523 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a7:	0f 82 6e 01 00 00    	jb     80251b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b6:	0f 85 8a 00 00 00    	jne    802446 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c0:	75 17                	jne    8023d9 <alloc_block_FF+0x4e>
  8023c2:	83 ec 04             	sub    $0x4,%esp
  8023c5:	68 90 44 80 00       	push   $0x804490
  8023ca:	68 93 00 00 00       	push   $0x93
  8023cf:	68 e7 43 80 00       	push   $0x8043e7
  8023d4:	e8 23 e0 ff ff       	call   8003fc <_panic>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	74 10                	je     8023f2 <alloc_block_FF+0x67>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ea:	8b 52 04             	mov    0x4(%edx),%edx
  8023ed:	89 50 04             	mov    %edx,0x4(%eax)
  8023f0:	eb 0b                	jmp    8023fd <alloc_block_FF+0x72>
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 04             	mov    0x4(%eax),%eax
  8023f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 40 04             	mov    0x4(%eax),%eax
  802403:	85 c0                	test   %eax,%eax
  802405:	74 0f                	je     802416 <alloc_block_FF+0x8b>
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 40 04             	mov    0x4(%eax),%eax
  80240d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802410:	8b 12                	mov    (%edx),%edx
  802412:	89 10                	mov    %edx,(%eax)
  802414:	eb 0a                	jmp    802420 <alloc_block_FF+0x95>
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 00                	mov    (%eax),%eax
  80241b:	a3 38 51 80 00       	mov    %eax,0x805138
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802433:	a1 44 51 80 00       	mov    0x805144,%eax
  802438:	48                   	dec    %eax
  802439:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	e9 10 01 00 00       	jmp    802556 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 40 0c             	mov    0xc(%eax),%eax
  80244c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244f:	0f 86 c6 00 00 00    	jbe    80251b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802455:	a1 48 51 80 00       	mov    0x805148,%eax
  80245a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 50 08             	mov    0x8(%eax),%edx
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	8b 55 08             	mov    0x8(%ebp),%edx
  80246f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802476:	75 17                	jne    80248f <alloc_block_FF+0x104>
  802478:	83 ec 04             	sub    $0x4,%esp
  80247b:	68 90 44 80 00       	push   $0x804490
  802480:	68 9b 00 00 00       	push   $0x9b
  802485:	68 e7 43 80 00       	push   $0x8043e7
  80248a:	e8 6d df ff ff       	call   8003fc <_panic>
  80248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 10                	je     8024a8 <alloc_block_FF+0x11d>
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a0:	8b 52 04             	mov    0x4(%edx),%edx
  8024a3:	89 50 04             	mov    %edx,0x4(%eax)
  8024a6:	eb 0b                	jmp    8024b3 <alloc_block_FF+0x128>
  8024a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ab:	8b 40 04             	mov    0x4(%eax),%eax
  8024ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b6:	8b 40 04             	mov    0x4(%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 0f                	je     8024cc <alloc_block_FF+0x141>
  8024bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c6:	8b 12                	mov    (%edx),%edx
  8024c8:	89 10                	mov    %edx,(%eax)
  8024ca:	eb 0a                	jmp    8024d6 <alloc_block_FF+0x14b>
  8024cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8024d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8024ee:	48                   	dec    %eax
  8024ef:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 50 08             	mov    0x8(%eax),%edx
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	01 c2                	add    %eax,%edx
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 0c             	mov    0xc(%eax),%eax
  80250b:	2b 45 08             	sub    0x8(%ebp),%eax
  80250e:	89 c2                	mov    %eax,%edx
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802519:	eb 3b                	jmp    802556 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80251b:	a1 40 51 80 00       	mov    0x805140,%eax
  802520:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802523:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802527:	74 07                	je     802530 <alloc_block_FF+0x1a5>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	eb 05                	jmp    802535 <alloc_block_FF+0x1aa>
  802530:	b8 00 00 00 00       	mov    $0x0,%eax
  802535:	a3 40 51 80 00       	mov    %eax,0x805140
  80253a:	a1 40 51 80 00       	mov    0x805140,%eax
  80253f:	85 c0                	test   %eax,%eax
  802541:	0f 85 57 fe ff ff    	jne    80239e <alloc_block_FF+0x13>
  802547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254b:	0f 85 4d fe ff ff    	jne    80239e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802551:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80255e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802565:	a1 38 51 80 00       	mov    0x805138,%eax
  80256a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256d:	e9 df 00 00 00       	jmp    802651 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 40 0c             	mov    0xc(%eax),%eax
  802578:	3b 45 08             	cmp    0x8(%ebp),%eax
  80257b:	0f 82 c8 00 00 00    	jb     802649 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 40 0c             	mov    0xc(%eax),%eax
  802587:	3b 45 08             	cmp    0x8(%ebp),%eax
  80258a:	0f 85 8a 00 00 00    	jne    80261a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802594:	75 17                	jne    8025ad <alloc_block_BF+0x55>
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	68 90 44 80 00       	push   $0x804490
  80259e:	68 b7 00 00 00       	push   $0xb7
  8025a3:	68 e7 43 80 00       	push   $0x8043e7
  8025a8:	e8 4f de ff ff       	call   8003fc <_panic>
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	74 10                	je     8025c6 <alloc_block_BF+0x6e>
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025be:	8b 52 04             	mov    0x4(%edx),%edx
  8025c1:	89 50 04             	mov    %edx,0x4(%eax)
  8025c4:	eb 0b                	jmp    8025d1 <alloc_block_BF+0x79>
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 04             	mov    0x4(%eax),%eax
  8025cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 0f                	je     8025ea <alloc_block_BF+0x92>
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e4:	8b 12                	mov    (%edx),%edx
  8025e6:	89 10                	mov    %edx,(%eax)
  8025e8:	eb 0a                	jmp    8025f4 <alloc_block_BF+0x9c>
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	a3 38 51 80 00       	mov    %eax,0x805138
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802607:	a1 44 51 80 00       	mov    0x805144,%eax
  80260c:	48                   	dec    %eax
  80260d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	e9 4d 01 00 00       	jmp    802767 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 40 0c             	mov    0xc(%eax),%eax
  802620:	3b 45 08             	cmp    0x8(%ebp),%eax
  802623:	76 24                	jbe    802649 <alloc_block_BF+0xf1>
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 40 0c             	mov    0xc(%eax),%eax
  80262b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80262e:	73 19                	jae    802649 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802630:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 40 0c             	mov    0xc(%eax),%eax
  80263d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 08             	mov    0x8(%eax),%eax
  802646:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802649:	a1 40 51 80 00       	mov    0x805140,%eax
  80264e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802655:	74 07                	je     80265e <alloc_block_BF+0x106>
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 00                	mov    (%eax),%eax
  80265c:	eb 05                	jmp    802663 <alloc_block_BF+0x10b>
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
  802663:	a3 40 51 80 00       	mov    %eax,0x805140
  802668:	a1 40 51 80 00       	mov    0x805140,%eax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	0f 85 fd fe ff ff    	jne    802572 <alloc_block_BF+0x1a>
  802675:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802679:	0f 85 f3 fe ff ff    	jne    802572 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80267f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802683:	0f 84 d9 00 00 00    	je     802762 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802689:	a1 48 51 80 00       	mov    0x805148,%eax
  80268e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802694:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802697:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80269a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269d:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026a7:	75 17                	jne    8026c0 <alloc_block_BF+0x168>
  8026a9:	83 ec 04             	sub    $0x4,%esp
  8026ac:	68 90 44 80 00       	push   $0x804490
  8026b1:	68 c7 00 00 00       	push   $0xc7
  8026b6:	68 e7 43 80 00       	push   $0x8043e7
  8026bb:	e8 3c dd ff ff       	call   8003fc <_panic>
  8026c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 10                	je     8026d9 <alloc_block_BF+0x181>
  8026c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026d1:	8b 52 04             	mov    0x4(%edx),%edx
  8026d4:	89 50 04             	mov    %edx,0x4(%eax)
  8026d7:	eb 0b                	jmp    8026e4 <alloc_block_BF+0x18c>
  8026d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026dc:	8b 40 04             	mov    0x4(%eax),%eax
  8026df:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	74 0f                	je     8026fd <alloc_block_BF+0x1a5>
  8026ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f7:	8b 12                	mov    (%edx),%edx
  8026f9:	89 10                	mov    %edx,(%eax)
  8026fb:	eb 0a                	jmp    802707 <alloc_block_BF+0x1af>
  8026fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	a3 48 51 80 00       	mov    %eax,0x805148
  802707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802713:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271a:	a1 54 51 80 00       	mov    0x805154,%eax
  80271f:	48                   	dec    %eax
  802720:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802725:	83 ec 08             	sub    $0x8,%esp
  802728:	ff 75 ec             	pushl  -0x14(%ebp)
  80272b:	68 38 51 80 00       	push   $0x805138
  802730:	e8 71 f9 ff ff       	call   8020a6 <find_block>
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80273b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273e:	8b 50 08             	mov    0x8(%eax),%edx
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	01 c2                	add    %eax,%edx
  802746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802749:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80274c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274f:	8b 40 0c             	mov    0xc(%eax),%eax
  802752:	2b 45 08             	sub    0x8(%ebp),%eax
  802755:	89 c2                	mov    %eax,%edx
  802757:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80275d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802760:	eb 05                	jmp    802767 <alloc_block_BF+0x20f>
	}
	return NULL;
  802762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802767:	c9                   	leave  
  802768:	c3                   	ret    

00802769 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802769:	55                   	push   %ebp
  80276a:	89 e5                	mov    %esp,%ebp
  80276c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80276f:	a1 28 50 80 00       	mov    0x805028,%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	0f 85 de 01 00 00    	jne    80295a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80277c:	a1 38 51 80 00       	mov    0x805138,%eax
  802781:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802784:	e9 9e 01 00 00       	jmp    802927 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 40 0c             	mov    0xc(%eax),%eax
  80278f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802792:	0f 82 87 01 00 00    	jb     80291f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 40 0c             	mov    0xc(%eax),%eax
  80279e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a1:	0f 85 95 00 00 00    	jne    80283c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ab:	75 17                	jne    8027c4 <alloc_block_NF+0x5b>
  8027ad:	83 ec 04             	sub    $0x4,%esp
  8027b0:	68 90 44 80 00       	push   $0x804490
  8027b5:	68 e0 00 00 00       	push   $0xe0
  8027ba:	68 e7 43 80 00       	push   $0x8043e7
  8027bf:	e8 38 dc ff ff       	call   8003fc <_panic>
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 00                	mov    (%eax),%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	74 10                	je     8027dd <alloc_block_NF+0x74>
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d5:	8b 52 04             	mov    0x4(%edx),%edx
  8027d8:	89 50 04             	mov    %edx,0x4(%eax)
  8027db:	eb 0b                	jmp    8027e8 <alloc_block_NF+0x7f>
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 40 04             	mov    0x4(%eax),%eax
  8027e3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	74 0f                	je     802801 <alloc_block_NF+0x98>
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 40 04             	mov    0x4(%eax),%eax
  8027f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fb:	8b 12                	mov    (%edx),%edx
  8027fd:	89 10                	mov    %edx,(%eax)
  8027ff:	eb 0a                	jmp    80280b <alloc_block_NF+0xa2>
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	a3 38 51 80 00       	mov    %eax,0x805138
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281e:	a1 44 51 80 00       	mov    0x805144,%eax
  802823:	48                   	dec    %eax
  802824:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 40 08             	mov    0x8(%eax),%eax
  80282f:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	e9 f8 04 00 00       	jmp    802d34 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 0c             	mov    0xc(%eax),%eax
  802842:	3b 45 08             	cmp    0x8(%ebp),%eax
  802845:	0f 86 d4 00 00 00    	jbe    80291f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80284b:	a1 48 51 80 00       	mov    0x805148,%eax
  802850:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 50 08             	mov    0x8(%eax),%edx
  802859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80285f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802862:	8b 55 08             	mov    0x8(%ebp),%edx
  802865:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802868:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80286c:	75 17                	jne    802885 <alloc_block_NF+0x11c>
  80286e:	83 ec 04             	sub    $0x4,%esp
  802871:	68 90 44 80 00       	push   $0x804490
  802876:	68 e9 00 00 00       	push   $0xe9
  80287b:	68 e7 43 80 00       	push   $0x8043e7
  802880:	e8 77 db ff ff       	call   8003fc <_panic>
  802885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	74 10                	je     80289e <alloc_block_NF+0x135>
  80288e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802896:	8b 52 04             	mov    0x4(%edx),%edx
  802899:	89 50 04             	mov    %edx,0x4(%eax)
  80289c:	eb 0b                	jmp    8028a9 <alloc_block_NF+0x140>
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	8b 40 04             	mov    0x4(%eax),%eax
  8028a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 0f                	je     8028c2 <alloc_block_NF+0x159>
  8028b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b6:	8b 40 04             	mov    0x4(%eax),%eax
  8028b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028bc:	8b 12                	mov    (%edx),%edx
  8028be:	89 10                	mov    %edx,(%eax)
  8028c0:	eb 0a                	jmp    8028cc <alloc_block_NF+0x163>
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	a3 48 51 80 00       	mov    %eax,0x805148
  8028cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028df:	a1 54 51 80 00       	mov    0x805154,%eax
  8028e4:	48                   	dec    %eax
  8028e5:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ed:	8b 40 08             	mov    0x8(%eax),%eax
  8028f0:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 50 08             	mov    0x8(%eax),%edx
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	01 c2                	add    %eax,%edx
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 40 0c             	mov    0xc(%eax),%eax
  80290c:	2b 45 08             	sub    0x8(%ebp),%eax
  80290f:	89 c2                	mov    %eax,%edx
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291a:	e9 15 04 00 00       	jmp    802d34 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80291f:	a1 40 51 80 00       	mov    0x805140,%eax
  802924:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802927:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292b:	74 07                	je     802934 <alloc_block_NF+0x1cb>
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 00                	mov    (%eax),%eax
  802932:	eb 05                	jmp    802939 <alloc_block_NF+0x1d0>
  802934:	b8 00 00 00 00       	mov    $0x0,%eax
  802939:	a3 40 51 80 00       	mov    %eax,0x805140
  80293e:	a1 40 51 80 00       	mov    0x805140,%eax
  802943:	85 c0                	test   %eax,%eax
  802945:	0f 85 3e fe ff ff    	jne    802789 <alloc_block_NF+0x20>
  80294b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294f:	0f 85 34 fe ff ff    	jne    802789 <alloc_block_NF+0x20>
  802955:	e9 d5 03 00 00       	jmp    802d2f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80295a:	a1 38 51 80 00       	mov    0x805138,%eax
  80295f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802962:	e9 b1 01 00 00       	jmp    802b18 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 50 08             	mov    0x8(%eax),%edx
  80296d:	a1 28 50 80 00       	mov    0x805028,%eax
  802972:	39 c2                	cmp    %eax,%edx
  802974:	0f 82 96 01 00 00    	jb     802b10 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 0c             	mov    0xc(%eax),%eax
  802980:	3b 45 08             	cmp    0x8(%ebp),%eax
  802983:	0f 82 87 01 00 00    	jb     802b10 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 40 0c             	mov    0xc(%eax),%eax
  80298f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802992:	0f 85 95 00 00 00    	jne    802a2d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802998:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299c:	75 17                	jne    8029b5 <alloc_block_NF+0x24c>
  80299e:	83 ec 04             	sub    $0x4,%esp
  8029a1:	68 90 44 80 00       	push   $0x804490
  8029a6:	68 fc 00 00 00       	push   $0xfc
  8029ab:	68 e7 43 80 00       	push   $0x8043e7
  8029b0:	e8 47 da ff ff       	call   8003fc <_panic>
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	74 10                	je     8029ce <alloc_block_NF+0x265>
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c6:	8b 52 04             	mov    0x4(%edx),%edx
  8029c9:	89 50 04             	mov    %edx,0x4(%eax)
  8029cc:	eb 0b                	jmp    8029d9 <alloc_block_NF+0x270>
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 40 04             	mov    0x4(%eax),%eax
  8029d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	74 0f                	je     8029f2 <alloc_block_NF+0x289>
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 40 04             	mov    0x4(%eax),%eax
  8029e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ec:	8b 12                	mov    (%edx),%edx
  8029ee:	89 10                	mov    %edx,(%eax)
  8029f0:	eb 0a                	jmp    8029fc <alloc_block_NF+0x293>
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	a3 38 51 80 00       	mov    %eax,0x805138
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0f:	a1 44 51 80 00       	mov    0x805144,%eax
  802a14:	48                   	dec    %eax
  802a15:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 40 08             	mov    0x8(%eax),%eax
  802a20:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	e9 07 03 00 00       	jmp    802d34 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 40 0c             	mov    0xc(%eax),%eax
  802a33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a36:	0f 86 d4 00 00 00    	jbe    802b10 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a3c:	a1 48 51 80 00       	mov    0x805148,%eax
  802a41:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 50 08             	mov    0x8(%eax),%edx
  802a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a53:	8b 55 08             	mov    0x8(%ebp),%edx
  802a56:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a59:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a5d:	75 17                	jne    802a76 <alloc_block_NF+0x30d>
  802a5f:	83 ec 04             	sub    $0x4,%esp
  802a62:	68 90 44 80 00       	push   $0x804490
  802a67:	68 04 01 00 00       	push   $0x104
  802a6c:	68 e7 43 80 00       	push   $0x8043e7
  802a71:	e8 86 d9 ff ff       	call   8003fc <_panic>
  802a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	74 10                	je     802a8f <alloc_block_NF+0x326>
  802a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a87:	8b 52 04             	mov    0x4(%edx),%edx
  802a8a:	89 50 04             	mov    %edx,0x4(%eax)
  802a8d:	eb 0b                	jmp    802a9a <alloc_block_NF+0x331>
  802a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a92:	8b 40 04             	mov    0x4(%eax),%eax
  802a95:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9d:	8b 40 04             	mov    0x4(%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	74 0f                	je     802ab3 <alloc_block_NF+0x34a>
  802aa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aad:	8b 12                	mov    (%edx),%edx
  802aaf:	89 10                	mov    %edx,(%eax)
  802ab1:	eb 0a                	jmp    802abd <alloc_block_NF+0x354>
  802ab3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	a3 48 51 80 00       	mov    %eax,0x805148
  802abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ad5:	48                   	dec    %eax
  802ad6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802adb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ade:	8b 40 08             	mov    0x8(%eax),%eax
  802ae1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 50 08             	mov    0x8(%eax),%edx
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	01 c2                	add    %eax,%edx
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 40 0c             	mov    0xc(%eax),%eax
  802afd:	2b 45 08             	sub    0x8(%ebp),%eax
  802b00:	89 c2                	mov    %eax,%edx
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0b:	e9 24 02 00 00       	jmp    802d34 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b10:	a1 40 51 80 00       	mov    0x805140,%eax
  802b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1c:	74 07                	je     802b25 <alloc_block_NF+0x3bc>
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	eb 05                	jmp    802b2a <alloc_block_NF+0x3c1>
  802b25:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2a:	a3 40 51 80 00       	mov    %eax,0x805140
  802b2f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	0f 85 2b fe ff ff    	jne    802967 <alloc_block_NF+0x1fe>
  802b3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b40:	0f 85 21 fe ff ff    	jne    802967 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b46:	a1 38 51 80 00       	mov    0x805138,%eax
  802b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b4e:	e9 ae 01 00 00       	jmp    802d01 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 50 08             	mov    0x8(%eax),%edx
  802b59:	a1 28 50 80 00       	mov    0x805028,%eax
  802b5e:	39 c2                	cmp    %eax,%edx
  802b60:	0f 83 93 01 00 00    	jae    802cf9 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b6f:	0f 82 84 01 00 00    	jb     802cf9 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7e:	0f 85 95 00 00 00    	jne    802c19 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b88:	75 17                	jne    802ba1 <alloc_block_NF+0x438>
  802b8a:	83 ec 04             	sub    $0x4,%esp
  802b8d:	68 90 44 80 00       	push   $0x804490
  802b92:	68 14 01 00 00       	push   $0x114
  802b97:	68 e7 43 80 00       	push   $0x8043e7
  802b9c:	e8 5b d8 ff ff       	call   8003fc <_panic>
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	74 10                	je     802bba <alloc_block_NF+0x451>
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb2:	8b 52 04             	mov    0x4(%edx),%edx
  802bb5:	89 50 04             	mov    %edx,0x4(%eax)
  802bb8:	eb 0b                	jmp    802bc5 <alloc_block_NF+0x45c>
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 04             	mov    0x4(%eax),%eax
  802bc0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 40 04             	mov    0x4(%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 0f                	je     802bde <alloc_block_NF+0x475>
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 40 04             	mov    0x4(%eax),%eax
  802bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd8:	8b 12                	mov    (%edx),%edx
  802bda:	89 10                	mov    %edx,(%eax)
  802bdc:	eb 0a                	jmp    802be8 <alloc_block_NF+0x47f>
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 00                	mov    (%eax),%eax
  802be3:	a3 38 51 80 00       	mov    %eax,0x805138
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bfb:	a1 44 51 80 00       	mov    0x805144,%eax
  802c00:	48                   	dec    %eax
  802c01:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	8b 40 08             	mov    0x8(%eax),%eax
  802c0c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	e9 1b 01 00 00       	jmp    802d34 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c22:	0f 86 d1 00 00 00    	jbe    802cf9 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c28:	a1 48 51 80 00       	mov    0x805148,%eax
  802c2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 50 08             	mov    0x8(%eax),%edx
  802c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c39:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c42:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c49:	75 17                	jne    802c62 <alloc_block_NF+0x4f9>
  802c4b:	83 ec 04             	sub    $0x4,%esp
  802c4e:	68 90 44 80 00       	push   $0x804490
  802c53:	68 1c 01 00 00       	push   $0x11c
  802c58:	68 e7 43 80 00       	push   $0x8043e7
  802c5d:	e8 9a d7 ff ff       	call   8003fc <_panic>
  802c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 10                	je     802c7b <alloc_block_NF+0x512>
  802c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c73:	8b 52 04             	mov    0x4(%edx),%edx
  802c76:	89 50 04             	mov    %edx,0x4(%eax)
  802c79:	eb 0b                	jmp    802c86 <alloc_block_NF+0x51d>
  802c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7e:	8b 40 04             	mov    0x4(%eax),%eax
  802c81:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 0f                	je     802c9f <alloc_block_NF+0x536>
  802c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c99:	8b 12                	mov    (%edx),%edx
  802c9b:	89 10                	mov    %edx,(%eax)
  802c9d:	eb 0a                	jmp    802ca9 <alloc_block_NF+0x540>
  802c9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca2:	8b 00                	mov    (%eax),%eax
  802ca4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbc:	a1 54 51 80 00       	mov    0x805154,%eax
  802cc1:	48                   	dec    %eax
  802cc2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	8b 40 08             	mov    0x8(%eax),%eax
  802ccd:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 50 08             	mov    0x8(%eax),%edx
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	01 c2                	add    %eax,%edx
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce9:	2b 45 08             	sub    0x8(%ebp),%eax
  802cec:	89 c2                	mov    %eax,%edx
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf7:	eb 3b                	jmp    802d34 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cf9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d05:	74 07                	je     802d0e <alloc_block_NF+0x5a5>
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	eb 05                	jmp    802d13 <alloc_block_NF+0x5aa>
  802d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d13:	a3 40 51 80 00       	mov    %eax,0x805140
  802d18:	a1 40 51 80 00       	mov    0x805140,%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	0f 85 2e fe ff ff    	jne    802b53 <alloc_block_NF+0x3ea>
  802d25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d29:	0f 85 24 fe ff ff    	jne    802b53 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d34:	c9                   	leave  
  802d35:	c3                   	ret    

00802d36 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d36:	55                   	push   %ebp
  802d37:	89 e5                	mov    %esp,%ebp
  802d39:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d3c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d44:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d49:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d4c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	74 14                	je     802d69 <insert_sorted_with_merge_freeList+0x33>
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 50 08             	mov    0x8(%eax),%edx
  802d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5e:	8b 40 08             	mov    0x8(%eax),%eax
  802d61:	39 c2                	cmp    %eax,%edx
  802d63:	0f 87 9b 01 00 00    	ja     802f04 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6d:	75 17                	jne    802d86 <insert_sorted_with_merge_freeList+0x50>
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	68 c4 43 80 00       	push   $0x8043c4
  802d77:	68 38 01 00 00       	push   $0x138
  802d7c:	68 e7 43 80 00       	push   $0x8043e7
  802d81:	e8 76 d6 ff ff       	call   8003fc <_panic>
  802d86:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	89 10                	mov    %edx,(%eax)
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 0d                	je     802da7 <insert_sorted_with_merge_freeList+0x71>
  802d9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802da2:	89 50 04             	mov    %edx,0x4(%eax)
  802da5:	eb 08                	jmp    802daf <insert_sorted_with_merge_freeList+0x79>
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	a3 38 51 80 00       	mov    %eax,0x805138
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc1:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc6:	40                   	inc    %eax
  802dc7:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd0:	0f 84 a8 06 00 00    	je     80347e <insert_sorted_with_merge_freeList+0x748>
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	8b 50 08             	mov    0x8(%eax),%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 40 0c             	mov    0xc(%eax),%eax
  802de2:	01 c2                	add    %eax,%edx
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	8b 40 08             	mov    0x8(%eax),%eax
  802dea:	39 c2                	cmp    %eax,%edx
  802dec:	0f 85 8c 06 00 00    	jne    80347e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 50 0c             	mov    0xc(%eax),%edx
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfe:	01 c2                	add    %eax,%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e0a:	75 17                	jne    802e23 <insert_sorted_with_merge_freeList+0xed>
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	68 90 44 80 00       	push   $0x804490
  802e14:	68 3c 01 00 00       	push   $0x13c
  802e19:	68 e7 43 80 00       	push   $0x8043e7
  802e1e:	e8 d9 d5 ff ff       	call   8003fc <_panic>
  802e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 10                	je     802e3c <insert_sorted_with_merge_freeList+0x106>
  802e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e34:	8b 52 04             	mov    0x4(%edx),%edx
  802e37:	89 50 04             	mov    %edx,0x4(%eax)
  802e3a:	eb 0b                	jmp    802e47 <insert_sorted_with_merge_freeList+0x111>
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	8b 40 04             	mov    0x4(%eax),%eax
  802e42:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4a:	8b 40 04             	mov    0x4(%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 0f                	je     802e60 <insert_sorted_with_merge_freeList+0x12a>
  802e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e5a:	8b 12                	mov    (%edx),%edx
  802e5c:	89 10                	mov    %edx,(%eax)
  802e5e:	eb 0a                	jmp    802e6a <insert_sorted_with_merge_freeList+0x134>
  802e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	a3 38 51 80 00       	mov    %eax,0x805138
  802e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e82:	48                   	dec    %eax
  802e83:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea0:	75 17                	jne    802eb9 <insert_sorted_with_merge_freeList+0x183>
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	68 c4 43 80 00       	push   $0x8043c4
  802eaa:	68 3f 01 00 00       	push   $0x13f
  802eaf:	68 e7 43 80 00       	push   $0x8043e7
  802eb4:	e8 43 d5 ff ff       	call   8003fc <_panic>
  802eb9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec2:	89 10                	mov    %edx,(%eax)
  802ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec7:	8b 00                	mov    (%eax),%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	74 0d                	je     802eda <insert_sorted_with_merge_freeList+0x1a4>
  802ecd:	a1 48 51 80 00       	mov    0x805148,%eax
  802ed2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed5:	89 50 04             	mov    %edx,0x4(%eax)
  802ed8:	eb 08                	jmp    802ee2 <insert_sorted_with_merge_freeList+0x1ac>
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	a3 48 51 80 00       	mov    %eax,0x805148
  802eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef4:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef9:	40                   	inc    %eax
  802efa:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eff:	e9 7a 05 00 00       	jmp    80347e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	8b 50 08             	mov    0x8(%eax),%edx
  802f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0d:	8b 40 08             	mov    0x8(%eax),%eax
  802f10:	39 c2                	cmp    %eax,%edx
  802f12:	0f 82 14 01 00 00    	jb     80302c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1b:	8b 50 08             	mov    0x8(%eax),%edx
  802f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f21:	8b 40 0c             	mov    0xc(%eax),%eax
  802f24:	01 c2                	add    %eax,%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	8b 40 08             	mov    0x8(%eax),%eax
  802f2c:	39 c2                	cmp    %eax,%edx
  802f2e:	0f 85 90 00 00 00    	jne    802fc4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f40:	01 c2                	add    %eax,%edx
  802f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f45:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f60:	75 17                	jne    802f79 <insert_sorted_with_merge_freeList+0x243>
  802f62:	83 ec 04             	sub    $0x4,%esp
  802f65:	68 c4 43 80 00       	push   $0x8043c4
  802f6a:	68 49 01 00 00       	push   $0x149
  802f6f:	68 e7 43 80 00       	push   $0x8043e7
  802f74:	e8 83 d4 ff ff       	call   8003fc <_panic>
  802f79:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	89 10                	mov    %edx,(%eax)
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	74 0d                	je     802f9a <insert_sorted_with_merge_freeList+0x264>
  802f8d:	a1 48 51 80 00       	mov    0x805148,%eax
  802f92:	8b 55 08             	mov    0x8(%ebp),%edx
  802f95:	89 50 04             	mov    %edx,0x4(%eax)
  802f98:	eb 08                	jmp    802fa2 <insert_sorted_with_merge_freeList+0x26c>
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	a3 48 51 80 00       	mov    %eax,0x805148
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb4:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb9:	40                   	inc    %eax
  802fba:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fbf:	e9 bb 04 00 00       	jmp    80347f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc8:	75 17                	jne    802fe1 <insert_sorted_with_merge_freeList+0x2ab>
  802fca:	83 ec 04             	sub    $0x4,%esp
  802fcd:	68 38 44 80 00       	push   $0x804438
  802fd2:	68 4c 01 00 00       	push   $0x14c
  802fd7:	68 e7 43 80 00       	push   $0x8043e7
  802fdc:	e8 1b d4 ff ff       	call   8003fc <_panic>
  802fe1:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	89 50 04             	mov    %edx,0x4(%eax)
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	8b 40 04             	mov    0x4(%eax),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	74 0c                	je     803003 <insert_sorted_with_merge_freeList+0x2cd>
  802ff7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  802fff:	89 10                	mov    %edx,(%eax)
  803001:	eb 08                	jmp    80300b <insert_sorted_with_merge_freeList+0x2d5>
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	a3 38 51 80 00       	mov    %eax,0x805138
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301c:	a1 44 51 80 00       	mov    0x805144,%eax
  803021:	40                   	inc    %eax
  803022:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803027:	e9 53 04 00 00       	jmp    80347f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80302c:	a1 38 51 80 00       	mov    0x805138,%eax
  803031:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803034:	e9 15 04 00 00       	jmp    80344e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	8b 50 08             	mov    0x8(%eax),%edx
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	8b 40 08             	mov    0x8(%eax),%eax
  80304d:	39 c2                	cmp    %eax,%edx
  80304f:	0f 86 f1 03 00 00    	jbe    803446 <insert_sorted_with_merge_freeList+0x710>
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	8b 50 08             	mov    0x8(%eax),%edx
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	8b 40 08             	mov    0x8(%eax),%eax
  803061:	39 c2                	cmp    %eax,%edx
  803063:	0f 83 dd 03 00 00    	jae    803446 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306c:	8b 50 08             	mov    0x8(%eax),%edx
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 40 0c             	mov    0xc(%eax),%eax
  803075:	01 c2                	add    %eax,%edx
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	8b 40 08             	mov    0x8(%eax),%eax
  80307d:	39 c2                	cmp    %eax,%edx
  80307f:	0f 85 b9 01 00 00    	jne    80323e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	8b 50 08             	mov    0x8(%eax),%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8b 40 0c             	mov    0xc(%eax),%eax
  803091:	01 c2                	add    %eax,%edx
  803093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803096:	8b 40 08             	mov    0x8(%eax),%eax
  803099:	39 c2                	cmp    %eax,%edx
  80309b:	0f 85 0d 01 00 00    	jne    8031ae <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ad:	01 c2                	add    %eax,%edx
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b9:	75 17                	jne    8030d2 <insert_sorted_with_merge_freeList+0x39c>
  8030bb:	83 ec 04             	sub    $0x4,%esp
  8030be:	68 90 44 80 00       	push   $0x804490
  8030c3:	68 5c 01 00 00       	push   $0x15c
  8030c8:	68 e7 43 80 00       	push   $0x8043e7
  8030cd:	e8 2a d3 ff ff       	call   8003fc <_panic>
  8030d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d5:	8b 00                	mov    (%eax),%eax
  8030d7:	85 c0                	test   %eax,%eax
  8030d9:	74 10                	je     8030eb <insert_sorted_with_merge_freeList+0x3b5>
  8030db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e3:	8b 52 04             	mov    0x4(%edx),%edx
  8030e6:	89 50 04             	mov    %edx,0x4(%eax)
  8030e9:	eb 0b                	jmp    8030f6 <insert_sorted_with_merge_freeList+0x3c0>
  8030eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ee:	8b 40 04             	mov    0x4(%eax),%eax
  8030f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f9:	8b 40 04             	mov    0x4(%eax),%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	74 0f                	je     80310f <insert_sorted_with_merge_freeList+0x3d9>
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	8b 40 04             	mov    0x4(%eax),%eax
  803106:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803109:	8b 12                	mov    (%edx),%edx
  80310b:	89 10                	mov    %edx,(%eax)
  80310d:	eb 0a                	jmp    803119 <insert_sorted_with_merge_freeList+0x3e3>
  80310f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	a3 38 51 80 00       	mov    %eax,0x805138
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803122:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803125:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312c:	a1 44 51 80 00       	mov    0x805144,%eax
  803131:	48                   	dec    %eax
  803132:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80314b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80314f:	75 17                	jne    803168 <insert_sorted_with_merge_freeList+0x432>
  803151:	83 ec 04             	sub    $0x4,%esp
  803154:	68 c4 43 80 00       	push   $0x8043c4
  803159:	68 5f 01 00 00       	push   $0x15f
  80315e:	68 e7 43 80 00       	push   $0x8043e7
  803163:	e8 94 d2 ff ff       	call   8003fc <_panic>
  803168:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80316e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803171:	89 10                	mov    %edx,(%eax)
  803173:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803176:	8b 00                	mov    (%eax),%eax
  803178:	85 c0                	test   %eax,%eax
  80317a:	74 0d                	je     803189 <insert_sorted_with_merge_freeList+0x453>
  80317c:	a1 48 51 80 00       	mov    0x805148,%eax
  803181:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803184:	89 50 04             	mov    %edx,0x4(%eax)
  803187:	eb 08                	jmp    803191 <insert_sorted_with_merge_freeList+0x45b>
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	a3 48 51 80 00       	mov    %eax,0x805148
  803199:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8031a8:	40                   	inc    %eax
  8031a9:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ba:	01 c2                	add    %eax,%edx
  8031bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bf:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031da:	75 17                	jne    8031f3 <insert_sorted_with_merge_freeList+0x4bd>
  8031dc:	83 ec 04             	sub    $0x4,%esp
  8031df:	68 c4 43 80 00       	push   $0x8043c4
  8031e4:	68 64 01 00 00       	push   $0x164
  8031e9:	68 e7 43 80 00       	push   $0x8043e7
  8031ee:	e8 09 d2 ff ff       	call   8003fc <_panic>
  8031f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	89 10                	mov    %edx,(%eax)
  8031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	85 c0                	test   %eax,%eax
  803205:	74 0d                	je     803214 <insert_sorted_with_merge_freeList+0x4de>
  803207:	a1 48 51 80 00       	mov    0x805148,%eax
  80320c:	8b 55 08             	mov    0x8(%ebp),%edx
  80320f:	89 50 04             	mov    %edx,0x4(%eax)
  803212:	eb 08                	jmp    80321c <insert_sorted_with_merge_freeList+0x4e6>
  803214:	8b 45 08             	mov    0x8(%ebp),%eax
  803217:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	a3 48 51 80 00       	mov    %eax,0x805148
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322e:	a1 54 51 80 00       	mov    0x805154,%eax
  803233:	40                   	inc    %eax
  803234:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803239:	e9 41 02 00 00       	jmp    80347f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	8b 50 08             	mov    0x8(%eax),%edx
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	01 c2                	add    %eax,%edx
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 40 08             	mov    0x8(%eax),%eax
  803252:	39 c2                	cmp    %eax,%edx
  803254:	0f 85 7c 01 00 00    	jne    8033d6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80325a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80325e:	74 06                	je     803266 <insert_sorted_with_merge_freeList+0x530>
  803260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803264:	75 17                	jne    80327d <insert_sorted_with_merge_freeList+0x547>
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 00 44 80 00       	push   $0x804400
  80326e:	68 69 01 00 00       	push   $0x169
  803273:	68 e7 43 80 00       	push   $0x8043e7
  803278:	e8 7f d1 ff ff       	call   8003fc <_panic>
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	8b 50 04             	mov    0x4(%eax),%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	89 50 04             	mov    %edx,0x4(%eax)
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80328f:	89 10                	mov    %edx,(%eax)
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	8b 40 04             	mov    0x4(%eax),%eax
  803297:	85 c0                	test   %eax,%eax
  803299:	74 0d                	je     8032a8 <insert_sorted_with_merge_freeList+0x572>
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a4:	89 10                	mov    %edx,(%eax)
  8032a6:	eb 08                	jmp    8032b0 <insert_sorted_with_merge_freeList+0x57a>
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b6:	89 50 04             	mov    %edx,0x4(%eax)
  8032b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032be:	40                   	inc    %eax
  8032bf:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d0:	01 c2                	add    %eax,%edx
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032dc:	75 17                	jne    8032f5 <insert_sorted_with_merge_freeList+0x5bf>
  8032de:	83 ec 04             	sub    $0x4,%esp
  8032e1:	68 90 44 80 00       	push   $0x804490
  8032e6:	68 6b 01 00 00       	push   $0x16b
  8032eb:	68 e7 43 80 00       	push   $0x8043e7
  8032f0:	e8 07 d1 ff ff       	call   8003fc <_panic>
  8032f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f8:	8b 00                	mov    (%eax),%eax
  8032fa:	85 c0                	test   %eax,%eax
  8032fc:	74 10                	je     80330e <insert_sorted_with_merge_freeList+0x5d8>
  8032fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803306:	8b 52 04             	mov    0x4(%edx),%edx
  803309:	89 50 04             	mov    %edx,0x4(%eax)
  80330c:	eb 0b                	jmp    803319 <insert_sorted_with_merge_freeList+0x5e3>
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	8b 40 04             	mov    0x4(%eax),%eax
  803314:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331c:	8b 40 04             	mov    0x4(%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 0f                	je     803332 <insert_sorted_with_merge_freeList+0x5fc>
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	8b 40 04             	mov    0x4(%eax),%eax
  803329:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332c:	8b 12                	mov    (%edx),%edx
  80332e:	89 10                	mov    %edx,(%eax)
  803330:	eb 0a                	jmp    80333c <insert_sorted_with_merge_freeList+0x606>
  803332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803335:	8b 00                	mov    (%eax),%eax
  803337:	a3 38 51 80 00       	mov    %eax,0x805138
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803348:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334f:	a1 44 51 80 00       	mov    0x805144,%eax
  803354:	48                   	dec    %eax
  803355:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80335a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803367:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80336e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803372:	75 17                	jne    80338b <insert_sorted_with_merge_freeList+0x655>
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	68 c4 43 80 00       	push   $0x8043c4
  80337c:	68 6e 01 00 00       	push   $0x16e
  803381:	68 e7 43 80 00       	push   $0x8043e7
  803386:	e8 71 d0 ff ff       	call   8003fc <_panic>
  80338b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803394:	89 10                	mov    %edx,(%eax)
  803396:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	85 c0                	test   %eax,%eax
  80339d:	74 0d                	je     8033ac <insert_sorted_with_merge_freeList+0x676>
  80339f:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033a7:	89 50 04             	mov    %edx,0x4(%eax)
  8033aa:	eb 08                	jmp    8033b4 <insert_sorted_with_merge_freeList+0x67e>
  8033ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033cb:	40                   	inc    %eax
  8033cc:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033d1:	e9 a9 00 00 00       	jmp    80347f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033da:	74 06                	je     8033e2 <insert_sorted_with_merge_freeList+0x6ac>
  8033dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e0:	75 17                	jne    8033f9 <insert_sorted_with_merge_freeList+0x6c3>
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	68 5c 44 80 00       	push   $0x80445c
  8033ea:	68 73 01 00 00       	push   $0x173
  8033ef:	68 e7 43 80 00       	push   $0x8043e7
  8033f4:	e8 03 d0 ff ff       	call   8003fc <_panic>
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	8b 10                	mov    (%eax),%edx
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	89 10                	mov    %edx,(%eax)
  803403:	8b 45 08             	mov    0x8(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	85 c0                	test   %eax,%eax
  80340a:	74 0b                	je     803417 <insert_sorted_with_merge_freeList+0x6e1>
  80340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	8b 55 08             	mov    0x8(%ebp),%edx
  803414:	89 50 04             	mov    %edx,0x4(%eax)
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 55 08             	mov    0x8(%ebp),%edx
  80341d:	89 10                	mov    %edx,(%eax)
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803425:	89 50 04             	mov    %edx,0x4(%eax)
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	75 08                	jne    803439 <insert_sorted_with_merge_freeList+0x703>
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803439:	a1 44 51 80 00       	mov    0x805144,%eax
  80343e:	40                   	inc    %eax
  80343f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803444:	eb 39                	jmp    80347f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803446:	a1 40 51 80 00       	mov    0x805140,%eax
  80344b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80344e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803452:	74 07                	je     80345b <insert_sorted_with_merge_freeList+0x725>
  803454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803457:	8b 00                	mov    (%eax),%eax
  803459:	eb 05                	jmp    803460 <insert_sorted_with_merge_freeList+0x72a>
  80345b:	b8 00 00 00 00       	mov    $0x0,%eax
  803460:	a3 40 51 80 00       	mov    %eax,0x805140
  803465:	a1 40 51 80 00       	mov    0x805140,%eax
  80346a:	85 c0                	test   %eax,%eax
  80346c:	0f 85 c7 fb ff ff    	jne    803039 <insert_sorted_with_merge_freeList+0x303>
  803472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803476:	0f 85 bd fb ff ff    	jne    803039 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80347c:	eb 01                	jmp    80347f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80347e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80347f:	90                   	nop
  803480:	c9                   	leave  
  803481:	c3                   	ret    
  803482:	66 90                	xchg   %ax,%ax

00803484 <__udivdi3>:
  803484:	55                   	push   %ebp
  803485:	57                   	push   %edi
  803486:	56                   	push   %esi
  803487:	53                   	push   %ebx
  803488:	83 ec 1c             	sub    $0x1c,%esp
  80348b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80348f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803493:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803497:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80349b:	89 ca                	mov    %ecx,%edx
  80349d:	89 f8                	mov    %edi,%eax
  80349f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034a3:	85 f6                	test   %esi,%esi
  8034a5:	75 2d                	jne    8034d4 <__udivdi3+0x50>
  8034a7:	39 cf                	cmp    %ecx,%edi
  8034a9:	77 65                	ja     803510 <__udivdi3+0x8c>
  8034ab:	89 fd                	mov    %edi,%ebp
  8034ad:	85 ff                	test   %edi,%edi
  8034af:	75 0b                	jne    8034bc <__udivdi3+0x38>
  8034b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8034b6:	31 d2                	xor    %edx,%edx
  8034b8:	f7 f7                	div    %edi
  8034ba:	89 c5                	mov    %eax,%ebp
  8034bc:	31 d2                	xor    %edx,%edx
  8034be:	89 c8                	mov    %ecx,%eax
  8034c0:	f7 f5                	div    %ebp
  8034c2:	89 c1                	mov    %eax,%ecx
  8034c4:	89 d8                	mov    %ebx,%eax
  8034c6:	f7 f5                	div    %ebp
  8034c8:	89 cf                	mov    %ecx,%edi
  8034ca:	89 fa                	mov    %edi,%edx
  8034cc:	83 c4 1c             	add    $0x1c,%esp
  8034cf:	5b                   	pop    %ebx
  8034d0:	5e                   	pop    %esi
  8034d1:	5f                   	pop    %edi
  8034d2:	5d                   	pop    %ebp
  8034d3:	c3                   	ret    
  8034d4:	39 ce                	cmp    %ecx,%esi
  8034d6:	77 28                	ja     803500 <__udivdi3+0x7c>
  8034d8:	0f bd fe             	bsr    %esi,%edi
  8034db:	83 f7 1f             	xor    $0x1f,%edi
  8034de:	75 40                	jne    803520 <__udivdi3+0x9c>
  8034e0:	39 ce                	cmp    %ecx,%esi
  8034e2:	72 0a                	jb     8034ee <__udivdi3+0x6a>
  8034e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034e8:	0f 87 9e 00 00 00    	ja     80358c <__udivdi3+0x108>
  8034ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8034f3:	89 fa                	mov    %edi,%edx
  8034f5:	83 c4 1c             	add    $0x1c,%esp
  8034f8:	5b                   	pop    %ebx
  8034f9:	5e                   	pop    %esi
  8034fa:	5f                   	pop    %edi
  8034fb:	5d                   	pop    %ebp
  8034fc:	c3                   	ret    
  8034fd:	8d 76 00             	lea    0x0(%esi),%esi
  803500:	31 ff                	xor    %edi,%edi
  803502:	31 c0                	xor    %eax,%eax
  803504:	89 fa                	mov    %edi,%edx
  803506:	83 c4 1c             	add    $0x1c,%esp
  803509:	5b                   	pop    %ebx
  80350a:	5e                   	pop    %esi
  80350b:	5f                   	pop    %edi
  80350c:	5d                   	pop    %ebp
  80350d:	c3                   	ret    
  80350e:	66 90                	xchg   %ax,%ax
  803510:	89 d8                	mov    %ebx,%eax
  803512:	f7 f7                	div    %edi
  803514:	31 ff                	xor    %edi,%edi
  803516:	89 fa                	mov    %edi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	bd 20 00 00 00       	mov    $0x20,%ebp
  803525:	89 eb                	mov    %ebp,%ebx
  803527:	29 fb                	sub    %edi,%ebx
  803529:	89 f9                	mov    %edi,%ecx
  80352b:	d3 e6                	shl    %cl,%esi
  80352d:	89 c5                	mov    %eax,%ebp
  80352f:	88 d9                	mov    %bl,%cl
  803531:	d3 ed                	shr    %cl,%ebp
  803533:	89 e9                	mov    %ebp,%ecx
  803535:	09 f1                	or     %esi,%ecx
  803537:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80353b:	89 f9                	mov    %edi,%ecx
  80353d:	d3 e0                	shl    %cl,%eax
  80353f:	89 c5                	mov    %eax,%ebp
  803541:	89 d6                	mov    %edx,%esi
  803543:	88 d9                	mov    %bl,%cl
  803545:	d3 ee                	shr    %cl,%esi
  803547:	89 f9                	mov    %edi,%ecx
  803549:	d3 e2                	shl    %cl,%edx
  80354b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80354f:	88 d9                	mov    %bl,%cl
  803551:	d3 e8                	shr    %cl,%eax
  803553:	09 c2                	or     %eax,%edx
  803555:	89 d0                	mov    %edx,%eax
  803557:	89 f2                	mov    %esi,%edx
  803559:	f7 74 24 0c          	divl   0xc(%esp)
  80355d:	89 d6                	mov    %edx,%esi
  80355f:	89 c3                	mov    %eax,%ebx
  803561:	f7 e5                	mul    %ebp
  803563:	39 d6                	cmp    %edx,%esi
  803565:	72 19                	jb     803580 <__udivdi3+0xfc>
  803567:	74 0b                	je     803574 <__udivdi3+0xf0>
  803569:	89 d8                	mov    %ebx,%eax
  80356b:	31 ff                	xor    %edi,%edi
  80356d:	e9 58 ff ff ff       	jmp    8034ca <__udivdi3+0x46>
  803572:	66 90                	xchg   %ax,%ax
  803574:	8b 54 24 08          	mov    0x8(%esp),%edx
  803578:	89 f9                	mov    %edi,%ecx
  80357a:	d3 e2                	shl    %cl,%edx
  80357c:	39 c2                	cmp    %eax,%edx
  80357e:	73 e9                	jae    803569 <__udivdi3+0xe5>
  803580:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803583:	31 ff                	xor    %edi,%edi
  803585:	e9 40 ff ff ff       	jmp    8034ca <__udivdi3+0x46>
  80358a:	66 90                	xchg   %ax,%ax
  80358c:	31 c0                	xor    %eax,%eax
  80358e:	e9 37 ff ff ff       	jmp    8034ca <__udivdi3+0x46>
  803593:	90                   	nop

00803594 <__umoddi3>:
  803594:	55                   	push   %ebp
  803595:	57                   	push   %edi
  803596:	56                   	push   %esi
  803597:	53                   	push   %ebx
  803598:	83 ec 1c             	sub    $0x1c,%esp
  80359b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80359f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035b3:	89 f3                	mov    %esi,%ebx
  8035b5:	89 fa                	mov    %edi,%edx
  8035b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035bb:	89 34 24             	mov    %esi,(%esp)
  8035be:	85 c0                	test   %eax,%eax
  8035c0:	75 1a                	jne    8035dc <__umoddi3+0x48>
  8035c2:	39 f7                	cmp    %esi,%edi
  8035c4:	0f 86 a2 00 00 00    	jbe    80366c <__umoddi3+0xd8>
  8035ca:	89 c8                	mov    %ecx,%eax
  8035cc:	89 f2                	mov    %esi,%edx
  8035ce:	f7 f7                	div    %edi
  8035d0:	89 d0                	mov    %edx,%eax
  8035d2:	31 d2                	xor    %edx,%edx
  8035d4:	83 c4 1c             	add    $0x1c,%esp
  8035d7:	5b                   	pop    %ebx
  8035d8:	5e                   	pop    %esi
  8035d9:	5f                   	pop    %edi
  8035da:	5d                   	pop    %ebp
  8035db:	c3                   	ret    
  8035dc:	39 f0                	cmp    %esi,%eax
  8035de:	0f 87 ac 00 00 00    	ja     803690 <__umoddi3+0xfc>
  8035e4:	0f bd e8             	bsr    %eax,%ebp
  8035e7:	83 f5 1f             	xor    $0x1f,%ebp
  8035ea:	0f 84 ac 00 00 00    	je     80369c <__umoddi3+0x108>
  8035f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8035f5:	29 ef                	sub    %ebp,%edi
  8035f7:	89 fe                	mov    %edi,%esi
  8035f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035fd:	89 e9                	mov    %ebp,%ecx
  8035ff:	d3 e0                	shl    %cl,%eax
  803601:	89 d7                	mov    %edx,%edi
  803603:	89 f1                	mov    %esi,%ecx
  803605:	d3 ef                	shr    %cl,%edi
  803607:	09 c7                	or     %eax,%edi
  803609:	89 e9                	mov    %ebp,%ecx
  80360b:	d3 e2                	shl    %cl,%edx
  80360d:	89 14 24             	mov    %edx,(%esp)
  803610:	89 d8                	mov    %ebx,%eax
  803612:	d3 e0                	shl    %cl,%eax
  803614:	89 c2                	mov    %eax,%edx
  803616:	8b 44 24 08          	mov    0x8(%esp),%eax
  80361a:	d3 e0                	shl    %cl,%eax
  80361c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803620:	8b 44 24 08          	mov    0x8(%esp),%eax
  803624:	89 f1                	mov    %esi,%ecx
  803626:	d3 e8                	shr    %cl,%eax
  803628:	09 d0                	or     %edx,%eax
  80362a:	d3 eb                	shr    %cl,%ebx
  80362c:	89 da                	mov    %ebx,%edx
  80362e:	f7 f7                	div    %edi
  803630:	89 d3                	mov    %edx,%ebx
  803632:	f7 24 24             	mull   (%esp)
  803635:	89 c6                	mov    %eax,%esi
  803637:	89 d1                	mov    %edx,%ecx
  803639:	39 d3                	cmp    %edx,%ebx
  80363b:	0f 82 87 00 00 00    	jb     8036c8 <__umoddi3+0x134>
  803641:	0f 84 91 00 00 00    	je     8036d8 <__umoddi3+0x144>
  803647:	8b 54 24 04          	mov    0x4(%esp),%edx
  80364b:	29 f2                	sub    %esi,%edx
  80364d:	19 cb                	sbb    %ecx,%ebx
  80364f:	89 d8                	mov    %ebx,%eax
  803651:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803655:	d3 e0                	shl    %cl,%eax
  803657:	89 e9                	mov    %ebp,%ecx
  803659:	d3 ea                	shr    %cl,%edx
  80365b:	09 d0                	or     %edx,%eax
  80365d:	89 e9                	mov    %ebp,%ecx
  80365f:	d3 eb                	shr    %cl,%ebx
  803661:	89 da                	mov    %ebx,%edx
  803663:	83 c4 1c             	add    $0x1c,%esp
  803666:	5b                   	pop    %ebx
  803667:	5e                   	pop    %esi
  803668:	5f                   	pop    %edi
  803669:	5d                   	pop    %ebp
  80366a:	c3                   	ret    
  80366b:	90                   	nop
  80366c:	89 fd                	mov    %edi,%ebp
  80366e:	85 ff                	test   %edi,%edi
  803670:	75 0b                	jne    80367d <__umoddi3+0xe9>
  803672:	b8 01 00 00 00       	mov    $0x1,%eax
  803677:	31 d2                	xor    %edx,%edx
  803679:	f7 f7                	div    %edi
  80367b:	89 c5                	mov    %eax,%ebp
  80367d:	89 f0                	mov    %esi,%eax
  80367f:	31 d2                	xor    %edx,%edx
  803681:	f7 f5                	div    %ebp
  803683:	89 c8                	mov    %ecx,%eax
  803685:	f7 f5                	div    %ebp
  803687:	89 d0                	mov    %edx,%eax
  803689:	e9 44 ff ff ff       	jmp    8035d2 <__umoddi3+0x3e>
  80368e:	66 90                	xchg   %ax,%ax
  803690:	89 c8                	mov    %ecx,%eax
  803692:	89 f2                	mov    %esi,%edx
  803694:	83 c4 1c             	add    $0x1c,%esp
  803697:	5b                   	pop    %ebx
  803698:	5e                   	pop    %esi
  803699:	5f                   	pop    %edi
  80369a:	5d                   	pop    %ebp
  80369b:	c3                   	ret    
  80369c:	3b 04 24             	cmp    (%esp),%eax
  80369f:	72 06                	jb     8036a7 <__umoddi3+0x113>
  8036a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036a5:	77 0f                	ja     8036b6 <__umoddi3+0x122>
  8036a7:	89 f2                	mov    %esi,%edx
  8036a9:	29 f9                	sub    %edi,%ecx
  8036ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036af:	89 14 24             	mov    %edx,(%esp)
  8036b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036ba:	8b 14 24             	mov    (%esp),%edx
  8036bd:	83 c4 1c             	add    $0x1c,%esp
  8036c0:	5b                   	pop    %ebx
  8036c1:	5e                   	pop    %esi
  8036c2:	5f                   	pop    %edi
  8036c3:	5d                   	pop    %ebp
  8036c4:	c3                   	ret    
  8036c5:	8d 76 00             	lea    0x0(%esi),%esi
  8036c8:	2b 04 24             	sub    (%esp),%eax
  8036cb:	19 fa                	sbb    %edi,%edx
  8036cd:	89 d1                	mov    %edx,%ecx
  8036cf:	89 c6                	mov    %eax,%esi
  8036d1:	e9 71 ff ff ff       	jmp    803647 <__umoddi3+0xb3>
  8036d6:	66 90                	xchg   %ax,%ax
  8036d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036dc:	72 ea                	jb     8036c8 <__umoddi3+0x134>
  8036de:	89 d9                	mov    %ebx,%ecx
  8036e0:	e9 62 ff ff ff       	jmp    803647 <__umoddi3+0xb3>
