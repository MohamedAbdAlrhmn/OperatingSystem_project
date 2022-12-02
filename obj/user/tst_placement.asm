
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 b9 05 00 00       	call   8005ef <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec ac 00 00 01    	sub    $0x10000ac,%esp

	char arr[PAGE_SIZE*1024*4];

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800044:	a1 20 30 80 00       	mov    0x803020,%eax
  800049:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80004f:	8b 00                	mov    (%eax),%eax
  800051:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800054:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005c:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800061:	74 14                	je     800077 <_main+0x3f>
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	68 40 20 80 00       	push   $0x802040
  80006b:	6a 10                	push   $0x10
  80006d:	68 81 20 80 00       	push   $0x802081
  800072:	e8 b4 06 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800077:	a1 20 30 80 00       	mov    0x803020,%eax
  80007c:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800082:	83 c0 18             	add    $0x18,%eax
  800085:	8b 00                	mov    (%eax),%eax
  800087:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80008a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800092:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800097:	74 14                	je     8000ad <_main+0x75>
  800099:	83 ec 04             	sub    $0x4,%esp
  80009c:	68 40 20 80 00       	push   $0x802040
  8000a1:	6a 11                	push   $0x11
  8000a3:	68 81 20 80 00       	push   $0x802081
  8000a8:	e8 7e 06 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000b8:	83 c0 30             	add    $0x30,%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c8:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000cd:	74 14                	je     8000e3 <_main+0xab>
  8000cf:	83 ec 04             	sub    $0x4,%esp
  8000d2:	68 40 20 80 00       	push   $0x802040
  8000d7:	6a 12                	push   $0x12
  8000d9:	68 81 20 80 00       	push   $0x802081
  8000de:	e8 48 06 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e8:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000ee:	83 c0 48             	add    $0x48,%eax
  8000f1:	8b 00                	mov    (%eax),%eax
  8000f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fe:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 40 20 80 00       	push   $0x802040
  80010d:	6a 13                	push   $0x13
  80010f:	68 81 20 80 00       	push   $0x802081
  800114:	e8 12 06 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800124:	83 c0 60             	add    $0x60,%eax
  800127:	8b 00                	mov    (%eax),%eax
  800129:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80012c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80012f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800134:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 40 20 80 00       	push   $0x802040
  800143:	6a 14                	push   $0x14
  800145:	68 81 20 80 00       	push   $0x802081
  80014a:	e8 dc 05 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80014f:	a1 20 30 80 00       	mov    0x803020,%eax
  800154:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80015a:	83 c0 78             	add    $0x78,%eax
  80015d:	8b 00                	mov    (%eax),%eax
  80015f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800162:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800165:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80016a:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 40 20 80 00       	push   $0x802040
  800179:	6a 15                	push   $0x15
  80017b:	68 81 20 80 00       	push   $0x802081
  800180:	e8 a6 05 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x206000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800185:	a1 20 30 80 00       	mov    0x803020,%eax
  80018a:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800190:	05 90 00 00 00       	add    $0x90,%eax
  800195:	8b 00                	mov    (%eax),%eax
  800197:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80019a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80019d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a2:	3d 00 60 20 00       	cmp    $0x206000,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 40 20 80 00       	push   $0x802040
  8001b1:	6a 16                	push   $0x16
  8001b3:	68 81 20 80 00       	push   $0x802081
  8001b8:	e8 6e 05 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x207000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001c8:	05 a8 00 00 00       	add    $0xa8,%eax
  8001cd:	8b 00                	mov    (%eax),%eax
  8001cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8001d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001da:	3d 00 70 20 00       	cmp    $0x207000,%eax
  8001df:	74 14                	je     8001f5 <_main+0x1bd>
  8001e1:	83 ec 04             	sub    $0x4,%esp
  8001e4:	68 40 20 80 00       	push   $0x802040
  8001e9:	6a 17                	push   $0x17
  8001eb:	68 81 20 80 00       	push   $0x802081
  8001f0:	e8 36 05 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fa:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800200:	05 c0 00 00 00       	add    $0xc0,%eax
  800205:	8b 00                	mov    (%eax),%eax
  800207:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80020a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800212:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800217:	74 14                	je     80022d <_main+0x1f5>
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	68 40 20 80 00       	push   $0x802040
  800221:	6a 18                	push   $0x18
  800223:	68 81 20 80 00       	push   $0x802081
  800228:	e8 fe 04 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80022d:	a1 20 30 80 00       	mov    0x803020,%eax
  800232:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800238:	05 d8 00 00 00       	add    $0xd8,%eax
  80023d:	8b 00                	mov    (%eax),%eax
  80023f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800242:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800245:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024a:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80024f:	74 14                	je     800265 <_main+0x22d>
  800251:	83 ec 04             	sub    $0x4,%esp
  800254:	68 40 20 80 00       	push   $0x802040
  800259:	6a 19                	push   $0x19
  80025b:	68 81 20 80 00       	push   $0x802081
  800260:	e8 c6 04 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800265:	a1 20 30 80 00       	mov    0x803020,%eax
  80026a:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800270:	05 f0 00 00 00       	add    $0xf0,%eax
  800275:	8b 00                	mov    (%eax),%eax
  800277:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80027a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80027d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800282:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 40 20 80 00       	push   $0x802040
  800291:	6a 1a                	push   $0x1a
  800293:	68 81 20 80 00       	push   $0x802081
  800298:	e8 8e 04 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80029d:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002a8:	05 08 01 00 00       	add    $0x108,%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8002b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002ba:	3d 00 30 80 00       	cmp    $0x803000,%eax
  8002bf:	74 14                	je     8002d5 <_main+0x29d>
  8002c1:	83 ec 04             	sub    $0x4,%esp
  8002c4:	68 40 20 80 00       	push   $0x802040
  8002c9:	6a 1b                	push   $0x1b
  8002cb:	68 81 20 80 00       	push   $0x802081
  8002d0:	e8 56 04 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[12].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002da:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002e0:	05 20 01 00 00       	add    $0x120,%eax
  8002e5:	8b 00                	mov    (%eax),%eax
  8002e7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8002ea:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002f2:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 40 20 80 00       	push   $0x802040
  800301:	6a 1c                	push   $0x1c
  800303:	68 81 20 80 00       	push   $0x802081
  800308:	e8 1e 04 00 00       	call   80072b <_panic>

		for (int k = 13; k < 20; k++)
  80030d:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
  800314:	eb 37                	jmp    80034d <_main+0x315>
			if( myEnv->__uptr_pws[k].empty !=  1)
  800316:	a1 20 30 80 00       	mov    0x803020,%eax
  80031b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800321:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800324:	89 d0                	mov    %edx,%eax
  800326:	01 c0                	add    %eax,%eax
  800328:	01 d0                	add    %edx,%eax
  80032a:	c1 e0 03             	shl    $0x3,%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8a 40 04             	mov    0x4(%eax),%al
  800332:	3c 01                	cmp    $0x1,%al
  800334:	74 14                	je     80034a <_main+0x312>
				panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800336:	83 ec 04             	sub    $0x4,%esp
  800339:	68 40 20 80 00       	push   $0x802040
  80033e:	6a 20                	push   $0x20
  800340:	68 81 20 80 00       	push   $0x802081
  800345:	e8 e1 03 00 00       	call   80072b <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[12].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");

		for (int k = 13; k < 20; k++)
  80034a:	ff 45 e4             	incl   -0x1c(%ebp)
  80034d:	83 7d e4 13          	cmpl   $0x13,-0x1c(%ebp)
  800351:	7e c3                	jle    800316 <_main+0x2de>
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if( myEnv->page_last_WS_index !=  12)  											panic("INITIAL PAGE last index checking failed! Review size of the WS..!!");
		/*====================================*/
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800353:	e8 9d 15 00 00       	call   8018f5 <sys_pf_calculate_allocated_pages>
  800358:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int freePages = sys_calculate_free_frames();
  80035b:	e8 f5 14 00 00       	call   801855 <sys_calculate_free_frames>
  800360:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int i=0;
  800363:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for(;i<=PAGE_SIZE;i++)
  80036a:	eb 11                	jmp    80037d <_main+0x345>
	{
		arr[i] = -1;
  80036c:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  800372:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800375:	01 d0                	add    %edx,%eax
  800377:	c6 00 ff             	movb   $0xff,(%eax)
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  80037a:	ff 45 e0             	incl   -0x20(%ebp)
  80037d:	81 7d e0 00 10 00 00 	cmpl   $0x1000,-0x20(%ebp)
  800384:	7e e6                	jle    80036c <_main+0x334>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800386:	c7 45 e0 00 00 40 00 	movl   $0x400000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80038d:	eb 11                	jmp    8003a0 <_main+0x368>
	{
		arr[i] = -1;
  80038f:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  800395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80039d:	ff 45 e0             	incl   -0x20(%ebp)
  8003a0:	81 7d e0 00 10 40 00 	cmpl   $0x401000,-0x20(%ebp)
  8003a7:	7e e6                	jle    80038f <_main+0x357>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  8003a9:	c7 45 e0 00 00 80 00 	movl   $0x800000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8003b0:	eb 11                	jmp    8003c3 <_main+0x38b>
	{
		arr[i] = -1;
  8003b2:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  8003b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8003c0:	ff 45 e0             	incl   -0x20(%ebp)
  8003c3:	81 7d e0 00 10 80 00 	cmpl   $0x801000,-0x20(%ebp)
  8003ca:	7e e6                	jle    8003b2 <_main+0x37a>
	{
		arr[i] = -1;
	}

	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 98 20 80 00       	push   $0x802098
  8003d4:	e8 06 06 00 00       	call   8009df <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  8003dc:	8a 85 a4 ff ff fe    	mov    -0x100005c(%ebp),%al
  8003e2:	3c ff                	cmp    $0xff,%al
  8003e4:	74 14                	je     8003fa <_main+0x3c2>
  8003e6:	83 ec 04             	sub    $0x4,%esp
  8003e9:	68 c8 20 80 00       	push   $0x8020c8
  8003ee:	6a 3d                	push   $0x3d
  8003f0:	68 81 20 80 00       	push   $0x802081
  8003f5:	e8 31 03 00 00       	call   80072b <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8003fa:	8a 85 a4 0f 00 ff    	mov    -0xfff05c(%ebp),%al
  800400:	3c ff                	cmp    $0xff,%al
  800402:	74 14                	je     800418 <_main+0x3e0>
  800404:	83 ec 04             	sub    $0x4,%esp
  800407:	68 c8 20 80 00       	push   $0x8020c8
  80040c:	6a 3e                	push   $0x3e
  80040e:	68 81 20 80 00       	push   $0x802081
  800413:	e8 13 03 00 00       	call   80072b <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  800418:	8a 85 a4 ff 3f ff    	mov    -0xc0005c(%ebp),%al
  80041e:	3c ff                	cmp    $0xff,%al
  800420:	74 14                	je     800436 <_main+0x3fe>
  800422:	83 ec 04             	sub    $0x4,%esp
  800425:	68 c8 20 80 00       	push   $0x8020c8
  80042a:	6a 40                	push   $0x40
  80042c:	68 81 20 80 00       	push   $0x802081
  800431:	e8 f5 02 00 00       	call   80072b <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  800436:	8a 85 a4 0f 40 ff    	mov    -0xbff05c(%ebp),%al
  80043c:	3c ff                	cmp    $0xff,%al
  80043e:	74 14                	je     800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 c8 20 80 00       	push   $0x8020c8
  800448:	6a 41                	push   $0x41
  80044a:	68 81 20 80 00       	push   $0x802081
  80044f:	e8 d7 02 00 00       	call   80072b <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  800454:	8a 85 a4 ff 7f ff    	mov    -0x80005c(%ebp),%al
  80045a:	3c ff                	cmp    $0xff,%al
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 c8 20 80 00       	push   $0x8020c8
  800466:	6a 43                	push   $0x43
  800468:	68 81 20 80 00       	push   $0x802081
  80046d:	e8 b9 02 00 00       	call   80072b <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800472:	8a 85 a4 0f 80 ff    	mov    -0x7ff05c(%ebp),%al
  800478:	3c ff                	cmp    $0xff,%al
  80047a:	74 14                	je     800490 <_main+0x458>
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	68 c8 20 80 00       	push   $0x8020c8
  800484:	6a 44                	push   $0x44
  800486:	68 81 20 80 00       	push   $0x802081
  80048b:	e8 9b 02 00 00       	call   80072b <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("new stack pages are not written to Page File");
  800490:	e8 60 14 00 00       	call   8018f5 <sys_pf_calculate_allocated_pages>
  800495:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 e8 20 80 00       	push   $0x8020e8
  8004a2:	6a 47                	push   $0x47
  8004a4:	68 81 20 80 00       	push   $0x802081
  8004a9:	e8 7d 02 00 00       	call   80072b <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 7 ) panic("allocated memory size incorrect");
  8004ae:	8b 5d a4             	mov    -0x5c(%ebp),%ebx
  8004b1:	e8 9f 13 00 00       	call   801855 <sys_calculate_free_frames>
  8004b6:	29 c3                	sub    %eax,%ebx
  8004b8:	89 d8                	mov    %ebx,%eax
  8004ba:	83 f8 07             	cmp    $0x7,%eax
  8004bd:	74 14                	je     8004d3 <_main+0x49b>
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	68 18 21 80 00       	push   $0x802118
  8004c7:	6a 49                	push   $0x49
  8004c9:	68 81 20 80 00       	push   $0x802081
  8004ce:	e8 58 02 00 00       	call   80072b <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8004d3:	83 ec 0c             	sub    $0xc,%esp
  8004d6:	68 38 21 80 00       	push   $0x802138
  8004db:	e8 ff 04 00 00       	call   8009df <cprintf>
  8004e0:	83 c4 10             	add    $0x10,%esp


	uint32 expectedPages[20] = {0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,0x800000,0x801000,0x802000,0x803000,0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0};
  8004e3:	8d 85 54 ff ff fe    	lea    -0x10000ac(%ebp),%eax
  8004e9:	bb 60 22 80 00       	mov    $0x802260,%ebx
  8004ee:	ba 14 00 00 00       	mov    $0x14,%edx
  8004f3:	89 c7                	mov    %eax,%edi
  8004f5:	89 de                	mov    %ebx,%esi
  8004f7:	89 d1                	mov    %edx,%ecx
  8004f9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	cprintf("STEP B: checking WS entries ...\n");
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	68 6c 21 80 00       	push   $0x80216c
  800503:	e8 d7 04 00 00       	call   8009df <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
	{
		CheckWSWithoutLastIndex(expectedPages, 20);
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	6a 14                	push   $0x14
  800510:	8d 85 54 ff ff fe    	lea    -0x10000ac(%ebp),%eax
  800516:	50                   	push   %eax
  800517:	e8 81 02 00 00       	call   80079d <CheckWSWithoutLastIndex>
  80051c:	83 c4 10             	add    $0x10,%esp
	//		if( ROUNDDOWN(myEnv->__uptr_pws[14].virtual_address,PAGE_SIZE) !=  0xedffd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[15].virtual_address,PAGE_SIZE) !=  0xedffe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[16].virtual_address,PAGE_SIZE) !=  0xee3fd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[17].virtual_address,PAGE_SIZE) !=  0xee3fe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	cprintf("STEP B passed: WS entries test are correct\n\n\n");
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	68 90 21 80 00       	push   $0x802190
  800527:	e8 b3 04 00 00       	call   8009df <cprintf>
  80052c:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking working sets WHEN BECOMES FULL...\n");
  80052f:	83 ec 0c             	sub    $0xc,%esp
  800532:	68 c0 21 80 00       	push   $0x8021c0
  800537:	e8 a3 04 00 00       	call   8009df <cprintf>
  80053c:	83 c4 10             	add    $0x10,%esp
	{
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

		i=PAGE_SIZE*1024*3;
  80053f:	c7 45 e0 00 00 c0 00 	movl   $0xc00000,-0x20(%ebp)
		for(;i<=(PAGE_SIZE*1024*3+PAGE_SIZE);i++)
  800546:	eb 11                	jmp    800559 <_main+0x521>
		{
			arr[i] = -1;
  800548:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  80054e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800551:	01 d0                	add    %edx,%eax
  800553:	c6 00 ff             	movb   $0xff,(%eax)
	{
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3+PAGE_SIZE);i++)
  800556:	ff 45 e0             	incl   -0x20(%ebp)
  800559:	81 7d e0 00 10 c0 00 	cmpl   $0xc01000,-0x20(%ebp)
  800560:	7e e6                	jle    800548 <_main+0x510>
		{
			arr[i] = -1;
		}

		if( arr[PAGE_SIZE*1024*3] !=  -1)  panic("PLACEMENT of stack page failed");
  800562:	8a 85 a4 ff bf ff    	mov    -0x40005c(%ebp),%al
  800568:	3c ff                	cmp    $0xff,%al
  80056a:	74 14                	je     800580 <_main+0x548>
  80056c:	83 ec 04             	sub    $0x4,%esp
  80056f:	68 c8 20 80 00       	push   $0x8020c8
  800574:	6a 72                	push   $0x72
  800576:	68 81 20 80 00       	push   $0x802081
  80057b:	e8 ab 01 00 00       	call   80072b <_panic>
		if( arr[PAGE_SIZE*1024*3 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800580:	8a 85 a4 0f c0 ff    	mov    -0x3ff05c(%ebp),%al
  800586:	3c ff                	cmp    $0xff,%al
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 c8 20 80 00       	push   $0x8020c8
  800592:	6a 73                	push   $0x73
  800594:	68 81 20 80 00       	push   $0x802081
  800599:	e8 8d 01 00 00       	call   80072b <_panic>

		//expectedPages[18] = 0xee7fd000;
		expectedPages[19] = 0xee7fd000;
  80059e:	c7 85 a0 ff ff fe 00 	movl   $0xee7fd000,-0x1000060(%ebp)
  8005a5:	d0 7f ee 
		expectedPages[0] = 0xee7fe000;
  8005a8:	c7 85 54 ff ff fe 00 	movl   $0xee7fe000,-0x10000ac(%ebp)
  8005af:	e0 7f ee 
		CheckWSWithoutLastIndex(expectedPages, 20);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	6a 14                	push   $0x14
  8005b7:	8d 85 54 ff ff fe    	lea    -0x10000ac(%ebp),%eax
  8005bd:	50                   	push   %eax
  8005be:	e8 da 01 00 00       	call   80079d <CheckWSWithoutLastIndex>
  8005c3:	83 c4 10             	add    $0x10,%esp

		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 0) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

	}
	cprintf("STEP C passed: WS is FULL now\n\n\n");
  8005c6:	83 ec 0c             	sub    $0xc,%esp
  8005c9:	68 f4 21 80 00       	push   $0x8021f4
  8005ce:	e8 0c 04 00 00       	call   8009df <cprintf>
  8005d3:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT completed successfully!!\n\n\n");
  8005d6:	83 ec 0c             	sub    $0xc,%esp
  8005d9:	68 18 22 80 00       	push   $0x802218
  8005de:	e8 fc 03 00 00       	call   8009df <cprintf>
  8005e3:	83 c4 10             	add    $0x10,%esp
	return;
  8005e6:	90                   	nop
}
  8005e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005ea:	5b                   	pop    %ebx
  8005eb:	5e                   	pop    %esi
  8005ec:	5f                   	pop    %edi
  8005ed:	5d                   	pop    %ebp
  8005ee:	c3                   	ret    

008005ef <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005f5:	e8 3b 15 00 00       	call   801b35 <sys_getenvindex>
  8005fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800600:	89 d0                	mov    %edx,%eax
  800602:	c1 e0 03             	shl    $0x3,%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	01 c0                	add    %eax,%eax
  800609:	01 d0                	add    %edx,%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	01 d0                	add    %edx,%eax
  800614:	c1 e0 04             	shl    $0x4,%eax
  800617:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80061c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800621:	a1 20 30 80 00       	mov    0x803020,%eax
  800626:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80062c:	84 c0                	test   %al,%al
  80062e:	74 0f                	je     80063f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800630:	a1 20 30 80 00       	mov    0x803020,%eax
  800635:	05 5c 05 00 00       	add    $0x55c,%eax
  80063a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80063f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800643:	7e 0a                	jle    80064f <libmain+0x60>
		binaryname = argv[0];
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	8b 00                	mov    (%eax),%eax
  80064a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	ff 75 08             	pushl  0x8(%ebp)
  800658:	e8 db f9 ff ff       	call   800038 <_main>
  80065d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800660:	e8 dd 12 00 00       	call   801942 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800665:	83 ec 0c             	sub    $0xc,%esp
  800668:	68 c8 22 80 00       	push   $0x8022c8
  80066d:	e8 6d 03 00 00       	call   8009df <cprintf>
  800672:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800675:	a1 20 30 80 00       	mov    0x803020,%eax
  80067a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800680:	a1 20 30 80 00       	mov    0x803020,%eax
  800685:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80068b:	83 ec 04             	sub    $0x4,%esp
  80068e:	52                   	push   %edx
  80068f:	50                   	push   %eax
  800690:	68 f0 22 80 00       	push   $0x8022f0
  800695:	e8 45 03 00 00       	call   8009df <cprintf>
  80069a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80069d:	a1 20 30 80 00       	mov    0x803020,%eax
  8006a2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ad:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006be:	51                   	push   %ecx
  8006bf:	52                   	push   %edx
  8006c0:	50                   	push   %eax
  8006c1:	68 18 23 80 00       	push   $0x802318
  8006c6:	e8 14 03 00 00       	call   8009df <cprintf>
  8006cb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8006d3:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	50                   	push   %eax
  8006dd:	68 70 23 80 00       	push   $0x802370
  8006e2:	e8 f8 02 00 00       	call   8009df <cprintf>
  8006e7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	68 c8 22 80 00       	push   $0x8022c8
  8006f2:	e8 e8 02 00 00       	call   8009df <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006fa:	e8 5d 12 00 00       	call   80195c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006ff:	e8 19 00 00 00       	call   80071d <exit>
}
  800704:	90                   	nop
  800705:	c9                   	leave  
  800706:	c3                   	ret    

00800707 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800707:	55                   	push   %ebp
  800708:	89 e5                	mov    %esp,%ebp
  80070a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80070d:	83 ec 0c             	sub    $0xc,%esp
  800710:	6a 00                	push   $0x0
  800712:	e8 ea 13 00 00       	call   801b01 <sys_destroy_env>
  800717:	83 c4 10             	add    $0x10,%esp
}
  80071a:	90                   	nop
  80071b:	c9                   	leave  
  80071c:	c3                   	ret    

0080071d <exit>:

void
exit(void)
{
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800723:	e8 3f 14 00 00       	call   801b67 <sys_exit_env>
}
  800728:	90                   	nop
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800731:	8d 45 10             	lea    0x10(%ebp),%eax
  800734:	83 c0 04             	add    $0x4,%eax
  800737:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80073a:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80073f:	85 c0                	test   %eax,%eax
  800741:	74 16                	je     800759 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800743:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	50                   	push   %eax
  80074c:	68 84 23 80 00       	push   $0x802384
  800751:	e8 89 02 00 00       	call   8009df <cprintf>
  800756:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800759:	a1 00 30 80 00       	mov    0x803000,%eax
  80075e:	ff 75 0c             	pushl  0xc(%ebp)
  800761:	ff 75 08             	pushl  0x8(%ebp)
  800764:	50                   	push   %eax
  800765:	68 89 23 80 00       	push   $0x802389
  80076a:	e8 70 02 00 00       	call   8009df <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 f4             	pushl  -0xc(%ebp)
  80077b:	50                   	push   %eax
  80077c:	e8 f3 01 00 00       	call   800974 <vcprintf>
  800781:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	6a 00                	push   $0x0
  800789:	68 a5 23 80 00       	push   $0x8023a5
  80078e:	e8 e1 01 00 00       	call   800974 <vcprintf>
  800793:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800796:	e8 82 ff ff ff       	call   80071d <exit>

	// should not return here
	while (1) ;
  80079b:	eb fe                	jmp    80079b <_panic+0x70>

0080079d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8007a8:	8b 50 74             	mov    0x74(%eax),%edx
  8007ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ae:	39 c2                	cmp    %eax,%edx
  8007b0:	74 14                	je     8007c6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007b2:	83 ec 04             	sub    $0x4,%esp
  8007b5:	68 a8 23 80 00       	push   $0x8023a8
  8007ba:	6a 26                	push   $0x26
  8007bc:	68 f4 23 80 00       	push   $0x8023f4
  8007c1:	e8 65 ff ff ff       	call   80072b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007d4:	e9 c2 00 00 00       	jmp    80089b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	01 d0                	add    %edx,%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	85 c0                	test   %eax,%eax
  8007ec:	75 08                	jne    8007f6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007ee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007f1:	e9 a2 00 00 00       	jmp    800898 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800804:	eb 69                	jmp    80086f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800806:	a1 20 30 80 00       	mov    0x803020,%eax
  80080b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800811:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800814:	89 d0                	mov    %edx,%eax
  800816:	01 c0                	add    %eax,%eax
  800818:	01 d0                	add    %edx,%eax
  80081a:	c1 e0 03             	shl    $0x3,%eax
  80081d:	01 c8                	add    %ecx,%eax
  80081f:	8a 40 04             	mov    0x4(%eax),%al
  800822:	84 c0                	test   %al,%al
  800824:	75 46                	jne    80086c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800826:	a1 20 30 80 00       	mov    0x803020,%eax
  80082b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800831:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800834:	89 d0                	mov    %edx,%eax
  800836:	01 c0                	add    %eax,%eax
  800838:	01 d0                	add    %edx,%eax
  80083a:	c1 e0 03             	shl    $0x3,%eax
  80083d:	01 c8                	add    %ecx,%eax
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800844:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800847:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80084c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80084e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800851:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	01 c8                	add    %ecx,%eax
  80085d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085f:	39 c2                	cmp    %eax,%edx
  800861:	75 09                	jne    80086c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800863:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80086a:	eb 12                	jmp    80087e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086c:	ff 45 e8             	incl   -0x18(%ebp)
  80086f:	a1 20 30 80 00       	mov    0x803020,%eax
  800874:	8b 50 74             	mov    0x74(%eax),%edx
  800877:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087a:	39 c2                	cmp    %eax,%edx
  80087c:	77 88                	ja     800806 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80087e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800882:	75 14                	jne    800898 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800884:	83 ec 04             	sub    $0x4,%esp
  800887:	68 00 24 80 00       	push   $0x802400
  80088c:	6a 3a                	push   $0x3a
  80088e:	68 f4 23 80 00       	push   $0x8023f4
  800893:	e8 93 fe ff ff       	call   80072b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800898:	ff 45 f0             	incl   -0x10(%ebp)
  80089b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008a1:	0f 8c 32 ff ff ff    	jl     8007d9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b5:	eb 26                	jmp    8008dd <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8008bc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c5:	89 d0                	mov    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d0                	add    %edx,%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	01 c8                	add    %ecx,%eax
  8008d0:	8a 40 04             	mov    0x4(%eax),%al
  8008d3:	3c 01                	cmp    $0x1,%al
  8008d5:	75 03                	jne    8008da <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008d7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008da:	ff 45 e0             	incl   -0x20(%ebp)
  8008dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8008e2:	8b 50 74             	mov    0x74(%eax),%edx
  8008e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e8:	39 c2                	cmp    %eax,%edx
  8008ea:	77 cb                	ja     8008b7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ef:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008f2:	74 14                	je     800908 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 54 24 80 00       	push   $0x802454
  8008fc:	6a 44                	push   $0x44
  8008fe:	68 f4 23 80 00       	push   $0x8023f4
  800903:	e8 23 fe ff ff       	call   80072b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800908:	90                   	nop
  800909:	c9                   	leave  
  80090a:	c3                   	ret    

0080090b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800911:	8b 45 0c             	mov    0xc(%ebp),%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	8d 48 01             	lea    0x1(%eax),%ecx
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	89 0a                	mov    %ecx,(%edx)
  80091e:	8b 55 08             	mov    0x8(%ebp),%edx
  800921:	88 d1                	mov    %dl,%cl
  800923:	8b 55 0c             	mov    0xc(%ebp),%edx
  800926:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80092a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800934:	75 2c                	jne    800962 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800936:	a0 24 30 80 00       	mov    0x803024,%al
  80093b:	0f b6 c0             	movzbl %al,%eax
  80093e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800941:	8b 12                	mov    (%edx),%edx
  800943:	89 d1                	mov    %edx,%ecx
  800945:	8b 55 0c             	mov    0xc(%ebp),%edx
  800948:	83 c2 08             	add    $0x8,%edx
  80094b:	83 ec 04             	sub    $0x4,%esp
  80094e:	50                   	push   %eax
  80094f:	51                   	push   %ecx
  800950:	52                   	push   %edx
  800951:	e8 3e 0e 00 00       	call   801794 <sys_cputs>
  800956:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800962:	8b 45 0c             	mov    0xc(%ebp),%eax
  800965:	8b 40 04             	mov    0x4(%eax),%eax
  800968:	8d 50 01             	lea    0x1(%eax),%edx
  80096b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800971:	90                   	nop
  800972:	c9                   	leave  
  800973:	c3                   	ret    

00800974 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80097d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800984:	00 00 00 
	b.cnt = 0;
  800987:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80098e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	ff 75 08             	pushl  0x8(%ebp)
  800997:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80099d:	50                   	push   %eax
  80099e:	68 0b 09 80 00       	push   $0x80090b
  8009a3:	e8 11 02 00 00       	call   800bb9 <vprintfmt>
  8009a8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009ab:	a0 24 30 80 00       	mov    0x803024,%al
  8009b0:	0f b6 c0             	movzbl %al,%eax
  8009b3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b9:	83 ec 04             	sub    $0x4,%esp
  8009bc:	50                   	push   %eax
  8009bd:	52                   	push   %edx
  8009be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009c4:	83 c0 08             	add    $0x8,%eax
  8009c7:	50                   	push   %eax
  8009c8:	e8 c7 0d 00 00       	call   801794 <sys_cputs>
  8009cd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009d0:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009dd:	c9                   	leave  
  8009de:	c3                   	ret    

008009df <cprintf>:

int cprintf(const char *fmt, ...) {
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009e5:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	83 ec 08             	sub    $0x8,%esp
  8009f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009fb:	50                   	push   %eax
  8009fc:	e8 73 ff ff ff       	call   800974 <vcprintf>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a12:	e8 2b 0f 00 00       	call   801942 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a17:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 f4             	pushl  -0xc(%ebp)
  800a26:	50                   	push   %eax
  800a27:	e8 48 ff ff ff       	call   800974 <vcprintf>
  800a2c:	83 c4 10             	add    $0x10,%esp
  800a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a32:	e8 25 0f 00 00       	call   80195c <sys_enable_interrupt>
	return cnt;
  800a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	53                   	push   %ebx
  800a40:	83 ec 14             	sub    $0x14,%esp
  800a43:	8b 45 10             	mov    0x10(%ebp),%eax
  800a46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a49:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a4f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a52:	ba 00 00 00 00       	mov    $0x0,%edx
  800a57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5a:	77 55                	ja     800ab1 <printnum+0x75>
  800a5c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5f:	72 05                	jb     800a66 <printnum+0x2a>
  800a61:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a64:	77 4b                	ja     800ab1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a66:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a69:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a6c:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a74:	52                   	push   %edx
  800a75:	50                   	push   %eax
  800a76:	ff 75 f4             	pushl  -0xc(%ebp)
  800a79:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7c:	e8 47 13 00 00       	call   801dc8 <__udivdi3>
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	83 ec 04             	sub    $0x4,%esp
  800a87:	ff 75 20             	pushl  0x20(%ebp)
  800a8a:	53                   	push   %ebx
  800a8b:	ff 75 18             	pushl  0x18(%ebp)
  800a8e:	52                   	push   %edx
  800a8f:	50                   	push   %eax
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 a1 ff ff ff       	call   800a3c <printnum>
  800a9b:	83 c4 20             	add    $0x20,%esp
  800a9e:	eb 1a                	jmp    800aba <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	ff 75 20             	pushl  0x20(%ebp)
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	ff d0                	call   *%eax
  800aae:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ab1:	ff 4d 1c             	decl   0x1c(%ebp)
  800ab4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab8:	7f e6                	jg     800aa0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aba:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800abd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac8:	53                   	push   %ebx
  800ac9:	51                   	push   %ecx
  800aca:	52                   	push   %edx
  800acb:	50                   	push   %eax
  800acc:	e8 07 14 00 00       	call   801ed8 <__umoddi3>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	05 b4 26 80 00       	add    $0x8026b4,%eax
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	0f be c0             	movsbl %al,%eax
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 0c             	pushl  0xc(%ebp)
  800ae4:	50                   	push   %eax
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
}
  800aed:	90                   	nop
  800aee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    

00800af3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800afa:	7e 1c                	jle    800b18 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	8d 50 08             	lea    0x8(%eax),%edx
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	89 10                	mov    %edx,(%eax)
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 00                	mov    (%eax),%eax
  800b0e:	83 e8 08             	sub    $0x8,%eax
  800b11:	8b 50 04             	mov    0x4(%eax),%edx
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	eb 40                	jmp    800b58 <getuint+0x65>
	else if (lflag)
  800b18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1c:	74 1e                	je     800b3c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	8d 50 04             	lea    0x4(%eax),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	89 10                	mov    %edx,(%eax)
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	83 e8 04             	sub    $0x4,%eax
  800b33:	8b 00                	mov    (%eax),%eax
  800b35:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3a:	eb 1c                	jmp    800b58 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	8d 50 04             	lea    0x4(%eax),%edx
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 10                	mov    %edx,(%eax)
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	83 e8 04             	sub    $0x4,%eax
  800b51:	8b 00                	mov    (%eax),%eax
  800b53:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b61:	7e 1c                	jle    800b7f <getint+0x25>
		return va_arg(*ap, long long);
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	8d 50 08             	lea    0x8(%eax),%edx
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	89 10                	mov    %edx,(%eax)
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	83 e8 08             	sub    $0x8,%eax
  800b78:	8b 50 04             	mov    0x4(%eax),%edx
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	eb 38                	jmp    800bb7 <getint+0x5d>
	else if (lflag)
  800b7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b83:	74 1a                	je     800b9f <getint+0x45>
		return va_arg(*ap, long);
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	8d 50 04             	lea    0x4(%eax),%edx
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	89 10                	mov    %edx,(%eax)
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	83 e8 04             	sub    $0x4,%eax
  800b9a:	8b 00                	mov    (%eax),%eax
  800b9c:	99                   	cltd   
  800b9d:	eb 18                	jmp    800bb7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	8d 50 04             	lea    0x4(%eax),%edx
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	89 10                	mov    %edx,(%eax)
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	83 e8 04             	sub    $0x4,%eax
  800bb4:	8b 00                	mov    (%eax),%eax
  800bb6:	99                   	cltd   
}
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	56                   	push   %esi
  800bbd:	53                   	push   %ebx
  800bbe:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bc1:	eb 17                	jmp    800bda <vprintfmt+0x21>
			if (ch == '\0')
  800bc3:	85 db                	test   %ebx,%ebx
  800bc5:	0f 84 af 03 00 00    	je     800f7a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	53                   	push   %ebx
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	ff d0                	call   *%eax
  800bd7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bda:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdd:	8d 50 01             	lea    0x1(%eax),%edx
  800be0:	89 55 10             	mov    %edx,0x10(%ebp)
  800be3:	8a 00                	mov    (%eax),%al
  800be5:	0f b6 d8             	movzbl %al,%ebx
  800be8:	83 fb 25             	cmp    $0x25,%ebx
  800beb:	75 d6                	jne    800bc3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bed:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bf1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c06:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8d 50 01             	lea    0x1(%eax),%edx
  800c13:	89 55 10             	mov    %edx,0x10(%ebp)
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	0f b6 d8             	movzbl %al,%ebx
  800c1b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c1e:	83 f8 55             	cmp    $0x55,%eax
  800c21:	0f 87 2b 03 00 00    	ja     800f52 <vprintfmt+0x399>
  800c27:	8b 04 85 d8 26 80 00 	mov    0x8026d8(,%eax,4),%eax
  800c2e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c30:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c34:	eb d7                	jmp    800c0d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c36:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c3a:	eb d1                	jmp    800c0d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c46:	89 d0                	mov    %edx,%eax
  800c48:	c1 e0 02             	shl    $0x2,%eax
  800c4b:	01 d0                	add    %edx,%eax
  800c4d:	01 c0                	add    %eax,%eax
  800c4f:	01 d8                	add    %ebx,%eax
  800c51:	83 e8 30             	sub    $0x30,%eax
  800c54:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c57:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c5f:	83 fb 2f             	cmp    $0x2f,%ebx
  800c62:	7e 3e                	jle    800ca2 <vprintfmt+0xe9>
  800c64:	83 fb 39             	cmp    $0x39,%ebx
  800c67:	7f 39                	jg     800ca2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c69:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c6c:	eb d5                	jmp    800c43 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c71:	83 c0 04             	add    $0x4,%eax
  800c74:	89 45 14             	mov    %eax,0x14(%ebp)
  800c77:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7a:	83 e8 04             	sub    $0x4,%eax
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c82:	eb 1f                	jmp    800ca3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c88:	79 83                	jns    800c0d <vprintfmt+0x54>
				width = 0;
  800c8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c91:	e9 77 ff ff ff       	jmp    800c0d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c96:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c9d:	e9 6b ff ff ff       	jmp    800c0d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ca2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ca3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca7:	0f 89 60 ff ff ff    	jns    800c0d <vprintfmt+0x54>
				width = precision, precision = -1;
  800cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cb3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cba:	e9 4e ff ff ff       	jmp    800c0d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cbf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cc2:	e9 46 ff ff ff       	jmp    800c0d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cca:	83 c0 04             	add    $0x4,%eax
  800ccd:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd3:	83 e8 04             	sub    $0x4,%eax
  800cd6:	8b 00                	mov    (%eax),%eax
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	50                   	push   %eax
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	ff d0                	call   *%eax
  800ce4:	83 c4 10             	add    $0x10,%esp
			break;
  800ce7:	e9 89 02 00 00       	jmp    800f75 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cec:	8b 45 14             	mov    0x14(%ebp),%eax
  800cef:	83 c0 04             	add    $0x4,%eax
  800cf2:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cfd:	85 db                	test   %ebx,%ebx
  800cff:	79 02                	jns    800d03 <vprintfmt+0x14a>
				err = -err;
  800d01:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d03:	83 fb 64             	cmp    $0x64,%ebx
  800d06:	7f 0b                	jg     800d13 <vprintfmt+0x15a>
  800d08:	8b 34 9d 20 25 80 00 	mov    0x802520(,%ebx,4),%esi
  800d0f:	85 f6                	test   %esi,%esi
  800d11:	75 19                	jne    800d2c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d13:	53                   	push   %ebx
  800d14:	68 c5 26 80 00       	push   $0x8026c5
  800d19:	ff 75 0c             	pushl  0xc(%ebp)
  800d1c:	ff 75 08             	pushl  0x8(%ebp)
  800d1f:	e8 5e 02 00 00       	call   800f82 <printfmt>
  800d24:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d27:	e9 49 02 00 00       	jmp    800f75 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d2c:	56                   	push   %esi
  800d2d:	68 ce 26 80 00       	push   $0x8026ce
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	ff 75 08             	pushl  0x8(%ebp)
  800d38:	e8 45 02 00 00       	call   800f82 <printfmt>
  800d3d:	83 c4 10             	add    $0x10,%esp
			break;
  800d40:	e9 30 02 00 00       	jmp    800f75 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	83 c0 04             	add    $0x4,%eax
  800d4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d51:	83 e8 04             	sub    $0x4,%eax
  800d54:	8b 30                	mov    (%eax),%esi
  800d56:	85 f6                	test   %esi,%esi
  800d58:	75 05                	jne    800d5f <vprintfmt+0x1a6>
				p = "(null)";
  800d5a:	be d1 26 80 00       	mov    $0x8026d1,%esi
			if (width > 0 && padc != '-')
  800d5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d63:	7e 6d                	jle    800dd2 <vprintfmt+0x219>
  800d65:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d69:	74 67                	je     800dd2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d6e:	83 ec 08             	sub    $0x8,%esp
  800d71:	50                   	push   %eax
  800d72:	56                   	push   %esi
  800d73:	e8 0c 03 00 00       	call   801084 <strnlen>
  800d78:	83 c4 10             	add    $0x10,%esp
  800d7b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d7e:	eb 16                	jmp    800d96 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d80:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d84:	83 ec 08             	sub    $0x8,%esp
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	50                   	push   %eax
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	ff d0                	call   *%eax
  800d90:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d93:	ff 4d e4             	decl   -0x1c(%ebp)
  800d96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d9a:	7f e4                	jg     800d80 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d9c:	eb 34                	jmp    800dd2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800da2:	74 1c                	je     800dc0 <vprintfmt+0x207>
  800da4:	83 fb 1f             	cmp    $0x1f,%ebx
  800da7:	7e 05                	jle    800dae <vprintfmt+0x1f5>
  800da9:	83 fb 7e             	cmp    $0x7e,%ebx
  800dac:	7e 12                	jle    800dc0 <vprintfmt+0x207>
					putch('?', putdat);
  800dae:	83 ec 08             	sub    $0x8,%esp
  800db1:	ff 75 0c             	pushl  0xc(%ebp)
  800db4:	6a 3f                	push   $0x3f
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	ff d0                	call   *%eax
  800dbb:	83 c4 10             	add    $0x10,%esp
  800dbe:	eb 0f                	jmp    800dcf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dc0:	83 ec 08             	sub    $0x8,%esp
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	53                   	push   %ebx
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	ff d0                	call   *%eax
  800dcc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dcf:	ff 4d e4             	decl   -0x1c(%ebp)
  800dd2:	89 f0                	mov    %esi,%eax
  800dd4:	8d 70 01             	lea    0x1(%eax),%esi
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f be d8             	movsbl %al,%ebx
  800ddc:	85 db                	test   %ebx,%ebx
  800dde:	74 24                	je     800e04 <vprintfmt+0x24b>
  800de0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de4:	78 b8                	js     800d9e <vprintfmt+0x1e5>
  800de6:	ff 4d e0             	decl   -0x20(%ebp)
  800de9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ded:	79 af                	jns    800d9e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800def:	eb 13                	jmp    800e04 <vprintfmt+0x24b>
				putch(' ', putdat);
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	6a 20                	push   $0x20
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	ff d0                	call   *%eax
  800dfe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e01:	ff 4d e4             	decl   -0x1c(%ebp)
  800e04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e08:	7f e7                	jg     800df1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e0a:	e9 66 01 00 00       	jmp    800f75 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0f:	83 ec 08             	sub    $0x8,%esp
  800e12:	ff 75 e8             	pushl  -0x18(%ebp)
  800e15:	8d 45 14             	lea    0x14(%ebp),%eax
  800e18:	50                   	push   %eax
  800e19:	e8 3c fd ff ff       	call   800b5a <getint>
  800e1e:	83 c4 10             	add    $0x10,%esp
  800e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2d:	85 d2                	test   %edx,%edx
  800e2f:	79 23                	jns    800e54 <vprintfmt+0x29b>
				putch('-', putdat);
  800e31:	83 ec 08             	sub    $0x8,%esp
  800e34:	ff 75 0c             	pushl  0xc(%ebp)
  800e37:	6a 2d                	push   $0x2d
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	ff d0                	call   *%eax
  800e3e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e47:	f7 d8                	neg    %eax
  800e49:	83 d2 00             	adc    $0x0,%edx
  800e4c:	f7 da                	neg    %edx
  800e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e54:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e5b:	e9 bc 00 00 00       	jmp    800f1c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e60:	83 ec 08             	sub    $0x8,%esp
  800e63:	ff 75 e8             	pushl  -0x18(%ebp)
  800e66:	8d 45 14             	lea    0x14(%ebp),%eax
  800e69:	50                   	push   %eax
  800e6a:	e8 84 fc ff ff       	call   800af3 <getuint>
  800e6f:	83 c4 10             	add    $0x10,%esp
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e78:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7f:	e9 98 00 00 00       	jmp    800f1c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	6a 58                	push   $0x58
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	ff d0                	call   *%eax
  800e91:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e94:	83 ec 08             	sub    $0x8,%esp
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	6a 58                	push   $0x58
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	ff d0                	call   *%eax
  800ea1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ea4:	83 ec 08             	sub    $0x8,%esp
  800ea7:	ff 75 0c             	pushl  0xc(%ebp)
  800eaa:	6a 58                	push   $0x58
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	ff d0                	call   *%eax
  800eb1:	83 c4 10             	add    $0x10,%esp
			break;
  800eb4:	e9 bc 00 00 00       	jmp    800f75 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	6a 30                	push   $0x30
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	ff d0                	call   *%eax
  800ec6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	6a 78                	push   $0x78
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	ff d0                	call   *%eax
  800ed6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed9:	8b 45 14             	mov    0x14(%ebp),%eax
  800edc:	83 c0 04             	add    $0x4,%eax
  800edf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee5:	83 e8 04             	sub    $0x4,%eax
  800ee8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800eea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ef4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800efb:	eb 1f                	jmp    800f1c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800efd:	83 ec 08             	sub    $0x8,%esp
  800f00:	ff 75 e8             	pushl  -0x18(%ebp)
  800f03:	8d 45 14             	lea    0x14(%ebp),%eax
  800f06:	50                   	push   %eax
  800f07:	e8 e7 fb ff ff       	call   800af3 <getuint>
  800f0c:	83 c4 10             	add    $0x10,%esp
  800f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f1c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	52                   	push   %edx
  800f27:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f2a:	50                   	push   %eax
  800f2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2e:	ff 75 f0             	pushl  -0x10(%ebp)
  800f31:	ff 75 0c             	pushl  0xc(%ebp)
  800f34:	ff 75 08             	pushl  0x8(%ebp)
  800f37:	e8 00 fb ff ff       	call   800a3c <printnum>
  800f3c:	83 c4 20             	add    $0x20,%esp
			break;
  800f3f:	eb 34                	jmp    800f75 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	ff 75 0c             	pushl  0xc(%ebp)
  800f47:	53                   	push   %ebx
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
  800f4d:	83 c4 10             	add    $0x10,%esp
			break;
  800f50:	eb 23                	jmp    800f75 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 0c             	pushl  0xc(%ebp)
  800f58:	6a 25                	push   $0x25
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	ff d0                	call   *%eax
  800f5f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f62:	ff 4d 10             	decl   0x10(%ebp)
  800f65:	eb 03                	jmp    800f6a <vprintfmt+0x3b1>
  800f67:	ff 4d 10             	decl   0x10(%ebp)
  800f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6d:	48                   	dec    %eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	3c 25                	cmp    $0x25,%al
  800f72:	75 f3                	jne    800f67 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f74:	90                   	nop
		}
	}
  800f75:	e9 47 fc ff ff       	jmp    800bc1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f7a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f88:	8d 45 10             	lea    0x10(%ebp),%eax
  800f8b:	83 c0 04             	add    $0x4,%eax
  800f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f91:	8b 45 10             	mov    0x10(%ebp),%eax
  800f94:	ff 75 f4             	pushl  -0xc(%ebp)
  800f97:	50                   	push   %eax
  800f98:	ff 75 0c             	pushl  0xc(%ebp)
  800f9b:	ff 75 08             	pushl  0x8(%ebp)
  800f9e:	e8 16 fc ff ff       	call   800bb9 <vprintfmt>
  800fa3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa6:	90                   	nop
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8b 40 08             	mov    0x8(%eax),%eax
  800fb2:	8d 50 01             	lea    0x1(%eax),%edx
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8b 10                	mov    (%eax),%edx
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	8b 40 04             	mov    0x4(%eax),%eax
  800fc6:	39 c2                	cmp    %eax,%edx
  800fc8:	73 12                	jae    800fdc <sprintputch+0x33>
		*b->buf++ = ch;
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	8b 00                	mov    (%eax),%eax
  800fcf:	8d 48 01             	lea    0x1(%eax),%ecx
  800fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd5:	89 0a                	mov    %ecx,(%edx)
  800fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fda:	88 10                	mov    %dl,(%eax)
}
  800fdc:	90                   	nop
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	01 d0                	add    %edx,%eax
  800ff6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801000:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801004:	74 06                	je     80100c <vsnprintf+0x2d>
  801006:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80100a:	7f 07                	jg     801013 <vsnprintf+0x34>
		return -E_INVAL;
  80100c:	b8 03 00 00 00       	mov    $0x3,%eax
  801011:	eb 20                	jmp    801033 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801013:	ff 75 14             	pushl  0x14(%ebp)
  801016:	ff 75 10             	pushl  0x10(%ebp)
  801019:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80101c:	50                   	push   %eax
  80101d:	68 a9 0f 80 00       	push   $0x800fa9
  801022:	e8 92 fb ff ff       	call   800bb9 <vprintfmt>
  801027:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80102a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80102d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801033:	c9                   	leave  
  801034:	c3                   	ret    

00801035 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80103b:	8d 45 10             	lea    0x10(%ebp),%eax
  80103e:	83 c0 04             	add    $0x4,%eax
  801041:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801044:	8b 45 10             	mov    0x10(%ebp),%eax
  801047:	ff 75 f4             	pushl  -0xc(%ebp)
  80104a:	50                   	push   %eax
  80104b:	ff 75 0c             	pushl  0xc(%ebp)
  80104e:	ff 75 08             	pushl  0x8(%ebp)
  801051:	e8 89 ff ff ff       	call   800fdf <vsnprintf>
  801056:	83 c4 10             	add    $0x10,%esp
  801059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80105c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801067:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80106e:	eb 06                	jmp    801076 <strlen+0x15>
		n++;
  801070:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	84 c0                	test   %al,%al
  80107d:	75 f1                	jne    801070 <strlen+0xf>
		n++;
	return n;
  80107f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801082:	c9                   	leave  
  801083:	c3                   	ret    

00801084 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80108a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801091:	eb 09                	jmp    80109c <strnlen+0x18>
		n++;
  801093:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801096:	ff 45 08             	incl   0x8(%ebp)
  801099:	ff 4d 0c             	decl   0xc(%ebp)
  80109c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a0:	74 09                	je     8010ab <strnlen+0x27>
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	84 c0                	test   %al,%al
  8010a9:	75 e8                	jne    801093 <strnlen+0xf>
		n++;
	return n;
  8010ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010bc:	90                   	nop
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8d 50 01             	lea    0x1(%eax),%edx
  8010c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cf:	8a 12                	mov    (%edx),%dl
  8010d1:	88 10                	mov    %dl,(%eax)
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e4                	jne    8010bd <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010f1:	eb 1f                	jmp    801112 <strncpy+0x34>
		*dst++ = *src;
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ff:	8a 12                	mov    (%edx),%dl
  801101:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801103:	8b 45 0c             	mov    0xc(%ebp),%eax
  801106:	8a 00                	mov    (%eax),%al
  801108:	84 c0                	test   %al,%al
  80110a:	74 03                	je     80110f <strncpy+0x31>
			src++;
  80110c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80110f:	ff 45 fc             	incl   -0x4(%ebp)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	3b 45 10             	cmp    0x10(%ebp),%eax
  801118:	72 d9                	jb     8010f3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	74 30                	je     801161 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801131:	eb 16                	jmp    801149 <strlcpy+0x2a>
			*dst++ = *src++;
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8d 50 01             	lea    0x1(%eax),%edx
  801139:	89 55 08             	mov    %edx,0x8(%ebp)
  80113c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801142:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801145:	8a 12                	mov    (%edx),%dl
  801147:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801149:	ff 4d 10             	decl   0x10(%ebp)
  80114c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801150:	74 09                	je     80115b <strlcpy+0x3c>
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	84 c0                	test   %al,%al
  801159:	75 d8                	jne    801133 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801161:	8b 55 08             	mov    0x8(%ebp),%edx
  801164:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
}
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    

0080116d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801170:	eb 06                	jmp    801178 <strcmp+0xb>
		p++, q++;
  801172:	ff 45 08             	incl   0x8(%ebp)
  801175:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	84 c0                	test   %al,%al
  80117f:	74 0e                	je     80118f <strcmp+0x22>
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 10                	mov    (%eax),%dl
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	38 c2                	cmp    %al,%dl
  80118d:	74 e3                	je     801172 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	0f b6 d0             	movzbl %al,%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	0f b6 c0             	movzbl %al,%eax
  80119f:	29 c2                	sub    %eax,%edx
  8011a1:	89 d0                	mov    %edx,%eax
}
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    

008011a5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011a8:	eb 09                	jmp    8011b3 <strncmp+0xe>
		n--, p++, q++;
  8011aa:	ff 4d 10             	decl   0x10(%ebp)
  8011ad:	ff 45 08             	incl   0x8(%ebp)
  8011b0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b7:	74 17                	je     8011d0 <strncmp+0x2b>
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	84 c0                	test   %al,%al
  8011c0:	74 0e                	je     8011d0 <strncmp+0x2b>
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 10                	mov    (%eax),%dl
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	38 c2                	cmp    %al,%dl
  8011ce:	74 da                	je     8011aa <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	75 07                	jne    8011dd <strncmp+0x38>
		return 0;
  8011d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011db:	eb 14                	jmp    8011f1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d0             	movzbl %al,%edx
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 c0             	movzbl %al,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
}
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011ff:	eb 12                	jmp    801213 <strchr+0x20>
		if (*s == c)
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	8a 00                	mov    (%eax),%al
  801206:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801209:	75 05                	jne    801210 <strchr+0x1d>
			return (char *) s;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	eb 11                	jmp    801221 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801210:	ff 45 08             	incl   0x8(%ebp)
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	84 c0                	test   %al,%al
  80121a:	75 e5                	jne    801201 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80121c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 04             	sub    $0x4,%esp
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122f:	eb 0d                	jmp    80123e <strfind+0x1b>
		if (*s == c)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801239:	74 0e                	je     801249 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	75 ea                	jne    801231 <strfind+0xe>
  801247:	eb 01                	jmp    80124a <strfind+0x27>
		if (*s == c)
			break;
  801249:	90                   	nop
	return (char *) s;
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801261:	eb 0e                	jmp    801271 <memset+0x22>
		*p++ = c;
  801263:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801266:	8d 50 01             	lea    0x1(%eax),%edx
  801269:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80126c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801271:	ff 4d f8             	decl   -0x8(%ebp)
  801274:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801278:	79 e9                	jns    801263 <memset+0x14>
		*p++ = c;

	return v;
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801285:	8b 45 0c             	mov    0xc(%ebp),%eax
  801288:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801291:	eb 16                	jmp    8012a9 <memcpy+0x2a>
		*d++ = *s++;
  801293:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801296:	8d 50 01             	lea    0x1(%eax),%edx
  801299:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80129c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a5:	8a 12                	mov    (%edx),%dl
  8012a7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012af:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	75 dd                	jne    801293 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d3:	73 50                	jae    801325 <memmove+0x6a>
  8012d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 d0                	add    %edx,%eax
  8012dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012e0:	76 43                	jbe    801325 <memmove+0x6a>
		s += n;
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012eb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012ee:	eb 10                	jmp    801300 <memmove+0x45>
			*--d = *--s;
  8012f0:	ff 4d f8             	decl   -0x8(%ebp)
  8012f3:	ff 4d fc             	decl   -0x4(%ebp)
  8012f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f9:	8a 10                	mov    (%eax),%dl
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fe:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	8d 50 ff             	lea    -0x1(%eax),%edx
  801306:	89 55 10             	mov    %edx,0x10(%ebp)
  801309:	85 c0                	test   %eax,%eax
  80130b:	75 e3                	jne    8012f0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80130d:	eb 23                	jmp    801332 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80130f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801312:	8d 50 01             	lea    0x1(%eax),%edx
  801315:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801318:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80131e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801321:	8a 12                	mov    (%edx),%dl
  801323:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	8d 50 ff             	lea    -0x1(%eax),%edx
  80132b:	89 55 10             	mov    %edx,0x10(%ebp)
  80132e:	85 c0                	test   %eax,%eax
  801330:	75 dd                	jne    80130f <memmove+0x54>
			*d++ = *s++;

	return dst;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801349:	eb 2a                	jmp    801375 <memcmp+0x3e>
		if (*s1 != *s2)
  80134b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134e:	8a 10                	mov    (%eax),%dl
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	38 c2                	cmp    %al,%dl
  801357:	74 16                	je     80136f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801359:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	0f b6 d0             	movzbl %al,%edx
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	8a 00                	mov    (%eax),%al
  801366:	0f b6 c0             	movzbl %al,%eax
  801369:	29 c2                	sub    %eax,%edx
  80136b:	89 d0                	mov    %edx,%eax
  80136d:	eb 18                	jmp    801387 <memcmp+0x50>
		s1++, s2++;
  80136f:	ff 45 fc             	incl   -0x4(%ebp)
  801372:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137b:	89 55 10             	mov    %edx,0x10(%ebp)
  80137e:	85 c0                	test   %eax,%eax
  801380:	75 c9                	jne    80134b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801382:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80138f:	8b 55 08             	mov    0x8(%ebp),%edx
  801392:	8b 45 10             	mov    0x10(%ebp),%eax
  801395:	01 d0                	add    %edx,%eax
  801397:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80139a:	eb 15                	jmp    8013b1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	0f b6 d0             	movzbl %al,%edx
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	0f b6 c0             	movzbl %al,%eax
  8013aa:	39 c2                	cmp    %eax,%edx
  8013ac:	74 0d                	je     8013bb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013b7:	72 e3                	jb     80139c <memfind+0x13>
  8013b9:	eb 01                	jmp    8013bc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013bb:	90                   	nop
	return (void *) s;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013d5:	eb 03                	jmp    8013da <strtol+0x19>
		s++;
  8013d7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	3c 20                	cmp    $0x20,%al
  8013e1:	74 f4                	je     8013d7 <strtol+0x16>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 09                	cmp    $0x9,%al
  8013ea:	74 eb                	je     8013d7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	3c 2b                	cmp    $0x2b,%al
  8013f3:	75 05                	jne    8013fa <strtol+0x39>
		s++;
  8013f5:	ff 45 08             	incl   0x8(%ebp)
  8013f8:	eb 13                	jmp    80140d <strtol+0x4c>
	else if (*s == '-')
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	3c 2d                	cmp    $0x2d,%al
  801401:	75 0a                	jne    80140d <strtol+0x4c>
		s++, neg = 1;
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80140d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801411:	74 06                	je     801419 <strtol+0x58>
  801413:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801417:	75 20                	jne    801439 <strtol+0x78>
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	3c 30                	cmp    $0x30,%al
  801420:	75 17                	jne    801439 <strtol+0x78>
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	40                   	inc    %eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	3c 78                	cmp    $0x78,%al
  80142a:	75 0d                	jne    801439 <strtol+0x78>
		s += 2, base = 16;
  80142c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801430:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801437:	eb 28                	jmp    801461 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801439:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143d:	75 15                	jne    801454 <strtol+0x93>
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	3c 30                	cmp    $0x30,%al
  801446:	75 0c                	jne    801454 <strtol+0x93>
		s++, base = 8;
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801452:	eb 0d                	jmp    801461 <strtol+0xa0>
	else if (base == 0)
  801454:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801458:	75 07                	jne    801461 <strtol+0xa0>
		base = 10;
  80145a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	3c 2f                	cmp    $0x2f,%al
  801468:	7e 19                	jle    801483 <strtol+0xc2>
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 39                	cmp    $0x39,%al
  801471:	7f 10                	jg     801483 <strtol+0xc2>
			dig = *s - '0';
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	0f be c0             	movsbl %al,%eax
  80147b:	83 e8 30             	sub    $0x30,%eax
  80147e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801481:	eb 42                	jmp    8014c5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	3c 60                	cmp    $0x60,%al
  80148a:	7e 19                	jle    8014a5 <strtol+0xe4>
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3c 7a                	cmp    $0x7a,%al
  801493:	7f 10                	jg     8014a5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8a 00                	mov    (%eax),%al
  80149a:	0f be c0             	movsbl %al,%eax
  80149d:	83 e8 57             	sub    $0x57,%eax
  8014a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014a3:	eb 20                	jmp    8014c5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8a 00                	mov    (%eax),%al
  8014aa:	3c 40                	cmp    $0x40,%al
  8014ac:	7e 39                	jle    8014e7 <strtol+0x126>
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	3c 5a                	cmp    $0x5a,%al
  8014b5:	7f 30                	jg     8014e7 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	0f be c0             	movsbl %al,%eax
  8014bf:	83 e8 37             	sub    $0x37,%eax
  8014c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014cb:	7d 19                	jge    8014e6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014cd:	ff 45 08             	incl   0x8(%ebp)
  8014d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014d7:	89 c2                	mov    %eax,%edx
  8014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014e1:	e9 7b ff ff ff       	jmp    801461 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014e6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014eb:	74 08                	je     8014f5 <strtol+0x134>
		*endptr = (char *) s;
  8014ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014f9:	74 07                	je     801502 <strtol+0x141>
  8014fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fe:	f7 d8                	neg    %eax
  801500:	eb 03                	jmp    801505 <strtol+0x144>
  801502:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <ltostr>:

void
ltostr(long value, char *str)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80150d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801514:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80151b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151f:	79 13                	jns    801534 <ltostr+0x2d>
	{
		neg = 1;
  801521:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80152e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801531:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80153c:	99                   	cltd   
  80153d:	f7 f9                	idiv   %ecx
  80153f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801545:	8d 50 01             	lea    0x1(%eax),%edx
  801548:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80154b:	89 c2                	mov    %eax,%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801555:	83 c2 30             	add    $0x30,%edx
  801558:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80155a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80155d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801562:	f7 e9                	imul   %ecx
  801564:	c1 fa 02             	sar    $0x2,%edx
  801567:	89 c8                	mov    %ecx,%eax
  801569:	c1 f8 1f             	sar    $0x1f,%eax
  80156c:	29 c2                	sub    %eax,%edx
  80156e:	89 d0                	mov    %edx,%eax
  801570:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801573:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801576:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80157b:	f7 e9                	imul   %ecx
  80157d:	c1 fa 02             	sar    $0x2,%edx
  801580:	89 c8                	mov    %ecx,%eax
  801582:	c1 f8 1f             	sar    $0x1f,%eax
  801585:	29 c2                	sub    %eax,%edx
  801587:	89 d0                	mov    %edx,%eax
  801589:	c1 e0 02             	shl    $0x2,%eax
  80158c:	01 d0                	add    %edx,%eax
  80158e:	01 c0                	add    %eax,%eax
  801590:	29 c1                	sub    %eax,%ecx
  801592:	89 ca                	mov    %ecx,%edx
  801594:	85 d2                	test   %edx,%edx
  801596:	75 9c                	jne    801534 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80159f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a2:	48                   	dec    %eax
  8015a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015aa:	74 3d                	je     8015e9 <ltostr+0xe2>
		start = 1 ;
  8015ac:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015b3:	eb 34                	jmp    8015e9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 d0                	add    %edx,%eax
  8015bd:	8a 00                	mov    (%eax),%al
  8015bf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c8:	01 c2                	add    %eax,%edx
  8015ca:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	01 c8                	add    %ecx,%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dc:	01 c2                	add    %eax,%edx
  8015de:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015e1:	88 02                	mov    %al,(%edx)
		start++ ;
  8015e3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015e6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015ef:	7c c4                	jl     8015b5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	01 d0                	add    %edx,%eax
  8015f9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015fc:	90                   	nop
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801605:	ff 75 08             	pushl  0x8(%ebp)
  801608:	e8 54 fa ff ff       	call   801061 <strlen>
  80160d:	83 c4 04             	add    $0x4,%esp
  801610:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801613:	ff 75 0c             	pushl  0xc(%ebp)
  801616:	e8 46 fa ff ff       	call   801061 <strlen>
  80161b:	83 c4 04             	add    $0x4,%esp
  80161e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801628:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80162f:	eb 17                	jmp    801648 <strcconcat+0x49>
		final[s] = str1[s] ;
  801631:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801634:	8b 45 10             	mov    0x10(%ebp),%eax
  801637:	01 c2                	add    %eax,%edx
  801639:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	01 c8                	add    %ecx,%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801645:	ff 45 fc             	incl   -0x4(%ebp)
  801648:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80164e:	7c e1                	jl     801631 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801650:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801657:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80165e:	eb 1f                	jmp    80167f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801660:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801663:	8d 50 01             	lea    0x1(%eax),%edx
  801666:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801669:	89 c2                	mov    %eax,%edx
  80166b:	8b 45 10             	mov    0x10(%ebp),%eax
  80166e:	01 c2                	add    %eax,%edx
  801670:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	01 c8                	add    %ecx,%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80167c:	ff 45 f8             	incl   -0x8(%ebp)
  80167f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801682:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801685:	7c d9                	jl     801660 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	c6 00 00             	movb   $0x0,(%eax)
}
  801692:	90                   	nop
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801698:	8b 45 14             	mov    0x14(%ebp),%eax
  80169b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a4:	8b 00                	mov    (%eax),%eax
  8016a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b0:	01 d0                	add    %edx,%eax
  8016b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b8:	eb 0c                	jmp    8016c6 <strsplit+0x31>
			*string++ = 0;
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	8a 00                	mov    (%eax),%al
  8016cb:	84 c0                	test   %al,%al
  8016cd:	74 18                	je     8016e7 <strsplit+0x52>
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	0f be c0             	movsbl %al,%eax
  8016d7:	50                   	push   %eax
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	e8 13 fb ff ff       	call   8011f3 <strchr>
  8016e0:	83 c4 08             	add    $0x8,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	75 d3                	jne    8016ba <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	84 c0                	test   %al,%al
  8016ee:	74 5a                	je     80174a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f3:	8b 00                	mov    (%eax),%eax
  8016f5:	83 f8 0f             	cmp    $0xf,%eax
  8016f8:	75 07                	jne    801701 <strsplit+0x6c>
		{
			return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ff:	eb 66                	jmp    801767 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801701:	8b 45 14             	mov    0x14(%ebp),%eax
  801704:	8b 00                	mov    (%eax),%eax
  801706:	8d 48 01             	lea    0x1(%eax),%ecx
  801709:	8b 55 14             	mov    0x14(%ebp),%edx
  80170c:	89 0a                	mov    %ecx,(%edx)
  80170e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801715:	8b 45 10             	mov    0x10(%ebp),%eax
  801718:	01 c2                	add    %eax,%edx
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80171f:	eb 03                	jmp    801724 <strsplit+0x8f>
			string++;
  801721:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	8a 00                	mov    (%eax),%al
  801729:	84 c0                	test   %al,%al
  80172b:	74 8b                	je     8016b8 <strsplit+0x23>
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	8a 00                	mov    (%eax),%al
  801732:	0f be c0             	movsbl %al,%eax
  801735:	50                   	push   %eax
  801736:	ff 75 0c             	pushl  0xc(%ebp)
  801739:	e8 b5 fa ff ff       	call   8011f3 <strchr>
  80173e:	83 c4 08             	add    $0x8,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	74 dc                	je     801721 <strsplit+0x8c>
			string++;
	}
  801745:	e9 6e ff ff ff       	jmp    8016b8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80174a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80174b:	8b 45 14             	mov    0x14(%ebp),%eax
  80174e:	8b 00                	mov    (%eax),%eax
  801750:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801757:	8b 45 10             	mov    0x10(%ebp),%eax
  80175a:	01 d0                	add    %edx,%eax
  80175c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801762:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	57                   	push   %edi
  80176d:	56                   	push   %esi
  80176e:	53                   	push   %ebx
  80176f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8b 55 0c             	mov    0xc(%ebp),%edx
  801778:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80177e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801781:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801784:	cd 30                	int    $0x30
  801786:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801789:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	5b                   	pop    %ebx
  801790:	5e                   	pop    %esi
  801791:	5f                   	pop    %edi
  801792:	5d                   	pop    %ebp
  801793:	c3                   	ret    

00801794 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 04             	sub    $0x4,%esp
  80179a:	8b 45 10             	mov    0x10(%ebp),%eax
  80179d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	52                   	push   %edx
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	e8 b2 ff ff ff       	call   801769 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	90                   	nop
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 01                	push   $0x1
  8017cc:	e8 98 ff ff ff       	call   801769 <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	52                   	push   %edx
  8017e6:	50                   	push   %eax
  8017e7:	6a 05                	push   $0x5
  8017e9:	e8 7b ff ff ff       	call   801769 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017f8:	8b 75 18             	mov    0x18(%ebp),%esi
  8017fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801801:	8b 55 0c             	mov    0xc(%ebp),%edx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	56                   	push   %esi
  801808:	53                   	push   %ebx
  801809:	51                   	push   %ecx
  80180a:	52                   	push   %edx
  80180b:	50                   	push   %eax
  80180c:	6a 06                	push   $0x6
  80180e:	e8 56 ff ff ff       	call   801769 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801819:	5b                   	pop    %ebx
  80181a:	5e                   	pop    %esi
  80181b:	5d                   	pop    %ebp
  80181c:	c3                   	ret    

0080181d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801820:	8b 55 0c             	mov    0xc(%ebp),%edx
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	52                   	push   %edx
  80182d:	50                   	push   %eax
  80182e:	6a 07                	push   $0x7
  801830:	e8 34 ff ff ff       	call   801769 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	ff 75 08             	pushl  0x8(%ebp)
  801849:	6a 08                	push   $0x8
  80184b:	e8 19 ff ff ff       	call   801769 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 09                	push   $0x9
  801864:	e8 00 ff ff ff       	call   801769 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 0a                	push   $0xa
  80187d:	e8 e7 fe ff ff       	call   801769 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 0b                	push   $0xb
  801896:	e8 ce fe ff ff       	call   801769 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ac:	ff 75 08             	pushl  0x8(%ebp)
  8018af:	6a 0f                	push   $0xf
  8018b1:	e8 b3 fe ff ff       	call   801769 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
	return;
  8018b9:	90                   	nop
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 10                	push   $0x10
  8018cd:	e8 97 fe ff ff       	call   801769 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	ff 75 10             	pushl  0x10(%ebp)
  8018e2:	ff 75 0c             	pushl  0xc(%ebp)
  8018e5:	ff 75 08             	pushl  0x8(%ebp)
  8018e8:	6a 11                	push   $0x11
  8018ea:	e8 7a fe ff ff       	call   801769 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f2:	90                   	nop
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 0c                	push   $0xc
  801904:	e8 60 fe ff ff       	call   801769 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	ff 75 08             	pushl  0x8(%ebp)
  80191c:	6a 0d                	push   $0xd
  80191e:	e8 46 fe ff ff       	call   801769 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 0e                	push   $0xe
  801937:	e8 2d fe ff ff       	call   801769 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	90                   	nop
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 13                	push   $0x13
  801951:	e8 13 fe ff ff       	call   801769 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	90                   	nop
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 14                	push   $0x14
  80196b:	e8 f9 fd ff ff       	call   801769 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	90                   	nop
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_cputc>:


void
sys_cputc(const char c)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801982:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	50                   	push   %eax
  80198f:	6a 15                	push   $0x15
  801991:	e8 d3 fd ff ff       	call   801769 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	90                   	nop
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 16                	push   $0x16
  8019ab:	e8 b9 fd ff ff       	call   801769 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	6a 17                	push   $0x17
  8019c8:	e8 9c fd ff ff       	call   801769 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	52                   	push   %edx
  8019e2:	50                   	push   %eax
  8019e3:	6a 1a                	push   $0x1a
  8019e5:	e8 7f fd ff ff       	call   801769 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	52                   	push   %edx
  8019ff:	50                   	push   %eax
  801a00:	6a 18                	push   $0x18
  801a02:	e8 62 fd ff ff       	call   801769 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	52                   	push   %edx
  801a1d:	50                   	push   %eax
  801a1e:	6a 19                	push   $0x19
  801a20:	e8 44 fd ff ff       	call   801769 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	90                   	nop
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	83 ec 04             	sub    $0x4,%esp
  801a31:	8b 45 10             	mov    0x10(%ebp),%eax
  801a34:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a37:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a3a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	51                   	push   %ecx
  801a44:	52                   	push   %edx
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	50                   	push   %eax
  801a49:	6a 1b                	push   $0x1b
  801a4b:	e8 19 fd ff ff       	call   801769 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	6a 1c                	push   $0x1c
  801a68:	e8 fc fc ff ff       	call   801769 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	51                   	push   %ecx
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 1d                	push   $0x1d
  801a87:	e8 dd fc ff ff       	call   801769 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 1e                	push   $0x1e
  801aa4:	e8 c0 fc ff ff       	call   801769 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 1f                	push   $0x1f
  801abd:	e8 a7 fc ff ff       	call   801769 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	6a 00                	push   $0x0
  801acf:	ff 75 14             	pushl  0x14(%ebp)
  801ad2:	ff 75 10             	pushl  0x10(%ebp)
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	6a 20                	push   $0x20
  801adb:	e8 89 fc ff ff       	call   801769 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	50                   	push   %eax
  801af4:	6a 21                	push   $0x21
  801af6:	e8 6e fc ff ff       	call   801769 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	50                   	push   %eax
  801b10:	6a 22                	push   $0x22
  801b12:	e8 52 fc ff ff       	call   801769 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 02                	push   $0x2
  801b2b:	e8 39 fc ff ff       	call   801769 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 03                	push   $0x3
  801b44:	e8 20 fc ff ff       	call   801769 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 04                	push   $0x4
  801b5d:	e8 07 fc ff ff       	call   801769 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_exit_env>:


void sys_exit_env(void)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 23                	push   $0x23
  801b76:	e8 ee fb ff ff       	call   801769 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	90                   	nop
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8a:	8d 50 04             	lea    0x4(%eax),%edx
  801b8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 24                	push   $0x24
  801b9a:	e8 ca fb ff ff       	call   801769 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bab:	89 01                	mov    %eax,(%ecx)
  801bad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	c9                   	leave  
  801bb4:	c2 04 00             	ret    $0x4

00801bb7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	ff 75 10             	pushl  0x10(%ebp)
  801bc1:	ff 75 0c             	pushl  0xc(%ebp)
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	6a 12                	push   $0x12
  801bc9:	e8 9b fb ff ff       	call   801769 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd1:	90                   	nop
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 25                	push   $0x25
  801be3:	e8 81 fb ff ff       	call   801769 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bf9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	50                   	push   %eax
  801c06:	6a 26                	push   $0x26
  801c08:	e8 5c fb ff ff       	call   801769 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c10:	90                   	nop
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <rsttst>:
void rsttst()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 28                	push   $0x28
  801c22:	e8 42 fb ff ff       	call   801769 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2a:	90                   	nop
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	8b 45 14             	mov    0x14(%ebp),%eax
  801c36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c39:	8b 55 18             	mov    0x18(%ebp),%edx
  801c3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c40:	52                   	push   %edx
  801c41:	50                   	push   %eax
  801c42:	ff 75 10             	pushl  0x10(%ebp)
  801c45:	ff 75 0c             	pushl  0xc(%ebp)
  801c48:	ff 75 08             	pushl  0x8(%ebp)
  801c4b:	6a 27                	push   $0x27
  801c4d:	e8 17 fb ff ff       	call   801769 <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
	return ;
  801c55:	90                   	nop
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <chktst>:
void chktst(uint32 n)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	6a 29                	push   $0x29
  801c68:	e8 fc fa ff ff       	call   801769 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c70:	90                   	nop
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <inctst>:

void inctst()
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 2a                	push   $0x2a
  801c82:	e8 e2 fa ff ff       	call   801769 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8a:	90                   	nop
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <gettst>:
uint32 gettst()
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 2b                	push   $0x2b
  801c9c:	e8 c8 fa ff ff       	call   801769 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 2c                	push   $0x2c
  801cb8:	e8 ac fa ff ff       	call   801769 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
  801cc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cc7:	75 07                	jne    801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cce:	eb 05                	jmp    801cd5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 2c                	push   $0x2c
  801ce9:	e8 7b fa ff ff       	call   801769 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
  801cf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cf8:	75 07                	jne    801d01 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801cff:	eb 05                	jmp    801d06 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 2c                	push   $0x2c
  801d1a:	e8 4a fa ff ff       	call   801769 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
  801d22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d25:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d29:	75 07                	jne    801d32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d30:	eb 05                	jmp    801d37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 2c                	push   $0x2c
  801d4b:	e8 19 fa ff ff       	call   801769 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
  801d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d56:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d5a:	75 07                	jne    801d63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d61:	eb 05                	jmp    801d68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	6a 2d                	push   $0x2d
  801d7a:	e8 ea f9 ff ff       	call   801769 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	6a 00                	push   $0x0
  801d97:	53                   	push   %ebx
  801d98:	51                   	push   %ecx
  801d99:	52                   	push   %edx
  801d9a:	50                   	push   %eax
  801d9b:	6a 2e                	push   $0x2e
  801d9d:	e8 c7 f9 ff ff       	call   801769 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	52                   	push   %edx
  801dba:	50                   	push   %eax
  801dbb:	6a 2f                	push   $0x2f
  801dbd:	e8 a7 f9 ff ff       	call   801769 <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    
  801dc7:	90                   	nop

00801dc8 <__udivdi3>:
  801dc8:	55                   	push   %ebp
  801dc9:	57                   	push   %edi
  801dca:	56                   	push   %esi
  801dcb:	53                   	push   %ebx
  801dcc:	83 ec 1c             	sub    $0x1c,%esp
  801dcf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801dd3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801dd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ddb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ddf:	89 ca                	mov    %ecx,%edx
  801de1:	89 f8                	mov    %edi,%eax
  801de3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801de7:	85 f6                	test   %esi,%esi
  801de9:	75 2d                	jne    801e18 <__udivdi3+0x50>
  801deb:	39 cf                	cmp    %ecx,%edi
  801ded:	77 65                	ja     801e54 <__udivdi3+0x8c>
  801def:	89 fd                	mov    %edi,%ebp
  801df1:	85 ff                	test   %edi,%edi
  801df3:	75 0b                	jne    801e00 <__udivdi3+0x38>
  801df5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfa:	31 d2                	xor    %edx,%edx
  801dfc:	f7 f7                	div    %edi
  801dfe:	89 c5                	mov    %eax,%ebp
  801e00:	31 d2                	xor    %edx,%edx
  801e02:	89 c8                	mov    %ecx,%eax
  801e04:	f7 f5                	div    %ebp
  801e06:	89 c1                	mov    %eax,%ecx
  801e08:	89 d8                	mov    %ebx,%eax
  801e0a:	f7 f5                	div    %ebp
  801e0c:	89 cf                	mov    %ecx,%edi
  801e0e:	89 fa                	mov    %edi,%edx
  801e10:	83 c4 1c             	add    $0x1c,%esp
  801e13:	5b                   	pop    %ebx
  801e14:	5e                   	pop    %esi
  801e15:	5f                   	pop    %edi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    
  801e18:	39 ce                	cmp    %ecx,%esi
  801e1a:	77 28                	ja     801e44 <__udivdi3+0x7c>
  801e1c:	0f bd fe             	bsr    %esi,%edi
  801e1f:	83 f7 1f             	xor    $0x1f,%edi
  801e22:	75 40                	jne    801e64 <__udivdi3+0x9c>
  801e24:	39 ce                	cmp    %ecx,%esi
  801e26:	72 0a                	jb     801e32 <__udivdi3+0x6a>
  801e28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e2c:	0f 87 9e 00 00 00    	ja     801ed0 <__udivdi3+0x108>
  801e32:	b8 01 00 00 00       	mov    $0x1,%eax
  801e37:	89 fa                	mov    %edi,%edx
  801e39:	83 c4 1c             	add    $0x1c,%esp
  801e3c:	5b                   	pop    %ebx
  801e3d:	5e                   	pop    %esi
  801e3e:	5f                   	pop    %edi
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    
  801e41:	8d 76 00             	lea    0x0(%esi),%esi
  801e44:	31 ff                	xor    %edi,%edi
  801e46:	31 c0                	xor    %eax,%eax
  801e48:	89 fa                	mov    %edi,%edx
  801e4a:	83 c4 1c             	add    $0x1c,%esp
  801e4d:	5b                   	pop    %ebx
  801e4e:	5e                   	pop    %esi
  801e4f:	5f                   	pop    %edi
  801e50:	5d                   	pop    %ebp
  801e51:	c3                   	ret    
  801e52:	66 90                	xchg   %ax,%ax
  801e54:	89 d8                	mov    %ebx,%eax
  801e56:	f7 f7                	div    %edi
  801e58:	31 ff                	xor    %edi,%edi
  801e5a:	89 fa                	mov    %edi,%edx
  801e5c:	83 c4 1c             	add    $0x1c,%esp
  801e5f:	5b                   	pop    %ebx
  801e60:	5e                   	pop    %esi
  801e61:	5f                   	pop    %edi
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    
  801e64:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e69:	89 eb                	mov    %ebp,%ebx
  801e6b:	29 fb                	sub    %edi,%ebx
  801e6d:	89 f9                	mov    %edi,%ecx
  801e6f:	d3 e6                	shl    %cl,%esi
  801e71:	89 c5                	mov    %eax,%ebp
  801e73:	88 d9                	mov    %bl,%cl
  801e75:	d3 ed                	shr    %cl,%ebp
  801e77:	89 e9                	mov    %ebp,%ecx
  801e79:	09 f1                	or     %esi,%ecx
  801e7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e7f:	89 f9                	mov    %edi,%ecx
  801e81:	d3 e0                	shl    %cl,%eax
  801e83:	89 c5                	mov    %eax,%ebp
  801e85:	89 d6                	mov    %edx,%esi
  801e87:	88 d9                	mov    %bl,%cl
  801e89:	d3 ee                	shr    %cl,%esi
  801e8b:	89 f9                	mov    %edi,%ecx
  801e8d:	d3 e2                	shl    %cl,%edx
  801e8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e93:	88 d9                	mov    %bl,%cl
  801e95:	d3 e8                	shr    %cl,%eax
  801e97:	09 c2                	or     %eax,%edx
  801e99:	89 d0                	mov    %edx,%eax
  801e9b:	89 f2                	mov    %esi,%edx
  801e9d:	f7 74 24 0c          	divl   0xc(%esp)
  801ea1:	89 d6                	mov    %edx,%esi
  801ea3:	89 c3                	mov    %eax,%ebx
  801ea5:	f7 e5                	mul    %ebp
  801ea7:	39 d6                	cmp    %edx,%esi
  801ea9:	72 19                	jb     801ec4 <__udivdi3+0xfc>
  801eab:	74 0b                	je     801eb8 <__udivdi3+0xf0>
  801ead:	89 d8                	mov    %ebx,%eax
  801eaf:	31 ff                	xor    %edi,%edi
  801eb1:	e9 58 ff ff ff       	jmp    801e0e <__udivdi3+0x46>
  801eb6:	66 90                	xchg   %ax,%ax
  801eb8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ebc:	89 f9                	mov    %edi,%ecx
  801ebe:	d3 e2                	shl    %cl,%edx
  801ec0:	39 c2                	cmp    %eax,%edx
  801ec2:	73 e9                	jae    801ead <__udivdi3+0xe5>
  801ec4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ec7:	31 ff                	xor    %edi,%edi
  801ec9:	e9 40 ff ff ff       	jmp    801e0e <__udivdi3+0x46>
  801ece:	66 90                	xchg   %ax,%ax
  801ed0:	31 c0                	xor    %eax,%eax
  801ed2:	e9 37 ff ff ff       	jmp    801e0e <__udivdi3+0x46>
  801ed7:	90                   	nop

00801ed8 <__umoddi3>:
  801ed8:	55                   	push   %ebp
  801ed9:	57                   	push   %edi
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
  801edc:	83 ec 1c             	sub    $0x1c,%esp
  801edf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ee3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ee7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801eef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ef3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ef7:	89 f3                	mov    %esi,%ebx
  801ef9:	89 fa                	mov    %edi,%edx
  801efb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eff:	89 34 24             	mov    %esi,(%esp)
  801f02:	85 c0                	test   %eax,%eax
  801f04:	75 1a                	jne    801f20 <__umoddi3+0x48>
  801f06:	39 f7                	cmp    %esi,%edi
  801f08:	0f 86 a2 00 00 00    	jbe    801fb0 <__umoddi3+0xd8>
  801f0e:	89 c8                	mov    %ecx,%eax
  801f10:	89 f2                	mov    %esi,%edx
  801f12:	f7 f7                	div    %edi
  801f14:	89 d0                	mov    %edx,%eax
  801f16:	31 d2                	xor    %edx,%edx
  801f18:	83 c4 1c             	add    $0x1c,%esp
  801f1b:	5b                   	pop    %ebx
  801f1c:	5e                   	pop    %esi
  801f1d:	5f                   	pop    %edi
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    
  801f20:	39 f0                	cmp    %esi,%eax
  801f22:	0f 87 ac 00 00 00    	ja     801fd4 <__umoddi3+0xfc>
  801f28:	0f bd e8             	bsr    %eax,%ebp
  801f2b:	83 f5 1f             	xor    $0x1f,%ebp
  801f2e:	0f 84 ac 00 00 00    	je     801fe0 <__umoddi3+0x108>
  801f34:	bf 20 00 00 00       	mov    $0x20,%edi
  801f39:	29 ef                	sub    %ebp,%edi
  801f3b:	89 fe                	mov    %edi,%esi
  801f3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f41:	89 e9                	mov    %ebp,%ecx
  801f43:	d3 e0                	shl    %cl,%eax
  801f45:	89 d7                	mov    %edx,%edi
  801f47:	89 f1                	mov    %esi,%ecx
  801f49:	d3 ef                	shr    %cl,%edi
  801f4b:	09 c7                	or     %eax,%edi
  801f4d:	89 e9                	mov    %ebp,%ecx
  801f4f:	d3 e2                	shl    %cl,%edx
  801f51:	89 14 24             	mov    %edx,(%esp)
  801f54:	89 d8                	mov    %ebx,%eax
  801f56:	d3 e0                	shl    %cl,%eax
  801f58:	89 c2                	mov    %eax,%edx
  801f5a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f5e:	d3 e0                	shl    %cl,%eax
  801f60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f64:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f68:	89 f1                	mov    %esi,%ecx
  801f6a:	d3 e8                	shr    %cl,%eax
  801f6c:	09 d0                	or     %edx,%eax
  801f6e:	d3 eb                	shr    %cl,%ebx
  801f70:	89 da                	mov    %ebx,%edx
  801f72:	f7 f7                	div    %edi
  801f74:	89 d3                	mov    %edx,%ebx
  801f76:	f7 24 24             	mull   (%esp)
  801f79:	89 c6                	mov    %eax,%esi
  801f7b:	89 d1                	mov    %edx,%ecx
  801f7d:	39 d3                	cmp    %edx,%ebx
  801f7f:	0f 82 87 00 00 00    	jb     80200c <__umoddi3+0x134>
  801f85:	0f 84 91 00 00 00    	je     80201c <__umoddi3+0x144>
  801f8b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f8f:	29 f2                	sub    %esi,%edx
  801f91:	19 cb                	sbb    %ecx,%ebx
  801f93:	89 d8                	mov    %ebx,%eax
  801f95:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f99:	d3 e0                	shl    %cl,%eax
  801f9b:	89 e9                	mov    %ebp,%ecx
  801f9d:	d3 ea                	shr    %cl,%edx
  801f9f:	09 d0                	or     %edx,%eax
  801fa1:	89 e9                	mov    %ebp,%ecx
  801fa3:	d3 eb                	shr    %cl,%ebx
  801fa5:	89 da                	mov    %ebx,%edx
  801fa7:	83 c4 1c             	add    $0x1c,%esp
  801faa:	5b                   	pop    %ebx
  801fab:	5e                   	pop    %esi
  801fac:	5f                   	pop    %edi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    
  801faf:	90                   	nop
  801fb0:	89 fd                	mov    %edi,%ebp
  801fb2:	85 ff                	test   %edi,%edi
  801fb4:	75 0b                	jne    801fc1 <__umoddi3+0xe9>
  801fb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbb:	31 d2                	xor    %edx,%edx
  801fbd:	f7 f7                	div    %edi
  801fbf:	89 c5                	mov    %eax,%ebp
  801fc1:	89 f0                	mov    %esi,%eax
  801fc3:	31 d2                	xor    %edx,%edx
  801fc5:	f7 f5                	div    %ebp
  801fc7:	89 c8                	mov    %ecx,%eax
  801fc9:	f7 f5                	div    %ebp
  801fcb:	89 d0                	mov    %edx,%eax
  801fcd:	e9 44 ff ff ff       	jmp    801f16 <__umoddi3+0x3e>
  801fd2:	66 90                	xchg   %ax,%ax
  801fd4:	89 c8                	mov    %ecx,%eax
  801fd6:	89 f2                	mov    %esi,%edx
  801fd8:	83 c4 1c             	add    $0x1c,%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    
  801fe0:	3b 04 24             	cmp    (%esp),%eax
  801fe3:	72 06                	jb     801feb <__umoddi3+0x113>
  801fe5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fe9:	77 0f                	ja     801ffa <__umoddi3+0x122>
  801feb:	89 f2                	mov    %esi,%edx
  801fed:	29 f9                	sub    %edi,%ecx
  801fef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ff3:	89 14 24             	mov    %edx,(%esp)
  801ff6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ffa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ffe:	8b 14 24             	mov    (%esp),%edx
  802001:	83 c4 1c             	add    $0x1c,%esp
  802004:	5b                   	pop    %ebx
  802005:	5e                   	pop    %esi
  802006:	5f                   	pop    %edi
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    
  802009:	8d 76 00             	lea    0x0(%esi),%esi
  80200c:	2b 04 24             	sub    (%esp),%eax
  80200f:	19 fa                	sbb    %edi,%edx
  802011:	89 d1                	mov    %edx,%ecx
  802013:	89 c6                	mov    %eax,%esi
  802015:	e9 71 ff ff ff       	jmp    801f8b <__umoddi3+0xb3>
  80201a:	66 90                	xchg   %ax,%ax
  80201c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802020:	72 ea                	jb     80200c <__umoddi3+0x134>
  802022:	89 d9                	mov    %ebx,%ecx
  802024:	e9 62 ff ff ff       	jmp    801f8b <__umoddi3+0xb3>
