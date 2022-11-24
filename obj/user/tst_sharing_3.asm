
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
  800031:	e8 49 02 00 00       	call   80027f <libmain>
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
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
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
  80008c:	68 00 1e 80 00       	push   $0x801e00
  800091:	6a 12                	push   $0x12
  800093:	68 1c 1e 80 00       	push   $0x801e1c
  800098:	e8 1e 03 00 00       	call   8003bb <_panic>
	}
	cprintf("************************************************\n");
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	68 34 1e 80 00       	push   $0x801e34
  8000a5:	e8 c5 05 00 00       	call   80066f <cprintf>
  8000aa:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 68 1e 80 00       	push   $0x801e68
  8000b5:	e8 b5 05 00 00       	call   80066f <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 c4 1e 80 00       	push   $0x801ec4
  8000c5:	e8 a5 05 00 00       	call   80066f <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 f8 1e 80 00       	push   $0x801ef8
  8000d5:	e8 95 05 00 00       	call   80066f <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000dd:	83 ec 04             	sub    $0x4,%esp
  8000e0:	6a 01                	push   $0x1
  8000e2:	68 00 10 00 00       	push   $0x1000
  8000e7:	68 40 1f 80 00       	push   $0x801f40
  8000ec:	e8 7d 13 00 00       	call   80146e <smalloc>
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000f7:	e8 26 15 00 00       	call   801622 <sys_calculate_free_frames>
  8000fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	6a 01                	push   $0x1
  800104:	68 00 10 00 00       	push   $0x1000
  800109:	68 40 1f 80 00       	push   $0x801f40
  80010e:	e8 5b 13 00 00       	call   80146e <smalloc>
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800119:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 44 1f 80 00       	push   $0x801f44
  800127:	6a 20                	push   $0x20
  800129:	68 1c 1e 80 00       	push   $0x801e1c
  80012e:	e8 88 02 00 00       	call   8003bb <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800133:	e8 ea 14 00 00       	call   801622 <sys_calculate_free_frames>
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013d:	39 c2                	cmp    %eax,%edx
  80013f:	74 14                	je     800155 <_main+0x11d>
  800141:	83 ec 04             	sub    $0x4,%esp
  800144:	68 98 1f 80 00       	push   $0x801f98
  800149:	6a 21                	push   $0x21
  80014b:	68 1c 1e 80 00       	push   $0x801e1c
  800150:	e8 66 02 00 00       	call   8003bb <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	68 f4 1f 80 00       	push   $0x801ff4
  80015d:	e8 0d 05 00 00       	call   80066f <cprintf>
  800162:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800165:	e8 b8 14 00 00       	call   801622 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80016d:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800174:	83 ec 04             	sub    $0x4,%esp
  800177:	6a 01                	push   $0x1
  800179:	ff 75 dc             	pushl  -0x24(%ebp)
  80017c:	68 4c 20 80 00       	push   $0x80204c
  800181:	e8 e8 12 00 00       	call   80146e <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  80018c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800190:	74 14                	je     8001a6 <_main+0x16e>
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	68 50 20 80 00       	push   $0x802050
  80019a:	6a 29                	push   $0x29
  80019c:	68 1c 1e 80 00       	push   $0x801e1c
  8001a1:	e8 15 02 00 00       	call   8003bb <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001a6:	e8 77 14 00 00       	call   801622 <sys_calculate_free_frames>
  8001ab:	89 c2                	mov    %eax,%edx
  8001ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b0:	39 c2                	cmp    %eax,%edx
  8001b2:	74 14                	je     8001c8 <_main+0x190>
  8001b4:	83 ec 04             	sub    $0x4,%esp
  8001b7:	68 c4 20 80 00       	push   $0x8020c4
  8001bc:	6a 2a                	push   $0x2a
  8001be:	68 1c 1e 80 00       	push   $0x801e1c
  8001c3:	e8 f3 01 00 00       	call   8003bb <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 38 21 80 00       	push   $0x802138
  8001d0:	e8 9a 04 00 00       	call   80066f <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001d8:	e8 9e 16 00 00       	call   80187b <sys_getMaxShares>
  8001dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001e7:	eb 45                	jmp    80022e <_main+0x1f6>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001e9:	83 ec 08             	sub    $0x8,%esp
  8001ec:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f3:	e8 9f 0f 00 00       	call   801197 <ltostr>
  8001f8:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  8001fb:	83 ec 04             	sub    $0x4,%esp
  8001fe:	6a 01                	push   $0x1
  800200:	6a 01                	push   $0x1
  800202:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  800205:	50                   	push   %eax
  800206:	e8 63 12 00 00       	call   80146e <smalloc>
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  800211:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800215:	75 14                	jne    80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 ac 21 80 00       	push   $0x8021ac
  80021f:	6a 36                	push   $0x36
  800221:	68 1c 1e 80 00       	push   $0x801e1c
  800226:	e8 90 01 00 00       	call   8003bb <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  80022b:	ff 45 ec             	incl   -0x14(%ebp)
  80022e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800231:	8d 50 ff             	lea    -0x1(%eax),%edx
  800234:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800237:	39 c2                	cmp    %eax,%edx
  800239:	77 ae                	ja     8001e9 <_main+0x1b1>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  80023b:	83 ec 04             	sub    $0x4,%esp
  80023e:	6a 01                	push   $0x1
  800240:	6a 01                	push   $0x1
  800242:	68 dc 21 80 00       	push   $0x8021dc
  800247:	e8 22 12 00 00       	call   80146e <smalloc>
  80024c:	83 c4 10             	add    $0x10,%esp
  80024f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (z != NULL) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800252:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800256:	74 14                	je     80026c <_main+0x234>
  800258:	83 ec 04             	sub    $0x4,%esp
  80025b:	68 e8 21 80 00       	push   $0x8021e8
  800260:	6a 39                	push   $0x39
  800262:	68 1c 1e 80 00       	push   $0x801e1c
  800267:	e8 4f 01 00 00       	call   8003bb <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 64 22 80 00       	push   $0x802264
  800274:	e8 f6 03 00 00       	call   80066f <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp

	return;
  80027c:	90                   	nop
}
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800285:	e8 78 16 00 00       	call   801902 <sys_getenvindex>
  80028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80028d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800290:	89 d0                	mov    %edx,%eax
  800292:	c1 e0 03             	shl    $0x3,%eax
  800295:	01 d0                	add    %edx,%eax
  800297:	01 c0                	add    %eax,%eax
  800299:	01 d0                	add    %edx,%eax
  80029b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a2:	01 d0                	add    %edx,%eax
  8002a4:	c1 e0 04             	shl    $0x4,%eax
  8002a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ac:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002bc:	84 c0                	test   %al,%al
  8002be:	74 0f                	je     8002cf <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c5:	05 5c 05 00 00       	add    $0x55c,%eax
  8002ca:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002d3:	7e 0a                	jle    8002df <libmain+0x60>
		binaryname = argv[0];
  8002d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d8:	8b 00                	mov    (%eax),%eax
  8002da:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	ff 75 0c             	pushl  0xc(%ebp)
  8002e5:	ff 75 08             	pushl  0x8(%ebp)
  8002e8:	e8 4b fd ff ff       	call   800038 <_main>
  8002ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002f0:	e8 1a 14 00 00       	call   80170f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002f5:	83 ec 0c             	sub    $0xc,%esp
  8002f8:	68 dc 22 80 00       	push   $0x8022dc
  8002fd:	e8 6d 03 00 00       	call   80066f <cprintf>
  800302:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800305:	a1 20 30 80 00       	mov    0x803020,%eax
  80030a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800310:	a1 20 30 80 00       	mov    0x803020,%eax
  800315:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80031b:	83 ec 04             	sub    $0x4,%esp
  80031e:	52                   	push   %edx
  80031f:	50                   	push   %eax
  800320:	68 04 23 80 00       	push   $0x802304
  800325:	e8 45 03 00 00       	call   80066f <cprintf>
  80032a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80032d:	a1 20 30 80 00       	mov    0x803020,%eax
  800332:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800338:	a1 20 30 80 00       	mov    0x803020,%eax
  80033d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800343:	a1 20 30 80 00       	mov    0x803020,%eax
  800348:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80034e:	51                   	push   %ecx
  80034f:	52                   	push   %edx
  800350:	50                   	push   %eax
  800351:	68 2c 23 80 00       	push   $0x80232c
  800356:	e8 14 03 00 00       	call   80066f <cprintf>
  80035b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80035e:	a1 20 30 80 00       	mov    0x803020,%eax
  800363:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	50                   	push   %eax
  80036d:	68 84 23 80 00       	push   $0x802384
  800372:	e8 f8 02 00 00       	call   80066f <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	68 dc 22 80 00       	push   $0x8022dc
  800382:	e8 e8 02 00 00       	call   80066f <cprintf>
  800387:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80038a:	e8 9a 13 00 00       	call   801729 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80038f:	e8 19 00 00 00       	call   8003ad <exit>
}
  800394:	90                   	nop
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80039d:	83 ec 0c             	sub    $0xc,%esp
  8003a0:	6a 00                	push   $0x0
  8003a2:	e8 27 15 00 00       	call   8018ce <sys_destroy_env>
  8003a7:	83 c4 10             	add    $0x10,%esp
}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <exit>:

void
exit(void)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003b3:	e8 7c 15 00 00       	call   801934 <sys_exit_env>
}
  8003b8:	90                   	nop
  8003b9:	c9                   	leave  
  8003ba:	c3                   	ret    

008003bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8003c4:	83 c0 04             	add    $0x4,%eax
  8003c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003ca:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	74 16                	je     8003e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003d3:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	50                   	push   %eax
  8003dc:	68 98 23 80 00       	push   $0x802398
  8003e1:	e8 89 02 00 00       	call   80066f <cprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e9:	a1 00 30 80 00       	mov    0x803000,%eax
  8003ee:	ff 75 0c             	pushl  0xc(%ebp)
  8003f1:	ff 75 08             	pushl  0x8(%ebp)
  8003f4:	50                   	push   %eax
  8003f5:	68 9d 23 80 00       	push   $0x80239d
  8003fa:	e8 70 02 00 00       	call   80066f <cprintf>
  8003ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800402:	8b 45 10             	mov    0x10(%ebp),%eax
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	ff 75 f4             	pushl  -0xc(%ebp)
  80040b:	50                   	push   %eax
  80040c:	e8 f3 01 00 00       	call   800604 <vcprintf>
  800411:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	6a 00                	push   $0x0
  800419:	68 b9 23 80 00       	push   $0x8023b9
  80041e:	e8 e1 01 00 00       	call   800604 <vcprintf>
  800423:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800426:	e8 82 ff ff ff       	call   8003ad <exit>

	// should not return here
	while (1) ;
  80042b:	eb fe                	jmp    80042b <_panic+0x70>

0080042d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800433:	a1 20 30 80 00       	mov    0x803020,%eax
  800438:	8b 50 74             	mov    0x74(%eax),%edx
  80043b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043e:	39 c2                	cmp    %eax,%edx
  800440:	74 14                	je     800456 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 bc 23 80 00       	push   $0x8023bc
  80044a:	6a 26                	push   $0x26
  80044c:	68 08 24 80 00       	push   $0x802408
  800451:	e8 65 ff ff ff       	call   8003bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80045d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800464:	e9 c2 00 00 00       	jmp    80052b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80046c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	01 d0                	add    %edx,%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	85 c0                	test   %eax,%eax
  80047c:	75 08                	jne    800486 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80047e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800481:	e9 a2 00 00 00       	jmp    800528 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800486:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80048d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800494:	eb 69                	jmp    8004ff <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800496:	a1 20 30 80 00       	mov    0x803020,%eax
  80049b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a4:	89 d0                	mov    %edx,%eax
  8004a6:	01 c0                	add    %eax,%eax
  8004a8:	01 d0                	add    %edx,%eax
  8004aa:	c1 e0 03             	shl    $0x3,%eax
  8004ad:	01 c8                	add    %ecx,%eax
  8004af:	8a 40 04             	mov    0x4(%eax),%al
  8004b2:	84 c0                	test   %al,%al
  8004b4:	75 46                	jne    8004fc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004bb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004c4:	89 d0                	mov    %edx,%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	c1 e0 03             	shl    $0x3,%eax
  8004cd:	01 c8                	add    %ecx,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004dc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004eb:	01 c8                	add    %ecx,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ef:	39 c2                	cmp    %eax,%edx
  8004f1:	75 09                	jne    8004fc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004f3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004fa:	eb 12                	jmp    80050e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004fc:	ff 45 e8             	incl   -0x18(%ebp)
  8004ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800504:	8b 50 74             	mov    0x74(%eax),%edx
  800507:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80050a:	39 c2                	cmp    %eax,%edx
  80050c:	77 88                	ja     800496 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80050e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800512:	75 14                	jne    800528 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800514:	83 ec 04             	sub    $0x4,%esp
  800517:	68 14 24 80 00       	push   $0x802414
  80051c:	6a 3a                	push   $0x3a
  80051e:	68 08 24 80 00       	push   $0x802408
  800523:	e8 93 fe ff ff       	call   8003bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800528:	ff 45 f0             	incl   -0x10(%ebp)
  80052b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800531:	0f 8c 32 ff ff ff    	jl     800469 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800537:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800545:	eb 26                	jmp    80056d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800547:	a1 20 30 80 00       	mov    0x803020,%eax
  80054c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800552:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800555:	89 d0                	mov    %edx,%eax
  800557:	01 c0                	add    %eax,%eax
  800559:	01 d0                	add    %edx,%eax
  80055b:	c1 e0 03             	shl    $0x3,%eax
  80055e:	01 c8                	add    %ecx,%eax
  800560:	8a 40 04             	mov    0x4(%eax),%al
  800563:	3c 01                	cmp    $0x1,%al
  800565:	75 03                	jne    80056a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800567:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056a:	ff 45 e0             	incl   -0x20(%ebp)
  80056d:	a1 20 30 80 00       	mov    0x803020,%eax
  800572:	8b 50 74             	mov    0x74(%eax),%edx
  800575:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800578:	39 c2                	cmp    %eax,%edx
  80057a:	77 cb                	ja     800547 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80057c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800582:	74 14                	je     800598 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800584:	83 ec 04             	sub    $0x4,%esp
  800587:	68 68 24 80 00       	push   $0x802468
  80058c:	6a 44                	push   $0x44
  80058e:	68 08 24 80 00       	push   $0x802408
  800593:	e8 23 fe ff ff       	call   8003bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800598:	90                   	nop
  800599:	c9                   	leave  
  80059a:	c3                   	ret    

0080059b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8005a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ac:	89 0a                	mov    %ecx,(%edx)
  8005ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8005b1:	88 d1                	mov    %dl,%cl
  8005b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bd:	8b 00                	mov    (%eax),%eax
  8005bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005c4:	75 2c                	jne    8005f2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005c6:	a0 24 30 80 00       	mov    0x803024,%al
  8005cb:	0f b6 c0             	movzbl %al,%eax
  8005ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d1:	8b 12                	mov    (%edx),%edx
  8005d3:	89 d1                	mov    %edx,%ecx
  8005d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005d8:	83 c2 08             	add    $0x8,%edx
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	50                   	push   %eax
  8005df:	51                   	push   %ecx
  8005e0:	52                   	push   %edx
  8005e1:	e8 7b 0f 00 00       	call   801561 <sys_cputs>
  8005e6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f5:	8b 40 04             	mov    0x4(%eax),%eax
  8005f8:	8d 50 01             	lea    0x1(%eax),%edx
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800601:	90                   	nop
  800602:	c9                   	leave  
  800603:	c3                   	ret    

00800604 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80060d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800614:	00 00 00 
	b.cnt = 0;
  800617:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80061e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800621:	ff 75 0c             	pushl  0xc(%ebp)
  800624:	ff 75 08             	pushl  0x8(%ebp)
  800627:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80062d:	50                   	push   %eax
  80062e:	68 9b 05 80 00       	push   $0x80059b
  800633:	e8 11 02 00 00       	call   800849 <vprintfmt>
  800638:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80063b:	a0 24 30 80 00       	mov    0x803024,%al
  800640:	0f b6 c0             	movzbl %al,%eax
  800643:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	50                   	push   %eax
  80064d:	52                   	push   %edx
  80064e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800654:	83 c0 08             	add    $0x8,%eax
  800657:	50                   	push   %eax
  800658:	e8 04 0f 00 00       	call   801561 <sys_cputs>
  80065d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800660:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800667:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80066d:	c9                   	leave  
  80066e:	c3                   	ret    

0080066f <cprintf>:

int cprintf(const char *fmt, ...) {
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800675:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 73 ff ff ff       	call   800604 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800697:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069a:	c9                   	leave  
  80069b:	c3                   	ret    

0080069c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006a2:	e8 68 10 00 00       	call   80170f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b6:	50                   	push   %eax
  8006b7:	e8 48 ff ff ff       	call   800604 <vcprintf>
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006c2:	e8 62 10 00 00       	call   801729 <sys_enable_interrupt>
	return cnt;
  8006c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ca:	c9                   	leave  
  8006cb:	c3                   	ret    

008006cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	53                   	push   %ebx
  8006d0:	83 ec 14             	sub    $0x14,%esp
  8006d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006df:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ea:	77 55                	ja     800741 <printnum+0x75>
  8006ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ef:	72 05                	jb     8006f6 <printnum+0x2a>
  8006f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006f4:	77 4b                	ja     800741 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800704:	52                   	push   %edx
  800705:	50                   	push   %eax
  800706:	ff 75 f4             	pushl  -0xc(%ebp)
  800709:	ff 75 f0             	pushl  -0x10(%ebp)
  80070c:	e8 83 14 00 00       	call   801b94 <__udivdi3>
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	ff 75 20             	pushl  0x20(%ebp)
  80071a:	53                   	push   %ebx
  80071b:	ff 75 18             	pushl  0x18(%ebp)
  80071e:	52                   	push   %edx
  80071f:	50                   	push   %eax
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	ff 75 08             	pushl  0x8(%ebp)
  800726:	e8 a1 ff ff ff       	call   8006cc <printnum>
  80072b:	83 c4 20             	add    $0x20,%esp
  80072e:	eb 1a                	jmp    80074a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	ff 75 20             	pushl  0x20(%ebp)
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	ff d0                	call   *%eax
  80073e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800741:	ff 4d 1c             	decl   0x1c(%ebp)
  800744:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800748:	7f e6                	jg     800730 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80074a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80074d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800755:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800758:	53                   	push   %ebx
  800759:	51                   	push   %ecx
  80075a:	52                   	push   %edx
  80075b:	50                   	push   %eax
  80075c:	e8 43 15 00 00       	call   801ca4 <__umoddi3>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	05 d4 26 80 00       	add    $0x8026d4,%eax
  800769:	8a 00                	mov    (%eax),%al
  80076b:	0f be c0             	movsbl %al,%eax
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	50                   	push   %eax
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
}
  80077d:	90                   	nop
  80077e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800786:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80078a:	7e 1c                	jle    8007a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	8d 50 08             	lea    0x8(%eax),%edx
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	89 10                	mov    %edx,(%eax)
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	83 e8 08             	sub    $0x8,%eax
  8007a1:	8b 50 04             	mov    0x4(%eax),%edx
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	eb 40                	jmp    8007e8 <getuint+0x65>
	else if (lflag)
  8007a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ac:	74 1e                	je     8007cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 10                	mov    %edx,(%eax)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ca:	eb 1c                	jmp    8007e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	8d 50 04             	lea    0x4(%eax),%edx
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	89 10                	mov    %edx,(%eax)
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	83 e8 04             	sub    $0x4,%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007f1:	7e 1c                	jle    80080f <getint+0x25>
		return va_arg(*ap, long long);
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	8d 50 08             	lea    0x8(%eax),%edx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	89 10                	mov    %edx,(%eax)
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	83 e8 08             	sub    $0x8,%eax
  800808:	8b 50 04             	mov    0x4(%eax),%edx
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	eb 38                	jmp    800847 <getint+0x5d>
	else if (lflag)
  80080f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800813:	74 1a                	je     80082f <getint+0x45>
		return va_arg(*ap, long);
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	8d 50 04             	lea    0x4(%eax),%edx
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	89 10                	mov    %edx,(%eax)
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	99                   	cltd   
  80082d:	eb 18                	jmp    800847 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	8d 50 04             	lea    0x4(%eax),%edx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	89 10                	mov    %edx,(%eax)
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	83 e8 04             	sub    $0x4,%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	99                   	cltd   
}
  800847:	5d                   	pop    %ebp
  800848:	c3                   	ret    

00800849 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
  80084c:	56                   	push   %esi
  80084d:	53                   	push   %ebx
  80084e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800851:	eb 17                	jmp    80086a <vprintfmt+0x21>
			if (ch == '\0')
  800853:	85 db                	test   %ebx,%ebx
  800855:	0f 84 af 03 00 00    	je     800c0a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	53                   	push   %ebx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	ff d0                	call   *%eax
  800867:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086a:	8b 45 10             	mov    0x10(%ebp),%eax
  80086d:	8d 50 01             	lea    0x1(%eax),%edx
  800870:	89 55 10             	mov    %edx,0x10(%ebp)
  800873:	8a 00                	mov    (%eax),%al
  800875:	0f b6 d8             	movzbl %al,%ebx
  800878:	83 fb 25             	cmp    $0x25,%ebx
  80087b:	75 d6                	jne    800853 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80087d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800881:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800888:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80088f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800896:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089d:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a0:	8d 50 01             	lea    0x1(%eax),%edx
  8008a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8008a6:	8a 00                	mov    (%eax),%al
  8008a8:	0f b6 d8             	movzbl %al,%ebx
  8008ab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ae:	83 f8 55             	cmp    $0x55,%eax
  8008b1:	0f 87 2b 03 00 00    	ja     800be2 <vprintfmt+0x399>
  8008b7:	8b 04 85 f8 26 80 00 	mov    0x8026f8(,%eax,4),%eax
  8008be:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008c0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008c4:	eb d7                	jmp    80089d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008c6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ca:	eb d1                	jmp    80089d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008d6:	89 d0                	mov    %edx,%eax
  8008d8:	c1 e0 02             	shl    $0x2,%eax
  8008db:	01 d0                	add    %edx,%eax
  8008dd:	01 c0                	add    %eax,%eax
  8008df:	01 d8                	add    %ebx,%eax
  8008e1:	83 e8 30             	sub    $0x30,%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ea:	8a 00                	mov    (%eax),%al
  8008ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8008f2:	7e 3e                	jle    800932 <vprintfmt+0xe9>
  8008f4:	83 fb 39             	cmp    $0x39,%ebx
  8008f7:	7f 39                	jg     800932 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008f9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008fc:	eb d5                	jmp    8008d3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	83 c0 04             	add    $0x4,%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	83 e8 04             	sub    $0x4,%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800912:	eb 1f                	jmp    800933 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800914:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800918:	79 83                	jns    80089d <vprintfmt+0x54>
				width = 0;
  80091a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800921:	e9 77 ff ff ff       	jmp    80089d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800926:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80092d:	e9 6b ff ff ff       	jmp    80089d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800932:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800933:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800937:	0f 89 60 ff ff ff    	jns    80089d <vprintfmt+0x54>
				width = precision, precision = -1;
  80093d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800943:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80094a:	e9 4e ff ff ff       	jmp    80089d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80094f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800952:	e9 46 ff ff ff       	jmp    80089d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800957:	8b 45 14             	mov    0x14(%ebp),%eax
  80095a:	83 c0 04             	add    $0x4,%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	83 e8 04             	sub    $0x4,%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	ff 75 0c             	pushl  0xc(%ebp)
  80096e:	50                   	push   %eax
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			break;
  800977:	e9 89 02 00 00       	jmp    800c05 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	83 c0 04             	add    $0x4,%eax
  800982:	89 45 14             	mov    %eax,0x14(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	83 e8 04             	sub    $0x4,%eax
  80098b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80098d:	85 db                	test   %ebx,%ebx
  80098f:	79 02                	jns    800993 <vprintfmt+0x14a>
				err = -err;
  800991:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800993:	83 fb 64             	cmp    $0x64,%ebx
  800996:	7f 0b                	jg     8009a3 <vprintfmt+0x15a>
  800998:	8b 34 9d 40 25 80 00 	mov    0x802540(,%ebx,4),%esi
  80099f:	85 f6                	test   %esi,%esi
  8009a1:	75 19                	jne    8009bc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009a3:	53                   	push   %ebx
  8009a4:	68 e5 26 80 00       	push   $0x8026e5
  8009a9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ac:	ff 75 08             	pushl  0x8(%ebp)
  8009af:	e8 5e 02 00 00       	call   800c12 <printfmt>
  8009b4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009b7:	e9 49 02 00 00       	jmp    800c05 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009bc:	56                   	push   %esi
  8009bd:	68 ee 26 80 00       	push   $0x8026ee
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	ff 75 08             	pushl  0x8(%ebp)
  8009c8:	e8 45 02 00 00       	call   800c12 <printfmt>
  8009cd:	83 c4 10             	add    $0x10,%esp
			break;
  8009d0:	e9 30 02 00 00       	jmp    800c05 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 c0 04             	add    $0x4,%eax
  8009db:	89 45 14             	mov    %eax,0x14(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	83 e8 04             	sub    $0x4,%eax
  8009e4:	8b 30                	mov    (%eax),%esi
  8009e6:	85 f6                	test   %esi,%esi
  8009e8:	75 05                	jne    8009ef <vprintfmt+0x1a6>
				p = "(null)";
  8009ea:	be f1 26 80 00       	mov    $0x8026f1,%esi
			if (width > 0 && padc != '-')
  8009ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f3:	7e 6d                	jle    800a62 <vprintfmt+0x219>
  8009f5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009f9:	74 67                	je     800a62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	50                   	push   %eax
  800a02:	56                   	push   %esi
  800a03:	e8 0c 03 00 00       	call   800d14 <strnlen>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a0e:	eb 16                	jmp    800a26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	50                   	push   %eax
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a23:	ff 4d e4             	decl   -0x1c(%ebp)
  800a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2a:	7f e4                	jg     800a10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a2c:	eb 34                	jmp    800a62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a32:	74 1c                	je     800a50 <vprintfmt+0x207>
  800a34:	83 fb 1f             	cmp    $0x1f,%ebx
  800a37:	7e 05                	jle    800a3e <vprintfmt+0x1f5>
  800a39:	83 fb 7e             	cmp    $0x7e,%ebx
  800a3c:	7e 12                	jle    800a50 <vprintfmt+0x207>
					putch('?', putdat);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 0c             	pushl  0xc(%ebp)
  800a44:	6a 3f                	push   $0x3f
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	ff d0                	call   *%eax
  800a4b:	83 c4 10             	add    $0x10,%esp
  800a4e:	eb 0f                	jmp    800a5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	53                   	push   %ebx
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	ff d0                	call   *%eax
  800a5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800a62:	89 f0                	mov    %esi,%eax
  800a64:	8d 70 01             	lea    0x1(%eax),%esi
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f be d8             	movsbl %al,%ebx
  800a6c:	85 db                	test   %ebx,%ebx
  800a6e:	74 24                	je     800a94 <vprintfmt+0x24b>
  800a70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a74:	78 b8                	js     800a2e <vprintfmt+0x1e5>
  800a76:	ff 4d e0             	decl   -0x20(%ebp)
  800a79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a7d:	79 af                	jns    800a2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a7f:	eb 13                	jmp    800a94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	6a 20                	push   $0x20
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a91:	ff 4d e4             	decl   -0x1c(%ebp)
  800a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a98:	7f e7                	jg     800a81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a9a:	e9 66 01 00 00       	jmp    800c05 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	e8 3c fd ff ff       	call   8007ea <getint>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abd:	85 d2                	test   %edx,%edx
  800abf:	79 23                	jns    800ae4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	6a 2d                	push   $0x2d
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad7:	f7 d8                	neg    %eax
  800ad9:	83 d2 00             	adc    $0x0,%edx
  800adc:	f7 da                	neg    %edx
  800ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ae4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aeb:	e9 bc 00 00 00       	jmp    800bac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 e8             	pushl  -0x18(%ebp)
  800af6:	8d 45 14             	lea    0x14(%ebp),%eax
  800af9:	50                   	push   %eax
  800afa:	e8 84 fc ff ff       	call   800783 <getuint>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b0f:	e9 98 00 00 00       	jmp    800bac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	6a 58                	push   $0x58
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	ff d0                	call   *%eax
  800b21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b24:	83 ec 08             	sub    $0x8,%esp
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	6a 58                	push   $0x58
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	ff d0                	call   *%eax
  800b31:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	6a 58                	push   $0x58
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	ff d0                	call   *%eax
  800b41:	83 c4 10             	add    $0x10,%esp
			break;
  800b44:	e9 bc 00 00 00       	jmp    800c05 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	6a 30                	push   $0x30
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	ff d0                	call   *%eax
  800b56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 78                	push   $0x78
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b69:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6c:	83 c0 04             	add    $0x4,%eax
  800b6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b72:	8b 45 14             	mov    0x14(%ebp),%eax
  800b75:	83 e8 04             	sub    $0x4,%eax
  800b78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b8b:	eb 1f                	jmp    800bac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	ff 75 e8             	pushl  -0x18(%ebp)
  800b93:	8d 45 14             	lea    0x14(%ebp),%eax
  800b96:	50                   	push   %eax
  800b97:	e8 e7 fb ff ff       	call   800783 <getuint>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ba5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	52                   	push   %edx
  800bb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bba:	50                   	push   %eax
  800bbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	ff 75 08             	pushl  0x8(%ebp)
  800bc7:	e8 00 fb ff ff       	call   8006cc <printnum>
  800bcc:	83 c4 20             	add    $0x20,%esp
			break;
  800bcf:	eb 34                	jmp    800c05 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	53                   	push   %ebx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	ff d0                	call   *%eax
  800bdd:	83 c4 10             	add    $0x10,%esp
			break;
  800be0:	eb 23                	jmp    800c05 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 25                	push   $0x25
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bf2:	ff 4d 10             	decl   0x10(%ebp)
  800bf5:	eb 03                	jmp    800bfa <vprintfmt+0x3b1>
  800bf7:	ff 4d 10             	decl   0x10(%ebp)
  800bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfd:	48                   	dec    %eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	3c 25                	cmp    $0x25,%al
  800c02:	75 f3                	jne    800bf7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c04:	90                   	nop
		}
	}
  800c05:	e9 47 fc ff ff       	jmp    800851 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c18:	8d 45 10             	lea    0x10(%ebp),%eax
  800c1b:	83 c0 04             	add    $0x4,%eax
  800c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c21:	8b 45 10             	mov    0x10(%ebp),%eax
  800c24:	ff 75 f4             	pushl  -0xc(%ebp)
  800c27:	50                   	push   %eax
  800c28:	ff 75 0c             	pushl  0xc(%ebp)
  800c2b:	ff 75 08             	pushl  0x8(%ebp)
  800c2e:	e8 16 fc ff ff       	call   800849 <vprintfmt>
  800c33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c36:	90                   	nop
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8b 40 08             	mov    0x8(%eax),%eax
  800c42:	8d 50 01             	lea    0x1(%eax),%edx
  800c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4e:	8b 10                	mov    (%eax),%edx
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 40 04             	mov    0x4(%eax),%eax
  800c56:	39 c2                	cmp    %eax,%edx
  800c58:	73 12                	jae    800c6c <sprintputch+0x33>
		*b->buf++ = ch;
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8b 00                	mov    (%eax),%eax
  800c5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	89 0a                	mov    %ecx,(%edx)
  800c67:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6a:	88 10                	mov    %dl,(%eax)
}
  800c6c:	90                   	nop
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c81:	8b 45 08             	mov    0x8(%ebp),%eax
  800c84:	01 d0                	add    %edx,%eax
  800c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c94:	74 06                	je     800c9c <vsnprintf+0x2d>
  800c96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9a:	7f 07                	jg     800ca3 <vsnprintf+0x34>
		return -E_INVAL;
  800c9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800ca1:	eb 20                	jmp    800cc3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ca3:	ff 75 14             	pushl  0x14(%ebp)
  800ca6:	ff 75 10             	pushl  0x10(%ebp)
  800ca9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cac:	50                   	push   %eax
  800cad:	68 39 0c 80 00       	push   $0x800c39
  800cb2:	e8 92 fb ff ff       	call   800849 <vprintfmt>
  800cb7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cbd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ccb:	8d 45 10             	lea    0x10(%ebp),%eax
  800cce:	83 c0 04             	add    $0x4,%eax
  800cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cda:	50                   	push   %eax
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	ff 75 08             	pushl  0x8(%ebp)
  800ce1:	e8 89 ff ff ff       	call   800c6f <vsnprintf>
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfe:	eb 06                	jmp    800d06 <strlen+0x15>
		n++;
  800d00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d03:	ff 45 08             	incl   0x8(%ebp)
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	84 c0                	test   %al,%al
  800d0d:	75 f1                	jne    800d00 <strlen+0xf>
		n++;
	return n;
  800d0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d21:	eb 09                	jmp    800d2c <strnlen+0x18>
		n++;
  800d23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d26:	ff 45 08             	incl   0x8(%ebp)
  800d29:	ff 4d 0c             	decl   0xc(%ebp)
  800d2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d30:	74 09                	je     800d3b <strnlen+0x27>
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	84 c0                	test   %al,%al
  800d39:	75 e8                	jne    800d23 <strnlen+0xf>
		n++;
	return n;
  800d3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d4c:	90                   	nop
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8d 50 01             	lea    0x1(%eax),%edx
  800d53:	89 55 08             	mov    %edx,0x8(%ebp)
  800d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5f:	8a 12                	mov    (%edx),%dl
  800d61:	88 10                	mov    %dl,(%eax)
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	84 c0                	test   %al,%al
  800d67:	75 e4                	jne    800d4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d81:	eb 1f                	jmp    800da2 <strncpy+0x34>
		*dst++ = *src;
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8d 50 01             	lea    0x1(%eax),%edx
  800d89:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8f:	8a 12                	mov    (%edx),%dl
  800d91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	84 c0                	test   %al,%al
  800d9a:	74 03                	je     800d9f <strncpy+0x31>
			src++;
  800d9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d9f:	ff 45 fc             	incl   -0x4(%ebp)
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da8:	72 d9                	jb     800d83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbf:	74 30                	je     800df1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dc1:	eb 16                	jmp    800dd9 <strlcpy+0x2a>
			*dst++ = *src++;
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 08             	mov    %edx,0x8(%ebp)
  800dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd9:	ff 4d 10             	decl   0x10(%ebp)
  800ddc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de0:	74 09                	je     800deb <strlcpy+0x3c>
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	84 c0                	test   %al,%al
  800de9:	75 d8                	jne    800dc3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e00:	eb 06                	jmp    800e08 <strcmp+0xb>
		p++, q++;
  800e02:	ff 45 08             	incl   0x8(%ebp)
  800e05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	84 c0                	test   %al,%al
  800e0f:	74 0e                	je     800e1f <strcmp+0x22>
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 10                	mov    (%eax),%dl
  800e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	38 c2                	cmp    %al,%dl
  800e1d:	74 e3                	je     800e02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f b6 d0             	movzbl %al,%edx
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	0f b6 c0             	movzbl %al,%eax
  800e2f:	29 c2                	sub    %eax,%edx
  800e31:	89 d0                	mov    %edx,%eax
}
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e38:	eb 09                	jmp    800e43 <strncmp+0xe>
		n--, p++, q++;
  800e3a:	ff 4d 10             	decl   0x10(%ebp)
  800e3d:	ff 45 08             	incl   0x8(%ebp)
  800e40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e47:	74 17                	je     800e60 <strncmp+0x2b>
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	74 0e                	je     800e60 <strncmp+0x2b>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 10                	mov    (%eax),%dl
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	38 c2                	cmp    %al,%dl
  800e5e:	74 da                	je     800e3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e64:	75 07                	jne    800e6d <strncmp+0x38>
		return 0;
  800e66:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6b:	eb 14                	jmp    800e81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	0f b6 d0             	movzbl %al,%edx
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	0f b6 c0             	movzbl %al,%eax
  800e7d:	29 c2                	sub    %eax,%edx
  800e7f:	89 d0                	mov    %edx,%eax
}
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 04             	sub    $0x4,%esp
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e8f:	eb 12                	jmp    800ea3 <strchr+0x20>
		if (*s == c)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e99:	75 05                	jne    800ea0 <strchr+0x1d>
			return (char *) s;
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	eb 11                	jmp    800eb1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	75 e5                	jne    800e91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb1:	c9                   	leave  
  800eb2:	c3                   	ret    

00800eb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	83 ec 04             	sub    $0x4,%esp
  800eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ebf:	eb 0d                	jmp    800ece <strfind+0x1b>
		if (*s == c)
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec9:	74 0e                	je     800ed9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ecb:	ff 45 08             	incl   0x8(%ebp)
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 ea                	jne    800ec1 <strfind+0xe>
  800ed7:	eb 01                	jmp    800eda <strfind+0x27>
		if (*s == c)
			break;
  800ed9:	90                   	nop
	return (char *) s;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ef1:	eb 0e                	jmp    800f01 <memset+0x22>
		*p++ = c;
  800ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef6:	8d 50 01             	lea    0x1(%eax),%edx
  800ef9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f01:	ff 4d f8             	decl   -0x8(%ebp)
  800f04:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f08:	79 e9                	jns    800ef3 <memset+0x14>
		*p++ = c;

	return v;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0d:	c9                   	leave  
  800f0e:	c3                   	ret    

00800f0f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f21:	eb 16                	jmp    800f39 <memcpy+0x2a>
		*d++ = *s++;
  800f23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f26:	8d 50 01             	lea    0x1(%eax),%edx
  800f29:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f32:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f35:	8a 12                	mov    (%edx),%dl
  800f37:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f39:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f42:	85 c0                	test   %eax,%eax
  800f44:	75 dd                	jne    800f23 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f60:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f63:	73 50                	jae    800fb5 <memmove+0x6a>
  800f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	01 d0                	add    %edx,%eax
  800f6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f70:	76 43                	jbe    800fb5 <memmove+0x6a>
		s += n;
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f7e:	eb 10                	jmp    800f90 <memmove+0x45>
			*--d = *--s;
  800f80:	ff 4d f8             	decl   -0x8(%ebp)
  800f83:	ff 4d fc             	decl   -0x4(%ebp)
  800f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f89:	8a 10                	mov    (%eax),%dl
  800f8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f96:	89 55 10             	mov    %edx,0x10(%ebp)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	75 e3                	jne    800f80 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f9d:	eb 23                	jmp    800fc2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	8d 50 01             	lea    0x1(%eax),%edx
  800fa5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fa8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fab:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fb1:	8a 12                	mov    (%edx),%dl
  800fb3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbb:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbe:	85 c0                	test   %eax,%eax
  800fc0:	75 dd                	jne    800f9f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc5:	c9                   	leave  
  800fc6:	c3                   	ret    

00800fc7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fd9:	eb 2a                	jmp    801005 <memcmp+0x3e>
		if (*s1 != *s2)
  800fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fde:	8a 10                	mov    (%eax),%dl
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	38 c2                	cmp    %al,%dl
  800fe7:	74 16                	je     800fff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fe9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f b6 d0             	movzbl %al,%edx
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	0f b6 c0             	movzbl %al,%eax
  800ff9:	29 c2                	sub    %eax,%edx
  800ffb:	89 d0                	mov    %edx,%eax
  800ffd:	eb 18                	jmp    801017 <memcmp+0x50>
		s1++, s2++;
  800fff:	ff 45 fc             	incl   -0x4(%ebp)
  801002:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801005:	8b 45 10             	mov    0x10(%ebp),%eax
  801008:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100b:	89 55 10             	mov    %edx,0x10(%ebp)
  80100e:	85 c0                	test   %eax,%eax
  801010:	75 c9                	jne    800fdb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801012:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80101f:	8b 55 08             	mov    0x8(%ebp),%edx
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	01 d0                	add    %edx,%eax
  801027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80102a:	eb 15                	jmp    801041 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	0f b6 d0             	movzbl %al,%edx
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	0f b6 c0             	movzbl %al,%eax
  80103a:	39 c2                	cmp    %eax,%edx
  80103c:	74 0d                	je     80104b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80103e:	ff 45 08             	incl   0x8(%ebp)
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801047:	72 e3                	jb     80102c <memfind+0x13>
  801049:	eb 01                	jmp    80104c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80104b:	90                   	nop
	return (void *) s;
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104f:	c9                   	leave  
  801050:	c3                   	ret    

00801051 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801057:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80105e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801065:	eb 03                	jmp    80106a <strtol+0x19>
		s++;
  801067:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	3c 20                	cmp    $0x20,%al
  801071:	74 f4                	je     801067 <strtol+0x16>
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	3c 09                	cmp    $0x9,%al
  80107a:	74 eb                	je     801067 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	3c 2b                	cmp    $0x2b,%al
  801083:	75 05                	jne    80108a <strtol+0x39>
		s++;
  801085:	ff 45 08             	incl   0x8(%ebp)
  801088:	eb 13                	jmp    80109d <strtol+0x4c>
	else if (*s == '-')
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	3c 2d                	cmp    $0x2d,%al
  801091:	75 0a                	jne    80109d <strtol+0x4c>
		s++, neg = 1;
  801093:	ff 45 08             	incl   0x8(%ebp)
  801096:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80109d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a1:	74 06                	je     8010a9 <strtol+0x58>
  8010a3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010a7:	75 20                	jne    8010c9 <strtol+0x78>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 30                	cmp    $0x30,%al
  8010b0:	75 17                	jne    8010c9 <strtol+0x78>
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	40                   	inc    %eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3c 78                	cmp    $0x78,%al
  8010ba:	75 0d                	jne    8010c9 <strtol+0x78>
		s += 2, base = 16;
  8010bc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010c0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010c7:	eb 28                	jmp    8010f1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cd:	75 15                	jne    8010e4 <strtol+0x93>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 30                	cmp    $0x30,%al
  8010d6:	75 0c                	jne    8010e4 <strtol+0x93>
		s++, base = 8;
  8010d8:	ff 45 08             	incl   0x8(%ebp)
  8010db:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010e2:	eb 0d                	jmp    8010f1 <strtol+0xa0>
	else if (base == 0)
  8010e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e8:	75 07                	jne    8010f1 <strtol+0xa0>
		base = 10;
  8010ea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 2f                	cmp    $0x2f,%al
  8010f8:	7e 19                	jle    801113 <strtol+0xc2>
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	3c 39                	cmp    $0x39,%al
  801101:	7f 10                	jg     801113 <strtol+0xc2>
			dig = *s - '0';
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	0f be c0             	movsbl %al,%eax
  80110b:	83 e8 30             	sub    $0x30,%eax
  80110e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801111:	eb 42                	jmp    801155 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 60                	cmp    $0x60,%al
  80111a:	7e 19                	jle    801135 <strtol+0xe4>
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	3c 7a                	cmp    $0x7a,%al
  801123:	7f 10                	jg     801135 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	0f be c0             	movsbl %al,%eax
  80112d:	83 e8 57             	sub    $0x57,%eax
  801130:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801133:	eb 20                	jmp    801155 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	3c 40                	cmp    $0x40,%al
  80113c:	7e 39                	jle    801177 <strtol+0x126>
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	3c 5a                	cmp    $0x5a,%al
  801145:	7f 30                	jg     801177 <strtol+0x126>
			dig = *s - 'A' + 10;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f be c0             	movsbl %al,%eax
  80114f:	83 e8 37             	sub    $0x37,%eax
  801152:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801158:	3b 45 10             	cmp    0x10(%ebp),%eax
  80115b:	7d 19                	jge    801176 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80115d:	ff 45 08             	incl   0x8(%ebp)
  801160:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801163:	0f af 45 10          	imul   0x10(%ebp),%eax
  801167:	89 c2                	mov    %eax,%edx
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	01 d0                	add    %edx,%eax
  80116e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801171:	e9 7b ff ff ff       	jmp    8010f1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801176:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801177:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117b:	74 08                	je     801185 <strtol+0x134>
		*endptr = (char *) s;
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8b 55 08             	mov    0x8(%ebp),%edx
  801183:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801185:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801189:	74 07                	je     801192 <strtol+0x141>
  80118b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118e:	f7 d8                	neg    %eax
  801190:	eb 03                	jmp    801195 <strtol+0x144>
  801192:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <ltostr>:

void
ltostr(long value, char *str)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80119d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011af:	79 13                	jns    8011c4 <ltostr+0x2d>
	{
		neg = 1;
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011be:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011c1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011cc:	99                   	cltd   
  8011cd:	f7 f9                	idiv   %ecx
  8011cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d5:	8d 50 01             	lea    0x1(%eax),%edx
  8011d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011e5:	83 c2 30             	add    $0x30,%edx
  8011e8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011f2:	f7 e9                	imul   %ecx
  8011f4:	c1 fa 02             	sar    $0x2,%edx
  8011f7:	89 c8                	mov    %ecx,%eax
  8011f9:	c1 f8 1f             	sar    $0x1f,%eax
  8011fc:	29 c2                	sub    %eax,%edx
  8011fe:	89 d0                	mov    %edx,%eax
  801200:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801203:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801206:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80120b:	f7 e9                	imul   %ecx
  80120d:	c1 fa 02             	sar    $0x2,%edx
  801210:	89 c8                	mov    %ecx,%eax
  801212:	c1 f8 1f             	sar    $0x1f,%eax
  801215:	29 c2                	sub    %eax,%edx
  801217:	89 d0                	mov    %edx,%eax
  801219:	c1 e0 02             	shl    $0x2,%eax
  80121c:	01 d0                	add    %edx,%eax
  80121e:	01 c0                	add    %eax,%eax
  801220:	29 c1                	sub    %eax,%ecx
  801222:	89 ca                	mov    %ecx,%edx
  801224:	85 d2                	test   %edx,%edx
  801226:	75 9c                	jne    8011c4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80122f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801232:	48                   	dec    %eax
  801233:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801236:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80123a:	74 3d                	je     801279 <ltostr+0xe2>
		start = 1 ;
  80123c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801243:	eb 34                	jmp    801279 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801266:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801271:	88 02                	mov    %al,(%edx)
		start++ ;
  801273:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801276:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80127f:	7c c4                	jl     801245 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801281:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80128c:	90                   	nop
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801295:	ff 75 08             	pushl  0x8(%ebp)
  801298:	e8 54 fa ff ff       	call   800cf1 <strlen>
  80129d:	83 c4 04             	add    $0x4,%esp
  8012a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012a3:	ff 75 0c             	pushl  0xc(%ebp)
  8012a6:	e8 46 fa ff ff       	call   800cf1 <strlen>
  8012ab:	83 c4 04             	add    $0x4,%esp
  8012ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012bf:	eb 17                	jmp    8012d8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	01 c2                	add    %eax,%edx
  8012c9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	01 c8                	add    %ecx,%eax
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012d5:	ff 45 fc             	incl   -0x4(%ebp)
  8012d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012de:	7c e1                	jl     8012c1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012ee:	eb 1f                	jmp    80130f <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f3:	8d 50 01             	lea    0x1(%eax),%edx
  8012f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012f9:	89 c2                	mov    %eax,%edx
  8012fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fe:	01 c2                	add    %eax,%edx
  801300:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	01 c8                	add    %ecx,%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80130c:	ff 45 f8             	incl   -0x8(%ebp)
  80130f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801312:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801315:	7c d9                	jl     8012f0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801317:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	c6 00 00             	movb   $0x0,(%eax)
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801328:	8b 45 14             	mov    0x14(%ebp),%eax
  80132b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	8b 00                	mov    (%eax),%eax
  801336:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
  801340:	01 d0                	add    %edx,%eax
  801342:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801348:	eb 0c                	jmp    801356 <strsplit+0x31>
			*string++ = 0;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8d 50 01             	lea    0x1(%eax),%edx
  801350:	89 55 08             	mov    %edx,0x8(%ebp)
  801353:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	84 c0                	test   %al,%al
  80135d:	74 18                	je     801377 <strsplit+0x52>
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f be c0             	movsbl %al,%eax
  801367:	50                   	push   %eax
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	e8 13 fb ff ff       	call   800e83 <strchr>
  801370:	83 c4 08             	add    $0x8,%esp
  801373:	85 c0                	test   %eax,%eax
  801375:	75 d3                	jne    80134a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 5a                	je     8013da <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801380:	8b 45 14             	mov    0x14(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	83 f8 0f             	cmp    $0xf,%eax
  801388:	75 07                	jne    801391 <strsplit+0x6c>
		{
			return 0;
  80138a:	b8 00 00 00 00       	mov    $0x0,%eax
  80138f:	eb 66                	jmp    8013f7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801391:	8b 45 14             	mov    0x14(%ebp),%eax
  801394:	8b 00                	mov    (%eax),%eax
  801396:	8d 48 01             	lea    0x1(%eax),%ecx
  801399:	8b 55 14             	mov    0x14(%ebp),%edx
  80139c:	89 0a                	mov    %ecx,(%edx)
  80139e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a8:	01 c2                	add    %eax,%edx
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013af:	eb 03                	jmp    8013b4 <strsplit+0x8f>
			string++;
  8013b1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b7:	8a 00                	mov    (%eax),%al
  8013b9:	84 c0                	test   %al,%al
  8013bb:	74 8b                	je     801348 <strsplit+0x23>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	0f be c0             	movsbl %al,%eax
  8013c5:	50                   	push   %eax
  8013c6:	ff 75 0c             	pushl  0xc(%ebp)
  8013c9:	e8 b5 fa ff ff       	call   800e83 <strchr>
  8013ce:	83 c4 08             	add    $0x8,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	74 dc                	je     8013b1 <strsplit+0x8c>
			string++;
	}
  8013d5:	e9 6e ff ff ff       	jmp    801348 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013da:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013db:	8b 45 14             	mov    0x14(%ebp),%eax
  8013de:	8b 00                	mov    (%eax),%eax
  8013e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 d0                	add    %edx,%eax
  8013ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8013ff:	83 ec 04             	sub    $0x4,%esp
  801402:	68 50 28 80 00       	push   $0x802850
  801407:	6a 0e                	push   $0xe
  801409:	68 8a 28 80 00       	push   $0x80288a
  80140e:	e8 a8 ef ff ff       	call   8003bb <_panic>

00801413 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801419:	a1 04 30 80 00       	mov    0x803004,%eax
  80141e:	85 c0                	test   %eax,%eax
  801420:	74 0f                	je     801431 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801422:	e8 d2 ff ff ff       	call   8013f9 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801427:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80142e:	00 00 00 
	}
	if (size == 0) return NULL ;
  801431:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801435:	75 07                	jne    80143e <malloc+0x2b>
  801437:	b8 00 00 00 00       	mov    $0x0,%eax
  80143c:	eb 14                	jmp    801452 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	68 98 28 80 00       	push   $0x802898
  801446:	6a 2e                	push   $0x2e
  801448:	68 8a 28 80 00       	push   $0x80288a
  80144d:	e8 69 ef ff ff       	call   8003bb <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	68 c0 28 80 00       	push   $0x8028c0
  801462:	6a 49                	push   $0x49
  801464:	68 8a 28 80 00       	push   $0x80288a
  801469:	e8 4d ef ff ff       	call   8003bb <_panic>

0080146e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 18             	sub    $0x18,%esp
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	68 e4 28 80 00       	push   $0x8028e4
  801482:	6a 57                	push   $0x57
  801484:	68 8a 28 80 00       	push   $0x80288a
  801489:	e8 2d ef ff ff       	call   8003bb <_panic>

0080148e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801494:	83 ec 04             	sub    $0x4,%esp
  801497:	68 0c 29 80 00       	push   $0x80290c
  80149c:	6a 60                	push   $0x60
  80149e:	68 8a 28 80 00       	push   $0x80288a
  8014a3:	e8 13 ef ff ff       	call   8003bb <_panic>

008014a8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014ae:	83 ec 04             	sub    $0x4,%esp
  8014b1:	68 30 29 80 00       	push   $0x802930
  8014b6:	6a 7c                	push   $0x7c
  8014b8:	68 8a 28 80 00       	push   $0x80288a
  8014bd:	e8 f9 ee ff ff       	call   8003bb <_panic>

008014c2 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	68 58 29 80 00       	push   $0x802958
  8014d0:	68 86 00 00 00       	push   $0x86
  8014d5:	68 8a 28 80 00       	push   $0x80288a
  8014da:	e8 dc ee ff ff       	call   8003bb <_panic>

008014df <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	68 7c 29 80 00       	push   $0x80297c
  8014ed:	68 91 00 00 00       	push   $0x91
  8014f2:	68 8a 28 80 00       	push   $0x80288a
  8014f7:	e8 bf ee ff ff       	call   8003bb <_panic>

008014fc <shrink>:

}
void shrink(uint32 newSize)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	68 7c 29 80 00       	push   $0x80297c
  80150a:	68 96 00 00 00       	push   $0x96
  80150f:	68 8a 28 80 00       	push   $0x80288a
  801514:	e8 a2 ee ff ff       	call   8003bb <_panic>

00801519 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	68 7c 29 80 00       	push   $0x80297c
  801527:	68 9b 00 00 00       	push   $0x9b
  80152c:	68 8a 28 80 00       	push   $0x80288a
  801531:	e8 85 ee ff ff       	call   8003bb <_panic>

00801536 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	57                   	push   %edi
  80153a:	56                   	push   %esi
  80153b:	53                   	push   %ebx
  80153c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8b 55 0c             	mov    0xc(%ebp),%edx
  801545:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801548:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80154b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80154e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801551:	cd 30                	int    $0x30
  801553:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801556:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5f                   	pop    %edi
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    

00801561 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80156d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	52                   	push   %edx
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	50                   	push   %eax
  80157d:	6a 00                	push   $0x0
  80157f:	e8 b2 ff ff ff       	call   801536 <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
}
  801587:	90                   	nop
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_cgetc>:

int
sys_cgetc(void)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 01                	push   $0x1
  801599:	e8 98 ff ff ff       	call   801536 <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	52                   	push   %edx
  8015b3:	50                   	push   %eax
  8015b4:	6a 05                	push   $0x5
  8015b6:	e8 7b ff ff ff       	call   801536 <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015c5:	8b 75 18             	mov    0x18(%ebp),%esi
  8015c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	56                   	push   %esi
  8015d5:	53                   	push   %ebx
  8015d6:	51                   	push   %ecx
  8015d7:	52                   	push   %edx
  8015d8:	50                   	push   %eax
  8015d9:	6a 06                	push   $0x6
  8015db:	e8 56 ff ff ff       	call   801536 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5e                   	pop    %esi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	52                   	push   %edx
  8015fa:	50                   	push   %eax
  8015fb:	6a 07                	push   $0x7
  8015fd:	e8 34 ff ff ff       	call   801536 <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	ff 75 0c             	pushl  0xc(%ebp)
  801613:	ff 75 08             	pushl  0x8(%ebp)
  801616:	6a 08                	push   $0x8
  801618:	e8 19 ff ff ff       	call   801536 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 09                	push   $0x9
  801631:	e8 00 ff ff ff       	call   801536 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 0a                	push   $0xa
  80164a:	e8 e7 fe ff ff       	call   801536 <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 0b                	push   $0xb
  801663:	e8 ce fe ff ff       	call   801536 <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	6a 0f                	push   $0xf
  80167e:	e8 b3 fe ff ff       	call   801536 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
	return;
  801686:	90                   	nop
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	6a 10                	push   $0x10
  80169a:	e8 97 fe ff ff       	call   801536 <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a2:	90                   	nop
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	ff 75 10             	pushl  0x10(%ebp)
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	ff 75 08             	pushl  0x8(%ebp)
  8016b5:	6a 11                	push   $0x11
  8016b7:	e8 7a fe ff ff       	call   801536 <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8016bf:	90                   	nop
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 0c                	push   $0xc
  8016d1:	e8 60 fe ff ff       	call   801536 <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	ff 75 08             	pushl  0x8(%ebp)
  8016e9:	6a 0d                	push   $0xd
  8016eb:	e8 46 fe ff ff       	call   801536 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 0e                	push   $0xe
  801704:	e8 2d fe ff ff       	call   801536 <syscall>
  801709:	83 c4 18             	add    $0x18,%esp
}
  80170c:	90                   	nop
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 13                	push   $0x13
  80171e:	e8 13 fe ff ff       	call   801536 <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	90                   	nop
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 14                	push   $0x14
  801738:	e8 f9 fd ff ff       	call   801536 <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	90                   	nop
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_cputc>:


void
sys_cputc(const char c)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80174f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	50                   	push   %eax
  80175c:	6a 15                	push   $0x15
  80175e:	e8 d3 fd ff ff       	call   801536 <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	90                   	nop
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 16                	push   $0x16
  801778:	e8 b9 fd ff ff       	call   801536 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	50                   	push   %eax
  801793:	6a 17                	push   $0x17
  801795:	e8 9c fd ff ff       	call   801536 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	52                   	push   %edx
  8017af:	50                   	push   %eax
  8017b0:	6a 1a                	push   $0x1a
  8017b2:	e8 7f fd ff ff       	call   801536 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	52                   	push   %edx
  8017cc:	50                   	push   %eax
  8017cd:	6a 18                	push   $0x18
  8017cf:	e8 62 fd ff ff       	call   801536 <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	90                   	nop
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	52                   	push   %edx
  8017ea:	50                   	push   %eax
  8017eb:	6a 19                	push   $0x19
  8017ed:	e8 44 fd ff ff       	call   801536 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	90                   	nop
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801801:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801804:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801807:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	6a 00                	push   $0x0
  801810:	51                   	push   %ecx
  801811:	52                   	push   %edx
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	50                   	push   %eax
  801816:	6a 1b                	push   $0x1b
  801818:	e8 19 fd ff ff       	call   801536 <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801825:	8b 55 0c             	mov    0xc(%ebp),%edx
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	52                   	push   %edx
  801832:	50                   	push   %eax
  801833:	6a 1c                	push   $0x1c
  801835:	e8 fc fc ff ff       	call   801536 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801842:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801845:	8b 55 0c             	mov    0xc(%ebp),%edx
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	51                   	push   %ecx
  801850:	52                   	push   %edx
  801851:	50                   	push   %eax
  801852:	6a 1d                	push   $0x1d
  801854:	e8 dd fc ff ff       	call   801536 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801861:	8b 55 0c             	mov    0xc(%ebp),%edx
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	52                   	push   %edx
  80186e:	50                   	push   %eax
  80186f:	6a 1e                	push   $0x1e
  801871:	e8 c0 fc ff ff       	call   801536 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 1f                	push   $0x1f
  80188a:	e8 a7 fc ff ff       	call   801536 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 14             	pushl  0x14(%ebp)
  80189f:	ff 75 10             	pushl  0x10(%ebp)
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	50                   	push   %eax
  8018a6:	6a 20                	push   $0x20
  8018a8:	e8 89 fc ff ff       	call   801536 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	50                   	push   %eax
  8018c1:	6a 21                	push   $0x21
  8018c3:	e8 6e fc ff ff       	call   801536 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	90                   	nop
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	50                   	push   %eax
  8018dd:	6a 22                	push   $0x22
  8018df:	e8 52 fc ff ff       	call   801536 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 02                	push   $0x2
  8018f8:	e8 39 fc ff ff       	call   801536 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 03                	push   $0x3
  801911:	e8 20 fc ff ff       	call   801536 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 04                	push   $0x4
  80192a:	e8 07 fc ff ff       	call   801536 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_exit_env>:


void sys_exit_env(void)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 23                	push   $0x23
  801943:	e8 ee fb ff ff       	call   801536 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	90                   	nop
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801954:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801957:	8d 50 04             	lea    0x4(%eax),%edx
  80195a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	52                   	push   %edx
  801964:	50                   	push   %eax
  801965:	6a 24                	push   $0x24
  801967:	e8 ca fb ff ff       	call   801536 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
	return result;
  80196f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801972:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801975:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801978:	89 01                	mov    %eax,(%ecx)
  80197a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	c9                   	leave  
  801981:	c2 04 00             	ret    $0x4

00801984 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	ff 75 10             	pushl  0x10(%ebp)
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	6a 12                	push   $0x12
  801996:	e8 9b fb ff ff       	call   801536 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
	return ;
  80199e:	90                   	nop
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 25                	push   $0x25
  8019b0:	e8 81 fb ff ff       	call   801536 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019c6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	50                   	push   %eax
  8019d3:	6a 26                	push   $0x26
  8019d5:	e8 5c fb ff ff       	call   801536 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dd:	90                   	nop
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <rsttst>:
void rsttst()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 28                	push   $0x28
  8019ef:	e8 42 fb ff ff       	call   801536 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f7:	90                   	nop
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	8b 45 14             	mov    0x14(%ebp),%eax
  801a03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a06:	8b 55 18             	mov    0x18(%ebp),%edx
  801a09:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	ff 75 10             	pushl  0x10(%ebp)
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	ff 75 08             	pushl  0x8(%ebp)
  801a18:	6a 27                	push   $0x27
  801a1a:	e8 17 fb ff ff       	call   801536 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a22:	90                   	nop
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <chktst>:
void chktst(uint32 n)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	ff 75 08             	pushl  0x8(%ebp)
  801a33:	6a 29                	push   $0x29
  801a35:	e8 fc fa ff ff       	call   801536 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3d:	90                   	nop
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <inctst>:

void inctst()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 2a                	push   $0x2a
  801a4f:	e8 e2 fa ff ff       	call   801536 <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
	return ;
  801a57:	90                   	nop
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <gettst>:
uint32 gettst()
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 2b                	push   $0x2b
  801a69:	e8 c8 fa ff ff       	call   801536 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 2c                	push   $0x2c
  801a85:	e8 ac fa ff ff       	call   801536 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
  801a8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a90:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a94:	75 07                	jne    801a9d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a96:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9b:	eb 05                	jmp    801aa2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 2c                	push   $0x2c
  801ab6:	e8 7b fa ff ff       	call   801536 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
  801abe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ac1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ac5:	75 07                	jne    801ace <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ac7:	b8 01 00 00 00       	mov    $0x1,%eax
  801acc:	eb 05                	jmp    801ad3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 2c                	push   $0x2c
  801ae7:	e8 4a fa ff ff       	call   801536 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
  801aef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801af2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801af6:	75 07                	jne    801aff <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801af8:	b8 01 00 00 00       	mov    $0x1,%eax
  801afd:	eb 05                	jmp    801b04 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801aff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 2c                	push   $0x2c
  801b18:	e8 19 fa ff ff       	call   801536 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
  801b20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b23:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b27:	75 07                	jne    801b30 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b29:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2e:	eb 05                	jmp    801b35 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	6a 2d                	push   $0x2d
  801b47:	e8 ea f9 ff ff       	call   801536 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4f:	90                   	nop
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b56:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	53                   	push   %ebx
  801b65:	51                   	push   %ecx
  801b66:	52                   	push   %edx
  801b67:	50                   	push   %eax
  801b68:	6a 2e                	push   $0x2e
  801b6a:	e8 c7 f9 ff ff       	call   801536 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	52                   	push   %edx
  801b87:	50                   	push   %eax
  801b88:	6a 2f                	push   $0x2f
  801b8a:	e8 a7 f9 ff ff       	call   801536 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <__udivdi3>:
  801b94:	55                   	push   %ebp
  801b95:	57                   	push   %edi
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
  801b98:	83 ec 1c             	sub    $0x1c,%esp
  801b9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ba3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ba7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bab:	89 ca                	mov    %ecx,%edx
  801bad:	89 f8                	mov    %edi,%eax
  801baf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bb3:	85 f6                	test   %esi,%esi
  801bb5:	75 2d                	jne    801be4 <__udivdi3+0x50>
  801bb7:	39 cf                	cmp    %ecx,%edi
  801bb9:	77 65                	ja     801c20 <__udivdi3+0x8c>
  801bbb:	89 fd                	mov    %edi,%ebp
  801bbd:	85 ff                	test   %edi,%edi
  801bbf:	75 0b                	jne    801bcc <__udivdi3+0x38>
  801bc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc6:	31 d2                	xor    %edx,%edx
  801bc8:	f7 f7                	div    %edi
  801bca:	89 c5                	mov    %eax,%ebp
  801bcc:	31 d2                	xor    %edx,%edx
  801bce:	89 c8                	mov    %ecx,%eax
  801bd0:	f7 f5                	div    %ebp
  801bd2:	89 c1                	mov    %eax,%ecx
  801bd4:	89 d8                	mov    %ebx,%eax
  801bd6:	f7 f5                	div    %ebp
  801bd8:	89 cf                	mov    %ecx,%edi
  801bda:	89 fa                	mov    %edi,%edx
  801bdc:	83 c4 1c             	add    $0x1c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    
  801be4:	39 ce                	cmp    %ecx,%esi
  801be6:	77 28                	ja     801c10 <__udivdi3+0x7c>
  801be8:	0f bd fe             	bsr    %esi,%edi
  801beb:	83 f7 1f             	xor    $0x1f,%edi
  801bee:	75 40                	jne    801c30 <__udivdi3+0x9c>
  801bf0:	39 ce                	cmp    %ecx,%esi
  801bf2:	72 0a                	jb     801bfe <__udivdi3+0x6a>
  801bf4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bf8:	0f 87 9e 00 00 00    	ja     801c9c <__udivdi3+0x108>
  801bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801c03:	89 fa                	mov    %edi,%edx
  801c05:	83 c4 1c             	add    $0x1c,%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5f                   	pop    %edi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    
  801c0d:	8d 76 00             	lea    0x0(%esi),%esi
  801c10:	31 ff                	xor    %edi,%edi
  801c12:	31 c0                	xor    %eax,%eax
  801c14:	89 fa                	mov    %edi,%edx
  801c16:	83 c4 1c             	add    $0x1c,%esp
  801c19:	5b                   	pop    %ebx
  801c1a:	5e                   	pop    %esi
  801c1b:	5f                   	pop    %edi
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    
  801c1e:	66 90                	xchg   %ax,%ax
  801c20:	89 d8                	mov    %ebx,%eax
  801c22:	f7 f7                	div    %edi
  801c24:	31 ff                	xor    %edi,%edi
  801c26:	89 fa                	mov    %edi,%edx
  801c28:	83 c4 1c             	add    $0x1c,%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    
  801c30:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c35:	89 eb                	mov    %ebp,%ebx
  801c37:	29 fb                	sub    %edi,%ebx
  801c39:	89 f9                	mov    %edi,%ecx
  801c3b:	d3 e6                	shl    %cl,%esi
  801c3d:	89 c5                	mov    %eax,%ebp
  801c3f:	88 d9                	mov    %bl,%cl
  801c41:	d3 ed                	shr    %cl,%ebp
  801c43:	89 e9                	mov    %ebp,%ecx
  801c45:	09 f1                	or     %esi,%ecx
  801c47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c4b:	89 f9                	mov    %edi,%ecx
  801c4d:	d3 e0                	shl    %cl,%eax
  801c4f:	89 c5                	mov    %eax,%ebp
  801c51:	89 d6                	mov    %edx,%esi
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 ee                	shr    %cl,%esi
  801c57:	89 f9                	mov    %edi,%ecx
  801c59:	d3 e2                	shl    %cl,%edx
  801c5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5f:	88 d9                	mov    %bl,%cl
  801c61:	d3 e8                	shr    %cl,%eax
  801c63:	09 c2                	or     %eax,%edx
  801c65:	89 d0                	mov    %edx,%eax
  801c67:	89 f2                	mov    %esi,%edx
  801c69:	f7 74 24 0c          	divl   0xc(%esp)
  801c6d:	89 d6                	mov    %edx,%esi
  801c6f:	89 c3                	mov    %eax,%ebx
  801c71:	f7 e5                	mul    %ebp
  801c73:	39 d6                	cmp    %edx,%esi
  801c75:	72 19                	jb     801c90 <__udivdi3+0xfc>
  801c77:	74 0b                	je     801c84 <__udivdi3+0xf0>
  801c79:	89 d8                	mov    %ebx,%eax
  801c7b:	31 ff                	xor    %edi,%edi
  801c7d:	e9 58 ff ff ff       	jmp    801bda <__udivdi3+0x46>
  801c82:	66 90                	xchg   %ax,%ax
  801c84:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c88:	89 f9                	mov    %edi,%ecx
  801c8a:	d3 e2                	shl    %cl,%edx
  801c8c:	39 c2                	cmp    %eax,%edx
  801c8e:	73 e9                	jae    801c79 <__udivdi3+0xe5>
  801c90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c93:	31 ff                	xor    %edi,%edi
  801c95:	e9 40 ff ff ff       	jmp    801bda <__udivdi3+0x46>
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	31 c0                	xor    %eax,%eax
  801c9e:	e9 37 ff ff ff       	jmp    801bda <__udivdi3+0x46>
  801ca3:	90                   	nop

00801ca4 <__umoddi3>:
  801ca4:	55                   	push   %ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 1c             	sub    $0x1c,%esp
  801cab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801caf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cbf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cc3:	89 f3                	mov    %esi,%ebx
  801cc5:	89 fa                	mov    %edi,%edx
  801cc7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ccb:	89 34 24             	mov    %esi,(%esp)
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	75 1a                	jne    801cec <__umoddi3+0x48>
  801cd2:	39 f7                	cmp    %esi,%edi
  801cd4:	0f 86 a2 00 00 00    	jbe    801d7c <__umoddi3+0xd8>
  801cda:	89 c8                	mov    %ecx,%eax
  801cdc:	89 f2                	mov    %esi,%edx
  801cde:	f7 f7                	div    %edi
  801ce0:	89 d0                	mov    %edx,%eax
  801ce2:	31 d2                	xor    %edx,%edx
  801ce4:	83 c4 1c             	add    $0x1c,%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5f                   	pop    %edi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    
  801cec:	39 f0                	cmp    %esi,%eax
  801cee:	0f 87 ac 00 00 00    	ja     801da0 <__umoddi3+0xfc>
  801cf4:	0f bd e8             	bsr    %eax,%ebp
  801cf7:	83 f5 1f             	xor    $0x1f,%ebp
  801cfa:	0f 84 ac 00 00 00    	je     801dac <__umoddi3+0x108>
  801d00:	bf 20 00 00 00       	mov    $0x20,%edi
  801d05:	29 ef                	sub    %ebp,%edi
  801d07:	89 fe                	mov    %edi,%esi
  801d09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	d3 e0                	shl    %cl,%eax
  801d11:	89 d7                	mov    %edx,%edi
  801d13:	89 f1                	mov    %esi,%ecx
  801d15:	d3 ef                	shr    %cl,%edi
  801d17:	09 c7                	or     %eax,%edi
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	d3 e2                	shl    %cl,%edx
  801d1d:	89 14 24             	mov    %edx,(%esp)
  801d20:	89 d8                	mov    %ebx,%eax
  801d22:	d3 e0                	shl    %cl,%eax
  801d24:	89 c2                	mov    %eax,%edx
  801d26:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d2a:	d3 e0                	shl    %cl,%eax
  801d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d30:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d34:	89 f1                	mov    %esi,%ecx
  801d36:	d3 e8                	shr    %cl,%eax
  801d38:	09 d0                	or     %edx,%eax
  801d3a:	d3 eb                	shr    %cl,%ebx
  801d3c:	89 da                	mov    %ebx,%edx
  801d3e:	f7 f7                	div    %edi
  801d40:	89 d3                	mov    %edx,%ebx
  801d42:	f7 24 24             	mull   (%esp)
  801d45:	89 c6                	mov    %eax,%esi
  801d47:	89 d1                	mov    %edx,%ecx
  801d49:	39 d3                	cmp    %edx,%ebx
  801d4b:	0f 82 87 00 00 00    	jb     801dd8 <__umoddi3+0x134>
  801d51:	0f 84 91 00 00 00    	je     801de8 <__umoddi3+0x144>
  801d57:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d5b:	29 f2                	sub    %esi,%edx
  801d5d:	19 cb                	sbb    %ecx,%ebx
  801d5f:	89 d8                	mov    %ebx,%eax
  801d61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d65:	d3 e0                	shl    %cl,%eax
  801d67:	89 e9                	mov    %ebp,%ecx
  801d69:	d3 ea                	shr    %cl,%edx
  801d6b:	09 d0                	or     %edx,%eax
  801d6d:	89 e9                	mov    %ebp,%ecx
  801d6f:	d3 eb                	shr    %cl,%ebx
  801d71:	89 da                	mov    %ebx,%edx
  801d73:	83 c4 1c             	add    $0x1c,%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5e                   	pop    %esi
  801d78:	5f                   	pop    %edi
  801d79:	5d                   	pop    %ebp
  801d7a:	c3                   	ret    
  801d7b:	90                   	nop
  801d7c:	89 fd                	mov    %edi,%ebp
  801d7e:	85 ff                	test   %edi,%edi
  801d80:	75 0b                	jne    801d8d <__umoddi3+0xe9>
  801d82:	b8 01 00 00 00       	mov    $0x1,%eax
  801d87:	31 d2                	xor    %edx,%edx
  801d89:	f7 f7                	div    %edi
  801d8b:	89 c5                	mov    %eax,%ebp
  801d8d:	89 f0                	mov    %esi,%eax
  801d8f:	31 d2                	xor    %edx,%edx
  801d91:	f7 f5                	div    %ebp
  801d93:	89 c8                	mov    %ecx,%eax
  801d95:	f7 f5                	div    %ebp
  801d97:	89 d0                	mov    %edx,%eax
  801d99:	e9 44 ff ff ff       	jmp    801ce2 <__umoddi3+0x3e>
  801d9e:	66 90                	xchg   %ax,%ax
  801da0:	89 c8                	mov    %ecx,%eax
  801da2:	89 f2                	mov    %esi,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	3b 04 24             	cmp    (%esp),%eax
  801daf:	72 06                	jb     801db7 <__umoddi3+0x113>
  801db1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801db5:	77 0f                	ja     801dc6 <__umoddi3+0x122>
  801db7:	89 f2                	mov    %esi,%edx
  801db9:	29 f9                	sub    %edi,%ecx
  801dbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dbf:	89 14 24             	mov    %edx,(%esp)
  801dc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dca:	8b 14 24             	mov    (%esp),%edx
  801dcd:	83 c4 1c             	add    $0x1c,%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5f                   	pop    %edi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    
  801dd5:	8d 76 00             	lea    0x0(%esi),%esi
  801dd8:	2b 04 24             	sub    (%esp),%eax
  801ddb:	19 fa                	sbb    %edi,%edx
  801ddd:	89 d1                	mov    %edx,%ecx
  801ddf:	89 c6                	mov    %eax,%esi
  801de1:	e9 71 ff ff ff       	jmp    801d57 <__umoddi3+0xb3>
  801de6:	66 90                	xchg   %ax,%ax
  801de8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dec:	72 ea                	jb     801dd8 <__umoddi3+0x134>
  801dee:	89 d9                	mov    %ebx,%ecx
  801df0:	e9 62 ff ff ff       	jmp    801d57 <__umoddi3+0xb3>
