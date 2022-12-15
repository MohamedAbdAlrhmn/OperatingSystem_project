
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
  80004d:	e8 45 19 00 00       	call   801997 <sys_calculate_free_frames>
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
  80007b:	e8 17 19 00 00       	call   801997 <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 28 19 00 00       	call   8019b0 <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 c0 37 80 00       	push   $0x8037c0
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
  8001d9:	68 e0 37 80 00       	push   $0x8037e0
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 0e 38 80 00       	push   $0x80380e
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
  800200:	e8 92 17 00 00       	call   801997 <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 a3 17 00 00       	call   8019b0 <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 9b 17 00 00       	call   8019b0 <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 7b 17 00 00       	call   801997 <sys_calculate_free_frames>
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
  800235:	68 24 38 80 00       	push   $0x803824
  80023a:	6a 53                	push   $0x53
  80023c:	68 0e 38 80 00       	push   $0x80380e
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 78 38 80 00       	push   $0x803878
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 d4 38 80 00       	push   $0x8038d4
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
  8002a7:	68 b8 39 80 00       	push   $0x8039b8
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 0e 38 80 00       	push   $0x80380e
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
  8002be:	e8 b4 19 00 00       	call   801c77 <sys_getenvindex>
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
  800329:	e8 56 17 00 00       	call   801a84 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 d8 3a 80 00       	push   $0x803ad8
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
  800359:	68 00 3b 80 00       	push   $0x803b00
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
  80038a:	68 28 3b 80 00       	push   $0x803b28
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 50 80 00       	mov    0x805020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 80 3b 80 00       	push   $0x803b80
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 d8 3a 80 00       	push   $0x803ad8
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 d6 16 00 00       	call   801a9e <sys_enable_interrupt>

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
  8003db:	e8 63 18 00 00       	call   801c43 <sys_destroy_env>
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
  8003ec:	e8 b8 18 00 00       	call   801ca9 <sys_exit_env>
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
  800415:	68 94 3b 80 00       	push   $0x803b94
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 50 80 00       	mov    0x805000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 99 3b 80 00       	push   $0x803b99
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
  800452:	68 b5 3b 80 00       	push   $0x803bb5
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
  80047e:	68 b8 3b 80 00       	push   $0x803bb8
  800483:	6a 26                	push   $0x26
  800485:	68 04 3c 80 00       	push   $0x803c04
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
  800550:	68 10 3c 80 00       	push   $0x803c10
  800555:	6a 3a                	push   $0x3a
  800557:	68 04 3c 80 00       	push   $0x803c04
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
  8005c0:	68 64 3c 80 00       	push   $0x803c64
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 04 3c 80 00       	push   $0x803c04
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
  80061a:	e8 b7 12 00 00       	call   8018d6 <sys_cputs>
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
  800691:	e8 40 12 00 00       	call   8018d6 <sys_cputs>
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
  8006db:	e8 a4 13 00 00       	call   801a84 <sys_disable_interrupt>
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
  8006fb:	e8 9e 13 00 00       	call   801a9e <sys_enable_interrupt>
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
  800745:	e8 12 2e 00 00       	call   80355c <__udivdi3>
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
  800795:	e8 d2 2e 00 00       	call   80366c <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 d4 3e 80 00       	add    $0x803ed4,%eax
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
  8008f0:	8b 04 85 f8 3e 80 00 	mov    0x803ef8(,%eax,4),%eax
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
  8009d1:	8b 34 9d 40 3d 80 00 	mov    0x803d40(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 e5 3e 80 00       	push   $0x803ee5
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
  8009f6:	68 ee 3e 80 00       	push   $0x803eee
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
  800a23:	be f1 3e 80 00       	mov    $0x803ef1,%esi
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
  801449:	68 50 40 80 00       	push   $0x804050
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
  801519:	e8 fc 04 00 00       	call   801a1a <sys_allocate_chunk>
  80151e:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801521:	a1 20 51 80 00       	mov    0x805120,%eax
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	50                   	push   %eax
  80152a:	e8 71 0b 00 00       	call   8020a0 <initialize_MemBlocksList>
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
  801557:	68 75 40 80 00       	push   $0x804075
  80155c:	6a 33                	push   $0x33
  80155e:	68 93 40 80 00       	push   $0x804093
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
  8015d6:	68 a0 40 80 00       	push   $0x8040a0
  8015db:	6a 34                	push   $0x34
  8015dd:	68 93 40 80 00       	push   $0x804093
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
  80166e:	e8 75 07 00 00       	call   801de8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801673:	85 c0                	test   %eax,%eax
  801675:	74 11                	je     801688 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801677:	83 ec 0c             	sub    $0xc,%esp
  80167a:	ff 75 e8             	pushl  -0x18(%ebp)
  80167d:	e8 e0 0d 00 00       	call   802462 <alloc_block_FF>
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
  801694:	e8 3c 0b 00 00       	call   8021d5 <insert_sorted_allocList>
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
  8016b4:	68 c4 40 80 00       	push   $0x8040c4
  8016b9:	6a 6f                	push   $0x6f
  8016bb:	68 93 40 80 00       	push   $0x804093
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
  8016da:	75 0a                	jne    8016e6 <smalloc+0x21>
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e1:	e9 8b 00 00 00       	jmp    801771 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016e6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	01 d0                	add    %edx,%eax
  8016f5:	48                   	dec    %eax
  8016f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801701:	f7 75 f0             	divl   -0x10(%ebp)
  801704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801707:	29 d0                	sub    %edx,%eax
  801709:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80170c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801713:	e8 d0 06 00 00       	call   801de8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 11                	je     80172d <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	ff 75 e8             	pushl  -0x18(%ebp)
  801722:	e8 3b 0d 00 00       	call   802462 <alloc_block_FF>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80172d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801731:	74 39                	je     80176c <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801736:	8b 40 08             	mov    0x8(%eax),%eax
  801739:	89 c2                	mov    %eax,%edx
  80173b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80173f:	52                   	push   %edx
  801740:	50                   	push   %eax
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	ff 75 08             	pushl  0x8(%ebp)
  801747:	e8 21 04 00 00       	call   801b6d <sys_createSharedObject>
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801752:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801756:	74 14                	je     80176c <smalloc+0xa7>
  801758:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80175c:	74 0e                	je     80176c <smalloc+0xa7>
  80175e:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801762:	74 08                	je     80176c <smalloc+0xa7>
			return (void*) mem_block->sva;
  801764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801767:	8b 40 08             	mov    0x8(%eax),%eax
  80176a:	eb 05                	jmp    801771 <smalloc+0xac>
	}
	return NULL;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801779:	e8 b4 fc ff ff       	call   801432 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	ff 75 08             	pushl  0x8(%ebp)
  801787:	e8 0b 04 00 00       	call   801b97 <sys_getSizeOfSharedObject>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801792:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801796:	74 76                	je     80180e <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801798:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80179f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a5:	01 d0                	add    %edx,%eax
  8017a7:	48                   	dec    %eax
  8017a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b3:	f7 75 ec             	divl   -0x14(%ebp)
  8017b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b9:	29 d0                	sub    %edx,%eax
  8017bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8017be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017c5:	e8 1e 06 00 00       	call   801de8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	74 11                	je     8017df <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8017ce:	83 ec 0c             	sub    $0xc,%esp
  8017d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017d4:	e8 89 0c 00 00       	call   802462 <alloc_block_FF>
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8017df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e3:	74 29                	je     80180e <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8017e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e8:	8b 40 08             	mov    0x8(%eax),%eax
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	50                   	push   %eax
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	ff 75 08             	pushl  0x8(%ebp)
  8017f5:	e8 ba 03 00 00       	call   801bb4 <sys_getSharedObject>
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801800:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801804:	74 08                	je     80180e <sget+0x9b>
				return (void *)mem_block->sva;
  801806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801809:	8b 40 08             	mov    0x8(%eax),%eax
  80180c:	eb 05                	jmp    801813 <sget+0xa0>
		}
	}
	return NULL;
  80180e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80181b:	e8 12 fc ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	68 e8 40 80 00       	push   $0x8040e8
  801828:	68 f1 00 00 00       	push   $0xf1
  80182d:	68 93 40 80 00       	push   $0x804093
  801832:	e8 bd eb ff ff       	call   8003f4 <_panic>

00801837 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	68 10 41 80 00       	push   $0x804110
  801845:	68 05 01 00 00       	push   $0x105
  80184a:	68 93 40 80 00       	push   $0x804093
  80184f:	e8 a0 eb ff ff       	call   8003f4 <_panic>

00801854 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185a:	83 ec 04             	sub    $0x4,%esp
  80185d:	68 34 41 80 00       	push   $0x804134
  801862:	68 10 01 00 00       	push   $0x110
  801867:	68 93 40 80 00       	push   $0x804093
  80186c:	e8 83 eb ff ff       	call   8003f4 <_panic>

00801871 <shrink>:

}
void shrink(uint32 newSize)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801877:	83 ec 04             	sub    $0x4,%esp
  80187a:	68 34 41 80 00       	push   $0x804134
  80187f:	68 15 01 00 00       	push   $0x115
  801884:	68 93 40 80 00       	push   $0x804093
  801889:	e8 66 eb ff ff       	call   8003f4 <_panic>

0080188e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	68 34 41 80 00       	push   $0x804134
  80189c:	68 1a 01 00 00       	push   $0x11a
  8018a1:	68 93 40 80 00       	push   $0x804093
  8018a6:	e8 49 eb ff ff       	call   8003f4 <_panic>

008018ab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	57                   	push   %edi
  8018af:	56                   	push   %esi
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018c3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018c6:	cd 30                	int    $0x30
  8018c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5f                   	pop    %edi
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    

008018d6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 04             	sub    $0x4,%esp
  8018dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	52                   	push   %edx
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	50                   	push   %eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	e8 b2 ff ff ff       	call   8018ab <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	90                   	nop
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 01                	push   $0x1
  80190e:	e8 98 ff ff ff       	call   8018ab <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80191b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	52                   	push   %edx
  801928:	50                   	push   %eax
  801929:	6a 05                	push   $0x5
  80192b:	e8 7b ff ff ff       	call   8018ab <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	56                   	push   %esi
  801939:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80193a:	8b 75 18             	mov    0x18(%ebp),%esi
  80193d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801940:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	56                   	push   %esi
  80194a:	53                   	push   %ebx
  80194b:	51                   	push   %ecx
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	6a 06                	push   $0x6
  801950:	e8 56 ff ff ff       	call   8018ab <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5d                   	pop    %ebp
  80195e:	c3                   	ret    

0080195f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801962:	8b 55 0c             	mov    0xc(%ebp),%edx
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	52                   	push   %edx
  80196f:	50                   	push   %eax
  801970:	6a 07                	push   $0x7
  801972:	e8 34 ff ff ff       	call   8018ab <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	6a 08                	push   $0x8
  80198d:	e8 19 ff ff ff       	call   8018ab <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 09                	push   $0x9
  8019a6:	e8 00 ff ff ff       	call   8018ab <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 0a                	push   $0xa
  8019bf:	e8 e7 fe ff ff       	call   8018ab <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 0b                	push   $0xb
  8019d8:	e8 ce fe ff ff       	call   8018ab <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	6a 0f                	push   $0xf
  8019f3:	e8 b3 fe ff ff       	call   8018ab <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
	return;
  8019fb:	90                   	nop
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	ff 75 0c             	pushl  0xc(%ebp)
  801a0a:	ff 75 08             	pushl  0x8(%ebp)
  801a0d:	6a 10                	push   $0x10
  801a0f:	e8 97 fe ff ff       	call   8018ab <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
	return ;
  801a17:	90                   	nop
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	ff 75 10             	pushl  0x10(%ebp)
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	ff 75 08             	pushl  0x8(%ebp)
  801a2a:	6a 11                	push   $0x11
  801a2c:	e8 7a fe ff ff       	call   8018ab <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
	return ;
  801a34:	90                   	nop
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 0c                	push   $0xc
  801a46:	e8 60 fe ff ff       	call   8018ab <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	ff 75 08             	pushl  0x8(%ebp)
  801a5e:	6a 0d                	push   $0xd
  801a60:	e8 46 fe ff ff       	call   8018ab <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 0e                	push   $0xe
  801a79:	e8 2d fe ff ff       	call   8018ab <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 13                	push   $0x13
  801a93:	e8 13 fe ff ff       	call   8018ab <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	90                   	nop
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 14                	push   $0x14
  801aad:	e8 f9 fd ff ff       	call   8018ab <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	90                   	nop
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 04             	sub    $0x4,%esp
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ac4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	50                   	push   %eax
  801ad1:	6a 15                	push   $0x15
  801ad3:	e8 d3 fd ff ff       	call   8018ab <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	90                   	nop
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 16                	push   $0x16
  801aed:	e8 b9 fd ff ff       	call   8018ab <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	90                   	nop
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	50                   	push   %eax
  801b08:	6a 17                	push   $0x17
  801b0a:	e8 9c fd ff ff       	call   8018ab <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	6a 1a                	push   $0x1a
  801b27:	e8 7f fd ff ff       	call   8018ab <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	6a 18                	push   $0x18
  801b44:	e8 62 fd ff ff       	call   8018ab <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	90                   	nop
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	52                   	push   %edx
  801b5f:	50                   	push   %eax
  801b60:	6a 19                	push   $0x19
  801b62:	e8 44 fd ff ff       	call   8018ab <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	90                   	nop
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	8b 45 10             	mov    0x10(%ebp),%eax
  801b76:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b79:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b7c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	51                   	push   %ecx
  801b86:	52                   	push   %edx
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	50                   	push   %eax
  801b8b:	6a 1b                	push   $0x1b
  801b8d:	e8 19 fd ff ff       	call   8018ab <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	52                   	push   %edx
  801ba7:	50                   	push   %eax
  801ba8:	6a 1c                	push   $0x1c
  801baa:	e8 fc fc ff ff       	call   8018ab <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	51                   	push   %ecx
  801bc5:	52                   	push   %edx
  801bc6:	50                   	push   %eax
  801bc7:	6a 1d                	push   $0x1d
  801bc9:	e8 dd fc ff ff       	call   8018ab <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	52                   	push   %edx
  801be3:	50                   	push   %eax
  801be4:	6a 1e                	push   $0x1e
  801be6:	e8 c0 fc ff ff       	call   8018ab <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 1f                	push   $0x1f
  801bff:	e8 a7 fc ff ff       	call   8018ab <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	6a 00                	push   $0x0
  801c11:	ff 75 14             	pushl  0x14(%ebp)
  801c14:	ff 75 10             	pushl  0x10(%ebp)
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	50                   	push   %eax
  801c1b:	6a 20                	push   $0x20
  801c1d:	e8 89 fc ff ff       	call   8018ab <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	50                   	push   %eax
  801c36:	6a 21                	push   $0x21
  801c38:	e8 6e fc ff ff       	call   8018ab <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	90                   	nop
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	50                   	push   %eax
  801c52:	6a 22                	push   $0x22
  801c54:	e8 52 fc ff ff       	call   8018ab <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 02                	push   $0x2
  801c6d:	e8 39 fc ff ff       	call   8018ab <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 03                	push   $0x3
  801c86:	e8 20 fc ff ff       	call   8018ab <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 04                	push   $0x4
  801c9f:	e8 07 fc ff ff       	call   8018ab <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_exit_env>:


void sys_exit_env(void)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 23                	push   $0x23
  801cb8:	e8 ee fb ff ff       	call   8018ab <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	90                   	nop
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cc9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ccc:	8d 50 04             	lea    0x4(%eax),%edx
  801ccf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	52                   	push   %edx
  801cd9:	50                   	push   %eax
  801cda:	6a 24                	push   $0x24
  801cdc:	e8 ca fb ff ff       	call   8018ab <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return result;
  801ce4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ced:	89 01                	mov    %eax,(%ecx)
  801cef:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	c9                   	leave  
  801cf6:	c2 04 00             	ret    $0x4

00801cf9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	ff 75 10             	pushl  0x10(%ebp)
  801d03:	ff 75 0c             	pushl  0xc(%ebp)
  801d06:	ff 75 08             	pushl  0x8(%ebp)
  801d09:	6a 12                	push   $0x12
  801d0b:	e8 9b fb ff ff       	call   8018ab <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
	return ;
  801d13:	90                   	nop
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 25                	push   $0x25
  801d25:	e8 81 fb ff ff       	call   8018ab <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 04             	sub    $0x4,%esp
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d3b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	50                   	push   %eax
  801d48:	6a 26                	push   $0x26
  801d4a:	e8 5c fb ff ff       	call   8018ab <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d52:	90                   	nop
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <rsttst>:
void rsttst()
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 28                	push   $0x28
  801d64:	e8 42 fb ff ff       	call   8018ab <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6c:	90                   	nop
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 04             	sub    $0x4,%esp
  801d75:	8b 45 14             	mov    0x14(%ebp),%eax
  801d78:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d7b:	8b 55 18             	mov    0x18(%ebp),%edx
  801d7e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d82:	52                   	push   %edx
  801d83:	50                   	push   %eax
  801d84:	ff 75 10             	pushl  0x10(%ebp)
  801d87:	ff 75 0c             	pushl  0xc(%ebp)
  801d8a:	ff 75 08             	pushl  0x8(%ebp)
  801d8d:	6a 27                	push   $0x27
  801d8f:	e8 17 fb ff ff       	call   8018ab <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return ;
  801d97:	90                   	nop
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <chktst>:
void chktst(uint32 n)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 08             	pushl  0x8(%ebp)
  801da8:	6a 29                	push   $0x29
  801daa:	e8 fc fa ff ff       	call   8018ab <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
	return ;
  801db2:	90                   	nop
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <inctst>:

void inctst()
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 2a                	push   $0x2a
  801dc4:	e8 e2 fa ff ff       	call   8018ab <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcc:	90                   	nop
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <gettst>:
uint32 gettst()
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 2b                	push   $0x2b
  801dde:	e8 c8 fa ff ff       	call   8018ab <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 2c                	push   $0x2c
  801dfa:	e8 ac fa ff ff       	call   8018ab <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
  801e02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e05:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e09:	75 07                	jne    801e12 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e10:	eb 05                	jmp    801e17 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 2c                	push   $0x2c
  801e2b:	e8 7b fa ff ff       	call   8018ab <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
  801e33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e36:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e3a:	75 07                	jne    801e43 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e41:	eb 05                	jmp    801e48 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 2c                	push   $0x2c
  801e5c:	e8 4a fa ff ff       	call   8018ab <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
  801e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e67:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e6b:	75 07                	jne    801e74 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e72:	eb 05                	jmp    801e79 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 2c                	push   $0x2c
  801e8d:	e8 19 fa ff ff       	call   8018ab <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
  801e95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e98:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e9c:	75 07                	jne    801ea5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea3:	eb 05                	jmp    801eaa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	ff 75 08             	pushl  0x8(%ebp)
  801eba:	6a 2d                	push   $0x2d
  801ebc:	e8 ea f9 ff ff       	call   8018ab <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec4:	90                   	nop
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ecb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ece:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	53                   	push   %ebx
  801eda:	51                   	push   %ecx
  801edb:	52                   	push   %edx
  801edc:	50                   	push   %eax
  801edd:	6a 2e                	push   $0x2e
  801edf:	e8 c7 f9 ff ff       	call   8018ab <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
}
  801ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	52                   	push   %edx
  801efc:	50                   	push   %eax
  801efd:	6a 2f                	push   $0x2f
  801eff:	e8 a7 f9 ff ff       	call   8018ab <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	68 44 41 80 00       	push   $0x804144
  801f17:	e8 8c e7 ff ff       	call   8006a8 <cprintf>
  801f1c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	68 70 41 80 00       	push   $0x804170
  801f2e:	e8 75 e7 ff ff       	call   8006a8 <cprintf>
  801f33:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f36:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f3a:	a1 38 51 80 00       	mov    0x805138,%eax
  801f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f42:	eb 56                	jmp    801f9a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f48:	74 1c                	je     801f66 <print_mem_block_lists+0x5d>
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	8b 50 08             	mov    0x8(%eax),%edx
  801f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f53:	8b 48 08             	mov    0x8(%eax),%ecx
  801f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f59:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5c:	01 c8                	add    %ecx,%eax
  801f5e:	39 c2                	cmp    %eax,%edx
  801f60:	73 04                	jae    801f66 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f62:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	8b 50 08             	mov    0x8(%eax),%edx
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f72:	01 c2                	add    %eax,%edx
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	8b 40 08             	mov    0x8(%eax),%eax
  801f7a:	83 ec 04             	sub    $0x4,%esp
  801f7d:	52                   	push   %edx
  801f7e:	50                   	push   %eax
  801f7f:	68 85 41 80 00       	push   $0x804185
  801f84:	e8 1f e7 ff ff       	call   8006a8 <cprintf>
  801f89:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f92:	a1 40 51 80 00       	mov    0x805140,%eax
  801f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9e:	74 07                	je     801fa7 <print_mem_block_lists+0x9e>
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 00                	mov    (%eax),%eax
  801fa5:	eb 05                	jmp    801fac <print_mem_block_lists+0xa3>
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fac:	a3 40 51 80 00       	mov    %eax,0x805140
  801fb1:	a1 40 51 80 00       	mov    0x805140,%eax
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	75 8a                	jne    801f44 <print_mem_block_lists+0x3b>
  801fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbe:	75 84                	jne    801f44 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fc0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc4:	75 10                	jne    801fd6 <print_mem_block_lists+0xcd>
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	68 94 41 80 00       	push   $0x804194
  801fce:	e8 d5 e6 ff ff       	call   8006a8 <cprintf>
  801fd3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fd6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	68 b8 41 80 00       	push   $0x8041b8
  801fe5:	e8 be e6 ff ff       	call   8006a8 <cprintf>
  801fea:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fed:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ff1:	a1 40 50 80 00       	mov    0x805040,%eax
  801ff6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff9:	eb 56                	jmp    802051 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ffb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fff:	74 1c                	je     80201d <print_mem_block_lists+0x114>
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	8b 50 08             	mov    0x8(%eax),%edx
  802007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200a:	8b 48 08             	mov    0x8(%eax),%ecx
  80200d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802010:	8b 40 0c             	mov    0xc(%eax),%eax
  802013:	01 c8                	add    %ecx,%eax
  802015:	39 c2                	cmp    %eax,%edx
  802017:	73 04                	jae    80201d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802019:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	8b 50 08             	mov    0x8(%eax),%edx
  802023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802026:	8b 40 0c             	mov    0xc(%eax),%eax
  802029:	01 c2                	add    %eax,%edx
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	8b 40 08             	mov    0x8(%eax),%eax
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	52                   	push   %edx
  802035:	50                   	push   %eax
  802036:	68 85 41 80 00       	push   $0x804185
  80203b:	e8 68 e6 ff ff       	call   8006a8 <cprintf>
  802040:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802046:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802049:	a1 48 50 80 00       	mov    0x805048,%eax
  80204e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802051:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802055:	74 07                	je     80205e <print_mem_block_lists+0x155>
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	8b 00                	mov    (%eax),%eax
  80205c:	eb 05                	jmp    802063 <print_mem_block_lists+0x15a>
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	a3 48 50 80 00       	mov    %eax,0x805048
  802068:	a1 48 50 80 00       	mov    0x805048,%eax
  80206d:	85 c0                	test   %eax,%eax
  80206f:	75 8a                	jne    801ffb <print_mem_block_lists+0xf2>
  802071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802075:	75 84                	jne    801ffb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802077:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80207b:	75 10                	jne    80208d <print_mem_block_lists+0x184>
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	68 d0 41 80 00       	push   $0x8041d0
  802085:	e8 1e e6 ff ff       	call   8006a8 <cprintf>
  80208a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	68 44 41 80 00       	push   $0x804144
  802095:	e8 0e e6 ff ff       	call   8006a8 <cprintf>
  80209a:	83 c4 10             	add    $0x10,%esp

}
  80209d:	90                   	nop
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020a6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020ad:	00 00 00 
  8020b0:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020b7:	00 00 00 
  8020ba:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020c1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020cb:	e9 9e 00 00 00       	jmp    80216e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020d0:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d8:	c1 e2 04             	shl    $0x4,%edx
  8020db:	01 d0                	add    %edx,%eax
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	75 14                	jne    8020f5 <initialize_MemBlocksList+0x55>
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	68 f8 41 80 00       	push   $0x8041f8
  8020e9:	6a 46                	push   $0x46
  8020eb:	68 1b 42 80 00       	push   $0x80421b
  8020f0:	e8 ff e2 ff ff       	call   8003f4 <_panic>
  8020f5:	a1 50 50 80 00       	mov    0x805050,%eax
  8020fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fd:	c1 e2 04             	shl    $0x4,%edx
  802100:	01 d0                	add    %edx,%eax
  802102:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802108:	89 10                	mov    %edx,(%eax)
  80210a:	8b 00                	mov    (%eax),%eax
  80210c:	85 c0                	test   %eax,%eax
  80210e:	74 18                	je     802128 <initialize_MemBlocksList+0x88>
  802110:	a1 48 51 80 00       	mov    0x805148,%eax
  802115:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80211b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80211e:	c1 e1 04             	shl    $0x4,%ecx
  802121:	01 ca                	add    %ecx,%edx
  802123:	89 50 04             	mov    %edx,0x4(%eax)
  802126:	eb 12                	jmp    80213a <initialize_MemBlocksList+0x9a>
  802128:	a1 50 50 80 00       	mov    0x805050,%eax
  80212d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802130:	c1 e2 04             	shl    $0x4,%edx
  802133:	01 d0                	add    %edx,%eax
  802135:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80213a:	a1 50 50 80 00       	mov    0x805050,%eax
  80213f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802142:	c1 e2 04             	shl    $0x4,%edx
  802145:	01 d0                	add    %edx,%eax
  802147:	a3 48 51 80 00       	mov    %eax,0x805148
  80214c:	a1 50 50 80 00       	mov    0x805050,%eax
  802151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802154:	c1 e2 04             	shl    $0x4,%edx
  802157:	01 d0                	add    %edx,%eax
  802159:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802160:	a1 54 51 80 00       	mov    0x805154,%eax
  802165:	40                   	inc    %eax
  802166:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80216b:	ff 45 f4             	incl   -0xc(%ebp)
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	3b 45 08             	cmp    0x8(%ebp),%eax
  802174:	0f 82 56 ff ff ff    	jb     8020d0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80217a:	90                   	nop
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80218b:	eb 19                	jmp    8021a6 <find_block+0x29>
	{
		if(va==point->sva)
  80218d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802190:	8b 40 08             	mov    0x8(%eax),%eax
  802193:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802196:	75 05                	jne    80219d <find_block+0x20>
		   return point;
  802198:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219b:	eb 36                	jmp    8021d3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	8b 40 08             	mov    0x8(%eax),%eax
  8021a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021aa:	74 07                	je     8021b3 <find_block+0x36>
  8021ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021af:	8b 00                	mov    (%eax),%eax
  8021b1:	eb 05                	jmp    8021b8 <find_block+0x3b>
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021bb:	89 42 08             	mov    %eax,0x8(%edx)
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	8b 40 08             	mov    0x8(%eax),%eax
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	75 c5                	jne    80218d <find_block+0x10>
  8021c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021cc:	75 bf                	jne    80218d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021db:	a1 40 50 80 00       	mov    0x805040,%eax
  8021e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021e3:	a1 44 50 80 00       	mov    0x805044,%eax
  8021e8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021f1:	74 24                	je     802217 <insert_sorted_allocList+0x42>
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8b 50 08             	mov    0x8(%eax),%edx
  8021f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fc:	8b 40 08             	mov    0x8(%eax),%eax
  8021ff:	39 c2                	cmp    %eax,%edx
  802201:	76 14                	jbe    802217 <insert_sorted_allocList+0x42>
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	8b 50 08             	mov    0x8(%eax),%edx
  802209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220c:	8b 40 08             	mov    0x8(%eax),%eax
  80220f:	39 c2                	cmp    %eax,%edx
  802211:	0f 82 60 01 00 00    	jb     802377 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802217:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221b:	75 65                	jne    802282 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80221d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802221:	75 14                	jne    802237 <insert_sorted_allocList+0x62>
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	68 f8 41 80 00       	push   $0x8041f8
  80222b:	6a 6b                	push   $0x6b
  80222d:	68 1b 42 80 00       	push   $0x80421b
  802232:	e8 bd e1 ff ff       	call   8003f4 <_panic>
  802237:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	89 10                	mov    %edx,(%eax)
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	8b 00                	mov    (%eax),%eax
  802247:	85 c0                	test   %eax,%eax
  802249:	74 0d                	je     802258 <insert_sorted_allocList+0x83>
  80224b:	a1 40 50 80 00       	mov    0x805040,%eax
  802250:	8b 55 08             	mov    0x8(%ebp),%edx
  802253:	89 50 04             	mov    %edx,0x4(%eax)
  802256:	eb 08                	jmp    802260 <insert_sorted_allocList+0x8b>
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	a3 44 50 80 00       	mov    %eax,0x805044
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	a3 40 50 80 00       	mov    %eax,0x805040
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802272:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802277:	40                   	inc    %eax
  802278:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80227d:	e9 dc 01 00 00       	jmp    80245e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	8b 50 08             	mov    0x8(%eax),%edx
  802288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228b:	8b 40 08             	mov    0x8(%eax),%eax
  80228e:	39 c2                	cmp    %eax,%edx
  802290:	77 6c                	ja     8022fe <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802292:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802296:	74 06                	je     80229e <insert_sorted_allocList+0xc9>
  802298:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229c:	75 14                	jne    8022b2 <insert_sorted_allocList+0xdd>
  80229e:	83 ec 04             	sub    $0x4,%esp
  8022a1:	68 34 42 80 00       	push   $0x804234
  8022a6:	6a 6f                	push   $0x6f
  8022a8:	68 1b 42 80 00       	push   $0x80421b
  8022ad:	e8 42 e1 ff ff       	call   8003f4 <_panic>
  8022b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b5:	8b 50 04             	mov    0x4(%eax),%edx
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	89 50 04             	mov    %edx,0x4(%eax)
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c4:	89 10                	mov    %edx,(%eax)
  8022c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c9:	8b 40 04             	mov    0x4(%eax),%eax
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	74 0d                	je     8022dd <insert_sorted_allocList+0x108>
  8022d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d3:	8b 40 04             	mov    0x4(%eax),%eax
  8022d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d9:	89 10                	mov    %edx,(%eax)
  8022db:	eb 08                	jmp    8022e5 <insert_sorted_allocList+0x110>
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	a3 40 50 80 00       	mov    %eax,0x805040
  8022e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022eb:	89 50 04             	mov    %edx,0x4(%eax)
  8022ee:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022f3:	40                   	inc    %eax
  8022f4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022f9:	e9 60 01 00 00       	jmp    80245e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	8b 50 08             	mov    0x8(%eax),%edx
  802304:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802307:	8b 40 08             	mov    0x8(%eax),%eax
  80230a:	39 c2                	cmp    %eax,%edx
  80230c:	0f 82 4c 01 00 00    	jb     80245e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802312:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802316:	75 14                	jne    80232c <insert_sorted_allocList+0x157>
  802318:	83 ec 04             	sub    $0x4,%esp
  80231b:	68 6c 42 80 00       	push   $0x80426c
  802320:	6a 73                	push   $0x73
  802322:	68 1b 42 80 00       	push   $0x80421b
  802327:	e8 c8 e0 ff ff       	call   8003f4 <_panic>
  80232c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	89 50 04             	mov    %edx,0x4(%eax)
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	8b 40 04             	mov    0x4(%eax),%eax
  80233e:	85 c0                	test   %eax,%eax
  802340:	74 0c                	je     80234e <insert_sorted_allocList+0x179>
  802342:	a1 44 50 80 00       	mov    0x805044,%eax
  802347:	8b 55 08             	mov    0x8(%ebp),%edx
  80234a:	89 10                	mov    %edx,(%eax)
  80234c:	eb 08                	jmp    802356 <insert_sorted_allocList+0x181>
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	a3 40 50 80 00       	mov    %eax,0x805040
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	a3 44 50 80 00       	mov    %eax,0x805044
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802367:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80236c:	40                   	inc    %eax
  80236d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802372:	e9 e7 00 00 00       	jmp    80245e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80237d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802384:	a1 40 50 80 00       	mov    0x805040,%eax
  802389:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238c:	e9 9d 00 00 00       	jmp    80242e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 00                	mov    (%eax),%eax
  802396:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8b 50 08             	mov    0x8(%eax),%edx
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 40 08             	mov    0x8(%eax),%eax
  8023a5:	39 c2                	cmp    %eax,%edx
  8023a7:	76 7d                	jbe    802426 <insert_sorted_allocList+0x251>
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	8b 50 08             	mov    0x8(%eax),%edx
  8023af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023b2:	8b 40 08             	mov    0x8(%eax),%eax
  8023b5:	39 c2                	cmp    %eax,%edx
  8023b7:	73 6d                	jae    802426 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bd:	74 06                	je     8023c5 <insert_sorted_allocList+0x1f0>
  8023bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c3:	75 14                	jne    8023d9 <insert_sorted_allocList+0x204>
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	68 90 42 80 00       	push   $0x804290
  8023cd:	6a 7f                	push   $0x7f
  8023cf:	68 1b 42 80 00       	push   $0x80421b
  8023d4:	e8 1b e0 ff ff       	call   8003f4 <_panic>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 10                	mov    (%eax),%edx
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	89 10                	mov    %edx,(%eax)
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	74 0b                	je     8023f7 <insert_sorted_allocList+0x222>
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 00                	mov    (%eax),%eax
  8023f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f4:	89 50 04             	mov    %edx,0x4(%eax)
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fd:	89 10                	mov    %edx,(%eax)
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802405:	89 50 04             	mov    %edx,0x4(%eax)
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	75 08                	jne    802419 <insert_sorted_allocList+0x244>
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	a3 44 50 80 00       	mov    %eax,0x805044
  802419:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80241e:	40                   	inc    %eax
  80241f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802424:	eb 39                	jmp    80245f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802426:	a1 48 50 80 00       	mov    0x805048,%eax
  80242b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802432:	74 07                	je     80243b <insert_sorted_allocList+0x266>
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	eb 05                	jmp    802440 <insert_sorted_allocList+0x26b>
  80243b:	b8 00 00 00 00       	mov    $0x0,%eax
  802440:	a3 48 50 80 00       	mov    %eax,0x805048
  802445:	a1 48 50 80 00       	mov    0x805048,%eax
  80244a:	85 c0                	test   %eax,%eax
  80244c:	0f 85 3f ff ff ff    	jne    802391 <insert_sorted_allocList+0x1bc>
  802452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802456:	0f 85 35 ff ff ff    	jne    802391 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80245c:	eb 01                	jmp    80245f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80245e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80245f:	90                   	nop
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802468:	a1 38 51 80 00       	mov    0x805138,%eax
  80246d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802470:	e9 85 01 00 00       	jmp    8025fa <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 40 0c             	mov    0xc(%eax),%eax
  80247b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80247e:	0f 82 6e 01 00 00    	jb     8025f2 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248d:	0f 85 8a 00 00 00    	jne    80251d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802497:	75 17                	jne    8024b0 <alloc_block_FF+0x4e>
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	68 c4 42 80 00       	push   $0x8042c4
  8024a1:	68 93 00 00 00       	push   $0x93
  8024a6:	68 1b 42 80 00       	push   $0x80421b
  8024ab:	e8 44 df ff ff       	call   8003f4 <_panic>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	74 10                	je     8024c9 <alloc_block_FF+0x67>
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c1:	8b 52 04             	mov    0x4(%edx),%edx
  8024c4:	89 50 04             	mov    %edx,0x4(%eax)
  8024c7:	eb 0b                	jmp    8024d4 <alloc_block_FF+0x72>
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 40 04             	mov    0x4(%eax),%eax
  8024cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 04             	mov    0x4(%eax),%eax
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	74 0f                	je     8024ed <alloc_block_FF+0x8b>
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e7:	8b 12                	mov    (%edx),%edx
  8024e9:	89 10                	mov    %edx,(%eax)
  8024eb:	eb 0a                	jmp    8024f7 <alloc_block_FF+0x95>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250a:	a1 44 51 80 00       	mov    0x805144,%eax
  80250f:	48                   	dec    %eax
  802510:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	e9 10 01 00 00       	jmp    80262d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 40 0c             	mov    0xc(%eax),%eax
  802523:	3b 45 08             	cmp    0x8(%ebp),%eax
  802526:	0f 86 c6 00 00 00    	jbe    8025f2 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80252c:	a1 48 51 80 00       	mov    0x805148,%eax
  802531:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 50 08             	mov    0x8(%eax),%edx
  80253a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	8b 55 08             	mov    0x8(%ebp),%edx
  802546:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802549:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80254d:	75 17                	jne    802566 <alloc_block_FF+0x104>
  80254f:	83 ec 04             	sub    $0x4,%esp
  802552:	68 c4 42 80 00       	push   $0x8042c4
  802557:	68 9b 00 00 00       	push   $0x9b
  80255c:	68 1b 42 80 00       	push   $0x80421b
  802561:	e8 8e de ff ff       	call   8003f4 <_panic>
  802566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 10                	je     80257f <alloc_block_FF+0x11d>
  80256f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802572:	8b 00                	mov    (%eax),%eax
  802574:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802577:	8b 52 04             	mov    0x4(%edx),%edx
  80257a:	89 50 04             	mov    %edx,0x4(%eax)
  80257d:	eb 0b                	jmp    80258a <alloc_block_FF+0x128>
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	8b 40 04             	mov    0x4(%eax),%eax
  802585:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258d:	8b 40 04             	mov    0x4(%eax),%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	74 0f                	je     8025a3 <alloc_block_FF+0x141>
  802594:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802597:	8b 40 04             	mov    0x4(%eax),%eax
  80259a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80259d:	8b 12                	mov    (%edx),%edx
  80259f:	89 10                	mov    %edx,(%eax)
  8025a1:	eb 0a                	jmp    8025ad <alloc_block_FF+0x14b>
  8025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8025ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8025c5:	48                   	dec    %eax
  8025c6:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 50 08             	mov    0x8(%eax),%edx
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	01 c2                	add    %eax,%edx
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e2:	2b 45 08             	sub    0x8(%ebp),%eax
  8025e5:	89 c2                	mov    %eax,%edx
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f0:	eb 3b                	jmp    80262d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fe:	74 07                	je     802607 <alloc_block_FF+0x1a5>
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	eb 05                	jmp    80260c <alloc_block_FF+0x1aa>
  802607:	b8 00 00 00 00       	mov    $0x0,%eax
  80260c:	a3 40 51 80 00       	mov    %eax,0x805140
  802611:	a1 40 51 80 00       	mov    0x805140,%eax
  802616:	85 c0                	test   %eax,%eax
  802618:	0f 85 57 fe ff ff    	jne    802475 <alloc_block_FF+0x13>
  80261e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802622:	0f 85 4d fe ff ff    	jne    802475 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802635:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80263c:	a1 38 51 80 00       	mov    0x805138,%eax
  802641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802644:	e9 df 00 00 00       	jmp    802728 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 0c             	mov    0xc(%eax),%eax
  80264f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802652:	0f 82 c8 00 00 00    	jb     802720 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 40 0c             	mov    0xc(%eax),%eax
  80265e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802661:	0f 85 8a 00 00 00    	jne    8026f1 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802667:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266b:	75 17                	jne    802684 <alloc_block_BF+0x55>
  80266d:	83 ec 04             	sub    $0x4,%esp
  802670:	68 c4 42 80 00       	push   $0x8042c4
  802675:	68 b7 00 00 00       	push   $0xb7
  80267a:	68 1b 42 80 00       	push   $0x80421b
  80267f:	e8 70 dd ff ff       	call   8003f4 <_panic>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	74 10                	je     80269d <alloc_block_BF+0x6e>
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802695:	8b 52 04             	mov    0x4(%edx),%edx
  802698:	89 50 04             	mov    %edx,0x4(%eax)
  80269b:	eb 0b                	jmp    8026a8 <alloc_block_BF+0x79>
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 40 04             	mov    0x4(%eax),%eax
  8026a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	74 0f                	je     8026c1 <alloc_block_BF+0x92>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 04             	mov    0x4(%eax),%eax
  8026b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bb:	8b 12                	mov    (%edx),%edx
  8026bd:	89 10                	mov    %edx,(%eax)
  8026bf:	eb 0a                	jmp    8026cb <alloc_block_BF+0x9c>
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026de:	a1 44 51 80 00       	mov    0x805144,%eax
  8026e3:	48                   	dec    %eax
  8026e4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	e9 4d 01 00 00       	jmp    80283e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fa:	76 24                	jbe    802720 <alloc_block_BF+0xf1>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802702:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802705:	73 19                	jae    802720 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802707:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 40 0c             	mov    0xc(%eax),%eax
  802714:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	8b 40 08             	mov    0x8(%eax),%eax
  80271d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802720:	a1 40 51 80 00       	mov    0x805140,%eax
  802725:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802728:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272c:	74 07                	je     802735 <alloc_block_BF+0x106>
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	eb 05                	jmp    80273a <alloc_block_BF+0x10b>
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
  80273a:	a3 40 51 80 00       	mov    %eax,0x805140
  80273f:	a1 40 51 80 00       	mov    0x805140,%eax
  802744:	85 c0                	test   %eax,%eax
  802746:	0f 85 fd fe ff ff    	jne    802649 <alloc_block_BF+0x1a>
  80274c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802750:	0f 85 f3 fe ff ff    	jne    802649 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802756:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80275a:	0f 84 d9 00 00 00    	je     802839 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802760:	a1 48 51 80 00       	mov    0x805148,%eax
  802765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80276e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802774:	8b 55 08             	mov    0x8(%ebp),%edx
  802777:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80277a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80277e:	75 17                	jne    802797 <alloc_block_BF+0x168>
  802780:	83 ec 04             	sub    $0x4,%esp
  802783:	68 c4 42 80 00       	push   $0x8042c4
  802788:	68 c7 00 00 00       	push   $0xc7
  80278d:	68 1b 42 80 00       	push   $0x80421b
  802792:	e8 5d dc ff ff       	call   8003f4 <_panic>
  802797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 10                	je     8027b0 <alloc_block_BF+0x181>
  8027a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027a8:	8b 52 04             	mov    0x4(%edx),%edx
  8027ab:	89 50 04             	mov    %edx,0x4(%eax)
  8027ae:	eb 0b                	jmp    8027bb <alloc_block_BF+0x18c>
  8027b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027be:	8b 40 04             	mov    0x4(%eax),%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	74 0f                	je     8027d4 <alloc_block_BF+0x1a5>
  8027c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ce:	8b 12                	mov    (%edx),%edx
  8027d0:	89 10                	mov    %edx,(%eax)
  8027d2:	eb 0a                	jmp    8027de <alloc_block_BF+0x1af>
  8027d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8027de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8027f6:	48                   	dec    %eax
  8027f7:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027fc:	83 ec 08             	sub    $0x8,%esp
  8027ff:	ff 75 ec             	pushl  -0x14(%ebp)
  802802:	68 38 51 80 00       	push   $0x805138
  802807:	e8 71 f9 ff ff       	call   80217d <find_block>
  80280c:	83 c4 10             	add    $0x10,%esp
  80280f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802815:	8b 50 08             	mov    0x8(%eax),%edx
  802818:	8b 45 08             	mov    0x8(%ebp),%eax
  80281b:	01 c2                	add    %eax,%edx
  80281d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802820:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802823:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802826:	8b 40 0c             	mov    0xc(%eax),%eax
  802829:	2b 45 08             	sub    0x8(%ebp),%eax
  80282c:	89 c2                	mov    %eax,%edx
  80282e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802831:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802837:	eb 05                	jmp    80283e <alloc_block_BF+0x20f>
	}
	return NULL;
  802839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283e:	c9                   	leave  
  80283f:	c3                   	ret    

00802840 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802846:	a1 28 50 80 00       	mov    0x805028,%eax
  80284b:	85 c0                	test   %eax,%eax
  80284d:	0f 85 de 01 00 00    	jne    802a31 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802853:	a1 38 51 80 00       	mov    0x805138,%eax
  802858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285b:	e9 9e 01 00 00       	jmp    8029fe <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 40 0c             	mov    0xc(%eax),%eax
  802866:	3b 45 08             	cmp    0x8(%ebp),%eax
  802869:	0f 82 87 01 00 00    	jb     8029f6 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 40 0c             	mov    0xc(%eax),%eax
  802875:	3b 45 08             	cmp    0x8(%ebp),%eax
  802878:	0f 85 95 00 00 00    	jne    802913 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80287e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802882:	75 17                	jne    80289b <alloc_block_NF+0x5b>
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	68 c4 42 80 00       	push   $0x8042c4
  80288c:	68 e0 00 00 00       	push   $0xe0
  802891:	68 1b 42 80 00       	push   $0x80421b
  802896:	e8 59 db ff ff       	call   8003f4 <_panic>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 10                	je     8028b4 <alloc_block_NF+0x74>
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 00                	mov    (%eax),%eax
  8028a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ac:	8b 52 04             	mov    0x4(%edx),%edx
  8028af:	89 50 04             	mov    %edx,0x4(%eax)
  8028b2:	eb 0b                	jmp    8028bf <alloc_block_NF+0x7f>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 04             	mov    0x4(%eax),%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 0f                	je     8028d8 <alloc_block_NF+0x98>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 04             	mov    0x4(%eax),%eax
  8028cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d2:	8b 12                	mov    (%edx),%edx
  8028d4:	89 10                	mov    %edx,(%eax)
  8028d6:	eb 0a                	jmp    8028e2 <alloc_block_NF+0xa2>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8028fa:	48                   	dec    %eax
  8028fb:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 40 08             	mov    0x8(%eax),%eax
  802906:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	e9 f8 04 00 00       	jmp    802e0b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 0c             	mov    0xc(%eax),%eax
  802919:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291c:	0f 86 d4 00 00 00    	jbe    8029f6 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802922:	a1 48 51 80 00       	mov    0x805148,%eax
  802927:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 50 08             	mov    0x8(%eax),%edx
  802930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802933:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802939:	8b 55 08             	mov    0x8(%ebp),%edx
  80293c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80293f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802943:	75 17                	jne    80295c <alloc_block_NF+0x11c>
  802945:	83 ec 04             	sub    $0x4,%esp
  802948:	68 c4 42 80 00       	push   $0x8042c4
  80294d:	68 e9 00 00 00       	push   $0xe9
  802952:	68 1b 42 80 00       	push   $0x80421b
  802957:	e8 98 da ff ff       	call   8003f4 <_panic>
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 10                	je     802975 <alloc_block_NF+0x135>
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296d:	8b 52 04             	mov    0x4(%edx),%edx
  802970:	89 50 04             	mov    %edx,0x4(%eax)
  802973:	eb 0b                	jmp    802980 <alloc_block_NF+0x140>
  802975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 0f                	je     802999 <alloc_block_NF+0x159>
  80298a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802993:	8b 12                	mov    (%edx),%edx
  802995:	89 10                	mov    %edx,(%eax)
  802997:	eb 0a                	jmp    8029a3 <alloc_block_NF+0x163>
  802999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	a3 48 51 80 00       	mov    %eax,0x805148
  8029a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b6:	a1 54 51 80 00       	mov    0x805154,%eax
  8029bb:	48                   	dec    %eax
  8029bc:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	8b 40 08             	mov    0x8(%eax),%eax
  8029c7:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 50 08             	mov    0x8(%eax),%edx
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	01 c2                	add    %eax,%edx
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e6:	89 c2                	mov    %eax,%edx
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	e9 15 04 00 00       	jmp    802e0b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029f6:	a1 40 51 80 00       	mov    0x805140,%eax
  8029fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a02:	74 07                	je     802a0b <alloc_block_NF+0x1cb>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	eb 05                	jmp    802a10 <alloc_block_NF+0x1d0>
  802a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a10:	a3 40 51 80 00       	mov    %eax,0x805140
  802a15:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	0f 85 3e fe ff ff    	jne    802860 <alloc_block_NF+0x20>
  802a22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a26:	0f 85 34 fe ff ff    	jne    802860 <alloc_block_NF+0x20>
  802a2c:	e9 d5 03 00 00       	jmp    802e06 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a31:	a1 38 51 80 00       	mov    0x805138,%eax
  802a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a39:	e9 b1 01 00 00       	jmp    802bef <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 50 08             	mov    0x8(%eax),%edx
  802a44:	a1 28 50 80 00       	mov    0x805028,%eax
  802a49:	39 c2                	cmp    %eax,%edx
  802a4b:	0f 82 96 01 00 00    	jb     802be7 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 40 0c             	mov    0xc(%eax),%eax
  802a57:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5a:	0f 82 87 01 00 00    	jb     802be7 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 40 0c             	mov    0xc(%eax),%eax
  802a66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a69:	0f 85 95 00 00 00    	jne    802b04 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a73:	75 17                	jne    802a8c <alloc_block_NF+0x24c>
  802a75:	83 ec 04             	sub    $0x4,%esp
  802a78:	68 c4 42 80 00       	push   $0x8042c4
  802a7d:	68 fc 00 00 00       	push   $0xfc
  802a82:	68 1b 42 80 00       	push   $0x80421b
  802a87:	e8 68 d9 ff ff       	call   8003f4 <_panic>
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	74 10                	je     802aa5 <alloc_block_NF+0x265>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 00                	mov    (%eax),%eax
  802a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9d:	8b 52 04             	mov    0x4(%edx),%edx
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)
  802aa3:	eb 0b                	jmp    802ab0 <alloc_block_NF+0x270>
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 04             	mov    0x4(%eax),%eax
  802aab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	74 0f                	je     802ac9 <alloc_block_NF+0x289>
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 40 04             	mov    0x4(%eax),%eax
  802ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac3:	8b 12                	mov    (%edx),%edx
  802ac5:	89 10                	mov    %edx,(%eax)
  802ac7:	eb 0a                	jmp    802ad3 <alloc_block_NF+0x293>
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	a3 38 51 80 00       	mov    %eax,0x805138
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae6:	a1 44 51 80 00       	mov    0x805144,%eax
  802aeb:	48                   	dec    %eax
  802aec:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 40 08             	mov    0x8(%eax),%eax
  802af7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	e9 07 03 00 00       	jmp    802e0b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b0d:	0f 86 d4 00 00 00    	jbe    802be7 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b13:	a1 48 51 80 00       	mov    0x805148,%eax
  802b18:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 50 08             	mov    0x8(%eax),%edx
  802b21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b24:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b34:	75 17                	jne    802b4d <alloc_block_NF+0x30d>
  802b36:	83 ec 04             	sub    $0x4,%esp
  802b39:	68 c4 42 80 00       	push   $0x8042c4
  802b3e:	68 04 01 00 00       	push   $0x104
  802b43:	68 1b 42 80 00       	push   $0x80421b
  802b48:	e8 a7 d8 ff ff       	call   8003f4 <_panic>
  802b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	74 10                	je     802b66 <alloc_block_NF+0x326>
  802b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b5e:	8b 52 04             	mov    0x4(%edx),%edx
  802b61:	89 50 04             	mov    %edx,0x4(%eax)
  802b64:	eb 0b                	jmp    802b71 <alloc_block_NF+0x331>
  802b66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b69:	8b 40 04             	mov    0x4(%eax),%eax
  802b6c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b74:	8b 40 04             	mov    0x4(%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 0f                	je     802b8a <alloc_block_NF+0x34a>
  802b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7e:	8b 40 04             	mov    0x4(%eax),%eax
  802b81:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b84:	8b 12                	mov    (%edx),%edx
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	eb 0a                	jmp    802b94 <alloc_block_NF+0x354>
  802b8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	a3 48 51 80 00       	mov    %eax,0x805148
  802b94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba7:	a1 54 51 80 00       	mov    0x805154,%eax
  802bac:	48                   	dec    %eax
  802bad:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb5:	8b 40 08             	mov    0x8(%eax),%eax
  802bb8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 50 08             	mov    0x8(%eax),%edx
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	01 c2                	add    %eax,%edx
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd4:	2b 45 08             	sub    0x8(%ebp),%eax
  802bd7:	89 c2                	mov    %eax,%edx
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be2:	e9 24 02 00 00       	jmp    802e0b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802be7:	a1 40 51 80 00       	mov    0x805140,%eax
  802bec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf3:	74 07                	je     802bfc <alloc_block_NF+0x3bc>
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	eb 05                	jmp    802c01 <alloc_block_NF+0x3c1>
  802bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  802c01:	a3 40 51 80 00       	mov    %eax,0x805140
  802c06:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	0f 85 2b fe ff ff    	jne    802a3e <alloc_block_NF+0x1fe>
  802c13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c17:	0f 85 21 fe ff ff    	jne    802a3e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c1d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c25:	e9 ae 01 00 00       	jmp    802dd8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 50 08             	mov    0x8(%eax),%edx
  802c30:	a1 28 50 80 00       	mov    0x805028,%eax
  802c35:	39 c2                	cmp    %eax,%edx
  802c37:	0f 83 93 01 00 00    	jae    802dd0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 0c             	mov    0xc(%eax),%eax
  802c43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c46:	0f 82 84 01 00 00    	jb     802dd0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c55:	0f 85 95 00 00 00    	jne    802cf0 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5f:	75 17                	jne    802c78 <alloc_block_NF+0x438>
  802c61:	83 ec 04             	sub    $0x4,%esp
  802c64:	68 c4 42 80 00       	push   $0x8042c4
  802c69:	68 14 01 00 00       	push   $0x114
  802c6e:	68 1b 42 80 00       	push   $0x80421b
  802c73:	e8 7c d7 ff ff       	call   8003f4 <_panic>
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 10                	je     802c91 <alloc_block_NF+0x451>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c89:	8b 52 04             	mov    0x4(%edx),%edx
  802c8c:	89 50 04             	mov    %edx,0x4(%eax)
  802c8f:	eb 0b                	jmp    802c9c <alloc_block_NF+0x45c>
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ca2:	85 c0                	test   %eax,%eax
  802ca4:	74 0f                	je     802cb5 <alloc_block_NF+0x475>
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802caf:	8b 12                	mov    (%edx),%edx
  802cb1:	89 10                	mov    %edx,(%eax)
  802cb3:	eb 0a                	jmp    802cbf <alloc_block_NF+0x47f>
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 00                	mov    (%eax),%eax
  802cba:	a3 38 51 80 00       	mov    %eax,0x805138
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd2:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd7:	48                   	dec    %eax
  802cd8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	8b 40 08             	mov    0x8(%eax),%eax
  802ce3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	e9 1b 01 00 00       	jmp    802e0b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf9:	0f 86 d1 00 00 00    	jbe    802dd0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cff:	a1 48 51 80 00       	mov    0x805148,%eax
  802d04:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 50 08             	mov    0x8(%eax),%edx
  802d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d10:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d16:	8b 55 08             	mov    0x8(%ebp),%edx
  802d19:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d20:	75 17                	jne    802d39 <alloc_block_NF+0x4f9>
  802d22:	83 ec 04             	sub    $0x4,%esp
  802d25:	68 c4 42 80 00       	push   $0x8042c4
  802d2a:	68 1c 01 00 00       	push   $0x11c
  802d2f:	68 1b 42 80 00       	push   $0x80421b
  802d34:	e8 bb d6 ff ff       	call   8003f4 <_panic>
  802d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 10                	je     802d52 <alloc_block_NF+0x512>
  802d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d4a:	8b 52 04             	mov    0x4(%edx),%edx
  802d4d:	89 50 04             	mov    %edx,0x4(%eax)
  802d50:	eb 0b                	jmp    802d5d <alloc_block_NF+0x51d>
  802d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d60:	8b 40 04             	mov    0x4(%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	74 0f                	je     802d76 <alloc_block_NF+0x536>
  802d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d70:	8b 12                	mov    (%edx),%edx
  802d72:	89 10                	mov    %edx,(%eax)
  802d74:	eb 0a                	jmp    802d80 <alloc_block_NF+0x540>
  802d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	a3 48 51 80 00       	mov    %eax,0x805148
  802d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d93:	a1 54 51 80 00       	mov    0x805154,%eax
  802d98:	48                   	dec    %eax
  802d99:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	8b 40 08             	mov    0x8(%eax),%eax
  802da4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 50 08             	mov    0x8(%eax),%edx
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	01 c2                	add    %eax,%edx
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc0:	2b 45 08             	sub    0x8(%ebp),%eax
  802dc3:	89 c2                	mov    %eax,%edx
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dce:	eb 3b                	jmp    802e0b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dd0:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddc:	74 07                	je     802de5 <alloc_block_NF+0x5a5>
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	eb 05                	jmp    802dea <alloc_block_NF+0x5aa>
  802de5:	b8 00 00 00 00       	mov    $0x0,%eax
  802dea:	a3 40 51 80 00       	mov    %eax,0x805140
  802def:	a1 40 51 80 00       	mov    0x805140,%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	0f 85 2e fe ff ff    	jne    802c2a <alloc_block_NF+0x3ea>
  802dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e00:	0f 85 24 fe ff ff    	jne    802c2a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0b:	c9                   	leave  
  802e0c:	c3                   	ret    

00802e0d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e0d:	55                   	push   %ebp
  802e0e:	89 e5                	mov    %esp,%ebp
  802e10:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e13:	a1 38 51 80 00       	mov    0x805138,%eax
  802e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e1b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e20:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e23:	a1 38 51 80 00       	mov    0x805138,%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 14                	je     802e40 <insert_sorted_with_merge_freeList+0x33>
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	8b 50 08             	mov    0x8(%eax),%edx
  802e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e35:	8b 40 08             	mov    0x8(%eax),%eax
  802e38:	39 c2                	cmp    %eax,%edx
  802e3a:	0f 87 9b 01 00 00    	ja     802fdb <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e44:	75 17                	jne    802e5d <insert_sorted_with_merge_freeList+0x50>
  802e46:	83 ec 04             	sub    $0x4,%esp
  802e49:	68 f8 41 80 00       	push   $0x8041f8
  802e4e:	68 38 01 00 00       	push   $0x138
  802e53:	68 1b 42 80 00       	push   $0x80421b
  802e58:	e8 97 d5 ff ff       	call   8003f4 <_panic>
  802e5d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	89 10                	mov    %edx,(%eax)
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 0d                	je     802e7e <insert_sorted_with_merge_freeList+0x71>
  802e71:	a1 38 51 80 00       	mov    0x805138,%eax
  802e76:	8b 55 08             	mov    0x8(%ebp),%edx
  802e79:	89 50 04             	mov    %edx,0x4(%eax)
  802e7c:	eb 08                	jmp    802e86 <insert_sorted_with_merge_freeList+0x79>
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	a3 38 51 80 00       	mov    %eax,0x805138
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e98:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9d:	40                   	inc    %eax
  802e9e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ea3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea7:	0f 84 a8 06 00 00    	je     803555 <insert_sorted_with_merge_freeList+0x748>
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	8b 50 08             	mov    0x8(%eax),%edx
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb9:	01 c2                	add    %eax,%edx
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	8b 40 08             	mov    0x8(%eax),%eax
  802ec1:	39 c2                	cmp    %eax,%edx
  802ec3:	0f 85 8c 06 00 00    	jne    803555 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	8b 50 0c             	mov    0xc(%eax),%edx
  802ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	01 c2                	add    %eax,%edx
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802edd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee1:	75 17                	jne    802efa <insert_sorted_with_merge_freeList+0xed>
  802ee3:	83 ec 04             	sub    $0x4,%esp
  802ee6:	68 c4 42 80 00       	push   $0x8042c4
  802eeb:	68 3c 01 00 00       	push   $0x13c
  802ef0:	68 1b 42 80 00       	push   $0x80421b
  802ef5:	e8 fa d4 ff ff       	call   8003f4 <_panic>
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 10                	je     802f13 <insert_sorted_with_merge_freeList+0x106>
  802f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0b:	8b 52 04             	mov    0x4(%edx),%edx
  802f0e:	89 50 04             	mov    %edx,0x4(%eax)
  802f11:	eb 0b                	jmp    802f1e <insert_sorted_with_merge_freeList+0x111>
  802f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f16:	8b 40 04             	mov    0x4(%eax),%eax
  802f19:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	85 c0                	test   %eax,%eax
  802f26:	74 0f                	je     802f37 <insert_sorted_with_merge_freeList+0x12a>
  802f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2b:	8b 40 04             	mov    0x4(%eax),%eax
  802f2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f31:	8b 12                	mov    (%edx),%edx
  802f33:	89 10                	mov    %edx,(%eax)
  802f35:	eb 0a                	jmp    802f41 <insert_sorted_with_merge_freeList+0x134>
  802f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3a:	8b 00                	mov    (%eax),%eax
  802f3c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f54:	a1 44 51 80 00       	mov    0x805144,%eax
  802f59:	48                   	dec    %eax
  802f5a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f62:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f77:	75 17                	jne    802f90 <insert_sorted_with_merge_freeList+0x183>
  802f79:	83 ec 04             	sub    $0x4,%esp
  802f7c:	68 f8 41 80 00       	push   $0x8041f8
  802f81:	68 3f 01 00 00       	push   $0x13f
  802f86:	68 1b 42 80 00       	push   $0x80421b
  802f8b:	e8 64 d4 ff ff       	call   8003f4 <_panic>
  802f90:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f99:	89 10                	mov    %edx,(%eax)
  802f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	74 0d                	je     802fb1 <insert_sorted_with_merge_freeList+0x1a4>
  802fa4:	a1 48 51 80 00       	mov    0x805148,%eax
  802fa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fac:	89 50 04             	mov    %edx,0x4(%eax)
  802faf:	eb 08                	jmp    802fb9 <insert_sorted_with_merge_freeList+0x1ac>
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcb:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd0:	40                   	inc    %eax
  802fd1:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fd6:	e9 7a 05 00 00       	jmp    803555 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	8b 50 08             	mov    0x8(%eax),%edx
  802fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe4:	8b 40 08             	mov    0x8(%eax),%eax
  802fe7:	39 c2                	cmp    %eax,%edx
  802fe9:	0f 82 14 01 00 00    	jb     803103 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff2:	8b 50 08             	mov    0x8(%eax),%edx
  802ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffb:	01 c2                	add    %eax,%edx
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	8b 40 08             	mov    0x8(%eax),%eax
  803003:	39 c2                	cmp    %eax,%edx
  803005:	0f 85 90 00 00 00    	jne    80309b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80300b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300e:	8b 50 0c             	mov    0xc(%eax),%edx
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 40 0c             	mov    0xc(%eax),%eax
  803017:	01 c2                	add    %eax,%edx
  803019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803033:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803037:	75 17                	jne    803050 <insert_sorted_with_merge_freeList+0x243>
  803039:	83 ec 04             	sub    $0x4,%esp
  80303c:	68 f8 41 80 00       	push   $0x8041f8
  803041:	68 49 01 00 00       	push   $0x149
  803046:	68 1b 42 80 00       	push   $0x80421b
  80304b:	e8 a4 d3 ff ff       	call   8003f4 <_panic>
  803050:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	89 10                	mov    %edx,(%eax)
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	74 0d                	je     803071 <insert_sorted_with_merge_freeList+0x264>
  803064:	a1 48 51 80 00       	mov    0x805148,%eax
  803069:	8b 55 08             	mov    0x8(%ebp),%edx
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
  80306f:	eb 08                	jmp    803079 <insert_sorted_with_merge_freeList+0x26c>
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	a3 48 51 80 00       	mov    %eax,0x805148
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308b:	a1 54 51 80 00       	mov    0x805154,%eax
  803090:	40                   	inc    %eax
  803091:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803096:	e9 bb 04 00 00       	jmp    803556 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80309b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309f:	75 17                	jne    8030b8 <insert_sorted_with_merge_freeList+0x2ab>
  8030a1:	83 ec 04             	sub    $0x4,%esp
  8030a4:	68 6c 42 80 00       	push   $0x80426c
  8030a9:	68 4c 01 00 00       	push   $0x14c
  8030ae:	68 1b 42 80 00       	push   $0x80421b
  8030b3:	e8 3c d3 ff ff       	call   8003f4 <_panic>
  8030b8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	89 50 04             	mov    %edx,0x4(%eax)
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	74 0c                	je     8030da <insert_sorted_with_merge_freeList+0x2cd>
  8030ce:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d6:	89 10                	mov    %edx,(%eax)
  8030d8:	eb 08                	jmp    8030e2 <insert_sorted_with_merge_freeList+0x2d5>
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f8:	40                   	inc    %eax
  8030f9:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030fe:	e9 53 04 00 00       	jmp    803556 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803103:	a1 38 51 80 00       	mov    0x805138,%eax
  803108:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310b:	e9 15 04 00 00       	jmp    803525 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	8b 50 08             	mov    0x8(%eax),%edx
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 40 08             	mov    0x8(%eax),%eax
  803124:	39 c2                	cmp    %eax,%edx
  803126:	0f 86 f1 03 00 00    	jbe    80351d <insert_sorted_with_merge_freeList+0x710>
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	8b 50 08             	mov    0x8(%eax),%edx
  803132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803135:	8b 40 08             	mov    0x8(%eax),%eax
  803138:	39 c2                	cmp    %eax,%edx
  80313a:	0f 83 dd 03 00 00    	jae    80351d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803143:	8b 50 08             	mov    0x8(%eax),%edx
  803146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803149:	8b 40 0c             	mov    0xc(%eax),%eax
  80314c:	01 c2                	add    %eax,%edx
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	8b 40 08             	mov    0x8(%eax),%eax
  803154:	39 c2                	cmp    %eax,%edx
  803156:	0f 85 b9 01 00 00    	jne    803315 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 50 08             	mov    0x8(%eax),%edx
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	8b 40 0c             	mov    0xc(%eax),%eax
  803168:	01 c2                	add    %eax,%edx
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	8b 40 08             	mov    0x8(%eax),%eax
  803170:	39 c2                	cmp    %eax,%edx
  803172:	0f 85 0d 01 00 00    	jne    803285 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	8b 50 0c             	mov    0xc(%eax),%edx
  80317e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803181:	8b 40 0c             	mov    0xc(%eax),%eax
  803184:	01 c2                	add    %eax,%edx
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80318c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803190:	75 17                	jne    8031a9 <insert_sorted_with_merge_freeList+0x39c>
  803192:	83 ec 04             	sub    $0x4,%esp
  803195:	68 c4 42 80 00       	push   $0x8042c4
  80319a:	68 5c 01 00 00       	push   $0x15c
  80319f:	68 1b 42 80 00       	push   $0x80421b
  8031a4:	e8 4b d2 ff ff       	call   8003f4 <_panic>
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 10                	je     8031c2 <insert_sorted_with_merge_freeList+0x3b5>
  8031b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ba:	8b 52 04             	mov    0x4(%edx),%edx
  8031bd:	89 50 04             	mov    %edx,0x4(%eax)
  8031c0:	eb 0b                	jmp    8031cd <insert_sorted_with_merge_freeList+0x3c0>
  8031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c5:	8b 40 04             	mov    0x4(%eax),%eax
  8031c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d0:	8b 40 04             	mov    0x4(%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 0f                	je     8031e6 <insert_sorted_with_merge_freeList+0x3d9>
  8031d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031da:	8b 40 04             	mov    0x4(%eax),%eax
  8031dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e0:	8b 12                	mov    (%edx),%edx
  8031e2:	89 10                	mov    %edx,(%eax)
  8031e4:	eb 0a                	jmp    8031f0 <insert_sorted_with_merge_freeList+0x3e3>
  8031e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e9:	8b 00                	mov    (%eax),%eax
  8031eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803203:	a1 44 51 80 00       	mov    0x805144,%eax
  803208:	48                   	dec    %eax
  803209:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803222:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803226:	75 17                	jne    80323f <insert_sorted_with_merge_freeList+0x432>
  803228:	83 ec 04             	sub    $0x4,%esp
  80322b:	68 f8 41 80 00       	push   $0x8041f8
  803230:	68 5f 01 00 00       	push   $0x15f
  803235:	68 1b 42 80 00       	push   $0x80421b
  80323a:	e8 b5 d1 ff ff       	call   8003f4 <_panic>
  80323f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	89 10                	mov    %edx,(%eax)
  80324a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 0d                	je     803260 <insert_sorted_with_merge_freeList+0x453>
  803253:	a1 48 51 80 00       	mov    0x805148,%eax
  803258:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325b:	89 50 04             	mov    %edx,0x4(%eax)
  80325e:	eb 08                	jmp    803268 <insert_sorted_with_merge_freeList+0x45b>
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	a3 48 51 80 00       	mov    %eax,0x805148
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327a:	a1 54 51 80 00       	mov    0x805154,%eax
  80327f:	40                   	inc    %eax
  803280:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803288:	8b 50 0c             	mov    0xc(%eax),%edx
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	8b 40 0c             	mov    0xc(%eax),%eax
  803291:	01 c2                	add    %eax,%edx
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b1:	75 17                	jne    8032ca <insert_sorted_with_merge_freeList+0x4bd>
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 f8 41 80 00       	push   $0x8041f8
  8032bb:	68 64 01 00 00       	push   $0x164
  8032c0:	68 1b 42 80 00       	push   $0x80421b
  8032c5:	e8 2a d1 ff ff       	call   8003f4 <_panic>
  8032ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	89 10                	mov    %edx,(%eax)
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	74 0d                	je     8032eb <insert_sorted_with_merge_freeList+0x4de>
  8032de:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e6:	89 50 04             	mov    %edx,0x4(%eax)
  8032e9:	eb 08                	jmp    8032f3 <insert_sorted_with_merge_freeList+0x4e6>
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803305:	a1 54 51 80 00       	mov    0x805154,%eax
  80330a:	40                   	inc    %eax
  80330b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803310:	e9 41 02 00 00       	jmp    803556 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	8b 50 08             	mov    0x8(%eax),%edx
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	8b 40 0c             	mov    0xc(%eax),%eax
  803321:	01 c2                	add    %eax,%edx
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	8b 40 08             	mov    0x8(%eax),%eax
  803329:	39 c2                	cmp    %eax,%edx
  80332b:	0f 85 7c 01 00 00    	jne    8034ad <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803331:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803335:	74 06                	je     80333d <insert_sorted_with_merge_freeList+0x530>
  803337:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333b:	75 17                	jne    803354 <insert_sorted_with_merge_freeList+0x547>
  80333d:	83 ec 04             	sub    $0x4,%esp
  803340:	68 34 42 80 00       	push   $0x804234
  803345:	68 69 01 00 00       	push   $0x169
  80334a:	68 1b 42 80 00       	push   $0x80421b
  80334f:	e8 a0 d0 ff ff       	call   8003f4 <_panic>
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	8b 50 04             	mov    0x4(%eax),%edx
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	89 50 04             	mov    %edx,0x4(%eax)
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803366:	89 10                	mov    %edx,(%eax)
  803368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0d                	je     80337f <insert_sorted_with_merge_freeList+0x572>
  803372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803375:	8b 40 04             	mov    0x4(%eax),%eax
  803378:	8b 55 08             	mov    0x8(%ebp),%edx
  80337b:	89 10                	mov    %edx,(%eax)
  80337d:	eb 08                	jmp    803387 <insert_sorted_with_merge_freeList+0x57a>
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	a3 38 51 80 00       	mov    %eax,0x805138
  803387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338a:	8b 55 08             	mov    0x8(%ebp),%edx
  80338d:	89 50 04             	mov    %edx,0x4(%eax)
  803390:	a1 44 51 80 00       	mov    0x805144,%eax
  803395:	40                   	inc    %eax
  803396:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	8b 50 0c             	mov    0xc(%eax),%edx
  8033a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a7:	01 c2                	add    %eax,%edx
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033b3:	75 17                	jne    8033cc <insert_sorted_with_merge_freeList+0x5bf>
  8033b5:	83 ec 04             	sub    $0x4,%esp
  8033b8:	68 c4 42 80 00       	push   $0x8042c4
  8033bd:	68 6b 01 00 00       	push   $0x16b
  8033c2:	68 1b 42 80 00       	push   $0x80421b
  8033c7:	e8 28 d0 ff ff       	call   8003f4 <_panic>
  8033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	85 c0                	test   %eax,%eax
  8033d3:	74 10                	je     8033e5 <insert_sorted_with_merge_freeList+0x5d8>
  8033d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033dd:	8b 52 04             	mov    0x4(%edx),%edx
  8033e0:	89 50 04             	mov    %edx,0x4(%eax)
  8033e3:	eb 0b                	jmp    8033f0 <insert_sorted_with_merge_freeList+0x5e3>
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	8b 40 04             	mov    0x4(%eax),%eax
  8033eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f3:	8b 40 04             	mov    0x4(%eax),%eax
  8033f6:	85 c0                	test   %eax,%eax
  8033f8:	74 0f                	je     803409 <insert_sorted_with_merge_freeList+0x5fc>
  8033fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fd:	8b 40 04             	mov    0x4(%eax),%eax
  803400:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803403:	8b 12                	mov    (%edx),%edx
  803405:	89 10                	mov    %edx,(%eax)
  803407:	eb 0a                	jmp    803413 <insert_sorted_with_merge_freeList+0x606>
  803409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340c:	8b 00                	mov    (%eax),%eax
  80340e:	a3 38 51 80 00       	mov    %eax,0x805138
  803413:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803416:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803426:	a1 44 51 80 00       	mov    0x805144,%eax
  80342b:	48                   	dec    %eax
  80342c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803434:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80343b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803445:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803449:	75 17                	jne    803462 <insert_sorted_with_merge_freeList+0x655>
  80344b:	83 ec 04             	sub    $0x4,%esp
  80344e:	68 f8 41 80 00       	push   $0x8041f8
  803453:	68 6e 01 00 00       	push   $0x16e
  803458:	68 1b 42 80 00       	push   $0x80421b
  80345d:	e8 92 cf ff ff       	call   8003f4 <_panic>
  803462:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346b:	89 10                	mov    %edx,(%eax)
  80346d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	85 c0                	test   %eax,%eax
  803474:	74 0d                	je     803483 <insert_sorted_with_merge_freeList+0x676>
  803476:	a1 48 51 80 00       	mov    0x805148,%eax
  80347b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80347e:	89 50 04             	mov    %edx,0x4(%eax)
  803481:	eb 08                	jmp    80348b <insert_sorted_with_merge_freeList+0x67e>
  803483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803486:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80348b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348e:	a3 48 51 80 00       	mov    %eax,0x805148
  803493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803496:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349d:	a1 54 51 80 00       	mov    0x805154,%eax
  8034a2:	40                   	inc    %eax
  8034a3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034a8:	e9 a9 00 00 00       	jmp    803556 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b1:	74 06                	je     8034b9 <insert_sorted_with_merge_freeList+0x6ac>
  8034b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b7:	75 17                	jne    8034d0 <insert_sorted_with_merge_freeList+0x6c3>
  8034b9:	83 ec 04             	sub    $0x4,%esp
  8034bc:	68 90 42 80 00       	push   $0x804290
  8034c1:	68 73 01 00 00       	push   $0x173
  8034c6:	68 1b 42 80 00       	push   $0x80421b
  8034cb:	e8 24 cf ff ff       	call   8003f4 <_panic>
  8034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d3:	8b 10                	mov    (%eax),%edx
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	89 10                	mov    %edx,(%eax)
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	74 0b                	je     8034ee <insert_sorted_with_merge_freeList+0x6e1>
  8034e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e6:	8b 00                	mov    (%eax),%eax
  8034e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034eb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f4:	89 10                	mov    %edx,(%eax)
  8034f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034fc:	89 50 04             	mov    %edx,0x4(%eax)
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	75 08                	jne    803510 <insert_sorted_with_merge_freeList+0x703>
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803510:	a1 44 51 80 00       	mov    0x805144,%eax
  803515:	40                   	inc    %eax
  803516:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80351b:	eb 39                	jmp    803556 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80351d:	a1 40 51 80 00       	mov    0x805140,%eax
  803522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803529:	74 07                	je     803532 <insert_sorted_with_merge_freeList+0x725>
  80352b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352e:	8b 00                	mov    (%eax),%eax
  803530:	eb 05                	jmp    803537 <insert_sorted_with_merge_freeList+0x72a>
  803532:	b8 00 00 00 00       	mov    $0x0,%eax
  803537:	a3 40 51 80 00       	mov    %eax,0x805140
  80353c:	a1 40 51 80 00       	mov    0x805140,%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	0f 85 c7 fb ff ff    	jne    803110 <insert_sorted_with_merge_freeList+0x303>
  803549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354d:	0f 85 bd fb ff ff    	jne    803110 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803553:	eb 01                	jmp    803556 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803555:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803556:	90                   	nop
  803557:	c9                   	leave  
  803558:	c3                   	ret    
  803559:	66 90                	xchg   %ax,%ax
  80355b:	90                   	nop

0080355c <__udivdi3>:
  80355c:	55                   	push   %ebp
  80355d:	57                   	push   %edi
  80355e:	56                   	push   %esi
  80355f:	53                   	push   %ebx
  803560:	83 ec 1c             	sub    $0x1c,%esp
  803563:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803567:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80356b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80356f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803573:	89 ca                	mov    %ecx,%edx
  803575:	89 f8                	mov    %edi,%eax
  803577:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80357b:	85 f6                	test   %esi,%esi
  80357d:	75 2d                	jne    8035ac <__udivdi3+0x50>
  80357f:	39 cf                	cmp    %ecx,%edi
  803581:	77 65                	ja     8035e8 <__udivdi3+0x8c>
  803583:	89 fd                	mov    %edi,%ebp
  803585:	85 ff                	test   %edi,%edi
  803587:	75 0b                	jne    803594 <__udivdi3+0x38>
  803589:	b8 01 00 00 00       	mov    $0x1,%eax
  80358e:	31 d2                	xor    %edx,%edx
  803590:	f7 f7                	div    %edi
  803592:	89 c5                	mov    %eax,%ebp
  803594:	31 d2                	xor    %edx,%edx
  803596:	89 c8                	mov    %ecx,%eax
  803598:	f7 f5                	div    %ebp
  80359a:	89 c1                	mov    %eax,%ecx
  80359c:	89 d8                	mov    %ebx,%eax
  80359e:	f7 f5                	div    %ebp
  8035a0:	89 cf                	mov    %ecx,%edi
  8035a2:	89 fa                	mov    %edi,%edx
  8035a4:	83 c4 1c             	add    $0x1c,%esp
  8035a7:	5b                   	pop    %ebx
  8035a8:	5e                   	pop    %esi
  8035a9:	5f                   	pop    %edi
  8035aa:	5d                   	pop    %ebp
  8035ab:	c3                   	ret    
  8035ac:	39 ce                	cmp    %ecx,%esi
  8035ae:	77 28                	ja     8035d8 <__udivdi3+0x7c>
  8035b0:	0f bd fe             	bsr    %esi,%edi
  8035b3:	83 f7 1f             	xor    $0x1f,%edi
  8035b6:	75 40                	jne    8035f8 <__udivdi3+0x9c>
  8035b8:	39 ce                	cmp    %ecx,%esi
  8035ba:	72 0a                	jb     8035c6 <__udivdi3+0x6a>
  8035bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035c0:	0f 87 9e 00 00 00    	ja     803664 <__udivdi3+0x108>
  8035c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035cb:	89 fa                	mov    %edi,%edx
  8035cd:	83 c4 1c             	add    $0x1c,%esp
  8035d0:	5b                   	pop    %ebx
  8035d1:	5e                   	pop    %esi
  8035d2:	5f                   	pop    %edi
  8035d3:	5d                   	pop    %ebp
  8035d4:	c3                   	ret    
  8035d5:	8d 76 00             	lea    0x0(%esi),%esi
  8035d8:	31 ff                	xor    %edi,%edi
  8035da:	31 c0                	xor    %eax,%eax
  8035dc:	89 fa                	mov    %edi,%edx
  8035de:	83 c4 1c             	add    $0x1c,%esp
  8035e1:	5b                   	pop    %ebx
  8035e2:	5e                   	pop    %esi
  8035e3:	5f                   	pop    %edi
  8035e4:	5d                   	pop    %ebp
  8035e5:	c3                   	ret    
  8035e6:	66 90                	xchg   %ax,%ax
  8035e8:	89 d8                	mov    %ebx,%eax
  8035ea:	f7 f7                	div    %edi
  8035ec:	31 ff                	xor    %edi,%edi
  8035ee:	89 fa                	mov    %edi,%edx
  8035f0:	83 c4 1c             	add    $0x1c,%esp
  8035f3:	5b                   	pop    %ebx
  8035f4:	5e                   	pop    %esi
  8035f5:	5f                   	pop    %edi
  8035f6:	5d                   	pop    %ebp
  8035f7:	c3                   	ret    
  8035f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035fd:	89 eb                	mov    %ebp,%ebx
  8035ff:	29 fb                	sub    %edi,%ebx
  803601:	89 f9                	mov    %edi,%ecx
  803603:	d3 e6                	shl    %cl,%esi
  803605:	89 c5                	mov    %eax,%ebp
  803607:	88 d9                	mov    %bl,%cl
  803609:	d3 ed                	shr    %cl,%ebp
  80360b:	89 e9                	mov    %ebp,%ecx
  80360d:	09 f1                	or     %esi,%ecx
  80360f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803613:	89 f9                	mov    %edi,%ecx
  803615:	d3 e0                	shl    %cl,%eax
  803617:	89 c5                	mov    %eax,%ebp
  803619:	89 d6                	mov    %edx,%esi
  80361b:	88 d9                	mov    %bl,%cl
  80361d:	d3 ee                	shr    %cl,%esi
  80361f:	89 f9                	mov    %edi,%ecx
  803621:	d3 e2                	shl    %cl,%edx
  803623:	8b 44 24 08          	mov    0x8(%esp),%eax
  803627:	88 d9                	mov    %bl,%cl
  803629:	d3 e8                	shr    %cl,%eax
  80362b:	09 c2                	or     %eax,%edx
  80362d:	89 d0                	mov    %edx,%eax
  80362f:	89 f2                	mov    %esi,%edx
  803631:	f7 74 24 0c          	divl   0xc(%esp)
  803635:	89 d6                	mov    %edx,%esi
  803637:	89 c3                	mov    %eax,%ebx
  803639:	f7 e5                	mul    %ebp
  80363b:	39 d6                	cmp    %edx,%esi
  80363d:	72 19                	jb     803658 <__udivdi3+0xfc>
  80363f:	74 0b                	je     80364c <__udivdi3+0xf0>
  803641:	89 d8                	mov    %ebx,%eax
  803643:	31 ff                	xor    %edi,%edi
  803645:	e9 58 ff ff ff       	jmp    8035a2 <__udivdi3+0x46>
  80364a:	66 90                	xchg   %ax,%ax
  80364c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803650:	89 f9                	mov    %edi,%ecx
  803652:	d3 e2                	shl    %cl,%edx
  803654:	39 c2                	cmp    %eax,%edx
  803656:	73 e9                	jae    803641 <__udivdi3+0xe5>
  803658:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80365b:	31 ff                	xor    %edi,%edi
  80365d:	e9 40 ff ff ff       	jmp    8035a2 <__udivdi3+0x46>
  803662:	66 90                	xchg   %ax,%ax
  803664:	31 c0                	xor    %eax,%eax
  803666:	e9 37 ff ff ff       	jmp    8035a2 <__udivdi3+0x46>
  80366b:	90                   	nop

0080366c <__umoddi3>:
  80366c:	55                   	push   %ebp
  80366d:	57                   	push   %edi
  80366e:	56                   	push   %esi
  80366f:	53                   	push   %ebx
  803670:	83 ec 1c             	sub    $0x1c,%esp
  803673:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803677:	8b 74 24 34          	mov    0x34(%esp),%esi
  80367b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80367f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803683:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803687:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80368b:	89 f3                	mov    %esi,%ebx
  80368d:	89 fa                	mov    %edi,%edx
  80368f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803693:	89 34 24             	mov    %esi,(%esp)
  803696:	85 c0                	test   %eax,%eax
  803698:	75 1a                	jne    8036b4 <__umoddi3+0x48>
  80369a:	39 f7                	cmp    %esi,%edi
  80369c:	0f 86 a2 00 00 00    	jbe    803744 <__umoddi3+0xd8>
  8036a2:	89 c8                	mov    %ecx,%eax
  8036a4:	89 f2                	mov    %esi,%edx
  8036a6:	f7 f7                	div    %edi
  8036a8:	89 d0                	mov    %edx,%eax
  8036aa:	31 d2                	xor    %edx,%edx
  8036ac:	83 c4 1c             	add    $0x1c,%esp
  8036af:	5b                   	pop    %ebx
  8036b0:	5e                   	pop    %esi
  8036b1:	5f                   	pop    %edi
  8036b2:	5d                   	pop    %ebp
  8036b3:	c3                   	ret    
  8036b4:	39 f0                	cmp    %esi,%eax
  8036b6:	0f 87 ac 00 00 00    	ja     803768 <__umoddi3+0xfc>
  8036bc:	0f bd e8             	bsr    %eax,%ebp
  8036bf:	83 f5 1f             	xor    $0x1f,%ebp
  8036c2:	0f 84 ac 00 00 00    	je     803774 <__umoddi3+0x108>
  8036c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8036cd:	29 ef                	sub    %ebp,%edi
  8036cf:	89 fe                	mov    %edi,%esi
  8036d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036d5:	89 e9                	mov    %ebp,%ecx
  8036d7:	d3 e0                	shl    %cl,%eax
  8036d9:	89 d7                	mov    %edx,%edi
  8036db:	89 f1                	mov    %esi,%ecx
  8036dd:	d3 ef                	shr    %cl,%edi
  8036df:	09 c7                	or     %eax,%edi
  8036e1:	89 e9                	mov    %ebp,%ecx
  8036e3:	d3 e2                	shl    %cl,%edx
  8036e5:	89 14 24             	mov    %edx,(%esp)
  8036e8:	89 d8                	mov    %ebx,%eax
  8036ea:	d3 e0                	shl    %cl,%eax
  8036ec:	89 c2                	mov    %eax,%edx
  8036ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f2:	d3 e0                	shl    %cl,%eax
  8036f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036fc:	89 f1                	mov    %esi,%ecx
  8036fe:	d3 e8                	shr    %cl,%eax
  803700:	09 d0                	or     %edx,%eax
  803702:	d3 eb                	shr    %cl,%ebx
  803704:	89 da                	mov    %ebx,%edx
  803706:	f7 f7                	div    %edi
  803708:	89 d3                	mov    %edx,%ebx
  80370a:	f7 24 24             	mull   (%esp)
  80370d:	89 c6                	mov    %eax,%esi
  80370f:	89 d1                	mov    %edx,%ecx
  803711:	39 d3                	cmp    %edx,%ebx
  803713:	0f 82 87 00 00 00    	jb     8037a0 <__umoddi3+0x134>
  803719:	0f 84 91 00 00 00    	je     8037b0 <__umoddi3+0x144>
  80371f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803723:	29 f2                	sub    %esi,%edx
  803725:	19 cb                	sbb    %ecx,%ebx
  803727:	89 d8                	mov    %ebx,%eax
  803729:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80372d:	d3 e0                	shl    %cl,%eax
  80372f:	89 e9                	mov    %ebp,%ecx
  803731:	d3 ea                	shr    %cl,%edx
  803733:	09 d0                	or     %edx,%eax
  803735:	89 e9                	mov    %ebp,%ecx
  803737:	d3 eb                	shr    %cl,%ebx
  803739:	89 da                	mov    %ebx,%edx
  80373b:	83 c4 1c             	add    $0x1c,%esp
  80373e:	5b                   	pop    %ebx
  80373f:	5e                   	pop    %esi
  803740:	5f                   	pop    %edi
  803741:	5d                   	pop    %ebp
  803742:	c3                   	ret    
  803743:	90                   	nop
  803744:	89 fd                	mov    %edi,%ebp
  803746:	85 ff                	test   %edi,%edi
  803748:	75 0b                	jne    803755 <__umoddi3+0xe9>
  80374a:	b8 01 00 00 00       	mov    $0x1,%eax
  80374f:	31 d2                	xor    %edx,%edx
  803751:	f7 f7                	div    %edi
  803753:	89 c5                	mov    %eax,%ebp
  803755:	89 f0                	mov    %esi,%eax
  803757:	31 d2                	xor    %edx,%edx
  803759:	f7 f5                	div    %ebp
  80375b:	89 c8                	mov    %ecx,%eax
  80375d:	f7 f5                	div    %ebp
  80375f:	89 d0                	mov    %edx,%eax
  803761:	e9 44 ff ff ff       	jmp    8036aa <__umoddi3+0x3e>
  803766:	66 90                	xchg   %ax,%ax
  803768:	89 c8                	mov    %ecx,%eax
  80376a:	89 f2                	mov    %esi,%edx
  80376c:	83 c4 1c             	add    $0x1c,%esp
  80376f:	5b                   	pop    %ebx
  803770:	5e                   	pop    %esi
  803771:	5f                   	pop    %edi
  803772:	5d                   	pop    %ebp
  803773:	c3                   	ret    
  803774:	3b 04 24             	cmp    (%esp),%eax
  803777:	72 06                	jb     80377f <__umoddi3+0x113>
  803779:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80377d:	77 0f                	ja     80378e <__umoddi3+0x122>
  80377f:	89 f2                	mov    %esi,%edx
  803781:	29 f9                	sub    %edi,%ecx
  803783:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803787:	89 14 24             	mov    %edx,(%esp)
  80378a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80378e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803792:	8b 14 24             	mov    (%esp),%edx
  803795:	83 c4 1c             	add    $0x1c,%esp
  803798:	5b                   	pop    %ebx
  803799:	5e                   	pop    %esi
  80379a:	5f                   	pop    %edi
  80379b:	5d                   	pop    %ebp
  80379c:	c3                   	ret    
  80379d:	8d 76 00             	lea    0x0(%esi),%esi
  8037a0:	2b 04 24             	sub    (%esp),%eax
  8037a3:	19 fa                	sbb    %edi,%edx
  8037a5:	89 d1                	mov    %edx,%ecx
  8037a7:	89 c6                	mov    %eax,%esi
  8037a9:	e9 71 ff ff ff       	jmp    80371f <__umoddi3+0xb3>
  8037ae:	66 90                	xchg   %ax,%ax
  8037b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037b4:	72 ea                	jb     8037a0 <__umoddi3+0x134>
  8037b6:	89 d9                	mov    %ebx,%ecx
  8037b8:	e9 62 ff ff ff       	jmp    80371f <__umoddi3+0xb3>
