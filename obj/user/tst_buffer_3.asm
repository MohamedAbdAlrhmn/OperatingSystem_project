
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
  80004d:	e8 fe 17 00 00       	call   801850 <sys_calculate_free_frames>
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
  80007b:	e8 d0 17 00 00       	call   801850 <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 e1 17 00 00       	call   801869 <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 80 36 80 00       	push   $0x803680
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
  80015c:	e8 fd 14 00 00       	call   80165e <free>
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
  8001d9:	68 a0 36 80 00       	push   $0x8036a0
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 ce 36 80 00       	push   $0x8036ce
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
  800200:	e8 4b 16 00 00       	call   801850 <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 5c 16 00 00       	call   801869 <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 54 16 00 00       	call   801869 <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 34 16 00 00       	call   801850 <sys_calculate_free_frames>
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
  800235:	68 e4 36 80 00       	push   $0x8036e4
  80023a:	6a 53                	push   $0x53
  80023c:	68 ce 36 80 00       	push   $0x8036ce
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 38 37 80 00       	push   $0x803738
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 94 37 80 00       	push   $0x803794
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
  8002a7:	68 78 38 80 00       	push   $0x803878
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 ce 36 80 00       	push   $0x8036ce
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
  8002be:	e8 6d 18 00 00       	call   801b30 <sys_getenvindex>
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
  800329:	e8 0f 16 00 00       	call   80193d <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 98 39 80 00       	push   $0x803998
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
  800359:	68 c0 39 80 00       	push   $0x8039c0
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
  80038a:	68 e8 39 80 00       	push   $0x8039e8
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 50 80 00       	mov    0x805020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 40 3a 80 00       	push   $0x803a40
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 98 39 80 00       	push   $0x803998
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 8f 15 00 00       	call   801957 <sys_enable_interrupt>

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
  8003db:	e8 1c 17 00 00       	call   801afc <sys_destroy_env>
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
  8003ec:	e8 71 17 00 00       	call   801b62 <sys_exit_env>
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
  800415:	68 54 3a 80 00       	push   $0x803a54
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 50 80 00       	mov    0x805000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 59 3a 80 00       	push   $0x803a59
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
  800452:	68 75 3a 80 00       	push   $0x803a75
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
  80047e:	68 78 3a 80 00       	push   $0x803a78
  800483:	6a 26                	push   $0x26
  800485:	68 c4 3a 80 00       	push   $0x803ac4
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
  800550:	68 d0 3a 80 00       	push   $0x803ad0
  800555:	6a 3a                	push   $0x3a
  800557:	68 c4 3a 80 00       	push   $0x803ac4
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
  8005c0:	68 24 3b 80 00       	push   $0x803b24
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 c4 3a 80 00       	push   $0x803ac4
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
  80061a:	e8 70 11 00 00       	call   80178f <sys_cputs>
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
  800691:	e8 f9 10 00 00       	call   80178f <sys_cputs>
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
  8006db:	e8 5d 12 00 00       	call   80193d <sys_disable_interrupt>
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
  8006fb:	e8 57 12 00 00       	call   801957 <sys_enable_interrupt>
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
  800745:	e8 ca 2c 00 00       	call   803414 <__udivdi3>
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
  800795:	e8 8a 2d 00 00       	call   803524 <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 94 3d 80 00       	add    $0x803d94,%eax
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
  8008f0:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
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
  8009d1:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 a5 3d 80 00       	push   $0x803da5
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
  8009f6:	68 ae 3d 80 00       	push   $0x803dae
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
  800a23:	be b1 3d 80 00       	mov    $0x803db1,%esi
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
  801449:	68 10 3f 80 00       	push   $0x803f10
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
  801519:	e8 b5 03 00 00       	call   8018d3 <sys_allocate_chunk>
  80151e:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801521:	a1 20 51 80 00       	mov    0x805120,%eax
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	50                   	push   %eax
  80152a:	e8 2a 0a 00 00       	call   801f59 <initialize_MemBlocksList>
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
  801557:	68 35 3f 80 00       	push   $0x803f35
  80155c:	6a 33                	push   $0x33
  80155e:	68 53 3f 80 00       	push   $0x803f53
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
  8015d6:	68 60 3f 80 00       	push   $0x803f60
  8015db:	6a 34                	push   $0x34
  8015dd:	68 53 3f 80 00       	push   $0x803f53
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
  801633:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801636:	e8 f7 fd ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  80163b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80163f:	75 07                	jne    801648 <malloc+0x18>
  801641:	b8 00 00 00 00       	mov    $0x0,%eax
  801646:	eb 14                	jmp    80165c <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801648:	83 ec 04             	sub    $0x4,%esp
  80164b:	68 84 3f 80 00       	push   $0x803f84
  801650:	6a 46                	push   $0x46
  801652:	68 53 3f 80 00       	push   $0x803f53
  801657:	e8 98 ed ff ff       	call   8003f4 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	68 ac 3f 80 00       	push   $0x803fac
  80166c:	6a 61                	push   $0x61
  80166e:	68 53 3f 80 00       	push   $0x803f53
  801673:	e8 7c ed ff ff       	call   8003f4 <_panic>

00801678 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 18             	sub    $0x18,%esp
  80167e:	8b 45 10             	mov    0x10(%ebp),%eax
  801681:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801684:	e8 a9 fd ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  801689:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168d:	75 07                	jne    801696 <smalloc+0x1e>
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
  801694:	eb 14                	jmp    8016aa <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	68 d0 3f 80 00       	push   $0x803fd0
  80169e:	6a 76                	push   $0x76
  8016a0:	68 53 3f 80 00       	push   $0x803f53
  8016a5:	e8 4a ed ff ff       	call   8003f4 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b2:	e8 7b fd ff ff       	call   801432 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	68 f8 3f 80 00       	push   $0x803ff8
  8016bf:	68 93 00 00 00       	push   $0x93
  8016c4:	68 53 3f 80 00       	push   $0x803f53
  8016c9:	e8 26 ed ff ff       	call   8003f4 <_panic>

008016ce <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d4:	e8 59 fd ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	68 1c 40 80 00       	push   $0x80401c
  8016e1:	68 c5 00 00 00       	push   $0xc5
  8016e6:	68 53 3f 80 00       	push   $0x803f53
  8016eb:	e8 04 ed ff ff       	call   8003f4 <_panic>

008016f0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	68 44 40 80 00       	push   $0x804044
  8016fe:	68 d9 00 00 00       	push   $0xd9
  801703:	68 53 3f 80 00       	push   $0x803f53
  801708:	e8 e7 ec ff ff       	call   8003f4 <_panic>

0080170d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	68 68 40 80 00       	push   $0x804068
  80171b:	68 e4 00 00 00       	push   $0xe4
  801720:	68 53 3f 80 00       	push   $0x803f53
  801725:	e8 ca ec ff ff       	call   8003f4 <_panic>

0080172a <shrink>:

}
void shrink(uint32 newSize)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	68 68 40 80 00       	push   $0x804068
  801738:	68 e9 00 00 00       	push   $0xe9
  80173d:	68 53 3f 80 00       	push   $0x803f53
  801742:	e8 ad ec ff ff       	call   8003f4 <_panic>

00801747 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	68 68 40 80 00       	push   $0x804068
  801755:	68 ee 00 00 00       	push   $0xee
  80175a:	68 53 3f 80 00       	push   $0x803f53
  80175f:	e8 90 ec ff ff       	call   8003f4 <_panic>

00801764 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	57                   	push   %edi
  801768:	56                   	push   %esi
  801769:	53                   	push   %ebx
  80176a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8b 55 0c             	mov    0xc(%ebp),%edx
  801773:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801776:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801779:	8b 7d 18             	mov    0x18(%ebp),%edi
  80177c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80177f:	cd 30                	int    $0x30
  801781:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801784:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	5b                   	pop    %ebx
  80178b:	5e                   	pop    %esi
  80178c:	5f                   	pop    %edi
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    

0080178f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	8b 45 10             	mov    0x10(%ebp),%eax
  801798:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80179b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	52                   	push   %edx
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	50                   	push   %eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	e8 b2 ff ff ff       	call   801764 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	90                   	nop
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 01                	push   $0x1
  8017c7:	e8 98 ff ff ff       	call   801764 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	52                   	push   %edx
  8017e1:	50                   	push   %eax
  8017e2:	6a 05                	push   $0x5
  8017e4:	e8 7b ff ff ff       	call   801764 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	56                   	push   %esi
  8017f2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017f3:	8b 75 18             	mov    0x18(%ebp),%esi
  8017f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	56                   	push   %esi
  801803:	53                   	push   %ebx
  801804:	51                   	push   %ecx
  801805:	52                   	push   %edx
  801806:	50                   	push   %eax
  801807:	6a 06                	push   $0x6
  801809:	e8 56 ff ff ff       	call   801764 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801814:	5b                   	pop    %ebx
  801815:	5e                   	pop    %esi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    

00801818 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80181b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	52                   	push   %edx
  801828:	50                   	push   %eax
  801829:	6a 07                	push   $0x7
  80182b:	e8 34 ff ff ff       	call   801764 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	ff 75 08             	pushl  0x8(%ebp)
  801844:	6a 08                	push   $0x8
  801846:	e8 19 ff ff ff       	call   801764 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 09                	push   $0x9
  80185f:	e8 00 ff ff ff       	call   801764 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 0a                	push   $0xa
  801878:	e8 e7 fe ff ff       	call   801764 <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 0b                	push   $0xb
  801891:	e8 ce fe ff ff       	call   801764 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	ff 75 08             	pushl  0x8(%ebp)
  8018aa:	6a 0f                	push   $0xf
  8018ac:	e8 b3 fe ff ff       	call   801764 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
	return;
  8018b4:	90                   	nop
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	6a 10                	push   $0x10
  8018c8:	e8 97 fe ff ff       	call   801764 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d0:	90                   	nop
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	ff 75 10             	pushl  0x10(%ebp)
  8018dd:	ff 75 0c             	pushl  0xc(%ebp)
  8018e0:	ff 75 08             	pushl  0x8(%ebp)
  8018e3:	6a 11                	push   $0x11
  8018e5:	e8 7a fe ff ff       	call   801764 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ed:	90                   	nop
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 0c                	push   $0xc
  8018ff:	e8 60 fe ff ff       	call   801764 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	6a 0d                	push   $0xd
  801919:	e8 46 fe ff ff       	call   801764 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 0e                	push   $0xe
  801932:	e8 2d fe ff ff       	call   801764 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	90                   	nop
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 13                	push   $0x13
  80194c:	e8 13 fe ff ff       	call   801764 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	90                   	nop
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 14                	push   $0x14
  801966:	e8 f9 fd ff ff       	call   801764 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	90                   	nop
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_cputc>:


void
sys_cputc(const char c)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80197d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	50                   	push   %eax
  80198a:	6a 15                	push   $0x15
  80198c:	e8 d3 fd ff ff       	call   801764 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 16                	push   $0x16
  8019a6:	e8 b9 fd ff ff       	call   801764 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	50                   	push   %eax
  8019c1:	6a 17                	push   $0x17
  8019c3:	e8 9c fd ff ff       	call   801764 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	52                   	push   %edx
  8019dd:	50                   	push   %eax
  8019de:	6a 1a                	push   $0x1a
  8019e0:	e8 7f fd ff ff       	call   801764 <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	52                   	push   %edx
  8019fa:	50                   	push   %eax
  8019fb:	6a 18                	push   $0x18
  8019fd:	e8 62 fd ff ff       	call   801764 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	90                   	nop
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	52                   	push   %edx
  801a18:	50                   	push   %eax
  801a19:	6a 19                	push   $0x19
  801a1b:	e8 44 fd ff ff       	call   801764 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a32:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a35:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	6a 00                	push   $0x0
  801a3e:	51                   	push   %ecx
  801a3f:	52                   	push   %edx
  801a40:	ff 75 0c             	pushl  0xc(%ebp)
  801a43:	50                   	push   %eax
  801a44:	6a 1b                	push   $0x1b
  801a46:	e8 19 fd ff ff       	call   801764 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	52                   	push   %edx
  801a60:	50                   	push   %eax
  801a61:	6a 1c                	push   $0x1c
  801a63:	e8 fc fc ff ff       	call   801764 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	51                   	push   %ecx
  801a7e:	52                   	push   %edx
  801a7f:	50                   	push   %eax
  801a80:	6a 1d                	push   $0x1d
  801a82:	e8 dd fc ff ff       	call   801764 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	50                   	push   %eax
  801a9d:	6a 1e                	push   $0x1e
  801a9f:	e8 c0 fc ff ff       	call   801764 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 1f                	push   $0x1f
  801ab8:	e8 a7 fc ff ff       	call   801764 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	ff 75 14             	pushl  0x14(%ebp)
  801acd:	ff 75 10             	pushl  0x10(%ebp)
  801ad0:	ff 75 0c             	pushl  0xc(%ebp)
  801ad3:	50                   	push   %eax
  801ad4:	6a 20                	push   $0x20
  801ad6:	e8 89 fc ff ff       	call   801764 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	50                   	push   %eax
  801aef:	6a 21                	push   $0x21
  801af1:	e8 6e fc ff ff       	call   801764 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	90                   	nop
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	50                   	push   %eax
  801b0b:	6a 22                	push   $0x22
  801b0d:	e8 52 fc ff ff       	call   801764 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 02                	push   $0x2
  801b26:	e8 39 fc ff ff       	call   801764 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 03                	push   $0x3
  801b3f:	e8 20 fc ff ff       	call   801764 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 04                	push   $0x4
  801b58:	e8 07 fc ff ff       	call   801764 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_exit_env>:


void sys_exit_env(void)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 23                	push   $0x23
  801b71:	e8 ee fb ff ff       	call   801764 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	90                   	nop
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b82:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b85:	8d 50 04             	lea    0x4(%eax),%edx
  801b88:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	52                   	push   %edx
  801b92:	50                   	push   %eax
  801b93:	6a 24                	push   $0x24
  801b95:	e8 ca fb ff ff       	call   801764 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
	return result;
  801b9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba6:	89 01                	mov    %eax,(%ecx)
  801ba8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	c9                   	leave  
  801baf:	c2 04 00             	ret    $0x4

00801bb2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	ff 75 10             	pushl  0x10(%ebp)
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	ff 75 08             	pushl  0x8(%ebp)
  801bc2:	6a 12                	push   $0x12
  801bc4:	e8 9b fb ff ff       	call   801764 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcc:	90                   	nop
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_rcr2>:
uint32 sys_rcr2()
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 25                	push   $0x25
  801bde:	e8 81 fb ff ff       	call   801764 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bf4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	50                   	push   %eax
  801c01:	6a 26                	push   $0x26
  801c03:	e8 5c fb ff ff       	call   801764 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0b:	90                   	nop
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <rsttst>:
void rsttst()
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 28                	push   $0x28
  801c1d:	e8 42 fb ff ff       	call   801764 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
	return ;
  801c25:	90                   	nop
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 04             	sub    $0x4,%esp
  801c2e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c34:	8b 55 18             	mov    0x18(%ebp),%edx
  801c37:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c3b:	52                   	push   %edx
  801c3c:	50                   	push   %eax
  801c3d:	ff 75 10             	pushl  0x10(%ebp)
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	ff 75 08             	pushl  0x8(%ebp)
  801c46:	6a 27                	push   $0x27
  801c48:	e8 17 fb ff ff       	call   801764 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c50:	90                   	nop
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <chktst>:
void chktst(uint32 n)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	ff 75 08             	pushl  0x8(%ebp)
  801c61:	6a 29                	push   $0x29
  801c63:	e8 fc fa ff ff       	call   801764 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6b:	90                   	nop
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <inctst>:

void inctst()
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 2a                	push   $0x2a
  801c7d:	e8 e2 fa ff ff       	call   801764 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
	return ;
  801c85:	90                   	nop
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <gettst>:
uint32 gettst()
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 2b                	push   $0x2b
  801c97:	e8 c8 fa ff ff       	call   801764 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 2c                	push   $0x2c
  801cb3:	e8 ac fa ff ff       	call   801764 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
  801cbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cbe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cc2:	75 07                	jne    801ccb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cc4:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc9:	eb 05                	jmp    801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ccb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 2c                	push   $0x2c
  801ce4:	e8 7b fa ff ff       	call   801764 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
  801cec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cef:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cf3:	75 07                	jne    801cfc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cf5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfa:	eb 05                	jmp    801d01 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 2c                	push   $0x2c
  801d15:	e8 4a fa ff ff       	call   801764 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
  801d1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d20:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d24:	75 07                	jne    801d2d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d26:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2b:	eb 05                	jmp    801d32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 2c                	push   $0x2c
  801d46:	e8 19 fa ff ff       	call   801764 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
  801d4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d51:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d55:	75 07                	jne    801d5e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d57:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5c:	eb 05                	jmp    801d63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	6a 2d                	push   $0x2d
  801d75:	e8 ea f9 ff ff       	call   801764 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7d:	90                   	nop
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	6a 00                	push   $0x0
  801d92:	53                   	push   %ebx
  801d93:	51                   	push   %ecx
  801d94:	52                   	push   %edx
  801d95:	50                   	push   %eax
  801d96:	6a 2e                	push   $0x2e
  801d98:	e8 c7 f9 ff ff       	call   801764 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 2f                	push   $0x2f
  801db8:	e8 a7 f9 ff ff       	call   801764 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dc8:	83 ec 0c             	sub    $0xc,%esp
  801dcb:	68 78 40 80 00       	push   $0x804078
  801dd0:	e8 d3 e8 ff ff       	call   8006a8 <cprintf>
  801dd5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801dd8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ddf:	83 ec 0c             	sub    $0xc,%esp
  801de2:	68 a4 40 80 00       	push   $0x8040a4
  801de7:	e8 bc e8 ff ff       	call   8006a8 <cprintf>
  801dec:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801def:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df3:	a1 38 51 80 00       	mov    0x805138,%eax
  801df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfb:	eb 56                	jmp    801e53 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e01:	74 1c                	je     801e1f <print_mem_block_lists+0x5d>
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	8b 50 08             	mov    0x8(%eax),%edx
  801e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e12:	8b 40 0c             	mov    0xc(%eax),%eax
  801e15:	01 c8                	add    %ecx,%eax
  801e17:	39 c2                	cmp    %eax,%edx
  801e19:	73 04                	jae    801e1f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e1b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e22:	8b 50 08             	mov    0x8(%eax),%edx
  801e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e28:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2b:	01 c2                	add    %eax,%edx
  801e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e30:	8b 40 08             	mov    0x8(%eax),%eax
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	52                   	push   %edx
  801e37:	50                   	push   %eax
  801e38:	68 b9 40 80 00       	push   $0x8040b9
  801e3d:	e8 66 e8 ff ff       	call   8006a8 <cprintf>
  801e42:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e4b:	a1 40 51 80 00       	mov    0x805140,%eax
  801e50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e57:	74 07                	je     801e60 <print_mem_block_lists+0x9e>
  801e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5c:	8b 00                	mov    (%eax),%eax
  801e5e:	eb 05                	jmp    801e65 <print_mem_block_lists+0xa3>
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
  801e65:	a3 40 51 80 00       	mov    %eax,0x805140
  801e6a:	a1 40 51 80 00       	mov    0x805140,%eax
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	75 8a                	jne    801dfd <print_mem_block_lists+0x3b>
  801e73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e77:	75 84                	jne    801dfd <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e79:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e7d:	75 10                	jne    801e8f <print_mem_block_lists+0xcd>
  801e7f:	83 ec 0c             	sub    $0xc,%esp
  801e82:	68 c8 40 80 00       	push   $0x8040c8
  801e87:	e8 1c e8 ff ff       	call   8006a8 <cprintf>
  801e8c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e8f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	68 ec 40 80 00       	push   $0x8040ec
  801e9e:	e8 05 e8 ff ff       	call   8006a8 <cprintf>
  801ea3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ea6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eaa:	a1 40 50 80 00       	mov    0x805040,%eax
  801eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb2:	eb 56                	jmp    801f0a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb8:	74 1c                	je     801ed6 <print_mem_block_lists+0x114>
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	8b 50 08             	mov    0x8(%eax),%edx
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec3:	8b 48 08             	mov    0x8(%eax),%ecx
  801ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ecc:	01 c8                	add    %ecx,%eax
  801ece:	39 c2                	cmp    %eax,%edx
  801ed0:	73 04                	jae    801ed6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ed2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed9:	8b 50 08             	mov    0x8(%eax),%edx
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee2:	01 c2                	add    %eax,%edx
  801ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee7:	8b 40 08             	mov    0x8(%eax),%eax
  801eea:	83 ec 04             	sub    $0x4,%esp
  801eed:	52                   	push   %edx
  801eee:	50                   	push   %eax
  801eef:	68 b9 40 80 00       	push   $0x8040b9
  801ef4:	e8 af e7 ff ff       	call   8006a8 <cprintf>
  801ef9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f02:	a1 48 50 80 00       	mov    0x805048,%eax
  801f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0e:	74 07                	je     801f17 <print_mem_block_lists+0x155>
  801f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f13:	8b 00                	mov    (%eax),%eax
  801f15:	eb 05                	jmp    801f1c <print_mem_block_lists+0x15a>
  801f17:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1c:	a3 48 50 80 00       	mov    %eax,0x805048
  801f21:	a1 48 50 80 00       	mov    0x805048,%eax
  801f26:	85 c0                	test   %eax,%eax
  801f28:	75 8a                	jne    801eb4 <print_mem_block_lists+0xf2>
  801f2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2e:	75 84                	jne    801eb4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f30:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f34:	75 10                	jne    801f46 <print_mem_block_lists+0x184>
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	68 04 41 80 00       	push   $0x804104
  801f3e:	e8 65 e7 ff ff       	call   8006a8 <cprintf>
  801f43:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	68 78 40 80 00       	push   $0x804078
  801f4e:	e8 55 e7 ff ff       	call   8006a8 <cprintf>
  801f53:	83 c4 10             	add    $0x10,%esp

}
  801f56:	90                   	nop
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f5f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f66:	00 00 00 
  801f69:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f70:	00 00 00 
  801f73:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f7a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f84:	e9 9e 00 00 00       	jmp    802027 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f89:	a1 50 50 80 00       	mov    0x805050,%eax
  801f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f91:	c1 e2 04             	shl    $0x4,%edx
  801f94:	01 d0                	add    %edx,%eax
  801f96:	85 c0                	test   %eax,%eax
  801f98:	75 14                	jne    801fae <initialize_MemBlocksList+0x55>
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	68 2c 41 80 00       	push   $0x80412c
  801fa2:	6a 46                	push   $0x46
  801fa4:	68 4f 41 80 00       	push   $0x80414f
  801fa9:	e8 46 e4 ff ff       	call   8003f4 <_panic>
  801fae:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb6:	c1 e2 04             	shl    $0x4,%edx
  801fb9:	01 d0                	add    %edx,%eax
  801fbb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fc1:	89 10                	mov    %edx,(%eax)
  801fc3:	8b 00                	mov    (%eax),%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	74 18                	je     801fe1 <initialize_MemBlocksList+0x88>
  801fc9:	a1 48 51 80 00       	mov    0x805148,%eax
  801fce:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fd4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fd7:	c1 e1 04             	shl    $0x4,%ecx
  801fda:	01 ca                	add    %ecx,%edx
  801fdc:	89 50 04             	mov    %edx,0x4(%eax)
  801fdf:	eb 12                	jmp    801ff3 <initialize_MemBlocksList+0x9a>
  801fe1:	a1 50 50 80 00       	mov    0x805050,%eax
  801fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe9:	c1 e2 04             	shl    $0x4,%edx
  801fec:	01 d0                	add    %edx,%eax
  801fee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ff3:	a1 50 50 80 00       	mov    0x805050,%eax
  801ff8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffb:	c1 e2 04             	shl    $0x4,%edx
  801ffe:	01 d0                	add    %edx,%eax
  802000:	a3 48 51 80 00       	mov    %eax,0x805148
  802005:	a1 50 50 80 00       	mov    0x805050,%eax
  80200a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200d:	c1 e2 04             	shl    $0x4,%edx
  802010:	01 d0                	add    %edx,%eax
  802012:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802019:	a1 54 51 80 00       	mov    0x805154,%eax
  80201e:	40                   	inc    %eax
  80201f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802024:	ff 45 f4             	incl   -0xc(%ebp)
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80202d:	0f 82 56 ff ff ff    	jb     801f89 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802033:	90                   	nop
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	8b 00                	mov    (%eax),%eax
  802041:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802044:	eb 19                	jmp    80205f <find_block+0x29>
	{
		if(va==point->sva)
  802046:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802049:	8b 40 08             	mov    0x8(%eax),%eax
  80204c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80204f:	75 05                	jne    802056 <find_block+0x20>
		   return point;
  802051:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802054:	eb 36                	jmp    80208c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	8b 40 08             	mov    0x8(%eax),%eax
  80205c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80205f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802063:	74 07                	je     80206c <find_block+0x36>
  802065:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802068:	8b 00                	mov    (%eax),%eax
  80206a:	eb 05                	jmp    802071 <find_block+0x3b>
  80206c:	b8 00 00 00 00       	mov    $0x0,%eax
  802071:	8b 55 08             	mov    0x8(%ebp),%edx
  802074:	89 42 08             	mov    %eax,0x8(%edx)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	8b 40 08             	mov    0x8(%eax),%eax
  80207d:	85 c0                	test   %eax,%eax
  80207f:	75 c5                	jne    802046 <find_block+0x10>
  802081:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802085:	75 bf                	jne    802046 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802094:	a1 40 50 80 00       	mov    0x805040,%eax
  802099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80209c:	a1 44 50 80 00       	mov    0x805044,%eax
  8020a1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020aa:	74 24                	je     8020d0 <insert_sorted_allocList+0x42>
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	8b 50 08             	mov    0x8(%eax),%edx
  8020b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b5:	8b 40 08             	mov    0x8(%eax),%eax
  8020b8:	39 c2                	cmp    %eax,%edx
  8020ba:	76 14                	jbe    8020d0 <insert_sorted_allocList+0x42>
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8b 50 08             	mov    0x8(%eax),%edx
  8020c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c5:	8b 40 08             	mov    0x8(%eax),%eax
  8020c8:	39 c2                	cmp    %eax,%edx
  8020ca:	0f 82 60 01 00 00    	jb     802230 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d4:	75 65                	jne    80213b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020da:	75 14                	jne    8020f0 <insert_sorted_allocList+0x62>
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	68 2c 41 80 00       	push   $0x80412c
  8020e4:	6a 6b                	push   $0x6b
  8020e6:	68 4f 41 80 00       	push   $0x80414f
  8020eb:	e8 04 e3 ff ff       	call   8003f4 <_panic>
  8020f0:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	89 10                	mov    %edx,(%eax)
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	85 c0                	test   %eax,%eax
  802102:	74 0d                	je     802111 <insert_sorted_allocList+0x83>
  802104:	a1 40 50 80 00       	mov    0x805040,%eax
  802109:	8b 55 08             	mov    0x8(%ebp),%edx
  80210c:	89 50 04             	mov    %edx,0x4(%eax)
  80210f:	eb 08                	jmp    802119 <insert_sorted_allocList+0x8b>
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	a3 44 50 80 00       	mov    %eax,0x805044
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	a3 40 50 80 00       	mov    %eax,0x805040
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80212b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802130:	40                   	inc    %eax
  802131:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802136:	e9 dc 01 00 00       	jmp    802317 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	8b 50 08             	mov    0x8(%eax),%edx
  802141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802144:	8b 40 08             	mov    0x8(%eax),%eax
  802147:	39 c2                	cmp    %eax,%edx
  802149:	77 6c                	ja     8021b7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80214b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80214f:	74 06                	je     802157 <insert_sorted_allocList+0xc9>
  802151:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802155:	75 14                	jne    80216b <insert_sorted_allocList+0xdd>
  802157:	83 ec 04             	sub    $0x4,%esp
  80215a:	68 68 41 80 00       	push   $0x804168
  80215f:	6a 6f                	push   $0x6f
  802161:	68 4f 41 80 00       	push   $0x80414f
  802166:	e8 89 e2 ff ff       	call   8003f4 <_panic>
  80216b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216e:	8b 50 04             	mov    0x4(%eax),%edx
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	89 50 04             	mov    %edx,0x4(%eax)
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80217d:	89 10                	mov    %edx,(%eax)
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	8b 40 04             	mov    0x4(%eax),%eax
  802185:	85 c0                	test   %eax,%eax
  802187:	74 0d                	je     802196 <insert_sorted_allocList+0x108>
  802189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218c:	8b 40 04             	mov    0x4(%eax),%eax
  80218f:	8b 55 08             	mov    0x8(%ebp),%edx
  802192:	89 10                	mov    %edx,(%eax)
  802194:	eb 08                	jmp    80219e <insert_sorted_allocList+0x110>
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	a3 40 50 80 00       	mov    %eax,0x805040
  80219e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a4:	89 50 04             	mov    %edx,0x4(%eax)
  8021a7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021ac:	40                   	inc    %eax
  8021ad:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b2:	e9 60 01 00 00       	jmp    802317 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	8b 50 08             	mov    0x8(%eax),%edx
  8021bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c0:	8b 40 08             	mov    0x8(%eax),%eax
  8021c3:	39 c2                	cmp    %eax,%edx
  8021c5:	0f 82 4c 01 00 00    	jb     802317 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cf:	75 14                	jne    8021e5 <insert_sorted_allocList+0x157>
  8021d1:	83 ec 04             	sub    $0x4,%esp
  8021d4:	68 a0 41 80 00       	push   $0x8041a0
  8021d9:	6a 73                	push   $0x73
  8021db:	68 4f 41 80 00       	push   $0x80414f
  8021e0:	e8 0f e2 ff ff       	call   8003f4 <_panic>
  8021e5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	89 50 04             	mov    %edx,0x4(%eax)
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	8b 40 04             	mov    0x4(%eax),%eax
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	74 0c                	je     802207 <insert_sorted_allocList+0x179>
  8021fb:	a1 44 50 80 00       	mov    0x805044,%eax
  802200:	8b 55 08             	mov    0x8(%ebp),%edx
  802203:	89 10                	mov    %edx,(%eax)
  802205:	eb 08                	jmp    80220f <insert_sorted_allocList+0x181>
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	a3 40 50 80 00       	mov    %eax,0x805040
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	a3 44 50 80 00       	mov    %eax,0x805044
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802220:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802225:	40                   	inc    %eax
  802226:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80222b:	e9 e7 00 00 00       	jmp    802317 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802233:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802236:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80223d:	a1 40 50 80 00       	mov    0x805040,%eax
  802242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802245:	e9 9d 00 00 00       	jmp    8022e7 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	8b 50 08             	mov    0x8(%eax),%edx
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 40 08             	mov    0x8(%eax),%eax
  80225e:	39 c2                	cmp    %eax,%edx
  802260:	76 7d                	jbe    8022df <insert_sorted_allocList+0x251>
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	8b 50 08             	mov    0x8(%eax),%edx
  802268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80226b:	8b 40 08             	mov    0x8(%eax),%eax
  80226e:	39 c2                	cmp    %eax,%edx
  802270:	73 6d                	jae    8022df <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802272:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802276:	74 06                	je     80227e <insert_sorted_allocList+0x1f0>
  802278:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80227c:	75 14                	jne    802292 <insert_sorted_allocList+0x204>
  80227e:	83 ec 04             	sub    $0x4,%esp
  802281:	68 c4 41 80 00       	push   $0x8041c4
  802286:	6a 7f                	push   $0x7f
  802288:	68 4f 41 80 00       	push   $0x80414f
  80228d:	e8 62 e1 ff ff       	call   8003f4 <_panic>
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 10                	mov    (%eax),%edx
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	89 10                	mov    %edx,(%eax)
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	8b 00                	mov    (%eax),%eax
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	74 0b                	je     8022b0 <insert_sorted_allocList+0x222>
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	8b 00                	mov    (%eax),%eax
  8022aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ad:	89 50 04             	mov    %edx,0x4(%eax)
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b6:	89 10                	mov    %edx,(%eax)
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	8b 00                	mov    (%eax),%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	75 08                	jne    8022d2 <insert_sorted_allocList+0x244>
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022d7:	40                   	inc    %eax
  8022d8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022dd:	eb 39                	jmp    802318 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022df:	a1 48 50 80 00       	mov    0x805048,%eax
  8022e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022eb:	74 07                	je     8022f4 <insert_sorted_allocList+0x266>
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 00                	mov    (%eax),%eax
  8022f2:	eb 05                	jmp    8022f9 <insert_sorted_allocList+0x26b>
  8022f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f9:	a3 48 50 80 00       	mov    %eax,0x805048
  8022fe:	a1 48 50 80 00       	mov    0x805048,%eax
  802303:	85 c0                	test   %eax,%eax
  802305:	0f 85 3f ff ff ff    	jne    80224a <insert_sorted_allocList+0x1bc>
  80230b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230f:	0f 85 35 ff ff ff    	jne    80224a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802315:	eb 01                	jmp    802318 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802317:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802318:	90                   	nop
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802321:	a1 38 51 80 00       	mov    0x805138,%eax
  802326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802329:	e9 85 01 00 00       	jmp    8024b3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 40 0c             	mov    0xc(%eax),%eax
  802334:	3b 45 08             	cmp    0x8(%ebp),%eax
  802337:	0f 82 6e 01 00 00    	jb     8024ab <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 40 0c             	mov    0xc(%eax),%eax
  802343:	3b 45 08             	cmp    0x8(%ebp),%eax
  802346:	0f 85 8a 00 00 00    	jne    8023d6 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80234c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802350:	75 17                	jne    802369 <alloc_block_FF+0x4e>
  802352:	83 ec 04             	sub    $0x4,%esp
  802355:	68 f8 41 80 00       	push   $0x8041f8
  80235a:	68 93 00 00 00       	push   $0x93
  80235f:	68 4f 41 80 00       	push   $0x80414f
  802364:	e8 8b e0 ff ff       	call   8003f4 <_panic>
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 00                	mov    (%eax),%eax
  80236e:	85 c0                	test   %eax,%eax
  802370:	74 10                	je     802382 <alloc_block_FF+0x67>
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 00                	mov    (%eax),%eax
  802377:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237a:	8b 52 04             	mov    0x4(%edx),%edx
  80237d:	89 50 04             	mov    %edx,0x4(%eax)
  802380:	eb 0b                	jmp    80238d <alloc_block_FF+0x72>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 40 04             	mov    0x4(%eax),%eax
  802388:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 40 04             	mov    0x4(%eax),%eax
  802393:	85 c0                	test   %eax,%eax
  802395:	74 0f                	je     8023a6 <alloc_block_FF+0x8b>
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 40 04             	mov    0x4(%eax),%eax
  80239d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a0:	8b 12                	mov    (%edx),%edx
  8023a2:	89 10                	mov    %edx,(%eax)
  8023a4:	eb 0a                	jmp    8023b0 <alloc_block_FF+0x95>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 00                	mov    (%eax),%eax
  8023ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8023c8:	48                   	dec    %eax
  8023c9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	e9 10 01 00 00       	jmp    8024e6 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023df:	0f 86 c6 00 00 00    	jbe    8024ab <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8023ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 50 08             	mov    0x8(%eax),%edx
  8023f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f6:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ff:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802402:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802406:	75 17                	jne    80241f <alloc_block_FF+0x104>
  802408:	83 ec 04             	sub    $0x4,%esp
  80240b:	68 f8 41 80 00       	push   $0x8041f8
  802410:	68 9b 00 00 00       	push   $0x9b
  802415:	68 4f 41 80 00       	push   $0x80414f
  80241a:	e8 d5 df ff ff       	call   8003f4 <_panic>
  80241f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	85 c0                	test   %eax,%eax
  802426:	74 10                	je     802438 <alloc_block_FF+0x11d>
  802428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242b:	8b 00                	mov    (%eax),%eax
  80242d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802430:	8b 52 04             	mov    0x4(%edx),%edx
  802433:	89 50 04             	mov    %edx,0x4(%eax)
  802436:	eb 0b                	jmp    802443 <alloc_block_FF+0x128>
  802438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243b:	8b 40 04             	mov    0x4(%eax),%eax
  80243e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802446:	8b 40 04             	mov    0x4(%eax),%eax
  802449:	85 c0                	test   %eax,%eax
  80244b:	74 0f                	je     80245c <alloc_block_FF+0x141>
  80244d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802450:	8b 40 04             	mov    0x4(%eax),%eax
  802453:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802456:	8b 12                	mov    (%edx),%edx
  802458:	89 10                	mov    %edx,(%eax)
  80245a:	eb 0a                	jmp    802466 <alloc_block_FF+0x14b>
  80245c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	a3 48 51 80 00       	mov    %eax,0x805148
  802466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802472:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802479:	a1 54 51 80 00       	mov    0x805154,%eax
  80247e:	48                   	dec    %eax
  80247f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 50 08             	mov    0x8(%eax),%edx
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	01 c2                	add    %eax,%edx
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 0c             	mov    0xc(%eax),%eax
  80249b:	2b 45 08             	sub    0x8(%ebp),%eax
  80249e:	89 c2                	mov    %eax,%edx
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a9:	eb 3b                	jmp    8024e6 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b7:	74 07                	je     8024c0 <alloc_block_FF+0x1a5>
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	eb 05                	jmp    8024c5 <alloc_block_FF+0x1aa>
  8024c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c5:	a3 40 51 80 00       	mov    %eax,0x805140
  8024ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	0f 85 57 fe ff ff    	jne    80232e <alloc_block_FF+0x13>
  8024d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024db:	0f 85 4d fe ff ff    	jne    80232e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024ee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024f5:	a1 38 51 80 00       	mov    0x805138,%eax
  8024fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fd:	e9 df 00 00 00       	jmp    8025e1 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 40 0c             	mov    0xc(%eax),%eax
  802508:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250b:	0f 82 c8 00 00 00    	jb     8025d9 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 40 0c             	mov    0xc(%eax),%eax
  802517:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251a:	0f 85 8a 00 00 00    	jne    8025aa <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802524:	75 17                	jne    80253d <alloc_block_BF+0x55>
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 f8 41 80 00       	push   $0x8041f8
  80252e:	68 b7 00 00 00       	push   $0xb7
  802533:	68 4f 41 80 00       	push   $0x80414f
  802538:	e8 b7 de ff ff       	call   8003f4 <_panic>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	74 10                	je     802556 <alloc_block_BF+0x6e>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254e:	8b 52 04             	mov    0x4(%edx),%edx
  802551:	89 50 04             	mov    %edx,0x4(%eax)
  802554:	eb 0b                	jmp    802561 <alloc_block_BF+0x79>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	74 0f                	je     80257a <alloc_block_BF+0x92>
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802574:	8b 12                	mov    (%edx),%edx
  802576:	89 10                	mov    %edx,(%eax)
  802578:	eb 0a                	jmp    802584 <alloc_block_BF+0x9c>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	a3 38 51 80 00       	mov    %eax,0x805138
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802597:	a1 44 51 80 00       	mov    0x805144,%eax
  80259c:	48                   	dec    %eax
  80259d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	e9 4d 01 00 00       	jmp    8026f7 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b3:	76 24                	jbe    8025d9 <alloc_block_BF+0xf1>
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025be:	73 19                	jae    8025d9 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025c0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 40 08             	mov    0x8(%eax),%eax
  8025d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8025de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e5:	74 07                	je     8025ee <alloc_block_BF+0x106>
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 00                	mov    (%eax),%eax
  8025ec:	eb 05                	jmp    8025f3 <alloc_block_BF+0x10b>
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f3:	a3 40 51 80 00       	mov    %eax,0x805140
  8025f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	0f 85 fd fe ff ff    	jne    802502 <alloc_block_BF+0x1a>
  802605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802609:	0f 85 f3 fe ff ff    	jne    802502 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80260f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802613:	0f 84 d9 00 00 00    	je     8026f2 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802619:	a1 48 51 80 00       	mov    0x805148,%eax
  80261e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802624:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802627:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80262a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262d:	8b 55 08             	mov    0x8(%ebp),%edx
  802630:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802633:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802637:	75 17                	jne    802650 <alloc_block_BF+0x168>
  802639:	83 ec 04             	sub    $0x4,%esp
  80263c:	68 f8 41 80 00       	push   $0x8041f8
  802641:	68 c7 00 00 00       	push   $0xc7
  802646:	68 4f 41 80 00       	push   $0x80414f
  80264b:	e8 a4 dd ff ff       	call   8003f4 <_panic>
  802650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	74 10                	je     802669 <alloc_block_BF+0x181>
  802659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802661:	8b 52 04             	mov    0x4(%edx),%edx
  802664:	89 50 04             	mov    %edx,0x4(%eax)
  802667:	eb 0b                	jmp    802674 <alloc_block_BF+0x18c>
  802669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266c:	8b 40 04             	mov    0x4(%eax),%eax
  80266f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	74 0f                	je     80268d <alloc_block_BF+0x1a5>
  80267e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802681:	8b 40 04             	mov    0x4(%eax),%eax
  802684:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802687:	8b 12                	mov    (%edx),%edx
  802689:	89 10                	mov    %edx,(%eax)
  80268b:	eb 0a                	jmp    802697 <alloc_block_BF+0x1af>
  80268d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	a3 48 51 80 00       	mov    %eax,0x805148
  802697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8026af:	48                   	dec    %eax
  8026b0:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026b5:	83 ec 08             	sub    $0x8,%esp
  8026b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8026bb:	68 38 51 80 00       	push   $0x805138
  8026c0:	e8 71 f9 ff ff       	call   802036 <find_block>
  8026c5:	83 c4 10             	add    $0x10,%esp
  8026c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ce:	8b 50 08             	mov    0x8(%eax),%edx
  8026d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d4:	01 c2                	add    %eax,%edx
  8026d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d9:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026df:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e2:	2b 45 08             	sub    0x8(%ebp),%eax
  8026e5:	89 c2                	mov    %eax,%edx
  8026e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ea:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f0:	eb 05                	jmp    8026f7 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026ff:	a1 28 50 80 00       	mov    0x805028,%eax
  802704:	85 c0                	test   %eax,%eax
  802706:	0f 85 de 01 00 00    	jne    8028ea <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80270c:	a1 38 51 80 00       	mov    0x805138,%eax
  802711:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802714:	e9 9e 01 00 00       	jmp    8028b7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 40 0c             	mov    0xc(%eax),%eax
  80271f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802722:	0f 82 87 01 00 00    	jb     8028af <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 40 0c             	mov    0xc(%eax),%eax
  80272e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802731:	0f 85 95 00 00 00    	jne    8027cc <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273b:	75 17                	jne    802754 <alloc_block_NF+0x5b>
  80273d:	83 ec 04             	sub    $0x4,%esp
  802740:	68 f8 41 80 00       	push   $0x8041f8
  802745:	68 e0 00 00 00       	push   $0xe0
  80274a:	68 4f 41 80 00       	push   $0x80414f
  80274f:	e8 a0 dc ff ff       	call   8003f4 <_panic>
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 00                	mov    (%eax),%eax
  802759:	85 c0                	test   %eax,%eax
  80275b:	74 10                	je     80276d <alloc_block_NF+0x74>
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802765:	8b 52 04             	mov    0x4(%edx),%edx
  802768:	89 50 04             	mov    %edx,0x4(%eax)
  80276b:	eb 0b                	jmp    802778 <alloc_block_NF+0x7f>
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 40 04             	mov    0x4(%eax),%eax
  802773:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 04             	mov    0x4(%eax),%eax
  80277e:	85 c0                	test   %eax,%eax
  802780:	74 0f                	je     802791 <alloc_block_NF+0x98>
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 40 04             	mov    0x4(%eax),%eax
  802788:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278b:	8b 12                	mov    (%edx),%edx
  80278d:	89 10                	mov    %edx,(%eax)
  80278f:	eb 0a                	jmp    80279b <alloc_block_NF+0xa2>
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	a3 38 51 80 00       	mov    %eax,0x805138
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8027b3:	48                   	dec    %eax
  8027b4:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 40 08             	mov    0x8(%eax),%eax
  8027bf:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	e9 f8 04 00 00       	jmp    802cc4 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d5:	0f 86 d4 00 00 00    	jbe    8028af <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027db:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 50 08             	mov    0x8(%eax),%edx
  8027e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ec:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f5:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027fc:	75 17                	jne    802815 <alloc_block_NF+0x11c>
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	68 f8 41 80 00       	push   $0x8041f8
  802806:	68 e9 00 00 00       	push   $0xe9
  80280b:	68 4f 41 80 00       	push   $0x80414f
  802810:	e8 df db ff ff       	call   8003f4 <_panic>
  802815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 10                	je     80282e <alloc_block_NF+0x135>
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802826:	8b 52 04             	mov    0x4(%edx),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	eb 0b                	jmp    802839 <alloc_block_NF+0x140>
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 0f                	je     802852 <alloc_block_NF+0x159>
  802843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284c:	8b 12                	mov    (%edx),%edx
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	eb 0a                	jmp    80285c <alloc_block_NF+0x163>
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	a3 48 51 80 00       	mov    %eax,0x805148
  80285c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286f:	a1 54 51 80 00       	mov    0x805154,%eax
  802874:	48                   	dec    %eax
  802875:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80287a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287d:	8b 40 08             	mov    0x8(%eax),%eax
  802880:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 50 08             	mov    0x8(%eax),%edx
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	01 c2                	add    %eax,%edx
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 40 0c             	mov    0xc(%eax),%eax
  80289c:	2b 45 08             	sub    0x8(%ebp),%eax
  80289f:	89 c2                	mov    %eax,%edx
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028aa:	e9 15 04 00 00       	jmp    802cc4 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028af:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bb:	74 07                	je     8028c4 <alloc_block_NF+0x1cb>
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 00                	mov    (%eax),%eax
  8028c2:	eb 05                	jmp    8028c9 <alloc_block_NF+0x1d0>
  8028c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c9:	a3 40 51 80 00       	mov    %eax,0x805140
  8028ce:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	0f 85 3e fe ff ff    	jne    802719 <alloc_block_NF+0x20>
  8028db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028df:	0f 85 34 fe ff ff    	jne    802719 <alloc_block_NF+0x20>
  8028e5:	e9 d5 03 00 00       	jmp    802cbf <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f2:	e9 b1 01 00 00       	jmp    802aa8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 50 08             	mov    0x8(%eax),%edx
  8028fd:	a1 28 50 80 00       	mov    0x805028,%eax
  802902:	39 c2                	cmp    %eax,%edx
  802904:	0f 82 96 01 00 00    	jb     802aa0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	3b 45 08             	cmp    0x8(%ebp),%eax
  802913:	0f 82 87 01 00 00    	jb     802aa0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 0c             	mov    0xc(%eax),%eax
  80291f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802922:	0f 85 95 00 00 00    	jne    8029bd <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802928:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292c:	75 17                	jne    802945 <alloc_block_NF+0x24c>
  80292e:	83 ec 04             	sub    $0x4,%esp
  802931:	68 f8 41 80 00       	push   $0x8041f8
  802936:	68 fc 00 00 00       	push   $0xfc
  80293b:	68 4f 41 80 00       	push   $0x80414f
  802940:	e8 af da ff ff       	call   8003f4 <_panic>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 00                	mov    (%eax),%eax
  80294a:	85 c0                	test   %eax,%eax
  80294c:	74 10                	je     80295e <alloc_block_NF+0x265>
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 00                	mov    (%eax),%eax
  802953:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802956:	8b 52 04             	mov    0x4(%edx),%edx
  802959:	89 50 04             	mov    %edx,0x4(%eax)
  80295c:	eb 0b                	jmp    802969 <alloc_block_NF+0x270>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 40 04             	mov    0x4(%eax),%eax
  802964:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 40 04             	mov    0x4(%eax),%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	74 0f                	je     802982 <alloc_block_NF+0x289>
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 40 04             	mov    0x4(%eax),%eax
  802979:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297c:	8b 12                	mov    (%edx),%edx
  80297e:	89 10                	mov    %edx,(%eax)
  802980:	eb 0a                	jmp    80298c <alloc_block_NF+0x293>
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
  802987:	a3 38 51 80 00       	mov    %eax,0x805138
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299f:	a1 44 51 80 00       	mov    0x805144,%eax
  8029a4:	48                   	dec    %eax
  8029a5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	8b 40 08             	mov    0x8(%eax),%eax
  8029b0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	e9 07 03 00 00       	jmp    802cc4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c6:	0f 86 d4 00 00 00    	jbe    802aa0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 50 08             	mov    0x8(%eax),%edx
  8029da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029dd:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ed:	75 17                	jne    802a06 <alloc_block_NF+0x30d>
  8029ef:	83 ec 04             	sub    $0x4,%esp
  8029f2:	68 f8 41 80 00       	push   $0x8041f8
  8029f7:	68 04 01 00 00       	push   $0x104
  8029fc:	68 4f 41 80 00       	push   $0x80414f
  802a01:	e8 ee d9 ff ff       	call   8003f4 <_panic>
  802a06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a09:	8b 00                	mov    (%eax),%eax
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	74 10                	je     802a1f <alloc_block_NF+0x326>
  802a0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a17:	8b 52 04             	mov    0x4(%edx),%edx
  802a1a:	89 50 04             	mov    %edx,0x4(%eax)
  802a1d:	eb 0b                	jmp    802a2a <alloc_block_NF+0x331>
  802a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a22:	8b 40 04             	mov    0x4(%eax),%eax
  802a25:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2d:	8b 40 04             	mov    0x4(%eax),%eax
  802a30:	85 c0                	test   %eax,%eax
  802a32:	74 0f                	je     802a43 <alloc_block_NF+0x34a>
  802a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a37:	8b 40 04             	mov    0x4(%eax),%eax
  802a3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a3d:	8b 12                	mov    (%edx),%edx
  802a3f:	89 10                	mov    %edx,(%eax)
  802a41:	eb 0a                	jmp    802a4d <alloc_block_NF+0x354>
  802a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	a3 48 51 80 00       	mov    %eax,0x805148
  802a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a60:	a1 54 51 80 00       	mov    0x805154,%eax
  802a65:	48                   	dec    %eax
  802a66:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6e:	8b 40 08             	mov    0x8(%eax),%eax
  802a71:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	8b 50 08             	mov    0x8(%eax),%edx
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	01 c2                	add    %eax,%edx
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8d:	2b 45 08             	sub    0x8(%ebp),%eax
  802a90:	89 c2                	mov    %eax,%edx
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9b:	e9 24 02 00 00       	jmp    802cc4 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa0:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aac:	74 07                	je     802ab5 <alloc_block_NF+0x3bc>
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 00                	mov    (%eax),%eax
  802ab3:	eb 05                	jmp    802aba <alloc_block_NF+0x3c1>
  802ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aba:	a3 40 51 80 00       	mov    %eax,0x805140
  802abf:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	0f 85 2b fe ff ff    	jne    8028f7 <alloc_block_NF+0x1fe>
  802acc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad0:	0f 85 21 fe ff ff    	jne    8028f7 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ad6:	a1 38 51 80 00       	mov    0x805138,%eax
  802adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ade:	e9 ae 01 00 00       	jmp    802c91 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 50 08             	mov    0x8(%eax),%edx
  802ae9:	a1 28 50 80 00       	mov    0x805028,%eax
  802aee:	39 c2                	cmp    %eax,%edx
  802af0:	0f 83 93 01 00 00    	jae    802c89 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 0c             	mov    0xc(%eax),%eax
  802afc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aff:	0f 82 84 01 00 00    	jb     802c89 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b0e:	0f 85 95 00 00 00    	jne    802ba9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b18:	75 17                	jne    802b31 <alloc_block_NF+0x438>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 f8 41 80 00       	push   $0x8041f8
  802b22:	68 14 01 00 00       	push   $0x114
  802b27:	68 4f 41 80 00       	push   $0x80414f
  802b2c:	e8 c3 d8 ff ff       	call   8003f4 <_panic>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 10                	je     802b4a <alloc_block_NF+0x451>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b42:	8b 52 04             	mov    0x4(%edx),%edx
  802b45:	89 50 04             	mov    %edx,0x4(%eax)
  802b48:	eb 0b                	jmp    802b55 <alloc_block_NF+0x45c>
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 40 04             	mov    0x4(%eax),%eax
  802b50:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	74 0f                	je     802b6e <alloc_block_NF+0x475>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 40 04             	mov    0x4(%eax),%eax
  802b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b68:	8b 12                	mov    (%edx),%edx
  802b6a:	89 10                	mov    %edx,(%eax)
  802b6c:	eb 0a                	jmp    802b78 <alloc_block_NF+0x47f>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	a3 38 51 80 00       	mov    %eax,0x805138
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8b:	a1 44 51 80 00       	mov    0x805144,%eax
  802b90:	48                   	dec    %eax
  802b91:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 40 08             	mov    0x8(%eax),%eax
  802b9c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	e9 1b 01 00 00       	jmp    802cc4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 40 0c             	mov    0xc(%eax),%eax
  802baf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb2:	0f 86 d1 00 00 00    	jbe    802c89 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bb8:	a1 48 51 80 00       	mov    0x805148,%eax
  802bbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 50 08             	mov    0x8(%eax),%edx
  802bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bd9:	75 17                	jne    802bf2 <alloc_block_NF+0x4f9>
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 f8 41 80 00       	push   $0x8041f8
  802be3:	68 1c 01 00 00       	push   $0x11c
  802be8:	68 4f 41 80 00       	push   $0x80414f
  802bed:	e8 02 d8 ff ff       	call   8003f4 <_panic>
  802bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 10                	je     802c0b <alloc_block_NF+0x512>
  802bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c03:	8b 52 04             	mov    0x4(%edx),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	eb 0b                	jmp    802c16 <alloc_block_NF+0x51d>
  802c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 0f                	je     802c2f <alloc_block_NF+0x536>
  802c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c23:	8b 40 04             	mov    0x4(%eax),%eax
  802c26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c29:	8b 12                	mov    (%edx),%edx
  802c2b:	89 10                	mov    %edx,(%eax)
  802c2d:	eb 0a                	jmp    802c39 <alloc_block_NF+0x540>
  802c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	a3 48 51 80 00       	mov    %eax,0x805148
  802c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c51:	48                   	dec    %eax
  802c52:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 50 08             	mov    0x8(%eax),%edx
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	01 c2                	add    %eax,%edx
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 40 0c             	mov    0xc(%eax),%eax
  802c79:	2b 45 08             	sub    0x8(%ebp),%eax
  802c7c:	89 c2                	mov    %eax,%edx
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c87:	eb 3b                	jmp    802cc4 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c89:	a1 40 51 80 00       	mov    0x805140,%eax
  802c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c95:	74 07                	je     802c9e <alloc_block_NF+0x5a5>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	eb 05                	jmp    802ca3 <alloc_block_NF+0x5aa>
  802c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ca8:	a1 40 51 80 00       	mov    0x805140,%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	0f 85 2e fe ff ff    	jne    802ae3 <alloc_block_NF+0x3ea>
  802cb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb9:	0f 85 24 fe ff ff    	jne    802ae3 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc4:	c9                   	leave  
  802cc5:	c3                   	ret    

00802cc6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cc6:	55                   	push   %ebp
  802cc7:	89 e5                	mov    %esp,%ebp
  802cc9:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ccc:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cd4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cd9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cdc:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce1:	85 c0                	test   %eax,%eax
  802ce3:	74 14                	je     802cf9 <insert_sorted_with_merge_freeList+0x33>
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	8b 50 08             	mov    0x8(%eax),%edx
  802ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cee:	8b 40 08             	mov    0x8(%eax),%eax
  802cf1:	39 c2                	cmp    %eax,%edx
  802cf3:	0f 87 9b 01 00 00    	ja     802e94 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cf9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cfd:	75 17                	jne    802d16 <insert_sorted_with_merge_freeList+0x50>
  802cff:	83 ec 04             	sub    $0x4,%esp
  802d02:	68 2c 41 80 00       	push   $0x80412c
  802d07:	68 38 01 00 00       	push   $0x138
  802d0c:	68 4f 41 80 00       	push   $0x80414f
  802d11:	e8 de d6 ff ff       	call   8003f4 <_panic>
  802d16:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	89 10                	mov    %edx,(%eax)
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 0d                	je     802d37 <insert_sorted_with_merge_freeList+0x71>
  802d2a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d32:	89 50 04             	mov    %edx,0x4(%eax)
  802d35:	eb 08                	jmp    802d3f <insert_sorted_with_merge_freeList+0x79>
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	a3 38 51 80 00       	mov    %eax,0x805138
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d51:	a1 44 51 80 00       	mov    0x805144,%eax
  802d56:	40                   	inc    %eax
  802d57:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d60:	0f 84 a8 06 00 00    	je     80340e <insert_sorted_with_merge_freeList+0x748>
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d72:	01 c2                	add    %eax,%edx
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	8b 40 08             	mov    0x8(%eax),%eax
  802d7a:	39 c2                	cmp    %eax,%edx
  802d7c:	0f 85 8c 06 00 00    	jne    80340e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	8b 50 0c             	mov    0xc(%eax),%edx
  802d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8e:	01 c2                	add    %eax,%edx
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9a:	75 17                	jne    802db3 <insert_sorted_with_merge_freeList+0xed>
  802d9c:	83 ec 04             	sub    $0x4,%esp
  802d9f:	68 f8 41 80 00       	push   $0x8041f8
  802da4:	68 3c 01 00 00       	push   $0x13c
  802da9:	68 4f 41 80 00       	push   $0x80414f
  802dae:	e8 41 d6 ff ff       	call   8003f4 <_panic>
  802db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	74 10                	je     802dcc <insert_sorted_with_merge_freeList+0x106>
  802dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc4:	8b 52 04             	mov    0x4(%edx),%edx
  802dc7:	89 50 04             	mov    %edx,0x4(%eax)
  802dca:	eb 0b                	jmp    802dd7 <insert_sorted_with_merge_freeList+0x111>
  802dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcf:	8b 40 04             	mov    0x4(%eax),%eax
  802dd2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 0f                	je     802df0 <insert_sorted_with_merge_freeList+0x12a>
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dea:	8b 12                	mov    (%edx),%edx
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	eb 0a                	jmp    802dfa <insert_sorted_with_merge_freeList+0x134>
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	a3 38 51 80 00       	mov    %eax,0x805138
  802dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e12:	48                   	dec    %eax
  802e13:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e30:	75 17                	jne    802e49 <insert_sorted_with_merge_freeList+0x183>
  802e32:	83 ec 04             	sub    $0x4,%esp
  802e35:	68 2c 41 80 00       	push   $0x80412c
  802e3a:	68 3f 01 00 00       	push   $0x13f
  802e3f:	68 4f 41 80 00       	push   $0x80414f
  802e44:	e8 ab d5 ff ff       	call   8003f4 <_panic>
  802e49:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e52:	89 10                	mov    %edx,(%eax)
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	74 0d                	je     802e6a <insert_sorted_with_merge_freeList+0x1a4>
  802e5d:	a1 48 51 80 00       	mov    0x805148,%eax
  802e62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e65:	89 50 04             	mov    %edx,0x4(%eax)
  802e68:	eb 08                	jmp    802e72 <insert_sorted_with_merge_freeList+0x1ac>
  802e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e75:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e84:	a1 54 51 80 00       	mov    0x805154,%eax
  802e89:	40                   	inc    %eax
  802e8a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e8f:	e9 7a 05 00 00       	jmp    80340e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 50 08             	mov    0x8(%eax),%edx
  802e9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ea0:	39 c2                	cmp    %eax,%edx
  802ea2:	0f 82 14 01 00 00    	jb     802fbc <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eab:	8b 50 08             	mov    0x8(%eax),%edx
  802eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb4:	01 c2                	add    %eax,%edx
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	8b 40 08             	mov    0x8(%eax),%eax
  802ebc:	39 c2                	cmp    %eax,%edx
  802ebe:	0f 85 90 00 00 00    	jne    802f54 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec7:	8b 50 0c             	mov    0xc(%eax),%edx
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed0:	01 c2                	add    %eax,%edx
  802ed2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed5:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef0:	75 17                	jne    802f09 <insert_sorted_with_merge_freeList+0x243>
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	68 2c 41 80 00       	push   $0x80412c
  802efa:	68 49 01 00 00       	push   $0x149
  802eff:	68 4f 41 80 00       	push   $0x80414f
  802f04:	e8 eb d4 ff ff       	call   8003f4 <_panic>
  802f09:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	89 10                	mov    %edx,(%eax)
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	74 0d                	je     802f2a <insert_sorted_with_merge_freeList+0x264>
  802f1d:	a1 48 51 80 00       	mov    0x805148,%eax
  802f22:	8b 55 08             	mov    0x8(%ebp),%edx
  802f25:	89 50 04             	mov    %edx,0x4(%eax)
  802f28:	eb 08                	jmp    802f32 <insert_sorted_with_merge_freeList+0x26c>
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	a3 48 51 80 00       	mov    %eax,0x805148
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f44:	a1 54 51 80 00       	mov    0x805154,%eax
  802f49:	40                   	inc    %eax
  802f4a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f4f:	e9 bb 04 00 00       	jmp    80340f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f58:	75 17                	jne    802f71 <insert_sorted_with_merge_freeList+0x2ab>
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	68 a0 41 80 00       	push   $0x8041a0
  802f62:	68 4c 01 00 00       	push   $0x14c
  802f67:	68 4f 41 80 00       	push   $0x80414f
  802f6c:	e8 83 d4 ff ff       	call   8003f4 <_panic>
  802f71:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	89 50 04             	mov    %edx,0x4(%eax)
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 40 04             	mov    0x4(%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 0c                	je     802f93 <insert_sorted_with_merge_freeList+0x2cd>
  802f87:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8f:	89 10                	mov    %edx,(%eax)
  802f91:	eb 08                	jmp    802f9b <insert_sorted_with_merge_freeList+0x2d5>
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	a3 38 51 80 00       	mov    %eax,0x805138
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fac:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb1:	40                   	inc    %eax
  802fb2:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fb7:	e9 53 04 00 00       	jmp    80340f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fbc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc4:	e9 15 04 00 00       	jmp    8033de <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	8b 50 08             	mov    0x8(%eax),%edx
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	8b 40 08             	mov    0x8(%eax),%eax
  802fdd:	39 c2                	cmp    %eax,%edx
  802fdf:	0f 86 f1 03 00 00    	jbe    8033d6 <insert_sorted_with_merge_freeList+0x710>
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 50 08             	mov    0x8(%eax),%edx
  802feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fee:	8b 40 08             	mov    0x8(%eax),%eax
  802ff1:	39 c2                	cmp    %eax,%edx
  802ff3:	0f 83 dd 03 00 00    	jae    8033d6 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	8b 50 08             	mov    0x8(%eax),%edx
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 40 0c             	mov    0xc(%eax),%eax
  803005:	01 c2                	add    %eax,%edx
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	8b 40 08             	mov    0x8(%eax),%eax
  80300d:	39 c2                	cmp    %eax,%edx
  80300f:	0f 85 b9 01 00 00    	jne    8031ce <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	8b 50 08             	mov    0x8(%eax),%edx
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	8b 40 0c             	mov    0xc(%eax),%eax
  803021:	01 c2                	add    %eax,%edx
  803023:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803026:	8b 40 08             	mov    0x8(%eax),%eax
  803029:	39 c2                	cmp    %eax,%edx
  80302b:	0f 85 0d 01 00 00    	jne    80313e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 50 0c             	mov    0xc(%eax),%edx
  803037:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303a:	8b 40 0c             	mov    0xc(%eax),%eax
  80303d:	01 c2                	add    %eax,%edx
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803045:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803049:	75 17                	jne    803062 <insert_sorted_with_merge_freeList+0x39c>
  80304b:	83 ec 04             	sub    $0x4,%esp
  80304e:	68 f8 41 80 00       	push   $0x8041f8
  803053:	68 5c 01 00 00       	push   $0x15c
  803058:	68 4f 41 80 00       	push   $0x80414f
  80305d:	e8 92 d3 ff ff       	call   8003f4 <_panic>
  803062:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	85 c0                	test   %eax,%eax
  803069:	74 10                	je     80307b <insert_sorted_with_merge_freeList+0x3b5>
  80306b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306e:	8b 00                	mov    (%eax),%eax
  803070:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803073:	8b 52 04             	mov    0x4(%edx),%edx
  803076:	89 50 04             	mov    %edx,0x4(%eax)
  803079:	eb 0b                	jmp    803086 <insert_sorted_with_merge_freeList+0x3c0>
  80307b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307e:	8b 40 04             	mov    0x4(%eax),%eax
  803081:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803086:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803089:	8b 40 04             	mov    0x4(%eax),%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	74 0f                	je     80309f <insert_sorted_with_merge_freeList+0x3d9>
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	8b 40 04             	mov    0x4(%eax),%eax
  803096:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803099:	8b 12                	mov    (%edx),%edx
  80309b:	89 10                	mov    %edx,(%eax)
  80309d:	eb 0a                	jmp    8030a9 <insert_sorted_with_merge_freeList+0x3e3>
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	a3 38 51 80 00       	mov    %eax,0x805138
  8030a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bc:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c1:	48                   	dec    %eax
  8030c2:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030df:	75 17                	jne    8030f8 <insert_sorted_with_merge_freeList+0x432>
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	68 2c 41 80 00       	push   $0x80412c
  8030e9:	68 5f 01 00 00       	push   $0x15f
  8030ee:	68 4f 41 80 00       	push   $0x80414f
  8030f3:	e8 fc d2 ff ff       	call   8003f4 <_panic>
  8030f8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	89 10                	mov    %edx,(%eax)
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	85 c0                	test   %eax,%eax
  80310a:	74 0d                	je     803119 <insert_sorted_with_merge_freeList+0x453>
  80310c:	a1 48 51 80 00       	mov    0x805148,%eax
  803111:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803114:	89 50 04             	mov    %edx,0x4(%eax)
  803117:	eb 08                	jmp    803121 <insert_sorted_with_merge_freeList+0x45b>
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	a3 48 51 80 00       	mov    %eax,0x805148
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803133:	a1 54 51 80 00       	mov    0x805154,%eax
  803138:	40                   	inc    %eax
  803139:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803141:	8b 50 0c             	mov    0xc(%eax),%edx
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 40 0c             	mov    0xc(%eax),%eax
  80314a:	01 c2                	add    %eax,%edx
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316a:	75 17                	jne    803183 <insert_sorted_with_merge_freeList+0x4bd>
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	68 2c 41 80 00       	push   $0x80412c
  803174:	68 64 01 00 00       	push   $0x164
  803179:	68 4f 41 80 00       	push   $0x80414f
  80317e:	e8 71 d2 ff ff       	call   8003f4 <_panic>
  803183:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	89 10                	mov    %edx,(%eax)
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	8b 00                	mov    (%eax),%eax
  803193:	85 c0                	test   %eax,%eax
  803195:	74 0d                	je     8031a4 <insert_sorted_with_merge_freeList+0x4de>
  803197:	a1 48 51 80 00       	mov    0x805148,%eax
  80319c:	8b 55 08             	mov    0x8(%ebp),%edx
  80319f:	89 50 04             	mov    %edx,0x4(%eax)
  8031a2:	eb 08                	jmp    8031ac <insert_sorted_with_merge_freeList+0x4e6>
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031be:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c3:	40                   	inc    %eax
  8031c4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031c9:	e9 41 02 00 00       	jmp    80340f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	8b 50 08             	mov    0x8(%eax),%edx
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031da:	01 c2                	add    %eax,%edx
  8031dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031df:	8b 40 08             	mov    0x8(%eax),%eax
  8031e2:	39 c2                	cmp    %eax,%edx
  8031e4:	0f 85 7c 01 00 00    	jne    803366 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ee:	74 06                	je     8031f6 <insert_sorted_with_merge_freeList+0x530>
  8031f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f4:	75 17                	jne    80320d <insert_sorted_with_merge_freeList+0x547>
  8031f6:	83 ec 04             	sub    $0x4,%esp
  8031f9:	68 68 41 80 00       	push   $0x804168
  8031fe:	68 69 01 00 00       	push   $0x169
  803203:	68 4f 41 80 00       	push   $0x80414f
  803208:	e8 e7 d1 ff ff       	call   8003f4 <_panic>
  80320d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803210:	8b 50 04             	mov    0x4(%eax),%edx
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	89 50 04             	mov    %edx,0x4(%eax)
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80321f:	89 10                	mov    %edx,(%eax)
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	74 0d                	je     803238 <insert_sorted_with_merge_freeList+0x572>
  80322b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322e:	8b 40 04             	mov    0x4(%eax),%eax
  803231:	8b 55 08             	mov    0x8(%ebp),%edx
  803234:	89 10                	mov    %edx,(%eax)
  803236:	eb 08                	jmp    803240 <insert_sorted_with_merge_freeList+0x57a>
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	a3 38 51 80 00       	mov    %eax,0x805138
  803240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803243:	8b 55 08             	mov    0x8(%ebp),%edx
  803246:	89 50 04             	mov    %edx,0x4(%eax)
  803249:	a1 44 51 80 00       	mov    0x805144,%eax
  80324e:	40                   	inc    %eax
  80324f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	8b 50 0c             	mov    0xc(%eax),%edx
  80325a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325d:	8b 40 0c             	mov    0xc(%eax),%eax
  803260:	01 c2                	add    %eax,%edx
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803268:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80326c:	75 17                	jne    803285 <insert_sorted_with_merge_freeList+0x5bf>
  80326e:	83 ec 04             	sub    $0x4,%esp
  803271:	68 f8 41 80 00       	push   $0x8041f8
  803276:	68 6b 01 00 00       	push   $0x16b
  80327b:	68 4f 41 80 00       	push   $0x80414f
  803280:	e8 6f d1 ff ff       	call   8003f4 <_panic>
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	8b 00                	mov    (%eax),%eax
  80328a:	85 c0                	test   %eax,%eax
  80328c:	74 10                	je     80329e <insert_sorted_with_merge_freeList+0x5d8>
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803296:	8b 52 04             	mov    0x4(%edx),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	eb 0b                	jmp    8032a9 <insert_sorted_with_merge_freeList+0x5e3>
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	8b 40 04             	mov    0x4(%eax),%eax
  8032a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	74 0f                	je     8032c2 <insert_sorted_with_merge_freeList+0x5fc>
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	8b 40 04             	mov    0x4(%eax),%eax
  8032b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032bc:	8b 12                	mov    (%edx),%edx
  8032be:	89 10                	mov    %edx,(%eax)
  8032c0:	eb 0a                	jmp    8032cc <insert_sorted_with_merge_freeList+0x606>
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
  803302:	75 17                	jne    80331b <insert_sorted_with_merge_freeList+0x655>
  803304:	83 ec 04             	sub    $0x4,%esp
  803307:	68 2c 41 80 00       	push   $0x80412c
  80330c:	68 6e 01 00 00       	push   $0x16e
  803311:	68 4f 41 80 00       	push   $0x80414f
  803316:	e8 d9 d0 ff ff       	call   8003f4 <_panic>
  80331b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803324:	89 10                	mov    %edx,(%eax)
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	74 0d                	je     80333c <insert_sorted_with_merge_freeList+0x676>
  80332f:	a1 48 51 80 00       	mov    0x805148,%eax
  803334:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803337:	89 50 04             	mov    %edx,0x4(%eax)
  80333a:	eb 08                	jmp    803344 <insert_sorted_with_merge_freeList+0x67e>
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803347:	a3 48 51 80 00       	mov    %eax,0x805148
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803356:	a1 54 51 80 00       	mov    0x805154,%eax
  80335b:	40                   	inc    %eax
  80335c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803361:	e9 a9 00 00 00       	jmp    80340f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336a:	74 06                	je     803372 <insert_sorted_with_merge_freeList+0x6ac>
  80336c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803370:	75 17                	jne    803389 <insert_sorted_with_merge_freeList+0x6c3>
  803372:	83 ec 04             	sub    $0x4,%esp
  803375:	68 c4 41 80 00       	push   $0x8041c4
  80337a:	68 73 01 00 00       	push   $0x173
  80337f:	68 4f 41 80 00       	push   $0x80414f
  803384:	e8 6b d0 ff ff       	call   8003f4 <_panic>
  803389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338c:	8b 10                	mov    (%eax),%edx
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	89 10                	mov    %edx,(%eax)
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	85 c0                	test   %eax,%eax
  80339a:	74 0b                	je     8033a7 <insert_sorted_with_merge_freeList+0x6e1>
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a4:	89 50 04             	mov    %edx,0x4(%eax)
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ad:	89 10                	mov    %edx,(%eax)
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033b5:	89 50 04             	mov    %edx,0x4(%eax)
  8033b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bb:	8b 00                	mov    (%eax),%eax
  8033bd:	85 c0                	test   %eax,%eax
  8033bf:	75 08                	jne    8033c9 <insert_sorted_with_merge_freeList+0x703>
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ce:	40                   	inc    %eax
  8033cf:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033d4:	eb 39                	jmp    80340f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8033db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e2:	74 07                	je     8033eb <insert_sorted_with_merge_freeList+0x725>
  8033e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e7:	8b 00                	mov    (%eax),%eax
  8033e9:	eb 05                	jmp    8033f0 <insert_sorted_with_merge_freeList+0x72a>
  8033eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f0:	a3 40 51 80 00       	mov    %eax,0x805140
  8033f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	0f 85 c7 fb ff ff    	jne    802fc9 <insert_sorted_with_merge_freeList+0x303>
  803402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803406:	0f 85 bd fb ff ff    	jne    802fc9 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80340c:	eb 01                	jmp    80340f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80340e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80340f:	90                   	nop
  803410:	c9                   	leave  
  803411:	c3                   	ret    
  803412:	66 90                	xchg   %ax,%ax

00803414 <__udivdi3>:
  803414:	55                   	push   %ebp
  803415:	57                   	push   %edi
  803416:	56                   	push   %esi
  803417:	53                   	push   %ebx
  803418:	83 ec 1c             	sub    $0x1c,%esp
  80341b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80341f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803423:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803427:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80342b:	89 ca                	mov    %ecx,%edx
  80342d:	89 f8                	mov    %edi,%eax
  80342f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803433:	85 f6                	test   %esi,%esi
  803435:	75 2d                	jne    803464 <__udivdi3+0x50>
  803437:	39 cf                	cmp    %ecx,%edi
  803439:	77 65                	ja     8034a0 <__udivdi3+0x8c>
  80343b:	89 fd                	mov    %edi,%ebp
  80343d:	85 ff                	test   %edi,%edi
  80343f:	75 0b                	jne    80344c <__udivdi3+0x38>
  803441:	b8 01 00 00 00       	mov    $0x1,%eax
  803446:	31 d2                	xor    %edx,%edx
  803448:	f7 f7                	div    %edi
  80344a:	89 c5                	mov    %eax,%ebp
  80344c:	31 d2                	xor    %edx,%edx
  80344e:	89 c8                	mov    %ecx,%eax
  803450:	f7 f5                	div    %ebp
  803452:	89 c1                	mov    %eax,%ecx
  803454:	89 d8                	mov    %ebx,%eax
  803456:	f7 f5                	div    %ebp
  803458:	89 cf                	mov    %ecx,%edi
  80345a:	89 fa                	mov    %edi,%edx
  80345c:	83 c4 1c             	add    $0x1c,%esp
  80345f:	5b                   	pop    %ebx
  803460:	5e                   	pop    %esi
  803461:	5f                   	pop    %edi
  803462:	5d                   	pop    %ebp
  803463:	c3                   	ret    
  803464:	39 ce                	cmp    %ecx,%esi
  803466:	77 28                	ja     803490 <__udivdi3+0x7c>
  803468:	0f bd fe             	bsr    %esi,%edi
  80346b:	83 f7 1f             	xor    $0x1f,%edi
  80346e:	75 40                	jne    8034b0 <__udivdi3+0x9c>
  803470:	39 ce                	cmp    %ecx,%esi
  803472:	72 0a                	jb     80347e <__udivdi3+0x6a>
  803474:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803478:	0f 87 9e 00 00 00    	ja     80351c <__udivdi3+0x108>
  80347e:	b8 01 00 00 00       	mov    $0x1,%eax
  803483:	89 fa                	mov    %edi,%edx
  803485:	83 c4 1c             	add    $0x1c,%esp
  803488:	5b                   	pop    %ebx
  803489:	5e                   	pop    %esi
  80348a:	5f                   	pop    %edi
  80348b:	5d                   	pop    %ebp
  80348c:	c3                   	ret    
  80348d:	8d 76 00             	lea    0x0(%esi),%esi
  803490:	31 ff                	xor    %edi,%edi
  803492:	31 c0                	xor    %eax,%eax
  803494:	89 fa                	mov    %edi,%edx
  803496:	83 c4 1c             	add    $0x1c,%esp
  803499:	5b                   	pop    %ebx
  80349a:	5e                   	pop    %esi
  80349b:	5f                   	pop    %edi
  80349c:	5d                   	pop    %ebp
  80349d:	c3                   	ret    
  80349e:	66 90                	xchg   %ax,%ax
  8034a0:	89 d8                	mov    %ebx,%eax
  8034a2:	f7 f7                	div    %edi
  8034a4:	31 ff                	xor    %edi,%edi
  8034a6:	89 fa                	mov    %edi,%edx
  8034a8:	83 c4 1c             	add    $0x1c,%esp
  8034ab:	5b                   	pop    %ebx
  8034ac:	5e                   	pop    %esi
  8034ad:	5f                   	pop    %edi
  8034ae:	5d                   	pop    %ebp
  8034af:	c3                   	ret    
  8034b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034b5:	89 eb                	mov    %ebp,%ebx
  8034b7:	29 fb                	sub    %edi,%ebx
  8034b9:	89 f9                	mov    %edi,%ecx
  8034bb:	d3 e6                	shl    %cl,%esi
  8034bd:	89 c5                	mov    %eax,%ebp
  8034bf:	88 d9                	mov    %bl,%cl
  8034c1:	d3 ed                	shr    %cl,%ebp
  8034c3:	89 e9                	mov    %ebp,%ecx
  8034c5:	09 f1                	or     %esi,%ecx
  8034c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034cb:	89 f9                	mov    %edi,%ecx
  8034cd:	d3 e0                	shl    %cl,%eax
  8034cf:	89 c5                	mov    %eax,%ebp
  8034d1:	89 d6                	mov    %edx,%esi
  8034d3:	88 d9                	mov    %bl,%cl
  8034d5:	d3 ee                	shr    %cl,%esi
  8034d7:	89 f9                	mov    %edi,%ecx
  8034d9:	d3 e2                	shl    %cl,%edx
  8034db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034df:	88 d9                	mov    %bl,%cl
  8034e1:	d3 e8                	shr    %cl,%eax
  8034e3:	09 c2                	or     %eax,%edx
  8034e5:	89 d0                	mov    %edx,%eax
  8034e7:	89 f2                	mov    %esi,%edx
  8034e9:	f7 74 24 0c          	divl   0xc(%esp)
  8034ed:	89 d6                	mov    %edx,%esi
  8034ef:	89 c3                	mov    %eax,%ebx
  8034f1:	f7 e5                	mul    %ebp
  8034f3:	39 d6                	cmp    %edx,%esi
  8034f5:	72 19                	jb     803510 <__udivdi3+0xfc>
  8034f7:	74 0b                	je     803504 <__udivdi3+0xf0>
  8034f9:	89 d8                	mov    %ebx,%eax
  8034fb:	31 ff                	xor    %edi,%edi
  8034fd:	e9 58 ff ff ff       	jmp    80345a <__udivdi3+0x46>
  803502:	66 90                	xchg   %ax,%ax
  803504:	8b 54 24 08          	mov    0x8(%esp),%edx
  803508:	89 f9                	mov    %edi,%ecx
  80350a:	d3 e2                	shl    %cl,%edx
  80350c:	39 c2                	cmp    %eax,%edx
  80350e:	73 e9                	jae    8034f9 <__udivdi3+0xe5>
  803510:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803513:	31 ff                	xor    %edi,%edi
  803515:	e9 40 ff ff ff       	jmp    80345a <__udivdi3+0x46>
  80351a:	66 90                	xchg   %ax,%ax
  80351c:	31 c0                	xor    %eax,%eax
  80351e:	e9 37 ff ff ff       	jmp    80345a <__udivdi3+0x46>
  803523:	90                   	nop

00803524 <__umoddi3>:
  803524:	55                   	push   %ebp
  803525:	57                   	push   %edi
  803526:	56                   	push   %esi
  803527:	53                   	push   %ebx
  803528:	83 ec 1c             	sub    $0x1c,%esp
  80352b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80352f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803533:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803537:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80353b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80353f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803543:	89 f3                	mov    %esi,%ebx
  803545:	89 fa                	mov    %edi,%edx
  803547:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80354b:	89 34 24             	mov    %esi,(%esp)
  80354e:	85 c0                	test   %eax,%eax
  803550:	75 1a                	jne    80356c <__umoddi3+0x48>
  803552:	39 f7                	cmp    %esi,%edi
  803554:	0f 86 a2 00 00 00    	jbe    8035fc <__umoddi3+0xd8>
  80355a:	89 c8                	mov    %ecx,%eax
  80355c:	89 f2                	mov    %esi,%edx
  80355e:	f7 f7                	div    %edi
  803560:	89 d0                	mov    %edx,%eax
  803562:	31 d2                	xor    %edx,%edx
  803564:	83 c4 1c             	add    $0x1c,%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5f                   	pop    %edi
  80356a:	5d                   	pop    %ebp
  80356b:	c3                   	ret    
  80356c:	39 f0                	cmp    %esi,%eax
  80356e:	0f 87 ac 00 00 00    	ja     803620 <__umoddi3+0xfc>
  803574:	0f bd e8             	bsr    %eax,%ebp
  803577:	83 f5 1f             	xor    $0x1f,%ebp
  80357a:	0f 84 ac 00 00 00    	je     80362c <__umoddi3+0x108>
  803580:	bf 20 00 00 00       	mov    $0x20,%edi
  803585:	29 ef                	sub    %ebp,%edi
  803587:	89 fe                	mov    %edi,%esi
  803589:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80358d:	89 e9                	mov    %ebp,%ecx
  80358f:	d3 e0                	shl    %cl,%eax
  803591:	89 d7                	mov    %edx,%edi
  803593:	89 f1                	mov    %esi,%ecx
  803595:	d3 ef                	shr    %cl,%edi
  803597:	09 c7                	or     %eax,%edi
  803599:	89 e9                	mov    %ebp,%ecx
  80359b:	d3 e2                	shl    %cl,%edx
  80359d:	89 14 24             	mov    %edx,(%esp)
  8035a0:	89 d8                	mov    %ebx,%eax
  8035a2:	d3 e0                	shl    %cl,%eax
  8035a4:	89 c2                	mov    %eax,%edx
  8035a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035aa:	d3 e0                	shl    %cl,%eax
  8035ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b4:	89 f1                	mov    %esi,%ecx
  8035b6:	d3 e8                	shr    %cl,%eax
  8035b8:	09 d0                	or     %edx,%eax
  8035ba:	d3 eb                	shr    %cl,%ebx
  8035bc:	89 da                	mov    %ebx,%edx
  8035be:	f7 f7                	div    %edi
  8035c0:	89 d3                	mov    %edx,%ebx
  8035c2:	f7 24 24             	mull   (%esp)
  8035c5:	89 c6                	mov    %eax,%esi
  8035c7:	89 d1                	mov    %edx,%ecx
  8035c9:	39 d3                	cmp    %edx,%ebx
  8035cb:	0f 82 87 00 00 00    	jb     803658 <__umoddi3+0x134>
  8035d1:	0f 84 91 00 00 00    	je     803668 <__umoddi3+0x144>
  8035d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035db:	29 f2                	sub    %esi,%edx
  8035dd:	19 cb                	sbb    %ecx,%ebx
  8035df:	89 d8                	mov    %ebx,%eax
  8035e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035e5:	d3 e0                	shl    %cl,%eax
  8035e7:	89 e9                	mov    %ebp,%ecx
  8035e9:	d3 ea                	shr    %cl,%edx
  8035eb:	09 d0                	or     %edx,%eax
  8035ed:	89 e9                	mov    %ebp,%ecx
  8035ef:	d3 eb                	shr    %cl,%ebx
  8035f1:	89 da                	mov    %ebx,%edx
  8035f3:	83 c4 1c             	add    $0x1c,%esp
  8035f6:	5b                   	pop    %ebx
  8035f7:	5e                   	pop    %esi
  8035f8:	5f                   	pop    %edi
  8035f9:	5d                   	pop    %ebp
  8035fa:	c3                   	ret    
  8035fb:	90                   	nop
  8035fc:	89 fd                	mov    %edi,%ebp
  8035fe:	85 ff                	test   %edi,%edi
  803600:	75 0b                	jne    80360d <__umoddi3+0xe9>
  803602:	b8 01 00 00 00       	mov    $0x1,%eax
  803607:	31 d2                	xor    %edx,%edx
  803609:	f7 f7                	div    %edi
  80360b:	89 c5                	mov    %eax,%ebp
  80360d:	89 f0                	mov    %esi,%eax
  80360f:	31 d2                	xor    %edx,%edx
  803611:	f7 f5                	div    %ebp
  803613:	89 c8                	mov    %ecx,%eax
  803615:	f7 f5                	div    %ebp
  803617:	89 d0                	mov    %edx,%eax
  803619:	e9 44 ff ff ff       	jmp    803562 <__umoddi3+0x3e>
  80361e:	66 90                	xchg   %ax,%ax
  803620:	89 c8                	mov    %ecx,%eax
  803622:	89 f2                	mov    %esi,%edx
  803624:	83 c4 1c             	add    $0x1c,%esp
  803627:	5b                   	pop    %ebx
  803628:	5e                   	pop    %esi
  803629:	5f                   	pop    %edi
  80362a:	5d                   	pop    %ebp
  80362b:	c3                   	ret    
  80362c:	3b 04 24             	cmp    (%esp),%eax
  80362f:	72 06                	jb     803637 <__umoddi3+0x113>
  803631:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803635:	77 0f                	ja     803646 <__umoddi3+0x122>
  803637:	89 f2                	mov    %esi,%edx
  803639:	29 f9                	sub    %edi,%ecx
  80363b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80363f:	89 14 24             	mov    %edx,(%esp)
  803642:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803646:	8b 44 24 04          	mov    0x4(%esp),%eax
  80364a:	8b 14 24             	mov    (%esp),%edx
  80364d:	83 c4 1c             	add    $0x1c,%esp
  803650:	5b                   	pop    %ebx
  803651:	5e                   	pop    %esi
  803652:	5f                   	pop    %edi
  803653:	5d                   	pop    %ebp
  803654:	c3                   	ret    
  803655:	8d 76 00             	lea    0x0(%esi),%esi
  803658:	2b 04 24             	sub    (%esp),%eax
  80365b:	19 fa                	sbb    %edi,%edx
  80365d:	89 d1                	mov    %edx,%ecx
  80365f:	89 c6                	mov    %eax,%esi
  803661:	e9 71 ff ff ff       	jmp    8035d7 <__umoddi3+0xb3>
  803666:	66 90                	xchg   %ax,%ax
  803668:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80366c:	72 ea                	jb     803658 <__umoddi3+0x134>
  80366e:	89 d9                	mov    %ebx,%ecx
  803670:	e9 62 ff ff ff       	jmp    8035d7 <__umoddi3+0xb3>
