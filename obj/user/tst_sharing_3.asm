
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
  80008c:	68 80 36 80 00       	push   $0x803680
  800091:	6a 12                	push   $0x12
  800093:	68 9c 36 80 00       	push   $0x80369c
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
  8000ad:	68 b4 36 80 00       	push   $0x8036b4
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 e8 36 80 00       	push   $0x8036e8
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 44 37 80 00       	push   $0x803744
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 78 37 80 00       	push   $0x803778
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 c0 37 80 00       	push   $0x8037c0
  8000f9:	e8 82 15 00 00       	call   801680 <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 4f 17 00 00       	call   801858 <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 c0 37 80 00       	push   $0x8037c0
  80011b:	e8 60 15 00 00       	call   801680 <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 c4 37 80 00       	push   $0x8037c4
  800134:	6a 24                	push   $0x24
  800136:	68 9c 36 80 00       	push   $0x80369c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 13 17 00 00       	call   801858 <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 18 38 80 00       	push   $0x803818
  800156:	6a 25                	push   $0x25
  800158:	68 9c 36 80 00       	push   $0x80369c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 74 38 80 00       	push   $0x803874
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 e1 16 00 00       	call   801858 <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 cc 38 80 00       	push   $0x8038cc
  80018e:	e8 ed 14 00 00       	call   801680 <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 d0 38 80 00       	push   $0x8038d0
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 9c 36 80 00       	push   $0x80369c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 a0 16 00 00       	call   801858 <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 44 39 80 00       	push   $0x803944
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 9c 36 80 00       	push   $0x80369c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 b8 39 80 00       	push   $0x8039b8
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 c7 18 00 00       	call   801ab1 <sys_getMaxShares>
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
  800227:	68 2c 3a 80 00       	push   $0x803a2c
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 9c 36 80 00       	push   $0x80369c
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
  80024f:	68 5c 3a 80 00       	push   $0x803a5c
  800254:	e8 27 14 00 00       	call   801680 <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 4d 18 00 00       	call   801ab1 <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 68 3a 80 00       	push   $0x803a68
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 9c 36 80 00       	push   $0x80369c
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
  80029c:	68 e4 3a 80 00       	push   $0x803ae4
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 9c 36 80 00       	push   $0x80369c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 70 3b 80 00       	push   $0x803b70
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
  8002c6:	e8 6d 18 00 00       	call   801b38 <sys_getenvindex>
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
  800331:	e8 0f 16 00 00       	call   801945 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 e8 3b 80 00       	push   $0x803be8
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
  800361:	68 10 3c 80 00       	push   $0x803c10
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
  800392:	68 38 3c 80 00       	push   $0x803c38
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 90 3c 80 00       	push   $0x803c90
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 e8 3b 80 00       	push   $0x803be8
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 8f 15 00 00       	call   80195f <sys_enable_interrupt>

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
  8003e3:	e8 1c 17 00 00       	call   801b04 <sys_destroy_env>
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
  8003f4:	e8 71 17 00 00       	call   801b6a <sys_exit_env>
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
  80041d:	68 a4 3c 80 00       	push   $0x803ca4
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 a9 3c 80 00       	push   $0x803ca9
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
  80045a:	68 c5 3c 80 00       	push   $0x803cc5
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
  800486:	68 c8 3c 80 00       	push   $0x803cc8
  80048b:	6a 26                	push   $0x26
  80048d:	68 14 3d 80 00       	push   $0x803d14
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
  800558:	68 20 3d 80 00       	push   $0x803d20
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 14 3d 80 00       	push   $0x803d14
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
  8005c8:	68 74 3d 80 00       	push   $0x803d74
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 14 3d 80 00       	push   $0x803d14
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
  800622:	e8 70 11 00 00       	call   801797 <sys_cputs>
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
  800699:	e8 f9 10 00 00       	call   801797 <sys_cputs>
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
  8006e3:	e8 5d 12 00 00       	call   801945 <sys_disable_interrupt>
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
  800703:	e8 57 12 00 00       	call   80195f <sys_enable_interrupt>
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
  80074d:	e8 ca 2c 00 00       	call   80341c <__udivdi3>
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
  80079d:	e8 8a 2d 00 00       	call   80352c <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 d4 3f 80 00       	add    $0x803fd4,%eax
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
  8008f8:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
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
  8009d9:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 e5 3f 80 00       	push   $0x803fe5
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
  8009fe:	68 ee 3f 80 00       	push   $0x803fee
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
  800a2b:	be f1 3f 80 00       	mov    $0x803ff1,%esi
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
  801451:	68 50 41 80 00       	push   $0x804150
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801504:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80150b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801513:	2d 00 10 00 00       	sub    $0x1000,%eax
  801518:	83 ec 04             	sub    $0x4,%esp
  80151b:	6a 03                	push   $0x3
  80151d:	ff 75 f4             	pushl  -0xc(%ebp)
  801520:	50                   	push   %eax
  801521:	e8 b5 03 00 00       	call   8018db <sys_allocate_chunk>
  801526:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801529:	a1 20 51 80 00       	mov    0x805120,%eax
  80152e:	83 ec 0c             	sub    $0xc,%esp
  801531:	50                   	push   %eax
  801532:	e8 2a 0a 00 00       	call   801f61 <initialize_MemBlocksList>
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
  80155f:	68 75 41 80 00       	push   $0x804175
  801564:	6a 33                	push   $0x33
  801566:	68 93 41 80 00       	push   $0x804193
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
  8015de:	68 a0 41 80 00       	push   $0x8041a0
  8015e3:	6a 34                	push   $0x34
  8015e5:	68 93 41 80 00       	push   $0x804193
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
  801653:	68 c4 41 80 00       	push   $0x8041c4
  801658:	6a 46                	push   $0x46
  80165a:	68 93 41 80 00       	push   $0x804193
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
  80166f:	68 ec 41 80 00       	push   $0x8041ec
  801674:	6a 61                	push   $0x61
  801676:	68 93 41 80 00       	push   $0x804193
  80167b:	e8 7c ed ff ff       	call   8003fc <_panic>

00801680 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 18             	sub    $0x18,%esp
  801686:	8b 45 10             	mov    0x10(%ebp),%eax
  801689:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80168c:	e8 a9 fd ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  801691:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801695:	75 07                	jne    80169e <smalloc+0x1e>
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
  80169c:	eb 14                	jmp    8016b2 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	68 10 42 80 00       	push   $0x804210
  8016a6:	6a 76                	push   $0x76
  8016a8:	68 93 41 80 00       	push   $0x804193
  8016ad:	e8 4a ed ff ff       	call   8003fc <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ba:	e8 7b fd ff ff       	call   80143a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016bf:	83 ec 04             	sub    $0x4,%esp
  8016c2:	68 38 42 80 00       	push   $0x804238
  8016c7:	68 93 00 00 00       	push   $0x93
  8016cc:	68 93 41 80 00       	push   $0x804193
  8016d1:	e8 26 ed ff ff       	call   8003fc <_panic>

008016d6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016dc:	e8 59 fd ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016e1:	83 ec 04             	sub    $0x4,%esp
  8016e4:	68 5c 42 80 00       	push   $0x80425c
  8016e9:	68 c5 00 00 00       	push   $0xc5
  8016ee:	68 93 41 80 00       	push   $0x804193
  8016f3:	e8 04 ed ff ff       	call   8003fc <_panic>

008016f8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016fe:	83 ec 04             	sub    $0x4,%esp
  801701:	68 84 42 80 00       	push   $0x804284
  801706:	68 d9 00 00 00       	push   $0xd9
  80170b:	68 93 41 80 00       	push   $0x804193
  801710:	e8 e7 ec ff ff       	call   8003fc <_panic>

00801715 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	68 a8 42 80 00       	push   $0x8042a8
  801723:	68 e4 00 00 00       	push   $0xe4
  801728:	68 93 41 80 00       	push   $0x804193
  80172d:	e8 ca ec ff ff       	call   8003fc <_panic>

00801732 <shrink>:

}
void shrink(uint32 newSize)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	68 a8 42 80 00       	push   $0x8042a8
  801740:	68 e9 00 00 00       	push   $0xe9
  801745:	68 93 41 80 00       	push   $0x804193
  80174a:	e8 ad ec ff ff       	call   8003fc <_panic>

0080174f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	68 a8 42 80 00       	push   $0x8042a8
  80175d:	68 ee 00 00 00       	push   $0xee
  801762:	68 93 41 80 00       	push   $0x804193
  801767:	e8 90 ec ff ff       	call   8003fc <_panic>

0080176c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	57                   	push   %edi
  801770:	56                   	push   %esi
  801771:	53                   	push   %ebx
  801772:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801781:	8b 7d 18             	mov    0x18(%ebp),%edi
  801784:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801787:	cd 30                	int    $0x30
  801789:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	5b                   	pop    %ebx
  801793:	5e                   	pop    %esi
  801794:	5f                   	pop    %edi
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017a3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	52                   	push   %edx
  8017af:	ff 75 0c             	pushl  0xc(%ebp)
  8017b2:	50                   	push   %eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	e8 b2 ff ff ff       	call   80176c <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	90                   	nop
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 01                	push   $0x1
  8017cf:	e8 98 ff ff ff       	call   80176c <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	52                   	push   %edx
  8017e9:	50                   	push   %eax
  8017ea:	6a 05                	push   $0x5
  8017ec:	e8 7b ff ff ff       	call   80176c <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	56                   	push   %esi
  8017fa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017fb:	8b 75 18             	mov    0x18(%ebp),%esi
  8017fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801801:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	56                   	push   %esi
  80180b:	53                   	push   %ebx
  80180c:	51                   	push   %ecx
  80180d:	52                   	push   %edx
  80180e:	50                   	push   %eax
  80180f:	6a 06                	push   $0x6
  801811:	e8 56 ff ff ff       	call   80176c <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181c:	5b                   	pop    %ebx
  80181d:	5e                   	pop    %esi
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	52                   	push   %edx
  801830:	50                   	push   %eax
  801831:	6a 07                	push   $0x7
  801833:	e8 34 ff ff ff       	call   80176c <syscall>
  801838:	83 c4 18             	add    $0x18,%esp
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	6a 08                	push   $0x8
  80184e:	e8 19 ff ff ff       	call   80176c <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 09                	push   $0x9
  801867:	e8 00 ff ff ff       	call   80176c <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 0a                	push   $0xa
  801880:	e8 e7 fe ff ff       	call   80176c <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 0b                	push   $0xb
  801899:	e8 ce fe ff ff       	call   80176c <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	6a 0f                	push   $0xf
  8018b4:	e8 b3 fe ff ff       	call   80176c <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
	return;
  8018bc:	90                   	nop
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	ff 75 0c             	pushl  0xc(%ebp)
  8018cb:	ff 75 08             	pushl  0x8(%ebp)
  8018ce:	6a 10                	push   $0x10
  8018d0:	e8 97 fe ff ff       	call   80176c <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d8:	90                   	nop
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	ff 75 10             	pushl  0x10(%ebp)
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	6a 11                	push   $0x11
  8018ed:	e8 7a fe ff ff       	call   80176c <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f5:	90                   	nop
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 0c                	push   $0xc
  801907:	e8 60 fe ff ff       	call   80176c <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	6a 0d                	push   $0xd
  801921:	e8 46 fe ff ff       	call   80176c <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 0e                	push   $0xe
  80193a:	e8 2d fe ff ff       	call   80176c <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	90                   	nop
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 13                	push   $0x13
  801954:	e8 13 fe ff ff       	call   80176c <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	90                   	nop
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 14                	push   $0x14
  80196e:	e8 f9 fd ff ff       	call   80176c <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	90                   	nop
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_cputc>:


void
sys_cputc(const char c)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 04             	sub    $0x4,%esp
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801985:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	50                   	push   %eax
  801992:	6a 15                	push   $0x15
  801994:	e8 d3 fd ff ff       	call   80176c <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 16                	push   $0x16
  8019ae:	e8 b9 fd ff ff       	call   80176c <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	90                   	nop
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	50                   	push   %eax
  8019c9:	6a 17                	push   $0x17
  8019cb:	e8 9c fd ff ff       	call   80176c <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	52                   	push   %edx
  8019e5:	50                   	push   %eax
  8019e6:	6a 1a                	push   $0x1a
  8019e8:	e8 7f fd ff ff       	call   80176c <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	52                   	push   %edx
  801a02:	50                   	push   %eax
  801a03:	6a 18                	push   $0x18
  801a05:	e8 62 fd ff ff       	call   80176c <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	52                   	push   %edx
  801a20:	50                   	push   %eax
  801a21:	6a 19                	push   $0x19
  801a23:	e8 44 fd ff ff       	call   80176c <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	8b 45 10             	mov    0x10(%ebp),%eax
  801a37:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a3a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a3d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	6a 00                	push   $0x0
  801a46:	51                   	push   %ecx
  801a47:	52                   	push   %edx
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	50                   	push   %eax
  801a4c:	6a 1b                	push   $0x1b
  801a4e:	e8 19 fd ff ff       	call   80176c <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	52                   	push   %edx
  801a68:	50                   	push   %eax
  801a69:	6a 1c                	push   $0x1c
  801a6b:	e8 fc fc ff ff       	call   80176c <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	51                   	push   %ecx
  801a86:	52                   	push   %edx
  801a87:	50                   	push   %eax
  801a88:	6a 1d                	push   $0x1d
  801a8a:	e8 dd fc ff ff       	call   80176c <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	52                   	push   %edx
  801aa4:	50                   	push   %eax
  801aa5:	6a 1e                	push   $0x1e
  801aa7:	e8 c0 fc ff ff       	call   80176c <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 1f                	push   $0x1f
  801ac0:	e8 a7 fc ff ff       	call   80176c <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	ff 75 14             	pushl  0x14(%ebp)
  801ad5:	ff 75 10             	pushl  0x10(%ebp)
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	50                   	push   %eax
  801adc:	6a 20                	push   $0x20
  801ade:	e8 89 fc ff ff       	call   80176c <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	50                   	push   %eax
  801af7:	6a 21                	push   $0x21
  801af9:	e8 6e fc ff ff       	call   80176c <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	50                   	push   %eax
  801b13:	6a 22                	push   $0x22
  801b15:	e8 52 fc ff ff       	call   80176c <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 02                	push   $0x2
  801b2e:	e8 39 fc ff ff       	call   80176c <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 03                	push   $0x3
  801b47:	e8 20 fc ff ff       	call   80176c <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 04                	push   $0x4
  801b60:	e8 07 fc ff ff       	call   80176c <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_exit_env>:


void sys_exit_env(void)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 23                	push   $0x23
  801b79:	e8 ee fb ff ff       	call   80176c <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	90                   	nop
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b8a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8d:	8d 50 04             	lea    0x4(%eax),%edx
  801b90:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	52                   	push   %edx
  801b9a:	50                   	push   %eax
  801b9b:	6a 24                	push   $0x24
  801b9d:	e8 ca fb ff ff       	call   80176c <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bae:	89 01                	mov    %eax,(%ecx)
  801bb0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	c9                   	leave  
  801bb7:	c2 04 00             	ret    $0x4

00801bba <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	ff 75 10             	pushl  0x10(%ebp)
  801bc4:	ff 75 0c             	pushl  0xc(%ebp)
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	6a 12                	push   $0x12
  801bcc:	e8 9b fb ff ff       	call   80176c <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 25                	push   $0x25
  801be6:	e8 81 fb ff ff       	call   80176c <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 04             	sub    $0x4,%esp
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bfc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	50                   	push   %eax
  801c09:	6a 26                	push   $0x26
  801c0b:	e8 5c fb ff ff       	call   80176c <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return ;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <rsttst>:
void rsttst()
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 28                	push   $0x28
  801c25:	e8 42 fb ff ff       	call   80176c <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2d:	90                   	nop
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	8b 45 14             	mov    0x14(%ebp),%eax
  801c39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c3c:	8b 55 18             	mov    0x18(%ebp),%edx
  801c3f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c43:	52                   	push   %edx
  801c44:	50                   	push   %eax
  801c45:	ff 75 10             	pushl  0x10(%ebp)
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	6a 27                	push   $0x27
  801c50:	e8 17 fb ff ff       	call   80176c <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
	return ;
  801c58:	90                   	nop
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <chktst>:
void chktst(uint32 n)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	ff 75 08             	pushl  0x8(%ebp)
  801c69:	6a 29                	push   $0x29
  801c6b:	e8 fc fa ff ff       	call   80176c <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
	return ;
  801c73:	90                   	nop
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <inctst>:

void inctst()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 2a                	push   $0x2a
  801c85:	e8 e2 fa ff ff       	call   80176c <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <gettst>:
uint32 gettst()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 2b                	push   $0x2b
  801c9f:	e8 c8 fa ff ff       	call   80176c <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 2c                	push   $0x2c
  801cbb:	e8 ac fa ff ff       	call   80176c <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
  801cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cca:	75 07                	jne    801cd3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ccc:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd1:	eb 05                	jmp    801cd8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 2c                	push   $0x2c
  801cec:	e8 7b fa ff ff       	call   80176c <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
  801cf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cfb:	75 07                	jne    801d04 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cfd:	b8 01 00 00 00       	mov    $0x1,%eax
  801d02:	eb 05                	jmp    801d09 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 2c                	push   $0x2c
  801d1d:	e8 4a fa ff ff       	call   80176c <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
  801d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d28:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d2c:	75 07                	jne    801d35 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d33:	eb 05                	jmp    801d3a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 2c                	push   $0x2c
  801d4e:	e8 19 fa ff ff       	call   80176c <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
  801d56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d59:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d5d:	75 07                	jne    801d66 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d64:	eb 05                	jmp    801d6b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	ff 75 08             	pushl  0x8(%ebp)
  801d7b:	6a 2d                	push   $0x2d
  801d7d:	e8 ea f9 ff ff       	call   80176c <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
	return ;
  801d85:	90                   	nop
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d8c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	6a 00                	push   $0x0
  801d9a:	53                   	push   %ebx
  801d9b:	51                   	push   %ecx
  801d9c:	52                   	push   %edx
  801d9d:	50                   	push   %eax
  801d9e:	6a 2e                	push   $0x2e
  801da0:	e8 c7 f9 ff ff       	call   80176c <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	52                   	push   %edx
  801dbd:	50                   	push   %eax
  801dbe:	6a 2f                	push   $0x2f
  801dc0:	e8 a7 f9 ff ff       	call   80176c <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dd0:	83 ec 0c             	sub    $0xc,%esp
  801dd3:	68 b8 42 80 00       	push   $0x8042b8
  801dd8:	e8 d3 e8 ff ff       	call   8006b0 <cprintf>
  801ddd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801de0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	68 e4 42 80 00       	push   $0x8042e4
  801def:	e8 bc e8 ff ff       	call   8006b0 <cprintf>
  801df4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801df7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dfb:	a1 38 51 80 00       	mov    0x805138,%eax
  801e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e03:	eb 56                	jmp    801e5b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e09:	74 1c                	je     801e27 <print_mem_block_lists+0x5d>
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	8b 50 08             	mov    0x8(%eax),%edx
  801e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e14:	8b 48 08             	mov    0x8(%eax),%ecx
  801e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1d:	01 c8                	add    %ecx,%eax
  801e1f:	39 c2                	cmp    %eax,%edx
  801e21:	73 04                	jae    801e27 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e23:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	8b 50 08             	mov    0x8(%eax),%edx
  801e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e30:	8b 40 0c             	mov    0xc(%eax),%eax
  801e33:	01 c2                	add    %eax,%edx
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	8b 40 08             	mov    0x8(%eax),%eax
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	52                   	push   %edx
  801e3f:	50                   	push   %eax
  801e40:	68 f9 42 80 00       	push   $0x8042f9
  801e45:	e8 66 e8 ff ff       	call   8006b0 <cprintf>
  801e4a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e53:	a1 40 51 80 00       	mov    0x805140,%eax
  801e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5f:	74 07                	je     801e68 <print_mem_block_lists+0x9e>
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	8b 00                	mov    (%eax),%eax
  801e66:	eb 05                	jmp    801e6d <print_mem_block_lists+0xa3>
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6d:	a3 40 51 80 00       	mov    %eax,0x805140
  801e72:	a1 40 51 80 00       	mov    0x805140,%eax
  801e77:	85 c0                	test   %eax,%eax
  801e79:	75 8a                	jne    801e05 <print_mem_block_lists+0x3b>
  801e7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7f:	75 84                	jne    801e05 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e81:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e85:	75 10                	jne    801e97 <print_mem_block_lists+0xcd>
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	68 08 43 80 00       	push   $0x804308
  801e8f:	e8 1c e8 ff ff       	call   8006b0 <cprintf>
  801e94:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	68 2c 43 80 00       	push   $0x80432c
  801ea6:	e8 05 e8 ff ff       	call   8006b0 <cprintf>
  801eab:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801eae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eb2:	a1 40 50 80 00       	mov    0x805040,%eax
  801eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eba:	eb 56                	jmp    801f12 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec0:	74 1c                	je     801ede <print_mem_block_lists+0x114>
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	8b 50 08             	mov    0x8(%eax),%edx
  801ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecb:	8b 48 08             	mov    0x8(%eax),%ecx
  801ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed4:	01 c8                	add    %ecx,%eax
  801ed6:	39 c2                	cmp    %eax,%edx
  801ed8:	73 04                	jae    801ede <print_mem_block_lists+0x114>
			sorted = 0 ;
  801eda:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee1:	8b 50 08             	mov    0x8(%eax),%edx
  801ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eea:	01 c2                	add    %eax,%edx
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 40 08             	mov    0x8(%eax),%eax
  801ef2:	83 ec 04             	sub    $0x4,%esp
  801ef5:	52                   	push   %edx
  801ef6:	50                   	push   %eax
  801ef7:	68 f9 42 80 00       	push   $0x8042f9
  801efc:	e8 af e7 ff ff       	call   8006b0 <cprintf>
  801f01:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f0a:	a1 48 50 80 00       	mov    0x805048,%eax
  801f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f16:	74 07                	je     801f1f <print_mem_block_lists+0x155>
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	eb 05                	jmp    801f24 <print_mem_block_lists+0x15a>
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f24:	a3 48 50 80 00       	mov    %eax,0x805048
  801f29:	a1 48 50 80 00       	mov    0x805048,%eax
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	75 8a                	jne    801ebc <print_mem_block_lists+0xf2>
  801f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f36:	75 84                	jne    801ebc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f38:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f3c:	75 10                	jne    801f4e <print_mem_block_lists+0x184>
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	68 44 43 80 00       	push   $0x804344
  801f46:	e8 65 e7 ff ff       	call   8006b0 <cprintf>
  801f4b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	68 b8 42 80 00       	push   $0x8042b8
  801f56:	e8 55 e7 ff ff       	call   8006b0 <cprintf>
  801f5b:	83 c4 10             	add    $0x10,%esp

}
  801f5e:	90                   	nop
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f67:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f6e:	00 00 00 
  801f71:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f78:	00 00 00 
  801f7b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f82:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f8c:	e9 9e 00 00 00       	jmp    80202f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f91:	a1 50 50 80 00       	mov    0x805050,%eax
  801f96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f99:	c1 e2 04             	shl    $0x4,%edx
  801f9c:	01 d0                	add    %edx,%eax
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	75 14                	jne    801fb6 <initialize_MemBlocksList+0x55>
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	68 6c 43 80 00       	push   $0x80436c
  801faa:	6a 46                	push   $0x46
  801fac:	68 8f 43 80 00       	push   $0x80438f
  801fb1:	e8 46 e4 ff ff       	call   8003fc <_panic>
  801fb6:	a1 50 50 80 00       	mov    0x805050,%eax
  801fbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbe:	c1 e2 04             	shl    $0x4,%edx
  801fc1:	01 d0                	add    %edx,%eax
  801fc3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fc9:	89 10                	mov    %edx,(%eax)
  801fcb:	8b 00                	mov    (%eax),%eax
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	74 18                	je     801fe9 <initialize_MemBlocksList+0x88>
  801fd1:	a1 48 51 80 00       	mov    0x805148,%eax
  801fd6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fdc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fdf:	c1 e1 04             	shl    $0x4,%ecx
  801fe2:	01 ca                	add    %ecx,%edx
  801fe4:	89 50 04             	mov    %edx,0x4(%eax)
  801fe7:	eb 12                	jmp    801ffb <initialize_MemBlocksList+0x9a>
  801fe9:	a1 50 50 80 00       	mov    0x805050,%eax
  801fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff1:	c1 e2 04             	shl    $0x4,%edx
  801ff4:	01 d0                	add    %edx,%eax
  801ff6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ffb:	a1 50 50 80 00       	mov    0x805050,%eax
  802000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802003:	c1 e2 04             	shl    $0x4,%edx
  802006:	01 d0                	add    %edx,%eax
  802008:	a3 48 51 80 00       	mov    %eax,0x805148
  80200d:	a1 50 50 80 00       	mov    0x805050,%eax
  802012:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802015:	c1 e2 04             	shl    $0x4,%edx
  802018:	01 d0                	add    %edx,%eax
  80201a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802021:	a1 54 51 80 00       	mov    0x805154,%eax
  802026:	40                   	inc    %eax
  802027:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80202c:	ff 45 f4             	incl   -0xc(%ebp)
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	3b 45 08             	cmp    0x8(%ebp),%eax
  802035:	0f 82 56 ff ff ff    	jb     801f91 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80203b:	90                   	nop
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	8b 00                	mov    (%eax),%eax
  802049:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80204c:	eb 19                	jmp    802067 <find_block+0x29>
	{
		if(va==point->sva)
  80204e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802051:	8b 40 08             	mov    0x8(%eax),%eax
  802054:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802057:	75 05                	jne    80205e <find_block+0x20>
		   return point;
  802059:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205c:	eb 36                	jmp    802094 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	8b 40 08             	mov    0x8(%eax),%eax
  802064:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802067:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80206b:	74 07                	je     802074 <find_block+0x36>
  80206d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802070:	8b 00                	mov    (%eax),%eax
  802072:	eb 05                	jmp    802079 <find_block+0x3b>
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
  802079:	8b 55 08             	mov    0x8(%ebp),%edx
  80207c:	89 42 08             	mov    %eax,0x8(%edx)
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	8b 40 08             	mov    0x8(%eax),%eax
  802085:	85 c0                	test   %eax,%eax
  802087:	75 c5                	jne    80204e <find_block+0x10>
  802089:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80208d:	75 bf                	jne    80204e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80209c:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020a4:	a1 44 50 80 00       	mov    0x805044,%eax
  8020a9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020b2:	74 24                	je     8020d8 <insert_sorted_allocList+0x42>
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	8b 50 08             	mov    0x8(%eax),%edx
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	8b 40 08             	mov    0x8(%eax),%eax
  8020c0:	39 c2                	cmp    %eax,%edx
  8020c2:	76 14                	jbe    8020d8 <insert_sorted_allocList+0x42>
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	8b 50 08             	mov    0x8(%eax),%edx
  8020ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cd:	8b 40 08             	mov    0x8(%eax),%eax
  8020d0:	39 c2                	cmp    %eax,%edx
  8020d2:	0f 82 60 01 00 00    	jb     802238 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020dc:	75 65                	jne    802143 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e2:	75 14                	jne    8020f8 <insert_sorted_allocList+0x62>
  8020e4:	83 ec 04             	sub    $0x4,%esp
  8020e7:	68 6c 43 80 00       	push   $0x80436c
  8020ec:	6a 6b                	push   $0x6b
  8020ee:	68 8f 43 80 00       	push   $0x80438f
  8020f3:	e8 04 e3 ff ff       	call   8003fc <_panic>
  8020f8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	89 10                	mov    %edx,(%eax)
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	74 0d                	je     802119 <insert_sorted_allocList+0x83>
  80210c:	a1 40 50 80 00       	mov    0x805040,%eax
  802111:	8b 55 08             	mov    0x8(%ebp),%edx
  802114:	89 50 04             	mov    %edx,0x4(%eax)
  802117:	eb 08                	jmp    802121 <insert_sorted_allocList+0x8b>
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	a3 44 50 80 00       	mov    %eax,0x805044
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	a3 40 50 80 00       	mov    %eax,0x805040
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802133:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802138:	40                   	inc    %eax
  802139:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80213e:	e9 dc 01 00 00       	jmp    80231f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	8b 50 08             	mov    0x8(%eax),%edx
  802149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214c:	8b 40 08             	mov    0x8(%eax),%eax
  80214f:	39 c2                	cmp    %eax,%edx
  802151:	77 6c                	ja     8021bf <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802153:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802157:	74 06                	je     80215f <insert_sorted_allocList+0xc9>
  802159:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215d:	75 14                	jne    802173 <insert_sorted_allocList+0xdd>
  80215f:	83 ec 04             	sub    $0x4,%esp
  802162:	68 a8 43 80 00       	push   $0x8043a8
  802167:	6a 6f                	push   $0x6f
  802169:	68 8f 43 80 00       	push   $0x80438f
  80216e:	e8 89 e2 ff ff       	call   8003fc <_panic>
  802173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802176:	8b 50 04             	mov    0x4(%eax),%edx
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	89 50 04             	mov    %edx,0x4(%eax)
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802185:	89 10                	mov    %edx,(%eax)
  802187:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218a:	8b 40 04             	mov    0x4(%eax),%eax
  80218d:	85 c0                	test   %eax,%eax
  80218f:	74 0d                	je     80219e <insert_sorted_allocList+0x108>
  802191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802194:	8b 40 04             	mov    0x4(%eax),%eax
  802197:	8b 55 08             	mov    0x8(%ebp),%edx
  80219a:	89 10                	mov    %edx,(%eax)
  80219c:	eb 08                	jmp    8021a6 <insert_sorted_allocList+0x110>
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	a3 40 50 80 00       	mov    %eax,0x805040
  8021a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ac:	89 50 04             	mov    %edx,0x4(%eax)
  8021af:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b4:	40                   	inc    %eax
  8021b5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021ba:	e9 60 01 00 00       	jmp    80231f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	8b 50 08             	mov    0x8(%eax),%edx
  8021c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c8:	8b 40 08             	mov    0x8(%eax),%eax
  8021cb:	39 c2                	cmp    %eax,%edx
  8021cd:	0f 82 4c 01 00 00    	jb     80231f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d7:	75 14                	jne    8021ed <insert_sorted_allocList+0x157>
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	68 e0 43 80 00       	push   $0x8043e0
  8021e1:	6a 73                	push   $0x73
  8021e3:	68 8f 43 80 00       	push   $0x80438f
  8021e8:	e8 0f e2 ff ff       	call   8003fc <_panic>
  8021ed:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	89 50 04             	mov    %edx,0x4(%eax)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	8b 40 04             	mov    0x4(%eax),%eax
  8021ff:	85 c0                	test   %eax,%eax
  802201:	74 0c                	je     80220f <insert_sorted_allocList+0x179>
  802203:	a1 44 50 80 00       	mov    0x805044,%eax
  802208:	8b 55 08             	mov    0x8(%ebp),%edx
  80220b:	89 10                	mov    %edx,(%eax)
  80220d:	eb 08                	jmp    802217 <insert_sorted_allocList+0x181>
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	a3 40 50 80 00       	mov    %eax,0x805040
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	a3 44 50 80 00       	mov    %eax,0x805044
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802228:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80222d:	40                   	inc    %eax
  80222e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802233:	e9 e7 00 00 00       	jmp    80231f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80223e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802245:	a1 40 50 80 00       	mov    0x805040,%eax
  80224a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224d:	e9 9d 00 00 00       	jmp    8022ef <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	8b 00                	mov    (%eax),%eax
  802257:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	8b 50 08             	mov    0x8(%eax),%edx
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 40 08             	mov    0x8(%eax),%eax
  802266:	39 c2                	cmp    %eax,%edx
  802268:	76 7d                	jbe    8022e7 <insert_sorted_allocList+0x251>
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8b 50 08             	mov    0x8(%eax),%edx
  802270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	73 6d                	jae    8022e7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80227a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227e:	74 06                	je     802286 <insert_sorted_allocList+0x1f0>
  802280:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802284:	75 14                	jne    80229a <insert_sorted_allocList+0x204>
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	68 04 44 80 00       	push   $0x804404
  80228e:	6a 7f                	push   $0x7f
  802290:	68 8f 43 80 00       	push   $0x80438f
  802295:	e8 62 e1 ff ff       	call   8003fc <_panic>
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 10                	mov    (%eax),%edx
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	89 10                	mov    %edx,(%eax)
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	74 0b                	je     8022b8 <insert_sorted_allocList+0x222>
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	8b 00                	mov    (%eax),%eax
  8022b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b5:	89 50 04             	mov    %edx,0x4(%eax)
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022be:	89 10                	mov    %edx,(%eax)
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c6:	89 50 04             	mov    %edx,0x4(%eax)
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	8b 00                	mov    (%eax),%eax
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	75 08                	jne    8022da <insert_sorted_allocList+0x244>
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	a3 44 50 80 00       	mov    %eax,0x805044
  8022da:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022df:	40                   	inc    %eax
  8022e0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022e5:	eb 39                	jmp    802320 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022e7:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f3:	74 07                	je     8022fc <insert_sorted_allocList+0x266>
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	8b 00                	mov    (%eax),%eax
  8022fa:	eb 05                	jmp    802301 <insert_sorted_allocList+0x26b>
  8022fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802301:	a3 48 50 80 00       	mov    %eax,0x805048
  802306:	a1 48 50 80 00       	mov    0x805048,%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	0f 85 3f ff ff ff    	jne    802252 <insert_sorted_allocList+0x1bc>
  802313:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802317:	0f 85 35 ff ff ff    	jne    802252 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80231d:	eb 01                	jmp    802320 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80231f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802320:	90                   	nop
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802329:	a1 38 51 80 00       	mov    0x805138,%eax
  80232e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802331:	e9 85 01 00 00       	jmp    8024bb <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 40 0c             	mov    0xc(%eax),%eax
  80233c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233f:	0f 82 6e 01 00 00    	jb     8024b3 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 0c             	mov    0xc(%eax),%eax
  80234b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234e:	0f 85 8a 00 00 00    	jne    8023de <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802358:	75 17                	jne    802371 <alloc_block_FF+0x4e>
  80235a:	83 ec 04             	sub    $0x4,%esp
  80235d:	68 38 44 80 00       	push   $0x804438
  802362:	68 93 00 00 00       	push   $0x93
  802367:	68 8f 43 80 00       	push   $0x80438f
  80236c:	e8 8b e0 ff ff       	call   8003fc <_panic>
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	74 10                	je     80238a <alloc_block_FF+0x67>
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 00                	mov    (%eax),%eax
  80237f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802382:	8b 52 04             	mov    0x4(%edx),%edx
  802385:	89 50 04             	mov    %edx,0x4(%eax)
  802388:	eb 0b                	jmp    802395 <alloc_block_FF+0x72>
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 40 04             	mov    0x4(%eax),%eax
  802390:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 40 04             	mov    0x4(%eax),%eax
  80239b:	85 c0                	test   %eax,%eax
  80239d:	74 0f                	je     8023ae <alloc_block_FF+0x8b>
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 40 04             	mov    0x4(%eax),%eax
  8023a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a8:	8b 12                	mov    (%edx),%edx
  8023aa:	89 10                	mov    %edx,(%eax)
  8023ac:	eb 0a                	jmp    8023b8 <alloc_block_FF+0x95>
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8023d0:	48                   	dec    %eax
  8023d1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	e9 10 01 00 00       	jmp    8024ee <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e7:	0f 86 c6 00 00 00    	jbe    8024b3 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8023f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 50 08             	mov    0x8(%eax),%edx
  8023fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fe:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802404:	8b 55 08             	mov    0x8(%ebp),%edx
  802407:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80240a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240e:	75 17                	jne    802427 <alloc_block_FF+0x104>
  802410:	83 ec 04             	sub    $0x4,%esp
  802413:	68 38 44 80 00       	push   $0x804438
  802418:	68 9b 00 00 00       	push   $0x9b
  80241d:	68 8f 43 80 00       	push   $0x80438f
  802422:	e8 d5 df ff ff       	call   8003fc <_panic>
  802427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242a:	8b 00                	mov    (%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 10                	je     802440 <alloc_block_FF+0x11d>
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802438:	8b 52 04             	mov    0x4(%edx),%edx
  80243b:	89 50 04             	mov    %edx,0x4(%eax)
  80243e:	eb 0b                	jmp    80244b <alloc_block_FF+0x128>
  802440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802443:	8b 40 04             	mov    0x4(%eax),%eax
  802446:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80244b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244e:	8b 40 04             	mov    0x4(%eax),%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	74 0f                	je     802464 <alloc_block_FF+0x141>
  802455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802458:	8b 40 04             	mov    0x4(%eax),%eax
  80245b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245e:	8b 12                	mov    (%edx),%edx
  802460:	89 10                	mov    %edx,(%eax)
  802462:	eb 0a                	jmp    80246e <alloc_block_FF+0x14b>
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	a3 48 51 80 00       	mov    %eax,0x805148
  80246e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802481:	a1 54 51 80 00       	mov    0x805154,%eax
  802486:	48                   	dec    %eax
  802487:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 50 08             	mov    0x8(%eax),%edx
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	01 c2                	add    %eax,%edx
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a3:	2b 45 08             	sub    0x8(%ebp),%eax
  8024a6:	89 c2                	mov    %eax,%edx
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b1:	eb 3b                	jmp    8024ee <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bf:	74 07                	je     8024c8 <alloc_block_FF+0x1a5>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	eb 05                	jmp    8024cd <alloc_block_FF+0x1aa>
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8024d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	0f 85 57 fe ff ff    	jne    802336 <alloc_block_FF+0x13>
  8024df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e3:	0f 85 4d fe ff ff    	jne    802336 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024fd:	a1 38 51 80 00       	mov    0x805138,%eax
  802502:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802505:	e9 df 00 00 00       	jmp    8025e9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 0c             	mov    0xc(%eax),%eax
  802510:	3b 45 08             	cmp    0x8(%ebp),%eax
  802513:	0f 82 c8 00 00 00    	jb     8025e1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 0c             	mov    0xc(%eax),%eax
  80251f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802522:	0f 85 8a 00 00 00    	jne    8025b2 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252c:	75 17                	jne    802545 <alloc_block_BF+0x55>
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	68 38 44 80 00       	push   $0x804438
  802536:	68 b7 00 00 00       	push   $0xb7
  80253b:	68 8f 43 80 00       	push   $0x80438f
  802540:	e8 b7 de ff ff       	call   8003fc <_panic>
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 10                	je     80255e <alloc_block_BF+0x6e>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802556:	8b 52 04             	mov    0x4(%edx),%edx
  802559:	89 50 04             	mov    %edx,0x4(%eax)
  80255c:	eb 0b                	jmp    802569 <alloc_block_BF+0x79>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 40 04             	mov    0x4(%eax),%eax
  802564:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 04             	mov    0x4(%eax),%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 0f                	je     802582 <alloc_block_BF+0x92>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 04             	mov    0x4(%eax),%eax
  802579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257c:	8b 12                	mov    (%edx),%edx
  80257e:	89 10                	mov    %edx,(%eax)
  802580:	eb 0a                	jmp    80258c <alloc_block_BF+0x9c>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	a3 38 51 80 00       	mov    %eax,0x805138
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259f:	a1 44 51 80 00       	mov    0x805144,%eax
  8025a4:	48                   	dec    %eax
  8025a5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	e9 4d 01 00 00       	jmp    8026ff <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bb:	76 24                	jbe    8025e1 <alloc_block_BF+0xf1>
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c6:	73 19                	jae    8025e1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025c8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 08             	mov    0x8(%eax),%eax
  8025de:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ed:	74 07                	je     8025f6 <alloc_block_BF+0x106>
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 00                	mov    (%eax),%eax
  8025f4:	eb 05                	jmp    8025fb <alloc_block_BF+0x10b>
  8025f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fb:	a3 40 51 80 00       	mov    %eax,0x805140
  802600:	a1 40 51 80 00       	mov    0x805140,%eax
  802605:	85 c0                	test   %eax,%eax
  802607:	0f 85 fd fe ff ff    	jne    80250a <alloc_block_BF+0x1a>
  80260d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802611:	0f 85 f3 fe ff ff    	jne    80250a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802617:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80261b:	0f 84 d9 00 00 00    	je     8026fa <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802621:	a1 48 51 80 00       	mov    0x805148,%eax
  802626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80262f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802635:	8b 55 08             	mov    0x8(%ebp),%edx
  802638:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80263b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80263f:	75 17                	jne    802658 <alloc_block_BF+0x168>
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	68 38 44 80 00       	push   $0x804438
  802649:	68 c7 00 00 00       	push   $0xc7
  80264e:	68 8f 43 80 00       	push   $0x80438f
  802653:	e8 a4 dd ff ff       	call   8003fc <_panic>
  802658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265b:	8b 00                	mov    (%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 10                	je     802671 <alloc_block_BF+0x181>
  802661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802669:	8b 52 04             	mov    0x4(%edx),%edx
  80266c:	89 50 04             	mov    %edx,0x4(%eax)
  80266f:	eb 0b                	jmp    80267c <alloc_block_BF+0x18c>
  802671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802674:	8b 40 04             	mov    0x4(%eax),%eax
  802677:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80267c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267f:	8b 40 04             	mov    0x4(%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 0f                	je     802695 <alloc_block_BF+0x1a5>
  802686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802689:	8b 40 04             	mov    0x4(%eax),%eax
  80268c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80268f:	8b 12                	mov    (%edx),%edx
  802691:	89 10                	mov    %edx,(%eax)
  802693:	eb 0a                	jmp    80269f <alloc_block_BF+0x1af>
  802695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	a3 48 51 80 00       	mov    %eax,0x805148
  80269f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b2:	a1 54 51 80 00       	mov    0x805154,%eax
  8026b7:	48                   	dec    %eax
  8026b8:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026bd:	83 ec 08             	sub    $0x8,%esp
  8026c0:	ff 75 ec             	pushl  -0x14(%ebp)
  8026c3:	68 38 51 80 00       	push   $0x805138
  8026c8:	e8 71 f9 ff ff       	call   80203e <find_block>
  8026cd:	83 c4 10             	add    $0x10,%esp
  8026d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d6:	8b 50 08             	mov    0x8(%eax),%edx
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	01 c2                	add    %eax,%edx
  8026de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ed:	89 c2                	mov    %eax,%edx
  8026ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f8:	eb 05                	jmp    8026ff <alloc_block_BF+0x20f>
	}
	return NULL;
  8026fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
  802704:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802707:	a1 28 50 80 00       	mov    0x805028,%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	0f 85 de 01 00 00    	jne    8028f2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802714:	a1 38 51 80 00       	mov    0x805138,%eax
  802719:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271c:	e9 9e 01 00 00       	jmp    8028bf <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 0c             	mov    0xc(%eax),%eax
  802727:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272a:	0f 82 87 01 00 00    	jb     8028b7 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 0c             	mov    0xc(%eax),%eax
  802736:	3b 45 08             	cmp    0x8(%ebp),%eax
  802739:	0f 85 95 00 00 00    	jne    8027d4 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80273f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802743:	75 17                	jne    80275c <alloc_block_NF+0x5b>
  802745:	83 ec 04             	sub    $0x4,%esp
  802748:	68 38 44 80 00       	push   $0x804438
  80274d:	68 e0 00 00 00       	push   $0xe0
  802752:	68 8f 43 80 00       	push   $0x80438f
  802757:	e8 a0 dc ff ff       	call   8003fc <_panic>
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 00                	mov    (%eax),%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	74 10                	je     802775 <alloc_block_NF+0x74>
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 00                	mov    (%eax),%eax
  80276a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276d:	8b 52 04             	mov    0x4(%edx),%edx
  802770:	89 50 04             	mov    %edx,0x4(%eax)
  802773:	eb 0b                	jmp    802780 <alloc_block_NF+0x7f>
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 40 04             	mov    0x4(%eax),%eax
  80277b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 40 04             	mov    0x4(%eax),%eax
  802786:	85 c0                	test   %eax,%eax
  802788:	74 0f                	je     802799 <alloc_block_NF+0x98>
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 40 04             	mov    0x4(%eax),%eax
  802790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802793:	8b 12                	mov    (%edx),%edx
  802795:	89 10                	mov    %edx,(%eax)
  802797:	eb 0a                	jmp    8027a3 <alloc_block_NF+0xa2>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	a3 38 51 80 00       	mov    %eax,0x805138
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8027bb:	48                   	dec    %eax
  8027bc:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 08             	mov    0x8(%eax),%eax
  8027c7:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	e9 f8 04 00 00       	jmp    802ccc <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027dd:	0f 86 d4 00 00 00    	jbe    8028b7 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 50 08             	mov    0x8(%eax),%edx
  8027f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fd:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802800:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802804:	75 17                	jne    80281d <alloc_block_NF+0x11c>
  802806:	83 ec 04             	sub    $0x4,%esp
  802809:	68 38 44 80 00       	push   $0x804438
  80280e:	68 e9 00 00 00       	push   $0xe9
  802813:	68 8f 43 80 00       	push   $0x80438f
  802818:	e8 df db ff ff       	call   8003fc <_panic>
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	8b 00                	mov    (%eax),%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	74 10                	je     802836 <alloc_block_NF+0x135>
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282e:	8b 52 04             	mov    0x4(%edx),%edx
  802831:	89 50 04             	mov    %edx,0x4(%eax)
  802834:	eb 0b                	jmp    802841 <alloc_block_NF+0x140>
  802836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802839:	8b 40 04             	mov    0x4(%eax),%eax
  80283c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802844:	8b 40 04             	mov    0x4(%eax),%eax
  802847:	85 c0                	test   %eax,%eax
  802849:	74 0f                	je     80285a <alloc_block_NF+0x159>
  80284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284e:	8b 40 04             	mov    0x4(%eax),%eax
  802851:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802854:	8b 12                	mov    (%edx),%edx
  802856:	89 10                	mov    %edx,(%eax)
  802858:	eb 0a                	jmp    802864 <alloc_block_NF+0x163>
  80285a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285d:	8b 00                	mov    (%eax),%eax
  80285f:	a3 48 51 80 00       	mov    %eax,0x805148
  802864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802867:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802877:	a1 54 51 80 00       	mov    0x805154,%eax
  80287c:	48                   	dec    %eax
  80287d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	8b 40 08             	mov    0x8(%eax),%eax
  802888:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 50 08             	mov    0x8(%eax),%edx
  802893:	8b 45 08             	mov    0x8(%ebp),%eax
  802896:	01 c2                	add    %eax,%edx
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a7:	89 c2                	mov    %eax,%edx
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b2:	e9 15 04 00 00       	jmp    802ccc <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c3:	74 07                	je     8028cc <alloc_block_NF+0x1cb>
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 00                	mov    (%eax),%eax
  8028ca:	eb 05                	jmp    8028d1 <alloc_block_NF+0x1d0>
  8028cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d1:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	0f 85 3e fe ff ff    	jne    802721 <alloc_block_NF+0x20>
  8028e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e7:	0f 85 34 fe ff ff    	jne    802721 <alloc_block_NF+0x20>
  8028ed:	e9 d5 03 00 00       	jmp    802cc7 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fa:	e9 b1 01 00 00       	jmp    802ab0 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 50 08             	mov    0x8(%eax),%edx
  802905:	a1 28 50 80 00       	mov    0x805028,%eax
  80290a:	39 c2                	cmp    %eax,%edx
  80290c:	0f 82 96 01 00 00    	jb     802aa8 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 0c             	mov    0xc(%eax),%eax
  802918:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291b:	0f 82 87 01 00 00    	jb     802aa8 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 0c             	mov    0xc(%eax),%eax
  802927:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292a:	0f 85 95 00 00 00    	jne    8029c5 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802930:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802934:	75 17                	jne    80294d <alloc_block_NF+0x24c>
  802936:	83 ec 04             	sub    $0x4,%esp
  802939:	68 38 44 80 00       	push   $0x804438
  80293e:	68 fc 00 00 00       	push   $0xfc
  802943:	68 8f 43 80 00       	push   $0x80438f
  802948:	e8 af da ff ff       	call   8003fc <_panic>
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	74 10                	je     802966 <alloc_block_NF+0x265>
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 00                	mov    (%eax),%eax
  80295b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295e:	8b 52 04             	mov    0x4(%edx),%edx
  802961:	89 50 04             	mov    %edx,0x4(%eax)
  802964:	eb 0b                	jmp    802971 <alloc_block_NF+0x270>
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 40 04             	mov    0x4(%eax),%eax
  80296c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 40 04             	mov    0x4(%eax),%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	74 0f                	je     80298a <alloc_block_NF+0x289>
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 04             	mov    0x4(%eax),%eax
  802981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802984:	8b 12                	mov    (%edx),%edx
  802986:	89 10                	mov    %edx,(%eax)
  802988:	eb 0a                	jmp    802994 <alloc_block_NF+0x293>
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	a3 38 51 80 00       	mov    %eax,0x805138
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8029ac:	48                   	dec    %eax
  8029ad:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 40 08             	mov    0x8(%eax),%eax
  8029b8:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	e9 07 03 00 00       	jmp    802ccc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ce:	0f 86 d4 00 00 00    	jbe    802aa8 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 50 08             	mov    0x8(%eax),%edx
  8029e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ee:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f5:	75 17                	jne    802a0e <alloc_block_NF+0x30d>
  8029f7:	83 ec 04             	sub    $0x4,%esp
  8029fa:	68 38 44 80 00       	push   $0x804438
  8029ff:	68 04 01 00 00       	push   $0x104
  802a04:	68 8f 43 80 00       	push   $0x80438f
  802a09:	e8 ee d9 ff ff       	call   8003fc <_panic>
  802a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	74 10                	je     802a27 <alloc_block_NF+0x326>
  802a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a1f:	8b 52 04             	mov    0x4(%edx),%edx
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	eb 0b                	jmp    802a32 <alloc_block_NF+0x331>
  802a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2a:	8b 40 04             	mov    0x4(%eax),%eax
  802a2d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	74 0f                	je     802a4b <alloc_block_NF+0x34a>
  802a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a45:	8b 12                	mov    (%edx),%edx
  802a47:	89 10                	mov    %edx,(%eax)
  802a49:	eb 0a                	jmp    802a55 <alloc_block_NF+0x354>
  802a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	a3 48 51 80 00       	mov    %eax,0x805148
  802a55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a68:	a1 54 51 80 00       	mov    0x805154,%eax
  802a6d:	48                   	dec    %eax
  802a6e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a76:	8b 40 08             	mov    0x8(%eax),%eax
  802a79:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 50 08             	mov    0x8(%eax),%edx
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	01 c2                	add    %eax,%edx
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 40 0c             	mov    0xc(%eax),%eax
  802a95:	2b 45 08             	sub    0x8(%ebp),%eax
  802a98:	89 c2                	mov    %eax,%edx
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802aa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa3:	e9 24 02 00 00       	jmp    802ccc <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa8:	a1 40 51 80 00       	mov    0x805140,%eax
  802aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab4:	74 07                	je     802abd <alloc_block_NF+0x3bc>
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 00                	mov    (%eax),%eax
  802abb:	eb 05                	jmp    802ac2 <alloc_block_NF+0x3c1>
  802abd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac2:	a3 40 51 80 00       	mov    %eax,0x805140
  802ac7:	a1 40 51 80 00       	mov    0x805140,%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	0f 85 2b fe ff ff    	jne    8028ff <alloc_block_NF+0x1fe>
  802ad4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad8:	0f 85 21 fe ff ff    	jne    8028ff <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ade:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae6:	e9 ae 01 00 00       	jmp    802c99 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 50 08             	mov    0x8(%eax),%edx
  802af1:	a1 28 50 80 00       	mov    0x805028,%eax
  802af6:	39 c2                	cmp    %eax,%edx
  802af8:	0f 83 93 01 00 00    	jae    802c91 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 0c             	mov    0xc(%eax),%eax
  802b04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b07:	0f 82 84 01 00 00    	jb     802c91 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 40 0c             	mov    0xc(%eax),%eax
  802b13:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b16:	0f 85 95 00 00 00    	jne    802bb1 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b20:	75 17                	jne    802b39 <alloc_block_NF+0x438>
  802b22:	83 ec 04             	sub    $0x4,%esp
  802b25:	68 38 44 80 00       	push   $0x804438
  802b2a:	68 14 01 00 00       	push   $0x114
  802b2f:	68 8f 43 80 00       	push   $0x80438f
  802b34:	e8 c3 d8 ff ff       	call   8003fc <_panic>
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	74 10                	je     802b52 <alloc_block_NF+0x451>
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4a:	8b 52 04             	mov    0x4(%edx),%edx
  802b4d:	89 50 04             	mov    %edx,0x4(%eax)
  802b50:	eb 0b                	jmp    802b5d <alloc_block_NF+0x45c>
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 40 04             	mov    0x4(%eax),%eax
  802b58:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 40 04             	mov    0x4(%eax),%eax
  802b63:	85 c0                	test   %eax,%eax
  802b65:	74 0f                	je     802b76 <alloc_block_NF+0x475>
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 40 04             	mov    0x4(%eax),%eax
  802b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b70:	8b 12                	mov    (%edx),%edx
  802b72:	89 10                	mov    %edx,(%eax)
  802b74:	eb 0a                	jmp    802b80 <alloc_block_NF+0x47f>
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	a3 38 51 80 00       	mov    %eax,0x805138
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b93:	a1 44 51 80 00       	mov    0x805144,%eax
  802b98:	48                   	dec    %eax
  802b99:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 08             	mov    0x8(%eax),%eax
  802ba4:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	e9 1b 01 00 00       	jmp    802ccc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bba:	0f 86 d1 00 00 00    	jbe    802c91 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bc0:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 50 08             	mov    0x8(%eax),%edx
  802bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  802bda:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bdd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802be1:	75 17                	jne    802bfa <alloc_block_NF+0x4f9>
  802be3:	83 ec 04             	sub    $0x4,%esp
  802be6:	68 38 44 80 00       	push   $0x804438
  802beb:	68 1c 01 00 00       	push   $0x11c
  802bf0:	68 8f 43 80 00       	push   $0x80438f
  802bf5:	e8 02 d8 ff ff       	call   8003fc <_panic>
  802bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	85 c0                	test   %eax,%eax
  802c01:	74 10                	je     802c13 <alloc_block_NF+0x512>
  802c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c0b:	8b 52 04             	mov    0x4(%edx),%edx
  802c0e:	89 50 04             	mov    %edx,0x4(%eax)
  802c11:	eb 0b                	jmp    802c1e <alloc_block_NF+0x51d>
  802c13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c16:	8b 40 04             	mov    0x4(%eax),%eax
  802c19:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 0f                	je     802c37 <alloc_block_NF+0x536>
  802c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2b:	8b 40 04             	mov    0x4(%eax),%eax
  802c2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c31:	8b 12                	mov    (%edx),%edx
  802c33:	89 10                	mov    %edx,(%eax)
  802c35:	eb 0a                	jmp    802c41 <alloc_block_NF+0x540>
  802c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	a3 48 51 80 00       	mov    %eax,0x805148
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c54:	a1 54 51 80 00       	mov    0x805154,%eax
  802c59:	48                   	dec    %eax
  802c5a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c62:	8b 40 08             	mov    0x8(%eax),%eax
  802c65:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	8b 50 08             	mov    0x8(%eax),%edx
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	01 c2                	add    %eax,%edx
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c81:	2b 45 08             	sub    0x8(%ebp),%eax
  802c84:	89 c2                	mov    %eax,%edx
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8f:	eb 3b                	jmp    802ccc <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c91:	a1 40 51 80 00       	mov    0x805140,%eax
  802c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9d:	74 07                	je     802ca6 <alloc_block_NF+0x5a5>
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 00                	mov    (%eax),%eax
  802ca4:	eb 05                	jmp    802cab <alloc_block_NF+0x5aa>
  802ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cab:	a3 40 51 80 00       	mov    %eax,0x805140
  802cb0:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	0f 85 2e fe ff ff    	jne    802aeb <alloc_block_NF+0x3ea>
  802cbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc1:	0f 85 24 fe ff ff    	jne    802aeb <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ccc:	c9                   	leave  
  802ccd:	c3                   	ret    

00802cce <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cce:	55                   	push   %ebp
  802ccf:	89 e5                	mov    %esp,%ebp
  802cd1:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cd4:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cdc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ce1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ce4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 14                	je     802d01 <insert_sorted_with_merge_freeList+0x33>
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	8b 50 08             	mov    0x8(%eax),%edx
  802cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf6:	8b 40 08             	mov    0x8(%eax),%eax
  802cf9:	39 c2                	cmp    %eax,%edx
  802cfb:	0f 87 9b 01 00 00    	ja     802e9c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d05:	75 17                	jne    802d1e <insert_sorted_with_merge_freeList+0x50>
  802d07:	83 ec 04             	sub    $0x4,%esp
  802d0a:	68 6c 43 80 00       	push   $0x80436c
  802d0f:	68 38 01 00 00       	push   $0x138
  802d14:	68 8f 43 80 00       	push   $0x80438f
  802d19:	e8 de d6 ff ff       	call   8003fc <_panic>
  802d1e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	89 10                	mov    %edx,(%eax)
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	85 c0                	test   %eax,%eax
  802d30:	74 0d                	je     802d3f <insert_sorted_with_merge_freeList+0x71>
  802d32:	a1 38 51 80 00       	mov    0x805138,%eax
  802d37:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3a:	89 50 04             	mov    %edx,0x4(%eax)
  802d3d:	eb 08                	jmp    802d47 <insert_sorted_with_merge_freeList+0x79>
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	a3 38 51 80 00       	mov    %eax,0x805138
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d59:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5e:	40                   	inc    %eax
  802d5f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d68:	0f 84 a8 06 00 00    	je     803416 <insert_sorted_with_merge_freeList+0x748>
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	8b 50 08             	mov    0x8(%eax),%edx
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7a:	01 c2                	add    %eax,%edx
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	8b 40 08             	mov    0x8(%eax),%eax
  802d82:	39 c2                	cmp    %eax,%edx
  802d84:	0f 85 8c 06 00 00    	jne    803416 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 40 0c             	mov    0xc(%eax),%eax
  802d96:	01 c2                	add    %eax,%edx
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da2:	75 17                	jne    802dbb <insert_sorted_with_merge_freeList+0xed>
  802da4:	83 ec 04             	sub    $0x4,%esp
  802da7:	68 38 44 80 00       	push   $0x804438
  802dac:	68 3c 01 00 00       	push   $0x13c
  802db1:	68 8f 43 80 00       	push   $0x80438f
  802db6:	e8 41 d6 ff ff       	call   8003fc <_panic>
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	8b 00                	mov    (%eax),%eax
  802dc0:	85 c0                	test   %eax,%eax
  802dc2:	74 10                	je     802dd4 <insert_sorted_with_merge_freeList+0x106>
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcc:	8b 52 04             	mov    0x4(%edx),%edx
  802dcf:	89 50 04             	mov    %edx,0x4(%eax)
  802dd2:	eb 0b                	jmp    802ddf <insert_sorted_with_merge_freeList+0x111>
  802dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd7:	8b 40 04             	mov    0x4(%eax),%eax
  802dda:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de2:	8b 40 04             	mov    0x4(%eax),%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	74 0f                	je     802df8 <insert_sorted_with_merge_freeList+0x12a>
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 40 04             	mov    0x4(%eax),%eax
  802def:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df2:	8b 12                	mov    (%edx),%edx
  802df4:	89 10                	mov    %edx,(%eax)
  802df6:	eb 0a                	jmp    802e02 <insert_sorted_with_merge_freeList+0x134>
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	a3 38 51 80 00       	mov    %eax,0x805138
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e15:	a1 44 51 80 00       	mov    0x805144,%eax
  802e1a:	48                   	dec    %eax
  802e1b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e38:	75 17                	jne    802e51 <insert_sorted_with_merge_freeList+0x183>
  802e3a:	83 ec 04             	sub    $0x4,%esp
  802e3d:	68 6c 43 80 00       	push   $0x80436c
  802e42:	68 3f 01 00 00       	push   $0x13f
  802e47:	68 8f 43 80 00       	push   $0x80438f
  802e4c:	e8 ab d5 ff ff       	call   8003fc <_panic>
  802e51:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5a:	89 10                	mov    %edx,(%eax)
  802e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	74 0d                	je     802e72 <insert_sorted_with_merge_freeList+0x1a4>
  802e65:	a1 48 51 80 00       	mov    0x805148,%eax
  802e6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e6d:	89 50 04             	mov    %edx,0x4(%eax)
  802e70:	eb 08                	jmp    802e7a <insert_sorted_with_merge_freeList+0x1ac>
  802e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e75:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	a3 48 51 80 00       	mov    %eax,0x805148
  802e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8c:	a1 54 51 80 00       	mov    0x805154,%eax
  802e91:	40                   	inc    %eax
  802e92:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e97:	e9 7a 05 00 00       	jmp    803416 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	8b 50 08             	mov    0x8(%eax),%edx
  802ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea5:	8b 40 08             	mov    0x8(%eax),%eax
  802ea8:	39 c2                	cmp    %eax,%edx
  802eaa:	0f 82 14 01 00 00    	jb     802fc4 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb3:	8b 50 08             	mov    0x8(%eax),%edx
  802eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebc:	01 c2                	add    %eax,%edx
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	8b 40 08             	mov    0x8(%eax),%eax
  802ec4:	39 c2                	cmp    %eax,%edx
  802ec6:	0f 85 90 00 00 00    	jne    802f5c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	01 c2                	add    %eax,%edx
  802eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edd:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ef4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef8:	75 17                	jne    802f11 <insert_sorted_with_merge_freeList+0x243>
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	68 6c 43 80 00       	push   $0x80436c
  802f02:	68 49 01 00 00       	push   $0x149
  802f07:	68 8f 43 80 00       	push   $0x80438f
  802f0c:	e8 eb d4 ff ff       	call   8003fc <_panic>
  802f11:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	89 10                	mov    %edx,(%eax)
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	74 0d                	je     802f32 <insert_sorted_with_merge_freeList+0x264>
  802f25:	a1 48 51 80 00       	mov    0x805148,%eax
  802f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	eb 08                	jmp    802f3a <insert_sorted_with_merge_freeList+0x26c>
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	a3 48 51 80 00       	mov    %eax,0x805148
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4c:	a1 54 51 80 00       	mov    0x805154,%eax
  802f51:	40                   	inc    %eax
  802f52:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f57:	e9 bb 04 00 00       	jmp    803417 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f60:	75 17                	jne    802f79 <insert_sorted_with_merge_freeList+0x2ab>
  802f62:	83 ec 04             	sub    $0x4,%esp
  802f65:	68 e0 43 80 00       	push   $0x8043e0
  802f6a:	68 4c 01 00 00       	push   $0x14c
  802f6f:	68 8f 43 80 00       	push   $0x80438f
  802f74:	e8 83 d4 ff ff       	call   8003fc <_panic>
  802f79:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	89 50 04             	mov    %edx,0x4(%eax)
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	8b 40 04             	mov    0x4(%eax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	74 0c                	je     802f9b <insert_sorted_with_merge_freeList+0x2cd>
  802f8f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f94:	8b 55 08             	mov    0x8(%ebp),%edx
  802f97:	89 10                	mov    %edx,(%eax)
  802f99:	eb 08                	jmp    802fa3 <insert_sorted_with_merge_freeList+0x2d5>
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	a3 38 51 80 00       	mov    %eax,0x805138
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb4:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb9:	40                   	inc    %eax
  802fba:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fbf:	e9 53 04 00 00       	jmp    803417 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fc4:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcc:	e9 15 04 00 00       	jmp    8033e6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	8b 50 08             	mov    0x8(%eax),%edx
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 40 08             	mov    0x8(%eax),%eax
  802fe5:	39 c2                	cmp    %eax,%edx
  802fe7:	0f 86 f1 03 00 00    	jbe    8033de <insert_sorted_with_merge_freeList+0x710>
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	8b 50 08             	mov    0x8(%eax),%edx
  802ff3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff6:	8b 40 08             	mov    0x8(%eax),%eax
  802ff9:	39 c2                	cmp    %eax,%edx
  802ffb:	0f 83 dd 03 00 00    	jae    8033de <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 50 08             	mov    0x8(%eax),%edx
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 40 0c             	mov    0xc(%eax),%eax
  80300d:	01 c2                	add    %eax,%edx
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	8b 40 08             	mov    0x8(%eax),%eax
  803015:	39 c2                	cmp    %eax,%edx
  803017:	0f 85 b9 01 00 00    	jne    8031d6 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	8b 50 08             	mov    0x8(%eax),%edx
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	8b 40 0c             	mov    0xc(%eax),%eax
  803029:	01 c2                	add    %eax,%edx
  80302b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302e:	8b 40 08             	mov    0x8(%eax),%eax
  803031:	39 c2                	cmp    %eax,%edx
  803033:	0f 85 0d 01 00 00    	jne    803146 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	8b 50 0c             	mov    0xc(%eax),%edx
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	8b 40 0c             	mov    0xc(%eax),%eax
  803045:	01 c2                	add    %eax,%edx
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80304d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803051:	75 17                	jne    80306a <insert_sorted_with_merge_freeList+0x39c>
  803053:	83 ec 04             	sub    $0x4,%esp
  803056:	68 38 44 80 00       	push   $0x804438
  80305b:	68 5c 01 00 00       	push   $0x15c
  803060:	68 8f 43 80 00       	push   $0x80438f
  803065:	e8 92 d3 ff ff       	call   8003fc <_panic>
  80306a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	74 10                	je     803083 <insert_sorted_with_merge_freeList+0x3b5>
  803073:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307b:	8b 52 04             	mov    0x4(%edx),%edx
  80307e:	89 50 04             	mov    %edx,0x4(%eax)
  803081:	eb 0b                	jmp    80308e <insert_sorted_with_merge_freeList+0x3c0>
  803083:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803086:	8b 40 04             	mov    0x4(%eax),%eax
  803089:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80308e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803091:	8b 40 04             	mov    0x4(%eax),%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	74 0f                	je     8030a7 <insert_sorted_with_merge_freeList+0x3d9>
  803098:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309b:	8b 40 04             	mov    0x4(%eax),%eax
  80309e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a1:	8b 12                	mov    (%edx),%edx
  8030a3:	89 10                	mov    %edx,(%eax)
  8030a5:	eb 0a                	jmp    8030b1 <insert_sorted_with_merge_freeList+0x3e3>
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c9:	48                   	dec    %eax
  8030ca:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e7:	75 17                	jne    803100 <insert_sorted_with_merge_freeList+0x432>
  8030e9:	83 ec 04             	sub    $0x4,%esp
  8030ec:	68 6c 43 80 00       	push   $0x80436c
  8030f1:	68 5f 01 00 00       	push   $0x15f
  8030f6:	68 8f 43 80 00       	push   $0x80438f
  8030fb:	e8 fc d2 ff ff       	call   8003fc <_panic>
  803100:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	89 10                	mov    %edx,(%eax)
  80310b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	85 c0                	test   %eax,%eax
  803112:	74 0d                	je     803121 <insert_sorted_with_merge_freeList+0x453>
  803114:	a1 48 51 80 00       	mov    0x805148,%eax
  803119:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80311c:	89 50 04             	mov    %edx,0x4(%eax)
  80311f:	eb 08                	jmp    803129 <insert_sorted_with_merge_freeList+0x45b>
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	a3 48 51 80 00       	mov    %eax,0x805148
  803131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803134:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313b:	a1 54 51 80 00       	mov    0x805154,%eax
  803140:	40                   	inc    %eax
  803141:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803149:	8b 50 0c             	mov    0xc(%eax),%edx
  80314c:	8b 45 08             	mov    0x8(%ebp),%eax
  80314f:	8b 40 0c             	mov    0xc(%eax),%eax
  803152:	01 c2                	add    %eax,%edx
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80316e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803172:	75 17                	jne    80318b <insert_sorted_with_merge_freeList+0x4bd>
  803174:	83 ec 04             	sub    $0x4,%esp
  803177:	68 6c 43 80 00       	push   $0x80436c
  80317c:	68 64 01 00 00       	push   $0x164
  803181:	68 8f 43 80 00       	push   $0x80438f
  803186:	e8 71 d2 ff ff       	call   8003fc <_panic>
  80318b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	89 10                	mov    %edx,(%eax)
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	74 0d                	je     8031ac <insert_sorted_with_merge_freeList+0x4de>
  80319f:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a7:	89 50 04             	mov    %edx,0x4(%eax)
  8031aa:	eb 08                	jmp    8031b4 <insert_sorted_with_merge_freeList+0x4e6>
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031cb:	40                   	inc    %eax
  8031cc:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031d1:	e9 41 02 00 00       	jmp    803417 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d9:	8b 50 08             	mov    0x8(%eax),%edx
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e2:	01 c2                	add    %eax,%edx
  8031e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e7:	8b 40 08             	mov    0x8(%eax),%eax
  8031ea:	39 c2                	cmp    %eax,%edx
  8031ec:	0f 85 7c 01 00 00    	jne    80336e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f6:	74 06                	je     8031fe <insert_sorted_with_merge_freeList+0x530>
  8031f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fc:	75 17                	jne    803215 <insert_sorted_with_merge_freeList+0x547>
  8031fe:	83 ec 04             	sub    $0x4,%esp
  803201:	68 a8 43 80 00       	push   $0x8043a8
  803206:	68 69 01 00 00       	push   $0x169
  80320b:	68 8f 43 80 00       	push   $0x80438f
  803210:	e8 e7 d1 ff ff       	call   8003fc <_panic>
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	8b 50 04             	mov    0x4(%eax),%edx
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	89 50 04             	mov    %edx,0x4(%eax)
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803227:	89 10                	mov    %edx,(%eax)
  803229:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	85 c0                	test   %eax,%eax
  803231:	74 0d                	je     803240 <insert_sorted_with_merge_freeList+0x572>
  803233:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803236:	8b 40 04             	mov    0x4(%eax),%eax
  803239:	8b 55 08             	mov    0x8(%ebp),%edx
  80323c:	89 10                	mov    %edx,(%eax)
  80323e:	eb 08                	jmp    803248 <insert_sorted_with_merge_freeList+0x57a>
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	a3 38 51 80 00       	mov    %eax,0x805138
  803248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324b:	8b 55 08             	mov    0x8(%ebp),%edx
  80324e:	89 50 04             	mov    %edx,0x4(%eax)
  803251:	a1 44 51 80 00       	mov    0x805144,%eax
  803256:	40                   	inc    %eax
  803257:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 50 0c             	mov    0xc(%eax),%edx
  803262:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803265:	8b 40 0c             	mov    0xc(%eax),%eax
  803268:	01 c2                	add    %eax,%edx
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803270:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803274:	75 17                	jne    80328d <insert_sorted_with_merge_freeList+0x5bf>
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	68 38 44 80 00       	push   $0x804438
  80327e:	68 6b 01 00 00       	push   $0x16b
  803283:	68 8f 43 80 00       	push   $0x80438f
  803288:	e8 6f d1 ff ff       	call   8003fc <_panic>
  80328d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803290:	8b 00                	mov    (%eax),%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	74 10                	je     8032a6 <insert_sorted_with_merge_freeList+0x5d8>
  803296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803299:	8b 00                	mov    (%eax),%eax
  80329b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329e:	8b 52 04             	mov    0x4(%edx),%edx
  8032a1:	89 50 04             	mov    %edx,0x4(%eax)
  8032a4:	eb 0b                	jmp    8032b1 <insert_sorted_with_merge_freeList+0x5e3>
  8032a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b4:	8b 40 04             	mov    0x4(%eax),%eax
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	74 0f                	je     8032ca <insert_sorted_with_merge_freeList+0x5fc>
  8032bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032be:	8b 40 04             	mov    0x4(%eax),%eax
  8032c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c4:	8b 12                	mov    (%edx),%edx
  8032c6:	89 10                	mov    %edx,(%eax)
  8032c8:	eb 0a                	jmp    8032d4 <insert_sorted_with_merge_freeList+0x606>
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 00                	mov    (%eax),%eax
  8032cf:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ec:	48                   	dec    %eax
  8032ed:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803306:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80330a:	75 17                	jne    803323 <insert_sorted_with_merge_freeList+0x655>
  80330c:	83 ec 04             	sub    $0x4,%esp
  80330f:	68 6c 43 80 00       	push   $0x80436c
  803314:	68 6e 01 00 00       	push   $0x16e
  803319:	68 8f 43 80 00       	push   $0x80438f
  80331e:	e8 d9 d0 ff ff       	call   8003fc <_panic>
  803323:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	89 10                	mov    %edx,(%eax)
  80332e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803331:	8b 00                	mov    (%eax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	74 0d                	je     803344 <insert_sorted_with_merge_freeList+0x676>
  803337:	a1 48 51 80 00       	mov    0x805148,%eax
  80333c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333f:	89 50 04             	mov    %edx,0x4(%eax)
  803342:	eb 08                	jmp    80334c <insert_sorted_with_merge_freeList+0x67e>
  803344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803347:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	a3 48 51 80 00       	mov    %eax,0x805148
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335e:	a1 54 51 80 00       	mov    0x805154,%eax
  803363:	40                   	inc    %eax
  803364:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803369:	e9 a9 00 00 00       	jmp    803417 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80336e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803372:	74 06                	je     80337a <insert_sorted_with_merge_freeList+0x6ac>
  803374:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803378:	75 17                	jne    803391 <insert_sorted_with_merge_freeList+0x6c3>
  80337a:	83 ec 04             	sub    $0x4,%esp
  80337d:	68 04 44 80 00       	push   $0x804404
  803382:	68 73 01 00 00       	push   $0x173
  803387:	68 8f 43 80 00       	push   $0x80438f
  80338c:	e8 6b d0 ff ff       	call   8003fc <_panic>
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	8b 10                	mov    (%eax),%edx
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	89 10                	mov    %edx,(%eax)
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	8b 00                	mov    (%eax),%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	74 0b                	je     8033af <insert_sorted_with_merge_freeList+0x6e1>
  8033a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a7:	8b 00                	mov    (%eax),%eax
  8033a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ac:	89 50 04             	mov    %edx,0x4(%eax)
  8033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b5:	89 10                	mov    %edx,(%eax)
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033bd:	89 50 04             	mov    %edx,0x4(%eax)
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	85 c0                	test   %eax,%eax
  8033c7:	75 08                	jne    8033d1 <insert_sorted_with_merge_freeList+0x703>
  8033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d6:	40                   	inc    %eax
  8033d7:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033dc:	eb 39                	jmp    803417 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033de:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ea:	74 07                	je     8033f3 <insert_sorted_with_merge_freeList+0x725>
  8033ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ef:	8b 00                	mov    (%eax),%eax
  8033f1:	eb 05                	jmp    8033f8 <insert_sorted_with_merge_freeList+0x72a>
  8033f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8033fd:	a1 40 51 80 00       	mov    0x805140,%eax
  803402:	85 c0                	test   %eax,%eax
  803404:	0f 85 c7 fb ff ff    	jne    802fd1 <insert_sorted_with_merge_freeList+0x303>
  80340a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340e:	0f 85 bd fb ff ff    	jne    802fd1 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803414:	eb 01                	jmp    803417 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803416:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803417:	90                   	nop
  803418:	c9                   	leave  
  803419:	c3                   	ret    
  80341a:	66 90                	xchg   %ax,%ax

0080341c <__udivdi3>:
  80341c:	55                   	push   %ebp
  80341d:	57                   	push   %edi
  80341e:	56                   	push   %esi
  80341f:	53                   	push   %ebx
  803420:	83 ec 1c             	sub    $0x1c,%esp
  803423:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803427:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80342b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803433:	89 ca                	mov    %ecx,%edx
  803435:	89 f8                	mov    %edi,%eax
  803437:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80343b:	85 f6                	test   %esi,%esi
  80343d:	75 2d                	jne    80346c <__udivdi3+0x50>
  80343f:	39 cf                	cmp    %ecx,%edi
  803441:	77 65                	ja     8034a8 <__udivdi3+0x8c>
  803443:	89 fd                	mov    %edi,%ebp
  803445:	85 ff                	test   %edi,%edi
  803447:	75 0b                	jne    803454 <__udivdi3+0x38>
  803449:	b8 01 00 00 00       	mov    $0x1,%eax
  80344e:	31 d2                	xor    %edx,%edx
  803450:	f7 f7                	div    %edi
  803452:	89 c5                	mov    %eax,%ebp
  803454:	31 d2                	xor    %edx,%edx
  803456:	89 c8                	mov    %ecx,%eax
  803458:	f7 f5                	div    %ebp
  80345a:	89 c1                	mov    %eax,%ecx
  80345c:	89 d8                	mov    %ebx,%eax
  80345e:	f7 f5                	div    %ebp
  803460:	89 cf                	mov    %ecx,%edi
  803462:	89 fa                	mov    %edi,%edx
  803464:	83 c4 1c             	add    $0x1c,%esp
  803467:	5b                   	pop    %ebx
  803468:	5e                   	pop    %esi
  803469:	5f                   	pop    %edi
  80346a:	5d                   	pop    %ebp
  80346b:	c3                   	ret    
  80346c:	39 ce                	cmp    %ecx,%esi
  80346e:	77 28                	ja     803498 <__udivdi3+0x7c>
  803470:	0f bd fe             	bsr    %esi,%edi
  803473:	83 f7 1f             	xor    $0x1f,%edi
  803476:	75 40                	jne    8034b8 <__udivdi3+0x9c>
  803478:	39 ce                	cmp    %ecx,%esi
  80347a:	72 0a                	jb     803486 <__udivdi3+0x6a>
  80347c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803480:	0f 87 9e 00 00 00    	ja     803524 <__udivdi3+0x108>
  803486:	b8 01 00 00 00       	mov    $0x1,%eax
  80348b:	89 fa                	mov    %edi,%edx
  80348d:	83 c4 1c             	add    $0x1c,%esp
  803490:	5b                   	pop    %ebx
  803491:	5e                   	pop    %esi
  803492:	5f                   	pop    %edi
  803493:	5d                   	pop    %ebp
  803494:	c3                   	ret    
  803495:	8d 76 00             	lea    0x0(%esi),%esi
  803498:	31 ff                	xor    %edi,%edi
  80349a:	31 c0                	xor    %eax,%eax
  80349c:	89 fa                	mov    %edi,%edx
  80349e:	83 c4 1c             	add    $0x1c,%esp
  8034a1:	5b                   	pop    %ebx
  8034a2:	5e                   	pop    %esi
  8034a3:	5f                   	pop    %edi
  8034a4:	5d                   	pop    %ebp
  8034a5:	c3                   	ret    
  8034a6:	66 90                	xchg   %ax,%ax
  8034a8:	89 d8                	mov    %ebx,%eax
  8034aa:	f7 f7                	div    %edi
  8034ac:	31 ff                	xor    %edi,%edi
  8034ae:	89 fa                	mov    %edi,%edx
  8034b0:	83 c4 1c             	add    $0x1c,%esp
  8034b3:	5b                   	pop    %ebx
  8034b4:	5e                   	pop    %esi
  8034b5:	5f                   	pop    %edi
  8034b6:	5d                   	pop    %ebp
  8034b7:	c3                   	ret    
  8034b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034bd:	89 eb                	mov    %ebp,%ebx
  8034bf:	29 fb                	sub    %edi,%ebx
  8034c1:	89 f9                	mov    %edi,%ecx
  8034c3:	d3 e6                	shl    %cl,%esi
  8034c5:	89 c5                	mov    %eax,%ebp
  8034c7:	88 d9                	mov    %bl,%cl
  8034c9:	d3 ed                	shr    %cl,%ebp
  8034cb:	89 e9                	mov    %ebp,%ecx
  8034cd:	09 f1                	or     %esi,%ecx
  8034cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034d3:	89 f9                	mov    %edi,%ecx
  8034d5:	d3 e0                	shl    %cl,%eax
  8034d7:	89 c5                	mov    %eax,%ebp
  8034d9:	89 d6                	mov    %edx,%esi
  8034db:	88 d9                	mov    %bl,%cl
  8034dd:	d3 ee                	shr    %cl,%esi
  8034df:	89 f9                	mov    %edi,%ecx
  8034e1:	d3 e2                	shl    %cl,%edx
  8034e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e7:	88 d9                	mov    %bl,%cl
  8034e9:	d3 e8                	shr    %cl,%eax
  8034eb:	09 c2                	or     %eax,%edx
  8034ed:	89 d0                	mov    %edx,%eax
  8034ef:	89 f2                	mov    %esi,%edx
  8034f1:	f7 74 24 0c          	divl   0xc(%esp)
  8034f5:	89 d6                	mov    %edx,%esi
  8034f7:	89 c3                	mov    %eax,%ebx
  8034f9:	f7 e5                	mul    %ebp
  8034fb:	39 d6                	cmp    %edx,%esi
  8034fd:	72 19                	jb     803518 <__udivdi3+0xfc>
  8034ff:	74 0b                	je     80350c <__udivdi3+0xf0>
  803501:	89 d8                	mov    %ebx,%eax
  803503:	31 ff                	xor    %edi,%edi
  803505:	e9 58 ff ff ff       	jmp    803462 <__udivdi3+0x46>
  80350a:	66 90                	xchg   %ax,%ax
  80350c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803510:	89 f9                	mov    %edi,%ecx
  803512:	d3 e2                	shl    %cl,%edx
  803514:	39 c2                	cmp    %eax,%edx
  803516:	73 e9                	jae    803501 <__udivdi3+0xe5>
  803518:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80351b:	31 ff                	xor    %edi,%edi
  80351d:	e9 40 ff ff ff       	jmp    803462 <__udivdi3+0x46>
  803522:	66 90                	xchg   %ax,%ax
  803524:	31 c0                	xor    %eax,%eax
  803526:	e9 37 ff ff ff       	jmp    803462 <__udivdi3+0x46>
  80352b:	90                   	nop

0080352c <__umoddi3>:
  80352c:	55                   	push   %ebp
  80352d:	57                   	push   %edi
  80352e:	56                   	push   %esi
  80352f:	53                   	push   %ebx
  803530:	83 ec 1c             	sub    $0x1c,%esp
  803533:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803537:	8b 74 24 34          	mov    0x34(%esp),%esi
  80353b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80353f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803543:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803547:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80354b:	89 f3                	mov    %esi,%ebx
  80354d:	89 fa                	mov    %edi,%edx
  80354f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803553:	89 34 24             	mov    %esi,(%esp)
  803556:	85 c0                	test   %eax,%eax
  803558:	75 1a                	jne    803574 <__umoddi3+0x48>
  80355a:	39 f7                	cmp    %esi,%edi
  80355c:	0f 86 a2 00 00 00    	jbe    803604 <__umoddi3+0xd8>
  803562:	89 c8                	mov    %ecx,%eax
  803564:	89 f2                	mov    %esi,%edx
  803566:	f7 f7                	div    %edi
  803568:	89 d0                	mov    %edx,%eax
  80356a:	31 d2                	xor    %edx,%edx
  80356c:	83 c4 1c             	add    $0x1c,%esp
  80356f:	5b                   	pop    %ebx
  803570:	5e                   	pop    %esi
  803571:	5f                   	pop    %edi
  803572:	5d                   	pop    %ebp
  803573:	c3                   	ret    
  803574:	39 f0                	cmp    %esi,%eax
  803576:	0f 87 ac 00 00 00    	ja     803628 <__umoddi3+0xfc>
  80357c:	0f bd e8             	bsr    %eax,%ebp
  80357f:	83 f5 1f             	xor    $0x1f,%ebp
  803582:	0f 84 ac 00 00 00    	je     803634 <__umoddi3+0x108>
  803588:	bf 20 00 00 00       	mov    $0x20,%edi
  80358d:	29 ef                	sub    %ebp,%edi
  80358f:	89 fe                	mov    %edi,%esi
  803591:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803595:	89 e9                	mov    %ebp,%ecx
  803597:	d3 e0                	shl    %cl,%eax
  803599:	89 d7                	mov    %edx,%edi
  80359b:	89 f1                	mov    %esi,%ecx
  80359d:	d3 ef                	shr    %cl,%edi
  80359f:	09 c7                	or     %eax,%edi
  8035a1:	89 e9                	mov    %ebp,%ecx
  8035a3:	d3 e2                	shl    %cl,%edx
  8035a5:	89 14 24             	mov    %edx,(%esp)
  8035a8:	89 d8                	mov    %ebx,%eax
  8035aa:	d3 e0                	shl    %cl,%eax
  8035ac:	89 c2                	mov    %eax,%edx
  8035ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b2:	d3 e0                	shl    %cl,%eax
  8035b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035bc:	89 f1                	mov    %esi,%ecx
  8035be:	d3 e8                	shr    %cl,%eax
  8035c0:	09 d0                	or     %edx,%eax
  8035c2:	d3 eb                	shr    %cl,%ebx
  8035c4:	89 da                	mov    %ebx,%edx
  8035c6:	f7 f7                	div    %edi
  8035c8:	89 d3                	mov    %edx,%ebx
  8035ca:	f7 24 24             	mull   (%esp)
  8035cd:	89 c6                	mov    %eax,%esi
  8035cf:	89 d1                	mov    %edx,%ecx
  8035d1:	39 d3                	cmp    %edx,%ebx
  8035d3:	0f 82 87 00 00 00    	jb     803660 <__umoddi3+0x134>
  8035d9:	0f 84 91 00 00 00    	je     803670 <__umoddi3+0x144>
  8035df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035e3:	29 f2                	sub    %esi,%edx
  8035e5:	19 cb                	sbb    %ecx,%ebx
  8035e7:	89 d8                	mov    %ebx,%eax
  8035e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035ed:	d3 e0                	shl    %cl,%eax
  8035ef:	89 e9                	mov    %ebp,%ecx
  8035f1:	d3 ea                	shr    %cl,%edx
  8035f3:	09 d0                	or     %edx,%eax
  8035f5:	89 e9                	mov    %ebp,%ecx
  8035f7:	d3 eb                	shr    %cl,%ebx
  8035f9:	89 da                	mov    %ebx,%edx
  8035fb:	83 c4 1c             	add    $0x1c,%esp
  8035fe:	5b                   	pop    %ebx
  8035ff:	5e                   	pop    %esi
  803600:	5f                   	pop    %edi
  803601:	5d                   	pop    %ebp
  803602:	c3                   	ret    
  803603:	90                   	nop
  803604:	89 fd                	mov    %edi,%ebp
  803606:	85 ff                	test   %edi,%edi
  803608:	75 0b                	jne    803615 <__umoddi3+0xe9>
  80360a:	b8 01 00 00 00       	mov    $0x1,%eax
  80360f:	31 d2                	xor    %edx,%edx
  803611:	f7 f7                	div    %edi
  803613:	89 c5                	mov    %eax,%ebp
  803615:	89 f0                	mov    %esi,%eax
  803617:	31 d2                	xor    %edx,%edx
  803619:	f7 f5                	div    %ebp
  80361b:	89 c8                	mov    %ecx,%eax
  80361d:	f7 f5                	div    %ebp
  80361f:	89 d0                	mov    %edx,%eax
  803621:	e9 44 ff ff ff       	jmp    80356a <__umoddi3+0x3e>
  803626:	66 90                	xchg   %ax,%ax
  803628:	89 c8                	mov    %ecx,%eax
  80362a:	89 f2                	mov    %esi,%edx
  80362c:	83 c4 1c             	add    $0x1c,%esp
  80362f:	5b                   	pop    %ebx
  803630:	5e                   	pop    %esi
  803631:	5f                   	pop    %edi
  803632:	5d                   	pop    %ebp
  803633:	c3                   	ret    
  803634:	3b 04 24             	cmp    (%esp),%eax
  803637:	72 06                	jb     80363f <__umoddi3+0x113>
  803639:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80363d:	77 0f                	ja     80364e <__umoddi3+0x122>
  80363f:	89 f2                	mov    %esi,%edx
  803641:	29 f9                	sub    %edi,%ecx
  803643:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803647:	89 14 24             	mov    %edx,(%esp)
  80364a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80364e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803652:	8b 14 24             	mov    (%esp),%edx
  803655:	83 c4 1c             	add    $0x1c,%esp
  803658:	5b                   	pop    %ebx
  803659:	5e                   	pop    %esi
  80365a:	5f                   	pop    %edi
  80365b:	5d                   	pop    %ebp
  80365c:	c3                   	ret    
  80365d:	8d 76 00             	lea    0x0(%esi),%esi
  803660:	2b 04 24             	sub    (%esp),%eax
  803663:	19 fa                	sbb    %edi,%edx
  803665:	89 d1                	mov    %edx,%ecx
  803667:	89 c6                	mov    %eax,%esi
  803669:	e9 71 ff ff ff       	jmp    8035df <__umoddi3+0xb3>
  80366e:	66 90                	xchg   %ax,%ax
  803670:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803674:	72 ea                	jb     803660 <__umoddi3+0x134>
  803676:	89 d9                	mov    %ebx,%ecx
  803678:	e9 62 ff ff ff       	jmp    8035df <__umoddi3+0xb3>
