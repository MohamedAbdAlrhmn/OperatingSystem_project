
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
  80004d:	e8 fb 19 00 00       	call   801a4d <sys_calculate_free_frames>
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
  80007b:	e8 cd 19 00 00       	call   801a4d <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 de 19 00 00       	call   801a66 <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 80 38 80 00       	push   $0x803880
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
  8001d9:	68 a0 38 80 00       	push   $0x8038a0
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 ce 38 80 00       	push   $0x8038ce
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
  800200:	e8 48 18 00 00       	call   801a4d <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 59 18 00 00       	call   801a66 <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 51 18 00 00       	call   801a66 <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 31 18 00 00       	call   801a4d <sys_calculate_free_frames>
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
  800235:	68 e4 38 80 00       	push   $0x8038e4
  80023a:	6a 53                	push   $0x53
  80023c:	68 ce 38 80 00       	push   $0x8038ce
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 38 39 80 00       	push   $0x803938
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 94 39 80 00       	push   $0x803994
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
  8002a7:	68 78 3a 80 00       	push   $0x803a78
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 ce 38 80 00       	push   $0x8038ce
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
  8002be:	e8 6a 1a 00 00       	call   801d2d <sys_getenvindex>
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
  800329:	e8 0c 18 00 00       	call   801b3a <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 98 3b 80 00       	push   $0x803b98
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
  800359:	68 c0 3b 80 00       	push   $0x803bc0
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
  80038a:	68 e8 3b 80 00       	push   $0x803be8
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 50 80 00       	mov    0x805020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 40 3c 80 00       	push   $0x803c40
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 98 3b 80 00       	push   $0x803b98
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 8c 17 00 00       	call   801b54 <sys_enable_interrupt>

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
  8003db:	e8 19 19 00 00       	call   801cf9 <sys_destroy_env>
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
  8003ec:	e8 6e 19 00 00       	call   801d5f <sys_exit_env>
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
  800415:	68 54 3c 80 00       	push   $0x803c54
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 50 80 00       	mov    0x805000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 59 3c 80 00       	push   $0x803c59
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
  800452:	68 75 3c 80 00       	push   $0x803c75
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
  80047e:	68 78 3c 80 00       	push   $0x803c78
  800483:	6a 26                	push   $0x26
  800485:	68 c4 3c 80 00       	push   $0x803cc4
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
  800550:	68 d0 3c 80 00       	push   $0x803cd0
  800555:	6a 3a                	push   $0x3a
  800557:	68 c4 3c 80 00       	push   $0x803cc4
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
  8005c0:	68 24 3d 80 00       	push   $0x803d24
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 c4 3c 80 00       	push   $0x803cc4
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
  80061a:	e8 6d 13 00 00       	call   80198c <sys_cputs>
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
  800691:	e8 f6 12 00 00       	call   80198c <sys_cputs>
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
  8006db:	e8 5a 14 00 00       	call   801b3a <sys_disable_interrupt>
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
  8006fb:	e8 54 14 00 00       	call   801b54 <sys_enable_interrupt>
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
  800745:	e8 c6 2e 00 00       	call   803610 <__udivdi3>
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
  800795:	e8 86 2f 00 00       	call   803720 <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 94 3f 80 00       	add    $0x803f94,%eax
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
  8008f0:	8b 04 85 b8 3f 80 00 	mov    0x803fb8(,%eax,4),%eax
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
  8009d1:	8b 34 9d 00 3e 80 00 	mov    0x803e00(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 a5 3f 80 00       	push   $0x803fa5
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
  8009f6:	68 ae 3f 80 00       	push   $0x803fae
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
  800a23:	be b1 3f 80 00       	mov    $0x803fb1,%esi
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
  801449:	68 10 41 80 00       	push   $0x804110
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
  801519:	e8 b2 05 00 00       	call   801ad0 <sys_allocate_chunk>
  80151e:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801521:	a1 20 51 80 00       	mov    0x805120,%eax
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	50                   	push   %eax
  80152a:	e8 27 0c 00 00       	call   802156 <initialize_MemBlocksList>
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
  801557:	68 35 41 80 00       	push   $0x804135
  80155c:	6a 33                	push   $0x33
  80155e:	68 53 41 80 00       	push   $0x804153
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
  8015d6:	68 60 41 80 00       	push   $0x804160
  8015db:	6a 34                	push   $0x34
  8015dd:	68 53 41 80 00       	push   $0x804153
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
  80166e:	e8 2b 08 00 00       	call   801e9e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801673:	85 c0                	test   %eax,%eax
  801675:	74 11                	je     801688 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801677:	83 ec 0c             	sub    $0xc,%esp
  80167a:	ff 75 e8             	pushl  -0x18(%ebp)
  80167d:	e8 96 0e 00 00       	call   802518 <alloc_block_FF>
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
  801694:	e8 f2 0b 00 00       	call   80228b <insert_sorted_allocList>
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
  8016ae:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	83 ec 08             	sub    $0x8,%esp
  8016b7:	50                   	push   %eax
  8016b8:	68 40 50 80 00       	push   $0x805040
  8016bd:	e8 71 0b 00 00       	call   802233 <find_block>
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8016c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016cc:	0f 84 a6 00 00 00    	je     801778 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8016d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016db:	8b 40 08             	mov    0x8(%eax),%eax
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	52                   	push   %edx
  8016e2:	50                   	push   %eax
  8016e3:	e8 b0 03 00 00       	call   801a98 <sys_free_user_mem>
  8016e8:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8016eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016ef:	75 14                	jne    801705 <free+0x5a>
  8016f1:	83 ec 04             	sub    $0x4,%esp
  8016f4:	68 35 41 80 00       	push   $0x804135
  8016f9:	6a 74                	push   $0x74
  8016fb:	68 53 41 80 00       	push   $0x804153
  801700:	e8 ef ec ff ff       	call   8003f4 <_panic>
  801705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801708:	8b 00                	mov    (%eax),%eax
  80170a:	85 c0                	test   %eax,%eax
  80170c:	74 10                	je     80171e <free+0x73>
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	8b 00                	mov    (%eax),%eax
  801713:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801716:	8b 52 04             	mov    0x4(%edx),%edx
  801719:	89 50 04             	mov    %edx,0x4(%eax)
  80171c:	eb 0b                	jmp    801729 <free+0x7e>
  80171e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801721:	8b 40 04             	mov    0x4(%eax),%eax
  801724:	a3 44 50 80 00       	mov    %eax,0x805044
  801729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172c:	8b 40 04             	mov    0x4(%eax),%eax
  80172f:	85 c0                	test   %eax,%eax
  801731:	74 0f                	je     801742 <free+0x97>
  801733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801736:	8b 40 04             	mov    0x4(%eax),%eax
  801739:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173c:	8b 12                	mov    (%edx),%edx
  80173e:	89 10                	mov    %edx,(%eax)
  801740:	eb 0a                	jmp    80174c <free+0xa1>
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	8b 00                	mov    (%eax),%eax
  801747:	a3 40 50 80 00       	mov    %eax,0x805040
  80174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801758:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80175f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801764:	48                   	dec    %eax
  801765:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  80176a:	83 ec 0c             	sub    $0xc,%esp
  80176d:	ff 75 f4             	pushl  -0xc(%ebp)
  801770:	e8 4e 17 00 00       	call   802ec3 <insert_sorted_with_merge_freeList>
  801775:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801778:	90                   	nop
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 38             	sub    $0x38,%esp
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801787:	e8 a6 fc ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  80178c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801790:	75 0a                	jne    80179c <smalloc+0x21>
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
  801797:	e9 8b 00 00 00       	jmp    801827 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80179c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a9:	01 d0                	add    %edx,%eax
  8017ab:	48                   	dec    %eax
  8017ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b7:	f7 75 f0             	divl   -0x10(%ebp)
  8017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bd:	29 d0                	sub    %edx,%eax
  8017bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017c9:	e8 d0 06 00 00       	call   801e9e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	74 11                	je     8017e3 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017d2:	83 ec 0c             	sub    $0xc,%esp
  8017d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d8:	e8 3b 0d 00 00       	call   802518 <alloc_block_FF>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8017e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e7:	74 39                	je     801822 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	89 c2                	mov    %eax,%edx
  8017f1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017f5:	52                   	push   %edx
  8017f6:	50                   	push   %eax
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	ff 75 08             	pushl  0x8(%ebp)
  8017fd:	e8 21 04 00 00       	call   801c23 <sys_createSharedObject>
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801808:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80180c:	74 14                	je     801822 <smalloc+0xa7>
  80180e:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801812:	74 0e                	je     801822 <smalloc+0xa7>
  801814:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801818:	74 08                	je     801822 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80181a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181d:	8b 40 08             	mov    0x8(%eax),%eax
  801820:	eb 05                	jmp    801827 <smalloc+0xac>
	}
	return NULL;
  801822:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182f:	e8 fe fb ff ff       	call   801432 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	e8 0b 04 00 00       	call   801c4d <sys_getSizeOfSharedObject>
  801842:	83 c4 10             	add    $0x10,%esp
  801845:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801848:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80184c:	74 76                	je     8018c4 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80184e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801855:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80185b:	01 d0                	add    %edx,%eax
  80185d:	48                   	dec    %eax
  80185e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801861:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801864:	ba 00 00 00 00       	mov    $0x0,%edx
  801869:	f7 75 ec             	divl   -0x14(%ebp)
  80186c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80186f:	29 d0                	sub    %edx,%eax
  801871:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801874:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80187b:	e8 1e 06 00 00       	call   801e9e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801880:	85 c0                	test   %eax,%eax
  801882:	74 11                	je     801895 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801884:	83 ec 0c             	sub    $0xc,%esp
  801887:	ff 75 e4             	pushl  -0x1c(%ebp)
  80188a:	e8 89 0c 00 00       	call   802518 <alloc_block_FF>
  80188f:	83 c4 10             	add    $0x10,%esp
  801892:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801895:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801899:	74 29                	je     8018c4 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189e:	8b 40 08             	mov    0x8(%eax),%eax
  8018a1:	83 ec 04             	sub    $0x4,%esp
  8018a4:	50                   	push   %eax
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	ff 75 08             	pushl  0x8(%ebp)
  8018ab:	e8 ba 03 00 00       	call   801c6a <sys_getSharedObject>
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8018b6:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8018ba:	74 08                	je     8018c4 <sget+0x9b>
				return (void *)mem_block->sva;
  8018bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bf:	8b 40 08             	mov    0x8(%eax),%eax
  8018c2:	eb 05                	jmp    8018c9 <sget+0xa0>
		}
	}
	return NULL;
  8018c4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d1:	e8 5c fb ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018d6:	83 ec 04             	sub    $0x4,%esp
  8018d9:	68 84 41 80 00       	push   $0x804184
  8018de:	68 f7 00 00 00       	push   $0xf7
  8018e3:	68 53 41 80 00       	push   $0x804153
  8018e8:	e8 07 eb ff ff       	call   8003f4 <_panic>

008018ed <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018f3:	83 ec 04             	sub    $0x4,%esp
  8018f6:	68 ac 41 80 00       	push   $0x8041ac
  8018fb:	68 0c 01 00 00       	push   $0x10c
  801900:	68 53 41 80 00       	push   $0x804153
  801905:	e8 ea ea ff ff       	call   8003f4 <_panic>

0080190a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	68 d0 41 80 00       	push   $0x8041d0
  801918:	68 44 01 00 00       	push   $0x144
  80191d:	68 53 41 80 00       	push   $0x804153
  801922:	e8 cd ea ff ff       	call   8003f4 <_panic>

00801927 <shrink>:

}
void shrink(uint32 newSize)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	68 d0 41 80 00       	push   $0x8041d0
  801935:	68 49 01 00 00       	push   $0x149
  80193a:	68 53 41 80 00       	push   $0x804153
  80193f:	e8 b0 ea ff ff       	call   8003f4 <_panic>

00801944 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	68 d0 41 80 00       	push   $0x8041d0
  801952:	68 4e 01 00 00       	push   $0x14e
  801957:	68 53 41 80 00       	push   $0x804153
  80195c:	e8 93 ea ff ff       	call   8003f4 <_panic>

00801961 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	57                   	push   %edi
  801965:	56                   	push   %esi
  801966:	53                   	push   %ebx
  801967:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801970:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801973:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801976:	8b 7d 18             	mov    0x18(%ebp),%edi
  801979:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80197c:	cd 30                	int    $0x30
  80197e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801981:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	5b                   	pop    %ebx
  801988:	5e                   	pop    %esi
  801989:	5f                   	pop    %edi
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    

0080198c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	8b 45 10             	mov    0x10(%ebp),%eax
  801995:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801998:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	52                   	push   %edx
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	50                   	push   %eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	e8 b2 ff ff ff       	call   801961 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 01                	push   $0x1
  8019c4:	e8 98 ff ff ff       	call   801961 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	52                   	push   %edx
  8019de:	50                   	push   %eax
  8019df:	6a 05                	push   $0x5
  8019e1:	e8 7b ff ff ff       	call   801961 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	56                   	push   %esi
  8019ef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019f0:	8b 75 18             	mov    0x18(%ebp),%esi
  8019f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	56                   	push   %esi
  801a00:	53                   	push   %ebx
  801a01:	51                   	push   %ecx
  801a02:	52                   	push   %edx
  801a03:	50                   	push   %eax
  801a04:	6a 06                	push   $0x6
  801a06:	e8 56 ff ff ff       	call   801961 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    

00801a15 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	52                   	push   %edx
  801a25:	50                   	push   %eax
  801a26:	6a 07                	push   $0x7
  801a28:	e8 34 ff ff ff       	call   801961 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	ff 75 08             	pushl  0x8(%ebp)
  801a41:	6a 08                	push   $0x8
  801a43:	e8 19 ff ff ff       	call   801961 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 09                	push   $0x9
  801a5c:	e8 00 ff ff ff       	call   801961 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 0a                	push   $0xa
  801a75:	e8 e7 fe ff ff       	call   801961 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 0b                	push   $0xb
  801a8e:	e8 ce fe ff ff       	call   801961 <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 0c             	pushl  0xc(%ebp)
  801aa4:	ff 75 08             	pushl  0x8(%ebp)
  801aa7:	6a 0f                	push   $0xf
  801aa9:	e8 b3 fe ff ff       	call   801961 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
	return;
  801ab1:	90                   	nop
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	ff 75 08             	pushl  0x8(%ebp)
  801ac3:	6a 10                	push   $0x10
  801ac5:	e8 97 fe ff ff       	call   801961 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
	return ;
  801acd:	90                   	nop
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	ff 75 10             	pushl  0x10(%ebp)
  801ada:	ff 75 0c             	pushl  0xc(%ebp)
  801add:	ff 75 08             	pushl  0x8(%ebp)
  801ae0:	6a 11                	push   $0x11
  801ae2:	e8 7a fe ff ff       	call   801961 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aea:	90                   	nop
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 0c                	push   $0xc
  801afc:	e8 60 fe ff ff       	call   801961 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	ff 75 08             	pushl  0x8(%ebp)
  801b14:	6a 0d                	push   $0xd
  801b16:	e8 46 fe ff ff       	call   801961 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 0e                	push   $0xe
  801b2f:	e8 2d fe ff ff       	call   801961 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	90                   	nop
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 13                	push   $0x13
  801b49:	e8 13 fe ff ff       	call   801961 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	90                   	nop
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 14                	push   $0x14
  801b63:	e8 f9 fd ff ff       	call   801961 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	90                   	nop
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_cputc>:


void
sys_cputc(const char c)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	50                   	push   %eax
  801b87:	6a 15                	push   $0x15
  801b89:	e8 d3 fd ff ff       	call   801961 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	90                   	nop
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 16                	push   $0x16
  801ba3:	e8 b9 fd ff ff       	call   801961 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	50                   	push   %eax
  801bbe:	6a 17                	push   $0x17
  801bc0:	e8 9c fd ff ff       	call   801961 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	52                   	push   %edx
  801bda:	50                   	push   %eax
  801bdb:	6a 1a                	push   $0x1a
  801bdd:	e8 7f fd ff ff       	call   801961 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	52                   	push   %edx
  801bf7:	50                   	push   %eax
  801bf8:	6a 18                	push   $0x18
  801bfa:	e8 62 fd ff ff       	call   801961 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	90                   	nop
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	52                   	push   %edx
  801c15:	50                   	push   %eax
  801c16:	6a 19                	push   $0x19
  801c18:	e8 44 fd ff ff       	call   801961 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	90                   	nop
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c32:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	6a 00                	push   $0x0
  801c3b:	51                   	push   %ecx
  801c3c:	52                   	push   %edx
  801c3d:	ff 75 0c             	pushl  0xc(%ebp)
  801c40:	50                   	push   %eax
  801c41:	6a 1b                	push   $0x1b
  801c43:	e8 19 fd ff ff       	call   801961 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	52                   	push   %edx
  801c5d:	50                   	push   %eax
  801c5e:	6a 1c                	push   $0x1c
  801c60:	e8 fc fc ff ff       	call   801961 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	51                   	push   %ecx
  801c7b:	52                   	push   %edx
  801c7c:	50                   	push   %eax
  801c7d:	6a 1d                	push   $0x1d
  801c7f:	e8 dd fc ff ff       	call   801961 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	6a 1e                	push   $0x1e
  801c9c:	e8 c0 fc ff ff       	call   801961 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 1f                	push   $0x1f
  801cb5:	e8 a7 fc ff ff       	call   801961 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	ff 75 14             	pushl  0x14(%ebp)
  801cca:	ff 75 10             	pushl  0x10(%ebp)
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	50                   	push   %eax
  801cd1:	6a 20                	push   $0x20
  801cd3:	e8 89 fc ff ff       	call   801961 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	50                   	push   %eax
  801cec:	6a 21                	push   $0x21
  801cee:	e8 6e fc ff ff       	call   801961 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	90                   	nop
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	50                   	push   %eax
  801d08:	6a 22                	push   $0x22
  801d0a:	e8 52 fc ff ff       	call   801961 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 02                	push   $0x2
  801d23:	e8 39 fc ff ff       	call   801961 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 03                	push   $0x3
  801d3c:	e8 20 fc ff ff       	call   801961 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 04                	push   $0x4
  801d55:	e8 07 fc ff ff       	call   801961 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_exit_env>:


void sys_exit_env(void)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 23                	push   $0x23
  801d6e:	e8 ee fb ff ff       	call   801961 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	90                   	nop
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d7f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d82:	8d 50 04             	lea    0x4(%eax),%edx
  801d85:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	52                   	push   %edx
  801d8f:	50                   	push   %eax
  801d90:	6a 24                	push   $0x24
  801d92:	e8 ca fb ff ff       	call   801961 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
	return result;
  801d9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801da0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801da3:	89 01                	mov    %eax,(%ecx)
  801da5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	c9                   	leave  
  801dac:	c2 04 00             	ret    $0x4

00801daf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	ff 75 10             	pushl  0x10(%ebp)
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	ff 75 08             	pushl  0x8(%ebp)
  801dbf:	6a 12                	push   $0x12
  801dc1:	e8 9b fb ff ff       	call   801961 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc9:	90                   	nop
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_rcr2>:
uint32 sys_rcr2()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 25                	push   $0x25
  801ddb:	e8 81 fb ff ff       	call   801961 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 04             	sub    $0x4,%esp
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801df1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	50                   	push   %eax
  801dfe:	6a 26                	push   $0x26
  801e00:	e8 5c fb ff ff       	call   801961 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
	return ;
  801e08:	90                   	nop
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <rsttst>:
void rsttst()
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 28                	push   $0x28
  801e1a:	e8 42 fb ff ff       	call   801961 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e22:	90                   	nop
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 04             	sub    $0x4,%esp
  801e2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801e2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e31:	8b 55 18             	mov    0x18(%ebp),%edx
  801e34:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e38:	52                   	push   %edx
  801e39:	50                   	push   %eax
  801e3a:	ff 75 10             	pushl  0x10(%ebp)
  801e3d:	ff 75 0c             	pushl  0xc(%ebp)
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	6a 27                	push   $0x27
  801e45:	e8 17 fb ff ff       	call   801961 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4d:	90                   	nop
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <chktst>:
void chktst(uint32 n)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	ff 75 08             	pushl  0x8(%ebp)
  801e5e:	6a 29                	push   $0x29
  801e60:	e8 fc fa ff ff       	call   801961 <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
	return ;
  801e68:	90                   	nop
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <inctst>:

void inctst()
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 2a                	push   $0x2a
  801e7a:	e8 e2 fa ff ff       	call   801961 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e82:	90                   	nop
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <gettst>:
uint32 gettst()
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 2b                	push   $0x2b
  801e94:	e8 c8 fa ff ff       	call   801961 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 2c                	push   $0x2c
  801eb0:	e8 ac fa ff ff       	call   801961 <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
  801eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ebb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ebf:	75 07                	jne    801ec8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ec1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec6:	eb 05                	jmp    801ecd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 2c                	push   $0x2c
  801ee1:	e8 7b fa ff ff       	call   801961 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
  801ee9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eec:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ef0:	75 07                	jne    801ef9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef7:	eb 05                	jmp    801efe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 2c                	push   $0x2c
  801f12:	e8 4a fa ff ff       	call   801961 <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
  801f1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f1d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f21:	75 07                	jne    801f2a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f23:	b8 01 00 00 00       	mov    $0x1,%eax
  801f28:	eb 05                	jmp    801f2f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 2c                	push   $0x2c
  801f43:	e8 19 fa ff ff       	call   801961 <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
  801f4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f4e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f52:	75 07                	jne    801f5b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f54:	b8 01 00 00 00       	mov    $0x1,%eax
  801f59:	eb 05                	jmp    801f60 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	6a 2d                	push   $0x2d
  801f72:	e8 ea f9 ff ff       	call   801961 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7a:	90                   	nop
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f81:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	6a 00                	push   $0x0
  801f8f:	53                   	push   %ebx
  801f90:	51                   	push   %ecx
  801f91:	52                   	push   %edx
  801f92:	50                   	push   %eax
  801f93:	6a 2e                	push   $0x2e
  801f95:	e8 c7 f9 ff ff       	call   801961 <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
}
  801f9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	52                   	push   %edx
  801fb2:	50                   	push   %eax
  801fb3:	6a 2f                	push   $0x2f
  801fb5:	e8 a7 f9 ff ff       	call   801961 <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	68 e0 41 80 00       	push   $0x8041e0
  801fcd:	e8 d6 e6 ff ff       	call   8006a8 <cprintf>
  801fd2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fd5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fdc:	83 ec 0c             	sub    $0xc,%esp
  801fdf:	68 0c 42 80 00       	push   $0x80420c
  801fe4:	e8 bf e6 ff ff       	call   8006a8 <cprintf>
  801fe9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fec:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ff0:	a1 38 51 80 00       	mov    0x805138,%eax
  801ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff8:	eb 56                	jmp    802050 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ffa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ffe:	74 1c                	je     80201c <print_mem_block_lists+0x5d>
  802000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802003:	8b 50 08             	mov    0x8(%eax),%edx
  802006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802009:	8b 48 08             	mov    0x8(%eax),%ecx
  80200c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200f:	8b 40 0c             	mov    0xc(%eax),%eax
  802012:	01 c8                	add    %ecx,%eax
  802014:	39 c2                	cmp    %eax,%edx
  802016:	73 04                	jae    80201c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802018:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	8b 50 08             	mov    0x8(%eax),%edx
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 40 0c             	mov    0xc(%eax),%eax
  802028:	01 c2                	add    %eax,%edx
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 40 08             	mov    0x8(%eax),%eax
  802030:	83 ec 04             	sub    $0x4,%esp
  802033:	52                   	push   %edx
  802034:	50                   	push   %eax
  802035:	68 21 42 80 00       	push   $0x804221
  80203a:	e8 69 e6 ff ff       	call   8006a8 <cprintf>
  80203f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802048:	a1 40 51 80 00       	mov    0x805140,%eax
  80204d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802050:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802054:	74 07                	je     80205d <print_mem_block_lists+0x9e>
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	8b 00                	mov    (%eax),%eax
  80205b:	eb 05                	jmp    802062 <print_mem_block_lists+0xa3>
  80205d:	b8 00 00 00 00       	mov    $0x0,%eax
  802062:	a3 40 51 80 00       	mov    %eax,0x805140
  802067:	a1 40 51 80 00       	mov    0x805140,%eax
  80206c:	85 c0                	test   %eax,%eax
  80206e:	75 8a                	jne    801ffa <print_mem_block_lists+0x3b>
  802070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802074:	75 84                	jne    801ffa <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802076:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80207a:	75 10                	jne    80208c <print_mem_block_lists+0xcd>
  80207c:	83 ec 0c             	sub    $0xc,%esp
  80207f:	68 30 42 80 00       	push   $0x804230
  802084:	e8 1f e6 ff ff       	call   8006a8 <cprintf>
  802089:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80208c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	68 54 42 80 00       	push   $0x804254
  80209b:	e8 08 e6 ff ff       	call   8006a8 <cprintf>
  8020a0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020a3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020a7:	a1 40 50 80 00       	mov    0x805040,%eax
  8020ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020af:	eb 56                	jmp    802107 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b5:	74 1c                	je     8020d3 <print_mem_block_lists+0x114>
  8020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ba:	8b 50 08             	mov    0x8(%eax),%edx
  8020bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c0:	8b 48 08             	mov    0x8(%eax),%ecx
  8020c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c9:	01 c8                	add    %ecx,%eax
  8020cb:	39 c2                	cmp    %eax,%edx
  8020cd:	73 04                	jae    8020d3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020cf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	8b 50 08             	mov    0x8(%eax),%edx
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8020df:	01 c2                	add    %eax,%edx
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 40 08             	mov    0x8(%eax),%eax
  8020e7:	83 ec 04             	sub    $0x4,%esp
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	68 21 42 80 00       	push   $0x804221
  8020f1:	e8 b2 e5 ff ff       	call   8006a8 <cprintf>
  8020f6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020ff:	a1 48 50 80 00       	mov    0x805048,%eax
  802104:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210b:	74 07                	je     802114 <print_mem_block_lists+0x155>
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 00                	mov    (%eax),%eax
  802112:	eb 05                	jmp    802119 <print_mem_block_lists+0x15a>
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
  802119:	a3 48 50 80 00       	mov    %eax,0x805048
  80211e:	a1 48 50 80 00       	mov    0x805048,%eax
  802123:	85 c0                	test   %eax,%eax
  802125:	75 8a                	jne    8020b1 <print_mem_block_lists+0xf2>
  802127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212b:	75 84                	jne    8020b1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80212d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802131:	75 10                	jne    802143 <print_mem_block_lists+0x184>
  802133:	83 ec 0c             	sub    $0xc,%esp
  802136:	68 6c 42 80 00       	push   $0x80426c
  80213b:	e8 68 e5 ff ff       	call   8006a8 <cprintf>
  802140:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802143:	83 ec 0c             	sub    $0xc,%esp
  802146:	68 e0 41 80 00       	push   $0x8041e0
  80214b:	e8 58 e5 ff ff       	call   8006a8 <cprintf>
  802150:	83 c4 10             	add    $0x10,%esp

}
  802153:	90                   	nop
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80215c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802163:	00 00 00 
  802166:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80216d:	00 00 00 
  802170:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802177:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80217a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802181:	e9 9e 00 00 00       	jmp    802224 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802186:	a1 50 50 80 00       	mov    0x805050,%eax
  80218b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218e:	c1 e2 04             	shl    $0x4,%edx
  802191:	01 d0                	add    %edx,%eax
  802193:	85 c0                	test   %eax,%eax
  802195:	75 14                	jne    8021ab <initialize_MemBlocksList+0x55>
  802197:	83 ec 04             	sub    $0x4,%esp
  80219a:	68 94 42 80 00       	push   $0x804294
  80219f:	6a 46                	push   $0x46
  8021a1:	68 b7 42 80 00       	push   $0x8042b7
  8021a6:	e8 49 e2 ff ff       	call   8003f4 <_panic>
  8021ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8021b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b3:	c1 e2 04             	shl    $0x4,%edx
  8021b6:	01 d0                	add    %edx,%eax
  8021b8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021be:	89 10                	mov    %edx,(%eax)
  8021c0:	8b 00                	mov    (%eax),%eax
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	74 18                	je     8021de <initialize_MemBlocksList+0x88>
  8021c6:	a1 48 51 80 00       	mov    0x805148,%eax
  8021cb:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021d1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021d4:	c1 e1 04             	shl    $0x4,%ecx
  8021d7:	01 ca                	add    %ecx,%edx
  8021d9:	89 50 04             	mov    %edx,0x4(%eax)
  8021dc:	eb 12                	jmp    8021f0 <initialize_MemBlocksList+0x9a>
  8021de:	a1 50 50 80 00       	mov    0x805050,%eax
  8021e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e6:	c1 e2 04             	shl    $0x4,%edx
  8021e9:	01 d0                	add    %edx,%eax
  8021eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8021f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f8:	c1 e2 04             	shl    $0x4,%edx
  8021fb:	01 d0                	add    %edx,%eax
  8021fd:	a3 48 51 80 00       	mov    %eax,0x805148
  802202:	a1 50 50 80 00       	mov    0x805050,%eax
  802207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220a:	c1 e2 04             	shl    $0x4,%edx
  80220d:	01 d0                	add    %edx,%eax
  80220f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802216:	a1 54 51 80 00       	mov    0x805154,%eax
  80221b:	40                   	inc    %eax
  80221c:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802221:	ff 45 f4             	incl   -0xc(%ebp)
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	3b 45 08             	cmp    0x8(%ebp),%eax
  80222a:	0f 82 56 ff ff ff    	jb     802186 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802230:	90                   	nop
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802241:	eb 19                	jmp    80225c <find_block+0x29>
	{
		if(va==point->sva)
  802243:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802246:	8b 40 08             	mov    0x8(%eax),%eax
  802249:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80224c:	75 05                	jne    802253 <find_block+0x20>
		   return point;
  80224e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802251:	eb 36                	jmp    802289 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	8b 40 08             	mov    0x8(%eax),%eax
  802259:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80225c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802260:	74 07                	je     802269 <find_block+0x36>
  802262:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802265:	8b 00                	mov    (%eax),%eax
  802267:	eb 05                	jmp    80226e <find_block+0x3b>
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	8b 55 08             	mov    0x8(%ebp),%edx
  802271:	89 42 08             	mov    %eax,0x8(%edx)
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	8b 40 08             	mov    0x8(%eax),%eax
  80227a:	85 c0                	test   %eax,%eax
  80227c:	75 c5                	jne    802243 <find_block+0x10>
  80227e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802282:	75 bf                	jne    802243 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802291:	a1 40 50 80 00       	mov    0x805040,%eax
  802296:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802299:	a1 44 50 80 00       	mov    0x805044,%eax
  80229e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8022a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022a7:	74 24                	je     8022cd <insert_sorted_allocList+0x42>
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	8b 50 08             	mov    0x8(%eax),%edx
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	8b 40 08             	mov    0x8(%eax),%eax
  8022b5:	39 c2                	cmp    %eax,%edx
  8022b7:	76 14                	jbe    8022cd <insert_sorted_allocList+0x42>
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	8b 50 08             	mov    0x8(%eax),%edx
  8022bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c2:	8b 40 08             	mov    0x8(%eax),%eax
  8022c5:	39 c2                	cmp    %eax,%edx
  8022c7:	0f 82 60 01 00 00    	jb     80242d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d1:	75 65                	jne    802338 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d7:	75 14                	jne    8022ed <insert_sorted_allocList+0x62>
  8022d9:	83 ec 04             	sub    $0x4,%esp
  8022dc:	68 94 42 80 00       	push   $0x804294
  8022e1:	6a 6b                	push   $0x6b
  8022e3:	68 b7 42 80 00       	push   $0x8042b7
  8022e8:	e8 07 e1 ff ff       	call   8003f4 <_panic>
  8022ed:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	89 10                	mov    %edx,(%eax)
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	85 c0                	test   %eax,%eax
  8022ff:	74 0d                	je     80230e <insert_sorted_allocList+0x83>
  802301:	a1 40 50 80 00       	mov    0x805040,%eax
  802306:	8b 55 08             	mov    0x8(%ebp),%edx
  802309:	89 50 04             	mov    %edx,0x4(%eax)
  80230c:	eb 08                	jmp    802316 <insert_sorted_allocList+0x8b>
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	a3 44 50 80 00       	mov    %eax,0x805044
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	a3 40 50 80 00       	mov    %eax,0x805040
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802328:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80232d:	40                   	inc    %eax
  80232e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802333:	e9 dc 01 00 00       	jmp    802514 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	8b 50 08             	mov    0x8(%eax),%edx
  80233e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802341:	8b 40 08             	mov    0x8(%eax),%eax
  802344:	39 c2                	cmp    %eax,%edx
  802346:	77 6c                	ja     8023b4 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802348:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80234c:	74 06                	je     802354 <insert_sorted_allocList+0xc9>
  80234e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802352:	75 14                	jne    802368 <insert_sorted_allocList+0xdd>
  802354:	83 ec 04             	sub    $0x4,%esp
  802357:	68 d0 42 80 00       	push   $0x8042d0
  80235c:	6a 6f                	push   $0x6f
  80235e:	68 b7 42 80 00       	push   $0x8042b7
  802363:	e8 8c e0 ff ff       	call   8003f4 <_panic>
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	8b 50 04             	mov    0x4(%eax),%edx
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	89 50 04             	mov    %edx,0x4(%eax)
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80237a:	89 10                	mov    %edx,(%eax)
  80237c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237f:	8b 40 04             	mov    0x4(%eax),%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	74 0d                	je     802393 <insert_sorted_allocList+0x108>
  802386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802389:	8b 40 04             	mov    0x4(%eax),%eax
  80238c:	8b 55 08             	mov    0x8(%ebp),%edx
  80238f:	89 10                	mov    %edx,(%eax)
  802391:	eb 08                	jmp    80239b <insert_sorted_allocList+0x110>
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	a3 40 50 80 00       	mov    %eax,0x805040
  80239b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239e:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a1:	89 50 04             	mov    %edx,0x4(%eax)
  8023a4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023a9:	40                   	inc    %eax
  8023aa:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023af:	e9 60 01 00 00       	jmp    802514 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	8b 50 08             	mov    0x8(%eax),%edx
  8023ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bd:	8b 40 08             	mov    0x8(%eax),%eax
  8023c0:	39 c2                	cmp    %eax,%edx
  8023c2:	0f 82 4c 01 00 00    	jb     802514 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023cc:	75 14                	jne    8023e2 <insert_sorted_allocList+0x157>
  8023ce:	83 ec 04             	sub    $0x4,%esp
  8023d1:	68 08 43 80 00       	push   $0x804308
  8023d6:	6a 73                	push   $0x73
  8023d8:	68 b7 42 80 00       	push   $0x8042b7
  8023dd:	e8 12 e0 ff ff       	call   8003f4 <_panic>
  8023e2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	89 50 04             	mov    %edx,0x4(%eax)
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	8b 40 04             	mov    0x4(%eax),%eax
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	74 0c                	je     802404 <insert_sorted_allocList+0x179>
  8023f8:	a1 44 50 80 00       	mov    0x805044,%eax
  8023fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802400:	89 10                	mov    %edx,(%eax)
  802402:	eb 08                	jmp    80240c <insert_sorted_allocList+0x181>
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	a3 40 50 80 00       	mov    %eax,0x805040
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	a3 44 50 80 00       	mov    %eax,0x805044
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802422:	40                   	inc    %eax
  802423:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802428:	e9 e7 00 00 00       	jmp    802514 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80242d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802430:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802433:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80243a:	a1 40 50 80 00       	mov    0x805040,%eax
  80243f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802442:	e9 9d 00 00 00       	jmp    8024e4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	8b 50 08             	mov    0x8(%eax),%edx
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 08             	mov    0x8(%eax),%eax
  80245b:	39 c2                	cmp    %eax,%edx
  80245d:	76 7d                	jbe    8024dc <insert_sorted_allocList+0x251>
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	8b 50 08             	mov    0x8(%eax),%edx
  802465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802468:	8b 40 08             	mov    0x8(%eax),%eax
  80246b:	39 c2                	cmp    %eax,%edx
  80246d:	73 6d                	jae    8024dc <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80246f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802473:	74 06                	je     80247b <insert_sorted_allocList+0x1f0>
  802475:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802479:	75 14                	jne    80248f <insert_sorted_allocList+0x204>
  80247b:	83 ec 04             	sub    $0x4,%esp
  80247e:	68 2c 43 80 00       	push   $0x80432c
  802483:	6a 7f                	push   $0x7f
  802485:	68 b7 42 80 00       	push   $0x8042b7
  80248a:	e8 65 df ff ff       	call   8003f4 <_panic>
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 10                	mov    (%eax),%edx
  802494:	8b 45 08             	mov    0x8(%ebp),%eax
  802497:	89 10                	mov    %edx,(%eax)
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	74 0b                	je     8024ad <insert_sorted_allocList+0x222>
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8024aa:	89 50 04             	mov    %edx,0x4(%eax)
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b3:	89 10                	mov    %edx,(%eax)
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bb:	89 50 04             	mov    %edx,0x4(%eax)
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	75 08                	jne    8024cf <insert_sorted_allocList+0x244>
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	a3 44 50 80 00       	mov    %eax,0x805044
  8024cf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d4:	40                   	inc    %eax
  8024d5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024da:	eb 39                	jmp    802515 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024dc:	a1 48 50 80 00       	mov    0x805048,%eax
  8024e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e8:	74 07                	je     8024f1 <insert_sorted_allocList+0x266>
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 00                	mov    (%eax),%eax
  8024ef:	eb 05                	jmp    8024f6 <insert_sorted_allocList+0x26b>
  8024f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f6:	a3 48 50 80 00       	mov    %eax,0x805048
  8024fb:	a1 48 50 80 00       	mov    0x805048,%eax
  802500:	85 c0                	test   %eax,%eax
  802502:	0f 85 3f ff ff ff    	jne    802447 <insert_sorted_allocList+0x1bc>
  802508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250c:	0f 85 35 ff ff ff    	jne    802447 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802512:	eb 01                	jmp    802515 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802514:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802515:	90                   	nop
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80251e:	a1 38 51 80 00       	mov    0x805138,%eax
  802523:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802526:	e9 85 01 00 00       	jmp    8026b0 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 40 0c             	mov    0xc(%eax),%eax
  802531:	3b 45 08             	cmp    0x8(%ebp),%eax
  802534:	0f 82 6e 01 00 00    	jb     8026a8 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 0c             	mov    0xc(%eax),%eax
  802540:	3b 45 08             	cmp    0x8(%ebp),%eax
  802543:	0f 85 8a 00 00 00    	jne    8025d3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254d:	75 17                	jne    802566 <alloc_block_FF+0x4e>
  80254f:	83 ec 04             	sub    $0x4,%esp
  802552:	68 60 43 80 00       	push   $0x804360
  802557:	68 93 00 00 00       	push   $0x93
  80255c:	68 b7 42 80 00       	push   $0x8042b7
  802561:	e8 8e de ff ff       	call   8003f4 <_panic>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 10                	je     80257f <alloc_block_FF+0x67>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 00                	mov    (%eax),%eax
  802574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802577:	8b 52 04             	mov    0x4(%edx),%edx
  80257a:	89 50 04             	mov    %edx,0x4(%eax)
  80257d:	eb 0b                	jmp    80258a <alloc_block_FF+0x72>
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 04             	mov    0x4(%eax),%eax
  802585:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 40 04             	mov    0x4(%eax),%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	74 0f                	je     8025a3 <alloc_block_FF+0x8b>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 40 04             	mov    0x4(%eax),%eax
  80259a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259d:	8b 12                	mov    (%edx),%edx
  80259f:	89 10                	mov    %edx,(%eax)
  8025a1:	eb 0a                	jmp    8025ad <alloc_block_FF+0x95>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8025c5:	48                   	dec    %eax
  8025c6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	e9 10 01 00 00       	jmp    8026e3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025dc:	0f 86 c6 00 00 00    	jbe    8026a8 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8025e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 50 08             	mov    0x8(%eax),%edx
  8025f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fc:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802603:	75 17                	jne    80261c <alloc_block_FF+0x104>
  802605:	83 ec 04             	sub    $0x4,%esp
  802608:	68 60 43 80 00       	push   $0x804360
  80260d:	68 9b 00 00 00       	push   $0x9b
  802612:	68 b7 42 80 00       	push   $0x8042b7
  802617:	e8 d8 dd ff ff       	call   8003f4 <_panic>
  80261c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 10                	je     802635 <alloc_block_FF+0x11d>
  802625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80262d:	8b 52 04             	mov    0x4(%edx),%edx
  802630:	89 50 04             	mov    %edx,0x4(%eax)
  802633:	eb 0b                	jmp    802640 <alloc_block_FF+0x128>
  802635:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802643:	8b 40 04             	mov    0x4(%eax),%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	74 0f                	je     802659 <alloc_block_FF+0x141>
  80264a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802653:	8b 12                	mov    (%edx),%edx
  802655:	89 10                	mov    %edx,(%eax)
  802657:	eb 0a                	jmp    802663 <alloc_block_FF+0x14b>
  802659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	a3 48 51 80 00       	mov    %eax,0x805148
  802663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802676:	a1 54 51 80 00       	mov    0x805154,%eax
  80267b:	48                   	dec    %eax
  80267c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 50 08             	mov    0x8(%eax),%edx
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	01 c2                	add    %eax,%edx
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 0c             	mov    0xc(%eax),%eax
  802698:	2b 45 08             	sub    0x8(%ebp),%eax
  80269b:	89 c2                	mov    %eax,%edx
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a6:	eb 3b                	jmp    8026e3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8026ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b4:	74 07                	je     8026bd <alloc_block_FF+0x1a5>
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	8b 00                	mov    (%eax),%eax
  8026bb:	eb 05                	jmp    8026c2 <alloc_block_FF+0x1aa>
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c2:	a3 40 51 80 00       	mov    %eax,0x805140
  8026c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	0f 85 57 fe ff ff    	jne    80252b <alloc_block_FF+0x13>
  8026d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d8:	0f 85 4d fe ff ff    	jne    80252b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026eb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8026f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fa:	e9 df 00 00 00       	jmp    8027de <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 0c             	mov    0xc(%eax),%eax
  802705:	3b 45 08             	cmp    0x8(%ebp),%eax
  802708:	0f 82 c8 00 00 00    	jb     8027d6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 40 0c             	mov    0xc(%eax),%eax
  802714:	3b 45 08             	cmp    0x8(%ebp),%eax
  802717:	0f 85 8a 00 00 00    	jne    8027a7 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80271d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802721:	75 17                	jne    80273a <alloc_block_BF+0x55>
  802723:	83 ec 04             	sub    $0x4,%esp
  802726:	68 60 43 80 00       	push   $0x804360
  80272b:	68 b7 00 00 00       	push   $0xb7
  802730:	68 b7 42 80 00       	push   $0x8042b7
  802735:	e8 ba dc ff ff       	call   8003f4 <_panic>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	85 c0                	test   %eax,%eax
  802741:	74 10                	je     802753 <alloc_block_BF+0x6e>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274b:	8b 52 04             	mov    0x4(%edx),%edx
  80274e:	89 50 04             	mov    %edx,0x4(%eax)
  802751:	eb 0b                	jmp    80275e <alloc_block_BF+0x79>
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 04             	mov    0x4(%eax),%eax
  802759:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 40 04             	mov    0x4(%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 0f                	je     802777 <alloc_block_BF+0x92>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 04             	mov    0x4(%eax),%eax
  80276e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802771:	8b 12                	mov    (%edx),%edx
  802773:	89 10                	mov    %edx,(%eax)
  802775:	eb 0a                	jmp    802781 <alloc_block_BF+0x9c>
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	a3 38 51 80 00       	mov    %eax,0x805138
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802794:	a1 44 51 80 00       	mov    0x805144,%eax
  802799:	48                   	dec    %eax
  80279a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	e9 4d 01 00 00       	jmp    8028f4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b0:	76 24                	jbe    8027d6 <alloc_block_BF+0xf1>
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027bb:	73 19                	jae    8027d6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8027bd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 40 08             	mov    0x8(%eax),%eax
  8027d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8027db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e2:	74 07                	je     8027eb <alloc_block_BF+0x106>
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 00                	mov    (%eax),%eax
  8027e9:	eb 05                	jmp    8027f0 <alloc_block_BF+0x10b>
  8027eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f0:	a3 40 51 80 00       	mov    %eax,0x805140
  8027f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8027fa:	85 c0                	test   %eax,%eax
  8027fc:	0f 85 fd fe ff ff    	jne    8026ff <alloc_block_BF+0x1a>
  802802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802806:	0f 85 f3 fe ff ff    	jne    8026ff <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80280c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802810:	0f 84 d9 00 00 00    	je     8028ef <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802816:	a1 48 51 80 00       	mov    0x805148,%eax
  80281b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80281e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802821:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802824:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282a:	8b 55 08             	mov    0x8(%ebp),%edx
  80282d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802830:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802834:	75 17                	jne    80284d <alloc_block_BF+0x168>
  802836:	83 ec 04             	sub    $0x4,%esp
  802839:	68 60 43 80 00       	push   $0x804360
  80283e:	68 c7 00 00 00       	push   $0xc7
  802843:	68 b7 42 80 00       	push   $0x8042b7
  802848:	e8 a7 db ff ff       	call   8003f4 <_panic>
  80284d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	85 c0                	test   %eax,%eax
  802854:	74 10                	je     802866 <alloc_block_BF+0x181>
  802856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802859:	8b 00                	mov    (%eax),%eax
  80285b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80285e:	8b 52 04             	mov    0x4(%edx),%edx
  802861:	89 50 04             	mov    %edx,0x4(%eax)
  802864:	eb 0b                	jmp    802871 <alloc_block_BF+0x18c>
  802866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802869:	8b 40 04             	mov    0x4(%eax),%eax
  80286c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802874:	8b 40 04             	mov    0x4(%eax),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	74 0f                	je     80288a <alloc_block_BF+0x1a5>
  80287b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287e:	8b 40 04             	mov    0x4(%eax),%eax
  802881:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802884:	8b 12                	mov    (%edx),%edx
  802886:	89 10                	mov    %edx,(%eax)
  802888:	eb 0a                	jmp    802894 <alloc_block_BF+0x1af>
  80288a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288d:	8b 00                	mov    (%eax),%eax
  80288f:	a3 48 51 80 00       	mov    %eax,0x805148
  802894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802897:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8028ac:	48                   	dec    %eax
  8028ad:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028b2:	83 ec 08             	sub    $0x8,%esp
  8028b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8028b8:	68 38 51 80 00       	push   $0x805138
  8028bd:	e8 71 f9 ff ff       	call   802233 <find_block>
  8028c2:	83 c4 10             	add    $0x10,%esp
  8028c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cb:	8b 50 08             	mov    0x8(%eax),%edx
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	01 c2                	add    %eax,%edx
  8028d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028df:	2b 45 08             	sub    0x8(%ebp),%eax
  8028e2:	89 c2                	mov    %eax,%edx
  8028e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ed:	eb 05                	jmp    8028f4 <alloc_block_BF+0x20f>
	}
	return NULL;
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    

008028f6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028f6:	55                   	push   %ebp
  8028f7:	89 e5                	mov    %esp,%ebp
  8028f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028fc:	a1 28 50 80 00       	mov    0x805028,%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	0f 85 de 01 00 00    	jne    802ae7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802909:	a1 38 51 80 00       	mov    0x805138,%eax
  80290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802911:	e9 9e 01 00 00       	jmp    802ab4 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 40 0c             	mov    0xc(%eax),%eax
  80291c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291f:	0f 82 87 01 00 00    	jb     802aac <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 40 0c             	mov    0xc(%eax),%eax
  80292b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292e:	0f 85 95 00 00 00    	jne    8029c9 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802938:	75 17                	jne    802951 <alloc_block_NF+0x5b>
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	68 60 43 80 00       	push   $0x804360
  802942:	68 e0 00 00 00       	push   $0xe0
  802947:	68 b7 42 80 00       	push   $0x8042b7
  80294c:	e8 a3 da ff ff       	call   8003f4 <_panic>
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 10                	je     80296a <alloc_block_NF+0x74>
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 00                	mov    (%eax),%eax
  80295f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802962:	8b 52 04             	mov    0x4(%edx),%edx
  802965:	89 50 04             	mov    %edx,0x4(%eax)
  802968:	eb 0b                	jmp    802975 <alloc_block_NF+0x7f>
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 40 04             	mov    0x4(%eax),%eax
  802970:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 0f                	je     80298e <alloc_block_NF+0x98>
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 40 04             	mov    0x4(%eax),%eax
  802985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802988:	8b 12                	mov    (%edx),%edx
  80298a:	89 10                	mov    %edx,(%eax)
  80298c:	eb 0a                	jmp    802998 <alloc_block_NF+0xa2>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	a3 38 51 80 00       	mov    %eax,0x805138
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b0:	48                   	dec    %eax
  8029b1:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 40 08             	mov    0x8(%eax),%eax
  8029bc:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	e9 f8 04 00 00       	jmp    802ec1 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d2:	0f 86 d4 00 00 00    	jbe    802aac <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8029dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 50 08             	mov    0x8(%eax),%edx
  8029e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f9:	75 17                	jne    802a12 <alloc_block_NF+0x11c>
  8029fb:	83 ec 04             	sub    $0x4,%esp
  8029fe:	68 60 43 80 00       	push   $0x804360
  802a03:	68 e9 00 00 00       	push   $0xe9
  802a08:	68 b7 42 80 00       	push   $0x8042b7
  802a0d:	e8 e2 d9 ff ff       	call   8003f4 <_panic>
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 10                	je     802a2b <alloc_block_NF+0x135>
  802a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a23:	8b 52 04             	mov    0x4(%edx),%edx
  802a26:	89 50 04             	mov    %edx,0x4(%eax)
  802a29:	eb 0b                	jmp    802a36 <alloc_block_NF+0x140>
  802a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2e:	8b 40 04             	mov    0x4(%eax),%eax
  802a31:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a39:	8b 40 04             	mov    0x4(%eax),%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	74 0f                	je     802a4f <alloc_block_NF+0x159>
  802a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a49:	8b 12                	mov    (%edx),%edx
  802a4b:	89 10                	mov    %edx,(%eax)
  802a4d:	eb 0a                	jmp    802a59 <alloc_block_NF+0x163>
  802a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	a3 48 51 80 00       	mov    %eax,0x805148
  802a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6c:	a1 54 51 80 00       	mov    0x805154,%eax
  802a71:	48                   	dec    %eax
  802a72:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7a:	8b 40 08             	mov    0x8(%eax),%eax
  802a7d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 50 08             	mov    0x8(%eax),%edx
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	01 c2                	add    %eax,%edx
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 40 0c             	mov    0xc(%eax),%eax
  802a99:	2b 45 08             	sub    0x8(%ebp),%eax
  802a9c:	89 c2                	mov    %eax,%edx
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa7:	e9 15 04 00 00       	jmp    802ec1 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802aac:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab8:	74 07                	je     802ac1 <alloc_block_NF+0x1cb>
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	eb 05                	jmp    802ac6 <alloc_block_NF+0x1d0>
  802ac1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac6:	a3 40 51 80 00       	mov    %eax,0x805140
  802acb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	0f 85 3e fe ff ff    	jne    802916 <alloc_block_NF+0x20>
  802ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adc:	0f 85 34 fe ff ff    	jne    802916 <alloc_block_NF+0x20>
  802ae2:	e9 d5 03 00 00       	jmp    802ebc <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ae7:	a1 38 51 80 00       	mov    0x805138,%eax
  802aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aef:	e9 b1 01 00 00       	jmp    802ca5 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 50 08             	mov    0x8(%eax),%edx
  802afa:	a1 28 50 80 00       	mov    0x805028,%eax
  802aff:	39 c2                	cmp    %eax,%edx
  802b01:	0f 82 96 01 00 00    	jb     802c9d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b10:	0f 82 87 01 00 00    	jb     802c9d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1f:	0f 85 95 00 00 00    	jne    802bba <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b29:	75 17                	jne    802b42 <alloc_block_NF+0x24c>
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	68 60 43 80 00       	push   $0x804360
  802b33:	68 fc 00 00 00       	push   $0xfc
  802b38:	68 b7 42 80 00       	push   $0x8042b7
  802b3d:	e8 b2 d8 ff ff       	call   8003f4 <_panic>
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 10                	je     802b5b <alloc_block_NF+0x265>
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b53:	8b 52 04             	mov    0x4(%edx),%edx
  802b56:	89 50 04             	mov    %edx,0x4(%eax)
  802b59:	eb 0b                	jmp    802b66 <alloc_block_NF+0x270>
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 40 04             	mov    0x4(%eax),%eax
  802b61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 40 04             	mov    0x4(%eax),%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	74 0f                	je     802b7f <alloc_block_NF+0x289>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b79:	8b 12                	mov    (%edx),%edx
  802b7b:	89 10                	mov    %edx,(%eax)
  802b7d:	eb 0a                	jmp    802b89 <alloc_block_NF+0x293>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	a3 38 51 80 00       	mov    %eax,0x805138
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba1:	48                   	dec    %eax
  802ba2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 40 08             	mov    0x8(%eax),%eax
  802bad:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	e9 07 03 00 00       	jmp    802ec1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc3:	0f 86 d4 00 00 00    	jbe    802c9d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bc9:	a1 48 51 80 00       	mov    0x805148,%eax
  802bce:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 50 08             	mov    0x8(%eax),%edx
  802bd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bda:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be0:	8b 55 08             	mov    0x8(%ebp),%edx
  802be3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802be6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bea:	75 17                	jne    802c03 <alloc_block_NF+0x30d>
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	68 60 43 80 00       	push   $0x804360
  802bf4:	68 04 01 00 00       	push   $0x104
  802bf9:	68 b7 42 80 00       	push   $0x8042b7
  802bfe:	e8 f1 d7 ff ff       	call   8003f4 <_panic>
  802c03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 10                	je     802c1c <alloc_block_NF+0x326>
  802c0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0f:	8b 00                	mov    (%eax),%eax
  802c11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c14:	8b 52 04             	mov    0x4(%edx),%edx
  802c17:	89 50 04             	mov    %edx,0x4(%eax)
  802c1a:	eb 0b                	jmp    802c27 <alloc_block_NF+0x331>
  802c1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2a:	8b 40 04             	mov    0x4(%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 0f                	je     802c40 <alloc_block_NF+0x34a>
  802c31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c34:	8b 40 04             	mov    0x4(%eax),%eax
  802c37:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c3a:	8b 12                	mov    (%edx),%edx
  802c3c:	89 10                	mov    %edx,(%eax)
  802c3e:	eb 0a                	jmp    802c4a <alloc_block_NF+0x354>
  802c40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	a3 48 51 80 00       	mov    %eax,0x805148
  802c4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5d:	a1 54 51 80 00       	mov    0x805154,%eax
  802c62:	48                   	dec    %eax
  802c63:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6b:	8b 40 08             	mov    0x8(%eax),%eax
  802c6e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 50 08             	mov    0x8(%eax),%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	01 c2                	add    %eax,%edx
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8a:	2b 45 08             	sub    0x8(%ebp),%eax
  802c8d:	89 c2                	mov    %eax,%edx
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c98:	e9 24 02 00 00       	jmp    802ec1 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c9d:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca9:	74 07                	je     802cb2 <alloc_block_NF+0x3bc>
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 00                	mov    (%eax),%eax
  802cb0:	eb 05                	jmp    802cb7 <alloc_block_NF+0x3c1>
  802cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb7:	a3 40 51 80 00       	mov    %eax,0x805140
  802cbc:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	0f 85 2b fe ff ff    	jne    802af4 <alloc_block_NF+0x1fe>
  802cc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccd:	0f 85 21 fe ff ff    	jne    802af4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cd3:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cdb:	e9 ae 01 00 00       	jmp    802e8e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 50 08             	mov    0x8(%eax),%edx
  802ce6:	a1 28 50 80 00       	mov    0x805028,%eax
  802ceb:	39 c2                	cmp    %eax,%edx
  802ced:	0f 83 93 01 00 00    	jae    802e86 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cfc:	0f 82 84 01 00 00    	jb     802e86 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	8b 40 0c             	mov    0xc(%eax),%eax
  802d08:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d0b:	0f 85 95 00 00 00    	jne    802da6 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d15:	75 17                	jne    802d2e <alloc_block_NF+0x438>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 60 43 80 00       	push   $0x804360
  802d1f:	68 14 01 00 00       	push   $0x114
  802d24:	68 b7 42 80 00       	push   $0x8042b7
  802d29:	e8 c6 d6 ff ff       	call   8003f4 <_panic>
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 10                	je     802d47 <alloc_block_NF+0x451>
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3f:	8b 52 04             	mov    0x4(%edx),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	eb 0b                	jmp    802d52 <alloc_block_NF+0x45c>
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 0f                	je     802d6b <alloc_block_NF+0x475>
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d65:	8b 12                	mov    (%edx),%edx
  802d67:	89 10                	mov    %edx,(%eax)
  802d69:	eb 0a                	jmp    802d75 <alloc_block_NF+0x47f>
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	a3 38 51 80 00       	mov    %eax,0x805138
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d88:	a1 44 51 80 00       	mov    0x805144,%eax
  802d8d:	48                   	dec    %eax
  802d8e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	8b 40 08             	mov    0x8(%eax),%eax
  802d99:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	e9 1b 01 00 00       	jmp    802ec1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dac:	3b 45 08             	cmp    0x8(%ebp),%eax
  802daf:	0f 86 d1 00 00 00    	jbe    802e86 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802db5:	a1 48 51 80 00       	mov    0x805148,%eax
  802dba:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 50 08             	mov    0x8(%eax),%edx
  802dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcf:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dd6:	75 17                	jne    802def <alloc_block_NF+0x4f9>
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	68 60 43 80 00       	push   $0x804360
  802de0:	68 1c 01 00 00       	push   $0x11c
  802de5:	68 b7 42 80 00       	push   $0x8042b7
  802dea:	e8 05 d6 ff ff       	call   8003f4 <_panic>
  802def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	74 10                	je     802e08 <alloc_block_NF+0x512>
  802df8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e00:	8b 52 04             	mov    0x4(%edx),%edx
  802e03:	89 50 04             	mov    %edx,0x4(%eax)
  802e06:	eb 0b                	jmp    802e13 <alloc_block_NF+0x51d>
  802e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0b:	8b 40 04             	mov    0x4(%eax),%eax
  802e0e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e16:	8b 40 04             	mov    0x4(%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 0f                	je     802e2c <alloc_block_NF+0x536>
  802e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e26:	8b 12                	mov    (%edx),%edx
  802e28:	89 10                	mov    %edx,(%eax)
  802e2a:	eb 0a                	jmp    802e36 <alloc_block_NF+0x540>
  802e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	a3 48 51 80 00       	mov    %eax,0x805148
  802e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e49:	a1 54 51 80 00       	mov    0x805154,%eax
  802e4e:	48                   	dec    %eax
  802e4f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e57:	8b 40 08             	mov    0x8(%eax),%eax
  802e5a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	8b 50 08             	mov    0x8(%eax),%edx
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	01 c2                	add    %eax,%edx
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 40 0c             	mov    0xc(%eax),%eax
  802e76:	2b 45 08             	sub    0x8(%ebp),%eax
  802e79:	89 c2                	mov    %eax,%edx
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e84:	eb 3b                	jmp    802ec1 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e86:	a1 40 51 80 00       	mov    0x805140,%eax
  802e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e92:	74 07                	je     802e9b <alloc_block_NF+0x5a5>
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 00                	mov    (%eax),%eax
  802e99:	eb 05                	jmp    802ea0 <alloc_block_NF+0x5aa>
  802e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea0:	a3 40 51 80 00       	mov    %eax,0x805140
  802ea5:	a1 40 51 80 00       	mov    0x805140,%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	0f 85 2e fe ff ff    	jne    802ce0 <alloc_block_NF+0x3ea>
  802eb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb6:	0f 85 24 fe ff ff    	jne    802ce0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ebc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ec1:	c9                   	leave  
  802ec2:	c3                   	ret    

00802ec3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ec3:	55                   	push   %ebp
  802ec4:	89 e5                	mov    %esp,%ebp
  802ec6:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ec9:	a1 38 51 80 00       	mov    0x805138,%eax
  802ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ed1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ed9:	a1 38 51 80 00       	mov    0x805138,%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	74 14                	je     802ef6 <insert_sorted_with_merge_freeList+0x33>
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 50 08             	mov    0x8(%eax),%edx
  802ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eeb:	8b 40 08             	mov    0x8(%eax),%eax
  802eee:	39 c2                	cmp    %eax,%edx
  802ef0:	0f 87 9b 01 00 00    	ja     803091 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ef6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efa:	75 17                	jne    802f13 <insert_sorted_with_merge_freeList+0x50>
  802efc:	83 ec 04             	sub    $0x4,%esp
  802eff:	68 94 42 80 00       	push   $0x804294
  802f04:	68 38 01 00 00       	push   $0x138
  802f09:	68 b7 42 80 00       	push   $0x8042b7
  802f0e:	e8 e1 d4 ff ff       	call   8003f4 <_panic>
  802f13:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	89 10                	mov    %edx,(%eax)
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 0d                	je     802f34 <insert_sorted_with_merge_freeList+0x71>
  802f27:	a1 38 51 80 00       	mov    0x805138,%eax
  802f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2f:	89 50 04             	mov    %edx,0x4(%eax)
  802f32:	eb 08                	jmp    802f3c <insert_sorted_with_merge_freeList+0x79>
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	a3 38 51 80 00       	mov    %eax,0x805138
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f53:	40                   	inc    %eax
  802f54:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5d:	0f 84 a8 06 00 00    	je     80360b <insert_sorted_with_merge_freeList+0x748>
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	8b 50 08             	mov    0x8(%eax),%edx
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6f:	01 c2                	add    %eax,%edx
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	8b 40 08             	mov    0x8(%eax),%eax
  802f77:	39 c2                	cmp    %eax,%edx
  802f79:	0f 85 8c 06 00 00    	jne    80360b <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 50 0c             	mov    0xc(%eax),%edx
  802f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	01 c2                	add    %eax,%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f97:	75 17                	jne    802fb0 <insert_sorted_with_merge_freeList+0xed>
  802f99:	83 ec 04             	sub    $0x4,%esp
  802f9c:	68 60 43 80 00       	push   $0x804360
  802fa1:	68 3c 01 00 00       	push   $0x13c
  802fa6:	68 b7 42 80 00       	push   $0x8042b7
  802fab:	e8 44 d4 ff ff       	call   8003f4 <_panic>
  802fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 10                	je     802fc9 <insert_sorted_with_merge_freeList+0x106>
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	8b 00                	mov    (%eax),%eax
  802fbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc1:	8b 52 04             	mov    0x4(%edx),%edx
  802fc4:	89 50 04             	mov    %edx,0x4(%eax)
  802fc7:	eb 0b                	jmp    802fd4 <insert_sorted_with_merge_freeList+0x111>
  802fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcc:	8b 40 04             	mov    0x4(%eax),%eax
  802fcf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd7:	8b 40 04             	mov    0x4(%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	74 0f                	je     802fed <insert_sorted_with_merge_freeList+0x12a>
  802fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe1:	8b 40 04             	mov    0x4(%eax),%eax
  802fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe7:	8b 12                	mov    (%edx),%edx
  802fe9:	89 10                	mov    %edx,(%eax)
  802feb:	eb 0a                	jmp    802ff7 <insert_sorted_with_merge_freeList+0x134>
  802fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803003:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300a:	a1 44 51 80 00       	mov    0x805144,%eax
  80300f:	48                   	dec    %eax
  803010:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803018:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803022:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803029:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302d:	75 17                	jne    803046 <insert_sorted_with_merge_freeList+0x183>
  80302f:	83 ec 04             	sub    $0x4,%esp
  803032:	68 94 42 80 00       	push   $0x804294
  803037:	68 3f 01 00 00       	push   $0x13f
  80303c:	68 b7 42 80 00       	push   $0x8042b7
  803041:	e8 ae d3 ff ff       	call   8003f4 <_panic>
  803046:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80304c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304f:	89 10                	mov    %edx,(%eax)
  803051:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	74 0d                	je     803067 <insert_sorted_with_merge_freeList+0x1a4>
  80305a:	a1 48 51 80 00       	mov    0x805148,%eax
  80305f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803062:	89 50 04             	mov    %edx,0x4(%eax)
  803065:	eb 08                	jmp    80306f <insert_sorted_with_merge_freeList+0x1ac>
  803067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	a3 48 51 80 00       	mov    %eax,0x805148
  803077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803081:	a1 54 51 80 00       	mov    0x805154,%eax
  803086:	40                   	inc    %eax
  803087:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80308c:	e9 7a 05 00 00       	jmp    80360b <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	8b 50 08             	mov    0x8(%eax),%edx
  803097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309a:	8b 40 08             	mov    0x8(%eax),%eax
  80309d:	39 c2                	cmp    %eax,%edx
  80309f:	0f 82 14 01 00 00    	jb     8031b9 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8030a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a8:	8b 50 08             	mov    0x8(%eax),%edx
  8030ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b1:	01 c2                	add    %eax,%edx
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	8b 40 08             	mov    0x8(%eax),%eax
  8030b9:	39 c2                	cmp    %eax,%edx
  8030bb:	0f 85 90 00 00 00    	jne    803151 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cd:	01 c2                	add    %eax,%edx
  8030cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ed:	75 17                	jne    803106 <insert_sorted_with_merge_freeList+0x243>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 94 42 80 00       	push   $0x804294
  8030f7:	68 49 01 00 00       	push   $0x149
  8030fc:	68 b7 42 80 00       	push   $0x8042b7
  803101:	e8 ee d2 ff ff       	call   8003f4 <_panic>
  803106:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	89 10                	mov    %edx,(%eax)
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	85 c0                	test   %eax,%eax
  803118:	74 0d                	je     803127 <insert_sorted_with_merge_freeList+0x264>
  80311a:	a1 48 51 80 00       	mov    0x805148,%eax
  80311f:	8b 55 08             	mov    0x8(%ebp),%edx
  803122:	89 50 04             	mov    %edx,0x4(%eax)
  803125:	eb 08                	jmp    80312f <insert_sorted_with_merge_freeList+0x26c>
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	a3 48 51 80 00       	mov    %eax,0x805148
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803141:	a1 54 51 80 00       	mov    0x805154,%eax
  803146:	40                   	inc    %eax
  803147:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80314c:	e9 bb 04 00 00       	jmp    80360c <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803151:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803155:	75 17                	jne    80316e <insert_sorted_with_merge_freeList+0x2ab>
  803157:	83 ec 04             	sub    $0x4,%esp
  80315a:	68 08 43 80 00       	push   $0x804308
  80315f:	68 4c 01 00 00       	push   $0x14c
  803164:	68 b7 42 80 00       	push   $0x8042b7
  803169:	e8 86 d2 ff ff       	call   8003f4 <_panic>
  80316e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	89 50 04             	mov    %edx,0x4(%eax)
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 40 04             	mov    0x4(%eax),%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	74 0c                	je     803190 <insert_sorted_with_merge_freeList+0x2cd>
  803184:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803189:	8b 55 08             	mov    0x8(%ebp),%edx
  80318c:	89 10                	mov    %edx,(%eax)
  80318e:	eb 08                	jmp    803198 <insert_sorted_with_merge_freeList+0x2d5>
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	a3 38 51 80 00       	mov    %eax,0x805138
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ae:	40                   	inc    %eax
  8031af:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031b4:	e9 53 04 00 00       	jmp    80360c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8031be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c1:	e9 15 04 00 00       	jmp    8035db <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	8b 50 08             	mov    0x8(%eax),%edx
  8031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d7:	8b 40 08             	mov    0x8(%eax),%eax
  8031da:	39 c2                	cmp    %eax,%edx
  8031dc:	0f 86 f1 03 00 00    	jbe    8035d3 <insert_sorted_with_merge_freeList+0x710>
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	8b 50 08             	mov    0x8(%eax),%edx
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	8b 40 08             	mov    0x8(%eax),%eax
  8031ee:	39 c2                	cmp    %eax,%edx
  8031f0:	0f 83 dd 03 00 00    	jae    8035d3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f9:	8b 50 08             	mov    0x8(%eax),%edx
  8031fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803202:	01 c2                	add    %eax,%edx
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	8b 40 08             	mov    0x8(%eax),%eax
  80320a:	39 c2                	cmp    %eax,%edx
  80320c:	0f 85 b9 01 00 00    	jne    8033cb <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803212:	8b 45 08             	mov    0x8(%ebp),%eax
  803215:	8b 50 08             	mov    0x8(%eax),%edx
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	8b 40 0c             	mov    0xc(%eax),%eax
  80321e:	01 c2                	add    %eax,%edx
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	8b 40 08             	mov    0x8(%eax),%eax
  803226:	39 c2                	cmp    %eax,%edx
  803228:	0f 85 0d 01 00 00    	jne    80333b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 50 0c             	mov    0xc(%eax),%edx
  803234:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803237:	8b 40 0c             	mov    0xc(%eax),%eax
  80323a:	01 c2                	add    %eax,%edx
  80323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803242:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803246:	75 17                	jne    80325f <insert_sorted_with_merge_freeList+0x39c>
  803248:	83 ec 04             	sub    $0x4,%esp
  80324b:	68 60 43 80 00       	push   $0x804360
  803250:	68 5c 01 00 00       	push   $0x15c
  803255:	68 b7 42 80 00       	push   $0x8042b7
  80325a:	e8 95 d1 ff ff       	call   8003f4 <_panic>
  80325f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	85 c0                	test   %eax,%eax
  803266:	74 10                	je     803278 <insert_sorted_with_merge_freeList+0x3b5>
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803270:	8b 52 04             	mov    0x4(%edx),%edx
  803273:	89 50 04             	mov    %edx,0x4(%eax)
  803276:	eb 0b                	jmp    803283 <insert_sorted_with_merge_freeList+0x3c0>
  803278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	8b 40 04             	mov    0x4(%eax),%eax
  803289:	85 c0                	test   %eax,%eax
  80328b:	74 0f                	je     80329c <insert_sorted_with_merge_freeList+0x3d9>
  80328d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803290:	8b 40 04             	mov    0x4(%eax),%eax
  803293:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803296:	8b 12                	mov    (%edx),%edx
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	eb 0a                	jmp    8032a6 <insert_sorted_with_merge_freeList+0x3e3>
  80329c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032be:	48                   	dec    %eax
  8032bf:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032dc:	75 17                	jne    8032f5 <insert_sorted_with_merge_freeList+0x432>
  8032de:	83 ec 04             	sub    $0x4,%esp
  8032e1:	68 94 42 80 00       	push   $0x804294
  8032e6:	68 5f 01 00 00       	push   $0x15f
  8032eb:	68 b7 42 80 00       	push   $0x8042b7
  8032f0:	e8 ff d0 ff ff       	call   8003f4 <_panic>
  8032f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	89 10                	mov    %edx,(%eax)
  803300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803303:	8b 00                	mov    (%eax),%eax
  803305:	85 c0                	test   %eax,%eax
  803307:	74 0d                	je     803316 <insert_sorted_with_merge_freeList+0x453>
  803309:	a1 48 51 80 00       	mov    0x805148,%eax
  80330e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803311:	89 50 04             	mov    %edx,0x4(%eax)
  803314:	eb 08                	jmp    80331e <insert_sorted_with_merge_freeList+0x45b>
  803316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803319:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80331e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803321:	a3 48 51 80 00       	mov    %eax,0x805148
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803330:	a1 54 51 80 00       	mov    0x805154,%eax
  803335:	40                   	inc    %eax
  803336:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333e:	8b 50 0c             	mov    0xc(%eax),%edx
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	8b 40 0c             	mov    0xc(%eax),%eax
  803347:	01 c2                	add    %eax,%edx
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803367:	75 17                	jne    803380 <insert_sorted_with_merge_freeList+0x4bd>
  803369:	83 ec 04             	sub    $0x4,%esp
  80336c:	68 94 42 80 00       	push   $0x804294
  803371:	68 64 01 00 00       	push   $0x164
  803376:	68 b7 42 80 00       	push   $0x8042b7
  80337b:	e8 74 d0 ff ff       	call   8003f4 <_panic>
  803380:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	89 10                	mov    %edx,(%eax)
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	85 c0                	test   %eax,%eax
  803392:	74 0d                	je     8033a1 <insert_sorted_with_merge_freeList+0x4de>
  803394:	a1 48 51 80 00       	mov    0x805148,%eax
  803399:	8b 55 08             	mov    0x8(%ebp),%edx
  80339c:	89 50 04             	mov    %edx,0x4(%eax)
  80339f:	eb 08                	jmp    8033a9 <insert_sorted_with_merge_freeList+0x4e6>
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c0:	40                   	inc    %eax
  8033c1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033c6:	e9 41 02 00 00       	jmp    80360c <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	8b 50 08             	mov    0x8(%eax),%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d7:	01 c2                	add    %eax,%edx
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	8b 40 08             	mov    0x8(%eax),%eax
  8033df:	39 c2                	cmp    %eax,%edx
  8033e1:	0f 85 7c 01 00 00    	jne    803563 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033eb:	74 06                	je     8033f3 <insert_sorted_with_merge_freeList+0x530>
  8033ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f1:	75 17                	jne    80340a <insert_sorted_with_merge_freeList+0x547>
  8033f3:	83 ec 04             	sub    $0x4,%esp
  8033f6:	68 d0 42 80 00       	push   $0x8042d0
  8033fb:	68 69 01 00 00       	push   $0x169
  803400:	68 b7 42 80 00       	push   $0x8042b7
  803405:	e8 ea cf ff ff       	call   8003f4 <_panic>
  80340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340d:	8b 50 04             	mov    0x4(%eax),%edx
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	89 50 04             	mov    %edx,0x4(%eax)
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80341c:	89 10                	mov    %edx,(%eax)
  80341e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803421:	8b 40 04             	mov    0x4(%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	74 0d                	je     803435 <insert_sorted_with_merge_freeList+0x572>
  803428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342b:	8b 40 04             	mov    0x4(%eax),%eax
  80342e:	8b 55 08             	mov    0x8(%ebp),%edx
  803431:	89 10                	mov    %edx,(%eax)
  803433:	eb 08                	jmp    80343d <insert_sorted_with_merge_freeList+0x57a>
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	a3 38 51 80 00       	mov    %eax,0x805138
  80343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803440:	8b 55 08             	mov    0x8(%ebp),%edx
  803443:	89 50 04             	mov    %edx,0x4(%eax)
  803446:	a1 44 51 80 00       	mov    0x805144,%eax
  80344b:	40                   	inc    %eax
  80344c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	8b 50 0c             	mov    0xc(%eax),%edx
  803457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345a:	8b 40 0c             	mov    0xc(%eax),%eax
  80345d:	01 c2                	add    %eax,%edx
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803465:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803469:	75 17                	jne    803482 <insert_sorted_with_merge_freeList+0x5bf>
  80346b:	83 ec 04             	sub    $0x4,%esp
  80346e:	68 60 43 80 00       	push   $0x804360
  803473:	68 6b 01 00 00       	push   $0x16b
  803478:	68 b7 42 80 00       	push   $0x8042b7
  80347d:	e8 72 cf ff ff       	call   8003f4 <_panic>
  803482:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803485:	8b 00                	mov    (%eax),%eax
  803487:	85 c0                	test   %eax,%eax
  803489:	74 10                	je     80349b <insert_sorted_with_merge_freeList+0x5d8>
  80348b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348e:	8b 00                	mov    (%eax),%eax
  803490:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803493:	8b 52 04             	mov    0x4(%edx),%edx
  803496:	89 50 04             	mov    %edx,0x4(%eax)
  803499:	eb 0b                	jmp    8034a6 <insert_sorted_with_merge_freeList+0x5e3>
  80349b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349e:	8b 40 04             	mov    0x4(%eax),%eax
  8034a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a9:	8b 40 04             	mov    0x4(%eax),%eax
  8034ac:	85 c0                	test   %eax,%eax
  8034ae:	74 0f                	je     8034bf <insert_sorted_with_merge_freeList+0x5fc>
  8034b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b3:	8b 40 04             	mov    0x4(%eax),%eax
  8034b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034b9:	8b 12                	mov    (%edx),%edx
  8034bb:	89 10                	mov    %edx,(%eax)
  8034bd:	eb 0a                	jmp    8034c9 <insert_sorted_with_merge_freeList+0x606>
  8034bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c2:	8b 00                	mov    (%eax),%eax
  8034c4:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8034e1:	48                   	dec    %eax
  8034e2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034ff:	75 17                	jne    803518 <insert_sorted_with_merge_freeList+0x655>
  803501:	83 ec 04             	sub    $0x4,%esp
  803504:	68 94 42 80 00       	push   $0x804294
  803509:	68 6e 01 00 00       	push   $0x16e
  80350e:	68 b7 42 80 00       	push   $0x8042b7
  803513:	e8 dc ce ff ff       	call   8003f4 <_panic>
  803518:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80351e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803521:	89 10                	mov    %edx,(%eax)
  803523:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803526:	8b 00                	mov    (%eax),%eax
  803528:	85 c0                	test   %eax,%eax
  80352a:	74 0d                	je     803539 <insert_sorted_with_merge_freeList+0x676>
  80352c:	a1 48 51 80 00       	mov    0x805148,%eax
  803531:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803534:	89 50 04             	mov    %edx,0x4(%eax)
  803537:	eb 08                	jmp    803541 <insert_sorted_with_merge_freeList+0x67e>
  803539:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803541:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803544:	a3 48 51 80 00       	mov    %eax,0x805148
  803549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803553:	a1 54 51 80 00       	mov    0x805154,%eax
  803558:	40                   	inc    %eax
  803559:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80355e:	e9 a9 00 00 00       	jmp    80360c <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803567:	74 06                	je     80356f <insert_sorted_with_merge_freeList+0x6ac>
  803569:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80356d:	75 17                	jne    803586 <insert_sorted_with_merge_freeList+0x6c3>
  80356f:	83 ec 04             	sub    $0x4,%esp
  803572:	68 2c 43 80 00       	push   $0x80432c
  803577:	68 73 01 00 00       	push   $0x173
  80357c:	68 b7 42 80 00       	push   $0x8042b7
  803581:	e8 6e ce ff ff       	call   8003f4 <_panic>
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	8b 10                	mov    (%eax),%edx
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	89 10                	mov    %edx,(%eax)
  803590:	8b 45 08             	mov    0x8(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	74 0b                	je     8035a4 <insert_sorted_with_merge_freeList+0x6e1>
  803599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359c:	8b 00                	mov    (%eax),%eax
  80359e:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a1:	89 50 04             	mov    %edx,0x4(%eax)
  8035a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8035aa:	89 10                	mov    %edx,(%eax)
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b2:	89 50 04             	mov    %edx,0x4(%eax)
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	8b 00                	mov    (%eax),%eax
  8035ba:	85 c0                	test   %eax,%eax
  8035bc:	75 08                	jne    8035c6 <insert_sorted_with_merge_freeList+0x703>
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035c6:	a1 44 51 80 00       	mov    0x805144,%eax
  8035cb:	40                   	inc    %eax
  8035cc:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035d1:	eb 39                	jmp    80360c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8035d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035df:	74 07                	je     8035e8 <insert_sorted_with_merge_freeList+0x725>
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	8b 00                	mov    (%eax),%eax
  8035e6:	eb 05                	jmp    8035ed <insert_sorted_with_merge_freeList+0x72a>
  8035e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ed:	a3 40 51 80 00       	mov    %eax,0x805140
  8035f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8035f7:	85 c0                	test   %eax,%eax
  8035f9:	0f 85 c7 fb ff ff    	jne    8031c6 <insert_sorted_with_merge_freeList+0x303>
  8035ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803603:	0f 85 bd fb ff ff    	jne    8031c6 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803609:	eb 01                	jmp    80360c <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80360b:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80360c:	90                   	nop
  80360d:	c9                   	leave  
  80360e:	c3                   	ret    
  80360f:	90                   	nop

00803610 <__udivdi3>:
  803610:	55                   	push   %ebp
  803611:	57                   	push   %edi
  803612:	56                   	push   %esi
  803613:	53                   	push   %ebx
  803614:	83 ec 1c             	sub    $0x1c,%esp
  803617:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80361b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80361f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803623:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803627:	89 ca                	mov    %ecx,%edx
  803629:	89 f8                	mov    %edi,%eax
  80362b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80362f:	85 f6                	test   %esi,%esi
  803631:	75 2d                	jne    803660 <__udivdi3+0x50>
  803633:	39 cf                	cmp    %ecx,%edi
  803635:	77 65                	ja     80369c <__udivdi3+0x8c>
  803637:	89 fd                	mov    %edi,%ebp
  803639:	85 ff                	test   %edi,%edi
  80363b:	75 0b                	jne    803648 <__udivdi3+0x38>
  80363d:	b8 01 00 00 00       	mov    $0x1,%eax
  803642:	31 d2                	xor    %edx,%edx
  803644:	f7 f7                	div    %edi
  803646:	89 c5                	mov    %eax,%ebp
  803648:	31 d2                	xor    %edx,%edx
  80364a:	89 c8                	mov    %ecx,%eax
  80364c:	f7 f5                	div    %ebp
  80364e:	89 c1                	mov    %eax,%ecx
  803650:	89 d8                	mov    %ebx,%eax
  803652:	f7 f5                	div    %ebp
  803654:	89 cf                	mov    %ecx,%edi
  803656:	89 fa                	mov    %edi,%edx
  803658:	83 c4 1c             	add    $0x1c,%esp
  80365b:	5b                   	pop    %ebx
  80365c:	5e                   	pop    %esi
  80365d:	5f                   	pop    %edi
  80365e:	5d                   	pop    %ebp
  80365f:	c3                   	ret    
  803660:	39 ce                	cmp    %ecx,%esi
  803662:	77 28                	ja     80368c <__udivdi3+0x7c>
  803664:	0f bd fe             	bsr    %esi,%edi
  803667:	83 f7 1f             	xor    $0x1f,%edi
  80366a:	75 40                	jne    8036ac <__udivdi3+0x9c>
  80366c:	39 ce                	cmp    %ecx,%esi
  80366e:	72 0a                	jb     80367a <__udivdi3+0x6a>
  803670:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803674:	0f 87 9e 00 00 00    	ja     803718 <__udivdi3+0x108>
  80367a:	b8 01 00 00 00       	mov    $0x1,%eax
  80367f:	89 fa                	mov    %edi,%edx
  803681:	83 c4 1c             	add    $0x1c,%esp
  803684:	5b                   	pop    %ebx
  803685:	5e                   	pop    %esi
  803686:	5f                   	pop    %edi
  803687:	5d                   	pop    %ebp
  803688:	c3                   	ret    
  803689:	8d 76 00             	lea    0x0(%esi),%esi
  80368c:	31 ff                	xor    %edi,%edi
  80368e:	31 c0                	xor    %eax,%eax
  803690:	89 fa                	mov    %edi,%edx
  803692:	83 c4 1c             	add    $0x1c,%esp
  803695:	5b                   	pop    %ebx
  803696:	5e                   	pop    %esi
  803697:	5f                   	pop    %edi
  803698:	5d                   	pop    %ebp
  803699:	c3                   	ret    
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	89 d8                	mov    %ebx,%eax
  80369e:	f7 f7                	div    %edi
  8036a0:	31 ff                	xor    %edi,%edi
  8036a2:	89 fa                	mov    %edi,%edx
  8036a4:	83 c4 1c             	add    $0x1c,%esp
  8036a7:	5b                   	pop    %ebx
  8036a8:	5e                   	pop    %esi
  8036a9:	5f                   	pop    %edi
  8036aa:	5d                   	pop    %ebp
  8036ab:	c3                   	ret    
  8036ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036b1:	89 eb                	mov    %ebp,%ebx
  8036b3:	29 fb                	sub    %edi,%ebx
  8036b5:	89 f9                	mov    %edi,%ecx
  8036b7:	d3 e6                	shl    %cl,%esi
  8036b9:	89 c5                	mov    %eax,%ebp
  8036bb:	88 d9                	mov    %bl,%cl
  8036bd:	d3 ed                	shr    %cl,%ebp
  8036bf:	89 e9                	mov    %ebp,%ecx
  8036c1:	09 f1                	or     %esi,%ecx
  8036c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036c7:	89 f9                	mov    %edi,%ecx
  8036c9:	d3 e0                	shl    %cl,%eax
  8036cb:	89 c5                	mov    %eax,%ebp
  8036cd:	89 d6                	mov    %edx,%esi
  8036cf:	88 d9                	mov    %bl,%cl
  8036d1:	d3 ee                	shr    %cl,%esi
  8036d3:	89 f9                	mov    %edi,%ecx
  8036d5:	d3 e2                	shl    %cl,%edx
  8036d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036db:	88 d9                	mov    %bl,%cl
  8036dd:	d3 e8                	shr    %cl,%eax
  8036df:	09 c2                	or     %eax,%edx
  8036e1:	89 d0                	mov    %edx,%eax
  8036e3:	89 f2                	mov    %esi,%edx
  8036e5:	f7 74 24 0c          	divl   0xc(%esp)
  8036e9:	89 d6                	mov    %edx,%esi
  8036eb:	89 c3                	mov    %eax,%ebx
  8036ed:	f7 e5                	mul    %ebp
  8036ef:	39 d6                	cmp    %edx,%esi
  8036f1:	72 19                	jb     80370c <__udivdi3+0xfc>
  8036f3:	74 0b                	je     803700 <__udivdi3+0xf0>
  8036f5:	89 d8                	mov    %ebx,%eax
  8036f7:	31 ff                	xor    %edi,%edi
  8036f9:	e9 58 ff ff ff       	jmp    803656 <__udivdi3+0x46>
  8036fe:	66 90                	xchg   %ax,%ax
  803700:	8b 54 24 08          	mov    0x8(%esp),%edx
  803704:	89 f9                	mov    %edi,%ecx
  803706:	d3 e2                	shl    %cl,%edx
  803708:	39 c2                	cmp    %eax,%edx
  80370a:	73 e9                	jae    8036f5 <__udivdi3+0xe5>
  80370c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80370f:	31 ff                	xor    %edi,%edi
  803711:	e9 40 ff ff ff       	jmp    803656 <__udivdi3+0x46>
  803716:	66 90                	xchg   %ax,%ax
  803718:	31 c0                	xor    %eax,%eax
  80371a:	e9 37 ff ff ff       	jmp    803656 <__udivdi3+0x46>
  80371f:	90                   	nop

00803720 <__umoddi3>:
  803720:	55                   	push   %ebp
  803721:	57                   	push   %edi
  803722:	56                   	push   %esi
  803723:	53                   	push   %ebx
  803724:	83 ec 1c             	sub    $0x1c,%esp
  803727:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80372b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80372f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803733:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803737:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80373b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80373f:	89 f3                	mov    %esi,%ebx
  803741:	89 fa                	mov    %edi,%edx
  803743:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803747:	89 34 24             	mov    %esi,(%esp)
  80374a:	85 c0                	test   %eax,%eax
  80374c:	75 1a                	jne    803768 <__umoddi3+0x48>
  80374e:	39 f7                	cmp    %esi,%edi
  803750:	0f 86 a2 00 00 00    	jbe    8037f8 <__umoddi3+0xd8>
  803756:	89 c8                	mov    %ecx,%eax
  803758:	89 f2                	mov    %esi,%edx
  80375a:	f7 f7                	div    %edi
  80375c:	89 d0                	mov    %edx,%eax
  80375e:	31 d2                	xor    %edx,%edx
  803760:	83 c4 1c             	add    $0x1c,%esp
  803763:	5b                   	pop    %ebx
  803764:	5e                   	pop    %esi
  803765:	5f                   	pop    %edi
  803766:	5d                   	pop    %ebp
  803767:	c3                   	ret    
  803768:	39 f0                	cmp    %esi,%eax
  80376a:	0f 87 ac 00 00 00    	ja     80381c <__umoddi3+0xfc>
  803770:	0f bd e8             	bsr    %eax,%ebp
  803773:	83 f5 1f             	xor    $0x1f,%ebp
  803776:	0f 84 ac 00 00 00    	je     803828 <__umoddi3+0x108>
  80377c:	bf 20 00 00 00       	mov    $0x20,%edi
  803781:	29 ef                	sub    %ebp,%edi
  803783:	89 fe                	mov    %edi,%esi
  803785:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803789:	89 e9                	mov    %ebp,%ecx
  80378b:	d3 e0                	shl    %cl,%eax
  80378d:	89 d7                	mov    %edx,%edi
  80378f:	89 f1                	mov    %esi,%ecx
  803791:	d3 ef                	shr    %cl,%edi
  803793:	09 c7                	or     %eax,%edi
  803795:	89 e9                	mov    %ebp,%ecx
  803797:	d3 e2                	shl    %cl,%edx
  803799:	89 14 24             	mov    %edx,(%esp)
  80379c:	89 d8                	mov    %ebx,%eax
  80379e:	d3 e0                	shl    %cl,%eax
  8037a0:	89 c2                	mov    %eax,%edx
  8037a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037a6:	d3 e0                	shl    %cl,%eax
  8037a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037b0:	89 f1                	mov    %esi,%ecx
  8037b2:	d3 e8                	shr    %cl,%eax
  8037b4:	09 d0                	or     %edx,%eax
  8037b6:	d3 eb                	shr    %cl,%ebx
  8037b8:	89 da                	mov    %ebx,%edx
  8037ba:	f7 f7                	div    %edi
  8037bc:	89 d3                	mov    %edx,%ebx
  8037be:	f7 24 24             	mull   (%esp)
  8037c1:	89 c6                	mov    %eax,%esi
  8037c3:	89 d1                	mov    %edx,%ecx
  8037c5:	39 d3                	cmp    %edx,%ebx
  8037c7:	0f 82 87 00 00 00    	jb     803854 <__umoddi3+0x134>
  8037cd:	0f 84 91 00 00 00    	je     803864 <__umoddi3+0x144>
  8037d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037d7:	29 f2                	sub    %esi,%edx
  8037d9:	19 cb                	sbb    %ecx,%ebx
  8037db:	89 d8                	mov    %ebx,%eax
  8037dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037e1:	d3 e0                	shl    %cl,%eax
  8037e3:	89 e9                	mov    %ebp,%ecx
  8037e5:	d3 ea                	shr    %cl,%edx
  8037e7:	09 d0                	or     %edx,%eax
  8037e9:	89 e9                	mov    %ebp,%ecx
  8037eb:	d3 eb                	shr    %cl,%ebx
  8037ed:	89 da                	mov    %ebx,%edx
  8037ef:	83 c4 1c             	add    $0x1c,%esp
  8037f2:	5b                   	pop    %ebx
  8037f3:	5e                   	pop    %esi
  8037f4:	5f                   	pop    %edi
  8037f5:	5d                   	pop    %ebp
  8037f6:	c3                   	ret    
  8037f7:	90                   	nop
  8037f8:	89 fd                	mov    %edi,%ebp
  8037fa:	85 ff                	test   %edi,%edi
  8037fc:	75 0b                	jne    803809 <__umoddi3+0xe9>
  8037fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803803:	31 d2                	xor    %edx,%edx
  803805:	f7 f7                	div    %edi
  803807:	89 c5                	mov    %eax,%ebp
  803809:	89 f0                	mov    %esi,%eax
  80380b:	31 d2                	xor    %edx,%edx
  80380d:	f7 f5                	div    %ebp
  80380f:	89 c8                	mov    %ecx,%eax
  803811:	f7 f5                	div    %ebp
  803813:	89 d0                	mov    %edx,%eax
  803815:	e9 44 ff ff ff       	jmp    80375e <__umoddi3+0x3e>
  80381a:	66 90                	xchg   %ax,%ax
  80381c:	89 c8                	mov    %ecx,%eax
  80381e:	89 f2                	mov    %esi,%edx
  803820:	83 c4 1c             	add    $0x1c,%esp
  803823:	5b                   	pop    %ebx
  803824:	5e                   	pop    %esi
  803825:	5f                   	pop    %edi
  803826:	5d                   	pop    %ebp
  803827:	c3                   	ret    
  803828:	3b 04 24             	cmp    (%esp),%eax
  80382b:	72 06                	jb     803833 <__umoddi3+0x113>
  80382d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803831:	77 0f                	ja     803842 <__umoddi3+0x122>
  803833:	89 f2                	mov    %esi,%edx
  803835:	29 f9                	sub    %edi,%ecx
  803837:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80383b:	89 14 24             	mov    %edx,(%esp)
  80383e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803842:	8b 44 24 04          	mov    0x4(%esp),%eax
  803846:	8b 14 24             	mov    (%esp),%edx
  803849:	83 c4 1c             	add    $0x1c,%esp
  80384c:	5b                   	pop    %ebx
  80384d:	5e                   	pop    %esi
  80384e:	5f                   	pop    %edi
  80384f:	5d                   	pop    %ebp
  803850:	c3                   	ret    
  803851:	8d 76 00             	lea    0x0(%esi),%esi
  803854:	2b 04 24             	sub    (%esp),%eax
  803857:	19 fa                	sbb    %edi,%edx
  803859:	89 d1                	mov    %edx,%ecx
  80385b:	89 c6                	mov    %eax,%esi
  80385d:	e9 71 ff ff ff       	jmp    8037d3 <__umoddi3+0xb3>
  803862:	66 90                	xchg   %ax,%ax
  803864:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803868:	72 ea                	jb     803854 <__umoddi3+0x134>
  80386a:	89 d9                	mov    %ebx,%ecx
  80386c:	e9 62 ff ff ff       	jmp    8037d3 <__umoddi3+0xb3>
