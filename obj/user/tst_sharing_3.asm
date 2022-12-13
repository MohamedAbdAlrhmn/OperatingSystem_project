
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
  80008c:	68 20 37 80 00       	push   $0x803720
  800091:	6a 12                	push   $0x12
  800093:	68 3c 37 80 00       	push   $0x80373c
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
  8000ad:	68 54 37 80 00       	push   $0x803754
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 88 37 80 00       	push   $0x803788
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 e4 37 80 00       	push   $0x8037e4
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 18 38 80 00       	push   $0x803818
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 60 38 80 00       	push   $0x803860
  8000f9:	e8 82 15 00 00       	call   801680 <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 dc 17 00 00       	call   8018e5 <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 60 38 80 00       	push   $0x803860
  80011b:	e8 60 15 00 00       	call   801680 <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 64 38 80 00       	push   $0x803864
  800134:	6a 24                	push   $0x24
  800136:	68 3c 37 80 00       	push   $0x80373c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 a0 17 00 00       	call   8018e5 <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 b8 38 80 00       	push   $0x8038b8
  800156:	6a 25                	push   $0x25
  800158:	68 3c 37 80 00       	push   $0x80373c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 14 39 80 00       	push   $0x803914
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 6e 17 00 00       	call   8018e5 <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 6c 39 80 00       	push   $0x80396c
  80018e:	e8 ed 14 00 00       	call   801680 <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 70 39 80 00       	push   $0x803970
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 3c 37 80 00       	push   $0x80373c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 2d 17 00 00       	call   8018e5 <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 e4 39 80 00       	push   $0x8039e4
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 3c 37 80 00       	push   $0x80373c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 58 3a 80 00       	push   $0x803a58
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 54 19 00 00       	call   801b3e <sys_getMaxShares>
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
  800227:	68 cc 3a 80 00       	push   $0x803acc
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 3c 37 80 00       	push   $0x80373c
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
  80024f:	68 fc 3a 80 00       	push   $0x803afc
  800254:	e8 27 14 00 00       	call   801680 <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 da 18 00 00       	call   801b3e <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 08 3b 80 00       	push   $0x803b08
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 3c 37 80 00       	push   $0x80373c
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
  80029c:	68 84 3b 80 00       	push   $0x803b84
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 3c 37 80 00       	push   $0x80373c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 10 3c 80 00       	push   $0x803c10
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
  8002c6:	e8 fa 18 00 00       	call   801bc5 <sys_getenvindex>
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
  800331:	e8 9c 16 00 00       	call   8019d2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 88 3c 80 00       	push   $0x803c88
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
  800361:	68 b0 3c 80 00       	push   $0x803cb0
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
  800392:	68 d8 3c 80 00       	push   $0x803cd8
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 30 3d 80 00       	push   $0x803d30
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 88 3c 80 00       	push   $0x803c88
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 1c 16 00 00       	call   8019ec <sys_enable_interrupt>

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
  8003e3:	e8 a9 17 00 00       	call   801b91 <sys_destroy_env>
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
  8003f4:	e8 fe 17 00 00       	call   801bf7 <sys_exit_env>
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
  80041d:	68 44 3d 80 00       	push   $0x803d44
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 49 3d 80 00       	push   $0x803d49
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
  80045a:	68 65 3d 80 00       	push   $0x803d65
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
  800486:	68 68 3d 80 00       	push   $0x803d68
  80048b:	6a 26                	push   $0x26
  80048d:	68 b4 3d 80 00       	push   $0x803db4
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
  800558:	68 c0 3d 80 00       	push   $0x803dc0
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 b4 3d 80 00       	push   $0x803db4
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
  8005c8:	68 14 3e 80 00       	push   $0x803e14
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 b4 3d 80 00       	push   $0x803db4
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
  800622:	e8 fd 11 00 00       	call   801824 <sys_cputs>
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
  800699:	e8 86 11 00 00       	call   801824 <sys_cputs>
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
  8006e3:	e8 ea 12 00 00       	call   8019d2 <sys_disable_interrupt>
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
  800703:	e8 e4 12 00 00       	call   8019ec <sys_enable_interrupt>
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
  80074d:	e8 56 2d 00 00       	call   8034a8 <__udivdi3>
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
  80079d:	e8 16 2e 00 00       	call   8035b8 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 74 40 80 00       	add    $0x804074,%eax
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
  8008f8:	8b 04 85 98 40 80 00 	mov    0x804098(,%eax,4),%eax
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
  8009d9:	8b 34 9d e0 3e 80 00 	mov    0x803ee0(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 85 40 80 00       	push   $0x804085
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
  8009fe:	68 8e 40 80 00       	push   $0x80408e
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
  800a2b:	be 91 40 80 00       	mov    $0x804091,%esi
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
  801451:	68 f0 41 80 00       	push   $0x8041f0
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
  801521:	e8 42 04 00 00       	call   801968 <sys_allocate_chunk>
  801526:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801529:	a1 20 51 80 00       	mov    0x805120,%eax
  80152e:	83 ec 0c             	sub    $0xc,%esp
  801531:	50                   	push   %eax
  801532:	e8 b7 0a 00 00       	call   801fee <initialize_MemBlocksList>
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
  80155f:	68 15 42 80 00       	push   $0x804215
  801564:	6a 33                	push   $0x33
  801566:	68 33 42 80 00       	push   $0x804233
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
  8015de:	68 40 42 80 00       	push   $0x804240
  8015e3:	6a 34                	push   $0x34
  8015e5:	68 33 42 80 00       	push   $0x804233
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
  801653:	68 64 42 80 00       	push   $0x804264
  801658:	6a 46                	push   $0x46
  80165a:	68 33 42 80 00       	push   $0x804233
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
  80166f:	68 8c 42 80 00       	push   $0x80428c
  801674:	6a 61                	push   $0x61
  801676:	68 33 42 80 00       	push   $0x804233
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
  801695:	75 0a                	jne    8016a1 <smalloc+0x21>
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
  80169c:	e9 9e 00 00 00       	jmp    80173f <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016a1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ae:	01 d0                	add    %edx,%eax
  8016b0:	48                   	dec    %eax
  8016b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bc:	f7 75 f0             	divl   -0x10(%ebp)
  8016bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c2:	29 d0                	sub    %edx,%eax
  8016c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016c7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ce:	e8 63 06 00 00       	call   801d36 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	74 11                	je     8016e8 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016d7:	83 ec 0c             	sub    $0xc,%esp
  8016da:	ff 75 e8             	pushl  -0x18(%ebp)
  8016dd:	e8 ce 0c 00 00       	call   8023b0 <alloc_block_FF>
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016ec:	74 4c                	je     80173a <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f1:	8b 40 08             	mov    0x8(%eax),%eax
  8016f4:	89 c2                	mov    %eax,%edx
  8016f6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016fa:	52                   	push   %edx
  8016fb:	50                   	push   %eax
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	ff 75 08             	pushl  0x8(%ebp)
  801702:	e8 b4 03 00 00       	call   801abb <sys_createSharedObject>
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  80170d:	83 ec 08             	sub    $0x8,%esp
  801710:	ff 75 e0             	pushl  -0x20(%ebp)
  801713:	68 af 42 80 00       	push   $0x8042af
  801718:	e8 93 ef ff ff       	call   8006b0 <cprintf>
  80171d:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801720:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801724:	74 14                	je     80173a <smalloc+0xba>
  801726:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80172a:	74 0e                	je     80173a <smalloc+0xba>
  80172c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801730:	74 08                	je     80173a <smalloc+0xba>
			return (void*) mem_block->sva;
  801732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801735:	8b 40 08             	mov    0x8(%eax),%eax
  801738:	eb 05                	jmp    80173f <smalloc+0xbf>
	}
	return NULL;
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801747:	e8 ee fc ff ff       	call   80143a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80174c:	83 ec 04             	sub    $0x4,%esp
  80174f:	68 c4 42 80 00       	push   $0x8042c4
  801754:	68 ab 00 00 00       	push   $0xab
  801759:	68 33 42 80 00       	push   $0x804233
  80175e:	e8 99 ec ff ff       	call   8003fc <_panic>

00801763 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801769:	e8 cc fc ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	68 e8 42 80 00       	push   $0x8042e8
  801776:	68 ef 00 00 00       	push   $0xef
  80177b:	68 33 42 80 00       	push   $0x804233
  801780:	e8 77 ec ff ff       	call   8003fc <_panic>

00801785 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	68 10 43 80 00       	push   $0x804310
  801793:	68 03 01 00 00       	push   $0x103
  801798:	68 33 42 80 00       	push   $0x804233
  80179d:	e8 5a ec ff ff       	call   8003fc <_panic>

008017a2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a8:	83 ec 04             	sub    $0x4,%esp
  8017ab:	68 34 43 80 00       	push   $0x804334
  8017b0:	68 0e 01 00 00       	push   $0x10e
  8017b5:	68 33 42 80 00       	push   $0x804233
  8017ba:	e8 3d ec ff ff       	call   8003fc <_panic>

008017bf <shrink>:

}
void shrink(uint32 newSize)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c5:	83 ec 04             	sub    $0x4,%esp
  8017c8:	68 34 43 80 00       	push   $0x804334
  8017cd:	68 13 01 00 00       	push   $0x113
  8017d2:	68 33 42 80 00       	push   $0x804233
  8017d7:	e8 20 ec ff ff       	call   8003fc <_panic>

008017dc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	68 34 43 80 00       	push   $0x804334
  8017ea:	68 18 01 00 00       	push   $0x118
  8017ef:	68 33 42 80 00       	push   $0x804233
  8017f4:	e8 03 ec ff ff       	call   8003fc <_panic>

008017f9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	57                   	push   %edi
  8017fd:	56                   	push   %esi
  8017fe:	53                   	push   %ebx
  8017ff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	8b 55 0c             	mov    0xc(%ebp),%edx
  801808:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80180e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801811:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801814:	cd 30                	int    $0x30
  801816:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801819:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	5b                   	pop    %ebx
  801820:	5e                   	pop    %esi
  801821:	5f                   	pop    %edi
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    

00801824 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 04             	sub    $0x4,%esp
  80182a:	8b 45 10             	mov    0x10(%ebp),%eax
  80182d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801830:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	52                   	push   %edx
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	50                   	push   %eax
  801840:	6a 00                	push   $0x0
  801842:	e8 b2 ff ff ff       	call   8017f9 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	90                   	nop
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_cgetc>:

int
sys_cgetc(void)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 01                	push   $0x1
  80185c:	e8 98 ff ff ff       	call   8017f9 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	52                   	push   %edx
  801876:	50                   	push   %eax
  801877:	6a 05                	push   $0x5
  801879:	e8 7b ff ff ff       	call   8017f9 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801888:	8b 75 18             	mov    0x18(%ebp),%esi
  80188b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	56                   	push   %esi
  801898:	53                   	push   %ebx
  801899:	51                   	push   %ecx
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	6a 06                	push   $0x6
  80189e:	e8 56 ff ff ff       	call   8017f9 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5e                   	pop    %esi
  8018ab:	5d                   	pop    %ebp
  8018ac:	c3                   	ret    

008018ad <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	52                   	push   %edx
  8018bd:	50                   	push   %eax
  8018be:	6a 07                	push   $0x7
  8018c0:	e8 34 ff ff ff       	call   8017f9 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 08                	push   $0x8
  8018db:	e8 19 ff ff ff       	call   8017f9 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 09                	push   $0x9
  8018f4:	e8 00 ff ff ff       	call   8017f9 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 0a                	push   $0xa
  80190d:	e8 e7 fe ff ff       	call   8017f9 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 0b                	push   $0xb
  801926:	e8 ce fe ff ff       	call   8017f9 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	6a 0f                	push   $0xf
  801941:	e8 b3 fe ff ff       	call   8017f9 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
	return;
  801949:	90                   	nop
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	ff 75 0c             	pushl  0xc(%ebp)
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	6a 10                	push   $0x10
  80195d:	e8 97 fe ff ff       	call   8017f9 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
	return ;
  801965:	90                   	nop
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	ff 75 10             	pushl  0x10(%ebp)
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 11                	push   $0x11
  80197a:	e8 7a fe ff ff       	call   8017f9 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return ;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 0c                	push   $0xc
  801994:	e8 60 fe ff ff       	call   8017f9 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	6a 0d                	push   $0xd
  8019ae:	e8 46 fe ff ff       	call   8017f9 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 0e                	push   $0xe
  8019c7:	e8 2d fe ff ff       	call   8017f9 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 13                	push   $0x13
  8019e1:	e8 13 fe ff ff       	call   8017f9 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	90                   	nop
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 14                	push   $0x14
  8019fb:	e8 f9 fd ff ff       	call   8017f9 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a12:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	50                   	push   %eax
  801a1f:	6a 15                	push   $0x15
  801a21:	e8 d3 fd ff ff       	call   8017f9 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 16                	push   $0x16
  801a3b:	e8 b9 fd ff ff       	call   8017f9 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	90                   	nop
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	50                   	push   %eax
  801a56:	6a 17                	push   $0x17
  801a58:	e8 9c fd ff ff       	call   8017f9 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	52                   	push   %edx
  801a72:	50                   	push   %eax
  801a73:	6a 1a                	push   $0x1a
  801a75:	e8 7f fd ff ff       	call   8017f9 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 18                	push   $0x18
  801a92:	e8 62 fd ff ff       	call   8017f9 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 19                	push   $0x19
  801ab0:	e8 44 fd ff ff       	call   8017f9 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	6a 00                	push   $0x0
  801ad3:	51                   	push   %ecx
  801ad4:	52                   	push   %edx
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	6a 1b                	push   $0x1b
  801adb:	e8 19 fd ff ff       	call   8017f9 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	52                   	push   %edx
  801af5:	50                   	push   %eax
  801af6:	6a 1c                	push   $0x1c
  801af8:	e8 fc fc ff ff       	call   8017f9 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	51                   	push   %ecx
  801b13:	52                   	push   %edx
  801b14:	50                   	push   %eax
  801b15:	6a 1d                	push   $0x1d
  801b17:	e8 dd fc ff ff       	call   8017f9 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	6a 1e                	push   $0x1e
  801b34:	e8 c0 fc ff ff       	call   8017f9 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 1f                	push   $0x1f
  801b4d:	e8 a7 fc ff ff       	call   8017f9 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	ff 75 14             	pushl  0x14(%ebp)
  801b62:	ff 75 10             	pushl  0x10(%ebp)
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	50                   	push   %eax
  801b69:	6a 20                	push   $0x20
  801b6b:	e8 89 fc ff ff       	call   8017f9 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	50                   	push   %eax
  801b84:	6a 21                	push   $0x21
  801b86:	e8 6e fc ff ff       	call   8017f9 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	90                   	nop
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	50                   	push   %eax
  801ba0:	6a 22                	push   $0x22
  801ba2:	e8 52 fc ff ff       	call   8017f9 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 02                	push   $0x2
  801bbb:	e8 39 fc ff ff       	call   8017f9 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 03                	push   $0x3
  801bd4:	e8 20 fc ff ff       	call   8017f9 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 04                	push   $0x4
  801bed:	e8 07 fc ff ff       	call   8017f9 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 23                	push   $0x23
  801c06:	e8 ee fb ff ff       	call   8017f9 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	90                   	nop
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c17:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1a:	8d 50 04             	lea    0x4(%eax),%edx
  801c1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	6a 24                	push   $0x24
  801c2a:	e8 ca fb ff ff       	call   8017f9 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
	return result;
  801c32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c3b:	89 01                	mov    %eax,(%ecx)
  801c3d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	c9                   	leave  
  801c44:	c2 04 00             	ret    $0x4

00801c47 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	ff 75 10             	pushl  0x10(%ebp)
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	ff 75 08             	pushl  0x8(%ebp)
  801c57:	6a 12                	push   $0x12
  801c59:	e8 9b fb ff ff       	call   8017f9 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c61:	90                   	nop
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 25                	push   $0x25
  801c73:	e8 81 fb ff ff       	call   8017f9 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c89:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	50                   	push   %eax
  801c96:	6a 26                	push   $0x26
  801c98:	e8 5c fb ff ff       	call   8017f9 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca0:	90                   	nop
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <rsttst>:
void rsttst()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 28                	push   $0x28
  801cb2:	e8 42 fb ff ff       	call   8017f9 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cba:	90                   	nop
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc9:	8b 55 18             	mov    0x18(%ebp),%edx
  801ccc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	ff 75 10             	pushl  0x10(%ebp)
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	6a 27                	push   $0x27
  801cdd:	e8 17 fb ff ff       	call   8017f9 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce5:	90                   	nop
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <chktst>:
void chktst(uint32 n)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	ff 75 08             	pushl  0x8(%ebp)
  801cf6:	6a 29                	push   $0x29
  801cf8:	e8 fc fa ff ff       	call   8017f9 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801d00:	90                   	nop
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <inctst>:

void inctst()
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 2a                	push   $0x2a
  801d12:	e8 e2 fa ff ff       	call   8017f9 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1a:	90                   	nop
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <gettst>:
uint32 gettst()
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 2b                	push   $0x2b
  801d2c:	e8 c8 fa ff ff       	call   8017f9 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 2c                	push   $0x2c
  801d48:	e8 ac fa ff ff       	call   8017f9 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
  801d50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d53:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d57:	75 07                	jne    801d60 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d59:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5e:	eb 05                	jmp    801d65 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 2c                	push   $0x2c
  801d79:	e8 7b fa ff ff       	call   8017f9 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
  801d81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d84:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d88:	75 07                	jne    801d91 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8f:	eb 05                	jmp    801d96 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 2c                	push   $0x2c
  801daa:	e8 4a fa ff ff       	call   8017f9 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
  801db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801db5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db9:	75 07                	jne    801dc2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc0:	eb 05                	jmp    801dc7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 2c                	push   $0x2c
  801ddb:	e8 19 fa ff ff       	call   8017f9 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
  801de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dea:	75 07                	jne    801df3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dec:	b8 01 00 00 00       	mov    $0x1,%eax
  801df1:	eb 05                	jmp    801df8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	ff 75 08             	pushl  0x8(%ebp)
  801e08:	6a 2d                	push   $0x2d
  801e0a:	e8 ea f9 ff ff       	call   8017f9 <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e12:	90                   	nop
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e19:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	6a 00                	push   $0x0
  801e27:	53                   	push   %ebx
  801e28:	51                   	push   %ecx
  801e29:	52                   	push   %edx
  801e2a:	50                   	push   %eax
  801e2b:	6a 2e                	push   $0x2e
  801e2d:	e8 c7 f9 ff ff       	call   8017f9 <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
}
  801e35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	52                   	push   %edx
  801e4a:	50                   	push   %eax
  801e4b:	6a 2f                	push   $0x2f
  801e4d:	e8 a7 f9 ff ff       	call   8017f9 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	68 44 43 80 00       	push   $0x804344
  801e65:	e8 46 e8 ff ff       	call   8006b0 <cprintf>
  801e6a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e6d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e74:	83 ec 0c             	sub    $0xc,%esp
  801e77:	68 70 43 80 00       	push   $0x804370
  801e7c:	e8 2f e8 ff ff       	call   8006b0 <cprintf>
  801e81:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e84:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e88:	a1 38 51 80 00       	mov    0x805138,%eax
  801e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e90:	eb 56                	jmp    801ee8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e96:	74 1c                	je     801eb4 <print_mem_block_lists+0x5d>
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 50 08             	mov    0x8(%eax),%edx
  801e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea1:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaa:	01 c8                	add    %ecx,%eax
  801eac:	39 c2                	cmp    %eax,%edx
  801eae:	73 04                	jae    801eb4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eb0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	8b 50 08             	mov    0x8(%eax),%edx
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec0:	01 c2                	add    %eax,%edx
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	8b 40 08             	mov    0x8(%eax),%eax
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	52                   	push   %edx
  801ecc:	50                   	push   %eax
  801ecd:	68 85 43 80 00       	push   $0x804385
  801ed2:	e8 d9 e7 ff ff       	call   8006b0 <cprintf>
  801ed7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee0:	a1 40 51 80 00       	mov    0x805140,%eax
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eec:	74 07                	je     801ef5 <print_mem_block_lists+0x9e>
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	8b 00                	mov    (%eax),%eax
  801ef3:	eb 05                	jmp    801efa <print_mem_block_lists+0xa3>
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	a3 40 51 80 00       	mov    %eax,0x805140
  801eff:	a1 40 51 80 00       	mov    0x805140,%eax
  801f04:	85 c0                	test   %eax,%eax
  801f06:	75 8a                	jne    801e92 <print_mem_block_lists+0x3b>
  801f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0c:	75 84                	jne    801e92 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f0e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f12:	75 10                	jne    801f24 <print_mem_block_lists+0xcd>
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 94 43 80 00       	push   $0x804394
  801f1c:	e8 8f e7 ff ff       	call   8006b0 <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	68 b8 43 80 00       	push   $0x8043b8
  801f33:	e8 78 e7 ff ff       	call   8006b0 <cprintf>
  801f38:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f3b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f3f:	a1 40 50 80 00       	mov    0x805040,%eax
  801f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f47:	eb 56                	jmp    801f9f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4d:	74 1c                	je     801f6b <print_mem_block_lists+0x114>
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 50 08             	mov    0x8(%eax),%edx
  801f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f58:	8b 48 08             	mov    0x8(%eax),%ecx
  801f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f61:	01 c8                	add    %ecx,%eax
  801f63:	39 c2                	cmp    %eax,%edx
  801f65:	73 04                	jae    801f6b <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f67:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 50 08             	mov    0x8(%eax),%edx
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	8b 40 0c             	mov    0xc(%eax),%eax
  801f77:	01 c2                	add    %eax,%edx
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 40 08             	mov    0x8(%eax),%eax
  801f7f:	83 ec 04             	sub    $0x4,%esp
  801f82:	52                   	push   %edx
  801f83:	50                   	push   %eax
  801f84:	68 85 43 80 00       	push   $0x804385
  801f89:	e8 22 e7 ff ff       	call   8006b0 <cprintf>
  801f8e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f97:	a1 48 50 80 00       	mov    0x805048,%eax
  801f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa3:	74 07                	je     801fac <print_mem_block_lists+0x155>
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	8b 00                	mov    (%eax),%eax
  801faa:	eb 05                	jmp    801fb1 <print_mem_block_lists+0x15a>
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	a3 48 50 80 00       	mov    %eax,0x805048
  801fb6:	a1 48 50 80 00       	mov    0x805048,%eax
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	75 8a                	jne    801f49 <print_mem_block_lists+0xf2>
  801fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc3:	75 84                	jne    801f49 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fc5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc9:	75 10                	jne    801fdb <print_mem_block_lists+0x184>
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	68 d0 43 80 00       	push   $0x8043d0
  801fd3:	e8 d8 e6 ff ff       	call   8006b0 <cprintf>
  801fd8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	68 44 43 80 00       	push   $0x804344
  801fe3:	e8 c8 e6 ff ff       	call   8006b0 <cprintf>
  801fe8:	83 c4 10             	add    $0x10,%esp

}
  801feb:	90                   	nop
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ff4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ffb:	00 00 00 
  801ffe:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802005:	00 00 00 
  802008:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80200f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802012:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802019:	e9 9e 00 00 00       	jmp    8020bc <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80201e:	a1 50 50 80 00       	mov    0x805050,%eax
  802023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802026:	c1 e2 04             	shl    $0x4,%edx
  802029:	01 d0                	add    %edx,%eax
  80202b:	85 c0                	test   %eax,%eax
  80202d:	75 14                	jne    802043 <initialize_MemBlocksList+0x55>
  80202f:	83 ec 04             	sub    $0x4,%esp
  802032:	68 f8 43 80 00       	push   $0x8043f8
  802037:	6a 46                	push   $0x46
  802039:	68 1b 44 80 00       	push   $0x80441b
  80203e:	e8 b9 e3 ff ff       	call   8003fc <_panic>
  802043:	a1 50 50 80 00       	mov    0x805050,%eax
  802048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204b:	c1 e2 04             	shl    $0x4,%edx
  80204e:	01 d0                	add    %edx,%eax
  802050:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802056:	89 10                	mov    %edx,(%eax)
  802058:	8b 00                	mov    (%eax),%eax
  80205a:	85 c0                	test   %eax,%eax
  80205c:	74 18                	je     802076 <initialize_MemBlocksList+0x88>
  80205e:	a1 48 51 80 00       	mov    0x805148,%eax
  802063:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802069:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80206c:	c1 e1 04             	shl    $0x4,%ecx
  80206f:	01 ca                	add    %ecx,%edx
  802071:	89 50 04             	mov    %edx,0x4(%eax)
  802074:	eb 12                	jmp    802088 <initialize_MemBlocksList+0x9a>
  802076:	a1 50 50 80 00       	mov    0x805050,%eax
  80207b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207e:	c1 e2 04             	shl    $0x4,%edx
  802081:	01 d0                	add    %edx,%eax
  802083:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802088:	a1 50 50 80 00       	mov    0x805050,%eax
  80208d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802090:	c1 e2 04             	shl    $0x4,%edx
  802093:	01 d0                	add    %edx,%eax
  802095:	a3 48 51 80 00       	mov    %eax,0x805148
  80209a:	a1 50 50 80 00       	mov    0x805050,%eax
  80209f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a2:	c1 e2 04             	shl    $0x4,%edx
  8020a5:	01 d0                	add    %edx,%eax
  8020a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8020b3:	40                   	inc    %eax
  8020b4:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020b9:	ff 45 f4             	incl   -0xc(%ebp)
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c2:	0f 82 56 ff ff ff    	jb     80201e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020c8:	90                   	nop
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	8b 00                	mov    (%eax),%eax
  8020d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d9:	eb 19                	jmp    8020f4 <find_block+0x29>
	{
		if(va==point->sva)
  8020db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020de:	8b 40 08             	mov    0x8(%eax),%eax
  8020e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020e4:	75 05                	jne    8020eb <find_block+0x20>
		   return point;
  8020e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e9:	eb 36                	jmp    802121 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8b 40 08             	mov    0x8(%eax),%eax
  8020f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f8:	74 07                	je     802101 <find_block+0x36>
  8020fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fd:	8b 00                	mov    (%eax),%eax
  8020ff:	eb 05                	jmp    802106 <find_block+0x3b>
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
  802106:	8b 55 08             	mov    0x8(%ebp),%edx
  802109:	89 42 08             	mov    %eax,0x8(%edx)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	8b 40 08             	mov    0x8(%eax),%eax
  802112:	85 c0                	test   %eax,%eax
  802114:	75 c5                	jne    8020db <find_block+0x10>
  802116:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80211a:	75 bf                	jne    8020db <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80211c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802129:	a1 40 50 80 00       	mov    0x805040,%eax
  80212e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802131:	a1 44 50 80 00       	mov    0x805044,%eax
  802136:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80213f:	74 24                	je     802165 <insert_sorted_allocList+0x42>
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8b 50 08             	mov    0x8(%eax),%edx
  802147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214a:	8b 40 08             	mov    0x8(%eax),%eax
  80214d:	39 c2                	cmp    %eax,%edx
  80214f:	76 14                	jbe    802165 <insert_sorted_allocList+0x42>
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8b 50 08             	mov    0x8(%eax),%edx
  802157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215a:	8b 40 08             	mov    0x8(%eax),%eax
  80215d:	39 c2                	cmp    %eax,%edx
  80215f:	0f 82 60 01 00 00    	jb     8022c5 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802165:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802169:	75 65                	jne    8021d0 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80216b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80216f:	75 14                	jne    802185 <insert_sorted_allocList+0x62>
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	68 f8 43 80 00       	push   $0x8043f8
  802179:	6a 6b                	push   $0x6b
  80217b:	68 1b 44 80 00       	push   $0x80441b
  802180:	e8 77 e2 ff ff       	call   8003fc <_panic>
  802185:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	89 10                	mov    %edx,(%eax)
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	8b 00                	mov    (%eax),%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	74 0d                	je     8021a6 <insert_sorted_allocList+0x83>
  802199:	a1 40 50 80 00       	mov    0x805040,%eax
  80219e:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a1:	89 50 04             	mov    %edx,0x4(%eax)
  8021a4:	eb 08                	jmp    8021ae <insert_sorted_allocList+0x8b>
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	a3 44 50 80 00       	mov    %eax,0x805044
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	a3 40 50 80 00       	mov    %eax,0x805040
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021c5:	40                   	inc    %eax
  8021c6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021cb:	e9 dc 01 00 00       	jmp    8023ac <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	8b 50 08             	mov    0x8(%eax),%edx
  8021d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d9:	8b 40 08             	mov    0x8(%eax),%eax
  8021dc:	39 c2                	cmp    %eax,%edx
  8021de:	77 6c                	ja     80224c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e4:	74 06                	je     8021ec <insert_sorted_allocList+0xc9>
  8021e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ea:	75 14                	jne    802200 <insert_sorted_allocList+0xdd>
  8021ec:	83 ec 04             	sub    $0x4,%esp
  8021ef:	68 34 44 80 00       	push   $0x804434
  8021f4:	6a 6f                	push   $0x6f
  8021f6:	68 1b 44 80 00       	push   $0x80441b
  8021fb:	e8 fc e1 ff ff       	call   8003fc <_panic>
  802200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802203:	8b 50 04             	mov    0x4(%eax),%edx
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	89 50 04             	mov    %edx,0x4(%eax)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802212:	89 10                	mov    %edx,(%eax)
  802214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802217:	8b 40 04             	mov    0x4(%eax),%eax
  80221a:	85 c0                	test   %eax,%eax
  80221c:	74 0d                	je     80222b <insert_sorted_allocList+0x108>
  80221e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802221:	8b 40 04             	mov    0x4(%eax),%eax
  802224:	8b 55 08             	mov    0x8(%ebp),%edx
  802227:	89 10                	mov    %edx,(%eax)
  802229:	eb 08                	jmp    802233 <insert_sorted_allocList+0x110>
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	a3 40 50 80 00       	mov    %eax,0x805040
  802233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802236:	8b 55 08             	mov    0x8(%ebp),%edx
  802239:	89 50 04             	mov    %edx,0x4(%eax)
  80223c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802241:	40                   	inc    %eax
  802242:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802247:	e9 60 01 00 00       	jmp    8023ac <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	8b 50 08             	mov    0x8(%eax),%edx
  802252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802255:	8b 40 08             	mov    0x8(%eax),%eax
  802258:	39 c2                	cmp    %eax,%edx
  80225a:	0f 82 4c 01 00 00    	jb     8023ac <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802264:	75 14                	jne    80227a <insert_sorted_allocList+0x157>
  802266:	83 ec 04             	sub    $0x4,%esp
  802269:	68 6c 44 80 00       	push   $0x80446c
  80226e:	6a 73                	push   $0x73
  802270:	68 1b 44 80 00       	push   $0x80441b
  802275:	e8 82 e1 ff ff       	call   8003fc <_panic>
  80227a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	89 50 04             	mov    %edx,0x4(%eax)
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	8b 40 04             	mov    0x4(%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 0c                	je     80229c <insert_sorted_allocList+0x179>
  802290:	a1 44 50 80 00       	mov    0x805044,%eax
  802295:	8b 55 08             	mov    0x8(%ebp),%edx
  802298:	89 10                	mov    %edx,(%eax)
  80229a:	eb 08                	jmp    8022a4 <insert_sorted_allocList+0x181>
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	a3 40 50 80 00       	mov    %eax,0x805040
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ba:	40                   	inc    %eax
  8022bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022c0:	e9 e7 00 00 00       	jmp    8023ac <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022d2:	a1 40 50 80 00       	mov    0x805040,%eax
  8022d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022da:	e9 9d 00 00 00       	jmp    80237c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8b 50 08             	mov    0x8(%eax),%edx
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 40 08             	mov    0x8(%eax),%eax
  8022f3:	39 c2                	cmp    %eax,%edx
  8022f5:	76 7d                	jbe    802374 <insert_sorted_allocList+0x251>
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8b 50 08             	mov    0x8(%eax),%edx
  8022fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802300:	8b 40 08             	mov    0x8(%eax),%eax
  802303:	39 c2                	cmp    %eax,%edx
  802305:	73 6d                	jae    802374 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230b:	74 06                	je     802313 <insert_sorted_allocList+0x1f0>
  80230d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802311:	75 14                	jne    802327 <insert_sorted_allocList+0x204>
  802313:	83 ec 04             	sub    $0x4,%esp
  802316:	68 90 44 80 00       	push   $0x804490
  80231b:	6a 7f                	push   $0x7f
  80231d:	68 1b 44 80 00       	push   $0x80441b
  802322:	e8 d5 e0 ff ff       	call   8003fc <_panic>
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	8b 10                	mov    (%eax),%edx
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	89 10                	mov    %edx,(%eax)
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	8b 00                	mov    (%eax),%eax
  802336:	85 c0                	test   %eax,%eax
  802338:	74 0b                	je     802345 <insert_sorted_allocList+0x222>
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	8b 00                	mov    (%eax),%eax
  80233f:	8b 55 08             	mov    0x8(%ebp),%edx
  802342:	89 50 04             	mov    %edx,0x4(%eax)
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 55 08             	mov    0x8(%ebp),%edx
  80234b:	89 10                	mov    %edx,(%eax)
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802353:	89 50 04             	mov    %edx,0x4(%eax)
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	8b 00                	mov    (%eax),%eax
  80235b:	85 c0                	test   %eax,%eax
  80235d:	75 08                	jne    802367 <insert_sorted_allocList+0x244>
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	a3 44 50 80 00       	mov    %eax,0x805044
  802367:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80236c:	40                   	inc    %eax
  80236d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802372:	eb 39                	jmp    8023ad <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802374:	a1 48 50 80 00       	mov    0x805048,%eax
  802379:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802380:	74 07                	je     802389 <insert_sorted_allocList+0x266>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	eb 05                	jmp    80238e <insert_sorted_allocList+0x26b>
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
  80238e:	a3 48 50 80 00       	mov    %eax,0x805048
  802393:	a1 48 50 80 00       	mov    0x805048,%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	0f 85 3f ff ff ff    	jne    8022df <insert_sorted_allocList+0x1bc>
  8023a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a4:	0f 85 35 ff ff ff    	jne    8022df <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023aa:	eb 01                	jmp    8023ad <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023ac:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023ad:	90                   	nop
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8023bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023be:	e9 85 01 00 00       	jmp    802548 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023cc:	0f 82 6e 01 00 00    	jb     802540 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023db:	0f 85 8a 00 00 00    	jne    80246b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e5:	75 17                	jne    8023fe <alloc_block_FF+0x4e>
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	68 c4 44 80 00       	push   $0x8044c4
  8023ef:	68 93 00 00 00       	push   $0x93
  8023f4:	68 1b 44 80 00       	push   $0x80441b
  8023f9:	e8 fe df ff ff       	call   8003fc <_panic>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	85 c0                	test   %eax,%eax
  802405:	74 10                	je     802417 <alloc_block_FF+0x67>
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240f:	8b 52 04             	mov    0x4(%edx),%edx
  802412:	89 50 04             	mov    %edx,0x4(%eax)
  802415:	eb 0b                	jmp    802422 <alloc_block_FF+0x72>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 40 04             	mov    0x4(%eax),%eax
  80241d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	85 c0                	test   %eax,%eax
  80242a:	74 0f                	je     80243b <alloc_block_FF+0x8b>
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 40 04             	mov    0x4(%eax),%eax
  802432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802435:	8b 12                	mov    (%edx),%edx
  802437:	89 10                	mov    %edx,(%eax)
  802439:	eb 0a                	jmp    802445 <alloc_block_FF+0x95>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	a3 38 51 80 00       	mov    %eax,0x805138
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802458:	a1 44 51 80 00       	mov    0x805144,%eax
  80245d:	48                   	dec    %eax
  80245e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	e9 10 01 00 00       	jmp    80257b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 40 0c             	mov    0xc(%eax),%eax
  802471:	3b 45 08             	cmp    0x8(%ebp),%eax
  802474:	0f 86 c6 00 00 00    	jbe    802540 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80247a:	a1 48 51 80 00       	mov    0x805148,%eax
  80247f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 50 08             	mov    0x8(%eax),%edx
  802488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80248e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802491:	8b 55 08             	mov    0x8(%ebp),%edx
  802494:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80249b:	75 17                	jne    8024b4 <alloc_block_FF+0x104>
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	68 c4 44 80 00       	push   $0x8044c4
  8024a5:	68 9b 00 00 00       	push   $0x9b
  8024aa:	68 1b 44 80 00       	push   $0x80441b
  8024af:	e8 48 df ff ff       	call   8003fc <_panic>
  8024b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b7:	8b 00                	mov    (%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 10                	je     8024cd <alloc_block_FF+0x11d>
  8024bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c0:	8b 00                	mov    (%eax),%eax
  8024c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c5:	8b 52 04             	mov    0x4(%edx),%edx
  8024c8:	89 50 04             	mov    %edx,0x4(%eax)
  8024cb:	eb 0b                	jmp    8024d8 <alloc_block_FF+0x128>
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	8b 40 04             	mov    0x4(%eax),%eax
  8024d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024db:	8b 40 04             	mov    0x4(%eax),%eax
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	74 0f                	je     8024f1 <alloc_block_FF+0x141>
  8024e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e5:	8b 40 04             	mov    0x4(%eax),%eax
  8024e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024eb:	8b 12                	mov    (%edx),%edx
  8024ed:	89 10                	mov    %edx,(%eax)
  8024ef:	eb 0a                	jmp    8024fb <alloc_block_FF+0x14b>
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 00                	mov    (%eax),%eax
  8024f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8024fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250e:	a1 54 51 80 00       	mov    0x805154,%eax
  802513:	48                   	dec    %eax
  802514:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 50 08             	mov    0x8(%eax),%edx
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	01 c2                	add    %eax,%edx
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 40 0c             	mov    0xc(%eax),%eax
  802530:	2b 45 08             	sub    0x8(%ebp),%eax
  802533:	89 c2                	mov    %eax,%edx
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80253b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253e:	eb 3b                	jmp    80257b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802540:	a1 40 51 80 00       	mov    0x805140,%eax
  802545:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254c:	74 07                	je     802555 <alloc_block_FF+0x1a5>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	eb 05                	jmp    80255a <alloc_block_FF+0x1aa>
  802555:	b8 00 00 00 00       	mov    $0x0,%eax
  80255a:	a3 40 51 80 00       	mov    %eax,0x805140
  80255f:	a1 40 51 80 00       	mov    0x805140,%eax
  802564:	85 c0                	test   %eax,%eax
  802566:	0f 85 57 fe ff ff    	jne    8023c3 <alloc_block_FF+0x13>
  80256c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802570:	0f 85 4d fe ff ff    	jne    8023c3 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802583:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80258a:	a1 38 51 80 00       	mov    0x805138,%eax
  80258f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802592:	e9 df 00 00 00       	jmp    802676 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 40 0c             	mov    0xc(%eax),%eax
  80259d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a0:	0f 82 c8 00 00 00    	jb     80266e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025af:	0f 85 8a 00 00 00    	jne    80263f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b9:	75 17                	jne    8025d2 <alloc_block_BF+0x55>
  8025bb:	83 ec 04             	sub    $0x4,%esp
  8025be:	68 c4 44 80 00       	push   $0x8044c4
  8025c3:	68 b7 00 00 00       	push   $0xb7
  8025c8:	68 1b 44 80 00       	push   $0x80441b
  8025cd:	e8 2a de ff ff       	call   8003fc <_panic>
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 10                	je     8025eb <alloc_block_BF+0x6e>
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e3:	8b 52 04             	mov    0x4(%edx),%edx
  8025e6:	89 50 04             	mov    %edx,0x4(%eax)
  8025e9:	eb 0b                	jmp    8025f6 <alloc_block_BF+0x79>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 40 04             	mov    0x4(%eax),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	74 0f                	je     80260f <alloc_block_BF+0x92>
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	8b 40 04             	mov    0x4(%eax),%eax
  802606:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802609:	8b 12                	mov    (%edx),%edx
  80260b:	89 10                	mov    %edx,(%eax)
  80260d:	eb 0a                	jmp    802619 <alloc_block_BF+0x9c>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	a3 38 51 80 00       	mov    %eax,0x805138
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262c:	a1 44 51 80 00       	mov    0x805144,%eax
  802631:	48                   	dec    %eax
  802632:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	e9 4d 01 00 00       	jmp    80278c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 40 0c             	mov    0xc(%eax),%eax
  802645:	3b 45 08             	cmp    0x8(%ebp),%eax
  802648:	76 24                	jbe    80266e <alloc_block_BF+0xf1>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 0c             	mov    0xc(%eax),%eax
  802650:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802653:	73 19                	jae    80266e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802655:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 40 0c             	mov    0xc(%eax),%eax
  802662:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 40 08             	mov    0x8(%eax),%eax
  80266b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80266e:	a1 40 51 80 00       	mov    0x805140,%eax
  802673:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267a:	74 07                	je     802683 <alloc_block_BF+0x106>
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 00                	mov    (%eax),%eax
  802681:	eb 05                	jmp    802688 <alloc_block_BF+0x10b>
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
  802688:	a3 40 51 80 00       	mov    %eax,0x805140
  80268d:	a1 40 51 80 00       	mov    0x805140,%eax
  802692:	85 c0                	test   %eax,%eax
  802694:	0f 85 fd fe ff ff    	jne    802597 <alloc_block_BF+0x1a>
  80269a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269e:	0f 85 f3 fe ff ff    	jne    802597 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026a8:	0f 84 d9 00 00 00    	je     802787 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8026b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026bc:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c5:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026cc:	75 17                	jne    8026e5 <alloc_block_BF+0x168>
  8026ce:	83 ec 04             	sub    $0x4,%esp
  8026d1:	68 c4 44 80 00       	push   $0x8044c4
  8026d6:	68 c7 00 00 00       	push   $0xc7
  8026db:	68 1b 44 80 00       	push   $0x80441b
  8026e0:	e8 17 dd ff ff       	call   8003fc <_panic>
  8026e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e8:	8b 00                	mov    (%eax),%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	74 10                	je     8026fe <alloc_block_BF+0x181>
  8026ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f6:	8b 52 04             	mov    0x4(%edx),%edx
  8026f9:	89 50 04             	mov    %edx,0x4(%eax)
  8026fc:	eb 0b                	jmp    802709 <alloc_block_BF+0x18c>
  8026fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802701:	8b 40 04             	mov    0x4(%eax),%eax
  802704:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	74 0f                	je     802722 <alloc_block_BF+0x1a5>
  802713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80271c:	8b 12                	mov    (%edx),%edx
  80271e:	89 10                	mov    %edx,(%eax)
  802720:	eb 0a                	jmp    80272c <alloc_block_BF+0x1af>
  802722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	a3 48 51 80 00       	mov    %eax,0x805148
  80272c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802738:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273f:	a1 54 51 80 00       	mov    0x805154,%eax
  802744:	48                   	dec    %eax
  802745:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80274a:	83 ec 08             	sub    $0x8,%esp
  80274d:	ff 75 ec             	pushl  -0x14(%ebp)
  802750:	68 38 51 80 00       	push   $0x805138
  802755:	e8 71 f9 ff ff       	call   8020cb <find_block>
  80275a:	83 c4 10             	add    $0x10,%esp
  80275d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802763:	8b 50 08             	mov    0x8(%eax),%edx
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	01 c2                	add    %eax,%edx
  80276b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802771:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802774:	8b 40 0c             	mov    0xc(%eax),%eax
  802777:	2b 45 08             	sub    0x8(%ebp),%eax
  80277a:	89 c2                	mov    %eax,%edx
  80277c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802785:	eb 05                	jmp    80278c <alloc_block_BF+0x20f>
	}
	return NULL;
  802787:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    

0080278e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802794:	a1 28 50 80 00       	mov    0x805028,%eax
  802799:	85 c0                	test   %eax,%eax
  80279b:	0f 85 de 01 00 00    	jne    80297f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8027a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a9:	e9 9e 01 00 00       	jmp    80294c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b7:	0f 82 87 01 00 00    	jb     802944 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c6:	0f 85 95 00 00 00    	jne    802861 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d0:	75 17                	jne    8027e9 <alloc_block_NF+0x5b>
  8027d2:	83 ec 04             	sub    $0x4,%esp
  8027d5:	68 c4 44 80 00       	push   $0x8044c4
  8027da:	68 e0 00 00 00       	push   $0xe0
  8027df:	68 1b 44 80 00       	push   $0x80441b
  8027e4:	e8 13 dc ff ff       	call   8003fc <_panic>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	74 10                	je     802802 <alloc_block_NF+0x74>
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fa:	8b 52 04             	mov    0x4(%edx),%edx
  8027fd:	89 50 04             	mov    %edx,0x4(%eax)
  802800:	eb 0b                	jmp    80280d <alloc_block_NF+0x7f>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 04             	mov    0x4(%eax),%eax
  802808:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 0f                	je     802826 <alloc_block_NF+0x98>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 40 04             	mov    0x4(%eax),%eax
  80281d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802820:	8b 12                	mov    (%edx),%edx
  802822:	89 10                	mov    %edx,(%eax)
  802824:	eb 0a                	jmp    802830 <alloc_block_NF+0xa2>
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	a3 38 51 80 00       	mov    %eax,0x805138
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802843:	a1 44 51 80 00       	mov    0x805144,%eax
  802848:	48                   	dec    %eax
  802849:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 40 08             	mov    0x8(%eax),%eax
  802854:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	e9 f8 04 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 40 0c             	mov    0xc(%eax),%eax
  802867:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286a:	0f 86 d4 00 00 00    	jbe    802944 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802870:	a1 48 51 80 00       	mov    0x805148,%eax
  802875:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 50 08             	mov    0x8(%eax),%edx
  80287e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802881:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	8b 55 08             	mov    0x8(%ebp),%edx
  80288a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80288d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802891:	75 17                	jne    8028aa <alloc_block_NF+0x11c>
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 c4 44 80 00       	push   $0x8044c4
  80289b:	68 e9 00 00 00       	push   $0xe9
  8028a0:	68 1b 44 80 00       	push   $0x80441b
  8028a5:	e8 52 db ff ff       	call   8003fc <_panic>
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	8b 00                	mov    (%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 10                	je     8028c3 <alloc_block_NF+0x135>
  8028b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028bb:	8b 52 04             	mov    0x4(%edx),%edx
  8028be:	89 50 04             	mov    %edx,0x4(%eax)
  8028c1:	eb 0b                	jmp    8028ce <alloc_block_NF+0x140>
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d1:	8b 40 04             	mov    0x4(%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 0f                	je     8028e7 <alloc_block_NF+0x159>
  8028d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e1:	8b 12                	mov    (%edx),%edx
  8028e3:	89 10                	mov    %edx,(%eax)
  8028e5:	eb 0a                	jmp    8028f1 <alloc_block_NF+0x163>
  8028e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802904:	a1 54 51 80 00       	mov    0x805154,%eax
  802909:	48                   	dec    %eax
  80290a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	8b 40 08             	mov    0x8(%eax),%eax
  802915:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 50 08             	mov    0x8(%eax),%edx
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	01 c2                	add    %eax,%edx
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 40 0c             	mov    0xc(%eax),%eax
  802931:	2b 45 08             	sub    0x8(%ebp),%eax
  802934:	89 c2                	mov    %eax,%edx
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	e9 15 04 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802944:	a1 40 51 80 00       	mov    0x805140,%eax
  802949:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80294c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802950:	74 07                	je     802959 <alloc_block_NF+0x1cb>
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	eb 05                	jmp    80295e <alloc_block_NF+0x1d0>
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
  80295e:	a3 40 51 80 00       	mov    %eax,0x805140
  802963:	a1 40 51 80 00       	mov    0x805140,%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	0f 85 3e fe ff ff    	jne    8027ae <alloc_block_NF+0x20>
  802970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802974:	0f 85 34 fe ff ff    	jne    8027ae <alloc_block_NF+0x20>
  80297a:	e9 d5 03 00 00       	jmp    802d54 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80297f:	a1 38 51 80 00       	mov    0x805138,%eax
  802984:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802987:	e9 b1 01 00 00       	jmp    802b3d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	8b 50 08             	mov    0x8(%eax),%edx
  802992:	a1 28 50 80 00       	mov    0x805028,%eax
  802997:	39 c2                	cmp    %eax,%edx
  802999:	0f 82 96 01 00 00    	jb     802b35 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a8:	0f 82 87 01 00 00    	jb     802b35 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b7:	0f 85 95 00 00 00    	jne    802a52 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c1:	75 17                	jne    8029da <alloc_block_NF+0x24c>
  8029c3:	83 ec 04             	sub    $0x4,%esp
  8029c6:	68 c4 44 80 00       	push   $0x8044c4
  8029cb:	68 fc 00 00 00       	push   $0xfc
  8029d0:	68 1b 44 80 00       	push   $0x80441b
  8029d5:	e8 22 da ff ff       	call   8003fc <_panic>
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 00                	mov    (%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	74 10                	je     8029f3 <alloc_block_NF+0x265>
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029eb:	8b 52 04             	mov    0x4(%edx),%edx
  8029ee:	89 50 04             	mov    %edx,0x4(%eax)
  8029f1:	eb 0b                	jmp    8029fe <alloc_block_NF+0x270>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 04             	mov    0x4(%eax),%eax
  8029f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 04             	mov    0x4(%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	74 0f                	je     802a17 <alloc_block_NF+0x289>
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a11:	8b 12                	mov    (%edx),%edx
  802a13:	89 10                	mov    %edx,(%eax)
  802a15:	eb 0a                	jmp    802a21 <alloc_block_NF+0x293>
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	a3 38 51 80 00       	mov    %eax,0x805138
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a34:	a1 44 51 80 00       	mov    0x805144,%eax
  802a39:	48                   	dec    %eax
  802a3a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	8b 40 08             	mov    0x8(%eax),%eax
  802a45:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	e9 07 03 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 40 0c             	mov    0xc(%eax),%eax
  802a58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5b:	0f 86 d4 00 00 00    	jbe    802b35 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a61:	a1 48 51 80 00       	mov    0x805148,%eax
  802a66:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 50 08             	mov    0x8(%eax),%edx
  802a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a72:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a78:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a82:	75 17                	jne    802a9b <alloc_block_NF+0x30d>
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	68 c4 44 80 00       	push   $0x8044c4
  802a8c:	68 04 01 00 00       	push   $0x104
  802a91:	68 1b 44 80 00       	push   $0x80441b
  802a96:	e8 61 d9 ff ff       	call   8003fc <_panic>
  802a9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	74 10                	je     802ab4 <alloc_block_NF+0x326>
  802aa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aac:	8b 52 04             	mov    0x4(%edx),%edx
  802aaf:	89 50 04             	mov    %edx,0x4(%eax)
  802ab2:	eb 0b                	jmp    802abf <alloc_block_NF+0x331>
  802ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802abf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac2:	8b 40 04             	mov    0x4(%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 0f                	je     802ad8 <alloc_block_NF+0x34a>
  802ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad2:	8b 12                	mov    (%edx),%edx
  802ad4:	89 10                	mov    %edx,(%eax)
  802ad6:	eb 0a                	jmp    802ae2 <alloc_block_NF+0x354>
  802ad8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	a3 48 51 80 00       	mov    %eax,0x805148
  802ae2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af5:	a1 54 51 80 00       	mov    0x805154,%eax
  802afa:	48                   	dec    %eax
  802afb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b03:	8b 40 08             	mov    0x8(%eax),%eax
  802b06:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 50 08             	mov    0x8(%eax),%edx
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	01 c2                	add    %eax,%edx
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b22:	2b 45 08             	sub    0x8(%ebp),%eax
  802b25:	89 c2                	mov    %eax,%edx
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b30:	e9 24 02 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b35:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b41:	74 07                	je     802b4a <alloc_block_NF+0x3bc>
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	eb 05                	jmp    802b4f <alloc_block_NF+0x3c1>
  802b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4f:	a3 40 51 80 00       	mov    %eax,0x805140
  802b54:	a1 40 51 80 00       	mov    0x805140,%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	0f 85 2b fe ff ff    	jne    80298c <alloc_block_NF+0x1fe>
  802b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b65:	0f 85 21 fe ff ff    	jne    80298c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b73:	e9 ae 01 00 00       	jmp    802d26 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 50 08             	mov    0x8(%eax),%edx
  802b7e:	a1 28 50 80 00       	mov    0x805028,%eax
  802b83:	39 c2                	cmp    %eax,%edx
  802b85:	0f 83 93 01 00 00    	jae    802d1e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b91:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b94:	0f 82 84 01 00 00    	jb     802d1e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba3:	0f 85 95 00 00 00    	jne    802c3e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bad:	75 17                	jne    802bc6 <alloc_block_NF+0x438>
  802baf:	83 ec 04             	sub    $0x4,%esp
  802bb2:	68 c4 44 80 00       	push   $0x8044c4
  802bb7:	68 14 01 00 00       	push   $0x114
  802bbc:	68 1b 44 80 00       	push   $0x80441b
  802bc1:	e8 36 d8 ff ff       	call   8003fc <_panic>
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 10                	je     802bdf <alloc_block_NF+0x451>
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd7:	8b 52 04             	mov    0x4(%edx),%edx
  802bda:	89 50 04             	mov    %edx,0x4(%eax)
  802bdd:	eb 0b                	jmp    802bea <alloc_block_NF+0x45c>
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 40 04             	mov    0x4(%eax),%eax
  802be5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	74 0f                	je     802c03 <alloc_block_NF+0x475>
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 40 04             	mov    0x4(%eax),%eax
  802bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfd:	8b 12                	mov    (%edx),%edx
  802bff:	89 10                	mov    %edx,(%eax)
  802c01:	eb 0a                	jmp    802c0d <alloc_block_NF+0x47f>
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	a3 38 51 80 00       	mov    %eax,0x805138
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c20:	a1 44 51 80 00       	mov    0x805144,%eax
  802c25:	48                   	dec    %eax
  802c26:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 40 08             	mov    0x8(%eax),%eax
  802c31:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	e9 1b 01 00 00       	jmp    802d59 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 0c             	mov    0xc(%eax),%eax
  802c44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c47:	0f 86 d1 00 00 00    	jbe    802d1e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c4d:	a1 48 51 80 00       	mov    0x805148,%eax
  802c52:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 50 08             	mov    0x8(%eax),%edx
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c64:	8b 55 08             	mov    0x8(%ebp),%edx
  802c67:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c6e:	75 17                	jne    802c87 <alloc_block_NF+0x4f9>
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	68 c4 44 80 00       	push   $0x8044c4
  802c78:	68 1c 01 00 00       	push   $0x11c
  802c7d:	68 1b 44 80 00       	push   $0x80441b
  802c82:	e8 75 d7 ff ff       	call   8003fc <_panic>
  802c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 10                	je     802ca0 <alloc_block_NF+0x512>
  802c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c98:	8b 52 04             	mov    0x4(%edx),%edx
  802c9b:	89 50 04             	mov    %edx,0x4(%eax)
  802c9e:	eb 0b                	jmp    802cab <alloc_block_NF+0x51d>
  802ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	74 0f                	je     802cc4 <alloc_block_NF+0x536>
  802cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cbe:	8b 12                	mov    (%edx),%edx
  802cc0:	89 10                	mov    %edx,(%eax)
  802cc2:	eb 0a                	jmp    802cce <alloc_block_NF+0x540>
  802cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc7:	8b 00                	mov    (%eax),%eax
  802cc9:	a3 48 51 80 00       	mov    %eax,0x805148
  802cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce1:	a1 54 51 80 00       	mov    0x805154,%eax
  802ce6:	48                   	dec    %eax
  802ce7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	8b 40 08             	mov    0x8(%eax),%eax
  802cf2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 50 08             	mov    0x8(%eax),%edx
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	01 c2                	add    %eax,%edx
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0e:	2b 45 08             	sub    0x8(%ebp),%eax
  802d11:	89 c2                	mov    %eax,%edx
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1c:	eb 3b                	jmp    802d59 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d1e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2a:	74 07                	je     802d33 <alloc_block_NF+0x5a5>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	eb 05                	jmp    802d38 <alloc_block_NF+0x5aa>
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
  802d38:	a3 40 51 80 00       	mov    %eax,0x805140
  802d3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d42:	85 c0                	test   %eax,%eax
  802d44:	0f 85 2e fe ff ff    	jne    802b78 <alloc_block_NF+0x3ea>
  802d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4e:	0f 85 24 fe ff ff    	jne    802b78 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d59:	c9                   	leave  
  802d5a:	c3                   	ret    

00802d5b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d5b:	55                   	push   %ebp
  802d5c:	89 e5                	mov    %esp,%ebp
  802d5e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d61:	a1 38 51 80 00       	mov    0x805138,%eax
  802d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d69:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d6e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d71:	a1 38 51 80 00       	mov    0x805138,%eax
  802d76:	85 c0                	test   %eax,%eax
  802d78:	74 14                	je     802d8e <insert_sorted_with_merge_freeList+0x33>
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	8b 40 08             	mov    0x8(%eax),%eax
  802d86:	39 c2                	cmp    %eax,%edx
  802d88:	0f 87 9b 01 00 00    	ja     802f29 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d92:	75 17                	jne    802dab <insert_sorted_with_merge_freeList+0x50>
  802d94:	83 ec 04             	sub    $0x4,%esp
  802d97:	68 f8 43 80 00       	push   $0x8043f8
  802d9c:	68 38 01 00 00       	push   $0x138
  802da1:	68 1b 44 80 00       	push   $0x80441b
  802da6:	e8 51 d6 ff ff       	call   8003fc <_panic>
  802dab:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	89 10                	mov    %edx,(%eax)
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 0d                	je     802dcc <insert_sorted_with_merge_freeList+0x71>
  802dbf:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc7:	89 50 04             	mov    %edx,0x4(%eax)
  802dca:	eb 08                	jmp    802dd4 <insert_sorted_with_merge_freeList+0x79>
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	a3 38 51 80 00       	mov    %eax,0x805138
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de6:	a1 44 51 80 00       	mov    0x805144,%eax
  802deb:	40                   	inc    %eax
  802dec:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802df1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df5:	0f 84 a8 06 00 00    	je     8034a3 <insert_sorted_with_merge_freeList+0x748>
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 50 08             	mov    0x8(%eax),%edx
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 40 0c             	mov    0xc(%eax),%eax
  802e07:	01 c2                	add    %eax,%edx
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	8b 40 08             	mov    0x8(%eax),%eax
  802e0f:	39 c2                	cmp    %eax,%edx
  802e11:	0f 85 8c 06 00 00    	jne    8034a3 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	8b 40 0c             	mov    0xc(%eax),%eax
  802e23:	01 c2                	add    %eax,%edx
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e2f:	75 17                	jne    802e48 <insert_sorted_with_merge_freeList+0xed>
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	68 c4 44 80 00       	push   $0x8044c4
  802e39:	68 3c 01 00 00       	push   $0x13c
  802e3e:	68 1b 44 80 00       	push   $0x80441b
  802e43:	e8 b4 d5 ff ff       	call   8003fc <_panic>
  802e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 10                	je     802e61 <insert_sorted_with_merge_freeList+0x106>
  802e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e54:	8b 00                	mov    (%eax),%eax
  802e56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e59:	8b 52 04             	mov    0x4(%edx),%edx
  802e5c:	89 50 04             	mov    %edx,0x4(%eax)
  802e5f:	eb 0b                	jmp    802e6c <insert_sorted_with_merge_freeList+0x111>
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	8b 40 04             	mov    0x4(%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 0f                	je     802e85 <insert_sorted_with_merge_freeList+0x12a>
  802e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7f:	8b 12                	mov    (%edx),%edx
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	eb 0a                	jmp    802e8f <insert_sorted_with_merge_freeList+0x134>
  802e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	a3 38 51 80 00       	mov    %eax,0x805138
  802e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea7:	48                   	dec    %eax
  802ea8:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ec1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec5:	75 17                	jne    802ede <insert_sorted_with_merge_freeList+0x183>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 f8 43 80 00       	push   $0x8043f8
  802ecf:	68 3f 01 00 00       	push   $0x13f
  802ed4:	68 1b 44 80 00       	push   $0x80441b
  802ed9:	e8 1e d5 ff ff       	call   8003fc <_panic>
  802ede:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee7:	89 10                	mov    %edx,(%eax)
  802ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 0d                	je     802eff <insert_sorted_with_merge_freeList+0x1a4>
  802ef2:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802efa:	89 50 04             	mov    %edx,0x4(%eax)
  802efd:	eb 08                	jmp    802f07 <insert_sorted_with_merge_freeList+0x1ac>
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f19:	a1 54 51 80 00       	mov    0x805154,%eax
  802f1e:	40                   	inc    %eax
  802f1f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f24:	e9 7a 05 00 00       	jmp    8034a3 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	8b 50 08             	mov    0x8(%eax),%edx
  802f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f32:	8b 40 08             	mov    0x8(%eax),%eax
  802f35:	39 c2                	cmp    %eax,%edx
  802f37:	0f 82 14 01 00 00    	jb     803051 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f40:	8b 50 08             	mov    0x8(%eax),%edx
  802f43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f46:	8b 40 0c             	mov    0xc(%eax),%eax
  802f49:	01 c2                	add    %eax,%edx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	8b 40 08             	mov    0x8(%eax),%eax
  802f51:	39 c2                	cmp    %eax,%edx
  802f53:	0f 85 90 00 00 00    	jne    802fe9 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	01 c2                	add    %eax,%edx
  802f67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f85:	75 17                	jne    802f9e <insert_sorted_with_merge_freeList+0x243>
  802f87:	83 ec 04             	sub    $0x4,%esp
  802f8a:	68 f8 43 80 00       	push   $0x8043f8
  802f8f:	68 49 01 00 00       	push   $0x149
  802f94:	68 1b 44 80 00       	push   $0x80441b
  802f99:	e8 5e d4 ff ff       	call   8003fc <_panic>
  802f9e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0d                	je     802fbf <insert_sorted_with_merge_freeList+0x264>
  802fb2:	a1 48 51 80 00       	mov    0x805148,%eax
  802fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fba:	89 50 04             	mov    %edx,0x4(%eax)
  802fbd:	eb 08                	jmp    802fc7 <insert_sorted_with_merge_freeList+0x26c>
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	a3 48 51 80 00       	mov    %eax,0x805148
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd9:	a1 54 51 80 00       	mov    0x805154,%eax
  802fde:	40                   	inc    %eax
  802fdf:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fe4:	e9 bb 04 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fe9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fed:	75 17                	jne    803006 <insert_sorted_with_merge_freeList+0x2ab>
  802fef:	83 ec 04             	sub    $0x4,%esp
  802ff2:	68 6c 44 80 00       	push   $0x80446c
  802ff7:	68 4c 01 00 00       	push   $0x14c
  802ffc:	68 1b 44 80 00       	push   $0x80441b
  803001:	e8 f6 d3 ff ff       	call   8003fc <_panic>
  803006:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	89 50 04             	mov    %edx,0x4(%eax)
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	74 0c                	je     803028 <insert_sorted_with_merge_freeList+0x2cd>
  80301c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803021:	8b 55 08             	mov    0x8(%ebp),%edx
  803024:	89 10                	mov    %edx,(%eax)
  803026:	eb 08                	jmp    803030 <insert_sorted_with_merge_freeList+0x2d5>
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	a3 38 51 80 00       	mov    %eax,0x805138
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803041:	a1 44 51 80 00       	mov    0x805144,%eax
  803046:	40                   	inc    %eax
  803047:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80304c:	e9 53 04 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803051:	a1 38 51 80 00       	mov    0x805138,%eax
  803056:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803059:	e9 15 04 00 00       	jmp    803473 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	8b 50 08             	mov    0x8(%eax),%edx
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 40 08             	mov    0x8(%eax),%eax
  803072:	39 c2                	cmp    %eax,%edx
  803074:	0f 86 f1 03 00 00    	jbe    80346b <insert_sorted_with_merge_freeList+0x710>
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	8b 50 08             	mov    0x8(%eax),%edx
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	8b 40 08             	mov    0x8(%eax),%eax
  803086:	39 c2                	cmp    %eax,%edx
  803088:	0f 83 dd 03 00 00    	jae    80346b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80308e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803091:	8b 50 08             	mov    0x8(%eax),%edx
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 0c             	mov    0xc(%eax),%eax
  80309a:	01 c2                	add    %eax,%edx
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	8b 40 08             	mov    0x8(%eax),%eax
  8030a2:	39 c2                	cmp    %eax,%edx
  8030a4:	0f 85 b9 01 00 00    	jne    803263 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	8b 50 08             	mov    0x8(%eax),%edx
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b6:	01 c2                	add    %eax,%edx
  8030b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bb:	8b 40 08             	mov    0x8(%eax),%eax
  8030be:	39 c2                	cmp    %eax,%edx
  8030c0:	0f 85 0d 01 00 00    	jne    8031d3 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d2:	01 c2                	add    %eax,%edx
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030de:	75 17                	jne    8030f7 <insert_sorted_with_merge_freeList+0x39c>
  8030e0:	83 ec 04             	sub    $0x4,%esp
  8030e3:	68 c4 44 80 00       	push   $0x8044c4
  8030e8:	68 5c 01 00 00       	push   $0x15c
  8030ed:	68 1b 44 80 00       	push   $0x80441b
  8030f2:	e8 05 d3 ff ff       	call   8003fc <_panic>
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	74 10                	je     803110 <insert_sorted_with_merge_freeList+0x3b5>
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803108:	8b 52 04             	mov    0x4(%edx),%edx
  80310b:	89 50 04             	mov    %edx,0x4(%eax)
  80310e:	eb 0b                	jmp    80311b <insert_sorted_with_merge_freeList+0x3c0>
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	8b 40 04             	mov    0x4(%eax),%eax
  803116:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311e:	8b 40 04             	mov    0x4(%eax),%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	74 0f                	je     803134 <insert_sorted_with_merge_freeList+0x3d9>
  803125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803128:	8b 40 04             	mov    0x4(%eax),%eax
  80312b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312e:	8b 12                	mov    (%edx),%edx
  803130:	89 10                	mov    %edx,(%eax)
  803132:	eb 0a                	jmp    80313e <insert_sorted_with_merge_freeList+0x3e3>
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	a3 38 51 80 00       	mov    %eax,0x805138
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803151:	a1 44 51 80 00       	mov    0x805144,%eax
  803156:	48                   	dec    %eax
  803157:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803170:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803174:	75 17                	jne    80318d <insert_sorted_with_merge_freeList+0x432>
  803176:	83 ec 04             	sub    $0x4,%esp
  803179:	68 f8 43 80 00       	push   $0x8043f8
  80317e:	68 5f 01 00 00       	push   $0x15f
  803183:	68 1b 44 80 00       	push   $0x80441b
  803188:	e8 6f d2 ff ff       	call   8003fc <_panic>
  80318d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803193:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803196:	89 10                	mov    %edx,(%eax)
  803198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319b:	8b 00                	mov    (%eax),%eax
  80319d:	85 c0                	test   %eax,%eax
  80319f:	74 0d                	je     8031ae <insert_sorted_with_merge_freeList+0x453>
  8031a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ac:	eb 08                	jmp    8031b6 <insert_sorted_with_merge_freeList+0x45b>
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031cd:	40                   	inc    %eax
  8031ce:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031df:	01 c2                	add    %eax,%edx
  8031e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ff:	75 17                	jne    803218 <insert_sorted_with_merge_freeList+0x4bd>
  803201:	83 ec 04             	sub    $0x4,%esp
  803204:	68 f8 43 80 00       	push   $0x8043f8
  803209:	68 64 01 00 00       	push   $0x164
  80320e:	68 1b 44 80 00       	push   $0x80441b
  803213:	e8 e4 d1 ff ff       	call   8003fc <_panic>
  803218:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	89 10                	mov    %edx,(%eax)
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	85 c0                	test   %eax,%eax
  80322a:	74 0d                	je     803239 <insert_sorted_with_merge_freeList+0x4de>
  80322c:	a1 48 51 80 00       	mov    0x805148,%eax
  803231:	8b 55 08             	mov    0x8(%ebp),%edx
  803234:	89 50 04             	mov    %edx,0x4(%eax)
  803237:	eb 08                	jmp    803241 <insert_sorted_with_merge_freeList+0x4e6>
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	a3 48 51 80 00       	mov    %eax,0x805148
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803253:	a1 54 51 80 00       	mov    0x805154,%eax
  803258:	40                   	inc    %eax
  803259:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80325e:	e9 41 02 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	8b 50 08             	mov    0x8(%eax),%edx
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	8b 40 0c             	mov    0xc(%eax),%eax
  80326f:	01 c2                	add    %eax,%edx
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	8b 40 08             	mov    0x8(%eax),%eax
  803277:	39 c2                	cmp    %eax,%edx
  803279:	0f 85 7c 01 00 00    	jne    8033fb <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80327f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803283:	74 06                	je     80328b <insert_sorted_with_merge_freeList+0x530>
  803285:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803289:	75 17                	jne    8032a2 <insert_sorted_with_merge_freeList+0x547>
  80328b:	83 ec 04             	sub    $0x4,%esp
  80328e:	68 34 44 80 00       	push   $0x804434
  803293:	68 69 01 00 00       	push   $0x169
  803298:	68 1b 44 80 00       	push   $0x80441b
  80329d:	e8 5a d1 ff ff       	call   8003fc <_panic>
  8032a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a5:	8b 50 04             	mov    0x4(%eax),%edx
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	89 50 04             	mov    %edx,0x4(%eax)
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	8b 40 04             	mov    0x4(%eax),%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	74 0d                	je     8032cd <insert_sorted_with_merge_freeList+0x572>
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	8b 40 04             	mov    0x4(%eax),%eax
  8032c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c9:	89 10                	mov    %edx,(%eax)
  8032cb:	eb 08                	jmp    8032d5 <insert_sorted_with_merge_freeList+0x57a>
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032db:	89 50 04             	mov    %edx,0x4(%eax)
  8032de:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e3:	40                   	inc    %eax
  8032e4:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f5:	01 c2                	add    %eax,%edx
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803301:	75 17                	jne    80331a <insert_sorted_with_merge_freeList+0x5bf>
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 c4 44 80 00       	push   $0x8044c4
  80330b:	68 6b 01 00 00       	push   $0x16b
  803310:	68 1b 44 80 00       	push   $0x80441b
  803315:	e8 e2 d0 ff ff       	call   8003fc <_panic>
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 10                	je     803333 <insert_sorted_with_merge_freeList+0x5d8>
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332b:	8b 52 04             	mov    0x4(%edx),%edx
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	eb 0b                	jmp    80333e <insert_sorted_with_merge_freeList+0x5e3>
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0f                	je     803357 <insert_sorted_with_merge_freeList+0x5fc>
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803351:	8b 12                	mov    (%edx),%edx
  803353:	89 10                	mov    %edx,(%eax)
  803355:	eb 0a                	jmp    803361 <insert_sorted_with_merge_freeList+0x606>
  803357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	a3 38 51 80 00       	mov    %eax,0x805138
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803374:	a1 44 51 80 00       	mov    0x805144,%eax
  803379:	48                   	dec    %eax
  80337a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803393:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803397:	75 17                	jne    8033b0 <insert_sorted_with_merge_freeList+0x655>
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	68 f8 43 80 00       	push   $0x8043f8
  8033a1:	68 6e 01 00 00       	push   $0x16e
  8033a6:	68 1b 44 80 00       	push   $0x80441b
  8033ab:	e8 4c d0 ff ff       	call   8003fc <_panic>
  8033b0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b9:	89 10                	mov    %edx,(%eax)
  8033bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	74 0d                	je     8033d1 <insert_sorted_with_merge_freeList+0x676>
  8033c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033cc:	89 50 04             	mov    %edx,0x4(%eax)
  8033cf:	eb 08                	jmp    8033d9 <insert_sorted_with_merge_freeList+0x67e>
  8033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f0:	40                   	inc    %eax
  8033f1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033f6:	e9 a9 00 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ff:	74 06                	je     803407 <insert_sorted_with_merge_freeList+0x6ac>
  803401:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803405:	75 17                	jne    80341e <insert_sorted_with_merge_freeList+0x6c3>
  803407:	83 ec 04             	sub    $0x4,%esp
  80340a:	68 90 44 80 00       	push   $0x804490
  80340f:	68 73 01 00 00       	push   $0x173
  803414:	68 1b 44 80 00       	push   $0x80441b
  803419:	e8 de cf ff ff       	call   8003fc <_panic>
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	8b 10                	mov    (%eax),%edx
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	89 10                	mov    %edx,(%eax)
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	74 0b                	je     80343c <insert_sorted_with_merge_freeList+0x6e1>
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	8b 00                	mov    (%eax),%eax
  803436:	8b 55 08             	mov    0x8(%ebp),%edx
  803439:	89 50 04             	mov    %edx,0x4(%eax)
  80343c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343f:	8b 55 08             	mov    0x8(%ebp),%edx
  803442:	89 10                	mov    %edx,(%eax)
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80344a:	89 50 04             	mov    %edx,0x4(%eax)
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	85 c0                	test   %eax,%eax
  803454:	75 08                	jne    80345e <insert_sorted_with_merge_freeList+0x703>
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80345e:	a1 44 51 80 00       	mov    0x805144,%eax
  803463:	40                   	inc    %eax
  803464:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803469:	eb 39                	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80346b:	a1 40 51 80 00       	mov    0x805140,%eax
  803470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803477:	74 07                	je     803480 <insert_sorted_with_merge_freeList+0x725>
  803479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	eb 05                	jmp    803485 <insert_sorted_with_merge_freeList+0x72a>
  803480:	b8 00 00 00 00       	mov    $0x0,%eax
  803485:	a3 40 51 80 00       	mov    %eax,0x805140
  80348a:	a1 40 51 80 00       	mov    0x805140,%eax
  80348f:	85 c0                	test   %eax,%eax
  803491:	0f 85 c7 fb ff ff    	jne    80305e <insert_sorted_with_merge_freeList+0x303>
  803497:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349b:	0f 85 bd fb ff ff    	jne    80305e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034a1:	eb 01                	jmp    8034a4 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034a3:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034a4:	90                   	nop
  8034a5:	c9                   	leave  
  8034a6:	c3                   	ret    
  8034a7:	90                   	nop

008034a8 <__udivdi3>:
  8034a8:	55                   	push   %ebp
  8034a9:	57                   	push   %edi
  8034aa:	56                   	push   %esi
  8034ab:	53                   	push   %ebx
  8034ac:	83 ec 1c             	sub    $0x1c,%esp
  8034af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034bf:	89 ca                	mov    %ecx,%edx
  8034c1:	89 f8                	mov    %edi,%eax
  8034c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034c7:	85 f6                	test   %esi,%esi
  8034c9:	75 2d                	jne    8034f8 <__udivdi3+0x50>
  8034cb:	39 cf                	cmp    %ecx,%edi
  8034cd:	77 65                	ja     803534 <__udivdi3+0x8c>
  8034cf:	89 fd                	mov    %edi,%ebp
  8034d1:	85 ff                	test   %edi,%edi
  8034d3:	75 0b                	jne    8034e0 <__udivdi3+0x38>
  8034d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034da:	31 d2                	xor    %edx,%edx
  8034dc:	f7 f7                	div    %edi
  8034de:	89 c5                	mov    %eax,%ebp
  8034e0:	31 d2                	xor    %edx,%edx
  8034e2:	89 c8                	mov    %ecx,%eax
  8034e4:	f7 f5                	div    %ebp
  8034e6:	89 c1                	mov    %eax,%ecx
  8034e8:	89 d8                	mov    %ebx,%eax
  8034ea:	f7 f5                	div    %ebp
  8034ec:	89 cf                	mov    %ecx,%edi
  8034ee:	89 fa                	mov    %edi,%edx
  8034f0:	83 c4 1c             	add    $0x1c,%esp
  8034f3:	5b                   	pop    %ebx
  8034f4:	5e                   	pop    %esi
  8034f5:	5f                   	pop    %edi
  8034f6:	5d                   	pop    %ebp
  8034f7:	c3                   	ret    
  8034f8:	39 ce                	cmp    %ecx,%esi
  8034fa:	77 28                	ja     803524 <__udivdi3+0x7c>
  8034fc:	0f bd fe             	bsr    %esi,%edi
  8034ff:	83 f7 1f             	xor    $0x1f,%edi
  803502:	75 40                	jne    803544 <__udivdi3+0x9c>
  803504:	39 ce                	cmp    %ecx,%esi
  803506:	72 0a                	jb     803512 <__udivdi3+0x6a>
  803508:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80350c:	0f 87 9e 00 00 00    	ja     8035b0 <__udivdi3+0x108>
  803512:	b8 01 00 00 00       	mov    $0x1,%eax
  803517:	89 fa                	mov    %edi,%edx
  803519:	83 c4 1c             	add    $0x1c,%esp
  80351c:	5b                   	pop    %ebx
  80351d:	5e                   	pop    %esi
  80351e:	5f                   	pop    %edi
  80351f:	5d                   	pop    %ebp
  803520:	c3                   	ret    
  803521:	8d 76 00             	lea    0x0(%esi),%esi
  803524:	31 ff                	xor    %edi,%edi
  803526:	31 c0                	xor    %eax,%eax
  803528:	89 fa                	mov    %edi,%edx
  80352a:	83 c4 1c             	add    $0x1c,%esp
  80352d:	5b                   	pop    %ebx
  80352e:	5e                   	pop    %esi
  80352f:	5f                   	pop    %edi
  803530:	5d                   	pop    %ebp
  803531:	c3                   	ret    
  803532:	66 90                	xchg   %ax,%ax
  803534:	89 d8                	mov    %ebx,%eax
  803536:	f7 f7                	div    %edi
  803538:	31 ff                	xor    %edi,%edi
  80353a:	89 fa                	mov    %edi,%edx
  80353c:	83 c4 1c             	add    $0x1c,%esp
  80353f:	5b                   	pop    %ebx
  803540:	5e                   	pop    %esi
  803541:	5f                   	pop    %edi
  803542:	5d                   	pop    %ebp
  803543:	c3                   	ret    
  803544:	bd 20 00 00 00       	mov    $0x20,%ebp
  803549:	89 eb                	mov    %ebp,%ebx
  80354b:	29 fb                	sub    %edi,%ebx
  80354d:	89 f9                	mov    %edi,%ecx
  80354f:	d3 e6                	shl    %cl,%esi
  803551:	89 c5                	mov    %eax,%ebp
  803553:	88 d9                	mov    %bl,%cl
  803555:	d3 ed                	shr    %cl,%ebp
  803557:	89 e9                	mov    %ebp,%ecx
  803559:	09 f1                	or     %esi,%ecx
  80355b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80355f:	89 f9                	mov    %edi,%ecx
  803561:	d3 e0                	shl    %cl,%eax
  803563:	89 c5                	mov    %eax,%ebp
  803565:	89 d6                	mov    %edx,%esi
  803567:	88 d9                	mov    %bl,%cl
  803569:	d3 ee                	shr    %cl,%esi
  80356b:	89 f9                	mov    %edi,%ecx
  80356d:	d3 e2                	shl    %cl,%edx
  80356f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803573:	88 d9                	mov    %bl,%cl
  803575:	d3 e8                	shr    %cl,%eax
  803577:	09 c2                	or     %eax,%edx
  803579:	89 d0                	mov    %edx,%eax
  80357b:	89 f2                	mov    %esi,%edx
  80357d:	f7 74 24 0c          	divl   0xc(%esp)
  803581:	89 d6                	mov    %edx,%esi
  803583:	89 c3                	mov    %eax,%ebx
  803585:	f7 e5                	mul    %ebp
  803587:	39 d6                	cmp    %edx,%esi
  803589:	72 19                	jb     8035a4 <__udivdi3+0xfc>
  80358b:	74 0b                	je     803598 <__udivdi3+0xf0>
  80358d:	89 d8                	mov    %ebx,%eax
  80358f:	31 ff                	xor    %edi,%edi
  803591:	e9 58 ff ff ff       	jmp    8034ee <__udivdi3+0x46>
  803596:	66 90                	xchg   %ax,%ax
  803598:	8b 54 24 08          	mov    0x8(%esp),%edx
  80359c:	89 f9                	mov    %edi,%ecx
  80359e:	d3 e2                	shl    %cl,%edx
  8035a0:	39 c2                	cmp    %eax,%edx
  8035a2:	73 e9                	jae    80358d <__udivdi3+0xe5>
  8035a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035a7:	31 ff                	xor    %edi,%edi
  8035a9:	e9 40 ff ff ff       	jmp    8034ee <__udivdi3+0x46>
  8035ae:	66 90                	xchg   %ax,%ax
  8035b0:	31 c0                	xor    %eax,%eax
  8035b2:	e9 37 ff ff ff       	jmp    8034ee <__udivdi3+0x46>
  8035b7:	90                   	nop

008035b8 <__umoddi3>:
  8035b8:	55                   	push   %ebp
  8035b9:	57                   	push   %edi
  8035ba:	56                   	push   %esi
  8035bb:	53                   	push   %ebx
  8035bc:	83 ec 1c             	sub    $0x1c,%esp
  8035bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035d7:	89 f3                	mov    %esi,%ebx
  8035d9:	89 fa                	mov    %edi,%edx
  8035db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035df:	89 34 24             	mov    %esi,(%esp)
  8035e2:	85 c0                	test   %eax,%eax
  8035e4:	75 1a                	jne    803600 <__umoddi3+0x48>
  8035e6:	39 f7                	cmp    %esi,%edi
  8035e8:	0f 86 a2 00 00 00    	jbe    803690 <__umoddi3+0xd8>
  8035ee:	89 c8                	mov    %ecx,%eax
  8035f0:	89 f2                	mov    %esi,%edx
  8035f2:	f7 f7                	div    %edi
  8035f4:	89 d0                	mov    %edx,%eax
  8035f6:	31 d2                	xor    %edx,%edx
  8035f8:	83 c4 1c             	add    $0x1c,%esp
  8035fb:	5b                   	pop    %ebx
  8035fc:	5e                   	pop    %esi
  8035fd:	5f                   	pop    %edi
  8035fe:	5d                   	pop    %ebp
  8035ff:	c3                   	ret    
  803600:	39 f0                	cmp    %esi,%eax
  803602:	0f 87 ac 00 00 00    	ja     8036b4 <__umoddi3+0xfc>
  803608:	0f bd e8             	bsr    %eax,%ebp
  80360b:	83 f5 1f             	xor    $0x1f,%ebp
  80360e:	0f 84 ac 00 00 00    	je     8036c0 <__umoddi3+0x108>
  803614:	bf 20 00 00 00       	mov    $0x20,%edi
  803619:	29 ef                	sub    %ebp,%edi
  80361b:	89 fe                	mov    %edi,%esi
  80361d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803621:	89 e9                	mov    %ebp,%ecx
  803623:	d3 e0                	shl    %cl,%eax
  803625:	89 d7                	mov    %edx,%edi
  803627:	89 f1                	mov    %esi,%ecx
  803629:	d3 ef                	shr    %cl,%edi
  80362b:	09 c7                	or     %eax,%edi
  80362d:	89 e9                	mov    %ebp,%ecx
  80362f:	d3 e2                	shl    %cl,%edx
  803631:	89 14 24             	mov    %edx,(%esp)
  803634:	89 d8                	mov    %ebx,%eax
  803636:	d3 e0                	shl    %cl,%eax
  803638:	89 c2                	mov    %eax,%edx
  80363a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363e:	d3 e0                	shl    %cl,%eax
  803640:	89 44 24 04          	mov    %eax,0x4(%esp)
  803644:	8b 44 24 08          	mov    0x8(%esp),%eax
  803648:	89 f1                	mov    %esi,%ecx
  80364a:	d3 e8                	shr    %cl,%eax
  80364c:	09 d0                	or     %edx,%eax
  80364e:	d3 eb                	shr    %cl,%ebx
  803650:	89 da                	mov    %ebx,%edx
  803652:	f7 f7                	div    %edi
  803654:	89 d3                	mov    %edx,%ebx
  803656:	f7 24 24             	mull   (%esp)
  803659:	89 c6                	mov    %eax,%esi
  80365b:	89 d1                	mov    %edx,%ecx
  80365d:	39 d3                	cmp    %edx,%ebx
  80365f:	0f 82 87 00 00 00    	jb     8036ec <__umoddi3+0x134>
  803665:	0f 84 91 00 00 00    	je     8036fc <__umoddi3+0x144>
  80366b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80366f:	29 f2                	sub    %esi,%edx
  803671:	19 cb                	sbb    %ecx,%ebx
  803673:	89 d8                	mov    %ebx,%eax
  803675:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803679:	d3 e0                	shl    %cl,%eax
  80367b:	89 e9                	mov    %ebp,%ecx
  80367d:	d3 ea                	shr    %cl,%edx
  80367f:	09 d0                	or     %edx,%eax
  803681:	89 e9                	mov    %ebp,%ecx
  803683:	d3 eb                	shr    %cl,%ebx
  803685:	89 da                	mov    %ebx,%edx
  803687:	83 c4 1c             	add    $0x1c,%esp
  80368a:	5b                   	pop    %ebx
  80368b:	5e                   	pop    %esi
  80368c:	5f                   	pop    %edi
  80368d:	5d                   	pop    %ebp
  80368e:	c3                   	ret    
  80368f:	90                   	nop
  803690:	89 fd                	mov    %edi,%ebp
  803692:	85 ff                	test   %edi,%edi
  803694:	75 0b                	jne    8036a1 <__umoddi3+0xe9>
  803696:	b8 01 00 00 00       	mov    $0x1,%eax
  80369b:	31 d2                	xor    %edx,%edx
  80369d:	f7 f7                	div    %edi
  80369f:	89 c5                	mov    %eax,%ebp
  8036a1:	89 f0                	mov    %esi,%eax
  8036a3:	31 d2                	xor    %edx,%edx
  8036a5:	f7 f5                	div    %ebp
  8036a7:	89 c8                	mov    %ecx,%eax
  8036a9:	f7 f5                	div    %ebp
  8036ab:	89 d0                	mov    %edx,%eax
  8036ad:	e9 44 ff ff ff       	jmp    8035f6 <__umoddi3+0x3e>
  8036b2:	66 90                	xchg   %ax,%ax
  8036b4:	89 c8                	mov    %ecx,%eax
  8036b6:	89 f2                	mov    %esi,%edx
  8036b8:	83 c4 1c             	add    $0x1c,%esp
  8036bb:	5b                   	pop    %ebx
  8036bc:	5e                   	pop    %esi
  8036bd:	5f                   	pop    %edi
  8036be:	5d                   	pop    %ebp
  8036bf:	c3                   	ret    
  8036c0:	3b 04 24             	cmp    (%esp),%eax
  8036c3:	72 06                	jb     8036cb <__umoddi3+0x113>
  8036c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036c9:	77 0f                	ja     8036da <__umoddi3+0x122>
  8036cb:	89 f2                	mov    %esi,%edx
  8036cd:	29 f9                	sub    %edi,%ecx
  8036cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036d3:	89 14 24             	mov    %edx,(%esp)
  8036d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036de:	8b 14 24             	mov    (%esp),%edx
  8036e1:	83 c4 1c             	add    $0x1c,%esp
  8036e4:	5b                   	pop    %ebx
  8036e5:	5e                   	pop    %esi
  8036e6:	5f                   	pop    %edi
  8036e7:	5d                   	pop    %ebp
  8036e8:	c3                   	ret    
  8036e9:	8d 76 00             	lea    0x0(%esi),%esi
  8036ec:	2b 04 24             	sub    (%esp),%eax
  8036ef:	19 fa                	sbb    %edi,%edx
  8036f1:	89 d1                	mov    %edx,%ecx
  8036f3:	89 c6                	mov    %eax,%esi
  8036f5:	e9 71 ff ff ff       	jmp    80366b <__umoddi3+0xb3>
  8036fa:	66 90                	xchg   %ax,%ax
  8036fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803700:	72 ea                	jb     8036ec <__umoddi3+0x134>
  803702:	89 d9                	mov    %ebx,%ecx
  803704:	e9 62 ff ff ff       	jmp    80366b <__umoddi3+0xb3>
