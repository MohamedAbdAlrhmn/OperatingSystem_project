
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
  80004d:	e8 8b 18 00 00       	call   8018dd <sys_calculate_free_frames>
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
  80007b:	e8 5d 18 00 00       	call   8018dd <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 6e 18 00 00       	call   8018f6 <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 20 37 80 00       	push   $0x803720
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
  8001d9:	68 40 37 80 00       	push   $0x803740
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 6e 37 80 00       	push   $0x80376e
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
  800200:	e8 d8 16 00 00       	call   8018dd <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 e9 16 00 00       	call   8018f6 <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 e1 16 00 00       	call   8018f6 <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 c1 16 00 00       	call   8018dd <sys_calculate_free_frames>
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
  800235:	68 84 37 80 00       	push   $0x803784
  80023a:	6a 53                	push   $0x53
  80023c:	68 6e 37 80 00       	push   $0x80376e
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 d8 37 80 00       	push   $0x8037d8
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 34 38 80 00       	push   $0x803834
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
  8002a7:	68 18 39 80 00       	push   $0x803918
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 6e 37 80 00       	push   $0x80376e
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
  8002be:	e8 fa 18 00 00       	call   801bbd <sys_getenvindex>
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
  800329:	e8 9c 16 00 00       	call   8019ca <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 38 3a 80 00       	push   $0x803a38
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
  800359:	68 60 3a 80 00       	push   $0x803a60
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
  80038a:	68 88 3a 80 00       	push   $0x803a88
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 50 80 00       	mov    0x805020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 e0 3a 80 00       	push   $0x803ae0
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 38 3a 80 00       	push   $0x803a38
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 1c 16 00 00       	call   8019e4 <sys_enable_interrupt>

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
  8003db:	e8 a9 17 00 00       	call   801b89 <sys_destroy_env>
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
  8003ec:	e8 fe 17 00 00       	call   801bef <sys_exit_env>
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
  800415:	68 f4 3a 80 00       	push   $0x803af4
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 50 80 00       	mov    0x805000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 f9 3a 80 00       	push   $0x803af9
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
  800452:	68 15 3b 80 00       	push   $0x803b15
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
  80047e:	68 18 3b 80 00       	push   $0x803b18
  800483:	6a 26                	push   $0x26
  800485:	68 64 3b 80 00       	push   $0x803b64
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
  800550:	68 70 3b 80 00       	push   $0x803b70
  800555:	6a 3a                	push   $0x3a
  800557:	68 64 3b 80 00       	push   $0x803b64
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
  8005c0:	68 c4 3b 80 00       	push   $0x803bc4
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 64 3b 80 00       	push   $0x803b64
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
  80061a:	e8 fd 11 00 00       	call   80181c <sys_cputs>
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
  800691:	e8 86 11 00 00       	call   80181c <sys_cputs>
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
  8006db:	e8 ea 12 00 00       	call   8019ca <sys_disable_interrupt>
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
  8006fb:	e8 e4 12 00 00       	call   8019e4 <sys_enable_interrupt>
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
  800745:	e8 56 2d 00 00       	call   8034a0 <__udivdi3>
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
  800795:	e8 16 2e 00 00       	call   8035b0 <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 34 3e 80 00       	add    $0x803e34,%eax
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
  8008f0:	8b 04 85 58 3e 80 00 	mov    0x803e58(,%eax,4),%eax
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
  8009d1:	8b 34 9d a0 3c 80 00 	mov    0x803ca0(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 45 3e 80 00       	push   $0x803e45
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
  8009f6:	68 4e 3e 80 00       	push   $0x803e4e
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
  800a23:	be 51 3e 80 00       	mov    $0x803e51,%esi
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
  801449:	68 b0 3f 80 00       	push   $0x803fb0
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
  801519:	e8 42 04 00 00       	call   801960 <sys_allocate_chunk>
  80151e:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801521:	a1 20 51 80 00       	mov    0x805120,%eax
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	50                   	push   %eax
  80152a:	e8 b7 0a 00 00       	call   801fe6 <initialize_MemBlocksList>
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
  801557:	68 d5 3f 80 00       	push   $0x803fd5
  80155c:	6a 33                	push   $0x33
  80155e:	68 f3 3f 80 00       	push   $0x803ff3
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
  8015d6:	68 00 40 80 00       	push   $0x804000
  8015db:	6a 34                	push   $0x34
  8015dd:	68 f3 3f 80 00       	push   $0x803ff3
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
  80164b:	68 24 40 80 00       	push   $0x804024
  801650:	6a 46                	push   $0x46
  801652:	68 f3 3f 80 00       	push   $0x803ff3
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
  801667:	68 4c 40 80 00       	push   $0x80404c
  80166c:	6a 61                	push   $0x61
  80166e:	68 f3 3f 80 00       	push   $0x803ff3
  801673:	e8 7c ed ff ff       	call   8003f4 <_panic>

00801678 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 38             	sub    $0x38,%esp
  80167e:	8b 45 10             	mov    0x10(%ebp),%eax
  801681:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801684:	e8 a9 fd ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  801689:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80168d:	75 0a                	jne    801699 <smalloc+0x21>
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
  801694:	e9 9e 00 00 00       	jmp    801737 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801699:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a6:	01 d0                	add    %edx,%eax
  8016a8:	48                   	dec    %eax
  8016a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016af:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b4:	f7 75 f0             	divl   -0x10(%ebp)
  8016b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ba:	29 d0                	sub    %edx,%eax
  8016bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016bf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016c6:	e8 63 06 00 00       	call   801d2e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	74 11                	je     8016e0 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016cf:	83 ec 0c             	sub    $0xc,%esp
  8016d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d5:	e8 ce 0c 00 00       	call   8023a8 <alloc_block_FF>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e4:	74 4c                	je     801732 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e9:	8b 40 08             	mov    0x8(%eax),%eax
  8016ec:	89 c2                	mov    %eax,%edx
  8016ee:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016f2:	52                   	push   %edx
  8016f3:	50                   	push   %eax
  8016f4:	ff 75 0c             	pushl  0xc(%ebp)
  8016f7:	ff 75 08             	pushl  0x8(%ebp)
  8016fa:	e8 b4 03 00 00       	call   801ab3 <sys_createSharedObject>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801705:	83 ec 08             	sub    $0x8,%esp
  801708:	ff 75 e0             	pushl  -0x20(%ebp)
  80170b:	68 6f 40 80 00       	push   $0x80406f
  801710:	e8 93 ef ff ff       	call   8006a8 <cprintf>
  801715:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801718:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80171c:	74 14                	je     801732 <smalloc+0xba>
  80171e:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801722:	74 0e                	je     801732 <smalloc+0xba>
  801724:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801728:	74 08                	je     801732 <smalloc+0xba>
			return (void*) mem_block->sva;
  80172a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172d:	8b 40 08             	mov    0x8(%eax),%eax
  801730:	eb 05                	jmp    801737 <smalloc+0xbf>
	}
	return NULL;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80173f:	e8 ee fc ff ff       	call   801432 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	68 84 40 80 00       	push   $0x804084
  80174c:	68 ab 00 00 00       	push   $0xab
  801751:	68 f3 3f 80 00       	push   $0x803ff3
  801756:	e8 99 ec ff ff       	call   8003f4 <_panic>

0080175b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801761:	e8 cc fc ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	68 a8 40 80 00       	push   $0x8040a8
  80176e:	68 ef 00 00 00       	push   $0xef
  801773:	68 f3 3f 80 00       	push   $0x803ff3
  801778:	e8 77 ec ff ff       	call   8003f4 <_panic>

0080177d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	68 d0 40 80 00       	push   $0x8040d0
  80178b:	68 03 01 00 00       	push   $0x103
  801790:	68 f3 3f 80 00       	push   $0x803ff3
  801795:	e8 5a ec ff ff       	call   8003f4 <_panic>

0080179a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	68 f4 40 80 00       	push   $0x8040f4
  8017a8:	68 0e 01 00 00       	push   $0x10e
  8017ad:	68 f3 3f 80 00       	push   $0x803ff3
  8017b2:	e8 3d ec ff ff       	call   8003f4 <_panic>

008017b7 <shrink>:

}
void shrink(uint32 newSize)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 f4 40 80 00       	push   $0x8040f4
  8017c5:	68 13 01 00 00       	push   $0x113
  8017ca:	68 f3 3f 80 00       	push   $0x803ff3
  8017cf:	e8 20 ec ff ff       	call   8003f4 <_panic>

008017d4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 f4 40 80 00       	push   $0x8040f4
  8017e2:	68 18 01 00 00       	push   $0x118
  8017e7:	68 f3 3f 80 00       	push   $0x803ff3
  8017ec:	e8 03 ec ff ff       	call   8003f4 <_panic>

008017f1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	57                   	push   %edi
  8017f5:	56                   	push   %esi
  8017f6:	53                   	push   %ebx
  8017f7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801800:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801803:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801806:	8b 7d 18             	mov    0x18(%ebp),%edi
  801809:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180c:	cd 30                	int    $0x30
  80180e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801811:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 04             	sub    $0x4,%esp
  801822:	8b 45 10             	mov    0x10(%ebp),%eax
  801825:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801828:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	52                   	push   %edx
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	50                   	push   %eax
  801838:	6a 00                	push   $0x0
  80183a:	e8 b2 ff ff ff       	call   8017f1 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	90                   	nop
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_cgetc>:

int
sys_cgetc(void)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 01                	push   $0x1
  801854:	e8 98 ff ff ff       	call   8017f1 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801861:	8b 55 0c             	mov    0xc(%ebp),%edx
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	52                   	push   %edx
  80186e:	50                   	push   %eax
  80186f:	6a 05                	push   $0x5
  801871:	e8 7b ff ff ff       	call   8017f1 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801880:	8b 75 18             	mov    0x18(%ebp),%esi
  801883:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801886:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	51                   	push   %ecx
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 06                	push   $0x6
  801896:	e8 56 ff ff ff       	call   8017f1 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a1:	5b                   	pop    %ebx
  8018a2:	5e                   	pop    %esi
  8018a3:	5d                   	pop    %ebp
  8018a4:	c3                   	ret    

008018a5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	6a 07                	push   $0x7
  8018b8:	e8 34 ff ff ff       	call   8017f1 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	6a 08                	push   $0x8
  8018d3:	e8 19 ff ff ff       	call   8017f1 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 09                	push   $0x9
  8018ec:	e8 00 ff ff ff       	call   8017f1 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 0a                	push   $0xa
  801905:	e8 e7 fe ff ff       	call   8017f1 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 0b                	push   $0xb
  80191e:	e8 ce fe ff ff       	call   8017f1 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	ff 75 08             	pushl  0x8(%ebp)
  801937:	6a 0f                	push   $0xf
  801939:	e8 b3 fe ff ff       	call   8017f1 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
	return;
  801941:	90                   	nop
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	ff 75 08             	pushl  0x8(%ebp)
  801953:	6a 10                	push   $0x10
  801955:	e8 97 fe ff ff       	call   8017f1 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
	return ;
  80195d:	90                   	nop
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	ff 75 10             	pushl  0x10(%ebp)
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	6a 11                	push   $0x11
  801972:	e8 7a fe ff ff       	call   8017f1 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
	return ;
  80197a:	90                   	nop
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 0c                	push   $0xc
  80198c:	e8 60 fe ff ff       	call   8017f1 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	ff 75 08             	pushl  0x8(%ebp)
  8019a4:	6a 0d                	push   $0xd
  8019a6:	e8 46 fe ff ff       	call   8017f1 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 0e                	push   $0xe
  8019bf:	e8 2d fe ff ff       	call   8017f1 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	90                   	nop
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 13                	push   $0x13
  8019d9:	e8 13 fe ff ff       	call   8017f1 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 14                	push   $0x14
  8019f3:	e8 f9 fd ff ff       	call   8017f1 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_cputc>:


void
sys_cputc(const char c)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 04             	sub    $0x4,%esp
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a0a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	50                   	push   %eax
  801a17:	6a 15                	push   $0x15
  801a19:	e8 d3 fd ff ff       	call   8017f1 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	90                   	nop
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 16                	push   $0x16
  801a33:	e8 b9 fd ff ff       	call   8017f1 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	90                   	nop
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	50                   	push   %eax
  801a4e:	6a 17                	push   $0x17
  801a50:	e8 9c fd ff ff       	call   8017f1 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	6a 1a                	push   $0x1a
  801a6d:	e8 7f fd ff ff       	call   8017f1 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	52                   	push   %edx
  801a87:	50                   	push   %eax
  801a88:	6a 18                	push   $0x18
  801a8a:	e8 62 fd ff ff       	call   8017f1 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	52                   	push   %edx
  801aa5:	50                   	push   %eax
  801aa6:	6a 19                	push   $0x19
  801aa8:	e8 44 fd ff ff       	call   8017f1 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	90                   	nop
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	8b 45 10             	mov    0x10(%ebp),%eax
  801abc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801abf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	51                   	push   %ecx
  801acc:	52                   	push   %edx
  801acd:	ff 75 0c             	pushl  0xc(%ebp)
  801ad0:	50                   	push   %eax
  801ad1:	6a 1b                	push   $0x1b
  801ad3:	e8 19 fd ff ff       	call   8017f1 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	52                   	push   %edx
  801aed:	50                   	push   %eax
  801aee:	6a 1c                	push   $0x1c
  801af0:	e8 fc fc ff ff       	call   8017f1 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801afd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	51                   	push   %ecx
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	6a 1d                	push   $0x1d
  801b0f:	e8 dd fc ff ff       	call   8017f1 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	52                   	push   %edx
  801b29:	50                   	push   %eax
  801b2a:	6a 1e                	push   $0x1e
  801b2c:	e8 c0 fc ff ff       	call   8017f1 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 1f                	push   $0x1f
  801b45:	e8 a7 fc ff ff       	call   8017f1 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	ff 75 14             	pushl  0x14(%ebp)
  801b5a:	ff 75 10             	pushl  0x10(%ebp)
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	50                   	push   %eax
  801b61:	6a 20                	push   $0x20
  801b63:	e8 89 fc ff ff       	call   8017f1 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	50                   	push   %eax
  801b7c:	6a 21                	push   $0x21
  801b7e:	e8 6e fc ff ff       	call   8017f1 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	90                   	nop
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	50                   	push   %eax
  801b98:	6a 22                	push   $0x22
  801b9a:	e8 52 fc ff ff       	call   8017f1 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 02                	push   $0x2
  801bb3:	e8 39 fc ff ff       	call   8017f1 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 03                	push   $0x3
  801bcc:	e8 20 fc ff ff       	call   8017f1 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 04                	push   $0x4
  801be5:	e8 07 fc ff ff       	call   8017f1 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_exit_env>:


void sys_exit_env(void)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 23                	push   $0x23
  801bfe:	e8 ee fb ff ff       	call   8017f1 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	90                   	nop
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c0f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c12:	8d 50 04             	lea    0x4(%eax),%edx
  801c15:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	52                   	push   %edx
  801c1f:	50                   	push   %eax
  801c20:	6a 24                	push   $0x24
  801c22:	e8 ca fb ff ff       	call   8017f1 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c33:	89 01                	mov    %eax,(%ecx)
  801c35:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	c9                   	leave  
  801c3c:	c2 04 00             	ret    $0x4

00801c3f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 10             	pushl  0x10(%ebp)
  801c49:	ff 75 0c             	pushl  0xc(%ebp)
  801c4c:	ff 75 08             	pushl  0x8(%ebp)
  801c4f:	6a 12                	push   $0x12
  801c51:	e8 9b fb ff ff       	call   8017f1 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
	return ;
  801c59:	90                   	nop
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 25                	push   $0x25
  801c6b:	e8 81 fb ff ff       	call   8017f1 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 04             	sub    $0x4,%esp
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c81:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	50                   	push   %eax
  801c8e:	6a 26                	push   $0x26
  801c90:	e8 5c fb ff ff       	call   8017f1 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
	return ;
  801c98:	90                   	nop
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <rsttst>:
void rsttst()
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 28                	push   $0x28
  801caa:	e8 42 fb ff ff       	call   8017f1 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb2:	90                   	nop
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc1:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc8:	52                   	push   %edx
  801cc9:	50                   	push   %eax
  801cca:	ff 75 10             	pushl  0x10(%ebp)
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	ff 75 08             	pushl  0x8(%ebp)
  801cd3:	6a 27                	push   $0x27
  801cd5:	e8 17 fb ff ff       	call   8017f1 <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdd:	90                   	nop
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <chktst>:
void chktst(uint32 n)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	ff 75 08             	pushl  0x8(%ebp)
  801cee:	6a 29                	push   $0x29
  801cf0:	e8 fc fa ff ff       	call   8017f1 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf8:	90                   	nop
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <inctst>:

void inctst()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 2a                	push   $0x2a
  801d0a:	e8 e2 fa ff ff       	call   8017f1 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d12:	90                   	nop
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <gettst>:
uint32 gettst()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 2b                	push   $0x2b
  801d24:	e8 c8 fa ff ff       	call   8017f1 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 2c                	push   $0x2c
  801d40:	e8 ac fa ff ff       	call   8017f1 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
  801d48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d4b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d4f:	75 07                	jne    801d58 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d51:	b8 01 00 00 00       	mov    $0x1,%eax
  801d56:	eb 05                	jmp    801d5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 2c                	push   $0x2c
  801d71:	e8 7b fa ff ff       	call   8017f1 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
  801d79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d7c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d80:	75 07                	jne    801d89 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d82:	b8 01 00 00 00       	mov    $0x1,%eax
  801d87:	eb 05                	jmp    801d8e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 2c                	push   $0x2c
  801da2:	e8 4a fa ff ff       	call   8017f1 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
  801daa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dad:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db1:	75 07                	jne    801dba <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db3:	b8 01 00 00 00       	mov    $0x1,%eax
  801db8:	eb 05                	jmp    801dbf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 2c                	push   $0x2c
  801dd3:	e8 19 fa ff ff       	call   8017f1 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
  801ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dde:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de2:	75 07                	jne    801deb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de4:	b8 01 00 00 00       	mov    $0x1,%eax
  801de9:	eb 05                	jmp    801df0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	6a 2d                	push   $0x2d
  801e02:	e8 ea f9 ff ff       	call   8017f1 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0a:	90                   	nop
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	6a 00                	push   $0x0
  801e1f:	53                   	push   %ebx
  801e20:	51                   	push   %ecx
  801e21:	52                   	push   %edx
  801e22:	50                   	push   %eax
  801e23:	6a 2e                	push   $0x2e
  801e25:	e8 c7 f9 ff ff       	call   8017f1 <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	6a 2f                	push   $0x2f
  801e45:	e8 a7 f9 ff ff       	call   8017f1 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e55:	83 ec 0c             	sub    $0xc,%esp
  801e58:	68 04 41 80 00       	push   $0x804104
  801e5d:	e8 46 e8 ff ff       	call   8006a8 <cprintf>
  801e62:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	68 30 41 80 00       	push   $0x804130
  801e74:	e8 2f e8 ff ff       	call   8006a8 <cprintf>
  801e79:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e7c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e80:	a1 38 51 80 00       	mov    0x805138,%eax
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e88:	eb 56                	jmp    801ee0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8e:	74 1c                	je     801eac <print_mem_block_lists+0x5d>
  801e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e93:	8b 50 08             	mov    0x8(%eax),%edx
  801e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e99:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea2:	01 c8                	add    %ecx,%eax
  801ea4:	39 c2                	cmp    %eax,%edx
  801ea6:	73 04                	jae    801eac <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ea8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	8b 50 08             	mov    0x8(%eax),%edx
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb8:	01 c2                	add    %eax,%edx
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	8b 40 08             	mov    0x8(%eax),%eax
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	52                   	push   %edx
  801ec4:	50                   	push   %eax
  801ec5:	68 45 41 80 00       	push   $0x804145
  801eca:	e8 d9 e7 ff ff       	call   8006a8 <cprintf>
  801ecf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed8:	a1 40 51 80 00       	mov    0x805140,%eax
  801edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee4:	74 07                	je     801eed <print_mem_block_lists+0x9e>
  801ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee9:	8b 00                	mov    (%eax),%eax
  801eeb:	eb 05                	jmp    801ef2 <print_mem_block_lists+0xa3>
  801eed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef2:	a3 40 51 80 00       	mov    %eax,0x805140
  801ef7:	a1 40 51 80 00       	mov    0x805140,%eax
  801efc:	85 c0                	test   %eax,%eax
  801efe:	75 8a                	jne    801e8a <print_mem_block_lists+0x3b>
  801f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f04:	75 84                	jne    801e8a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f06:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f0a:	75 10                	jne    801f1c <print_mem_block_lists+0xcd>
  801f0c:	83 ec 0c             	sub    $0xc,%esp
  801f0f:	68 54 41 80 00       	push   $0x804154
  801f14:	e8 8f e7 ff ff       	call   8006a8 <cprintf>
  801f19:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	68 78 41 80 00       	push   $0x804178
  801f2b:	e8 78 e7 ff ff       	call   8006a8 <cprintf>
  801f30:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f33:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f37:	a1 40 50 80 00       	mov    0x805040,%eax
  801f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3f:	eb 56                	jmp    801f97 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f45:	74 1c                	je     801f63 <print_mem_block_lists+0x114>
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 50 08             	mov    0x8(%eax),%edx
  801f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f50:	8b 48 08             	mov    0x8(%eax),%ecx
  801f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f56:	8b 40 0c             	mov    0xc(%eax),%eax
  801f59:	01 c8                	add    %ecx,%eax
  801f5b:	39 c2                	cmp    %eax,%edx
  801f5d:	73 04                	jae    801f63 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f5f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f66:	8b 50 08             	mov    0x8(%eax),%edx
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6f:	01 c2                	add    %eax,%edx
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	8b 40 08             	mov    0x8(%eax),%eax
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	52                   	push   %edx
  801f7b:	50                   	push   %eax
  801f7c:	68 45 41 80 00       	push   $0x804145
  801f81:	e8 22 e7 ff ff       	call   8006a8 <cprintf>
  801f86:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f8f:	a1 48 50 80 00       	mov    0x805048,%eax
  801f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9b:	74 07                	je     801fa4 <print_mem_block_lists+0x155>
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 00                	mov    (%eax),%eax
  801fa2:	eb 05                	jmp    801fa9 <print_mem_block_lists+0x15a>
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	a3 48 50 80 00       	mov    %eax,0x805048
  801fae:	a1 48 50 80 00       	mov    0x805048,%eax
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	75 8a                	jne    801f41 <print_mem_block_lists+0xf2>
  801fb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbb:	75 84                	jne    801f41 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fbd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc1:	75 10                	jne    801fd3 <print_mem_block_lists+0x184>
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	68 90 41 80 00       	push   $0x804190
  801fcb:	e8 d8 e6 ff ff       	call   8006a8 <cprintf>
  801fd0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	68 04 41 80 00       	push   $0x804104
  801fdb:	e8 c8 e6 ff ff       	call   8006a8 <cprintf>
  801fe0:	83 c4 10             	add    $0x10,%esp

}
  801fe3:	90                   	nop
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fec:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ff3:	00 00 00 
  801ff6:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ffd:	00 00 00 
  802000:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802007:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80200a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802011:	e9 9e 00 00 00       	jmp    8020b4 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802016:	a1 50 50 80 00       	mov    0x805050,%eax
  80201b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201e:	c1 e2 04             	shl    $0x4,%edx
  802021:	01 d0                	add    %edx,%eax
  802023:	85 c0                	test   %eax,%eax
  802025:	75 14                	jne    80203b <initialize_MemBlocksList+0x55>
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	68 b8 41 80 00       	push   $0x8041b8
  80202f:	6a 46                	push   $0x46
  802031:	68 db 41 80 00       	push   $0x8041db
  802036:	e8 b9 e3 ff ff       	call   8003f4 <_panic>
  80203b:	a1 50 50 80 00       	mov    0x805050,%eax
  802040:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802043:	c1 e2 04             	shl    $0x4,%edx
  802046:	01 d0                	add    %edx,%eax
  802048:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80204e:	89 10                	mov    %edx,(%eax)
  802050:	8b 00                	mov    (%eax),%eax
  802052:	85 c0                	test   %eax,%eax
  802054:	74 18                	je     80206e <initialize_MemBlocksList+0x88>
  802056:	a1 48 51 80 00       	mov    0x805148,%eax
  80205b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802061:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802064:	c1 e1 04             	shl    $0x4,%ecx
  802067:	01 ca                	add    %ecx,%edx
  802069:	89 50 04             	mov    %edx,0x4(%eax)
  80206c:	eb 12                	jmp    802080 <initialize_MemBlocksList+0x9a>
  80206e:	a1 50 50 80 00       	mov    0x805050,%eax
  802073:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802076:	c1 e2 04             	shl    $0x4,%edx
  802079:	01 d0                	add    %edx,%eax
  80207b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802080:	a1 50 50 80 00       	mov    0x805050,%eax
  802085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802088:	c1 e2 04             	shl    $0x4,%edx
  80208b:	01 d0                	add    %edx,%eax
  80208d:	a3 48 51 80 00       	mov    %eax,0x805148
  802092:	a1 50 50 80 00       	mov    0x805050,%eax
  802097:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209a:	c1 e2 04             	shl    $0x4,%edx
  80209d:	01 d0                	add    %edx,%eax
  80209f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8020ab:	40                   	inc    %eax
  8020ac:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020b1:	ff 45 f4             	incl   -0xc(%ebp)
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ba:	0f 82 56 ff ff ff    	jb     802016 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020c0:	90                   	nop
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	8b 00                	mov    (%eax),%eax
  8020ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d1:	eb 19                	jmp    8020ec <find_block+0x29>
	{
		if(va==point->sva)
  8020d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d6:	8b 40 08             	mov    0x8(%eax),%eax
  8020d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020dc:	75 05                	jne    8020e3 <find_block+0x20>
		   return point;
  8020de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e1:	eb 36                	jmp    802119 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	8b 40 08             	mov    0x8(%eax),%eax
  8020e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f0:	74 07                	je     8020f9 <find_block+0x36>
  8020f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f5:	8b 00                	mov    (%eax),%eax
  8020f7:	eb 05                	jmp    8020fe <find_block+0x3b>
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802101:	89 42 08             	mov    %eax,0x8(%edx)
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	8b 40 08             	mov    0x8(%eax),%eax
  80210a:	85 c0                	test   %eax,%eax
  80210c:	75 c5                	jne    8020d3 <find_block+0x10>
  80210e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802112:	75 bf                	jne    8020d3 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802121:	a1 40 50 80 00       	mov    0x805040,%eax
  802126:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802129:	a1 44 50 80 00       	mov    0x805044,%eax
  80212e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802134:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802137:	74 24                	je     80215d <insert_sorted_allocList+0x42>
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8b 50 08             	mov    0x8(%eax),%edx
  80213f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802142:	8b 40 08             	mov    0x8(%eax),%eax
  802145:	39 c2                	cmp    %eax,%edx
  802147:	76 14                	jbe    80215d <insert_sorted_allocList+0x42>
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 50 08             	mov    0x8(%eax),%edx
  80214f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802152:	8b 40 08             	mov    0x8(%eax),%eax
  802155:	39 c2                	cmp    %eax,%edx
  802157:	0f 82 60 01 00 00    	jb     8022bd <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80215d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802161:	75 65                	jne    8021c8 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802163:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802167:	75 14                	jne    80217d <insert_sorted_allocList+0x62>
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	68 b8 41 80 00       	push   $0x8041b8
  802171:	6a 6b                	push   $0x6b
  802173:	68 db 41 80 00       	push   $0x8041db
  802178:	e8 77 e2 ff ff       	call   8003f4 <_panic>
  80217d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	89 10                	mov    %edx,(%eax)
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	8b 00                	mov    (%eax),%eax
  80218d:	85 c0                	test   %eax,%eax
  80218f:	74 0d                	je     80219e <insert_sorted_allocList+0x83>
  802191:	a1 40 50 80 00       	mov    0x805040,%eax
  802196:	8b 55 08             	mov    0x8(%ebp),%edx
  802199:	89 50 04             	mov    %edx,0x4(%eax)
  80219c:	eb 08                	jmp    8021a6 <insert_sorted_allocList+0x8b>
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	a3 44 50 80 00       	mov    %eax,0x805044
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	a3 40 50 80 00       	mov    %eax,0x805040
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021bd:	40                   	inc    %eax
  8021be:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021c3:	e9 dc 01 00 00       	jmp    8023a4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	8b 50 08             	mov    0x8(%eax),%edx
  8021ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d1:	8b 40 08             	mov    0x8(%eax),%eax
  8021d4:	39 c2                	cmp    %eax,%edx
  8021d6:	77 6c                	ja     802244 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021dc:	74 06                	je     8021e4 <insert_sorted_allocList+0xc9>
  8021de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e2:	75 14                	jne    8021f8 <insert_sorted_allocList+0xdd>
  8021e4:	83 ec 04             	sub    $0x4,%esp
  8021e7:	68 f4 41 80 00       	push   $0x8041f4
  8021ec:	6a 6f                	push   $0x6f
  8021ee:	68 db 41 80 00       	push   $0x8041db
  8021f3:	e8 fc e1 ff ff       	call   8003f4 <_panic>
  8021f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fb:	8b 50 04             	mov    0x4(%eax),%edx
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	89 50 04             	mov    %edx,0x4(%eax)
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80220a:	89 10                	mov    %edx,(%eax)
  80220c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220f:	8b 40 04             	mov    0x4(%eax),%eax
  802212:	85 c0                	test   %eax,%eax
  802214:	74 0d                	je     802223 <insert_sorted_allocList+0x108>
  802216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802219:	8b 40 04             	mov    0x4(%eax),%eax
  80221c:	8b 55 08             	mov    0x8(%ebp),%edx
  80221f:	89 10                	mov    %edx,(%eax)
  802221:	eb 08                	jmp    80222b <insert_sorted_allocList+0x110>
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	a3 40 50 80 00       	mov    %eax,0x805040
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	8b 55 08             	mov    0x8(%ebp),%edx
  802231:	89 50 04             	mov    %edx,0x4(%eax)
  802234:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802239:	40                   	inc    %eax
  80223a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80223f:	e9 60 01 00 00       	jmp    8023a4 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	8b 50 08             	mov    0x8(%eax),%edx
  80224a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224d:	8b 40 08             	mov    0x8(%eax),%eax
  802250:	39 c2                	cmp    %eax,%edx
  802252:	0f 82 4c 01 00 00    	jb     8023a4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802258:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225c:	75 14                	jne    802272 <insert_sorted_allocList+0x157>
  80225e:	83 ec 04             	sub    $0x4,%esp
  802261:	68 2c 42 80 00       	push   $0x80422c
  802266:	6a 73                	push   $0x73
  802268:	68 db 41 80 00       	push   $0x8041db
  80226d:	e8 82 e1 ff ff       	call   8003f4 <_panic>
  802272:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	89 50 04             	mov    %edx,0x4(%eax)
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	8b 40 04             	mov    0x4(%eax),%eax
  802284:	85 c0                	test   %eax,%eax
  802286:	74 0c                	je     802294 <insert_sorted_allocList+0x179>
  802288:	a1 44 50 80 00       	mov    0x805044,%eax
  80228d:	8b 55 08             	mov    0x8(%ebp),%edx
  802290:	89 10                	mov    %edx,(%eax)
  802292:	eb 08                	jmp    80229c <insert_sorted_allocList+0x181>
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 40 50 80 00       	mov    %eax,0x805040
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	a3 44 50 80 00       	mov    %eax,0x805044
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022b2:	40                   	inc    %eax
  8022b3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022b8:	e9 e7 00 00 00       	jmp    8023a4 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022ca:	a1 40 50 80 00       	mov    0x805040,%eax
  8022cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d2:	e9 9d 00 00 00       	jmp    802374 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 00                	mov    (%eax),%eax
  8022dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8b 50 08             	mov    0x8(%eax),%edx
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	8b 40 08             	mov    0x8(%eax),%eax
  8022eb:	39 c2                	cmp    %eax,%edx
  8022ed:	76 7d                	jbe    80236c <insert_sorted_allocList+0x251>
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	8b 50 08             	mov    0x8(%eax),%edx
  8022f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f8:	8b 40 08             	mov    0x8(%eax),%eax
  8022fb:	39 c2                	cmp    %eax,%edx
  8022fd:	73 6d                	jae    80236c <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802303:	74 06                	je     80230b <insert_sorted_allocList+0x1f0>
  802305:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802309:	75 14                	jne    80231f <insert_sorted_allocList+0x204>
  80230b:	83 ec 04             	sub    $0x4,%esp
  80230e:	68 50 42 80 00       	push   $0x804250
  802313:	6a 7f                	push   $0x7f
  802315:	68 db 41 80 00       	push   $0x8041db
  80231a:	e8 d5 e0 ff ff       	call   8003f4 <_panic>
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 10                	mov    (%eax),%edx
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	89 10                	mov    %edx,(%eax)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	85 c0                	test   %eax,%eax
  802330:	74 0b                	je     80233d <insert_sorted_allocList+0x222>
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 00                	mov    (%eax),%eax
  802337:	8b 55 08             	mov    0x8(%ebp),%edx
  80233a:	89 50 04             	mov    %edx,0x4(%eax)
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 55 08             	mov    0x8(%ebp),%edx
  802343:	89 10                	mov    %edx,(%eax)
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234b:	89 50 04             	mov    %edx,0x4(%eax)
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8b 00                	mov    (%eax),%eax
  802353:	85 c0                	test   %eax,%eax
  802355:	75 08                	jne    80235f <insert_sorted_allocList+0x244>
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	a3 44 50 80 00       	mov    %eax,0x805044
  80235f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802364:	40                   	inc    %eax
  802365:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80236a:	eb 39                	jmp    8023a5 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80236c:	a1 48 50 80 00       	mov    0x805048,%eax
  802371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802378:	74 07                	je     802381 <insert_sorted_allocList+0x266>
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 00                	mov    (%eax),%eax
  80237f:	eb 05                	jmp    802386 <insert_sorted_allocList+0x26b>
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
  802386:	a3 48 50 80 00       	mov    %eax,0x805048
  80238b:	a1 48 50 80 00       	mov    0x805048,%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	0f 85 3f ff ff ff    	jne    8022d7 <insert_sorted_allocList+0x1bc>
  802398:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239c:	0f 85 35 ff ff ff    	jne    8022d7 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023a2:	eb 01                	jmp    8023a5 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023a4:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023a5:	90                   	nop
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023ae:	a1 38 51 80 00       	mov    0x805138,%eax
  8023b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b6:	e9 85 01 00 00       	jmp    802540 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c4:	0f 82 6e 01 00 00    	jb     802538 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d3:	0f 85 8a 00 00 00    	jne    802463 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023dd:	75 17                	jne    8023f6 <alloc_block_FF+0x4e>
  8023df:	83 ec 04             	sub    $0x4,%esp
  8023e2:	68 84 42 80 00       	push   $0x804284
  8023e7:	68 93 00 00 00       	push   $0x93
  8023ec:	68 db 41 80 00       	push   $0x8041db
  8023f1:	e8 fe df ff ff       	call   8003f4 <_panic>
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	74 10                	je     80240f <alloc_block_FF+0x67>
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802407:	8b 52 04             	mov    0x4(%edx),%edx
  80240a:	89 50 04             	mov    %edx,0x4(%eax)
  80240d:	eb 0b                	jmp    80241a <alloc_block_FF+0x72>
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 04             	mov    0x4(%eax),%eax
  802415:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 40 04             	mov    0x4(%eax),%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	74 0f                	je     802433 <alloc_block_FF+0x8b>
  802424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802427:	8b 40 04             	mov    0x4(%eax),%eax
  80242a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242d:	8b 12                	mov    (%edx),%edx
  80242f:	89 10                	mov    %edx,(%eax)
  802431:	eb 0a                	jmp    80243d <alloc_block_FF+0x95>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	a3 38 51 80 00       	mov    %eax,0x805138
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802450:	a1 44 51 80 00       	mov    0x805144,%eax
  802455:	48                   	dec    %eax
  802456:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	e9 10 01 00 00       	jmp    802573 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 40 0c             	mov    0xc(%eax),%eax
  802469:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246c:	0f 86 c6 00 00 00    	jbe    802538 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802472:	a1 48 51 80 00       	mov    0x805148,%eax
  802477:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 50 08             	mov    0x8(%eax),%edx
  802480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802483:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802489:	8b 55 08             	mov    0x8(%ebp),%edx
  80248c:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80248f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802493:	75 17                	jne    8024ac <alloc_block_FF+0x104>
  802495:	83 ec 04             	sub    $0x4,%esp
  802498:	68 84 42 80 00       	push   $0x804284
  80249d:	68 9b 00 00 00       	push   $0x9b
  8024a2:	68 db 41 80 00       	push   $0x8041db
  8024a7:	e8 48 df ff ff       	call   8003f4 <_panic>
  8024ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	74 10                	je     8024c5 <alloc_block_FF+0x11d>
  8024b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b8:	8b 00                	mov    (%eax),%eax
  8024ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024bd:	8b 52 04             	mov    0x4(%edx),%edx
  8024c0:	89 50 04             	mov    %edx,0x4(%eax)
  8024c3:	eb 0b                	jmp    8024d0 <alloc_block_FF+0x128>
  8024c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c8:	8b 40 04             	mov    0x4(%eax),%eax
  8024cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d3:	8b 40 04             	mov    0x4(%eax),%eax
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	74 0f                	je     8024e9 <alloc_block_FF+0x141>
  8024da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024dd:	8b 40 04             	mov    0x4(%eax),%eax
  8024e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e3:	8b 12                	mov    (%edx),%edx
  8024e5:	89 10                	mov    %edx,(%eax)
  8024e7:	eb 0a                	jmp    8024f3 <alloc_block_FF+0x14b>
  8024e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ec:	8b 00                	mov    (%eax),%eax
  8024ee:	a3 48 51 80 00       	mov    %eax,0x805148
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802506:	a1 54 51 80 00       	mov    0x805154,%eax
  80250b:	48                   	dec    %eax
  80250c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 50 08             	mov    0x8(%eax),%edx
  802517:	8b 45 08             	mov    0x8(%ebp),%eax
  80251a:	01 c2                	add    %eax,%edx
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 40 0c             	mov    0xc(%eax),%eax
  802528:	2b 45 08             	sub    0x8(%ebp),%eax
  80252b:	89 c2                	mov    %eax,%edx
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	eb 3b                	jmp    802573 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802538:	a1 40 51 80 00       	mov    0x805140,%eax
  80253d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802544:	74 07                	je     80254d <alloc_block_FF+0x1a5>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	eb 05                	jmp    802552 <alloc_block_FF+0x1aa>
  80254d:	b8 00 00 00 00       	mov    $0x0,%eax
  802552:	a3 40 51 80 00       	mov    %eax,0x805140
  802557:	a1 40 51 80 00       	mov    0x805140,%eax
  80255c:	85 c0                	test   %eax,%eax
  80255e:	0f 85 57 fe ff ff    	jne    8023bb <alloc_block_FF+0x13>
  802564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802568:	0f 85 4d fe ff ff    	jne    8023bb <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80256e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80257b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802582:	a1 38 51 80 00       	mov    0x805138,%eax
  802587:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258a:	e9 df 00 00 00       	jmp    80266e <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 0c             	mov    0xc(%eax),%eax
  802595:	3b 45 08             	cmp    0x8(%ebp),%eax
  802598:	0f 82 c8 00 00 00    	jb     802666 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a7:	0f 85 8a 00 00 00    	jne    802637 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b1:	75 17                	jne    8025ca <alloc_block_BF+0x55>
  8025b3:	83 ec 04             	sub    $0x4,%esp
  8025b6:	68 84 42 80 00       	push   $0x804284
  8025bb:	68 b7 00 00 00       	push   $0xb7
  8025c0:	68 db 41 80 00       	push   $0x8041db
  8025c5:	e8 2a de ff ff       	call   8003f4 <_panic>
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	74 10                	je     8025e3 <alloc_block_BF+0x6e>
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025db:	8b 52 04             	mov    0x4(%edx),%edx
  8025de:	89 50 04             	mov    %edx,0x4(%eax)
  8025e1:	eb 0b                	jmp    8025ee <alloc_block_BF+0x79>
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	8b 40 04             	mov    0x4(%eax),%eax
  8025e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 40 04             	mov    0x4(%eax),%eax
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	74 0f                	je     802607 <alloc_block_BF+0x92>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 04             	mov    0x4(%eax),%eax
  8025fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802601:	8b 12                	mov    (%edx),%edx
  802603:	89 10                	mov    %edx,(%eax)
  802605:	eb 0a                	jmp    802611 <alloc_block_BF+0x9c>
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	a3 38 51 80 00       	mov    %eax,0x805138
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802624:	a1 44 51 80 00       	mov    0x805144,%eax
  802629:	48                   	dec    %eax
  80262a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	e9 4d 01 00 00       	jmp    802784 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 40 0c             	mov    0xc(%eax),%eax
  80263d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802640:	76 24                	jbe    802666 <alloc_block_BF+0xf1>
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 40 0c             	mov    0xc(%eax),%eax
  802648:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80264b:	73 19                	jae    802666 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80264d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 0c             	mov    0xc(%eax),%eax
  80265a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 08             	mov    0x8(%eax),%eax
  802663:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802666:	a1 40 51 80 00       	mov    0x805140,%eax
  80266b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	74 07                	je     80267b <alloc_block_BF+0x106>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	eb 05                	jmp    802680 <alloc_block_BF+0x10b>
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	a3 40 51 80 00       	mov    %eax,0x805140
  802685:	a1 40 51 80 00       	mov    0x805140,%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	0f 85 fd fe ff ff    	jne    80258f <alloc_block_BF+0x1a>
  802692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802696:	0f 85 f3 fe ff ff    	jne    80258f <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80269c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026a0:	0f 84 d9 00 00 00    	je     80277f <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8026ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b4:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bd:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026c4:	75 17                	jne    8026dd <alloc_block_BF+0x168>
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	68 84 42 80 00       	push   $0x804284
  8026ce:	68 c7 00 00 00       	push   $0xc7
  8026d3:	68 db 41 80 00       	push   $0x8041db
  8026d8:	e8 17 dd ff ff       	call   8003f4 <_panic>
  8026dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	74 10                	je     8026f6 <alloc_block_BF+0x181>
  8026e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e9:	8b 00                	mov    (%eax),%eax
  8026eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ee:	8b 52 04             	mov    0x4(%edx),%edx
  8026f1:	89 50 04             	mov    %edx,0x4(%eax)
  8026f4:	eb 0b                	jmp    802701 <alloc_block_BF+0x18c>
  8026f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f9:	8b 40 04             	mov    0x4(%eax),%eax
  8026fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802704:	8b 40 04             	mov    0x4(%eax),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	74 0f                	je     80271a <alloc_block_BF+0x1a5>
  80270b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802714:	8b 12                	mov    (%edx),%edx
  802716:	89 10                	mov    %edx,(%eax)
  802718:	eb 0a                	jmp    802724 <alloc_block_BF+0x1af>
  80271a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	a3 48 51 80 00       	mov    %eax,0x805148
  802724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802727:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802730:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802737:	a1 54 51 80 00       	mov    0x805154,%eax
  80273c:	48                   	dec    %eax
  80273d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802742:	83 ec 08             	sub    $0x8,%esp
  802745:	ff 75 ec             	pushl  -0x14(%ebp)
  802748:	68 38 51 80 00       	push   $0x805138
  80274d:	e8 71 f9 ff ff       	call   8020c3 <find_block>
  802752:	83 c4 10             	add    $0x10,%esp
  802755:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275b:	8b 50 08             	mov    0x8(%eax),%edx
  80275e:	8b 45 08             	mov    0x8(%ebp),%eax
  802761:	01 c2                	add    %eax,%edx
  802763:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802766:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276c:	8b 40 0c             	mov    0xc(%eax),%eax
  80276f:	2b 45 08             	sub    0x8(%ebp),%eax
  802772:	89 c2                	mov    %eax,%edx
  802774:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802777:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80277a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277d:	eb 05                	jmp    802784 <alloc_block_BF+0x20f>
	}
	return NULL;
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80278c:	a1 28 50 80 00       	mov    0x805028,%eax
  802791:	85 c0                	test   %eax,%eax
  802793:	0f 85 de 01 00 00    	jne    802977 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802799:	a1 38 51 80 00       	mov    0x805138,%eax
  80279e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a1:	e9 9e 01 00 00       	jmp    802944 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027af:	0f 82 87 01 00 00    	jb     80293c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027be:	0f 85 95 00 00 00    	jne    802859 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	75 17                	jne    8027e1 <alloc_block_NF+0x5b>
  8027ca:	83 ec 04             	sub    $0x4,%esp
  8027cd:	68 84 42 80 00       	push   $0x804284
  8027d2:	68 e0 00 00 00       	push   $0xe0
  8027d7:	68 db 41 80 00       	push   $0x8041db
  8027dc:	e8 13 dc ff ff       	call   8003f4 <_panic>
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	74 10                	je     8027fa <alloc_block_NF+0x74>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f2:	8b 52 04             	mov    0x4(%edx),%edx
  8027f5:	89 50 04             	mov    %edx,0x4(%eax)
  8027f8:	eb 0b                	jmp    802805 <alloc_block_NF+0x7f>
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 40 04             	mov    0x4(%eax),%eax
  802800:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 40 04             	mov    0x4(%eax),%eax
  80280b:	85 c0                	test   %eax,%eax
  80280d:	74 0f                	je     80281e <alloc_block_NF+0x98>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 40 04             	mov    0x4(%eax),%eax
  802815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802818:	8b 12                	mov    (%edx),%edx
  80281a:	89 10                	mov    %edx,(%eax)
  80281c:	eb 0a                	jmp    802828 <alloc_block_NF+0xa2>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	a3 38 51 80 00       	mov    %eax,0x805138
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283b:	a1 44 51 80 00       	mov    0x805144,%eax
  802840:	48                   	dec    %eax
  802841:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 08             	mov    0x8(%eax),%eax
  80284c:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	e9 f8 04 00 00       	jmp    802d51 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 40 0c             	mov    0xc(%eax),%eax
  80285f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802862:	0f 86 d4 00 00 00    	jbe    80293c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802868:	a1 48 51 80 00       	mov    0x805148,%eax
  80286d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 50 08             	mov    0x8(%eax),%edx
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80287c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287f:	8b 55 08             	mov    0x8(%ebp),%edx
  802882:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802885:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802889:	75 17                	jne    8028a2 <alloc_block_NF+0x11c>
  80288b:	83 ec 04             	sub    $0x4,%esp
  80288e:	68 84 42 80 00       	push   $0x804284
  802893:	68 e9 00 00 00       	push   $0xe9
  802898:	68 db 41 80 00       	push   $0x8041db
  80289d:	e8 52 db ff ff       	call   8003f4 <_panic>
  8028a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	85 c0                	test   %eax,%eax
  8028a9:	74 10                	je     8028bb <alloc_block_NF+0x135>
  8028ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b3:	8b 52 04             	mov    0x4(%edx),%edx
  8028b6:	89 50 04             	mov    %edx,0x4(%eax)
  8028b9:	eb 0b                	jmp    8028c6 <alloc_block_NF+0x140>
  8028bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c9:	8b 40 04             	mov    0x4(%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 0f                	je     8028df <alloc_block_NF+0x159>
  8028d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d9:	8b 12                	mov    (%edx),%edx
  8028db:	89 10                	mov    %edx,(%eax)
  8028dd:	eb 0a                	jmp    8028e9 <alloc_block_NF+0x163>
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	a3 48 51 80 00       	mov    %eax,0x805148
  8028e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fc:	a1 54 51 80 00       	mov    0x805154,%eax
  802901:	48                   	dec    %eax
  802902:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	8b 40 08             	mov    0x8(%eax),%eax
  80290d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 50 08             	mov    0x8(%eax),%edx
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	01 c2                	add    %eax,%edx
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 40 0c             	mov    0xc(%eax),%eax
  802929:	2b 45 08             	sub    0x8(%ebp),%eax
  80292c:	89 c2                	mov    %eax,%edx
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802937:	e9 15 04 00 00       	jmp    802d51 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80293c:	a1 40 51 80 00       	mov    0x805140,%eax
  802941:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802944:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802948:	74 07                	je     802951 <alloc_block_NF+0x1cb>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	eb 05                	jmp    802956 <alloc_block_NF+0x1d0>
  802951:	b8 00 00 00 00       	mov    $0x0,%eax
  802956:	a3 40 51 80 00       	mov    %eax,0x805140
  80295b:	a1 40 51 80 00       	mov    0x805140,%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	0f 85 3e fe ff ff    	jne    8027a6 <alloc_block_NF+0x20>
  802968:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296c:	0f 85 34 fe ff ff    	jne    8027a6 <alloc_block_NF+0x20>
  802972:	e9 d5 03 00 00       	jmp    802d4c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802977:	a1 38 51 80 00       	mov    0x805138,%eax
  80297c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297f:	e9 b1 01 00 00       	jmp    802b35 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 50 08             	mov    0x8(%eax),%edx
  80298a:	a1 28 50 80 00       	mov    0x805028,%eax
  80298f:	39 c2                	cmp    %eax,%edx
  802991:	0f 82 96 01 00 00    	jb     802b2d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 40 0c             	mov    0xc(%eax),%eax
  80299d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a0:	0f 82 87 01 00 00    	jb     802b2d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029af:	0f 85 95 00 00 00    	jne    802a4a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b9:	75 17                	jne    8029d2 <alloc_block_NF+0x24c>
  8029bb:	83 ec 04             	sub    $0x4,%esp
  8029be:	68 84 42 80 00       	push   $0x804284
  8029c3:	68 fc 00 00 00       	push   $0xfc
  8029c8:	68 db 41 80 00       	push   $0x8041db
  8029cd:	e8 22 da ff ff       	call   8003f4 <_panic>
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	74 10                	je     8029eb <alloc_block_NF+0x265>
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e3:	8b 52 04             	mov    0x4(%edx),%edx
  8029e6:	89 50 04             	mov    %edx,0x4(%eax)
  8029e9:	eb 0b                	jmp    8029f6 <alloc_block_NF+0x270>
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 40 04             	mov    0x4(%eax),%eax
  8029f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 40 04             	mov    0x4(%eax),%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	74 0f                	je     802a0f <alloc_block_NF+0x289>
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 40 04             	mov    0x4(%eax),%eax
  802a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a09:	8b 12                	mov    (%edx),%edx
  802a0b:	89 10                	mov    %edx,(%eax)
  802a0d:	eb 0a                	jmp    802a19 <alloc_block_NF+0x293>
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	a3 38 51 80 00       	mov    %eax,0x805138
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2c:	a1 44 51 80 00       	mov    0x805144,%eax
  802a31:	48                   	dec    %eax
  802a32:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 08             	mov    0x8(%eax),%eax
  802a3d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	e9 07 03 00 00       	jmp    802d51 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a53:	0f 86 d4 00 00 00    	jbe    802b2d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a59:	a1 48 51 80 00       	mov    0x805148,%eax
  802a5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 50 08             	mov    0x8(%eax),%edx
  802a67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a70:	8b 55 08             	mov    0x8(%ebp),%edx
  802a73:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a7a:	75 17                	jne    802a93 <alloc_block_NF+0x30d>
  802a7c:	83 ec 04             	sub    $0x4,%esp
  802a7f:	68 84 42 80 00       	push   $0x804284
  802a84:	68 04 01 00 00       	push   $0x104
  802a89:	68 db 41 80 00       	push   $0x8041db
  802a8e:	e8 61 d9 ff ff       	call   8003f4 <_panic>
  802a93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a96:	8b 00                	mov    (%eax),%eax
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	74 10                	je     802aac <alloc_block_NF+0x326>
  802a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9f:	8b 00                	mov    (%eax),%eax
  802aa1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aa4:	8b 52 04             	mov    0x4(%edx),%edx
  802aa7:	89 50 04             	mov    %edx,0x4(%eax)
  802aaa:	eb 0b                	jmp    802ab7 <alloc_block_NF+0x331>
  802aac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aaf:	8b 40 04             	mov    0x4(%eax),%eax
  802ab2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aba:	8b 40 04             	mov    0x4(%eax),%eax
  802abd:	85 c0                	test   %eax,%eax
  802abf:	74 0f                	je     802ad0 <alloc_block_NF+0x34a>
  802ac1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac4:	8b 40 04             	mov    0x4(%eax),%eax
  802ac7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aca:	8b 12                	mov    (%edx),%edx
  802acc:	89 10                	mov    %edx,(%eax)
  802ace:	eb 0a                	jmp    802ada <alloc_block_NF+0x354>
  802ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad3:	8b 00                	mov    (%eax),%eax
  802ad5:	a3 48 51 80 00       	mov    %eax,0x805148
  802ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802add:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aed:	a1 54 51 80 00       	mov    0x805154,%eax
  802af2:	48                   	dec    %eax
  802af3:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afb:	8b 40 08             	mov    0x8(%eax),%eax
  802afe:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 50 08             	mov    0x8(%eax),%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	01 c2                	add    %eax,%edx
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1a:	2b 45 08             	sub    0x8(%ebp),%eax
  802b1d:	89 c2                	mov    %eax,%edx
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b28:	e9 24 02 00 00       	jmp    802d51 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b2d:	a1 40 51 80 00       	mov    0x805140,%eax
  802b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b39:	74 07                	je     802b42 <alloc_block_NF+0x3bc>
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	eb 05                	jmp    802b47 <alloc_block_NF+0x3c1>
  802b42:	b8 00 00 00 00       	mov    $0x0,%eax
  802b47:	a3 40 51 80 00       	mov    %eax,0x805140
  802b4c:	a1 40 51 80 00       	mov    0x805140,%eax
  802b51:	85 c0                	test   %eax,%eax
  802b53:	0f 85 2b fe ff ff    	jne    802984 <alloc_block_NF+0x1fe>
  802b59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5d:	0f 85 21 fe ff ff    	jne    802984 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b63:	a1 38 51 80 00       	mov    0x805138,%eax
  802b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6b:	e9 ae 01 00 00       	jmp    802d1e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 50 08             	mov    0x8(%eax),%edx
  802b76:	a1 28 50 80 00       	mov    0x805028,%eax
  802b7b:	39 c2                	cmp    %eax,%edx
  802b7d:	0f 83 93 01 00 00    	jae    802d16 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 0c             	mov    0xc(%eax),%eax
  802b89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8c:	0f 82 84 01 00 00    	jb     802d16 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 40 0c             	mov    0xc(%eax),%eax
  802b98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b9b:	0f 85 95 00 00 00    	jne    802c36 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba5:	75 17                	jne    802bbe <alloc_block_NF+0x438>
  802ba7:	83 ec 04             	sub    $0x4,%esp
  802baa:	68 84 42 80 00       	push   $0x804284
  802baf:	68 14 01 00 00       	push   $0x114
  802bb4:	68 db 41 80 00       	push   $0x8041db
  802bb9:	e8 36 d8 ff ff       	call   8003f4 <_panic>
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	74 10                	je     802bd7 <alloc_block_NF+0x451>
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcf:	8b 52 04             	mov    0x4(%edx),%edx
  802bd2:	89 50 04             	mov    %edx,0x4(%eax)
  802bd5:	eb 0b                	jmp    802be2 <alloc_block_NF+0x45c>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 04             	mov    0x4(%eax),%eax
  802bdd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 40 04             	mov    0x4(%eax),%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	74 0f                	je     802bfb <alloc_block_NF+0x475>
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 40 04             	mov    0x4(%eax),%eax
  802bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf5:	8b 12                	mov    (%edx),%edx
  802bf7:	89 10                	mov    %edx,(%eax)
  802bf9:	eb 0a                	jmp    802c05 <alloc_block_NF+0x47f>
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	a3 38 51 80 00       	mov    %eax,0x805138
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c18:	a1 44 51 80 00       	mov    0x805144,%eax
  802c1d:	48                   	dec    %eax
  802c1e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 40 08             	mov    0x8(%eax),%eax
  802c29:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	e9 1b 01 00 00       	jmp    802d51 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3f:	0f 86 d1 00 00 00    	jbe    802d16 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c45:	a1 48 51 80 00       	mov    0x805148,%eax
  802c4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 50 08             	mov    0x8(%eax),%edx
  802c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c56:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c66:	75 17                	jne    802c7f <alloc_block_NF+0x4f9>
  802c68:	83 ec 04             	sub    $0x4,%esp
  802c6b:	68 84 42 80 00       	push   $0x804284
  802c70:	68 1c 01 00 00       	push   $0x11c
  802c75:	68 db 41 80 00       	push   $0x8041db
  802c7a:	e8 75 d7 ff ff       	call   8003f4 <_panic>
  802c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	74 10                	je     802c98 <alloc_block_NF+0x512>
  802c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c90:	8b 52 04             	mov    0x4(%edx),%edx
  802c93:	89 50 04             	mov    %edx,0x4(%eax)
  802c96:	eb 0b                	jmp    802ca3 <alloc_block_NF+0x51d>
  802c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca6:	8b 40 04             	mov    0x4(%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 0f                	je     802cbc <alloc_block_NF+0x536>
  802cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb6:	8b 12                	mov    (%edx),%edx
  802cb8:	89 10                	mov    %edx,(%eax)
  802cba:	eb 0a                	jmp    802cc6 <alloc_block_NF+0x540>
  802cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd9:	a1 54 51 80 00       	mov    0x805154,%eax
  802cde:	48                   	dec    %eax
  802cdf:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce7:	8b 40 08             	mov    0x8(%eax),%eax
  802cea:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 50 08             	mov    0x8(%eax),%edx
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	01 c2                	add    %eax,%edx
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 40 0c             	mov    0xc(%eax),%eax
  802d06:	2b 45 08             	sub    0x8(%ebp),%eax
  802d09:	89 c2                	mov    %eax,%edx
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d14:	eb 3b                	jmp    802d51 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d16:	a1 40 51 80 00       	mov    0x805140,%eax
  802d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d22:	74 07                	je     802d2b <alloc_block_NF+0x5a5>
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	eb 05                	jmp    802d30 <alloc_block_NF+0x5aa>
  802d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d30:	a3 40 51 80 00       	mov    %eax,0x805140
  802d35:	a1 40 51 80 00       	mov    0x805140,%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	0f 85 2e fe ff ff    	jne    802b70 <alloc_block_NF+0x3ea>
  802d42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d46:	0f 85 24 fe ff ff    	jne    802b70 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d51:	c9                   	leave  
  802d52:	c3                   	ret    

00802d53 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d53:	55                   	push   %ebp
  802d54:	89 e5                	mov    %esp,%ebp
  802d56:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d59:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d61:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d66:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d69:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	74 14                	je     802d86 <insert_sorted_with_merge_freeList+0x33>
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	8b 50 08             	mov    0x8(%eax),%edx
  802d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7b:	8b 40 08             	mov    0x8(%eax),%eax
  802d7e:	39 c2                	cmp    %eax,%edx
  802d80:	0f 87 9b 01 00 00    	ja     802f21 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8a:	75 17                	jne    802da3 <insert_sorted_with_merge_freeList+0x50>
  802d8c:	83 ec 04             	sub    $0x4,%esp
  802d8f:	68 b8 41 80 00       	push   $0x8041b8
  802d94:	68 38 01 00 00       	push   $0x138
  802d99:	68 db 41 80 00       	push   $0x8041db
  802d9e:	e8 51 d6 ff ff       	call   8003f4 <_panic>
  802da3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	89 10                	mov    %edx,(%eax)
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	8b 00                	mov    (%eax),%eax
  802db3:	85 c0                	test   %eax,%eax
  802db5:	74 0d                	je     802dc4 <insert_sorted_with_merge_freeList+0x71>
  802db7:	a1 38 51 80 00       	mov    0x805138,%eax
  802dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbf:	89 50 04             	mov    %edx,0x4(%eax)
  802dc2:	eb 08                	jmp    802dcc <insert_sorted_with_merge_freeList+0x79>
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dde:	a1 44 51 80 00       	mov    0x805144,%eax
  802de3:	40                   	inc    %eax
  802de4:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802de9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ded:	0f 84 a8 06 00 00    	je     80349b <insert_sorted_with_merge_freeList+0x748>
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 50 08             	mov    0x8(%eax),%edx
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dff:	01 c2                	add    %eax,%edx
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	8b 40 08             	mov    0x8(%eax),%eax
  802e07:	39 c2                	cmp    %eax,%edx
  802e09:	0f 85 8c 06 00 00    	jne    80349b <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 50 0c             	mov    0xc(%eax),%edx
  802e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	01 c2                	add    %eax,%edx
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e27:	75 17                	jne    802e40 <insert_sorted_with_merge_freeList+0xed>
  802e29:	83 ec 04             	sub    $0x4,%esp
  802e2c:	68 84 42 80 00       	push   $0x804284
  802e31:	68 3c 01 00 00       	push   $0x13c
  802e36:	68 db 41 80 00       	push   $0x8041db
  802e3b:	e8 b4 d5 ff ff       	call   8003f4 <_panic>
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	74 10                	je     802e59 <insert_sorted_with_merge_freeList+0x106>
  802e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4c:	8b 00                	mov    (%eax),%eax
  802e4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e51:	8b 52 04             	mov    0x4(%edx),%edx
  802e54:	89 50 04             	mov    %edx,0x4(%eax)
  802e57:	eb 0b                	jmp    802e64 <insert_sorted_with_merge_freeList+0x111>
  802e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5c:	8b 40 04             	mov    0x4(%eax),%eax
  802e5f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e67:	8b 40 04             	mov    0x4(%eax),%eax
  802e6a:	85 c0                	test   %eax,%eax
  802e6c:	74 0f                	je     802e7d <insert_sorted_with_merge_freeList+0x12a>
  802e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e71:	8b 40 04             	mov    0x4(%eax),%eax
  802e74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e77:	8b 12                	mov    (%edx),%edx
  802e79:	89 10                	mov    %edx,(%eax)
  802e7b:	eb 0a                	jmp    802e87 <insert_sorted_with_merge_freeList+0x134>
  802e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	a3 38 51 80 00       	mov    %eax,0x805138
  802e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9a:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9f:	48                   	dec    %eax
  802ea0:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802eb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ebd:	75 17                	jne    802ed6 <insert_sorted_with_merge_freeList+0x183>
  802ebf:	83 ec 04             	sub    $0x4,%esp
  802ec2:	68 b8 41 80 00       	push   $0x8041b8
  802ec7:	68 3f 01 00 00       	push   $0x13f
  802ecc:	68 db 41 80 00       	push   $0x8041db
  802ed1:	e8 1e d5 ff ff       	call   8003f4 <_panic>
  802ed6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edf:	89 10                	mov    %edx,(%eax)
  802ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 0d                	je     802ef7 <insert_sorted_with_merge_freeList+0x1a4>
  802eea:	a1 48 51 80 00       	mov    0x805148,%eax
  802eef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef2:	89 50 04             	mov    %edx,0x4(%eax)
  802ef5:	eb 08                	jmp    802eff <insert_sorted_with_merge_freeList+0x1ac>
  802ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	a3 48 51 80 00       	mov    %eax,0x805148
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f11:	a1 54 51 80 00       	mov    0x805154,%eax
  802f16:	40                   	inc    %eax
  802f17:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f1c:	e9 7a 05 00 00       	jmp    80349b <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	8b 50 08             	mov    0x8(%eax),%edx
  802f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2a:	8b 40 08             	mov    0x8(%eax),%eax
  802f2d:	39 c2                	cmp    %eax,%edx
  802f2f:	0f 82 14 01 00 00    	jb     803049 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f38:	8b 50 08             	mov    0x8(%eax),%edx
  802f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f41:	01 c2                	add    %eax,%edx
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	8b 40 08             	mov    0x8(%eax),%eax
  802f49:	39 c2                	cmp    %eax,%edx
  802f4b:	0f 85 90 00 00 00    	jne    802fe1 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f54:	8b 50 0c             	mov    0xc(%eax),%edx
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5d:	01 c2                	add    %eax,%edx
  802f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f62:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7d:	75 17                	jne    802f96 <insert_sorted_with_merge_freeList+0x243>
  802f7f:	83 ec 04             	sub    $0x4,%esp
  802f82:	68 b8 41 80 00       	push   $0x8041b8
  802f87:	68 49 01 00 00       	push   $0x149
  802f8c:	68 db 41 80 00       	push   $0x8041db
  802f91:	e8 5e d4 ff ff       	call   8003f4 <_panic>
  802f96:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	89 10                	mov    %edx,(%eax)
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	85 c0                	test   %eax,%eax
  802fa8:	74 0d                	je     802fb7 <insert_sorted_with_merge_freeList+0x264>
  802faa:	a1 48 51 80 00       	mov    0x805148,%eax
  802faf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb2:	89 50 04             	mov    %edx,0x4(%eax)
  802fb5:	eb 08                	jmp    802fbf <insert_sorted_with_merge_freeList+0x26c>
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd1:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd6:	40                   	inc    %eax
  802fd7:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fdc:	e9 bb 04 00 00       	jmp    80349c <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fe1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe5:	75 17                	jne    802ffe <insert_sorted_with_merge_freeList+0x2ab>
  802fe7:	83 ec 04             	sub    $0x4,%esp
  802fea:	68 2c 42 80 00       	push   $0x80422c
  802fef:	68 4c 01 00 00       	push   $0x14c
  802ff4:	68 db 41 80 00       	push   $0x8041db
  802ff9:	e8 f6 d3 ff ff       	call   8003f4 <_panic>
  802ffe:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	89 50 04             	mov    %edx,0x4(%eax)
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 0c                	je     803020 <insert_sorted_with_merge_freeList+0x2cd>
  803014:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803019:	8b 55 08             	mov    0x8(%ebp),%edx
  80301c:	89 10                	mov    %edx,(%eax)
  80301e:	eb 08                	jmp    803028 <insert_sorted_with_merge_freeList+0x2d5>
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	a3 38 51 80 00       	mov    %eax,0x805138
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803039:	a1 44 51 80 00       	mov    0x805144,%eax
  80303e:	40                   	inc    %eax
  80303f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803044:	e9 53 04 00 00       	jmp    80349c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803049:	a1 38 51 80 00       	mov    0x805138,%eax
  80304e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803051:	e9 15 04 00 00       	jmp    80346b <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	8b 00                	mov    (%eax),%eax
  80305b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 50 08             	mov    0x8(%eax),%edx
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 40 08             	mov    0x8(%eax),%eax
  80306a:	39 c2                	cmp    %eax,%edx
  80306c:	0f 86 f1 03 00 00    	jbe    803463 <insert_sorted_with_merge_freeList+0x710>
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	8b 50 08             	mov    0x8(%eax),%edx
  803078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307b:	8b 40 08             	mov    0x8(%eax),%eax
  80307e:	39 c2                	cmp    %eax,%edx
  803080:	0f 83 dd 03 00 00    	jae    803463 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 50 08             	mov    0x8(%eax),%edx
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 40 0c             	mov    0xc(%eax),%eax
  803092:	01 c2                	add    %eax,%edx
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	8b 40 08             	mov    0x8(%eax),%eax
  80309a:	39 c2                	cmp    %eax,%edx
  80309c:	0f 85 b9 01 00 00    	jne    80325b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 50 08             	mov    0x8(%eax),%edx
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ae:	01 c2                	add    %eax,%edx
  8030b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b3:	8b 40 08             	mov    0x8(%eax),%eax
  8030b6:	39 c2                	cmp    %eax,%edx
  8030b8:	0f 85 0d 01 00 00    	jne    8031cb <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ca:	01 c2                	add    %eax,%edx
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d6:	75 17                	jne    8030ef <insert_sorted_with_merge_freeList+0x39c>
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	68 84 42 80 00       	push   $0x804284
  8030e0:	68 5c 01 00 00       	push   $0x15c
  8030e5:	68 db 41 80 00       	push   $0x8041db
  8030ea:	e8 05 d3 ff ff       	call   8003f4 <_panic>
  8030ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	85 c0                	test   %eax,%eax
  8030f6:	74 10                	je     803108 <insert_sorted_with_merge_freeList+0x3b5>
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803100:	8b 52 04             	mov    0x4(%edx),%edx
  803103:	89 50 04             	mov    %edx,0x4(%eax)
  803106:	eb 0b                	jmp    803113 <insert_sorted_with_merge_freeList+0x3c0>
  803108:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310b:	8b 40 04             	mov    0x4(%eax),%eax
  80310e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803116:	8b 40 04             	mov    0x4(%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 0f                	je     80312c <insert_sorted_with_merge_freeList+0x3d9>
  80311d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803120:	8b 40 04             	mov    0x4(%eax),%eax
  803123:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803126:	8b 12                	mov    (%edx),%edx
  803128:	89 10                	mov    %edx,(%eax)
  80312a:	eb 0a                	jmp    803136 <insert_sorted_with_merge_freeList+0x3e3>
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	a3 38 51 80 00       	mov    %eax,0x805138
  803136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803139:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803149:	a1 44 51 80 00       	mov    0x805144,%eax
  80314e:	48                   	dec    %eax
  80314f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803168:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80316c:	75 17                	jne    803185 <insert_sorted_with_merge_freeList+0x432>
  80316e:	83 ec 04             	sub    $0x4,%esp
  803171:	68 b8 41 80 00       	push   $0x8041b8
  803176:	68 5f 01 00 00       	push   $0x15f
  80317b:	68 db 41 80 00       	push   $0x8041db
  803180:	e8 6f d2 ff ff       	call   8003f4 <_panic>
  803185:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	89 10                	mov    %edx,(%eax)
  803190:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	74 0d                	je     8031a6 <insert_sorted_with_merge_freeList+0x453>
  803199:	a1 48 51 80 00       	mov    0x805148,%eax
  80319e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a1:	89 50 04             	mov    %edx,0x4(%eax)
  8031a4:	eb 08                	jmp    8031ae <insert_sorted_with_merge_freeList+0x45b>
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c5:	40                   	inc    %eax
  8031c6:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ce:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d7:	01 c2                	add    %eax,%edx
  8031d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dc:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f7:	75 17                	jne    803210 <insert_sorted_with_merge_freeList+0x4bd>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 b8 41 80 00       	push   $0x8041b8
  803201:	68 64 01 00 00       	push   $0x164
  803206:	68 db 41 80 00       	push   $0x8041db
  80320b:	e8 e4 d1 ff ff       	call   8003f4 <_panic>
  803210:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	89 10                	mov    %edx,(%eax)
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	74 0d                	je     803231 <insert_sorted_with_merge_freeList+0x4de>
  803224:	a1 48 51 80 00       	mov    0x805148,%eax
  803229:	8b 55 08             	mov    0x8(%ebp),%edx
  80322c:	89 50 04             	mov    %edx,0x4(%eax)
  80322f:	eb 08                	jmp    803239 <insert_sorted_with_merge_freeList+0x4e6>
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	a3 48 51 80 00       	mov    %eax,0x805148
  803241:	8b 45 08             	mov    0x8(%ebp),%eax
  803244:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324b:	a1 54 51 80 00       	mov    0x805154,%eax
  803250:	40                   	inc    %eax
  803251:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803256:	e9 41 02 00 00       	jmp    80349c <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	8b 50 08             	mov    0x8(%eax),%edx
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	8b 40 0c             	mov    0xc(%eax),%eax
  803267:	01 c2                	add    %eax,%edx
  803269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326c:	8b 40 08             	mov    0x8(%eax),%eax
  80326f:	39 c2                	cmp    %eax,%edx
  803271:	0f 85 7c 01 00 00    	jne    8033f3 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803277:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80327b:	74 06                	je     803283 <insert_sorted_with_merge_freeList+0x530>
  80327d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803281:	75 17                	jne    80329a <insert_sorted_with_merge_freeList+0x547>
  803283:	83 ec 04             	sub    $0x4,%esp
  803286:	68 f4 41 80 00       	push   $0x8041f4
  80328b:	68 69 01 00 00       	push   $0x169
  803290:	68 db 41 80 00       	push   $0x8041db
  803295:	e8 5a d1 ff ff       	call   8003f4 <_panic>
  80329a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329d:	8b 50 04             	mov    0x4(%eax),%edx
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	89 50 04             	mov    %edx,0x4(%eax)
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ac:	89 10                	mov    %edx,(%eax)
  8032ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b1:	8b 40 04             	mov    0x4(%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 0d                	je     8032c5 <insert_sorted_with_merge_freeList+0x572>
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	8b 40 04             	mov    0x4(%eax),%eax
  8032be:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c1:	89 10                	mov    %edx,(%eax)
  8032c3:	eb 08                	jmp    8032cd <insert_sorted_with_merge_freeList+0x57a>
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d3:	89 50 04             	mov    %edx,0x4(%eax)
  8032d6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032db:	40                   	inc    %eax
  8032dc:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ed:	01 c2                	add    %eax,%edx
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032f9:	75 17                	jne    803312 <insert_sorted_with_merge_freeList+0x5bf>
  8032fb:	83 ec 04             	sub    $0x4,%esp
  8032fe:	68 84 42 80 00       	push   $0x804284
  803303:	68 6b 01 00 00       	push   $0x16b
  803308:	68 db 41 80 00       	push   $0x8041db
  80330d:	e8 e2 d0 ff ff       	call   8003f4 <_panic>
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	85 c0                	test   %eax,%eax
  803319:	74 10                	je     80332b <insert_sorted_with_merge_freeList+0x5d8>
  80331b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803323:	8b 52 04             	mov    0x4(%edx),%edx
  803326:	89 50 04             	mov    %edx,0x4(%eax)
  803329:	eb 0b                	jmp    803336 <insert_sorted_with_merge_freeList+0x5e3>
  80332b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332e:	8b 40 04             	mov    0x4(%eax),%eax
  803331:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803336:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803339:	8b 40 04             	mov    0x4(%eax),%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	74 0f                	je     80334f <insert_sorted_with_merge_freeList+0x5fc>
  803340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803343:	8b 40 04             	mov    0x4(%eax),%eax
  803346:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803349:	8b 12                	mov    (%edx),%edx
  80334b:	89 10                	mov    %edx,(%eax)
  80334d:	eb 0a                	jmp    803359 <insert_sorted_with_merge_freeList+0x606>
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	a3 38 51 80 00       	mov    %eax,0x805138
  803359:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803365:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336c:	a1 44 51 80 00       	mov    0x805144,%eax
  803371:	48                   	dec    %eax
  803372:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803384:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80338b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80338f:	75 17                	jne    8033a8 <insert_sorted_with_merge_freeList+0x655>
  803391:	83 ec 04             	sub    $0x4,%esp
  803394:	68 b8 41 80 00       	push   $0x8041b8
  803399:	68 6e 01 00 00       	push   $0x16e
  80339e:	68 db 41 80 00       	push   $0x8041db
  8033a3:	e8 4c d0 ff ff       	call   8003f4 <_panic>
  8033a8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	74 0d                	je     8033c9 <insert_sorted_with_merge_freeList+0x676>
  8033bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c4:	89 50 04             	mov    %edx,0x4(%eax)
  8033c7:	eb 08                	jmp    8033d1 <insert_sorted_with_merge_freeList+0x67e>
  8033c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8033e8:	40                   	inc    %eax
  8033e9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033ee:	e9 a9 00 00 00       	jmp    80349c <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f7:	74 06                	je     8033ff <insert_sorted_with_merge_freeList+0x6ac>
  8033f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033fd:	75 17                	jne    803416 <insert_sorted_with_merge_freeList+0x6c3>
  8033ff:	83 ec 04             	sub    $0x4,%esp
  803402:	68 50 42 80 00       	push   $0x804250
  803407:	68 73 01 00 00       	push   $0x173
  80340c:	68 db 41 80 00       	push   $0x8041db
  803411:	e8 de cf ff ff       	call   8003f4 <_panic>
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 10                	mov    (%eax),%edx
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	89 10                	mov    %edx,(%eax)
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	8b 00                	mov    (%eax),%eax
  803425:	85 c0                	test   %eax,%eax
  803427:	74 0b                	je     803434 <insert_sorted_with_merge_freeList+0x6e1>
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	8b 55 08             	mov    0x8(%ebp),%edx
  803431:	89 50 04             	mov    %edx,0x4(%eax)
  803434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803437:	8b 55 08             	mov    0x8(%ebp),%edx
  80343a:	89 10                	mov    %edx,(%eax)
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803442:	89 50 04             	mov    %edx,0x4(%eax)
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	8b 00                	mov    (%eax),%eax
  80344a:	85 c0                	test   %eax,%eax
  80344c:	75 08                	jne    803456 <insert_sorted_with_merge_freeList+0x703>
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803456:	a1 44 51 80 00       	mov    0x805144,%eax
  80345b:	40                   	inc    %eax
  80345c:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803461:	eb 39                	jmp    80349c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803463:	a1 40 51 80 00       	mov    0x805140,%eax
  803468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80346b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346f:	74 07                	je     803478 <insert_sorted_with_merge_freeList+0x725>
  803471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	eb 05                	jmp    80347d <insert_sorted_with_merge_freeList+0x72a>
  803478:	b8 00 00 00 00       	mov    $0x0,%eax
  80347d:	a3 40 51 80 00       	mov    %eax,0x805140
  803482:	a1 40 51 80 00       	mov    0x805140,%eax
  803487:	85 c0                	test   %eax,%eax
  803489:	0f 85 c7 fb ff ff    	jne    803056 <insert_sorted_with_merge_freeList+0x303>
  80348f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803493:	0f 85 bd fb ff ff    	jne    803056 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803499:	eb 01                	jmp    80349c <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80349b:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80349c:	90                   	nop
  80349d:	c9                   	leave  
  80349e:	c3                   	ret    
  80349f:	90                   	nop

008034a0 <__udivdi3>:
  8034a0:	55                   	push   %ebp
  8034a1:	57                   	push   %edi
  8034a2:	56                   	push   %esi
  8034a3:	53                   	push   %ebx
  8034a4:	83 ec 1c             	sub    $0x1c,%esp
  8034a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034b7:	89 ca                	mov    %ecx,%edx
  8034b9:	89 f8                	mov    %edi,%eax
  8034bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034bf:	85 f6                	test   %esi,%esi
  8034c1:	75 2d                	jne    8034f0 <__udivdi3+0x50>
  8034c3:	39 cf                	cmp    %ecx,%edi
  8034c5:	77 65                	ja     80352c <__udivdi3+0x8c>
  8034c7:	89 fd                	mov    %edi,%ebp
  8034c9:	85 ff                	test   %edi,%edi
  8034cb:	75 0b                	jne    8034d8 <__udivdi3+0x38>
  8034cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d2:	31 d2                	xor    %edx,%edx
  8034d4:	f7 f7                	div    %edi
  8034d6:	89 c5                	mov    %eax,%ebp
  8034d8:	31 d2                	xor    %edx,%edx
  8034da:	89 c8                	mov    %ecx,%eax
  8034dc:	f7 f5                	div    %ebp
  8034de:	89 c1                	mov    %eax,%ecx
  8034e0:	89 d8                	mov    %ebx,%eax
  8034e2:	f7 f5                	div    %ebp
  8034e4:	89 cf                	mov    %ecx,%edi
  8034e6:	89 fa                	mov    %edi,%edx
  8034e8:	83 c4 1c             	add    $0x1c,%esp
  8034eb:	5b                   	pop    %ebx
  8034ec:	5e                   	pop    %esi
  8034ed:	5f                   	pop    %edi
  8034ee:	5d                   	pop    %ebp
  8034ef:	c3                   	ret    
  8034f0:	39 ce                	cmp    %ecx,%esi
  8034f2:	77 28                	ja     80351c <__udivdi3+0x7c>
  8034f4:	0f bd fe             	bsr    %esi,%edi
  8034f7:	83 f7 1f             	xor    $0x1f,%edi
  8034fa:	75 40                	jne    80353c <__udivdi3+0x9c>
  8034fc:	39 ce                	cmp    %ecx,%esi
  8034fe:	72 0a                	jb     80350a <__udivdi3+0x6a>
  803500:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803504:	0f 87 9e 00 00 00    	ja     8035a8 <__udivdi3+0x108>
  80350a:	b8 01 00 00 00       	mov    $0x1,%eax
  80350f:	89 fa                	mov    %edi,%edx
  803511:	83 c4 1c             	add    $0x1c,%esp
  803514:	5b                   	pop    %ebx
  803515:	5e                   	pop    %esi
  803516:	5f                   	pop    %edi
  803517:	5d                   	pop    %ebp
  803518:	c3                   	ret    
  803519:	8d 76 00             	lea    0x0(%esi),%esi
  80351c:	31 ff                	xor    %edi,%edi
  80351e:	31 c0                	xor    %eax,%eax
  803520:	89 fa                	mov    %edi,%edx
  803522:	83 c4 1c             	add    $0x1c,%esp
  803525:	5b                   	pop    %ebx
  803526:	5e                   	pop    %esi
  803527:	5f                   	pop    %edi
  803528:	5d                   	pop    %ebp
  803529:	c3                   	ret    
  80352a:	66 90                	xchg   %ax,%ax
  80352c:	89 d8                	mov    %ebx,%eax
  80352e:	f7 f7                	div    %edi
  803530:	31 ff                	xor    %edi,%edi
  803532:	89 fa                	mov    %edi,%edx
  803534:	83 c4 1c             	add    $0x1c,%esp
  803537:	5b                   	pop    %ebx
  803538:	5e                   	pop    %esi
  803539:	5f                   	pop    %edi
  80353a:	5d                   	pop    %ebp
  80353b:	c3                   	ret    
  80353c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803541:	89 eb                	mov    %ebp,%ebx
  803543:	29 fb                	sub    %edi,%ebx
  803545:	89 f9                	mov    %edi,%ecx
  803547:	d3 e6                	shl    %cl,%esi
  803549:	89 c5                	mov    %eax,%ebp
  80354b:	88 d9                	mov    %bl,%cl
  80354d:	d3 ed                	shr    %cl,%ebp
  80354f:	89 e9                	mov    %ebp,%ecx
  803551:	09 f1                	or     %esi,%ecx
  803553:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803557:	89 f9                	mov    %edi,%ecx
  803559:	d3 e0                	shl    %cl,%eax
  80355b:	89 c5                	mov    %eax,%ebp
  80355d:	89 d6                	mov    %edx,%esi
  80355f:	88 d9                	mov    %bl,%cl
  803561:	d3 ee                	shr    %cl,%esi
  803563:	89 f9                	mov    %edi,%ecx
  803565:	d3 e2                	shl    %cl,%edx
  803567:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356b:	88 d9                	mov    %bl,%cl
  80356d:	d3 e8                	shr    %cl,%eax
  80356f:	09 c2                	or     %eax,%edx
  803571:	89 d0                	mov    %edx,%eax
  803573:	89 f2                	mov    %esi,%edx
  803575:	f7 74 24 0c          	divl   0xc(%esp)
  803579:	89 d6                	mov    %edx,%esi
  80357b:	89 c3                	mov    %eax,%ebx
  80357d:	f7 e5                	mul    %ebp
  80357f:	39 d6                	cmp    %edx,%esi
  803581:	72 19                	jb     80359c <__udivdi3+0xfc>
  803583:	74 0b                	je     803590 <__udivdi3+0xf0>
  803585:	89 d8                	mov    %ebx,%eax
  803587:	31 ff                	xor    %edi,%edi
  803589:	e9 58 ff ff ff       	jmp    8034e6 <__udivdi3+0x46>
  80358e:	66 90                	xchg   %ax,%ax
  803590:	8b 54 24 08          	mov    0x8(%esp),%edx
  803594:	89 f9                	mov    %edi,%ecx
  803596:	d3 e2                	shl    %cl,%edx
  803598:	39 c2                	cmp    %eax,%edx
  80359a:	73 e9                	jae    803585 <__udivdi3+0xe5>
  80359c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80359f:	31 ff                	xor    %edi,%edi
  8035a1:	e9 40 ff ff ff       	jmp    8034e6 <__udivdi3+0x46>
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	31 c0                	xor    %eax,%eax
  8035aa:	e9 37 ff ff ff       	jmp    8034e6 <__udivdi3+0x46>
  8035af:	90                   	nop

008035b0 <__umoddi3>:
  8035b0:	55                   	push   %ebp
  8035b1:	57                   	push   %edi
  8035b2:	56                   	push   %esi
  8035b3:	53                   	push   %ebx
  8035b4:	83 ec 1c             	sub    $0x1c,%esp
  8035b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035cf:	89 f3                	mov    %esi,%ebx
  8035d1:	89 fa                	mov    %edi,%edx
  8035d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035d7:	89 34 24             	mov    %esi,(%esp)
  8035da:	85 c0                	test   %eax,%eax
  8035dc:	75 1a                	jne    8035f8 <__umoddi3+0x48>
  8035de:	39 f7                	cmp    %esi,%edi
  8035e0:	0f 86 a2 00 00 00    	jbe    803688 <__umoddi3+0xd8>
  8035e6:	89 c8                	mov    %ecx,%eax
  8035e8:	89 f2                	mov    %esi,%edx
  8035ea:	f7 f7                	div    %edi
  8035ec:	89 d0                	mov    %edx,%eax
  8035ee:	31 d2                	xor    %edx,%edx
  8035f0:	83 c4 1c             	add    $0x1c,%esp
  8035f3:	5b                   	pop    %ebx
  8035f4:	5e                   	pop    %esi
  8035f5:	5f                   	pop    %edi
  8035f6:	5d                   	pop    %ebp
  8035f7:	c3                   	ret    
  8035f8:	39 f0                	cmp    %esi,%eax
  8035fa:	0f 87 ac 00 00 00    	ja     8036ac <__umoddi3+0xfc>
  803600:	0f bd e8             	bsr    %eax,%ebp
  803603:	83 f5 1f             	xor    $0x1f,%ebp
  803606:	0f 84 ac 00 00 00    	je     8036b8 <__umoddi3+0x108>
  80360c:	bf 20 00 00 00       	mov    $0x20,%edi
  803611:	29 ef                	sub    %ebp,%edi
  803613:	89 fe                	mov    %edi,%esi
  803615:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803619:	89 e9                	mov    %ebp,%ecx
  80361b:	d3 e0                	shl    %cl,%eax
  80361d:	89 d7                	mov    %edx,%edi
  80361f:	89 f1                	mov    %esi,%ecx
  803621:	d3 ef                	shr    %cl,%edi
  803623:	09 c7                	or     %eax,%edi
  803625:	89 e9                	mov    %ebp,%ecx
  803627:	d3 e2                	shl    %cl,%edx
  803629:	89 14 24             	mov    %edx,(%esp)
  80362c:	89 d8                	mov    %ebx,%eax
  80362e:	d3 e0                	shl    %cl,%eax
  803630:	89 c2                	mov    %eax,%edx
  803632:	8b 44 24 08          	mov    0x8(%esp),%eax
  803636:	d3 e0                	shl    %cl,%eax
  803638:	89 44 24 04          	mov    %eax,0x4(%esp)
  80363c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803640:	89 f1                	mov    %esi,%ecx
  803642:	d3 e8                	shr    %cl,%eax
  803644:	09 d0                	or     %edx,%eax
  803646:	d3 eb                	shr    %cl,%ebx
  803648:	89 da                	mov    %ebx,%edx
  80364a:	f7 f7                	div    %edi
  80364c:	89 d3                	mov    %edx,%ebx
  80364e:	f7 24 24             	mull   (%esp)
  803651:	89 c6                	mov    %eax,%esi
  803653:	89 d1                	mov    %edx,%ecx
  803655:	39 d3                	cmp    %edx,%ebx
  803657:	0f 82 87 00 00 00    	jb     8036e4 <__umoddi3+0x134>
  80365d:	0f 84 91 00 00 00    	je     8036f4 <__umoddi3+0x144>
  803663:	8b 54 24 04          	mov    0x4(%esp),%edx
  803667:	29 f2                	sub    %esi,%edx
  803669:	19 cb                	sbb    %ecx,%ebx
  80366b:	89 d8                	mov    %ebx,%eax
  80366d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803671:	d3 e0                	shl    %cl,%eax
  803673:	89 e9                	mov    %ebp,%ecx
  803675:	d3 ea                	shr    %cl,%edx
  803677:	09 d0                	or     %edx,%eax
  803679:	89 e9                	mov    %ebp,%ecx
  80367b:	d3 eb                	shr    %cl,%ebx
  80367d:	89 da                	mov    %ebx,%edx
  80367f:	83 c4 1c             	add    $0x1c,%esp
  803682:	5b                   	pop    %ebx
  803683:	5e                   	pop    %esi
  803684:	5f                   	pop    %edi
  803685:	5d                   	pop    %ebp
  803686:	c3                   	ret    
  803687:	90                   	nop
  803688:	89 fd                	mov    %edi,%ebp
  80368a:	85 ff                	test   %edi,%edi
  80368c:	75 0b                	jne    803699 <__umoddi3+0xe9>
  80368e:	b8 01 00 00 00       	mov    $0x1,%eax
  803693:	31 d2                	xor    %edx,%edx
  803695:	f7 f7                	div    %edi
  803697:	89 c5                	mov    %eax,%ebp
  803699:	89 f0                	mov    %esi,%eax
  80369b:	31 d2                	xor    %edx,%edx
  80369d:	f7 f5                	div    %ebp
  80369f:	89 c8                	mov    %ecx,%eax
  8036a1:	f7 f5                	div    %ebp
  8036a3:	89 d0                	mov    %edx,%eax
  8036a5:	e9 44 ff ff ff       	jmp    8035ee <__umoddi3+0x3e>
  8036aa:	66 90                	xchg   %ax,%ax
  8036ac:	89 c8                	mov    %ecx,%eax
  8036ae:	89 f2                	mov    %esi,%edx
  8036b0:	83 c4 1c             	add    $0x1c,%esp
  8036b3:	5b                   	pop    %ebx
  8036b4:	5e                   	pop    %esi
  8036b5:	5f                   	pop    %edi
  8036b6:	5d                   	pop    %ebp
  8036b7:	c3                   	ret    
  8036b8:	3b 04 24             	cmp    (%esp),%eax
  8036bb:	72 06                	jb     8036c3 <__umoddi3+0x113>
  8036bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036c1:	77 0f                	ja     8036d2 <__umoddi3+0x122>
  8036c3:	89 f2                	mov    %esi,%edx
  8036c5:	29 f9                	sub    %edi,%ecx
  8036c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036cb:	89 14 24             	mov    %edx,(%esp)
  8036ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036d6:	8b 14 24             	mov    (%esp),%edx
  8036d9:	83 c4 1c             	add    $0x1c,%esp
  8036dc:	5b                   	pop    %ebx
  8036dd:	5e                   	pop    %esi
  8036de:	5f                   	pop    %edi
  8036df:	5d                   	pop    %ebp
  8036e0:	c3                   	ret    
  8036e1:	8d 76 00             	lea    0x0(%esi),%esi
  8036e4:	2b 04 24             	sub    (%esp),%eax
  8036e7:	19 fa                	sbb    %edi,%edx
  8036e9:	89 d1                	mov    %edx,%ecx
  8036eb:	89 c6                	mov    %eax,%esi
  8036ed:	e9 71 ff ff ff       	jmp    803663 <__umoddi3+0xb3>
  8036f2:	66 90                	xchg   %ax,%ax
  8036f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036f8:	72 ea                	jb     8036e4 <__umoddi3+0x134>
  8036fa:	89 d9                	mov    %ebx,%ecx
  8036fc:	e9 62 ff ff ff       	jmp    803663 <__umoddi3+0xb3>
