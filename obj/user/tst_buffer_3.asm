
obj/user/tst_buffer_3:     file format elf32-i386


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
  800031:	e8 82 02 00 00       	call   8002b8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
//		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}
	int kilo = 1024;
  80003f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int Mega = 1024*1024;
  800046:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)

	{
		int freeFrames = sys_calculate_free_frames() ;
  80004d:	e8 b3 18 00 00       	call   801905 <sys_calculate_free_frames>
  800052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int origFreeFrames = freeFrames ;
  800055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800058:	89 45 e0             	mov    %eax,-0x20(%ebp)

		uint32 size = 10*Mega;
  80005b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	c1 e0 02             	shl    $0x2,%eax
  800063:	01 d0                	add    %edx,%eax
  800065:	01 c0                	add    %eax,%eax
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	ff 75 dc             	pushl  -0x24(%ebp)
  800070:	e8 bb 15 00 00       	call   801630 <malloc>
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	89 45 d8             	mov    %eax,-0x28(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80007b:	e8 85 18 00 00       	call   801905 <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 96 18 00 00       	call   80191e <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 40 37 80 00       	push   $0x803740
  80009c:	e8 07 06 00 00       	call   8006a8 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp
		x[1]=-1;
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	40                   	inc    %eax
  8000a8:	c6 00 ff             	movb   $0xff,(%eax)

		x[1*Mega] = -1;
  8000ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	c6 00 ff             	movb   $0xff,(%eax)

		int i = x[2*Mega];
  8000b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b9:	01 c0                	add    %eax,%eax
  8000bb:	89 c2                	mov    %eax,%edx
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	01 d0                	add    %edx,%eax
  8000c2:	8a 00                	mov    (%eax),%al
  8000c4:	0f b6 c0             	movzbl %al,%eax
  8000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		int j = x[3*Mega];
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	89 c2                	mov    %eax,%edx
  8000cf:	01 d2                	add    %edx,%edx
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	8a 00                	mov    (%eax),%al
  8000dc:	0f b6 c0             	movzbl %al,%eax
  8000df:	89 45 d0             	mov    %eax,-0x30(%ebp)

		x[4*Mega] = -1;
  8000e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e5:	c1 e0 02             	shl    $0x2,%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega] = -1;
  8000f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000f5:	89 d0                	mov    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	89 c2                	mov    %eax,%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c6 00 ff             	movb   $0xff,(%eax)

		x[6*Mega] = -1;
  800106:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800109:	89 d0                	mov    %edx,%eax
  80010b:	01 c0                	add    %eax,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	01 c0                	add    %eax,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 ff             	movb   $0xff,(%eax)

		x[7*Mega] = -1;
  80011b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80011e:	89 d0                	mov    %edx,%eax
  800120:	01 c0                	add    %eax,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	01 c0                	add    %eax,%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	c1 e0 03             	shl    $0x3,%eax
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013d:	01 d0                	add    %edx,%eax
  80013f:	c6 00 ff             	movb   $0xff,(%eax)

		x[9*Mega] = -1;
  800142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800145:	89 d0                	mov    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c6 00 ff             	movb   $0xff,(%eax)

		free(x);
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	ff 75 d8             	pushl  -0x28(%ebp)
  80015c:	e8 4a 15 00 00       	call   8016ab <free>
  800161:	83 c4 10             	add    $0x10,%esp

		int numOFEmptyLocInWS = 0;
  800164:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80016b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800172:	eb 79                	jmp    8001ed <_main+0x1b5>
		{
			if (myEnv->__uptr_pws[i].empty)
  800174:	a1 20 50 80 00       	mov    0x805020,%eax
  800179:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80017f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800182:	89 d0                	mov    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	c1 e0 03             	shl    $0x3,%eax
  80018b:	01 c8                	add    %ecx,%eax
  80018d:	8a 40 04             	mov    0x4(%eax),%al
  800190:	84 c0                	test   %al,%al
  800192:	74 05                	je     800199 <_main+0x161>
			{
				numOFEmptyLocInWS++;
  800194:	ff 45 f0             	incl   -0x10(%ebp)
  800197:	eb 51                	jmp    8001ea <_main+0x1b2>
			}
			else
			{
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800199:	a1 20 50 80 00       	mov    0x805020,%eax
  80019e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a7:	89 d0                	mov    %edx,%eax
  8001a9:	01 c0                	add    %eax,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	c1 e0 03             	shl    $0x3,%eax
  8001b0:	01 c8                	add    %ecx,%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
  8001c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	79 21                	jns    8001ea <_main+0x1b2>
  8001c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cc:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001d4:	76 14                	jbe    8001ea <_main+0x1b2>
					panic("freeMem didn't remove its page(s) from the WS");
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 60 37 80 00       	push   $0x803760
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 8e 37 80 00       	push   $0x80378e
  8001e5:	e8 0a 02 00 00       	call   8003f4 <_panic>
		x[9*Mega] = -1;

		free(x);

		int numOFEmptyLocInWS = 0;
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8001ea:	ff 45 f4             	incl   -0xc(%ebp)
  8001ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f2:	8b 50 74             	mov    0x74(%eax),%edx
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	39 c2                	cmp    %eax,%edx
  8001fa:	0f 87 74 ff ff ff    	ja     800174 <_main+0x13c>
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
					panic("freeMem didn't remove its page(s) from the WS");
			}
		}
		int free_frames = sys_calculate_free_frames();
  800200:	e8 00 17 00 00       	call   801905 <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 11 17 00 00       	call   80191e <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 09 17 00 00       	call   80191e <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 e9 16 00 00       	call   801905 <sys_calculate_free_frames>
  80021c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80021f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800222:	89 d1                	mov    %edx,%ecx
  800224:	29 c1                	sub    %eax,%ecx
  800226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022c:	01 d0                	add    %edx,%eax
  80022e:	39 c1                	cmp    %eax,%ecx
  800230:	74 14                	je     800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 a4 37 80 00       	push   $0x8037a4
  80023a:	6a 53                	push   $0x53
  80023c:	68 8e 37 80 00       	push   $0x80378e
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 f8 37 80 00       	push   $0x8037f8
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 54 38 80 00       	push   $0x803854
  80025e:	e8 45 04 00 00       	call   8006a8 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800266:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	c6 00 ff             	movb   $0xff,(%eax)

			x[1*Mega] = -1;
  80026d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800273:	01 d0                	add    %edx,%eax
  800275:	c6 00 ff             	movb   $0xff,(%eax)

			int i = x[2*Mega];
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	01 c0                	add    %eax,%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800282:	01 d0                	add    %edx,%eax
  800284:	8a 00                	mov    (%eax),%al
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	89 45 bc             	mov    %eax,-0x44(%ebp)

			int j = x[3*Mega];
  80028c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028f:	89 c2                	mov    %eax,%edx
  800291:	01 d2                	add    %edx,%edx
  800293:	01 d0                	add    %edx,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8a 00                	mov    (%eax),%al
  80029e:	0f b6 c0             	movzbl %al,%eax
  8002a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for stack pages\n");
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 38 39 80 00       	push   $0x803938
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 8e 37 80 00       	push   $0x80378e
  8002b3:	e8 3c 01 00 00       	call   8003f4 <_panic>

008002b8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002be:	e8 22 19 00 00       	call   801be5 <sys_getenvindex>
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c9:	89 d0                	mov    %edx,%eax
  8002cb:	c1 e0 03             	shl    $0x3,%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	01 c0                	add    %eax,%eax
  8002d2:	01 d0                	add    %edx,%eax
  8002d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002db:	01 d0                	add    %edx,%eax
  8002dd:	c1 e0 04             	shl    $0x4,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ef:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002f5:	84 c0                	test   %al,%al
  8002f7:	74 0f                	je     800308 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002fe:	05 5c 05 00 00       	add    $0x55c,%eax
  800303:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030c:	7e 0a                	jle    800318 <libmain+0x60>
		binaryname = argv[0];
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	8b 00                	mov    (%eax),%eax
  800313:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 12 fd ff ff       	call   800038 <_main>
  800326:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800329:	e8 c4 16 00 00       	call   8019f2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 58 3a 80 00       	push   $0x803a58
  800336:	e8 6d 03 00 00       	call   8006a8 <cprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033e:	a1 20 50 80 00       	mov    0x805020,%eax
  800343:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800349:	a1 20 50 80 00       	mov    0x805020,%eax
  80034e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800354:	83 ec 04             	sub    $0x4,%esp
  800357:	52                   	push   %edx
  800358:	50                   	push   %eax
  800359:	68 80 3a 80 00       	push   $0x803a80
  80035e:	e8 45 03 00 00       	call   8006a8 <cprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800366:	a1 20 50 80 00       	mov    0x805020,%eax
  80036b:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800371:	a1 20 50 80 00       	mov    0x805020,%eax
  800376:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80037c:	a1 20 50 80 00       	mov    0x805020,%eax
  800381:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800387:	51                   	push   %ecx
  800388:	52                   	push   %edx
  800389:	50                   	push   %eax
  80038a:	68 a8 3a 80 00       	push   $0x803aa8
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 50 80 00       	mov    0x805020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 00 3b 80 00       	push   $0x803b00
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 58 3a 80 00       	push   $0x803a58
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 44 16 00 00       	call   801a0c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003c8:	e8 19 00 00 00       	call   8003e6 <exit>
}
  8003cd:	90                   	nop
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d6:	83 ec 0c             	sub    $0xc,%esp
  8003d9:	6a 00                	push   $0x0
  8003db:	e8 d1 17 00 00       	call   801bb1 <sys_destroy_env>
  8003e0:	83 c4 10             	add    $0x10,%esp
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <exit>:

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ec:	e8 26 18 00 00       	call   801c17 <sys_exit_env>
}
  8003f1:	90                   	nop
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800403:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800408:	85 c0                	test   %eax,%eax
  80040a:	74 16                	je     800422 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	50                   	push   %eax
  800415:	68 14 3b 80 00       	push   $0x803b14
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 50 80 00       	mov    0x805000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 19 3b 80 00       	push   $0x803b19
  800433:	e8 70 02 00 00       	call   8006a8 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 f4             	pushl  -0xc(%ebp)
  800444:	50                   	push   %eax
  800445:	e8 f3 01 00 00       	call   80063d <vcprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	6a 00                	push   $0x0
  800452:	68 35 3b 80 00       	push   $0x803b35
  800457:	e8 e1 01 00 00       	call   80063d <vcprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80045f:	e8 82 ff ff ff       	call   8003e6 <exit>

	// should not return here
	while (1) ;
  800464:	eb fe                	jmp    800464 <_panic+0x70>

00800466 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046c:	a1 20 50 80 00       	mov    0x805020,%eax
  800471:	8b 50 74             	mov    0x74(%eax),%edx
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 38 3b 80 00       	push   $0x803b38
  800483:	6a 26                	push   $0x26
  800485:	68 84 3b 80 00       	push   $0x803b84
  80048a:	e8 65 ff ff ff       	call   8003f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80048f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049d:	e9 c2 00 00 00       	jmp    800564 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	75 08                	jne    8004bf <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ba:	e9 a2 00 00 00       	jmp    800561 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004cd:	eb 69                	jmp    800538 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8a 40 04             	mov    0x4(%eax),%al
  8004eb:	84 c0                	test   %al,%al
  8004ed:	75 46                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 c8                	add    %ecx,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 c8                	add    %ecx,%eax
  800526:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	75 09                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80052c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800533:	eb 12                	jmp    800547 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800535:	ff 45 e8             	incl   -0x18(%ebp)
  800538:	a1 20 50 80 00       	mov    0x805020,%eax
  80053d:	8b 50 74             	mov    0x74(%eax),%edx
  800540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800543:	39 c2                	cmp    %eax,%edx
  800545:	77 88                	ja     8004cf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80054b:	75 14                	jne    800561 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 90 3b 80 00       	push   $0x803b90
  800555:	6a 3a                	push   $0x3a
  800557:	68 84 3b 80 00       	push   $0x803b84
  80055c:	e8 93 fe ff ff       	call   8003f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800561:	ff 45 f0             	incl   -0x10(%ebp)
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80056a:	0f 8c 32 ff ff ff    	jl     8004a2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800577:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057e:	eb 26                	jmp    8005a6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800580:	a1 20 50 80 00       	mov    0x805020,%eax
  800585:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8a 40 04             	mov    0x4(%eax),%al
  80059c:	3c 01                	cmp    $0x1,%al
  80059e:	75 03                	jne    8005a3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a3:	ff 45 e0             	incl   -0x20(%ebp)
  8005a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ab:	8b 50 74             	mov    0x74(%eax),%edx
  8005ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b1:	39 c2                	cmp    %eax,%edx
  8005b3:	77 cb                	ja     800580 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005bb:	74 14                	je     8005d1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 e4 3b 80 00       	push   $0x803be4
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 84 3b 80 00       	push   $0x803b84
  8005cc:	e8 23 fe ff ff       	call   8003f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	89 0a                	mov    %ecx,(%edx)
  8005e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ea:	88 d1                	mov    %dl,%cl
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fd:	75 2c                	jne    80062b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ff:	a0 24 50 80 00       	mov    0x805024,%al
  800604:	0f b6 c0             	movzbl %al,%eax
  800607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060a:	8b 12                	mov    (%edx),%edx
  80060c:	89 d1                	mov    %edx,%ecx
  80060e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800611:	83 c2 08             	add    $0x8,%edx
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	50                   	push   %eax
  800618:	51                   	push   %ecx
  800619:	52                   	push   %edx
  80061a:	e8 25 12 00 00       	call   801844 <sys_cputs>
  80061f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	8b 40 04             	mov    0x4(%eax),%eax
  800631:	8d 50 01             	lea    0x1(%eax),%edx
  800634:	8b 45 0c             	mov    0xc(%ebp),%eax
  800637:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063a:	90                   	nop
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800646:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064d:	00 00 00 
	b.cnt = 0;
  800650:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800657:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	ff 75 08             	pushl  0x8(%ebp)
  800660:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800666:	50                   	push   %eax
  800667:	68 d4 05 80 00       	push   $0x8005d4
  80066c:	e8 11 02 00 00       	call   800882 <vprintfmt>
  800671:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800674:	a0 24 50 80 00       	mov    0x805024,%al
  800679:	0f b6 c0             	movzbl %al,%eax
  80067c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	50                   	push   %eax
  800686:	52                   	push   %edx
  800687:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068d:	83 c0 08             	add    $0x8,%eax
  800690:	50                   	push   %eax
  800691:	e8 ae 11 00 00       	call   801844 <sys_cputs>
  800696:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800699:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8006a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ae:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8006b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	e8 73 ff ff ff       	call   80063d <vcprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006db:	e8 12 13 00 00       	call   8019f2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	e8 48 ff ff ff       	call   80063d <vcprintf>
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006fb:	e8 0c 13 00 00       	call   801a0c <sys_enable_interrupt>
	return cnt;
  800700:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800703:	c9                   	leave  
  800704:	c3                   	ret    

00800705 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	53                   	push   %ebx
  800709:	83 ec 14             	sub    $0x14,%esp
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800718:	8b 45 18             	mov    0x18(%ebp),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800723:	77 55                	ja     80077a <printnum+0x75>
  800725:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800728:	72 05                	jb     80072f <printnum+0x2a>
  80072a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072d:	77 4b                	ja     80077a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800732:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800735:	8b 45 18             	mov    0x18(%ebp),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	ff 75 f4             	pushl  -0xc(%ebp)
  800742:	ff 75 f0             	pushl  -0x10(%ebp)
  800745:	e8 7e 2d 00 00       	call   8034c8 <__udivdi3>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	ff 75 20             	pushl  0x20(%ebp)
  800753:	53                   	push   %ebx
  800754:	ff 75 18             	pushl  0x18(%ebp)
  800757:	52                   	push   %edx
  800758:	50                   	push   %eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	e8 a1 ff ff ff       	call   800705 <printnum>
  800764:	83 c4 20             	add    $0x20,%esp
  800767:	eb 1a                	jmp    800783 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 20             	pushl  0x20(%ebp)
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077a:	ff 4d 1c             	decl   0x1c(%ebp)
  80077d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800781:	7f e6                	jg     800769 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800783:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800786:	bb 00 00 00 00       	mov    $0x0,%ebx
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	53                   	push   %ebx
  800792:	51                   	push   %ecx
  800793:	52                   	push   %edx
  800794:	50                   	push   %eax
  800795:	e8 3e 2e 00 00       	call   8035d8 <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 54 3e 80 00       	add    $0x803e54,%eax
  8007a2:	8a 00                	mov    (%eax),%al
  8007a4:	0f be c0             	movsbl %al,%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
}
  8007b6:	90                   	nop
  8007b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c3:	7e 1c                	jle    8007e1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 08             	lea    0x8(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 08             	sub    $0x8,%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	eb 40                	jmp    800821 <getuint+0x65>
	else if (lflag)
  8007e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e5:	74 1e                	je     800805 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	8d 50 04             	lea    0x4(%eax),%edx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	89 10                	mov    %edx,(%eax)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	eb 1c                	jmp    800821 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	89 10                	mov    %edx,(%eax)
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800826:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082a:	7e 1c                	jle    800848 <getint+0x25>
		return va_arg(*ap, long long);
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	8d 50 08             	lea    0x8(%eax),%edx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	89 10                	mov    %edx,(%eax)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 e8 08             	sub    $0x8,%eax
  800841:	8b 50 04             	mov    0x4(%eax),%edx
  800844:	8b 00                	mov    (%eax),%eax
  800846:	eb 38                	jmp    800880 <getint+0x5d>
	else if (lflag)
  800848:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084c:	74 1a                	je     800868 <getint+0x45>
		return va_arg(*ap, long);
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	8d 50 04             	lea    0x4(%eax),%edx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	89 10                	mov    %edx,(%eax)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	83 e8 04             	sub    $0x4,%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	99                   	cltd   
  800866:	eb 18                	jmp    800880 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	99                   	cltd   
}
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088a:	eb 17                	jmp    8008a3 <vprintfmt+0x21>
			if (ch == '\0')
  80088c:	85 db                	test   %ebx,%ebx
  80088e:	0f 84 af 03 00 00    	je     800c43 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	8d 50 01             	lea    0x1(%eax),%edx
  8008a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f b6 d8             	movzbl %al,%ebx
  8008b1:	83 fb 25             	cmp    $0x25,%ebx
  8008b4:	75 d6                	jne    80088c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d9:	8d 50 01             	lea    0x1(%eax),%edx
  8008dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	0f b6 d8             	movzbl %al,%ebx
  8008e4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e7:	83 f8 55             	cmp    $0x55,%eax
  8008ea:	0f 87 2b 03 00 00    	ja     800c1b <vprintfmt+0x399>
  8008f0:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
  8008f7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fd:	eb d7                	jmp    8008d6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ff:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800903:	eb d1                	jmp    8008d6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800905:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090f:	89 d0                	mov    %edx,%eax
  800911:	c1 e0 02             	shl    $0x2,%eax
  800914:	01 d0                	add    %edx,%eax
  800916:	01 c0                	add    %eax,%eax
  800918:	01 d8                	add    %ebx,%eax
  80091a:	83 e8 30             	sub    $0x30,%eax
  80091d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800920:	8b 45 10             	mov    0x10(%ebp),%eax
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800928:	83 fb 2f             	cmp    $0x2f,%ebx
  80092b:	7e 3e                	jle    80096b <vprintfmt+0xe9>
  80092d:	83 fb 39             	cmp    $0x39,%ebx
  800930:	7f 39                	jg     80096b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800932:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800935:	eb d5                	jmp    80090c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80094b:	eb 1f                	jmp    80096c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800951:	79 83                	jns    8008d6 <vprintfmt+0x54>
				width = 0;
  800953:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80095a:	e9 77 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800966:	e9 6b ff ff ff       	jmp    8008d6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80096b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800970:	0f 89 60 ff ff ff    	jns    8008d6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800983:	e9 4e ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800988:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80098b:	e9 46 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			break;
  8009b0:	e9 89 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	83 c0 04             	add    $0x4,%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	83 e8 04             	sub    $0x4,%eax
  8009c4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	79 02                	jns    8009cc <vprintfmt+0x14a>
				err = -err;
  8009ca:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009cc:	83 fb 64             	cmp    $0x64,%ebx
  8009cf:	7f 0b                	jg     8009dc <vprintfmt+0x15a>
  8009d1:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 65 3e 80 00       	push   $0x803e65
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 5e 02 00 00       	call   800c4b <printfmt>
  8009ed:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f0:	e9 49 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f5:	56                   	push   %esi
  8009f6:	68 6e 3e 80 00       	push   $0x803e6e
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	ff 75 08             	pushl  0x8(%ebp)
  800a01:	e8 45 02 00 00       	call   800c4b <printfmt>
  800a06:	83 c4 10             	add    $0x10,%esp
			break;
  800a09:	e9 30 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	83 c0 04             	add    $0x4,%eax
  800a14:	89 45 14             	mov    %eax,0x14(%ebp)
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 e8 04             	sub    $0x4,%eax
  800a1d:	8b 30                	mov    (%eax),%esi
  800a1f:	85 f6                	test   %esi,%esi
  800a21:	75 05                	jne    800a28 <vprintfmt+0x1a6>
				p = "(null)";
  800a23:	be 71 3e 80 00       	mov    $0x803e71,%esi
			if (width > 0 && padc != '-')
  800a28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2c:	7e 6d                	jle    800a9b <vprintfmt+0x219>
  800a2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a32:	74 67                	je     800a9b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	50                   	push   %eax
  800a3b:	56                   	push   %esi
  800a3c:	e8 0c 03 00 00       	call   800d4d <strnlen>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a47:	eb 16                	jmp    800a5f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a49:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	7f e4                	jg     800a49 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a65:	eb 34                	jmp    800a9b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a6b:	74 1c                	je     800a89 <vprintfmt+0x207>
  800a6d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a70:	7e 05                	jle    800a77 <vprintfmt+0x1f5>
  800a72:	83 fb 7e             	cmp    $0x7e,%ebx
  800a75:	7e 12                	jle    800a89 <vprintfmt+0x207>
					putch('?', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 3f                	push   $0x3f
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	eb 0f                	jmp    800a98 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	53                   	push   %ebx
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a98:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9b:	89 f0                	mov    %esi,%eax
  800a9d:	8d 70 01             	lea    0x1(%eax),%esi
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f be d8             	movsbl %al,%ebx
  800aa5:	85 db                	test   %ebx,%ebx
  800aa7:	74 24                	je     800acd <vprintfmt+0x24b>
  800aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aad:	78 b8                	js     800a67 <vprintfmt+0x1e5>
  800aaf:	ff 4d e0             	decl   -0x20(%ebp)
  800ab2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab6:	79 af                	jns    800a67 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab8:	eb 13                	jmp    800acd <vprintfmt+0x24b>
				putch(' ', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 20                	push   $0x20
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aca:	ff 4d e4             	decl   -0x1c(%ebp)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7f e7                	jg     800aba <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad3:	e9 66 01 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ade:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	e8 3c fd ff ff       	call   800823 <getint>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	85 d2                	test   %edx,%edx
  800af8:	79 23                	jns    800b1d <vprintfmt+0x29b>
				putch('-', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 2d                	push   $0x2d
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b10:	f7 d8                	neg    %eax
  800b12:	83 d2 00             	adc    $0x0,%edx
  800b15:	f7 da                	neg    %edx
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b24:	e9 bc 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 84 fc ff ff       	call   8007bc <getuint>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b41:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b48:	e9 98 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 58                	push   $0x58
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 58                	push   $0x58
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 58                	push   $0x58
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			break;
  800b7d:	e9 bc 00 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	6a 30                	push   $0x30
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 78                	push   $0x78
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	83 e8 04             	sub    $0x4,%eax
  800bb1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc4:	eb 1f                	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcf:	50                   	push   %eax
  800bd0:	e8 e7 fb ff ff       	call   8007bc <getuint>
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	52                   	push   %edx
  800bf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 00 fb ff ff       	call   800705 <printnum>
  800c05:	83 c4 20             	add    $0x20,%esp
			break;
  800c08:	eb 34                	jmp    800c3e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	ff d0                	call   *%eax
  800c16:	83 c4 10             	add    $0x10,%esp
			break;
  800c19:	eb 23                	jmp    800c3e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 25                	push   $0x25
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	eb 03                	jmp    800c33 <vprintfmt+0x3b1>
  800c30:	ff 4d 10             	decl   0x10(%ebp)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	48                   	dec    %eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	3c 25                	cmp    $0x25,%al
  800c3b:	75 f3                	jne    800c30 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c3d:	90                   	nop
		}
	}
  800c3e:	e9 47 fc ff ff       	jmp    80088a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c43:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c51:	8d 45 10             	lea    0x10(%ebp),%eax
  800c54:	83 c0 04             	add    $0x4,%eax
  800c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c60:	50                   	push   %eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 16 fc ff ff       	call   800882 <vprintfmt>
  800c6c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6f:	90                   	nop
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8b 40 08             	mov    0x8(%eax),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8b 10                	mov    (%eax),%edx
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 40 04             	mov    0x4(%eax),%eax
  800c8f:	39 c2                	cmp    %eax,%edx
  800c91:	73 12                	jae    800ca5 <sprintputch+0x33>
		*b->buf++ = ch;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	89 0a                	mov    %ecx,(%edx)
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	88 10                	mov    %dl,(%eax)
}
  800ca5:	90                   	nop
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ccd:	74 06                	je     800cd5 <vsnprintf+0x2d>
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	7f 07                	jg     800cdc <vsnprintf+0x34>
		return -E_INVAL;
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	eb 20                	jmp    800cfc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdc:	ff 75 14             	pushl  0x14(%ebp)
  800cdf:	ff 75 10             	pushl  0x10(%ebp)
  800ce2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	68 72 0c 80 00       	push   $0x800c72
  800ceb:	e8 92 fb ff ff       	call   800882 <vprintfmt>
  800cf0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 89 ff ff ff       	call   800ca8 <vsnprintf>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d37:	eb 06                	jmp    800d3f <strlen+0x15>
		n++;
  800d39:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3c:	ff 45 08             	incl   0x8(%ebp)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	84 c0                	test   %al,%al
  800d46:	75 f1                	jne    800d39 <strlen+0xf>
		n++;
	return n;
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5a:	eb 09                	jmp    800d65 <strnlen+0x18>
		n++;
  800d5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	ff 4d 0c             	decl   0xc(%ebp)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 09                	je     800d74 <strnlen+0x27>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	75 e8                	jne    800d5c <strnlen+0xf>
		n++;
	return n;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d85:	90                   	nop
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	84 c0                	test   %al,%al
  800da0:	75 e4                	jne    800d86 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dba:	eb 1f                	jmp    800ddb <strncpy+0x34>
		*dst++ = *src;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc8:	8a 12                	mov    (%edx),%dl
  800dca:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	74 03                	je     800dd8 <strncpy+0x31>
			src++;
  800dd5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd8:	ff 45 fc             	incl   -0x4(%ebp)
  800ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dde:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de1:	72 d9                	jb     800dbc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df8:	74 30                	je     800e2a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfa:	eb 16                	jmp    800e12 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 08             	mov    %edx,0x8(%ebp)
  800e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0e:	8a 12                	mov    (%edx),%dl
  800e10:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e12:	ff 4d 10             	decl   0x10(%ebp)
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 09                	je     800e24 <strlcpy+0x3c>
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 d8                	jne    800dfc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e39:	eb 06                	jmp    800e41 <strcmp+0xb>
		p++, q++;
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 0e                	je     800e58 <strcmp+0x22>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	38 c2                	cmp    %al,%dl
  800e56:	74 e3                	je     800e3b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	0f b6 d0             	movzbl %al,%edx
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 c0             	movzbl %al,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 d0                	mov    %edx,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e71:	eb 09                	jmp    800e7c <strncmp+0xe>
		n--, p++, q++;
  800e73:	ff 4d 10             	decl   0x10(%ebp)
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e80:	74 17                	je     800e99 <strncmp+0x2b>
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	74 0e                	je     800e99 <strncmp+0x2b>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 da                	je     800e73 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	75 07                	jne    800ea6 <strncmp+0x38>
		return 0;
  800e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea4:	eb 14                	jmp    800eba <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 d0             	movzbl %al,%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 c0             	movzbl %al,%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec8:	eb 12                	jmp    800edc <strchr+0x20>
		if (*s == c)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed2:	75 05                	jne    800ed9 <strchr+0x1d>
			return (char *) s;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	eb 11                	jmp    800eea <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	75 e5                	jne    800eca <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 04             	sub    $0x4,%esp
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef8:	eb 0d                	jmp    800f07 <strfind+0x1b>
		if (*s == c)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f02:	74 0e                	je     800f12 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f04:	ff 45 08             	incl   0x8(%ebp)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	84 c0                	test   %al,%al
  800f0e:	75 ea                	jne    800efa <strfind+0xe>
  800f10:	eb 01                	jmp    800f13 <strfind+0x27>
		if (*s == c)
			break;
  800f12:	90                   	nop
	return (char *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f2a:	eb 0e                	jmp    800f3a <memset+0x22>
		*p++ = c;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	8d 50 01             	lea    0x1(%eax),%edx
  800f32:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f38:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f41:	79 e9                	jns    800f2c <memset+0x14>
		*p++ = c;

	return v;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x2a>
		*d++ = *s++;
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80123c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801244:	f7 e9                	imul   %ecx
  801246:	c1 fa 02             	sar    $0x2,%edx
  801249:	89 c8                	mov    %ecx,%eax
  80124b:	c1 f8 1f             	sar    $0x1f,%eax
  80124e:	29 c2                	sub    %eax,%edx
  801250:	89 d0                	mov    %edx,%eax
  801252:	c1 e0 02             	shl    $0x2,%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	01 c0                	add    %eax,%eax
  801259:	29 c1                	sub    %eax,%ecx
  80125b:	89 ca                	mov    %ecx,%edx
  80125d:	85 d2                	test   %edx,%edx
  80125f:	75 9c                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801268:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126b:	48                   	dec    %eax
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801273:	74 3d                	je     8012b2 <ltostr+0xe2>
		start = 1 ;
  801275:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127c:	eb 34                	jmp    8012b2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80127e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c2                	add    %eax,%edx
  801293:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c8                	add    %ecx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012aa:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ac:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012af:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b8:	7c c4                	jl     80127e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c5:	90                   	nop
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ce:	ff 75 08             	pushl  0x8(%ebp)
  8012d1:	e8 54 fa ff ff       	call   800d2a <strlen>
  8012d6:	83 c4 04             	add    $0x4,%esp
  8012d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 46 fa ff ff       	call   800d2a <strlen>
  8012e4:	83 c4 04             	add    $0x4,%esp
  8012e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f8:	eb 17                	jmp    801311 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 c2                	add    %eax,%edx
  801302:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	01 c8                	add    %ecx,%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130e:	ff 45 fc             	incl   -0x4(%ebp)
  801311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801314:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801317:	7c e1                	jl     8012fa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801327:	eb 1f                	jmp    801348 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801332:	89 c2                	mov    %eax,%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 c2                	add    %eax,%edx
  801339:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 c8                	add    %ecx,%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801345:	ff 45 f8             	incl   -0x8(%ebp)
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134e:	7c d9                	jl     801329 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801350:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c6 00 00             	movb   $0x0,(%eax)
}
  80135b:	90                   	nop
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	8b 00                	mov    (%eax),%eax
  80136f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801381:	eb 0c                	jmp    80138f <strsplit+0x31>
			*string++ = 0;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8d 50 01             	lea    0x1(%eax),%edx
  801389:	89 55 08             	mov    %edx,0x8(%ebp)
  80138c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	84 c0                	test   %al,%al
  801396:	74 18                	je     8013b0 <strsplit+0x52>
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f be c0             	movsbl %al,%eax
  8013a0:	50                   	push   %eax
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 13 fb ff ff       	call   800ebc <strchr>
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 d3                	jne    801383 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	84 c0                	test   %al,%al
  8013b7:	74 5a                	je     801413 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	83 f8 0f             	cmp    $0xf,%eax
  8013c1:	75 07                	jne    8013ca <strsplit+0x6c>
		{
			return 0;
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c8:	eb 66                	jmp    801430 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d5:	89 0a                	mov    %ecx,(%edx)
  8013d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013de:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e1:	01 c2                	add    %eax,%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e8:	eb 03                	jmp    8013ed <strsplit+0x8f>
			string++;
  8013ea:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	84 c0                	test   %al,%al
  8013f4:	74 8b                	je     801381 <strsplit+0x23>
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f be c0             	movsbl %al,%eax
  8013fe:	50                   	push   %eax
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	e8 b5 fa ff ff       	call   800ebc <strchr>
  801407:	83 c4 08             	add    $0x8,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 dc                	je     8013ea <strsplit+0x8c>
			string++;
	}
  80140e:	e9 6e ff ff ff       	jmp    801381 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801413:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801438:	a1 04 50 80 00       	mov    0x805004,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 1f                	je     801460 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801441:	e8 1d 00 00 00       	call   801463 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	68 d0 3f 80 00       	push   $0x803fd0
  80144e:	e8 55 f2 ff ff       	call   8006a8 <cprintf>
  801453:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801456:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80145d:	00 00 00 
	}
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801469:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801470:	00 00 00 
  801473:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80147a:	00 00 00 
  80147d:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801484:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801487:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80148e:	00 00 00 
  801491:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801498:	00 00 00 
  80149b:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8014a2:	00 00 00 
	uint32 arr_size = 0;
  8014a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8014ac:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014bb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014c0:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8014c5:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8014cc:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8014cf:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8014d6:	a1 20 51 80 00       	mov    0x805120,%eax
  8014db:	c1 e0 04             	shl    $0x4,%eax
  8014de:	89 c2                	mov    %eax,%edx
  8014e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e3:	01 d0                	add    %edx,%eax
  8014e5:	48                   	dec    %eax
  8014e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8014e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f1:	f7 75 ec             	divl   -0x14(%ebp)
  8014f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014f7:	29 d0                	sub    %edx,%eax
  8014f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8014fc:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801506:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80150b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	6a 06                	push   $0x6
  801515:	ff 75 f4             	pushl  -0xc(%ebp)
  801518:	50                   	push   %eax
  801519:	e8 6a 04 00 00       	call   801988 <sys_allocate_chunk>
  80151e:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801521:	a1 20 51 80 00       	mov    0x805120,%eax
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	50                   	push   %eax
  80152a:	e8 df 0a 00 00       	call   80200e <initialize_MemBlocksList>
  80152f:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801532:	a1 48 51 80 00       	mov    0x805148,%eax
  801537:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80153a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801547:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80154e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801552:	75 14                	jne    801568 <initialize_dyn_block_system+0x105>
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	68 f5 3f 80 00       	push   $0x803ff5
  80155c:	6a 33                	push   $0x33
  80155e:	68 13 40 80 00       	push   $0x804013
  801563:	e8 8c ee ff ff       	call   8003f4 <_panic>
  801568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156b:	8b 00                	mov    (%eax),%eax
  80156d:	85 c0                	test   %eax,%eax
  80156f:	74 10                	je     801581 <initialize_dyn_block_system+0x11e>
  801571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801574:	8b 00                	mov    (%eax),%eax
  801576:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801579:	8b 52 04             	mov    0x4(%edx),%edx
  80157c:	89 50 04             	mov    %edx,0x4(%eax)
  80157f:	eb 0b                	jmp    80158c <initialize_dyn_block_system+0x129>
  801581:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801584:	8b 40 04             	mov    0x4(%eax),%eax
  801587:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80158c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158f:	8b 40 04             	mov    0x4(%eax),%eax
  801592:	85 c0                	test   %eax,%eax
  801594:	74 0f                	je     8015a5 <initialize_dyn_block_system+0x142>
  801596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801599:	8b 40 04             	mov    0x4(%eax),%eax
  80159c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80159f:	8b 12                	mov    (%edx),%edx
  8015a1:	89 10                	mov    %edx,(%eax)
  8015a3:	eb 0a                	jmp    8015af <initialize_dyn_block_system+0x14c>
  8015a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a8:	8b 00                	mov    (%eax),%eax
  8015aa:	a3 48 51 80 00       	mov    %eax,0x805148
  8015af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015c2:	a1 54 51 80 00       	mov    0x805154,%eax
  8015c7:	48                   	dec    %eax
  8015c8:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8015cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015d1:	75 14                	jne    8015e7 <initialize_dyn_block_system+0x184>
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	68 20 40 80 00       	push   $0x804020
  8015db:	6a 34                	push   $0x34
  8015dd:	68 13 40 80 00       	push   $0x804013
  8015e2:	e8 0d ee ff ff       	call   8003f4 <_panic>
  8015e7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8015ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f0:	89 10                	mov    %edx,(%eax)
  8015f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f5:	8b 00                	mov    (%eax),%eax
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	74 0d                	je     801608 <initialize_dyn_block_system+0x1a5>
  8015fb:	a1 38 51 80 00       	mov    0x805138,%eax
  801600:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801603:	89 50 04             	mov    %edx,0x4(%eax)
  801606:	eb 08                	jmp    801610 <initialize_dyn_block_system+0x1ad>
  801608:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801613:	a3 38 51 80 00       	mov    %eax,0x805138
  801618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801622:	a1 44 51 80 00       	mov    0x805144,%eax
  801627:	40                   	inc    %eax
  801628:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80162d:	90                   	nop
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801636:	e8 f7 fd ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  80163b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80163f:	75 07                	jne    801648 <malloc+0x18>
  801641:	b8 00 00 00 00       	mov    $0x0,%eax
  801646:	eb 61                	jmp    8016a9 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801648:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80164f:	8b 55 08             	mov    0x8(%ebp),%edx
  801652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801655:	01 d0                	add    %edx,%eax
  801657:	48                   	dec    %eax
  801658:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80165b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165e:	ba 00 00 00 00       	mov    $0x0,%edx
  801663:	f7 75 f0             	divl   -0x10(%ebp)
  801666:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801669:	29 d0                	sub    %edx,%eax
  80166b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80166e:	e8 e3 06 00 00       	call   801d56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801673:	85 c0                	test   %eax,%eax
  801675:	74 11                	je     801688 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801677:	83 ec 0c             	sub    $0xc,%esp
  80167a:	ff 75 e8             	pushl  -0x18(%ebp)
  80167d:	e8 4e 0d 00 00       	call   8023d0 <alloc_block_FF>
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801688:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80168c:	74 16                	je     8016a4 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80168e:	83 ec 0c             	sub    $0xc,%esp
  801691:	ff 75 f4             	pushl  -0xc(%ebp)
  801694:	e8 aa 0a 00 00       	call   802143 <insert_sorted_allocList>
  801699:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169f:	8b 40 08             	mov    0x8(%eax),%eax
  8016a2:	eb 05                	jmp    8016a9 <malloc+0x79>
	}

    return NULL;
  8016a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	68 44 40 80 00       	push   $0x804044
  8016b9:	6a 6f                	push   $0x6f
  8016bb:	68 13 40 80 00       	push   $0x804013
  8016c0:	e8 2f ed ff ff       	call   8003f4 <_panic>

008016c5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 38             	sub    $0x38,%esp
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d1:	e8 5c fd ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016da:	75 07                	jne    8016e3 <smalloc+0x1e>
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e1:	eb 7c                	jmp    80175f <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016e3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	01 d0                	add    %edx,%eax
  8016f2:	48                   	dec    %eax
  8016f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fe:	f7 75 f0             	divl   -0x10(%ebp)
  801701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801704:	29 d0                	sub    %edx,%eax
  801706:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801709:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801710:	e8 41 06 00 00       	call   801d56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801715:	85 c0                	test   %eax,%eax
  801717:	74 11                	je     80172a <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	ff 75 e8             	pushl  -0x18(%ebp)
  80171f:	e8 ac 0c 00 00       	call   8023d0 <alloc_block_FF>
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80172a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80172e:	74 2a                	je     80175a <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801733:	8b 40 08             	mov    0x8(%eax),%eax
  801736:	89 c2                	mov    %eax,%edx
  801738:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80173c:	52                   	push   %edx
  80173d:	50                   	push   %eax
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	ff 75 08             	pushl  0x8(%ebp)
  801744:	e8 92 03 00 00       	call   801adb <sys_createSharedObject>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80174f:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801753:	74 05                	je     80175a <smalloc+0x95>
			return (void*)virtual_address;
  801755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801758:	eb 05                	jmp    80175f <smalloc+0x9a>
	}
	return NULL;
  80175a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801767:	e8 c6 fc ff ff       	call   801432 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	68 68 40 80 00       	push   $0x804068
  801774:	68 b0 00 00 00       	push   $0xb0
  801779:	68 13 40 80 00       	push   $0x804013
  80177e:	e8 71 ec ff ff       	call   8003f4 <_panic>

00801783 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801789:	e8 a4 fc ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	68 8c 40 80 00       	push   $0x80408c
  801796:	68 f4 00 00 00       	push   $0xf4
  80179b:	68 13 40 80 00       	push   $0x804013
  8017a0:	e8 4f ec ff ff       	call   8003f4 <_panic>

008017a5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	68 b4 40 80 00       	push   $0x8040b4
  8017b3:	68 08 01 00 00       	push   $0x108
  8017b8:	68 13 40 80 00       	push   $0x804013
  8017bd:	e8 32 ec ff ff       	call   8003f4 <_panic>

008017c2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	68 d8 40 80 00       	push   $0x8040d8
  8017d0:	68 13 01 00 00       	push   $0x113
  8017d5:	68 13 40 80 00       	push   $0x804013
  8017da:	e8 15 ec ff ff       	call   8003f4 <_panic>

008017df <shrink>:

}
void shrink(uint32 newSize)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	68 d8 40 80 00       	push   $0x8040d8
  8017ed:	68 18 01 00 00       	push   $0x118
  8017f2:	68 13 40 80 00       	push   $0x804013
  8017f7:	e8 f8 eb ff ff       	call   8003f4 <_panic>

008017fc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	68 d8 40 80 00       	push   $0x8040d8
  80180a:	68 1d 01 00 00       	push   $0x11d
  80180f:	68 13 40 80 00       	push   $0x804013
  801814:	e8 db eb ff ff       	call   8003f4 <_panic>

00801819 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	57                   	push   %edi
  80181d:	56                   	push   %esi
  80181e:	53                   	push   %ebx
  80181f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	8b 55 0c             	mov    0xc(%ebp),%edx
  801828:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801831:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801834:	cd 30                	int    $0x30
  801836:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801839:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	5b                   	pop    %ebx
  801840:	5e                   	pop    %esi
  801841:	5f                   	pop    %edi
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    

00801844 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	8b 45 10             	mov    0x10(%ebp),%eax
  80184d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801850:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	52                   	push   %edx
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	6a 00                	push   $0x0
  801862:	e8 b2 ff ff ff       	call   801819 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	90                   	nop
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_cgetc>:

int
sys_cgetc(void)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 01                	push   $0x1
  80187c:	e8 98 ff ff ff       	call   801819 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	52                   	push   %edx
  801896:	50                   	push   %eax
  801897:	6a 05                	push   $0x5
  801899:	e8 7b ff ff ff       	call   801819 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a8:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	56                   	push   %esi
  8018b8:	53                   	push   %ebx
  8018b9:	51                   	push   %ecx
  8018ba:	52                   	push   %edx
  8018bb:	50                   	push   %eax
  8018bc:	6a 06                	push   $0x6
  8018be:	e8 56 ff ff ff       	call   801819 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c9:	5b                   	pop    %ebx
  8018ca:	5e                   	pop    %esi
  8018cb:	5d                   	pop    %ebp
  8018cc:	c3                   	ret    

008018cd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	6a 07                	push   $0x7
  8018e0:	e8 34 ff ff ff       	call   801819 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	ff 75 0c             	pushl  0xc(%ebp)
  8018f6:	ff 75 08             	pushl  0x8(%ebp)
  8018f9:	6a 08                	push   $0x8
  8018fb:	e8 19 ff ff ff       	call   801819 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 09                	push   $0x9
  801914:	e8 00 ff ff ff       	call   801819 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 0a                	push   $0xa
  80192d:	e8 e7 fe ff ff       	call   801819 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 0b                	push   $0xb
  801946:	e8 ce fe ff ff       	call   801819 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	6a 0f                	push   $0xf
  801961:	e8 b3 fe ff ff       	call   801819 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
	return;
  801969:	90                   	nop
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	ff 75 08             	pushl  0x8(%ebp)
  80197b:	6a 10                	push   $0x10
  80197d:	e8 97 fe ff ff       	call   801819 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
	return ;
  801985:	90                   	nop
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 10             	pushl  0x10(%ebp)
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	ff 75 08             	pushl  0x8(%ebp)
  801998:	6a 11                	push   $0x11
  80199a:	e8 7a fe ff ff       	call   801819 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a2:	90                   	nop
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 0c                	push   $0xc
  8019b4:	e8 60 fe ff ff       	call   801819 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	6a 0d                	push   $0xd
  8019ce:	e8 46 fe ff ff       	call   801819 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 0e                	push   $0xe
  8019e7:	e8 2d fe ff ff       	call   801819 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 13                	push   $0x13
  801a01:	e8 13 fe ff ff       	call   801819 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	90                   	nop
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 14                	push   $0x14
  801a1b:	e8 f9 fd ff ff       	call   801819 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	50                   	push   %eax
  801a3f:	6a 15                	push   $0x15
  801a41:	e8 d3 fd ff ff       	call   801819 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	90                   	nop
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 16                	push   $0x16
  801a5b:	e8 b9 fd ff ff       	call   801819 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	90                   	nop
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	50                   	push   %eax
  801a76:	6a 17                	push   $0x17
  801a78:	e8 9c fd ff ff       	call   801819 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	52                   	push   %edx
  801a92:	50                   	push   %eax
  801a93:	6a 1a                	push   $0x1a
  801a95:	e8 7f fd ff ff       	call   801819 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	52                   	push   %edx
  801aaf:	50                   	push   %eax
  801ab0:	6a 18                	push   $0x18
  801ab2:	e8 62 fd ff ff       	call   801819 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	90                   	nop
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 19                	push   $0x19
  801ad0:	e8 44 fd ff ff       	call   801819 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	90                   	nop
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ae7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	6a 00                	push   $0x0
  801af3:	51                   	push   %ecx
  801af4:	52                   	push   %edx
  801af5:	ff 75 0c             	pushl  0xc(%ebp)
  801af8:	50                   	push   %eax
  801af9:	6a 1b                	push   $0x1b
  801afb:	e8 19 fd ff ff       	call   801819 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 1c                	push   $0x1c
  801b18:	e8 fc fc ff ff       	call   801819 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	51                   	push   %ecx
  801b33:	52                   	push   %edx
  801b34:	50                   	push   %eax
  801b35:	6a 1d                	push   $0x1d
  801b37:	e8 dd fc ff ff       	call   801819 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	6a 1e                	push   $0x1e
  801b54:	e8 c0 fc ff ff       	call   801819 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 1f                	push   $0x1f
  801b6d:	e8 a7 fc ff ff       	call   801819 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 14             	pushl  0x14(%ebp)
  801b82:	ff 75 10             	pushl  0x10(%ebp)
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	50                   	push   %eax
  801b89:	6a 20                	push   $0x20
  801b8b:	e8 89 fc ff ff       	call   801819 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	50                   	push   %eax
  801ba4:	6a 21                	push   $0x21
  801ba6:	e8 6e fc ff ff       	call   801819 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	90                   	nop
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	50                   	push   %eax
  801bc0:	6a 22                	push   $0x22
  801bc2:	e8 52 fc ff ff       	call   801819 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 02                	push   $0x2
  801bdb:	e8 39 fc ff ff       	call   801819 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 03                	push   $0x3
  801bf4:	e8 20 fc ff ff       	call   801819 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 04                	push   $0x4
  801c0d:	e8 07 fc ff ff       	call   801819 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_exit_env>:


void sys_exit_env(void)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 23                	push   $0x23
  801c26:	e8 ee fb ff ff       	call   801819 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	90                   	nop
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c3a:	8d 50 04             	lea    0x4(%eax),%edx
  801c3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	52                   	push   %edx
  801c47:	50                   	push   %eax
  801c48:	6a 24                	push   $0x24
  801c4a:	e8 ca fb ff ff       	call   801819 <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
	return result;
  801c52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5b:	89 01                	mov    %eax,(%ecx)
  801c5d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	c9                   	leave  
  801c64:	c2 04 00             	ret    $0x4

00801c67 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	ff 75 10             	pushl  0x10(%ebp)
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	ff 75 08             	pushl  0x8(%ebp)
  801c77:	6a 12                	push   $0x12
  801c79:	e8 9b fb ff ff       	call   801819 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c81:	90                   	nop
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 25                	push   $0x25
  801c93:	e8 81 fb ff ff       	call   801819 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 04             	sub    $0x4,%esp
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ca9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	50                   	push   %eax
  801cb6:	6a 26                	push   $0x26
  801cb8:	e8 5c fb ff ff       	call   801819 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc0:	90                   	nop
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <rsttst>:
void rsttst()
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 28                	push   $0x28
  801cd2:	e8 42 fb ff ff       	call   801819 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cda:	90                   	nop
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 04             	sub    $0x4,%esp
  801ce3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ce9:	8b 55 18             	mov    0x18(%ebp),%edx
  801cec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf0:	52                   	push   %edx
  801cf1:	50                   	push   %eax
  801cf2:	ff 75 10             	pushl  0x10(%ebp)
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	ff 75 08             	pushl  0x8(%ebp)
  801cfb:	6a 27                	push   $0x27
  801cfd:	e8 17 fb ff ff       	call   801819 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
	return ;
  801d05:	90                   	nop
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <chktst>:
void chktst(uint32 n)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	6a 29                	push   $0x29
  801d18:	e8 fc fa ff ff       	call   801819 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <inctst>:

void inctst()
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 2a                	push   $0x2a
  801d32:	e8 e2 fa ff ff       	call   801819 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <gettst>:
uint32 gettst()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 2b                	push   $0x2b
  801d4c:	e8 c8 fa ff ff       	call   801819 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 2c                	push   $0x2c
  801d68:	e8 ac fa ff ff       	call   801819 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
  801d70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d73:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d77:	75 07                	jne    801d80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d79:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7e:	eb 05                	jmp    801d85 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 2c                	push   $0x2c
  801d99:	e8 7b fa ff ff       	call   801819 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
  801da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801da4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801da8:	75 07                	jne    801db1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801daa:	b8 01 00 00 00       	mov    $0x1,%eax
  801daf:	eb 05                	jmp    801db6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 2c                	push   $0x2c
  801dca:	e8 4a fa ff ff       	call   801819 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
  801dd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dd5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dd9:	75 07                	jne    801de2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ddb:	b8 01 00 00 00       	mov    $0x1,%eax
  801de0:	eb 05                	jmp    801de7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 2c                	push   $0x2c
  801dfb:	e8 19 fa ff ff       	call   801819 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
  801e03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e06:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e0a:	75 07                	jne    801e13 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e11:	eb 05                	jmp    801e18 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	6a 2d                	push   $0x2d
  801e2a:	e8 ea f9 ff ff       	call   801819 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e32:	90                   	nop
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	6a 00                	push   $0x0
  801e47:	53                   	push   %ebx
  801e48:	51                   	push   %ecx
  801e49:	52                   	push   %edx
  801e4a:	50                   	push   %eax
  801e4b:	6a 2e                	push   $0x2e
  801e4d:	e8 c7 f9 ff ff       	call   801819 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	52                   	push   %edx
  801e6a:	50                   	push   %eax
  801e6b:	6a 2f                	push   $0x2f
  801e6d:	e8 a7 f9 ff ff       	call   801819 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e7d:	83 ec 0c             	sub    $0xc,%esp
  801e80:	68 e8 40 80 00       	push   $0x8040e8
  801e85:	e8 1e e8 ff ff       	call   8006a8 <cprintf>
  801e8a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e8d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e94:	83 ec 0c             	sub    $0xc,%esp
  801e97:	68 14 41 80 00       	push   $0x804114
  801e9c:	e8 07 e8 ff ff       	call   8006a8 <cprintf>
  801ea1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ea4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ea8:	a1 38 51 80 00       	mov    0x805138,%eax
  801ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb0:	eb 56                	jmp    801f08 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb6:	74 1c                	je     801ed4 <print_mem_block_lists+0x5d>
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	8b 50 08             	mov    0x8(%eax),%edx
  801ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec1:	8b 48 08             	mov    0x8(%eax),%ecx
  801ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eca:	01 c8                	add    %ecx,%eax
  801ecc:	39 c2                	cmp    %eax,%edx
  801ece:	73 04                	jae    801ed4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ed0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	8b 50 08             	mov    0x8(%eax),%edx
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee0:	01 c2                	add    %eax,%edx
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee5:	8b 40 08             	mov    0x8(%eax),%eax
  801ee8:	83 ec 04             	sub    $0x4,%esp
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	68 29 41 80 00       	push   $0x804129
  801ef2:	e8 b1 e7 ff ff       	call   8006a8 <cprintf>
  801ef7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f00:	a1 40 51 80 00       	mov    0x805140,%eax
  801f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0c:	74 07                	je     801f15 <print_mem_block_lists+0x9e>
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	8b 00                	mov    (%eax),%eax
  801f13:	eb 05                	jmp    801f1a <print_mem_block_lists+0xa3>
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1a:	a3 40 51 80 00       	mov    %eax,0x805140
  801f1f:	a1 40 51 80 00       	mov    0x805140,%eax
  801f24:	85 c0                	test   %eax,%eax
  801f26:	75 8a                	jne    801eb2 <print_mem_block_lists+0x3b>
  801f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2c:	75 84                	jne    801eb2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f2e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f32:	75 10                	jne    801f44 <print_mem_block_lists+0xcd>
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	68 38 41 80 00       	push   $0x804138
  801f3c:	e8 67 e7 ff ff       	call   8006a8 <cprintf>
  801f41:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f4b:	83 ec 0c             	sub    $0xc,%esp
  801f4e:	68 5c 41 80 00       	push   $0x80415c
  801f53:	e8 50 e7 ff ff       	call   8006a8 <cprintf>
  801f58:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f5b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f5f:	a1 40 50 80 00       	mov    0x805040,%eax
  801f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f67:	eb 56                	jmp    801fbf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6d:	74 1c                	je     801f8b <print_mem_block_lists+0x114>
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	8b 50 08             	mov    0x8(%eax),%edx
  801f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f78:	8b 48 08             	mov    0x8(%eax),%ecx
  801f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f81:	01 c8                	add    %ecx,%eax
  801f83:	39 c2                	cmp    %eax,%edx
  801f85:	73 04                	jae    801f8b <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f87:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	8b 50 08             	mov    0x8(%eax),%edx
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	8b 40 0c             	mov    0xc(%eax),%eax
  801f97:	01 c2                	add    %eax,%edx
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 40 08             	mov    0x8(%eax),%eax
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	52                   	push   %edx
  801fa3:	50                   	push   %eax
  801fa4:	68 29 41 80 00       	push   $0x804129
  801fa9:	e8 fa e6 ff ff       	call   8006a8 <cprintf>
  801fae:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fb7:	a1 48 50 80 00       	mov    0x805048,%eax
  801fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc3:	74 07                	je     801fcc <print_mem_block_lists+0x155>
  801fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc8:	8b 00                	mov    (%eax),%eax
  801fca:	eb 05                	jmp    801fd1 <print_mem_block_lists+0x15a>
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd1:	a3 48 50 80 00       	mov    %eax,0x805048
  801fd6:	a1 48 50 80 00       	mov    0x805048,%eax
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	75 8a                	jne    801f69 <print_mem_block_lists+0xf2>
  801fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe3:	75 84                	jne    801f69 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fe5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fe9:	75 10                	jne    801ffb <print_mem_block_lists+0x184>
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	68 74 41 80 00       	push   $0x804174
  801ff3:	e8 b0 e6 ff ff       	call   8006a8 <cprintf>
  801ff8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	68 e8 40 80 00       	push   $0x8040e8
  802003:	e8 a0 e6 ff ff       	call   8006a8 <cprintf>
  802008:	83 c4 10             	add    $0x10,%esp

}
  80200b:	90                   	nop
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802014:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80201b:	00 00 00 
  80201e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802025:	00 00 00 
  802028:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80202f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802032:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802039:	e9 9e 00 00 00       	jmp    8020dc <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80203e:	a1 50 50 80 00       	mov    0x805050,%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	c1 e2 04             	shl    $0x4,%edx
  802049:	01 d0                	add    %edx,%eax
  80204b:	85 c0                	test   %eax,%eax
  80204d:	75 14                	jne    802063 <initialize_MemBlocksList+0x55>
  80204f:	83 ec 04             	sub    $0x4,%esp
  802052:	68 9c 41 80 00       	push   $0x80419c
  802057:	6a 46                	push   $0x46
  802059:	68 bf 41 80 00       	push   $0x8041bf
  80205e:	e8 91 e3 ff ff       	call   8003f4 <_panic>
  802063:	a1 50 50 80 00       	mov    0x805050,%eax
  802068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206b:	c1 e2 04             	shl    $0x4,%edx
  80206e:	01 d0                	add    %edx,%eax
  802070:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802076:	89 10                	mov    %edx,(%eax)
  802078:	8b 00                	mov    (%eax),%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	74 18                	je     802096 <initialize_MemBlocksList+0x88>
  80207e:	a1 48 51 80 00       	mov    0x805148,%eax
  802083:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802089:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80208c:	c1 e1 04             	shl    $0x4,%ecx
  80208f:	01 ca                	add    %ecx,%edx
  802091:	89 50 04             	mov    %edx,0x4(%eax)
  802094:	eb 12                	jmp    8020a8 <initialize_MemBlocksList+0x9a>
  802096:	a1 50 50 80 00       	mov    0x805050,%eax
  80209b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209e:	c1 e2 04             	shl    $0x4,%edx
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020a8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b0:	c1 e2 04             	shl    $0x4,%edx
  8020b3:	01 d0                	add    %edx,%eax
  8020b5:	a3 48 51 80 00       	mov    %eax,0x805148
  8020ba:	a1 50 50 80 00       	mov    0x805050,%eax
  8020bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c2:	c1 e2 04             	shl    $0x4,%edx
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8020d3:	40                   	inc    %eax
  8020d4:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020d9:	ff 45 f4             	incl   -0xc(%ebp)
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020e2:	0f 82 56 ff ff ff    	jb     80203e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020e8:	90                   	nop
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f9:	eb 19                	jmp    802114 <find_block+0x29>
	{
		if(va==point->sva)
  8020fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fe:	8b 40 08             	mov    0x8(%eax),%eax
  802101:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802104:	75 05                	jne    80210b <find_block+0x20>
		   return point;
  802106:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802109:	eb 36                	jmp    802141 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	8b 40 08             	mov    0x8(%eax),%eax
  802111:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802114:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802118:	74 07                	je     802121 <find_block+0x36>
  80211a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211d:	8b 00                	mov    (%eax),%eax
  80211f:	eb 05                	jmp    802126 <find_block+0x3b>
  802121:	b8 00 00 00 00       	mov    $0x0,%eax
  802126:	8b 55 08             	mov    0x8(%ebp),%edx
  802129:	89 42 08             	mov    %eax,0x8(%edx)
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	8b 40 08             	mov    0x8(%eax),%eax
  802132:	85 c0                	test   %eax,%eax
  802134:	75 c5                	jne    8020fb <find_block+0x10>
  802136:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213a:	75 bf                	jne    8020fb <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802149:	a1 40 50 80 00       	mov    0x805040,%eax
  80214e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802151:	a1 44 50 80 00       	mov    0x805044,%eax
  802156:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80215f:	74 24                	je     802185 <insert_sorted_allocList+0x42>
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	8b 50 08             	mov    0x8(%eax),%edx
  802167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216a:	8b 40 08             	mov    0x8(%eax),%eax
  80216d:	39 c2                	cmp    %eax,%edx
  80216f:	76 14                	jbe    802185 <insert_sorted_allocList+0x42>
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8b 50 08             	mov    0x8(%eax),%edx
  802177:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217a:	8b 40 08             	mov    0x8(%eax),%eax
  80217d:	39 c2                	cmp    %eax,%edx
  80217f:	0f 82 60 01 00 00    	jb     8022e5 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802185:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802189:	75 65                	jne    8021f0 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80218b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218f:	75 14                	jne    8021a5 <insert_sorted_allocList+0x62>
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	68 9c 41 80 00       	push   $0x80419c
  802199:	6a 6b                	push   $0x6b
  80219b:	68 bf 41 80 00       	push   $0x8041bf
  8021a0:	e8 4f e2 ff ff       	call   8003f4 <_panic>
  8021a5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	89 10                	mov    %edx,(%eax)
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	8b 00                	mov    (%eax),%eax
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	74 0d                	je     8021c6 <insert_sorted_allocList+0x83>
  8021b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8021be:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c1:	89 50 04             	mov    %edx,0x4(%eax)
  8021c4:	eb 08                	jmp    8021ce <insert_sorted_allocList+0x8b>
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	a3 44 50 80 00       	mov    %eax,0x805044
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	a3 40 50 80 00       	mov    %eax,0x805040
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021e5:	40                   	inc    %eax
  8021e6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021eb:	e9 dc 01 00 00       	jmp    8023cc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8b 50 08             	mov    0x8(%eax),%edx
  8021f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f9:	8b 40 08             	mov    0x8(%eax),%eax
  8021fc:	39 c2                	cmp    %eax,%edx
  8021fe:	77 6c                	ja     80226c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802200:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802204:	74 06                	je     80220c <insert_sorted_allocList+0xc9>
  802206:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80220a:	75 14                	jne    802220 <insert_sorted_allocList+0xdd>
  80220c:	83 ec 04             	sub    $0x4,%esp
  80220f:	68 d8 41 80 00       	push   $0x8041d8
  802214:	6a 6f                	push   $0x6f
  802216:	68 bf 41 80 00       	push   $0x8041bf
  80221b:	e8 d4 e1 ff ff       	call   8003f4 <_panic>
  802220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802223:	8b 50 04             	mov    0x4(%eax),%edx
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	89 50 04             	mov    %edx,0x4(%eax)
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802232:	89 10                	mov    %edx,(%eax)
  802234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802237:	8b 40 04             	mov    0x4(%eax),%eax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	74 0d                	je     80224b <insert_sorted_allocList+0x108>
  80223e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802241:	8b 40 04             	mov    0x4(%eax),%eax
  802244:	8b 55 08             	mov    0x8(%ebp),%edx
  802247:	89 10                	mov    %edx,(%eax)
  802249:	eb 08                	jmp    802253 <insert_sorted_allocList+0x110>
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	a3 40 50 80 00       	mov    %eax,0x805040
  802253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802256:	8b 55 08             	mov    0x8(%ebp),%edx
  802259:	89 50 04             	mov    %edx,0x4(%eax)
  80225c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802261:	40                   	inc    %eax
  802262:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802267:	e9 60 01 00 00       	jmp    8023cc <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	8b 50 08             	mov    0x8(%eax),%edx
  802272:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802275:	8b 40 08             	mov    0x8(%eax),%eax
  802278:	39 c2                	cmp    %eax,%edx
  80227a:	0f 82 4c 01 00 00    	jb     8023cc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802280:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802284:	75 14                	jne    80229a <insert_sorted_allocList+0x157>
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	68 10 42 80 00       	push   $0x804210
  80228e:	6a 73                	push   $0x73
  802290:	68 bf 41 80 00       	push   $0x8041bf
  802295:	e8 5a e1 ff ff       	call   8003f4 <_panic>
  80229a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	89 50 04             	mov    %edx,0x4(%eax)
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	8b 40 04             	mov    0x4(%eax),%eax
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	74 0c                	je     8022bc <insert_sorted_allocList+0x179>
  8022b0:	a1 44 50 80 00       	mov    0x805044,%eax
  8022b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b8:	89 10                	mov    %edx,(%eax)
  8022ba:	eb 08                	jmp    8022c4 <insert_sorted_allocList+0x181>
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	a3 40 50 80 00       	mov    %eax,0x805040
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 44 50 80 00       	mov    %eax,0x805044
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022da:	40                   	inc    %eax
  8022db:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e0:	e9 e7 00 00 00       	jmp    8023cc <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022f2:	a1 40 50 80 00       	mov    0x805040,%eax
  8022f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fa:	e9 9d 00 00 00       	jmp    80239c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 00                	mov    (%eax),%eax
  802304:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	8b 50 08             	mov    0x8(%eax),%edx
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 40 08             	mov    0x8(%eax),%eax
  802313:	39 c2                	cmp    %eax,%edx
  802315:	76 7d                	jbe    802394 <insert_sorted_allocList+0x251>
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	8b 50 08             	mov    0x8(%eax),%edx
  80231d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802320:	8b 40 08             	mov    0x8(%eax),%eax
  802323:	39 c2                	cmp    %eax,%edx
  802325:	73 6d                	jae    802394 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232b:	74 06                	je     802333 <insert_sorted_allocList+0x1f0>
  80232d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802331:	75 14                	jne    802347 <insert_sorted_allocList+0x204>
  802333:	83 ec 04             	sub    $0x4,%esp
  802336:	68 34 42 80 00       	push   $0x804234
  80233b:	6a 7f                	push   $0x7f
  80233d:	68 bf 41 80 00       	push   $0x8041bf
  802342:	e8 ad e0 ff ff       	call   8003f4 <_panic>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 10                	mov    (%eax),%edx
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	89 10                	mov    %edx,(%eax)
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	74 0b                	je     802365 <insert_sorted_allocList+0x222>
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	8b 55 08             	mov    0x8(%ebp),%edx
  802362:	89 50 04             	mov    %edx,0x4(%eax)
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 55 08             	mov    0x8(%ebp),%edx
  80236b:	89 10                	mov    %edx,(%eax)
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802373:	89 50 04             	mov    %edx,0x4(%eax)
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	8b 00                	mov    (%eax),%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	75 08                	jne    802387 <insert_sorted_allocList+0x244>
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	a3 44 50 80 00       	mov    %eax,0x805044
  802387:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80238c:	40                   	inc    %eax
  80238d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802392:	eb 39                	jmp    8023cd <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802394:	a1 48 50 80 00       	mov    0x805048,%eax
  802399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a0:	74 07                	je     8023a9 <insert_sorted_allocList+0x266>
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	eb 05                	jmp    8023ae <insert_sorted_allocList+0x26b>
  8023a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ae:	a3 48 50 80 00       	mov    %eax,0x805048
  8023b3:	a1 48 50 80 00       	mov    0x805048,%eax
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	0f 85 3f ff ff ff    	jne    8022ff <insert_sorted_allocList+0x1bc>
  8023c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c4:	0f 85 35 ff ff ff    	jne    8022ff <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023ca:	eb 01                	jmp    8023cd <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023cc:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023cd:	90                   	nop
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8023db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023de:	e9 85 01 00 00       	jmp    802568 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ec:	0f 82 6e 01 00 00    	jb     802560 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023fb:	0f 85 8a 00 00 00    	jne    80248b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802401:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802405:	75 17                	jne    80241e <alloc_block_FF+0x4e>
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	68 68 42 80 00       	push   $0x804268
  80240f:	68 93 00 00 00       	push   $0x93
  802414:	68 bf 41 80 00       	push   $0x8041bf
  802419:	e8 d6 df ff ff       	call   8003f4 <_panic>
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	85 c0                	test   %eax,%eax
  802425:	74 10                	je     802437 <alloc_block_FF+0x67>
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 00                	mov    (%eax),%eax
  80242c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242f:	8b 52 04             	mov    0x4(%edx),%edx
  802432:	89 50 04             	mov    %edx,0x4(%eax)
  802435:	eb 0b                	jmp    802442 <alloc_block_FF+0x72>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 40 04             	mov    0x4(%eax),%eax
  80243d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 40 04             	mov    0x4(%eax),%eax
  802448:	85 c0                	test   %eax,%eax
  80244a:	74 0f                	je     80245b <alloc_block_FF+0x8b>
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802455:	8b 12                	mov    (%edx),%edx
  802457:	89 10                	mov    %edx,(%eax)
  802459:	eb 0a                	jmp    802465 <alloc_block_FF+0x95>
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	a3 38 51 80 00       	mov    %eax,0x805138
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802478:	a1 44 51 80 00       	mov    0x805144,%eax
  80247d:	48                   	dec    %eax
  80247e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	e9 10 01 00 00       	jmp    80259b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 0c             	mov    0xc(%eax),%eax
  802491:	3b 45 08             	cmp    0x8(%ebp),%eax
  802494:	0f 86 c6 00 00 00    	jbe    802560 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80249a:	a1 48 51 80 00       	mov    0x805148,%eax
  80249f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 50 08             	mov    0x8(%eax),%edx
  8024a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ab:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b4:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024bb:	75 17                	jne    8024d4 <alloc_block_FF+0x104>
  8024bd:	83 ec 04             	sub    $0x4,%esp
  8024c0:	68 68 42 80 00       	push   $0x804268
  8024c5:	68 9b 00 00 00       	push   $0x9b
  8024ca:	68 bf 41 80 00       	push   $0x8041bf
  8024cf:	e8 20 df ff ff       	call   8003f4 <_panic>
  8024d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d7:	8b 00                	mov    (%eax),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	74 10                	je     8024ed <alloc_block_FF+0x11d>
  8024dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e5:	8b 52 04             	mov    0x4(%edx),%edx
  8024e8:	89 50 04             	mov    %edx,0x4(%eax)
  8024eb:	eb 0b                	jmp    8024f8 <alloc_block_FF+0x128>
  8024ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f0:	8b 40 04             	mov    0x4(%eax),%eax
  8024f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	74 0f                	je     802511 <alloc_block_FF+0x141>
  802502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802505:	8b 40 04             	mov    0x4(%eax),%eax
  802508:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250b:	8b 12                	mov    (%edx),%edx
  80250d:	89 10                	mov    %edx,(%eax)
  80250f:	eb 0a                	jmp    80251b <alloc_block_FF+0x14b>
  802511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	a3 48 51 80 00       	mov    %eax,0x805148
  80251b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802527:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252e:	a1 54 51 80 00       	mov    0x805154,%eax
  802533:	48                   	dec    %eax
  802534:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 50 08             	mov    0x8(%eax),%edx
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	01 c2                	add    %eax,%edx
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 40 0c             	mov    0xc(%eax),%eax
  802550:	2b 45 08             	sub    0x8(%ebp),%eax
  802553:	89 c2                	mov    %eax,%edx
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80255b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255e:	eb 3b                	jmp    80259b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802560:	a1 40 51 80 00       	mov    0x805140,%eax
  802565:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256c:	74 07                	je     802575 <alloc_block_FF+0x1a5>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 00                	mov    (%eax),%eax
  802573:	eb 05                	jmp    80257a <alloc_block_FF+0x1aa>
  802575:	b8 00 00 00 00       	mov    $0x0,%eax
  80257a:	a3 40 51 80 00       	mov    %eax,0x805140
  80257f:	a1 40 51 80 00       	mov    0x805140,%eax
  802584:	85 c0                	test   %eax,%eax
  802586:	0f 85 57 fe ff ff    	jne    8023e3 <alloc_block_FF+0x13>
  80258c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802590:	0f 85 4d fe ff ff    	jne    8023e3 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
  8025a0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025aa:	a1 38 51 80 00       	mov    0x805138,%eax
  8025af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b2:	e9 df 00 00 00       	jmp    802696 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c0:	0f 82 c8 00 00 00    	jb     80268e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cf:	0f 85 8a 00 00 00    	jne    80265f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d9:	75 17                	jne    8025f2 <alloc_block_BF+0x55>
  8025db:	83 ec 04             	sub    $0x4,%esp
  8025de:	68 68 42 80 00       	push   $0x804268
  8025e3:	68 b7 00 00 00       	push   $0xb7
  8025e8:	68 bf 41 80 00       	push   $0x8041bf
  8025ed:	e8 02 de ff ff       	call   8003f4 <_panic>
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 00                	mov    (%eax),%eax
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	74 10                	je     80260b <alloc_block_BF+0x6e>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802603:	8b 52 04             	mov    0x4(%edx),%edx
  802606:	89 50 04             	mov    %edx,0x4(%eax)
  802609:	eb 0b                	jmp    802616 <alloc_block_BF+0x79>
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 40 04             	mov    0x4(%eax),%eax
  802611:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 40 04             	mov    0x4(%eax),%eax
  80261c:	85 c0                	test   %eax,%eax
  80261e:	74 0f                	je     80262f <alloc_block_BF+0x92>
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 04             	mov    0x4(%eax),%eax
  802626:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802629:	8b 12                	mov    (%edx),%edx
  80262b:	89 10                	mov    %edx,(%eax)
  80262d:	eb 0a                	jmp    802639 <alloc_block_BF+0x9c>
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	a3 38 51 80 00       	mov    %eax,0x805138
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264c:	a1 44 51 80 00       	mov    0x805144,%eax
  802651:	48                   	dec    %eax
  802652:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	e9 4d 01 00 00       	jmp    8027ac <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 0c             	mov    0xc(%eax),%eax
  802665:	3b 45 08             	cmp    0x8(%ebp),%eax
  802668:	76 24                	jbe    80268e <alloc_block_BF+0xf1>
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 40 0c             	mov    0xc(%eax),%eax
  802670:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802673:	73 19                	jae    80268e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802675:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 0c             	mov    0xc(%eax),%eax
  802682:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 08             	mov    0x8(%eax),%eax
  80268b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80268e:	a1 40 51 80 00       	mov    0x805140,%eax
  802693:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802696:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269a:	74 07                	je     8026a3 <alloc_block_BF+0x106>
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	eb 05                	jmp    8026a8 <alloc_block_BF+0x10b>
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	a3 40 51 80 00       	mov    %eax,0x805140
  8026ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	0f 85 fd fe ff ff    	jne    8025b7 <alloc_block_BF+0x1a>
  8026ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026be:	0f 85 f3 fe ff ff    	jne    8025b7 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c8:	0f 84 d9 00 00 00    	je     8027a7 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8026d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026dc:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e5:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026ec:	75 17                	jne    802705 <alloc_block_BF+0x168>
  8026ee:	83 ec 04             	sub    $0x4,%esp
  8026f1:	68 68 42 80 00       	push   $0x804268
  8026f6:	68 c7 00 00 00       	push   $0xc7
  8026fb:	68 bf 41 80 00       	push   $0x8041bf
  802700:	e8 ef dc ff ff       	call   8003f4 <_panic>
  802705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802708:	8b 00                	mov    (%eax),%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	74 10                	je     80271e <alloc_block_BF+0x181>
  80270e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802711:	8b 00                	mov    (%eax),%eax
  802713:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802716:	8b 52 04             	mov    0x4(%edx),%edx
  802719:	89 50 04             	mov    %edx,0x4(%eax)
  80271c:	eb 0b                	jmp    802729 <alloc_block_BF+0x18c>
  80271e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802721:	8b 40 04             	mov    0x4(%eax),%eax
  802724:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272c:	8b 40 04             	mov    0x4(%eax),%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	74 0f                	je     802742 <alloc_block_BF+0x1a5>
  802733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802736:	8b 40 04             	mov    0x4(%eax),%eax
  802739:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80273c:	8b 12                	mov    (%edx),%edx
  80273e:	89 10                	mov    %edx,(%eax)
  802740:	eb 0a                	jmp    80274c <alloc_block_BF+0x1af>
  802742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	a3 48 51 80 00       	mov    %eax,0x805148
  80274c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802758:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275f:	a1 54 51 80 00       	mov    0x805154,%eax
  802764:	48                   	dec    %eax
  802765:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80276a:	83 ec 08             	sub    $0x8,%esp
  80276d:	ff 75 ec             	pushl  -0x14(%ebp)
  802770:	68 38 51 80 00       	push   $0x805138
  802775:	e8 71 f9 ff ff       	call   8020eb <find_block>
  80277a:	83 c4 10             	add    $0x10,%esp
  80277d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802780:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802783:	8b 50 08             	mov    0x8(%eax),%edx
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	01 c2                	add    %eax,%edx
  80278b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802791:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802794:	8b 40 0c             	mov    0xc(%eax),%eax
  802797:	2b 45 08             	sub    0x8(%ebp),%eax
  80279a:	89 c2                	mov    %eax,%edx
  80279c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a5:	eb 05                	jmp    8027ac <alloc_block_BF+0x20f>
	}
	return NULL;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027b4:	a1 28 50 80 00       	mov    0x805028,%eax
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	0f 85 de 01 00 00    	jne    80299f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027c1:	a1 38 51 80 00       	mov    0x805138,%eax
  8027c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c9:	e9 9e 01 00 00       	jmp    80296c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d7:	0f 82 87 01 00 00    	jb     802964 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e6:	0f 85 95 00 00 00    	jne    802881 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f0:	75 17                	jne    802809 <alloc_block_NF+0x5b>
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	68 68 42 80 00       	push   $0x804268
  8027fa:	68 e0 00 00 00       	push   $0xe0
  8027ff:	68 bf 41 80 00       	push   $0x8041bf
  802804:	e8 eb db ff ff       	call   8003f4 <_panic>
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	8b 00                	mov    (%eax),%eax
  80280e:	85 c0                	test   %eax,%eax
  802810:	74 10                	je     802822 <alloc_block_NF+0x74>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281a:	8b 52 04             	mov    0x4(%edx),%edx
  80281d:	89 50 04             	mov    %edx,0x4(%eax)
  802820:	eb 0b                	jmp    80282d <alloc_block_NF+0x7f>
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 40 04             	mov    0x4(%eax),%eax
  802828:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 40 04             	mov    0x4(%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 0f                	je     802846 <alloc_block_NF+0x98>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 40 04             	mov    0x4(%eax),%eax
  80283d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802840:	8b 12                	mov    (%edx),%edx
  802842:	89 10                	mov    %edx,(%eax)
  802844:	eb 0a                	jmp    802850 <alloc_block_NF+0xa2>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	a3 38 51 80 00       	mov    %eax,0x805138
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802863:	a1 44 51 80 00       	mov    0x805144,%eax
  802868:	48                   	dec    %eax
  802869:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 08             	mov    0x8(%eax),%eax
  802874:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	e9 f8 04 00 00       	jmp    802d79 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 0c             	mov    0xc(%eax),%eax
  802887:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288a:	0f 86 d4 00 00 00    	jbe    802964 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802890:	a1 48 51 80 00       	mov    0x805148,%eax
  802895:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 50 08             	mov    0x8(%eax),%edx
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028aa:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b1:	75 17                	jne    8028ca <alloc_block_NF+0x11c>
  8028b3:	83 ec 04             	sub    $0x4,%esp
  8028b6:	68 68 42 80 00       	push   $0x804268
  8028bb:	68 e9 00 00 00       	push   $0xe9
  8028c0:	68 bf 41 80 00       	push   $0x8041bf
  8028c5:	e8 2a db ff ff       	call   8003f4 <_panic>
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	74 10                	je     8028e3 <alloc_block_NF+0x135>
  8028d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d6:	8b 00                	mov    (%eax),%eax
  8028d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028db:	8b 52 04             	mov    0x4(%edx),%edx
  8028de:	89 50 04             	mov    %edx,0x4(%eax)
  8028e1:	eb 0b                	jmp    8028ee <alloc_block_NF+0x140>
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	8b 40 04             	mov    0x4(%eax),%eax
  8028e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f1:	8b 40 04             	mov    0x4(%eax),%eax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	74 0f                	je     802907 <alloc_block_NF+0x159>
  8028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fb:	8b 40 04             	mov    0x4(%eax),%eax
  8028fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802901:	8b 12                	mov    (%edx),%edx
  802903:	89 10                	mov    %edx,(%eax)
  802905:	eb 0a                	jmp    802911 <alloc_block_NF+0x163>
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	8b 00                	mov    (%eax),%eax
  80290c:	a3 48 51 80 00       	mov    %eax,0x805148
  802911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802914:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802924:	a1 54 51 80 00       	mov    0x805154,%eax
  802929:	48                   	dec    %eax
  80292a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	8b 40 08             	mov    0x8(%eax),%eax
  802935:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 50 08             	mov    0x8(%eax),%edx
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	01 c2                	add    %eax,%edx
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 40 0c             	mov    0xc(%eax),%eax
  802951:	2b 45 08             	sub    0x8(%ebp),%eax
  802954:	89 c2                	mov    %eax,%edx
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	e9 15 04 00 00       	jmp    802d79 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802964:	a1 40 51 80 00       	mov    0x805140,%eax
  802969:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802970:	74 07                	je     802979 <alloc_block_NF+0x1cb>
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 00                	mov    (%eax),%eax
  802977:	eb 05                	jmp    80297e <alloc_block_NF+0x1d0>
  802979:	b8 00 00 00 00       	mov    $0x0,%eax
  80297e:	a3 40 51 80 00       	mov    %eax,0x805140
  802983:	a1 40 51 80 00       	mov    0x805140,%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	0f 85 3e fe ff ff    	jne    8027ce <alloc_block_NF+0x20>
  802990:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802994:	0f 85 34 fe ff ff    	jne    8027ce <alloc_block_NF+0x20>
  80299a:	e9 d5 03 00 00       	jmp    802d74 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80299f:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a7:	e9 b1 01 00 00       	jmp    802b5d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 50 08             	mov    0x8(%eax),%edx
  8029b2:	a1 28 50 80 00       	mov    0x805028,%eax
  8029b7:	39 c2                	cmp    %eax,%edx
  8029b9:	0f 82 96 01 00 00    	jb     802b55 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c8:	0f 82 87 01 00 00    	jb     802b55 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d7:	0f 85 95 00 00 00    	jne    802a72 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e1:	75 17                	jne    8029fa <alloc_block_NF+0x24c>
  8029e3:	83 ec 04             	sub    $0x4,%esp
  8029e6:	68 68 42 80 00       	push   $0x804268
  8029eb:	68 fc 00 00 00       	push   $0xfc
  8029f0:	68 bf 41 80 00       	push   $0x8041bf
  8029f5:	e8 fa d9 ff ff       	call   8003f4 <_panic>
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 00                	mov    (%eax),%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	74 10                	je     802a13 <alloc_block_NF+0x265>
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 00                	mov    (%eax),%eax
  802a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0b:	8b 52 04             	mov    0x4(%edx),%edx
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
  802a11:	eb 0b                	jmp    802a1e <alloc_block_NF+0x270>
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 40 04             	mov    0x4(%eax),%eax
  802a19:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 40 04             	mov    0x4(%eax),%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	74 0f                	je     802a37 <alloc_block_NF+0x289>
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 04             	mov    0x4(%eax),%eax
  802a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a31:	8b 12                	mov    (%edx),%edx
  802a33:	89 10                	mov    %edx,(%eax)
  802a35:	eb 0a                	jmp    802a41 <alloc_block_NF+0x293>
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 00                	mov    (%eax),%eax
  802a3c:	a3 38 51 80 00       	mov    %eax,0x805138
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a54:	a1 44 51 80 00       	mov    0x805144,%eax
  802a59:	48                   	dec    %eax
  802a5a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 40 08             	mov    0x8(%eax),%eax
  802a65:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	e9 07 03 00 00       	jmp    802d79 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 40 0c             	mov    0xc(%eax),%eax
  802a78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7b:	0f 86 d4 00 00 00    	jbe    802b55 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a81:	a1 48 51 80 00       	mov    0x805148,%eax
  802a86:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 50 08             	mov    0x8(%eax),%edx
  802a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a92:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a98:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aa2:	75 17                	jne    802abb <alloc_block_NF+0x30d>
  802aa4:	83 ec 04             	sub    $0x4,%esp
  802aa7:	68 68 42 80 00       	push   $0x804268
  802aac:	68 04 01 00 00       	push   $0x104
  802ab1:	68 bf 41 80 00       	push   $0x8041bf
  802ab6:	e8 39 d9 ff ff       	call   8003f4 <_panic>
  802abb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	74 10                	je     802ad4 <alloc_block_NF+0x326>
  802ac4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac7:	8b 00                	mov    (%eax),%eax
  802ac9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802acc:	8b 52 04             	mov    0x4(%edx),%edx
  802acf:	89 50 04             	mov    %edx,0x4(%eax)
  802ad2:	eb 0b                	jmp    802adf <alloc_block_NF+0x331>
  802ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802adf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae2:	8b 40 04             	mov    0x4(%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 0f                	je     802af8 <alloc_block_NF+0x34a>
  802ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aec:	8b 40 04             	mov    0x4(%eax),%eax
  802aef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802af2:	8b 12                	mov    (%edx),%edx
  802af4:	89 10                	mov    %edx,(%eax)
  802af6:	eb 0a                	jmp    802b02 <alloc_block_NF+0x354>
  802af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	a3 48 51 80 00       	mov    %eax,0x805148
  802b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b15:	a1 54 51 80 00       	mov    0x805154,%eax
  802b1a:	48                   	dec    %eax
  802b1b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b23:	8b 40 08             	mov    0x8(%eax),%eax
  802b26:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 50 08             	mov    0x8(%eax),%edx
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	01 c2                	add    %eax,%edx
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b42:	2b 45 08             	sub    0x8(%ebp),%eax
  802b45:	89 c2                	mov    %eax,%edx
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b50:	e9 24 02 00 00       	jmp    802d79 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b55:	a1 40 51 80 00       	mov    0x805140,%eax
  802b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b61:	74 07                	je     802b6a <alloc_block_NF+0x3bc>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	eb 05                	jmp    802b6f <alloc_block_NF+0x3c1>
  802b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6f:	a3 40 51 80 00       	mov    %eax,0x805140
  802b74:	a1 40 51 80 00       	mov    0x805140,%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	0f 85 2b fe ff ff    	jne    8029ac <alloc_block_NF+0x1fe>
  802b81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b85:	0f 85 21 fe ff ff    	jne    8029ac <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b8b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b93:	e9 ae 01 00 00       	jmp    802d46 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 50 08             	mov    0x8(%eax),%edx
  802b9e:	a1 28 50 80 00       	mov    0x805028,%eax
  802ba3:	39 c2                	cmp    %eax,%edx
  802ba5:	0f 83 93 01 00 00    	jae    802d3e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb4:	0f 82 84 01 00 00    	jb     802d3e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc3:	0f 85 95 00 00 00    	jne    802c5e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcd:	75 17                	jne    802be6 <alloc_block_NF+0x438>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 68 42 80 00       	push   $0x804268
  802bd7:	68 14 01 00 00       	push   $0x114
  802bdc:	68 bf 41 80 00       	push   $0x8041bf
  802be1:	e8 0e d8 ff ff       	call   8003f4 <_panic>
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 10                	je     802bff <alloc_block_NF+0x451>
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf7:	8b 52 04             	mov    0x4(%edx),%edx
  802bfa:	89 50 04             	mov    %edx,0x4(%eax)
  802bfd:	eb 0b                	jmp    802c0a <alloc_block_NF+0x45c>
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 40 04             	mov    0x4(%eax),%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	74 0f                	je     802c23 <alloc_block_NF+0x475>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 40 04             	mov    0x4(%eax),%eax
  802c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1d:	8b 12                	mov    (%edx),%edx
  802c1f:	89 10                	mov    %edx,(%eax)
  802c21:	eb 0a                	jmp    802c2d <alloc_block_NF+0x47f>
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 00                	mov    (%eax),%eax
  802c28:	a3 38 51 80 00       	mov    %eax,0x805138
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c40:	a1 44 51 80 00       	mov    0x805144,%eax
  802c45:	48                   	dec    %eax
  802c46:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 40 08             	mov    0x8(%eax),%eax
  802c51:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	e9 1b 01 00 00       	jmp    802d79 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 40 0c             	mov    0xc(%eax),%eax
  802c64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c67:	0f 86 d1 00 00 00    	jbe    802d3e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c6d:	a1 48 51 80 00       	mov    0x805148,%eax
  802c72:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 50 08             	mov    0x8(%eax),%edx
  802c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c84:	8b 55 08             	mov    0x8(%ebp),%edx
  802c87:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c8e:	75 17                	jne    802ca7 <alloc_block_NF+0x4f9>
  802c90:	83 ec 04             	sub    $0x4,%esp
  802c93:	68 68 42 80 00       	push   $0x804268
  802c98:	68 1c 01 00 00       	push   $0x11c
  802c9d:	68 bf 41 80 00       	push   $0x8041bf
  802ca2:	e8 4d d7 ff ff       	call   8003f4 <_panic>
  802ca7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	85 c0                	test   %eax,%eax
  802cae:	74 10                	je     802cc0 <alloc_block_NF+0x512>
  802cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb3:	8b 00                	mov    (%eax),%eax
  802cb5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb8:	8b 52 04             	mov    0x4(%edx),%edx
  802cbb:	89 50 04             	mov    %edx,0x4(%eax)
  802cbe:	eb 0b                	jmp    802ccb <alloc_block_NF+0x51d>
  802cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc3:	8b 40 04             	mov    0x4(%eax),%eax
  802cc6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cce:	8b 40 04             	mov    0x4(%eax),%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	74 0f                	je     802ce4 <alloc_block_NF+0x536>
  802cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd8:	8b 40 04             	mov    0x4(%eax),%eax
  802cdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cde:	8b 12                	mov    (%edx),%edx
  802ce0:	89 10                	mov    %edx,(%eax)
  802ce2:	eb 0a                	jmp    802cee <alloc_block_NF+0x540>
  802ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	a3 48 51 80 00       	mov    %eax,0x805148
  802cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d01:	a1 54 51 80 00       	mov    0x805154,%eax
  802d06:	48                   	dec    %eax
  802d07:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0f:	8b 40 08             	mov    0x8(%eax),%eax
  802d12:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 50 08             	mov    0x8(%eax),%edx
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	01 c2                	add    %eax,%edx
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2e:	2b 45 08             	sub    0x8(%ebp),%eax
  802d31:	89 c2                	mov    %eax,%edx
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3c:	eb 3b                	jmp    802d79 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d3e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4a:	74 07                	je     802d53 <alloc_block_NF+0x5a5>
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	eb 05                	jmp    802d58 <alloc_block_NF+0x5aa>
  802d53:	b8 00 00 00 00       	mov    $0x0,%eax
  802d58:	a3 40 51 80 00       	mov    %eax,0x805140
  802d5d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	0f 85 2e fe ff ff    	jne    802b98 <alloc_block_NF+0x3ea>
  802d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6e:	0f 85 24 fe ff ff    	jne    802b98 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d79:	c9                   	leave  
  802d7a:	c3                   	ret    

00802d7b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d7b:	55                   	push   %ebp
  802d7c:	89 e5                	mov    %esp,%ebp
  802d7e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d81:	a1 38 51 80 00       	mov    0x805138,%eax
  802d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d89:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d8e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d91:	a1 38 51 80 00       	mov    0x805138,%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 14                	je     802dae <insert_sorted_with_merge_freeList+0x33>
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 50 08             	mov    0x8(%eax),%edx
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	8b 40 08             	mov    0x8(%eax),%eax
  802da6:	39 c2                	cmp    %eax,%edx
  802da8:	0f 87 9b 01 00 00    	ja     802f49 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802dae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db2:	75 17                	jne    802dcb <insert_sorted_with_merge_freeList+0x50>
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	68 9c 41 80 00       	push   $0x80419c
  802dbc:	68 38 01 00 00       	push   $0x138
  802dc1:	68 bf 41 80 00       	push   $0x8041bf
  802dc6:	e8 29 d6 ff ff       	call   8003f4 <_panic>
  802dcb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 0d                	je     802dec <insert_sorted_with_merge_freeList+0x71>
  802ddf:	a1 38 51 80 00       	mov    0x805138,%eax
  802de4:	8b 55 08             	mov    0x8(%ebp),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	eb 08                	jmp    802df4 <insert_sorted_with_merge_freeList+0x79>
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	a3 38 51 80 00       	mov    %eax,0x805138
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e06:	a1 44 51 80 00       	mov    0x805144,%eax
  802e0b:	40                   	inc    %eax
  802e0c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e15:	0f 84 a8 06 00 00    	je     8034c3 <insert_sorted_with_merge_freeList+0x748>
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	8b 50 08             	mov    0x8(%eax),%edx
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	8b 40 0c             	mov    0xc(%eax),%eax
  802e27:	01 c2                	add    %eax,%edx
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	8b 40 08             	mov    0x8(%eax),%eax
  802e2f:	39 c2                	cmp    %eax,%edx
  802e31:	0f 85 8c 06 00 00    	jne    8034c3 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e40:	8b 40 0c             	mov    0xc(%eax),%eax
  802e43:	01 c2                	add    %eax,%edx
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e4f:	75 17                	jne    802e68 <insert_sorted_with_merge_freeList+0xed>
  802e51:	83 ec 04             	sub    $0x4,%esp
  802e54:	68 68 42 80 00       	push   $0x804268
  802e59:	68 3c 01 00 00       	push   $0x13c
  802e5e:	68 bf 41 80 00       	push   $0x8041bf
  802e63:	e8 8c d5 ff ff       	call   8003f4 <_panic>
  802e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 10                	je     802e81 <insert_sorted_with_merge_freeList+0x106>
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e79:	8b 52 04             	mov    0x4(%edx),%edx
  802e7c:	89 50 04             	mov    %edx,0x4(%eax)
  802e7f:	eb 0b                	jmp    802e8c <insert_sorted_with_merge_freeList+0x111>
  802e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e84:	8b 40 04             	mov    0x4(%eax),%eax
  802e87:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8f:	8b 40 04             	mov    0x4(%eax),%eax
  802e92:	85 c0                	test   %eax,%eax
  802e94:	74 0f                	je     802ea5 <insert_sorted_with_merge_freeList+0x12a>
  802e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e99:	8b 40 04             	mov    0x4(%eax),%eax
  802e9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9f:	8b 12                	mov    (%edx),%edx
  802ea1:	89 10                	mov    %edx,(%eax)
  802ea3:	eb 0a                	jmp    802eaf <insert_sorted_with_merge_freeList+0x134>
  802ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	a3 38 51 80 00       	mov    %eax,0x805138
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec7:	48                   	dec    %eax
  802ec8:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ee1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee5:	75 17                	jne    802efe <insert_sorted_with_merge_freeList+0x183>
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 9c 41 80 00       	push   $0x80419c
  802eef:	68 3f 01 00 00       	push   $0x13f
  802ef4:	68 bf 41 80 00       	push   $0x8041bf
  802ef9:	e8 f6 d4 ff ff       	call   8003f4 <_panic>
  802efe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f07:	89 10                	mov    %edx,(%eax)
  802f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	74 0d                	je     802f1f <insert_sorted_with_merge_freeList+0x1a4>
  802f12:	a1 48 51 80 00       	mov    0x805148,%eax
  802f17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f1a:	89 50 04             	mov    %edx,0x4(%eax)
  802f1d:	eb 08                	jmp    802f27 <insert_sorted_with_merge_freeList+0x1ac>
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f39:	a1 54 51 80 00       	mov    0x805154,%eax
  802f3e:	40                   	inc    %eax
  802f3f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f44:	e9 7a 05 00 00       	jmp    8034c3 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	8b 50 08             	mov    0x8(%eax),%edx
  802f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f52:	8b 40 08             	mov    0x8(%eax),%eax
  802f55:	39 c2                	cmp    %eax,%edx
  802f57:	0f 82 14 01 00 00    	jb     803071 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f60:	8b 50 08             	mov    0x8(%eax),%edx
  802f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f66:	8b 40 0c             	mov    0xc(%eax),%eax
  802f69:	01 c2                	add    %eax,%edx
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 40 08             	mov    0x8(%eax),%eax
  802f71:	39 c2                	cmp    %eax,%edx
  802f73:	0f 85 90 00 00 00    	jne    803009 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 40 0c             	mov    0xc(%eax),%eax
  802f85:	01 c2                	add    %eax,%edx
  802f87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa5:	75 17                	jne    802fbe <insert_sorted_with_merge_freeList+0x243>
  802fa7:	83 ec 04             	sub    $0x4,%esp
  802faa:	68 9c 41 80 00       	push   $0x80419c
  802faf:	68 49 01 00 00       	push   $0x149
  802fb4:	68 bf 41 80 00       	push   $0x8041bf
  802fb9:	e8 36 d4 ff ff       	call   8003f4 <_panic>
  802fbe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	89 10                	mov    %edx,(%eax)
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 0d                	je     802fdf <insert_sorted_with_merge_freeList+0x264>
  802fd2:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fda:	89 50 04             	mov    %edx,0x4(%eax)
  802fdd:	eb 08                	jmp    802fe7 <insert_sorted_with_merge_freeList+0x26c>
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	a3 48 51 80 00       	mov    %eax,0x805148
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff9:	a1 54 51 80 00       	mov    0x805154,%eax
  802ffe:	40                   	inc    %eax
  802fff:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803004:	e9 bb 04 00 00       	jmp    8034c4 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803009:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300d:	75 17                	jne    803026 <insert_sorted_with_merge_freeList+0x2ab>
  80300f:	83 ec 04             	sub    $0x4,%esp
  803012:	68 10 42 80 00       	push   $0x804210
  803017:	68 4c 01 00 00       	push   $0x14c
  80301c:	68 bf 41 80 00       	push   $0x8041bf
  803021:	e8 ce d3 ff ff       	call   8003f4 <_panic>
  803026:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	89 50 04             	mov    %edx,0x4(%eax)
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 40 04             	mov    0x4(%eax),%eax
  803038:	85 c0                	test   %eax,%eax
  80303a:	74 0c                	je     803048 <insert_sorted_with_merge_freeList+0x2cd>
  80303c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803041:	8b 55 08             	mov    0x8(%ebp),%edx
  803044:	89 10                	mov    %edx,(%eax)
  803046:	eb 08                	jmp    803050 <insert_sorted_with_merge_freeList+0x2d5>
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	a3 38 51 80 00       	mov    %eax,0x805138
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803061:	a1 44 51 80 00       	mov    0x805144,%eax
  803066:	40                   	inc    %eax
  803067:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80306c:	e9 53 04 00 00       	jmp    8034c4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803071:	a1 38 51 80 00       	mov    0x805138,%eax
  803076:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803079:	e9 15 04 00 00       	jmp    803493 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	8b 50 08             	mov    0x8(%eax),%edx
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 40 08             	mov    0x8(%eax),%eax
  803092:	39 c2                	cmp    %eax,%edx
  803094:	0f 86 f1 03 00 00    	jbe    80348b <insert_sorted_with_merge_freeList+0x710>
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	8b 50 08             	mov    0x8(%eax),%edx
  8030a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a3:	8b 40 08             	mov    0x8(%eax),%eax
  8030a6:	39 c2                	cmp    %eax,%edx
  8030a8:	0f 83 dd 03 00 00    	jae    80348b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	8b 50 08             	mov    0x8(%eax),%edx
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ba:	01 c2                	add    %eax,%edx
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	8b 40 08             	mov    0x8(%eax),%eax
  8030c2:	39 c2                	cmp    %eax,%edx
  8030c4:	0f 85 b9 01 00 00    	jne    803283 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	8b 50 08             	mov    0x8(%eax),%edx
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d6:	01 c2                	add    %eax,%edx
  8030d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030db:	8b 40 08             	mov    0x8(%eax),%eax
  8030de:	39 c2                	cmp    %eax,%edx
  8030e0:	0f 85 0d 01 00 00    	jne    8031f3 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f2:	01 c2                	add    %eax,%edx
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030fe:	75 17                	jne    803117 <insert_sorted_with_merge_freeList+0x39c>
  803100:	83 ec 04             	sub    $0x4,%esp
  803103:	68 68 42 80 00       	push   $0x804268
  803108:	68 5c 01 00 00       	push   $0x15c
  80310d:	68 bf 41 80 00       	push   $0x8041bf
  803112:	e8 dd d2 ff ff       	call   8003f4 <_panic>
  803117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311a:	8b 00                	mov    (%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 10                	je     803130 <insert_sorted_with_merge_freeList+0x3b5>
  803120:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803128:	8b 52 04             	mov    0x4(%edx),%edx
  80312b:	89 50 04             	mov    %edx,0x4(%eax)
  80312e:	eb 0b                	jmp    80313b <insert_sorted_with_merge_freeList+0x3c0>
  803130:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803133:	8b 40 04             	mov    0x4(%eax),%eax
  803136:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80313b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313e:	8b 40 04             	mov    0x4(%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 0f                	je     803154 <insert_sorted_with_merge_freeList+0x3d9>
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 40 04             	mov    0x4(%eax),%eax
  80314b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314e:	8b 12                	mov    (%edx),%edx
  803150:	89 10                	mov    %edx,(%eax)
  803152:	eb 0a                	jmp    80315e <insert_sorted_with_merge_freeList+0x3e3>
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	a3 38 51 80 00       	mov    %eax,0x805138
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803171:	a1 44 51 80 00       	mov    0x805144,%eax
  803176:	48                   	dec    %eax
  803177:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80317c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803190:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803194:	75 17                	jne    8031ad <insert_sorted_with_merge_freeList+0x432>
  803196:	83 ec 04             	sub    $0x4,%esp
  803199:	68 9c 41 80 00       	push   $0x80419c
  80319e:	68 5f 01 00 00       	push   $0x15f
  8031a3:	68 bf 41 80 00       	push   $0x8041bf
  8031a8:	e8 47 d2 ff ff       	call   8003f4 <_panic>
  8031ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b6:	89 10                	mov    %edx,(%eax)
  8031b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	74 0d                	je     8031ce <insert_sorted_with_merge_freeList+0x453>
  8031c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c9:	89 50 04             	mov    %edx,0x4(%eax)
  8031cc:	eb 08                	jmp    8031d6 <insert_sorted_with_merge_freeList+0x45b>
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ed:	40                   	inc    %eax
  8031ee:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ff:	01 c2                	add    %eax,%edx
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80321b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321f:	75 17                	jne    803238 <insert_sorted_with_merge_freeList+0x4bd>
  803221:	83 ec 04             	sub    $0x4,%esp
  803224:	68 9c 41 80 00       	push   $0x80419c
  803229:	68 64 01 00 00       	push   $0x164
  80322e:	68 bf 41 80 00       	push   $0x8041bf
  803233:	e8 bc d1 ff ff       	call   8003f4 <_panic>
  803238:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	89 10                	mov    %edx,(%eax)
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	8b 00                	mov    (%eax),%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	74 0d                	je     803259 <insert_sorted_with_merge_freeList+0x4de>
  80324c:	a1 48 51 80 00       	mov    0x805148,%eax
  803251:	8b 55 08             	mov    0x8(%ebp),%edx
  803254:	89 50 04             	mov    %edx,0x4(%eax)
  803257:	eb 08                	jmp    803261 <insert_sorted_with_merge_freeList+0x4e6>
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	a3 48 51 80 00       	mov    %eax,0x805148
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803273:	a1 54 51 80 00       	mov    0x805154,%eax
  803278:	40                   	inc    %eax
  803279:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80327e:	e9 41 02 00 00       	jmp    8034c4 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	8b 50 08             	mov    0x8(%eax),%edx
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	8b 40 0c             	mov    0xc(%eax),%eax
  80328f:	01 c2                	add    %eax,%edx
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	8b 40 08             	mov    0x8(%eax),%eax
  803297:	39 c2                	cmp    %eax,%edx
  803299:	0f 85 7c 01 00 00    	jne    80341b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80329f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a3:	74 06                	je     8032ab <insert_sorted_with_merge_freeList+0x530>
  8032a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a9:	75 17                	jne    8032c2 <insert_sorted_with_merge_freeList+0x547>
  8032ab:	83 ec 04             	sub    $0x4,%esp
  8032ae:	68 d8 41 80 00       	push   $0x8041d8
  8032b3:	68 69 01 00 00       	push   $0x169
  8032b8:	68 bf 41 80 00       	push   $0x8041bf
  8032bd:	e8 32 d1 ff ff       	call   8003f4 <_panic>
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	8b 50 04             	mov    0x4(%eax),%edx
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	89 50 04             	mov    %edx,0x4(%eax)
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d4:	89 10                	mov    %edx,(%eax)
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	8b 40 04             	mov    0x4(%eax),%eax
  8032dc:	85 c0                	test   %eax,%eax
  8032de:	74 0d                	je     8032ed <insert_sorted_with_merge_freeList+0x572>
  8032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e3:	8b 40 04             	mov    0x4(%eax),%eax
  8032e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e9:	89 10                	mov    %edx,(%eax)
  8032eb:	eb 08                	jmp    8032f5 <insert_sorted_with_merge_freeList+0x57a>
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fb:	89 50 04             	mov    %edx,0x4(%eax)
  8032fe:	a1 44 51 80 00       	mov    0x805144,%eax
  803303:	40                   	inc    %eax
  803304:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	8b 50 0c             	mov    0xc(%eax),%edx
  80330f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803312:	8b 40 0c             	mov    0xc(%eax),%eax
  803315:	01 c2                	add    %eax,%edx
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80331d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803321:	75 17                	jne    80333a <insert_sorted_with_merge_freeList+0x5bf>
  803323:	83 ec 04             	sub    $0x4,%esp
  803326:	68 68 42 80 00       	push   $0x804268
  80332b:	68 6b 01 00 00       	push   $0x16b
  803330:	68 bf 41 80 00       	push   $0x8041bf
  803335:	e8 ba d0 ff ff       	call   8003f4 <_panic>
  80333a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	74 10                	je     803353 <insert_sorted_with_merge_freeList+0x5d8>
  803343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334b:	8b 52 04             	mov    0x4(%edx),%edx
  80334e:	89 50 04             	mov    %edx,0x4(%eax)
  803351:	eb 0b                	jmp    80335e <insert_sorted_with_merge_freeList+0x5e3>
  803353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803356:	8b 40 04             	mov    0x4(%eax),%eax
  803359:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803361:	8b 40 04             	mov    0x4(%eax),%eax
  803364:	85 c0                	test   %eax,%eax
  803366:	74 0f                	je     803377 <insert_sorted_with_merge_freeList+0x5fc>
  803368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803371:	8b 12                	mov    (%edx),%edx
  803373:	89 10                	mov    %edx,(%eax)
  803375:	eb 0a                	jmp    803381 <insert_sorted_with_merge_freeList+0x606>
  803377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	a3 38 51 80 00       	mov    %eax,0x805138
  803381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803384:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803394:	a1 44 51 80 00       	mov    0x805144,%eax
  803399:	48                   	dec    %eax
  80339a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80339f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033b7:	75 17                	jne    8033d0 <insert_sorted_with_merge_freeList+0x655>
  8033b9:	83 ec 04             	sub    $0x4,%esp
  8033bc:	68 9c 41 80 00       	push   $0x80419c
  8033c1:	68 6e 01 00 00       	push   $0x16e
  8033c6:	68 bf 41 80 00       	push   $0x8041bf
  8033cb:	e8 24 d0 ff ff       	call   8003f4 <_panic>
  8033d0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d9:	89 10                	mov    %edx,(%eax)
  8033db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	85 c0                	test   %eax,%eax
  8033e2:	74 0d                	je     8033f1 <insert_sorted_with_merge_freeList+0x676>
  8033e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ec:	89 50 04             	mov    %edx,0x4(%eax)
  8033ef:	eb 08                	jmp    8033f9 <insert_sorted_with_merge_freeList+0x67e>
  8033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fc:	a3 48 51 80 00       	mov    %eax,0x805148
  803401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803404:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340b:	a1 54 51 80 00       	mov    0x805154,%eax
  803410:	40                   	inc    %eax
  803411:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803416:	e9 a9 00 00 00       	jmp    8034c4 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80341b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341f:	74 06                	je     803427 <insert_sorted_with_merge_freeList+0x6ac>
  803421:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803425:	75 17                	jne    80343e <insert_sorted_with_merge_freeList+0x6c3>
  803427:	83 ec 04             	sub    $0x4,%esp
  80342a:	68 34 42 80 00       	push   $0x804234
  80342f:	68 73 01 00 00       	push   $0x173
  803434:	68 bf 41 80 00       	push   $0x8041bf
  803439:	e8 b6 cf ff ff       	call   8003f4 <_panic>
  80343e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803441:	8b 10                	mov    (%eax),%edx
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	89 10                	mov    %edx,(%eax)
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	74 0b                	je     80345c <insert_sorted_with_merge_freeList+0x6e1>
  803451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803454:	8b 00                	mov    (%eax),%eax
  803456:	8b 55 08             	mov    0x8(%ebp),%edx
  803459:	89 50 04             	mov    %edx,0x4(%eax)
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	8b 55 08             	mov    0x8(%ebp),%edx
  803462:	89 10                	mov    %edx,(%eax)
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80346a:	89 50 04             	mov    %edx,0x4(%eax)
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	85 c0                	test   %eax,%eax
  803474:	75 08                	jne    80347e <insert_sorted_with_merge_freeList+0x703>
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80347e:	a1 44 51 80 00       	mov    0x805144,%eax
  803483:	40                   	inc    %eax
  803484:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803489:	eb 39                	jmp    8034c4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80348b:	a1 40 51 80 00       	mov    0x805140,%eax
  803490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803497:	74 07                	je     8034a0 <insert_sorted_with_merge_freeList+0x725>
  803499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349c:	8b 00                	mov    (%eax),%eax
  80349e:	eb 05                	jmp    8034a5 <insert_sorted_with_merge_freeList+0x72a>
  8034a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a5:	a3 40 51 80 00       	mov    %eax,0x805140
  8034aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8034af:	85 c0                	test   %eax,%eax
  8034b1:	0f 85 c7 fb ff ff    	jne    80307e <insert_sorted_with_merge_freeList+0x303>
  8034b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034bb:	0f 85 bd fb ff ff    	jne    80307e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034c1:	eb 01                	jmp    8034c4 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034c3:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034c4:	90                   	nop
  8034c5:	c9                   	leave  
  8034c6:	c3                   	ret    
  8034c7:	90                   	nop

008034c8 <__udivdi3>:
  8034c8:	55                   	push   %ebp
  8034c9:	57                   	push   %edi
  8034ca:	56                   	push   %esi
  8034cb:	53                   	push   %ebx
  8034cc:	83 ec 1c             	sub    $0x1c,%esp
  8034cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034df:	89 ca                	mov    %ecx,%edx
  8034e1:	89 f8                	mov    %edi,%eax
  8034e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034e7:	85 f6                	test   %esi,%esi
  8034e9:	75 2d                	jne    803518 <__udivdi3+0x50>
  8034eb:	39 cf                	cmp    %ecx,%edi
  8034ed:	77 65                	ja     803554 <__udivdi3+0x8c>
  8034ef:	89 fd                	mov    %edi,%ebp
  8034f1:	85 ff                	test   %edi,%edi
  8034f3:	75 0b                	jne    803500 <__udivdi3+0x38>
  8034f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034fa:	31 d2                	xor    %edx,%edx
  8034fc:	f7 f7                	div    %edi
  8034fe:	89 c5                	mov    %eax,%ebp
  803500:	31 d2                	xor    %edx,%edx
  803502:	89 c8                	mov    %ecx,%eax
  803504:	f7 f5                	div    %ebp
  803506:	89 c1                	mov    %eax,%ecx
  803508:	89 d8                	mov    %ebx,%eax
  80350a:	f7 f5                	div    %ebp
  80350c:	89 cf                	mov    %ecx,%edi
  80350e:	89 fa                	mov    %edi,%edx
  803510:	83 c4 1c             	add    $0x1c,%esp
  803513:	5b                   	pop    %ebx
  803514:	5e                   	pop    %esi
  803515:	5f                   	pop    %edi
  803516:	5d                   	pop    %ebp
  803517:	c3                   	ret    
  803518:	39 ce                	cmp    %ecx,%esi
  80351a:	77 28                	ja     803544 <__udivdi3+0x7c>
  80351c:	0f bd fe             	bsr    %esi,%edi
  80351f:	83 f7 1f             	xor    $0x1f,%edi
  803522:	75 40                	jne    803564 <__udivdi3+0x9c>
  803524:	39 ce                	cmp    %ecx,%esi
  803526:	72 0a                	jb     803532 <__udivdi3+0x6a>
  803528:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80352c:	0f 87 9e 00 00 00    	ja     8035d0 <__udivdi3+0x108>
  803532:	b8 01 00 00 00       	mov    $0x1,%eax
  803537:	89 fa                	mov    %edi,%edx
  803539:	83 c4 1c             	add    $0x1c,%esp
  80353c:	5b                   	pop    %ebx
  80353d:	5e                   	pop    %esi
  80353e:	5f                   	pop    %edi
  80353f:	5d                   	pop    %ebp
  803540:	c3                   	ret    
  803541:	8d 76 00             	lea    0x0(%esi),%esi
  803544:	31 ff                	xor    %edi,%edi
  803546:	31 c0                	xor    %eax,%eax
  803548:	89 fa                	mov    %edi,%edx
  80354a:	83 c4 1c             	add    $0x1c,%esp
  80354d:	5b                   	pop    %ebx
  80354e:	5e                   	pop    %esi
  80354f:	5f                   	pop    %edi
  803550:	5d                   	pop    %ebp
  803551:	c3                   	ret    
  803552:	66 90                	xchg   %ax,%ax
  803554:	89 d8                	mov    %ebx,%eax
  803556:	f7 f7                	div    %edi
  803558:	31 ff                	xor    %edi,%edi
  80355a:	89 fa                	mov    %edi,%edx
  80355c:	83 c4 1c             	add    $0x1c,%esp
  80355f:	5b                   	pop    %ebx
  803560:	5e                   	pop    %esi
  803561:	5f                   	pop    %edi
  803562:	5d                   	pop    %ebp
  803563:	c3                   	ret    
  803564:	bd 20 00 00 00       	mov    $0x20,%ebp
  803569:	89 eb                	mov    %ebp,%ebx
  80356b:	29 fb                	sub    %edi,%ebx
  80356d:	89 f9                	mov    %edi,%ecx
  80356f:	d3 e6                	shl    %cl,%esi
  803571:	89 c5                	mov    %eax,%ebp
  803573:	88 d9                	mov    %bl,%cl
  803575:	d3 ed                	shr    %cl,%ebp
  803577:	89 e9                	mov    %ebp,%ecx
  803579:	09 f1                	or     %esi,%ecx
  80357b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80357f:	89 f9                	mov    %edi,%ecx
  803581:	d3 e0                	shl    %cl,%eax
  803583:	89 c5                	mov    %eax,%ebp
  803585:	89 d6                	mov    %edx,%esi
  803587:	88 d9                	mov    %bl,%cl
  803589:	d3 ee                	shr    %cl,%esi
  80358b:	89 f9                	mov    %edi,%ecx
  80358d:	d3 e2                	shl    %cl,%edx
  80358f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803593:	88 d9                	mov    %bl,%cl
  803595:	d3 e8                	shr    %cl,%eax
  803597:	09 c2                	or     %eax,%edx
  803599:	89 d0                	mov    %edx,%eax
  80359b:	89 f2                	mov    %esi,%edx
  80359d:	f7 74 24 0c          	divl   0xc(%esp)
  8035a1:	89 d6                	mov    %edx,%esi
  8035a3:	89 c3                	mov    %eax,%ebx
  8035a5:	f7 e5                	mul    %ebp
  8035a7:	39 d6                	cmp    %edx,%esi
  8035a9:	72 19                	jb     8035c4 <__udivdi3+0xfc>
  8035ab:	74 0b                	je     8035b8 <__udivdi3+0xf0>
  8035ad:	89 d8                	mov    %ebx,%eax
  8035af:	31 ff                	xor    %edi,%edi
  8035b1:	e9 58 ff ff ff       	jmp    80350e <__udivdi3+0x46>
  8035b6:	66 90                	xchg   %ax,%ax
  8035b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035bc:	89 f9                	mov    %edi,%ecx
  8035be:	d3 e2                	shl    %cl,%edx
  8035c0:	39 c2                	cmp    %eax,%edx
  8035c2:	73 e9                	jae    8035ad <__udivdi3+0xe5>
  8035c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035c7:	31 ff                	xor    %edi,%edi
  8035c9:	e9 40 ff ff ff       	jmp    80350e <__udivdi3+0x46>
  8035ce:	66 90                	xchg   %ax,%ax
  8035d0:	31 c0                	xor    %eax,%eax
  8035d2:	e9 37 ff ff ff       	jmp    80350e <__udivdi3+0x46>
  8035d7:	90                   	nop

008035d8 <__umoddi3>:
  8035d8:	55                   	push   %ebp
  8035d9:	57                   	push   %edi
  8035da:	56                   	push   %esi
  8035db:	53                   	push   %ebx
  8035dc:	83 ec 1c             	sub    $0x1c,%esp
  8035df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035f7:	89 f3                	mov    %esi,%ebx
  8035f9:	89 fa                	mov    %edi,%edx
  8035fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ff:	89 34 24             	mov    %esi,(%esp)
  803602:	85 c0                	test   %eax,%eax
  803604:	75 1a                	jne    803620 <__umoddi3+0x48>
  803606:	39 f7                	cmp    %esi,%edi
  803608:	0f 86 a2 00 00 00    	jbe    8036b0 <__umoddi3+0xd8>
  80360e:	89 c8                	mov    %ecx,%eax
  803610:	89 f2                	mov    %esi,%edx
  803612:	f7 f7                	div    %edi
  803614:	89 d0                	mov    %edx,%eax
  803616:	31 d2                	xor    %edx,%edx
  803618:	83 c4 1c             	add    $0x1c,%esp
  80361b:	5b                   	pop    %ebx
  80361c:	5e                   	pop    %esi
  80361d:	5f                   	pop    %edi
  80361e:	5d                   	pop    %ebp
  80361f:	c3                   	ret    
  803620:	39 f0                	cmp    %esi,%eax
  803622:	0f 87 ac 00 00 00    	ja     8036d4 <__umoddi3+0xfc>
  803628:	0f bd e8             	bsr    %eax,%ebp
  80362b:	83 f5 1f             	xor    $0x1f,%ebp
  80362e:	0f 84 ac 00 00 00    	je     8036e0 <__umoddi3+0x108>
  803634:	bf 20 00 00 00       	mov    $0x20,%edi
  803639:	29 ef                	sub    %ebp,%edi
  80363b:	89 fe                	mov    %edi,%esi
  80363d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803641:	89 e9                	mov    %ebp,%ecx
  803643:	d3 e0                	shl    %cl,%eax
  803645:	89 d7                	mov    %edx,%edi
  803647:	89 f1                	mov    %esi,%ecx
  803649:	d3 ef                	shr    %cl,%edi
  80364b:	09 c7                	or     %eax,%edi
  80364d:	89 e9                	mov    %ebp,%ecx
  80364f:	d3 e2                	shl    %cl,%edx
  803651:	89 14 24             	mov    %edx,(%esp)
  803654:	89 d8                	mov    %ebx,%eax
  803656:	d3 e0                	shl    %cl,%eax
  803658:	89 c2                	mov    %eax,%edx
  80365a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80365e:	d3 e0                	shl    %cl,%eax
  803660:	89 44 24 04          	mov    %eax,0x4(%esp)
  803664:	8b 44 24 08          	mov    0x8(%esp),%eax
  803668:	89 f1                	mov    %esi,%ecx
  80366a:	d3 e8                	shr    %cl,%eax
  80366c:	09 d0                	or     %edx,%eax
  80366e:	d3 eb                	shr    %cl,%ebx
  803670:	89 da                	mov    %ebx,%edx
  803672:	f7 f7                	div    %edi
  803674:	89 d3                	mov    %edx,%ebx
  803676:	f7 24 24             	mull   (%esp)
  803679:	89 c6                	mov    %eax,%esi
  80367b:	89 d1                	mov    %edx,%ecx
  80367d:	39 d3                	cmp    %edx,%ebx
  80367f:	0f 82 87 00 00 00    	jb     80370c <__umoddi3+0x134>
  803685:	0f 84 91 00 00 00    	je     80371c <__umoddi3+0x144>
  80368b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80368f:	29 f2                	sub    %esi,%edx
  803691:	19 cb                	sbb    %ecx,%ebx
  803693:	89 d8                	mov    %ebx,%eax
  803695:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803699:	d3 e0                	shl    %cl,%eax
  80369b:	89 e9                	mov    %ebp,%ecx
  80369d:	d3 ea                	shr    %cl,%edx
  80369f:	09 d0                	or     %edx,%eax
  8036a1:	89 e9                	mov    %ebp,%ecx
  8036a3:	d3 eb                	shr    %cl,%ebx
  8036a5:	89 da                	mov    %ebx,%edx
  8036a7:	83 c4 1c             	add    $0x1c,%esp
  8036aa:	5b                   	pop    %ebx
  8036ab:	5e                   	pop    %esi
  8036ac:	5f                   	pop    %edi
  8036ad:	5d                   	pop    %ebp
  8036ae:	c3                   	ret    
  8036af:	90                   	nop
  8036b0:	89 fd                	mov    %edi,%ebp
  8036b2:	85 ff                	test   %edi,%edi
  8036b4:	75 0b                	jne    8036c1 <__umoddi3+0xe9>
  8036b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036bb:	31 d2                	xor    %edx,%edx
  8036bd:	f7 f7                	div    %edi
  8036bf:	89 c5                	mov    %eax,%ebp
  8036c1:	89 f0                	mov    %esi,%eax
  8036c3:	31 d2                	xor    %edx,%edx
  8036c5:	f7 f5                	div    %ebp
  8036c7:	89 c8                	mov    %ecx,%eax
  8036c9:	f7 f5                	div    %ebp
  8036cb:	89 d0                	mov    %edx,%eax
  8036cd:	e9 44 ff ff ff       	jmp    803616 <__umoddi3+0x3e>
  8036d2:	66 90                	xchg   %ax,%ax
  8036d4:	89 c8                	mov    %ecx,%eax
  8036d6:	89 f2                	mov    %esi,%edx
  8036d8:	83 c4 1c             	add    $0x1c,%esp
  8036db:	5b                   	pop    %ebx
  8036dc:	5e                   	pop    %esi
  8036dd:	5f                   	pop    %edi
  8036de:	5d                   	pop    %ebp
  8036df:	c3                   	ret    
  8036e0:	3b 04 24             	cmp    (%esp),%eax
  8036e3:	72 06                	jb     8036eb <__umoddi3+0x113>
  8036e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036e9:	77 0f                	ja     8036fa <__umoddi3+0x122>
  8036eb:	89 f2                	mov    %esi,%edx
  8036ed:	29 f9                	sub    %edi,%ecx
  8036ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036f3:	89 14 24             	mov    %edx,(%esp)
  8036f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036fe:	8b 14 24             	mov    (%esp),%edx
  803701:	83 c4 1c             	add    $0x1c,%esp
  803704:	5b                   	pop    %ebx
  803705:	5e                   	pop    %esi
  803706:	5f                   	pop    %edi
  803707:	5d                   	pop    %ebp
  803708:	c3                   	ret    
  803709:	8d 76 00             	lea    0x0(%esi),%esi
  80370c:	2b 04 24             	sub    (%esp),%eax
  80370f:	19 fa                	sbb    %edi,%edx
  803711:	89 d1                	mov    %edx,%ecx
  803713:	89 c6                	mov    %eax,%esi
  803715:	e9 71 ff ff ff       	jmp    80368b <__umoddi3+0xb3>
  80371a:	66 90                	xchg   %ax,%ax
  80371c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803720:	72 ea                	jb     80370c <__umoddi3+0x134>
  803722:	89 d9                	mov    %ebx,%ecx
  803724:	e9 62 ff ff ff       	jmp    80368b <__umoddi3+0xb3>
